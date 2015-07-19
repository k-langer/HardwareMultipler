CC=iverilog
TARGET= mult.sim
OBJS = hdw_mult.v 

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS)
run: 
	./mult.sim
clean:  
	rm -f *.sim 

