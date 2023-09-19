 class f_scoreboard extends uvm_scoreboard;
uvm_analysis_imp#(f_sequence_item, f_scoreboard) 
  item_got_export;
`uvm_component_utils(f_scoreboard)
function new(string name = "f_scoreboard", uvm_component parent);
 super.new(name, parent);
    item_got_export = new("item_got_export", this);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  bit [127:0] queue[$];

  int count;
  bit check_full;  
  bit check_empty;
  bit check_alm_full;
  bit check_alm_empty;
  int depth=256;

function void write(input f_sequence_item item_got);   
bit [127:0] examdata;
if(item_got.i_wren == 'b1)
begin
queue.push_back(item_got.i_wrdata);
  $display("%0d",count);
count++;
  if(count<=2 && count>0)   
begin
check_alm_empty=1;           
end
if(count==depth) 
begin
check_full=1; 
end

  if(count>=1020 && count<=1023) 
begin
check_alm_full=1; 
end
else
begin
check_alm_full=0;
end
if((check_full && item_got.o_full)==1)
begin
$display("full flag is matched");
end
if((check_alm_full && item_got.o_alm_full)==1)
begin
$display("almost full flag is matched");
end
if((check_alm_empty && item_got.o_alm_empty)==1)
begin
$display("almost empty flag is matched");
end
`uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0d full: %0b o_alm_full: %0b o_alm_empty:%d",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_full,item_got.o_alm_empty), UVM_LOW);
end

else if (item_got.i_rden == 'b1)
begin
if(queue.size() >= 'd1)
begin
examdata = queue.pop_front();
count--;
  $display("%0d",count);
if(count==0)  
 begin
check_empty=1; 
end
if(count<=2 && count>0)   
begin
check_alm_empty=1; 
end

if((check_empty && item_got.o_empty)==1)
begin
$display("empty flag is matched");
end

if((check_alm_empty && item_got.o_alm_empty)==1)
begin
$display("almost empty flag is matched");
end

        `uvm_info("Read Data", $sformatf("examdata: %0d data_out: %0d empty: %0b o_alm_empty: %0b", examdata, item_got.o_rddata, item_got.o_empty, item_got.o_alm_empty), UVM_LOW);
  
if(examdata == item_got.o_rddata)begin
$display("-------- 		MATCH 		--------");
end
else begin
$display("--------		MISS MATCH		--------");
end
end
end
endfunction

endclass