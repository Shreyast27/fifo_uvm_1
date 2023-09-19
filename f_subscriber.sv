// class my_subscriber extends uvm_subscriber #(f_sequence_item);
//   f_sequence_item req;
//   `uvm_component_utils(my_subscriber)

//   covergroup cover_bus;
//     wr: coverpoint req.i_wren {
//       bins i_wren_bin = {0, 1};
//     }
//     rd: coverpoint req.i_rden {
//       bins i_rden_bin = {0, 1};
//     }
//     F: coverpoint req.o_full {
//       bins o_full_bin = {0, 1};
//     }
//     E: coverpoint req.o_empty {
//       bins o_empty_bin = {0, 1};
//     }
//     AE: coverpoint req.o_alm_empty {
//       bins o_alm_empty_bin = {0, 1};
//     }
//     AF: coverpoint req.o_alm_full {
//       bins o_alm_full_bin = {0, 1};
//     }
//   endgroup: cover_bus

//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//     cover_bus = new;
//   endfunction: new

//   function void write(f_sequence_item req);
//     `uvm_info("mg", $psprintf("Subscriber received tx %s", req.convert2string()), UVM_NONE);
    
//     // Assign coverpoint values
//     cover_bus.i_wren = req.i_wren;
//     cover_bus.i_rden = req.i_rden;
//     cover_bus.o_full = req.o_full;
//     cover_bus.o_alm_full = req.o_alm_full;
//     cover_bus.o_empty = req.o_empty;
//     cover_bus.o_alm_empty = req.o_alm_empty;
    
//     // Sample the coverage
//     cover_bus.sample();
    
//     `uvm_info(get_type_name(), $psprintf("Coverage is %% = %.2f %%", cover_bus.get_coverage()), UVM_NONE);
//   endfunction: write
// endclass: my_subscriber



//////////////////////*******************//////////////////////////////

class f_subscriber extends uvm_subscriber #(f_sequence_item);

  `uvm_component_utils(f_sequence_item)

  function new(string name="",uvm_component parent);
    super.new(name,parent);
    dut_cov=new();
  endfunction

  f_sequence_item req;
  real cov;

  covergroup dut_cov;
    option.per_instance= 1;
    option.comment     = "dut_cov";
    option.name        = "dut_cov";
//     option.auto_bin_max= 2;
    
   wr: coverpoint req.i_wren {
      bins i_wren_bin = {0, 1};
    }
    rd: coverpoint req.i_rden {
      bins i_rden_bin = {0, 1};
    }
    F: coverpoint req.o_full {
      bins o_full_bin = {0, 1};
    }
    E: coverpoint req.o_empty {
      bins o_empty_bin = {0, 1};
    }
    AE: coverpoint req.o_alm_empty {
      bins o_alm_empty_bin = {0, 1};
    }
    AF: coverpoint req.o_alm_full {
      bins o_alm_full_bin = {0, 1};
    }
  endgroup:dut_cov;

  //---------------------  write method ----------------------------------------
  function void write(f_sequence_item t);
    req=t;
    dut_cov.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=dut_cov.get_coverage();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %.2f%%",cov),UVM_NONE)
  endfunction
  
endclass:f_subscriber