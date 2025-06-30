# PmodDA3
A verilog module for interfacing to a Digilent PmodDA3 Digital-to-Analog Converter

Two versions are provided with a positive and a negative reset, respectively.

Both versions require a 50 MHz input clock, and will convert a 16 bit parallel data input into 1-bit data output (sclk, din, nLDAC, nCS) required to drive the Pmod.
