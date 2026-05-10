export TMP := $(CURDIR)/tmp
OUT1?=./Preprocess
OUT2?=./Compile
OUT3?=./Assembly
OUT?=./builds
TARGET?=main


all: build $(OUT) 
	@g++  $(OUT3)/*.o -o $(OUT)/$(TARGET).exe
	

build: $(OUT1) $(OUT2) $(OUT3) $(OUT)
	@find ./srcs -name "*.c" -exec sh -c 'g++ -I./include -E "$$1" -o $(OUT1)/$$(basename "$$1" .c).i' _ {} \;
	@find $(OUT1) -name "*.i" -exec sh -c 'g++ -I./include -S "$$1" -o $(OUT2)/$$(basename "$$1" .i).s' _ {} \;
	@find $(OUT2) -name "*.s" -exec sh -c 'g++ -I./include -c "$$1" -o $(OUT3)/$$(basename "$$1" .s).o' _ {} \;

$(OUT1):
	@mkdir -p $(OUT1)

$(OUT2):
	@mkdir -p $(OUT2)

$(OUT3):
	@mkdir -p $(OUT3)

$(OUT):
	@mkdir -p $(OUT)
	@mkdir -p ./tmp

run: 
	@$(OUT)/$(TARGET).exe

clean:
	@rm -rf $(OUT1) $(OUT2) $(OUT3) $(OUT)

.PHONY: all build run clean 