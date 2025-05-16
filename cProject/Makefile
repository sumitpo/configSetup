CC := gcc
CFLAGS := -g -fno-omit-frame-pointer -O3 -Wall -Wextra -pthread
TARGET := demo
DEBUG_INFO := $(TARGET).debug
RELEASE := $(TARGET).release

.PHONY: all run debug clean

all: $(TARGET) $(DEBUG_INFO) $(RELEASE)

# 主二进制（剥离调试符号）
$(TARGET): main.c
	$(CC) $(CFLAGS) $< -o $@
	@echo -e "\n[1/3] finish compiling"

# 分离调试信息
$(DEBUG_INFO): $(TARGET)
	@echo "[2/3] extract debug info to standalone file ..."
	objcopy --only-keep-debug $< $@
	objcopy --add-gnu-debuglink=$@ $<
	@echo -e "\ndebug file: $(DEBUG_INFO)"
	@echo "executable file: $(TARGET)"

$(RELEASE): $(TARGET)
	cp $< $@
	@echo -e "\n[3/3] stripping debug symbol..."
	strip --strip-debug --strip-unneeded $@

# 运行并自动生成核心转储
run: $(TARGET)
	@echo -e "\nrunning program which will crash and generate coredump ..."
	ulimit -c unlimited && ./$(TARGET) || true
	@echo -e "\ncordump file:" $$(ls core.* 2>/dev/null || echo "None")

# 调试模式（保留完整符号）
debug: CFLAGS += -O0 -ggdb3
debug: $(TARGET)
	@echo -e "\ndebug version is compiled (not optimized and full debug symobol"

clean:
	rm -f $(TARGET) $(DEBUG_INFO) $(RELEASE) core.* *.o
