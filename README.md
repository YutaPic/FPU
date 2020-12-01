# Performance (KCU105)
- fadd (fadd.v) 100MHz 1clock
- fsub (fsub.v) 100MHz 1clock
- fmul: 100MHz 1clock (Maximum operating frequency = 160MHz)
- fdiv (fdiv.v): 100MHz 3clock
- fsqrt: 100MHz 2clock (Pipeline) (Maximum operating frequency = 160MHz)
- itof: 100MHz 1clock (Maximum operating frequency = 150MHz)
- ftoi: 100MHz 1clock 
- floor: 100MHz 1clock
- fless: 100MHz 1clock


# Utilization (KCU105)
- fadd (fadd.v) LUT 303, FF 96
- fsub (fsub.v) LUT 577, FF 96
- fmul: LUT 53, FF 96, DSP 2
- fdiv (fdiv.v): LUT 103, FF 167, DSP 3
- itof: LUT 246, FF 64
- ftoi: LUT 264, FF 64
- floor LUT 210, FF 64

# Dependency
- fdiv (fdiv.v)
  - fmul_for_fdiv (fmul_for_fdiv.v)
  - finv (finv.v)
    - finv_const_table (finv_table.v)
    - finv_grad_table (finv_table.v)
- fsqrt (fsqrt.v)
  - fsqrt_const_table (fsqrt_table.v)
  - fsqrt_grad_table (fsqrt_table.v)
    
# Notes
- fmul, fdiv and fsqrt only support normalized numbers.
  - if the exponent is 0, then the mantissa is set to 0 and the number is regarded as 0.
  - if the exponent is 255, then the mantissa is set to 0 and the number is regarded as infinity.
- fsqrt
  - If you enter negative number in fsqrt, 0 will be returned.
- ftoi
  - If you enter more than 2^31, 0x7fffffff will be returned.
  - If you enter less than -2^31, 0x80000001 will be returned.
