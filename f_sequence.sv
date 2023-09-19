class f_sequence extends uvm_sequence#(f_sequence_item);
  `uvm_object_utils(f_sequence)

  function new(string name = "f_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("******** GENERATE 256 CONTINOUS WRITE ********"), UVM_LOW)
    repeat(1024) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_wren == 1 && i_rden==0;});
      finish_item(req);
    end

    `uvm_info(get_type_name(), $sformatf("******** GENERATE 256 CONTINOUS READ ********"), UVM_LOW)
    repeat(1024) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_wren == 0 && i_rden == 1;});
      finish_item(req);
    end

    `uvm_info(get_type_name(), $sformatf("******** GENERATE 10 ALTERNATE WRITE AND READ ********"), UVM_LOW)
    repeat(10) begin
      //write
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_wren == 1 && i_rden==0;});
      finish_item(req);
      //read
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_wren == 0 && i_rden==1;});
      finish_item(req);
    end

    `uvm_info(get_type_name(), $sformatf("******** GENERATE 10 RANDOM REQUESTS ********"), UVM_LOW)
    repeat(10) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask

endclass