TARGET = aarch64
BUILD_DIR = build/$(TARGET)

.PHONY: build all

all: build

build: $(BUILD_DIR)/libkrng.so

# The final shared library depends on all object files
$(BUILD_DIR)/libkrng.so: $(BUILD_DIR)/rng.o $(BUILD_DIR)/krng.o
	@mkdir -p $(BUILD_DIR)
	g++ -shared $^ -o $@

# Assembly object file compilation
$(BUILD_DIR)/rng.o: src/$(TARGET)/rng.s
	@mkdir -p $(BUILD_DIR)
	g++ -c -fPIC $< -o $@

# C++ object file compilation
$(BUILD_DIR)/krng.o: src/krng.cpp includes/krng.h
	g++ -c -fPIC $< -Iincludes -o $@