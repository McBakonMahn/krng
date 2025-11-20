#pragma once

#include <cstdint> 

namespace KRng {
    void set_seed(unsigned int seed);
    
    unsigned int rand();

    int RandInt(int min, int max);
}