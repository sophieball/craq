TAME=/usr/local/lib/sfslite/tame
RPCC=/usr/local/lib/sfslite/rpcc
CC=g++
CFLAGS= -g -static -O2 -Wall -Werror -Wno-unused -Wno-sign-compare

INCLUDE= -I/usr/local/include/sfslite \
			-I/usr/include/crypto++ \
			-I/usr/local/include/c-client-src \
			-I./

SFS_LIB_DIR=/usr/local/lib/sfslite

LIBS= $(SFS_LIB_DIR)/libtame.a \
		$(SFS_LIB_DIR)/libsfscrypt.a \
		$(SFS_LIB_DIR)/libarpc.a \
		$(SFS_LIB_DIR)/libasync.a \
		-lresolv \
		-lpth \
		-ldl \
		-lcrypto++ \
		-lzookeeper_st \
		-lpthread
		
OBJS=craq_rpc.o \
		ID_Value.o \
		Node.o \
		MemStorage.o \
		connection_pool.o \
		zoo_craq.o

all: manager \
	chain_node \
	test/manager_test \
	test/single_write_read \
	test/multi_read_write \
	test/writer \
	test/reader \
	test/single_reader


craq_rpc.o: craq_rpc.x
	$(RPCC) -h -o craq_rpc.h craq_rpc.x
	$(RPCC) -c -o craq_rpc.c craq_rpc.x
	$(CC) $(INCLUDE) $(CFLAGS) -c craq_rpc.c
	
connection_pool.o: connection_pool.h connection_pool.T craq_rpc.o
	$(TAME) -o connection_pool.C connection_pool.T
	$(TAME) -o connection_pool.H connection_pool.h
	$(CC) $(INCLUDE) $(CFLAGS) -c connection_pool.C
ID_Value.o: ID_Value.h ID_Value.cpp craq_rpc.o
	$(CC) $(INCLUDE) $(CFLAGS) -c ID_Value.cpp
Node.o: Node.h Node.cpp ID_Value.o craq_rpc.o
	$(TAME) -o Node.C Node.cpp
	$(CC) $(INCLUDE) $(CFLAGS) -c Node.C
MemStorage.o: MemStorage.h MemStorage.cpp Storage.h
	$(TAME) -o MemStorage.C MemStorage.cpp
	$(CC) $(INCLUDE) $(CFLAGS) -c MemStorage.C
zoo_craq.o: zoo_craq.h zoo_craq.T
	$(TAME) -o zoo_craq.C zoo_craq.T
	$(TAME) -o zoo_craq.H zoo_craq.h
	$(CC) $(INCLUDE) $(CFLAGS) -c zoo_craq.C

manager: manager.T $(OBJS)
	$(TAME) -o manager.C manager.T
	$(CC) $(INCLUDE) $(CFLAGS) -c manager.C
	$(CC) $(CFLAGS) -o manager manager.o $(OBJS) $(LIBS)
	
chain_node: chain_node.T $(OBJS)
	$(TAME) -o chain_node.C chain_node.T
	$(CC) $(INCLUDE) $(CFLAGS) -c chain_node.C
	$(CC) $(CFLAGS) -o chain_node chain_node.o $(OBJS) $(LIBS)
	
test/manager_test: test/manager_test.T $(OBJS)
	$(TAME) -o test/manager_test.C test/manager_test.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/manager_test.o -c test/manager_test.C
	$(CC) $(CFLAGS) -o test/manager_test test/manager_test.o $(OBJS) $(LIBS)
	
test/single_write_read: test/single_write_read.T $(OBJS)
	$(TAME) -o test/single_write_read.C test/single_write_read.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/single_write_read.o -c test/single_write_read.C
	$(CC) $(CFLAGS) -o test/single_write_read test/single_write_read.o $(OBJS) $(LIBS)
	
test/multi_read_write: test/multi_read_write.T $(OBJS)
	$(TAME) -o test/multi_read_write.C test/multi_read_write.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/multi_read_write.o -c test/multi_read_write.C
	$(CC) $(CFLAGS) -o test/multi_read_write test/multi_read_write.o $(OBJS) $(LIBS)
	
test/writer: test/writer.T $(OBJS)
	$(TAME) -o test/writer.C test/writer.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/writer.o -c test/writer.C
	$(CC) $(CFLAGS) -o test/writer test/writer.o $(OBJS) $(LIBS)
	
test/reader: test/reader.T $(OBJS)
	$(TAME) -o test/reader.C test/reader.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/reader.o -c test/reader.C
	$(CC) $(CFLAGS) -o test/reader test/reader.o $(OBJS) $(LIBS)
	
test/single_reader: test/single_reader.T $(OBJS)
	$(TAME) -o test/single_reader.C test/single_reader.T
	$(CC) $(INCLUDE) $(CFLAGS) -o test/single_reader.o -c test/single_reader.C
	$(CC) $(CFLAGS) -o test/single_reader test/single_reader.o $(OBJS) $(LIBS)
	
clean:
	rm -f chain_node chain_node.C\
		manager manager.C \
		craq_rpc.h craq_rpc.c \
		Node.C MemStorage.C connection_pool.C connection_pool.H \
		zoo_craq.C zoo_craq.H \
		test/manager_test.C test/manager_test \
		test/single_write_read.C test/single_write_read \
		test/multi_read_write.C test/multi_read_write \
		test/writer.C test/writer \
		test/reader.C test/reader \
		test/single_reader.C test/single_reader \
		*.o test/*.o