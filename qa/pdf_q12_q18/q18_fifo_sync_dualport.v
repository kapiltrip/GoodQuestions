module dual_port_ram #(
    parameter integer DATA_W = 8,
    parameter integer ADDR_W = 8
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  write,
    input  wire [ADDR_W-1:0]     write_address,
    input  wire [DATA_W-1:0]     write_data,
    input  wire [ADDR_W-1:0]     read_address,
    output reg  [DATA_W-1:0]     read_data
);
    reg [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {DATA_W{1'b0}};
        end else begin
            if (write)
                mem[write_address] <= write_data;
            read_data <= mem[read_address];
        end
    end
endmodule

module fifo_sync_dualport #(
    parameter integer DATA_W = 8,
    parameter integer ADDR_W = 8
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  push,
    input  wire                  pop,
    input  wire [DATA_W-1:0]     data_in,
    output wire [DATA_W-1:0]     data_out,
    output wire                  fifo_full,
    output wire                  fifo_empty
);
    localparam integer DEPTH = (1 << ADDR_W);

    reg [ADDR_W-1:0] write_address;
    reg [ADDR_W-1:0] read_address;
    reg [ADDR_W:0]   fifo_count;

    wire pop_ok;
    wire push_ok;

    assign fifo_empty = (fifo_count == 0);
    assign fifo_full  = (fifo_count == DEPTH);

    assign pop_ok  = pop  && !fifo_empty;
    assign push_ok = push && (!fifo_full || pop_ok);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            write_address <= {ADDR_W{1'b0}};
        else if (push_ok)
            write_address <= write_address + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            read_address <= {ADDR_W{1'b0}};
        else if (pop_ok)
            read_address <= read_address + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_count <= {(ADDR_W+1){1'b0}};
        end else begin
            case ({push_ok, pop_ok})
                2'b10: fifo_count <= fifo_count + 1'b1;
                2'b01: fifo_count <= fifo_count - 1'b1;
                default: fifo_count <= fifo_count;
            endcase
        end
    end

    dual_port_ram #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_ram (
        .clk(clk),
        .rst_n(rst_n),
        .write(push_ok),
        .write_address(write_address),
        .write_data(data_in),
        .read_address(read_address),
        .read_data(data_out)
    );
endmodule
