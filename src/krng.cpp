#include "../includes/krng.h"
#include <cstdint>
#include <chrono> // For high-resolution time

extern "C" uint32_t get_random_u32();
extern "C" void set_seed_u32(uint32_t new_seed);
extern "C" int32_t get_range_s32(int32_t min, int32_t max);

static bool prng_initialized = false;

namespace KRng {
    void set_seed(unsigned int seed) {
        set_seed_u32(seed);
        prng_initialized = true;
    }

    static void auto_seed_if_needed() {
        if (!prng_initialized) {
            
            auto now = std::chrono::high_resolution_clock::now();
            auto duration = now.time_since_epoch();
            auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>(duration);

            
            uint32_t unique_seed = (uint32_t)nanoseconds.count();
            
            set_seed(unique_seed);
        }
    }

    unsigned int rand() {
        auto_seed_if_needed();
        return get_random_u32();
    }

    int RandInt(int min, int max) {
        auto_seed_if_needed();
        return get_range_s32(min, max);
    }
}