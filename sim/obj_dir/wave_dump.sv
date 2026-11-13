module wave_dump;
  string f;
  initial if ($value$plusargs("wave=%s", f)) begin $dumpfile(f); $dumpvars; end
endmodule
bind top wave_dump u_wave_dump();
