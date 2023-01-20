// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================
#include <stdio.h>
#include <stdlib.h>

#include <getopt.h>
#include <verilated.h>
#include <getopt.h>

#include "Vlarsen.h"

int main(int argc, char** argv) {
    const struct option long_options[] = {
      {"term-after_cycles", required_argument, nullptr, 'c'},
      {nullptr},
    };
    unsigned long term_after_cycles = 0;
    unsigned long cycles;

    for(;;) {
      int c = getopt_long(argc, argv, "-:c:", long_options, nullptr);
      if (c == -1) {
        break;
      }
      switch(c) {
        case 0:
        case 1:
          break;
        case 'c':
          term_after_cycles = strtoul(optarg, 0, 0);
          break;
        case ':':
          fprintf(stderr, "Error: missing argument\n");
          return 1;
        default:
          // Ignore unrecognized options as they might be consumed
          // by verilator below.
          ;
      }
    }
    // Construct a VerilatedContext to hold simulation time, etc.
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    Vlarsen* top = new Vlarsen{contextp};

    // Simulate until $finish
    while (!contextp->gotFinish()) {

        // Evaluate model
        top->eval();

        if (contextp->time() % (4<<19) == 0) {
        printf("[%10d] %c%c%c%c%c%c%c%c\n",
               contextp->time(),
               top->led1 ? '*' : ' ',
               top->led2 ? '*' : ' ',
               top->led3 ? '*' : ' ',
               top->led4 ? '*' : ' ',
               top->led5 ? '*' : ' ',
               top->led6 ? '*' : ' ',
               top->led7 ? '*' : ' ',
               top->led8 ? '*' : ' '
        );
        }
        if (term_after_cycles && contextp->time() > term_after_cycles) {
            break;
        }
        contextp->timeInc(1);
        top->hwclk = !top->hwclk;
    }

    // Final model cleanup
    top->final();

    // Destroy model
    delete top;

    // Return good completion status
    return 0;
}
