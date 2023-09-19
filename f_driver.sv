class f_driver extends uvm_driver#(f_sequence_item);
  virtual f_interface vif;
  f_sequence_item req;
  `uvm_component_utils(f_driver)
  
  function new(string name = "f_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual f_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "uvm_config_db ::get failed ")
  endfunction

  virtual task run_phase(uvm_phase phase);
    if(vif.rstn==0)
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_wren <= 'b0;
    vif.d_mp.d_cb.i_rden <= 'b0;
    vif.d_mp.d_cb.i_wrdata <= 'b0;
    forever begin
      seq_item_port.get_next_item(req);
      if(req.i_wren == 1)
        main_write(req.i_wrdata);
      else if(req.i_rden == 1)
        main_read();
      seq_item_port.item_done();
    end
  endtask
  
    virtual task main_write(input [127:0] data_in);
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_wren <= 'b1;
    vif.d_mp.d_cb.i_wrdata <= data_in;
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_wren <= 'b0;
  endtask
  
  virtual task main_read();
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_rden <= 'b1;
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_rden <= 'b0;
  endtask

endclass