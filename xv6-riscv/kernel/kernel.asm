
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	8d013103          	ld	sp,-1840(sp) # 800078d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddb9f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	da678793          	addi	a5,a5,-602 # 80000e26 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05263          	blez	a2,80000126 <consolewrite+0x56>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	0b4020ef          	jal	ra,800021ae <either_copyin>
    800000fe:	01550a63          	beq	a0,s5,80000112 <consolewrite+0x42>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7e8000ef          	jal	ra,800008ee <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
  }

  return i;
}
    80000112:	854a                	mv	a0,s2
    80000114:	60a6                	ld	ra,72(sp)
    80000116:	6406                	ld	s0,64(sp)
    80000118:	74e2                	ld	s1,56(sp)
    8000011a:	7942                	ld	s2,48(sp)
    8000011c:	79a2                	ld	s3,40(sp)
    8000011e:	7a02                	ld	s4,32(sp)
    80000120:	6ae2                	ld	s5,24(sp)
    80000122:	6161                	addi	sp,sp,80
    80000124:	8082                	ret
  for(i = 0; i < n; i++){
    80000126:	4901                	li	s2,0
    80000128:	b7ed                	j	80000112 <consolewrite+0x42>

000000008000012a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012a:	7119                	addi	sp,sp,-128
    8000012c:	fc86                	sd	ra,120(sp)
    8000012e:	f8a2                	sd	s0,112(sp)
    80000130:	f4a6                	sd	s1,104(sp)
    80000132:	f0ca                	sd	s2,96(sp)
    80000134:	ecce                	sd	s3,88(sp)
    80000136:	e8d2                	sd	s4,80(sp)
    80000138:	e4d6                	sd	s5,72(sp)
    8000013a:	e0da                	sd	s6,64(sp)
    8000013c:	fc5e                	sd	s7,56(sp)
    8000013e:	f862                	sd	s8,48(sp)
    80000140:	f466                	sd	s9,40(sp)
    80000142:	f06a                	sd	s10,32(sp)
    80000144:	ec6e                	sd	s11,24(sp)
    80000146:	0100                	addi	s0,sp,128
    80000148:	8b2a                	mv	s6,a0
    8000014a:	8aae                	mv	s5,a1
    8000014c:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000014e:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000152:	0000f517          	auipc	a0,0xf
    80000156:	7de50513          	addi	a0,a0,2014 # 8000f930 <cons>
    8000015a:	24f000ef          	jal	ra,80000ba8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000015e:	0000f497          	auipc	s1,0xf
    80000162:	7d248493          	addi	s1,s1,2002 # 8000f930 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000166:	89a6                	mv	s3,s1
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	86090913          	addi	s2,s2,-1952 # 8000f9c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80000170:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000172:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000174:	4da9                	li	s11,10
  while(n > 0){
    80000176:	07405363          	blez	s4,800001dc <consoleread+0xb2>
    while(cons.r == cons.w){
    8000017a:	0984a783          	lw	a5,152(s1)
    8000017e:	09c4a703          	lw	a4,156(s1)
    80000182:	02f71163          	bne	a4,a5,800001a4 <consoleread+0x7a>
      if(killed(myproc())){
    80000186:	6ba010ef          	jal	ra,80001840 <myproc>
    8000018a:	6b7010ef          	jal	ra,80002040 <killed>
    8000018e:	e125                	bnez	a0,800001ee <consoleread+0xc4>
      sleep(&cons.r, &cons.lock);
    80000190:	85ce                	mv	a1,s3
    80000192:	854a                	mv	a0,s2
    80000194:	475010ef          	jal	ra,80001e08 <sleep>
    while(cons.r == cons.w){
    80000198:	0984a783          	lw	a5,152(s1)
    8000019c:	09c4a703          	lw	a4,156(s1)
    800001a0:	fef703e3          	beq	a4,a5,80000186 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a4:	0017871b          	addiw	a4,a5,1
    800001a8:	08e4ac23          	sw	a4,152(s1)
    800001ac:	07f7f713          	andi	a4,a5,127
    800001b0:	9726                	add	a4,a4,s1
    800001b2:	01874703          	lbu	a4,24(a4)
    800001b6:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800001ba:	079c0063          	beq	s8,s9,8000021a <consoleread+0xf0>
    cbuf = c;
    800001be:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c2:	4685                	li	a3,1
    800001c4:	f8f40613          	addi	a2,s0,-113
    800001c8:	85d6                	mv	a1,s5
    800001ca:	855a                	mv	a0,s6
    800001cc:	799010ef          	jal	ra,80002164 <either_copyout>
    800001d0:	01a50663          	beq	a0,s10,800001dc <consoleread+0xb2>
    dst++;
    800001d4:	0a85                	addi	s5,s5,1
    --n;
    800001d6:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800001d8:	f9bc1fe3          	bne	s8,s11,80000176 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001dc:	0000f517          	auipc	a0,0xf
    800001e0:	75450513          	addi	a0,a0,1876 # 8000f930 <cons>
    800001e4:	25d000ef          	jal	ra,80000c40 <release>

  return target - n;
    800001e8:	414b853b          	subw	a0,s7,s4
    800001ec:	a801                	j	800001fc <consoleread+0xd2>
        release(&cons.lock);
    800001ee:	0000f517          	auipc	a0,0xf
    800001f2:	74250513          	addi	a0,a0,1858 # 8000f930 <cons>
    800001f6:	24b000ef          	jal	ra,80000c40 <release>
        return -1;
    800001fa:	557d                	li	a0,-1
}
    800001fc:	70e6                	ld	ra,120(sp)
    800001fe:	7446                	ld	s0,112(sp)
    80000200:	74a6                	ld	s1,104(sp)
    80000202:	7906                	ld	s2,96(sp)
    80000204:	69e6                	ld	s3,88(sp)
    80000206:	6a46                	ld	s4,80(sp)
    80000208:	6aa6                	ld	s5,72(sp)
    8000020a:	6b06                	ld	s6,64(sp)
    8000020c:	7be2                	ld	s7,56(sp)
    8000020e:	7c42                	ld	s8,48(sp)
    80000210:	7ca2                	ld	s9,40(sp)
    80000212:	7d02                	ld	s10,32(sp)
    80000214:	6de2                	ld	s11,24(sp)
    80000216:	6109                	addi	sp,sp,128
    80000218:	8082                	ret
      if(n < target){
    8000021a:	000a071b          	sext.w	a4,s4
    8000021e:	fb777fe3          	bgeu	a4,s7,800001dc <consoleread+0xb2>
        cons.r--;
    80000222:	0000f717          	auipc	a4,0xf
    80000226:	7af72323          	sw	a5,1958(a4) # 8000f9c8 <cons+0x98>
    8000022a:	bf4d                	j	800001dc <consoleread+0xb2>

000000008000022c <consputc>:
{
    8000022c:	1141                	addi	sp,sp,-16
    8000022e:	e406                	sd	ra,8(sp)
    80000230:	e022                	sd	s0,0(sp)
    80000232:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000234:	10000793          	li	a5,256
    80000238:	00f50863          	beq	a0,a5,80000248 <consputc+0x1c>
    uartputc_sync(c);
    8000023c:	5d4000ef          	jal	ra,80000810 <uartputc_sync>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000248:	4521                	li	a0,8
    8000024a:	5c6000ef          	jal	ra,80000810 <uartputc_sync>
    8000024e:	02000513          	li	a0,32
    80000252:	5be000ef          	jal	ra,80000810 <uartputc_sync>
    80000256:	4521                	li	a0,8
    80000258:	5b8000ef          	jal	ra,80000810 <uartputc_sync>
    8000025c:	b7d5                	j	80000240 <consputc+0x14>

000000008000025e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000025e:	1101                	addi	sp,sp,-32
    80000260:	ec06                	sd	ra,24(sp)
    80000262:	e822                	sd	s0,16(sp)
    80000264:	e426                	sd	s1,8(sp)
    80000266:	e04a                	sd	s2,0(sp)
    80000268:	1000                	addi	s0,sp,32
    8000026a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000026c:	0000f517          	auipc	a0,0xf
    80000270:	6c450513          	addi	a0,a0,1732 # 8000f930 <cons>
    80000274:	135000ef          	jal	ra,80000ba8 <acquire>

  switch(c){
    80000278:	47d5                	li	a5,21
    8000027a:	0af48063          	beq	s1,a5,8000031a <consoleintr+0xbc>
    8000027e:	0297c663          	blt	a5,s1,800002aa <consoleintr+0x4c>
    80000282:	47a1                	li	a5,8
    80000284:	0cf48f63          	beq	s1,a5,80000362 <consoleintr+0x104>
    80000288:	47c1                	li	a5,16
    8000028a:	10f49063          	bne	s1,a5,8000038a <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    8000028e:	76b010ef          	jal	ra,800021f8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000292:	0000f517          	auipc	a0,0xf
    80000296:	69e50513          	addi	a0,a0,1694 # 8000f930 <cons>
    8000029a:	1a7000ef          	jal	ra,80000c40 <release>
}
    8000029e:	60e2                	ld	ra,24(sp)
    800002a0:	6442                	ld	s0,16(sp)
    800002a2:	64a2                	ld	s1,8(sp)
    800002a4:	6902                	ld	s2,0(sp)
    800002a6:	6105                	addi	sp,sp,32
    800002a8:	8082                	ret
  switch(c){
    800002aa:	07f00793          	li	a5,127
    800002ae:	0af48a63          	beq	s1,a5,80000362 <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002b2:	0000f717          	auipc	a4,0xf
    800002b6:	67e70713          	addi	a4,a4,1662 # 8000f930 <cons>
    800002ba:	0a072783          	lw	a5,160(a4)
    800002be:	09872703          	lw	a4,152(a4)
    800002c2:	9f99                	subw	a5,a5,a4
    800002c4:	07f00713          	li	a4,127
    800002c8:	fcf765e3          	bltu	a4,a5,80000292 <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002cc:	47b5                	li	a5,13
    800002ce:	0cf48163          	beq	s1,a5,80000390 <consoleintr+0x132>
      consputc(c);
    800002d2:	8526                	mv	a0,s1
    800002d4:	f59ff0ef          	jal	ra,8000022c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d8:	0000f797          	auipc	a5,0xf
    800002dc:	65878793          	addi	a5,a5,1624 # 8000f930 <cons>
    800002e0:	0a07a683          	lw	a3,160(a5)
    800002e4:	0016871b          	addiw	a4,a3,1
    800002e8:	0007061b          	sext.w	a2,a4
    800002ec:	0ae7a023          	sw	a4,160(a5)
    800002f0:	07f6f693          	andi	a3,a3,127
    800002f4:	97b6                	add	a5,a5,a3
    800002f6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002fa:	47a9                	li	a5,10
    800002fc:	0af48f63          	beq	s1,a5,800003ba <consoleintr+0x15c>
    80000300:	4791                	li	a5,4
    80000302:	0af48c63          	beq	s1,a5,800003ba <consoleintr+0x15c>
    80000306:	0000f797          	auipc	a5,0xf
    8000030a:	6c27a783          	lw	a5,1730(a5) # 8000f9c8 <cons+0x98>
    8000030e:	9f1d                	subw	a4,a4,a5
    80000310:	08000793          	li	a5,128
    80000314:	f6f71fe3          	bne	a4,a5,80000292 <consoleintr+0x34>
    80000318:	a04d                	j	800003ba <consoleintr+0x15c>
    while(cons.e != cons.w &&
    8000031a:	0000f717          	auipc	a4,0xf
    8000031e:	61670713          	addi	a4,a4,1558 # 8000f930 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000032a:	0000f497          	auipc	s1,0xf
    8000032e:	60648493          	addi	s1,s1,1542 # 8000f930 <cons>
    while(cons.e != cons.w &&
    80000332:	4929                	li	s2,10
    80000334:	f4f70fe3          	beq	a4,a5,80000292 <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000338:	37fd                	addiw	a5,a5,-1
    8000033a:	07f7f713          	andi	a4,a5,127
    8000033e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000340:	01874703          	lbu	a4,24(a4)
    80000344:	f52707e3          	beq	a4,s2,80000292 <consoleintr+0x34>
      cons.e--;
    80000348:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000034c:	10000513          	li	a0,256
    80000350:	eddff0ef          	jal	ra,8000022c <consputc>
    while(cons.e != cons.w &&
    80000354:	0a04a783          	lw	a5,160(s1)
    80000358:	09c4a703          	lw	a4,156(s1)
    8000035c:	fcf71ee3          	bne	a4,a5,80000338 <consoleintr+0xda>
    80000360:	bf0d                	j	80000292 <consoleintr+0x34>
    if(cons.e != cons.w){
    80000362:	0000f717          	auipc	a4,0xf
    80000366:	5ce70713          	addi	a4,a4,1486 # 8000f930 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
    80000372:	f2f700e3          	beq	a4,a5,80000292 <consoleintr+0x34>
      cons.e--;
    80000376:	37fd                	addiw	a5,a5,-1
    80000378:	0000f717          	auipc	a4,0xf
    8000037c:	64f72c23          	sw	a5,1624(a4) # 8000f9d0 <cons+0xa0>
      consputc(BACKSPACE);
    80000380:	10000513          	li	a0,256
    80000384:	ea9ff0ef          	jal	ra,8000022c <consputc>
    80000388:	b729                	j	80000292 <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000038a:	f00484e3          	beqz	s1,80000292 <consoleintr+0x34>
    8000038e:	b715                	j	800002b2 <consoleintr+0x54>
      consputc(c);
    80000390:	4529                	li	a0,10
    80000392:	e9bff0ef          	jal	ra,8000022c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000396:	0000f797          	auipc	a5,0xf
    8000039a:	59a78793          	addi	a5,a5,1434 # 8000f930 <cons>
    8000039e:	0a07a703          	lw	a4,160(a5)
    800003a2:	0017069b          	addiw	a3,a4,1
    800003a6:	0006861b          	sext.w	a2,a3
    800003aa:	0ad7a023          	sw	a3,160(a5)
    800003ae:	07f77713          	andi	a4,a4,127
    800003b2:	97ba                	add	a5,a5,a4
    800003b4:	4729                	li	a4,10
    800003b6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003ba:	0000f797          	auipc	a5,0xf
    800003be:	60c7a923          	sw	a2,1554(a5) # 8000f9cc <cons+0x9c>
        wakeup(&cons.r);
    800003c2:	0000f517          	auipc	a0,0xf
    800003c6:	60650513          	addi	a0,a0,1542 # 8000f9c8 <cons+0x98>
    800003ca:	28b010ef          	jal	ra,80001e54 <wakeup>
    800003ce:	b5d1                	j	80000292 <consoleintr+0x34>

00000000800003d0 <consoleinit>:

void
consoleinit(void)
{
    800003d0:	1141                	addi	sp,sp,-16
    800003d2:	e406                	sd	ra,8(sp)
    800003d4:	e022                	sd	s0,0(sp)
    800003d6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d8:	00007597          	auipc	a1,0x7
    800003dc:	c3858593          	addi	a1,a1,-968 # 80007010 <etext+0x10>
    800003e0:	0000f517          	auipc	a0,0xf
    800003e4:	55050513          	addi	a0,a0,1360 # 8000f930 <cons>
    800003e8:	740000ef          	jal	ra,80000b28 <initlock>

  uartinit();
    800003ec:	3d8000ef          	jal	ra,800007c4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003f0:	0001f797          	auipc	a5,0x1f
    800003f4:	6d878793          	addi	a5,a5,1752 # 8001fac8 <devsw>
    800003f8:	00000717          	auipc	a4,0x0
    800003fc:	d3270713          	addi	a4,a4,-718 # 8000012a <consoleread>
    80000400:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000402:	00000717          	auipc	a4,0x0
    80000406:	cce70713          	addi	a4,a4,-818 # 800000d0 <consolewrite>
    8000040a:	ef98                	sd	a4,24(a5)
}
    8000040c:	60a2                	ld	ra,8(sp)
    8000040e:	6402                	ld	s0,0(sp)
    80000410:	0141                	addi	sp,sp,16
    80000412:	8082                	ret

0000000080000414 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000414:	7179                	addi	sp,sp,-48
    80000416:	f406                	sd	ra,40(sp)
    80000418:	f022                	sd	s0,32(sp)
    8000041a:	ec26                	sd	s1,24(sp)
    8000041c:	e84a                	sd	s2,16(sp)
    8000041e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000420:	c219                	beqz	a2,80000426 <printint+0x12>
    80000422:	06054f63          	bltz	a0,800004a0 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000426:	4881                	li	a7,0
    80000428:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000042c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000042e:	00007617          	auipc	a2,0x7
    80000432:	c0a60613          	addi	a2,a2,-1014 # 80007038 <digits>
    80000436:	883e                	mv	a6,a5
    80000438:	2785                	addiw	a5,a5,1
    8000043a:	02b57733          	remu	a4,a0,a1
    8000043e:	9732                	add	a4,a4,a2
    80000440:	00074703          	lbu	a4,0(a4)
    80000444:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000448:	872a                	mv	a4,a0
    8000044a:	02b55533          	divu	a0,a0,a1
    8000044e:	0685                	addi	a3,a3,1
    80000450:	feb773e3          	bgeu	a4,a1,80000436 <printint+0x22>

  if(sign)
    80000454:	00088b63          	beqz	a7,8000046a <printint+0x56>
    buf[i++] = '-';
    80000458:	fe040713          	addi	a4,s0,-32
    8000045c:	97ba                	add	a5,a5,a4
    8000045e:	02d00713          	li	a4,45
    80000462:	fee78823          	sb	a4,-16(a5)
    80000466:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000046a:	02f05563          	blez	a5,80000494 <printint+0x80>
    8000046e:	fd040713          	addi	a4,s0,-48
    80000472:	00f704b3          	add	s1,a4,a5
    80000476:	fff70913          	addi	s2,a4,-1
    8000047a:	993e                	add	s2,s2,a5
    8000047c:	37fd                	addiw	a5,a5,-1
    8000047e:	1782                	slli	a5,a5,0x20
    80000480:	9381                	srli	a5,a5,0x20
    80000482:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000486:	fff4c503          	lbu	a0,-1(s1)
    8000048a:	da3ff0ef          	jal	ra,8000022c <consputc>
  while(--i >= 0)
    8000048e:	14fd                	addi	s1,s1,-1
    80000490:	ff249be3          	bne	s1,s2,80000486 <printint+0x72>
}
    80000494:	70a2                	ld	ra,40(sp)
    80000496:	7402                	ld	s0,32(sp)
    80000498:	64e2                	ld	s1,24(sp)
    8000049a:	6942                	ld	s2,16(sp)
    8000049c:	6145                	addi	sp,sp,48
    8000049e:	8082                	ret
    x = -xx;
    800004a0:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004a4:	4885                	li	a7,1
    x = -xx;
    800004a6:	b749                	j	80000428 <printint+0x14>

00000000800004a8 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004a8:	7155                	addi	sp,sp,-208
    800004aa:	e506                	sd	ra,136(sp)
    800004ac:	e122                	sd	s0,128(sp)
    800004ae:	fca6                	sd	s1,120(sp)
    800004b0:	f8ca                	sd	s2,112(sp)
    800004b2:	f4ce                	sd	s3,104(sp)
    800004b4:	f0d2                	sd	s4,96(sp)
    800004b6:	ecd6                	sd	s5,88(sp)
    800004b8:	e8da                	sd	s6,80(sp)
    800004ba:	e4de                	sd	s7,72(sp)
    800004bc:	e0e2                	sd	s8,64(sp)
    800004be:	fc66                	sd	s9,56(sp)
    800004c0:	f86a                	sd	s10,48(sp)
    800004c2:	f46e                	sd	s11,40(sp)
    800004c4:	0900                	addi	s0,sp,144
    800004c6:	8a2a                	mv	s4,a0
    800004c8:	e40c                	sd	a1,8(s0)
    800004ca:	e810                	sd	a2,16(s0)
    800004cc:	ec14                	sd	a3,24(s0)
    800004ce:	f018                	sd	a4,32(s0)
    800004d0:	f41c                	sd	a5,40(s0)
    800004d2:	03043823          	sd	a6,48(s0)
    800004d6:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004da:	0000f797          	auipc	a5,0xf
    800004de:	5167a783          	lw	a5,1302(a5) # 8000f9f0 <pr+0x18>
    800004e2:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004e6:	eb9d                	bnez	a5,8000051c <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004e8:	00840793          	addi	a5,s0,8
    800004ec:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f0:	00054503          	lbu	a0,0(a0)
    800004f4:	24050463          	beqz	a0,8000073c <printf+0x294>
    800004f8:	4981                	li	s3,0
    if(cx != '%'){
    800004fa:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004fe:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000502:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000506:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000050a:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000050e:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000512:	00007b97          	auipc	s7,0x7
    80000516:	b26b8b93          	addi	s7,s7,-1242 # 80007038 <digits>
    8000051a:	a081                	j	8000055a <printf+0xb2>
    acquire(&pr.lock);
    8000051c:	0000f517          	auipc	a0,0xf
    80000520:	4bc50513          	addi	a0,a0,1212 # 8000f9d8 <pr>
    80000524:	684000ef          	jal	ra,80000ba8 <acquire>
  va_start(ap, fmt);
    80000528:	00840793          	addi	a5,s0,8
    8000052c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000530:	000a4503          	lbu	a0,0(s4)
    80000534:	f171                	bnez	a0,800004f8 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000536:	0000f517          	auipc	a0,0xf
    8000053a:	4a250513          	addi	a0,a0,1186 # 8000f9d8 <pr>
    8000053e:	702000ef          	jal	ra,80000c40 <release>
    80000542:	aaed                	j	8000073c <printf+0x294>
      consputc(cx);
    80000544:	ce9ff0ef          	jal	ra,8000022c <consputc>
      continue;
    80000548:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054a:	0014899b          	addiw	s3,s1,1
    8000054e:	013a07b3          	add	a5,s4,s3
    80000552:	0007c503          	lbu	a0,0(a5)
    80000556:	1c050f63          	beqz	a0,80000734 <printf+0x28c>
    if(cx != '%'){
    8000055a:	ff5515e3          	bne	a0,s5,80000544 <printf+0x9c>
    i++;
    8000055e:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000562:	009a07b3          	add	a5,s4,s1
    80000566:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056a:	1c090563          	beqz	s2,80000734 <printf+0x28c>
    8000056e:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000572:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000574:	c789                	beqz	a5,8000057e <printf+0xd6>
    80000576:	009a0733          	add	a4,s4,s1
    8000057a:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    8000057e:	03690463          	beq	s2,s6,800005a6 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    80000582:	03890e63          	beq	s2,s8,800005be <printf+0x116>
    } else if(c0 == 'u'){
    80000586:	0b990d63          	beq	s2,s9,80000640 <printf+0x198>
    } else if(c0 == 'x'){
    8000058a:	11a90363          	beq	s2,s10,80000690 <printf+0x1e8>
    } else if(c0 == 'p'){
    8000058e:	13b90b63          	beq	s2,s11,800006c4 <printf+0x21c>
    } else if(c0 == 's'){
    80000592:	07300793          	li	a5,115
    80000596:	16f90363          	beq	s2,a5,800006fc <printf+0x254>
    } else if(c0 == '%'){
    8000059a:	03591c63          	bne	s2,s5,800005d2 <printf+0x12a>
      consputc('%');
    8000059e:	8556                	mv	a0,s5
    800005a0:	c8dff0ef          	jal	ra,8000022c <consputc>
    800005a4:	b75d                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800005a6:	f8843783          	ld	a5,-120(s0)
    800005aa:	00878713          	addi	a4,a5,8
    800005ae:	f8e43423          	sd	a4,-120(s0)
    800005b2:	4605                	li	a2,1
    800005b4:	45a9                	li	a1,10
    800005b6:	4388                	lw	a0,0(a5)
    800005b8:	e5dff0ef          	jal	ra,80000414 <printint>
    800005bc:	b779                	j	8000054a <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800005be:	03678163          	beq	a5,s6,800005e0 <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005c2:	03878d63          	beq	a5,s8,800005fc <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005c6:	09978963          	beq	a5,s9,80000658 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005ca:	03878b63          	beq	a5,s8,80000600 <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005ce:	0da78d63          	beq	a5,s10,800006a8 <printf+0x200>
      consputc('%');
    800005d2:	8556                	mv	a0,s5
    800005d4:	c59ff0ef          	jal	ra,8000022c <consputc>
      consputc(c0);
    800005d8:	854a                	mv	a0,s2
    800005da:	c53ff0ef          	jal	ra,8000022c <consputc>
    800005de:	b7b5                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005e0:	f8843783          	ld	a5,-120(s0)
    800005e4:	00878713          	addi	a4,a5,8
    800005e8:	f8e43423          	sd	a4,-120(s0)
    800005ec:	4605                	li	a2,1
    800005ee:	45a9                	li	a1,10
    800005f0:	6388                	ld	a0,0(a5)
    800005f2:	e23ff0ef          	jal	ra,80000414 <printint>
      i += 1;
    800005f6:	0029849b          	addiw	s1,s3,2
    800005fa:	bf81                	j	8000054a <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005fc:	03668463          	beq	a3,s6,80000624 <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000600:	07968a63          	beq	a3,s9,80000674 <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000604:	fda697e3          	bne	a3,s10,800005d2 <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80000608:	f8843783          	ld	a5,-120(s0)
    8000060c:	00878713          	addi	a4,a5,8
    80000610:	f8e43423          	sd	a4,-120(s0)
    80000614:	4601                	li	a2,0
    80000616:	45c1                	li	a1,16
    80000618:	6388                	ld	a0,0(a5)
    8000061a:	dfbff0ef          	jal	ra,80000414 <printint>
      i += 2;
    8000061e:	0039849b          	addiw	s1,s3,3
    80000622:	b725                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4605                	li	a2,1
    80000632:	45a9                	li	a1,10
    80000634:	6388                	ld	a0,0(a5)
    80000636:	ddfff0ef          	jal	ra,80000414 <printint>
      i += 2;
    8000063a:	0039849b          	addiw	s1,s3,3
    8000063e:	b731                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    80000640:	f8843783          	ld	a5,-120(s0)
    80000644:	00878713          	addi	a4,a5,8
    80000648:	f8e43423          	sd	a4,-120(s0)
    8000064c:	4601                	li	a2,0
    8000064e:	45a9                	li	a1,10
    80000650:	4388                	lw	a0,0(a5)
    80000652:	dc3ff0ef          	jal	ra,80000414 <printint>
    80000656:	bdd5                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	dabff0ef          	jal	ra,80000414 <printint>
      i += 1;
    8000066e:	0029849b          	addiw	s1,s3,2
    80000672:	bde1                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000674:	f8843783          	ld	a5,-120(s0)
    80000678:	00878713          	addi	a4,a5,8
    8000067c:	f8e43423          	sd	a4,-120(s0)
    80000680:	4601                	li	a2,0
    80000682:	45a9                	li	a1,10
    80000684:	6388                	ld	a0,0(a5)
    80000686:	d8fff0ef          	jal	ra,80000414 <printint>
      i += 2;
    8000068a:	0039849b          	addiw	s1,s3,3
    8000068e:	bd75                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    80000690:	f8843783          	ld	a5,-120(s0)
    80000694:	00878713          	addi	a4,a5,8
    80000698:	f8e43423          	sd	a4,-120(s0)
    8000069c:	4601                	li	a2,0
    8000069e:	45c1                	li	a1,16
    800006a0:	4388                	lw	a0,0(a5)
    800006a2:	d73ff0ef          	jal	ra,80000414 <printint>
    800006a6:	b555                	j	8000054a <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	4601                	li	a2,0
    800006b6:	45c1                	li	a1,16
    800006b8:	6388                	ld	a0,0(a5)
    800006ba:	d5bff0ef          	jal	ra,80000414 <printint>
      i += 1;
    800006be:	0029849b          	addiw	s1,s3,2
    800006c2:	b561                	j	8000054a <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006d4:	03000513          	li	a0,48
    800006d8:	b55ff0ef          	jal	ra,8000022c <consputc>
  consputc('x');
    800006dc:	856a                	mv	a0,s10
    800006de:	b4fff0ef          	jal	ra,8000022c <consputc>
    800006e2:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e4:	03c9d793          	srli	a5,s3,0x3c
    800006e8:	97de                	add	a5,a5,s7
    800006ea:	0007c503          	lbu	a0,0(a5)
    800006ee:	b3fff0ef          	jal	ra,8000022c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f2:	0992                	slli	s3,s3,0x4
    800006f4:	397d                	addiw	s2,s2,-1
    800006f6:	fe0917e3          	bnez	s2,800006e4 <printf+0x23c>
    800006fa:	bd81                	j	8000054a <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006fc:	f8843783          	ld	a5,-120(s0)
    80000700:	00878713          	addi	a4,a5,8
    80000704:	f8e43423          	sd	a4,-120(s0)
    80000708:	0007b903          	ld	s2,0(a5)
    8000070c:	00090d63          	beqz	s2,80000726 <printf+0x27e>
      for(; *s; s++)
    80000710:	00094503          	lbu	a0,0(s2)
    80000714:	e2050be3          	beqz	a0,8000054a <printf+0xa2>
        consputc(*s);
    80000718:	b15ff0ef          	jal	ra,8000022c <consputc>
      for(; *s; s++)
    8000071c:	0905                	addi	s2,s2,1
    8000071e:	00094503          	lbu	a0,0(s2)
    80000722:	f97d                	bnez	a0,80000718 <printf+0x270>
    80000724:	b51d                	j	8000054a <printf+0xa2>
        s = "(null)";
    80000726:	00007917          	auipc	s2,0x7
    8000072a:	8f290913          	addi	s2,s2,-1806 # 80007018 <etext+0x18>
      for(; *s; s++)
    8000072e:	02800513          	li	a0,40
    80000732:	b7dd                	j	80000718 <printf+0x270>
  if(locking)
    80000734:	f7843783          	ld	a5,-136(s0)
    80000738:	de079fe3          	bnez	a5,80000536 <printf+0x8e>

  return 0;
}
    8000073c:	4501                	li	a0,0
    8000073e:	60aa                	ld	ra,136(sp)
    80000740:	640a                	ld	s0,128(sp)
    80000742:	74e6                	ld	s1,120(sp)
    80000744:	7946                	ld	s2,112(sp)
    80000746:	79a6                	ld	s3,104(sp)
    80000748:	7a06                	ld	s4,96(sp)
    8000074a:	6ae6                	ld	s5,88(sp)
    8000074c:	6b46                	ld	s6,80(sp)
    8000074e:	6ba6                	ld	s7,72(sp)
    80000750:	6c06                	ld	s8,64(sp)
    80000752:	7ce2                	ld	s9,56(sp)
    80000754:	7d42                	ld	s10,48(sp)
    80000756:	7da2                	ld	s11,40(sp)
    80000758:	6169                	addi	sp,sp,208
    8000075a:	8082                	ret

000000008000075c <panic>:

void
panic(char *s)
{
    8000075c:	1101                	addi	sp,sp,-32
    8000075e:	ec06                	sd	ra,24(sp)
    80000760:	e822                	sd	s0,16(sp)
    80000762:	e426                	sd	s1,8(sp)
    80000764:	1000                	addi	s0,sp,32
    80000766:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000768:	0000f797          	auipc	a5,0xf
    8000076c:	2807a423          	sw	zero,648(a5) # 8000f9f0 <pr+0x18>
  printf("panic: ");
    80000770:	00007517          	auipc	a0,0x7
    80000774:	8b050513          	addi	a0,a0,-1872 # 80007020 <etext+0x20>
    80000778:	d31ff0ef          	jal	ra,800004a8 <printf>
  printf("%s\n", s);
    8000077c:	85a6                	mv	a1,s1
    8000077e:	00007517          	auipc	a0,0x7
    80000782:	8aa50513          	addi	a0,a0,-1878 # 80007028 <etext+0x28>
    80000786:	d23ff0ef          	jal	ra,800004a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000078a:	4785                	li	a5,1
    8000078c:	00007717          	auipc	a4,0x7
    80000790:	16f72223          	sw	a5,356(a4) # 800078f0 <panicked>
  for(;;)
    80000794:	a001                	j	80000794 <panic+0x38>

0000000080000796 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000796:	1101                	addi	sp,sp,-32
    80000798:	ec06                	sd	ra,24(sp)
    8000079a:	e822                	sd	s0,16(sp)
    8000079c:	e426                	sd	s1,8(sp)
    8000079e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a0:	0000f497          	auipc	s1,0xf
    800007a4:	23848493          	addi	s1,s1,568 # 8000f9d8 <pr>
    800007a8:	00007597          	auipc	a1,0x7
    800007ac:	88858593          	addi	a1,a1,-1912 # 80007030 <etext+0x30>
    800007b0:	8526                	mv	a0,s1
    800007b2:	376000ef          	jal	ra,80000b28 <initlock>
  pr.locking = 1;
    800007b6:	4785                	li	a5,1
    800007b8:	cc9c                	sw	a5,24(s1)
}
    800007ba:	60e2                	ld	ra,24(sp)
    800007bc:	6442                	ld	s0,16(sp)
    800007be:	64a2                	ld	s1,8(sp)
    800007c0:	6105                	addi	sp,sp,32
    800007c2:	8082                	ret

00000000800007c4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007c4:	1141                	addi	sp,sp,-16
    800007c6:	e406                	sd	ra,8(sp)
    800007c8:	e022                	sd	s0,0(sp)
    800007ca:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007cc:	100007b7          	lui	a5,0x10000
    800007d0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007d4:	f8000713          	li	a4,-128
    800007d8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007dc:	470d                	li	a4,3
    800007de:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007e2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ea:	469d                	li	a3,7
    800007ec:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007f0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007f4:	00007597          	auipc	a1,0x7
    800007f8:	85c58593          	addi	a1,a1,-1956 # 80007050 <digits+0x18>
    800007fc:	0000f517          	auipc	a0,0xf
    80000800:	1fc50513          	addi	a0,a0,508 # 8000f9f8 <uart_tx_lock>
    80000804:	324000ef          	jal	ra,80000b28 <initlock>
}
    80000808:	60a2                	ld	ra,8(sp)
    8000080a:	6402                	ld	s0,0(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000810:	1101                	addi	sp,sp,-32
    80000812:	ec06                	sd	ra,24(sp)
    80000814:	e822                	sd	s0,16(sp)
    80000816:	e426                	sd	s1,8(sp)
    80000818:	1000                	addi	s0,sp,32
    8000081a:	84aa                	mv	s1,a0
  push_off();
    8000081c:	34c000ef          	jal	ra,80000b68 <push_off>

  if(panicked){
    80000820:	00007797          	auipc	a5,0x7
    80000824:	0d07a783          	lw	a5,208(a5) # 800078f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000828:	10000737          	lui	a4,0x10000
  if(panicked){
    8000082c:	c391                	beqz	a5,80000830 <uartputc_sync+0x20>
    for(;;)
    8000082e:	a001                	j	8000082e <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000830:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000834:	0ff7f793          	andi	a5,a5,255
    80000838:	0207f793          	andi	a5,a5,32
    8000083c:	dbf5                	beqz	a5,80000830 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000083e:	0ff4f793          	andi	a5,s1,255
    80000842:	10000737          	lui	a4,0x10000
    80000846:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000084a:	3a2000ef          	jal	ra,80000bec <pop_off>
}
    8000084e:	60e2                	ld	ra,24(sp)
    80000850:	6442                	ld	s0,16(sp)
    80000852:	64a2                	ld	s1,8(sp)
    80000854:	6105                	addi	sp,sp,32
    80000856:	8082                	ret

0000000080000858 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000858:	00007717          	auipc	a4,0x7
    8000085c:	0a073703          	ld	a4,160(a4) # 800078f8 <uart_tx_r>
    80000860:	00007797          	auipc	a5,0x7
    80000864:	0a07b783          	ld	a5,160(a5) # 80007900 <uart_tx_w>
    80000868:	06e78e63          	beq	a5,a4,800008e4 <uartstart+0x8c>
{
    8000086c:	7139                	addi	sp,sp,-64
    8000086e:	fc06                	sd	ra,56(sp)
    80000870:	f822                	sd	s0,48(sp)
    80000872:	f426                	sd	s1,40(sp)
    80000874:	f04a                	sd	s2,32(sp)
    80000876:	ec4e                	sd	s3,24(sp)
    80000878:	e852                	sd	s4,16(sp)
    8000087a:	e456                	sd	s5,8(sp)
    8000087c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	0000fa17          	auipc	s4,0xf
    80000886:	176a0a13          	addi	s4,s4,374 # 8000f9f8 <uart_tx_lock>
    uart_tx_r += 1;
    8000088a:	00007497          	auipc	s1,0x7
    8000088e:	06e48493          	addi	s1,s1,110 # 800078f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000892:	00007997          	auipc	s3,0x7
    80000896:	06e98993          	addi	s3,s3,110 # 80007900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000089a:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000089e:	0ff7f793          	andi	a5,a5,255
    800008a2:	0207f793          	andi	a5,a5,32
    800008a6:	c795                	beqz	a5,800008d2 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008a8:	01f77793          	andi	a5,a4,31
    800008ac:	97d2                	add	a5,a5,s4
    800008ae:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800008b2:	0705                	addi	a4,a4,1
    800008b4:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b6:	8526                	mv	a0,s1
    800008b8:	59c010ef          	jal	ra,80001e54 <wakeup>
    
    WriteReg(THR, c);
    800008bc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008c0:	6098                	ld	a4,0(s1)
    800008c2:	0009b783          	ld	a5,0(s3)
    800008c6:	fce79ae3          	bne	a5,a4,8000089a <uartstart+0x42>
      ReadReg(ISR);
    800008ca:	100007b7          	lui	a5,0x10000
    800008ce:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008d2:	70e2                	ld	ra,56(sp)
    800008d4:	7442                	ld	s0,48(sp)
    800008d6:	74a2                	ld	s1,40(sp)
    800008d8:	7902                	ld	s2,32(sp)
    800008da:	69e2                	ld	s3,24(sp)
    800008dc:	6a42                	ld	s4,16(sp)
    800008de:	6aa2                	ld	s5,8(sp)
    800008e0:	6121                	addi	sp,sp,64
    800008e2:	8082                	ret
      ReadReg(ISR);
    800008e4:	100007b7          	lui	a5,0x10000
    800008e8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008ec:	8082                	ret

00000000800008ee <uartputc>:
{
    800008ee:	7179                	addi	sp,sp,-48
    800008f0:	f406                	sd	ra,40(sp)
    800008f2:	f022                	sd	s0,32(sp)
    800008f4:	ec26                	sd	s1,24(sp)
    800008f6:	e84a                	sd	s2,16(sp)
    800008f8:	e44e                	sd	s3,8(sp)
    800008fa:	e052                	sd	s4,0(sp)
    800008fc:	1800                	addi	s0,sp,48
    800008fe:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80000900:	0000f517          	auipc	a0,0xf
    80000904:	0f850513          	addi	a0,a0,248 # 8000f9f8 <uart_tx_lock>
    80000908:	2a0000ef          	jal	ra,80000ba8 <acquire>
  if(panicked){
    8000090c:	00007797          	auipc	a5,0x7
    80000910:	fe47a783          	lw	a5,-28(a5) # 800078f0 <panicked>
    80000914:	efbd                	bnez	a5,80000992 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000916:	00007797          	auipc	a5,0x7
    8000091a:	fea7b783          	ld	a5,-22(a5) # 80007900 <uart_tx_w>
    8000091e:	00007717          	auipc	a4,0x7
    80000922:	fda73703          	ld	a4,-38(a4) # 800078f8 <uart_tx_r>
    80000926:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000092a:	0000fa17          	auipc	s4,0xf
    8000092e:	0cea0a13          	addi	s4,s4,206 # 8000f9f8 <uart_tx_lock>
    80000932:	00007497          	auipc	s1,0x7
    80000936:	fc648493          	addi	s1,s1,-58 # 800078f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000093a:	00007917          	auipc	s2,0x7
    8000093e:	fc690913          	addi	s2,s2,-58 # 80007900 <uart_tx_w>
    80000942:	00f71d63          	bne	a4,a5,8000095c <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000946:	85d2                	mv	a1,s4
    80000948:	8526                	mv	a0,s1
    8000094a:	4be010ef          	jal	ra,80001e08 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094e:	00093783          	ld	a5,0(s2)
    80000952:	6098                	ld	a4,0(s1)
    80000954:	02070713          	addi	a4,a4,32
    80000958:	fef707e3          	beq	a4,a5,80000946 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000095c:	0000f497          	auipc	s1,0xf
    80000960:	09c48493          	addi	s1,s1,156 # 8000f9f8 <uart_tx_lock>
    80000964:	01f7f713          	andi	a4,a5,31
    80000968:	9726                	add	a4,a4,s1
    8000096a:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    8000096e:	0785                	addi	a5,a5,1
    80000970:	00007717          	auipc	a4,0x7
    80000974:	f8f73823          	sd	a5,-112(a4) # 80007900 <uart_tx_w>
  uartstart();
    80000978:	ee1ff0ef          	jal	ra,80000858 <uartstart>
  release(&uart_tx_lock);
    8000097c:	8526                	mv	a0,s1
    8000097e:	2c2000ef          	jal	ra,80000c40 <release>
}
    80000982:	70a2                	ld	ra,40(sp)
    80000984:	7402                	ld	s0,32(sp)
    80000986:	64e2                	ld	s1,24(sp)
    80000988:	6942                	ld	s2,16(sp)
    8000098a:	69a2                	ld	s3,8(sp)
    8000098c:	6a02                	ld	s4,0(sp)
    8000098e:	6145                	addi	sp,sp,48
    80000990:	8082                	ret
    for(;;)
    80000992:	a001                	j	80000992 <uartputc+0xa4>

0000000080000994 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000994:	1141                	addi	sp,sp,-16
    80000996:	e422                	sd	s0,8(sp)
    80000998:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000099a:	100007b7          	lui	a5,0x10000
    8000099e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009a2:	8b85                	andi	a5,a5,1
    800009a4:	cb91                	beqz	a5,800009b8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009a6:	100007b7          	lui	a5,0x10000
    800009aa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009ae:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009b2:	6422                	ld	s0,8(sp)
    800009b4:	0141                	addi	sp,sp,16
    800009b6:	8082                	ret
    return -1;
    800009b8:	557d                	li	a0,-1
    800009ba:	bfe5                	j	800009b2 <uartgetc+0x1e>

00000000800009bc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009bc:	1101                	addi	sp,sp,-32
    800009be:	ec06                	sd	ra,24(sp)
    800009c0:	e822                	sd	s0,16(sp)
    800009c2:	e426                	sd	s1,8(sp)
    800009c4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009c6:	54fd                	li	s1,-1
    int c = uartgetc();
    800009c8:	fcdff0ef          	jal	ra,80000994 <uartgetc>
    if(c == -1)
    800009cc:	00950563          	beq	a0,s1,800009d6 <uartintr+0x1a>
      break;
    consoleintr(c);
    800009d0:	88fff0ef          	jal	ra,8000025e <consoleintr>
  while(1){
    800009d4:	bfd5                	j	800009c8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009d6:	0000f497          	auipc	s1,0xf
    800009da:	02248493          	addi	s1,s1,34 # 8000f9f8 <uart_tx_lock>
    800009de:	8526                	mv	a0,s1
    800009e0:	1c8000ef          	jal	ra,80000ba8 <acquire>
  uartstart();
    800009e4:	e75ff0ef          	jal	ra,80000858 <uartstart>
  release(&uart_tx_lock);
    800009e8:	8526                	mv	a0,s1
    800009ea:	256000ef          	jal	ra,80000c40 <release>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret

00000000800009f8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009f8:	1101                	addi	sp,sp,-32
    800009fa:	ec06                	sd	ra,24(sp)
    800009fc:	e822                	sd	s0,16(sp)
    800009fe:	e426                	sd	s1,8(sp)
    80000a00:	e04a                	sd	s2,0(sp)
    80000a02:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a04:	03451793          	slli	a5,a0,0x34
    80000a08:	e7a9                	bnez	a5,80000a52 <kfree+0x5a>
    80000a0a:	84aa                	mv	s1,a0
    80000a0c:	00020797          	auipc	a5,0x20
    80000a10:	25478793          	addi	a5,a5,596 # 80020c60 <end>
    80000a14:	02f56f63          	bltu	a0,a5,80000a52 <kfree+0x5a>
    80000a18:	47c5                	li	a5,17
    80000a1a:	07ee                	slli	a5,a5,0x1b
    80000a1c:	02f57b63          	bgeu	a0,a5,80000a52 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	4585                	li	a1,1
    80000a24:	258000ef          	jal	ra,80000c7c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a28:	0000f917          	auipc	s2,0xf
    80000a2c:	00890913          	addi	s2,s2,8 # 8000fa30 <kmem>
    80000a30:	854a                	mv	a0,s2
    80000a32:	176000ef          	jal	ra,80000ba8 <acquire>
  r->next = kmem.freelist;
    80000a36:	01893783          	ld	a5,24(s2)
    80000a3a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a3c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a40:	854a                	mv	a0,s2
    80000a42:	1fe000ef          	jal	ra,80000c40 <release>
}
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6902                	ld	s2,0(sp)
    80000a4e:	6105                	addi	sp,sp,32
    80000a50:	8082                	ret
    panic("kfree");
    80000a52:	00006517          	auipc	a0,0x6
    80000a56:	60650513          	addi	a0,a0,1542 # 80007058 <digits+0x20>
    80000a5a:	d03ff0ef          	jal	ra,8000075c <panic>

0000000080000a5e <freerange>:
{
    80000a5e:	7179                	addi	sp,sp,-48
    80000a60:	f406                	sd	ra,40(sp)
    80000a62:	f022                	sd	s0,32(sp)
    80000a64:	ec26                	sd	s1,24(sp)
    80000a66:	e84a                	sd	s2,16(sp)
    80000a68:	e44e                	sd	s3,8(sp)
    80000a6a:	e052                	sd	s4,0(sp)
    80000a6c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	94aa                	add	s1,s1,a0
    80000a76:	757d                	lui	a0,0xfffff
    80000a78:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7a:	94be                	add	s1,s1,a5
    80000a7c:	0095ec63          	bltu	a1,s1,80000a94 <freerange+0x36>
    80000a80:	892e                	mv	s2,a1
    kfree(p);
    80000a82:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a84:	6985                	lui	s3,0x1
    kfree(p);
    80000a86:	01448533          	add	a0,s1,s4
    80000a8a:	f6fff0ef          	jal	ra,800009f8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a8e:	94ce                	add	s1,s1,s3
    80000a90:	fe997be3          	bgeu	s2,s1,80000a86 <freerange+0x28>
}
    80000a94:	70a2                	ld	ra,40(sp)
    80000a96:	7402                	ld	s0,32(sp)
    80000a98:	64e2                	ld	s1,24(sp)
    80000a9a:	6942                	ld	s2,16(sp)
    80000a9c:	69a2                	ld	s3,8(sp)
    80000a9e:	6a02                	ld	s4,0(sp)
    80000aa0:	6145                	addi	sp,sp,48
    80000aa2:	8082                	ret

0000000080000aa4 <kinit>:
{
    80000aa4:	1141                	addi	sp,sp,-16
    80000aa6:	e406                	sd	ra,8(sp)
    80000aa8:	e022                	sd	s0,0(sp)
    80000aaa:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aac:	00006597          	auipc	a1,0x6
    80000ab0:	5b458593          	addi	a1,a1,1460 # 80007060 <digits+0x28>
    80000ab4:	0000f517          	auipc	a0,0xf
    80000ab8:	f7c50513          	addi	a0,a0,-132 # 8000fa30 <kmem>
    80000abc:	06c000ef          	jal	ra,80000b28 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac0:	45c5                	li	a1,17
    80000ac2:	05ee                	slli	a1,a1,0x1b
    80000ac4:	00020517          	auipc	a0,0x20
    80000ac8:	19c50513          	addi	a0,a0,412 # 80020c60 <end>
    80000acc:	f93ff0ef          	jal	ra,80000a5e <freerange>
}
    80000ad0:	60a2                	ld	ra,8(sp)
    80000ad2:	6402                	ld	s0,0(sp)
    80000ad4:	0141                	addi	sp,sp,16
    80000ad6:	8082                	ret

0000000080000ad8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad8:	1101                	addi	sp,sp,-32
    80000ada:	ec06                	sd	ra,24(sp)
    80000adc:	e822                	sd	s0,16(sp)
    80000ade:	e426                	sd	s1,8(sp)
    80000ae0:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ae2:	0000f497          	auipc	s1,0xf
    80000ae6:	f4e48493          	addi	s1,s1,-178 # 8000fa30 <kmem>
    80000aea:	8526                	mv	a0,s1
    80000aec:	0bc000ef          	jal	ra,80000ba8 <acquire>
  r = kmem.freelist;
    80000af0:	6c84                	ld	s1,24(s1)
  if(r)
    80000af2:	c485                	beqz	s1,80000b1a <kalloc+0x42>
    kmem.freelist = r->next;
    80000af4:	609c                	ld	a5,0(s1)
    80000af6:	0000f517          	auipc	a0,0xf
    80000afa:	f3a50513          	addi	a0,a0,-198 # 8000fa30 <kmem>
    80000afe:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b00:	140000ef          	jal	ra,80000c40 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b04:	6605                	lui	a2,0x1
    80000b06:	4595                	li	a1,5
    80000b08:	8526                	mv	a0,s1
    80000b0a:	172000ef          	jal	ra,80000c7c <memset>
  return (void*)r;
}
    80000b0e:	8526                	mv	a0,s1
    80000b10:	60e2                	ld	ra,24(sp)
    80000b12:	6442                	ld	s0,16(sp)
    80000b14:	64a2                	ld	s1,8(sp)
    80000b16:	6105                	addi	sp,sp,32
    80000b18:	8082                	ret
  release(&kmem.lock);
    80000b1a:	0000f517          	auipc	a0,0xf
    80000b1e:	f1650513          	addi	a0,a0,-234 # 8000fa30 <kmem>
    80000b22:	11e000ef          	jal	ra,80000c40 <release>
  if(r)
    80000b26:	b7e5                	j	80000b0e <kalloc+0x36>

0000000080000b28 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b28:	1141                	addi	sp,sp,-16
    80000b2a:	e422                	sd	s0,8(sp)
    80000b2c:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b2e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b30:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b34:	00053823          	sd	zero,16(a0)
}
    80000b38:	6422                	ld	s0,8(sp)
    80000b3a:	0141                	addi	sp,sp,16
    80000b3c:	8082                	ret

0000000080000b3e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b3e:	411c                	lw	a5,0(a0)
    80000b40:	e399                	bnez	a5,80000b46 <holding+0x8>
    80000b42:	4501                	li	a0,0
  return r;
}
    80000b44:	8082                	ret
{
    80000b46:	1101                	addi	sp,sp,-32
    80000b48:	ec06                	sd	ra,24(sp)
    80000b4a:	e822                	sd	s0,16(sp)
    80000b4c:	e426                	sd	s1,8(sp)
    80000b4e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b50:	6904                	ld	s1,16(a0)
    80000b52:	4d3000ef          	jal	ra,80001824 <mycpu>
    80000b56:	40a48533          	sub	a0,s1,a0
    80000b5a:	00153513          	seqz	a0,a0
}
    80000b5e:	60e2                	ld	ra,24(sp)
    80000b60:	6442                	ld	s0,16(sp)
    80000b62:	64a2                	ld	s1,8(sp)
    80000b64:	6105                	addi	sp,sp,32
    80000b66:	8082                	ret

0000000080000b68 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b68:	1101                	addi	sp,sp,-32
    80000b6a:	ec06                	sd	ra,24(sp)
    80000b6c:	e822                	sd	s0,16(sp)
    80000b6e:	e426                	sd	s1,8(sp)
    80000b70:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b72:	100024f3          	csrr	s1,sstatus
    80000b76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b7a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b7c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b80:	4a5000ef          	jal	ra,80001824 <mycpu>
    80000b84:	5d3c                	lw	a5,120(a0)
    80000b86:	cb99                	beqz	a5,80000b9c <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b88:	49d000ef          	jal	ra,80001824 <mycpu>
    80000b8c:	5d3c                	lw	a5,120(a0)
    80000b8e:	2785                	addiw	a5,a5,1
    80000b90:	dd3c                	sw	a5,120(a0)
}
    80000b92:	60e2                	ld	ra,24(sp)
    80000b94:	6442                	ld	s0,16(sp)
    80000b96:	64a2                	ld	s1,8(sp)
    80000b98:	6105                	addi	sp,sp,32
    80000b9a:	8082                	ret
    mycpu()->intena = old;
    80000b9c:	489000ef          	jal	ra,80001824 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000ba0:	8085                	srli	s1,s1,0x1
    80000ba2:	8885                	andi	s1,s1,1
    80000ba4:	dd64                	sw	s1,124(a0)
    80000ba6:	b7cd                	j	80000b88 <push_off+0x20>

0000000080000ba8 <acquire>:
{
    80000ba8:	1101                	addi	sp,sp,-32
    80000baa:	ec06                	sd	ra,24(sp)
    80000bac:	e822                	sd	s0,16(sp)
    80000bae:	e426                	sd	s1,8(sp)
    80000bb0:	1000                	addi	s0,sp,32
    80000bb2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bb4:	fb5ff0ef          	jal	ra,80000b68 <push_off>
  if(holding(lk))
    80000bb8:	8526                	mv	a0,s1
    80000bba:	f85ff0ef          	jal	ra,80000b3e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bbe:	4705                	li	a4,1
  if(holding(lk))
    80000bc0:	e105                	bnez	a0,80000be0 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bc2:	87ba                	mv	a5,a4
    80000bc4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bc8:	2781                	sext.w	a5,a5
    80000bca:	ffe5                	bnez	a5,80000bc2 <acquire+0x1a>
  __sync_synchronize();
    80000bcc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bd0:	455000ef          	jal	ra,80001824 <mycpu>
    80000bd4:	e888                	sd	a0,16(s1)
}
    80000bd6:	60e2                	ld	ra,24(sp)
    80000bd8:	6442                	ld	s0,16(sp)
    80000bda:	64a2                	ld	s1,8(sp)
    80000bdc:	6105                	addi	sp,sp,32
    80000bde:	8082                	ret
    panic("acquire");
    80000be0:	00006517          	auipc	a0,0x6
    80000be4:	48850513          	addi	a0,a0,1160 # 80007068 <digits+0x30>
    80000be8:	b75ff0ef          	jal	ra,8000075c <panic>

0000000080000bec <pop_off>:

void
pop_off(void)
{
    80000bec:	1141                	addi	sp,sp,-16
    80000bee:	e406                	sd	ra,8(sp)
    80000bf0:	e022                	sd	s0,0(sp)
    80000bf2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000bf4:	431000ef          	jal	ra,80001824 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bfc:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bfe:	e78d                	bnez	a5,80000c28 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c00:	5d3c                	lw	a5,120(a0)
    80000c02:	02f05963          	blez	a5,80000c34 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c06:	37fd                	addiw	a5,a5,-1
    80000c08:	0007871b          	sext.w	a4,a5
    80000c0c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c0e:	eb09                	bnez	a4,80000c20 <pop_off+0x34>
    80000c10:	5d7c                	lw	a5,124(a0)
    80000c12:	c799                	beqz	a5,80000c20 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c18:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c1c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c20:	60a2                	ld	ra,8(sp)
    80000c22:	6402                	ld	s0,0(sp)
    80000c24:	0141                	addi	sp,sp,16
    80000c26:	8082                	ret
    panic("pop_off - interruptible");
    80000c28:	00006517          	auipc	a0,0x6
    80000c2c:	44850513          	addi	a0,a0,1096 # 80007070 <digits+0x38>
    80000c30:	b2dff0ef          	jal	ra,8000075c <panic>
    panic("pop_off");
    80000c34:	00006517          	auipc	a0,0x6
    80000c38:	45450513          	addi	a0,a0,1108 # 80007088 <digits+0x50>
    80000c3c:	b21ff0ef          	jal	ra,8000075c <panic>

0000000080000c40 <release>:
{
    80000c40:	1101                	addi	sp,sp,-32
    80000c42:	ec06                	sd	ra,24(sp)
    80000c44:	e822                	sd	s0,16(sp)
    80000c46:	e426                	sd	s1,8(sp)
    80000c48:	1000                	addi	s0,sp,32
    80000c4a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c4c:	ef3ff0ef          	jal	ra,80000b3e <holding>
    80000c50:	c105                	beqz	a0,80000c70 <release+0x30>
  lk->cpu = 0;
    80000c52:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c56:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c5a:	0f50000f          	fence	iorw,ow
    80000c5e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c62:	f8bff0ef          	jal	ra,80000bec <pop_off>
}
    80000c66:	60e2                	ld	ra,24(sp)
    80000c68:	6442                	ld	s0,16(sp)
    80000c6a:	64a2                	ld	s1,8(sp)
    80000c6c:	6105                	addi	sp,sp,32
    80000c6e:	8082                	ret
    panic("release");
    80000c70:	00006517          	auipc	a0,0x6
    80000c74:	42050513          	addi	a0,a0,1056 # 80007090 <digits+0x58>
    80000c78:	ae5ff0ef          	jal	ra,8000075c <panic>

0000000080000c7c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c7c:	1141                	addi	sp,sp,-16
    80000c7e:	e422                	sd	s0,8(sp)
    80000c80:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c82:	ce09                	beqz	a2,80000c9c <memset+0x20>
    80000c84:	87aa                	mv	a5,a0
    80000c86:	fff6071b          	addiw	a4,a2,-1
    80000c8a:	1702                	slli	a4,a4,0x20
    80000c8c:	9301                	srli	a4,a4,0x20
    80000c8e:	0705                	addi	a4,a4,1
    80000c90:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000c92:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c96:	0785                	addi	a5,a5,1
    80000c98:	fee79de3          	bne	a5,a4,80000c92 <memset+0x16>
  }
  return dst;
}
    80000c9c:	6422                	ld	s0,8(sp)
    80000c9e:	0141                	addi	sp,sp,16
    80000ca0:	8082                	ret

0000000080000ca2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ca2:	1141                	addi	sp,sp,-16
    80000ca4:	e422                	sd	s0,8(sp)
    80000ca6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ca8:	ca05                	beqz	a2,80000cd8 <memcmp+0x36>
    80000caa:	fff6069b          	addiw	a3,a2,-1
    80000cae:	1682                	slli	a3,a3,0x20
    80000cb0:	9281                	srli	a3,a3,0x20
    80000cb2:	0685                	addi	a3,a3,1
    80000cb4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cb6:	00054783          	lbu	a5,0(a0)
    80000cba:	0005c703          	lbu	a4,0(a1)
    80000cbe:	00e79863          	bne	a5,a4,80000cce <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cc2:	0505                	addi	a0,a0,1
    80000cc4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cc6:	fed518e3          	bne	a0,a3,80000cb6 <memcmp+0x14>
  }

  return 0;
    80000cca:	4501                	li	a0,0
    80000ccc:	a019                	j	80000cd2 <memcmp+0x30>
      return *s1 - *s2;
    80000cce:	40e7853b          	subw	a0,a5,a4
}
    80000cd2:	6422                	ld	s0,8(sp)
    80000cd4:	0141                	addi	sp,sp,16
    80000cd6:	8082                	ret
  return 0;
    80000cd8:	4501                	li	a0,0
    80000cda:	bfe5                	j	80000cd2 <memcmp+0x30>

0000000080000cdc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cdc:	1141                	addi	sp,sp,-16
    80000cde:	e422                	sd	s0,8(sp)
    80000ce0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000ce2:	ca0d                	beqz	a2,80000d14 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000ce4:	00a5f963          	bgeu	a1,a0,80000cf6 <memmove+0x1a>
    80000ce8:	02061693          	slli	a3,a2,0x20
    80000cec:	9281                	srli	a3,a3,0x20
    80000cee:	00d58733          	add	a4,a1,a3
    80000cf2:	02e56463          	bltu	a0,a4,80000d1a <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cf6:	fff6079b          	addiw	a5,a2,-1
    80000cfa:	1782                	slli	a5,a5,0x20
    80000cfc:	9381                	srli	a5,a5,0x20
    80000cfe:	0785                	addi	a5,a5,1
    80000d00:	97ae                	add	a5,a5,a1
    80000d02:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d04:	0585                	addi	a1,a1,1
    80000d06:	0705                	addi	a4,a4,1
    80000d08:	fff5c683          	lbu	a3,-1(a1)
    80000d0c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d10:	fef59ae3          	bne	a1,a5,80000d04 <memmove+0x28>

  return dst;
}
    80000d14:	6422                	ld	s0,8(sp)
    80000d16:	0141                	addi	sp,sp,16
    80000d18:	8082                	ret
    d += n;
    80000d1a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d1c:	fff6079b          	addiw	a5,a2,-1
    80000d20:	1782                	slli	a5,a5,0x20
    80000d22:	9381                	srli	a5,a5,0x20
    80000d24:	fff7c793          	not	a5,a5
    80000d28:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d2a:	177d                	addi	a4,a4,-1
    80000d2c:	16fd                	addi	a3,a3,-1
    80000d2e:	00074603          	lbu	a2,0(a4)
    80000d32:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d36:	fef71ae3          	bne	a4,a5,80000d2a <memmove+0x4e>
    80000d3a:	bfe9                	j	80000d14 <memmove+0x38>

0000000080000d3c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d3c:	1141                	addi	sp,sp,-16
    80000d3e:	e406                	sd	ra,8(sp)
    80000d40:	e022                	sd	s0,0(sp)
    80000d42:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d44:	f99ff0ef          	jal	ra,80000cdc <memmove>
}
    80000d48:	60a2                	ld	ra,8(sp)
    80000d4a:	6402                	ld	s0,0(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret

0000000080000d50 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d50:	1141                	addi	sp,sp,-16
    80000d52:	e422                	sd	s0,8(sp)
    80000d54:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d56:	ce11                	beqz	a2,80000d72 <strncmp+0x22>
    80000d58:	00054783          	lbu	a5,0(a0)
    80000d5c:	cf89                	beqz	a5,80000d76 <strncmp+0x26>
    80000d5e:	0005c703          	lbu	a4,0(a1)
    80000d62:	00f71a63          	bne	a4,a5,80000d76 <strncmp+0x26>
    n--, p++, q++;
    80000d66:	367d                	addiw	a2,a2,-1
    80000d68:	0505                	addi	a0,a0,1
    80000d6a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d6c:	f675                	bnez	a2,80000d58 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d6e:	4501                	li	a0,0
    80000d70:	a809                	j	80000d82 <strncmp+0x32>
    80000d72:	4501                	li	a0,0
    80000d74:	a039                	j	80000d82 <strncmp+0x32>
  if(n == 0)
    80000d76:	ca09                	beqz	a2,80000d88 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d78:	00054503          	lbu	a0,0(a0)
    80000d7c:	0005c783          	lbu	a5,0(a1)
    80000d80:	9d1d                	subw	a0,a0,a5
}
    80000d82:	6422                	ld	s0,8(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
    return 0;
    80000d88:	4501                	li	a0,0
    80000d8a:	bfe5                	j	80000d82 <strncmp+0x32>

0000000080000d8c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e422                	sd	s0,8(sp)
    80000d90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d92:	872a                	mv	a4,a0
    80000d94:	8832                	mv	a6,a2
    80000d96:	367d                	addiw	a2,a2,-1
    80000d98:	01005963          	blez	a6,80000daa <strncpy+0x1e>
    80000d9c:	0705                	addi	a4,a4,1
    80000d9e:	0005c783          	lbu	a5,0(a1)
    80000da2:	fef70fa3          	sb	a5,-1(a4)
    80000da6:	0585                	addi	a1,a1,1
    80000da8:	f7f5                	bnez	a5,80000d94 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000daa:	00c05d63          	blez	a2,80000dc4 <strncpy+0x38>
    80000dae:	86ba                	mv	a3,a4
    *s++ = 0;
    80000db0:	0685                	addi	a3,a3,1
    80000db2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000db6:	fff6c793          	not	a5,a3
    80000dba:	9fb9                	addw	a5,a5,a4
    80000dbc:	010787bb          	addw	a5,a5,a6
    80000dc0:	fef048e3          	bgtz	a5,80000db0 <strncpy+0x24>
  return os;
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dd0:	02c05363          	blez	a2,80000df6 <safestrcpy+0x2c>
    80000dd4:	fff6069b          	addiw	a3,a2,-1
    80000dd8:	1682                	slli	a3,a3,0x20
    80000dda:	9281                	srli	a3,a3,0x20
    80000ddc:	96ae                	add	a3,a3,a1
    80000dde:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000de0:	00d58963          	beq	a1,a3,80000df2 <safestrcpy+0x28>
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	0785                	addi	a5,a5,1
    80000de8:	fff5c703          	lbu	a4,-1(a1)
    80000dec:	fee78fa3          	sb	a4,-1(a5)
    80000df0:	fb65                	bnez	a4,80000de0 <safestrcpy+0x16>
    ;
  *s = 0;
    80000df2:	00078023          	sb	zero,0(a5)
  return os;
}
    80000df6:	6422                	ld	s0,8(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret

0000000080000dfc <strlen>:

int
strlen(const char *s)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e422                	sd	s0,8(sp)
    80000e00:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e02:	00054783          	lbu	a5,0(a0)
    80000e06:	cf91                	beqz	a5,80000e22 <strlen+0x26>
    80000e08:	0505                	addi	a0,a0,1
    80000e0a:	87aa                	mv	a5,a0
    80000e0c:	4685                	li	a3,1
    80000e0e:	9e89                	subw	a3,a3,a0
    80000e10:	00f6853b          	addw	a0,a3,a5
    80000e14:	0785                	addi	a5,a5,1
    80000e16:	fff7c703          	lbu	a4,-1(a5)
    80000e1a:	fb7d                	bnez	a4,80000e10 <strlen+0x14>
    ;
  return n;
}
    80000e1c:	6422                	ld	s0,8(sp)
    80000e1e:	0141                	addi	sp,sp,16
    80000e20:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e22:	4501                	li	a0,0
    80000e24:	bfe5                	j	80000e1c <strlen+0x20>

0000000080000e26 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e406                	sd	ra,8(sp)
    80000e2a:	e022                	sd	s0,0(sp)
    80000e2c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e2e:	1e7000ef          	jal	ra,80001814 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e32:	00007717          	auipc	a4,0x7
    80000e36:	ad670713          	addi	a4,a4,-1322 # 80007908 <started>
  if(cpuid() == 0){
    80000e3a:	c51d                	beqz	a0,80000e68 <main+0x42>
    while(started == 0)
    80000e3c:	431c                	lw	a5,0(a4)
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	dff5                	beqz	a5,80000e3c <main+0x16>
      ;
    __sync_synchronize();
    80000e42:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e46:	1cf000ef          	jal	ra,80001814 <cpuid>
    80000e4a:	85aa                	mv	a1,a0
    80000e4c:	00006517          	auipc	a0,0x6
    80000e50:	26450513          	addi	a0,a0,612 # 800070b0 <digits+0x78>
    80000e54:	e54ff0ef          	jal	ra,800004a8 <printf>
    kvminithart();    // turn on paging
    80000e58:	080000ef          	jal	ra,80000ed8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e5c:	4cc010ef          	jal	ra,80002328 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e60:	254040ef          	jal	ra,800050b4 <plicinithart>
  }

  scheduler();        
    80000e64:	60b000ef          	jal	ra,80001c6e <scheduler>
    consoleinit();
    80000e68:	d68ff0ef          	jal	ra,800003d0 <consoleinit>
    printfinit();
    80000e6c:	92bff0ef          	jal	ra,80000796 <printfinit>
    printf("\n");
    80000e70:	00006517          	auipc	a0,0x6
    80000e74:	25050513          	addi	a0,a0,592 # 800070c0 <digits+0x88>
    80000e78:	e30ff0ef          	jal	ra,800004a8 <printf>
    printf("xv6 kernel is booting\n");
    80000e7c:	00006517          	auipc	a0,0x6
    80000e80:	21c50513          	addi	a0,a0,540 # 80007098 <digits+0x60>
    80000e84:	e24ff0ef          	jal	ra,800004a8 <printf>
    printf("\n");
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	23850513          	addi	a0,a0,568 # 800070c0 <digits+0x88>
    80000e90:	e18ff0ef          	jal	ra,800004a8 <printf>
    kinit();         // physical page allocator
    80000e94:	c11ff0ef          	jal	ra,80000aa4 <kinit>
    kvminit();       // create kernel page table
    80000e98:	2ca000ef          	jal	ra,80001162 <kvminit>
    kvminithart();   // turn on paging
    80000e9c:	03c000ef          	jal	ra,80000ed8 <kvminithart>
    procinit();      // process table
    80000ea0:	0cd000ef          	jal	ra,8000176c <procinit>
    trapinit();      // trap vectors
    80000ea4:	460010ef          	jal	ra,80002304 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ea8:	480010ef          	jal	ra,80002328 <trapinithart>
    plicinit();      // set up interrupt controller
    80000eac:	1f2040ef          	jal	ra,8000509e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eb0:	204040ef          	jal	ra,800050b4 <plicinithart>
    binit();         // buffer cache
    80000eb4:	29f010ef          	jal	ra,80002952 <binit>
    iinit();         // inode table
    80000eb8:	07e020ef          	jal	ra,80002f36 <iinit>
    fileinit();      // file table
    80000ebc:	619020ef          	jal	ra,80003cd4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ec0:	2e4040ef          	jal	ra,800051a4 <virtio_disk_init>
    userinit();      // first user process
    80000ec4:	3e5000ef          	jal	ra,80001aa8 <userinit>
    __sync_synchronize();
    80000ec8:	0ff0000f          	fence
    started = 1;
    80000ecc:	4785                	li	a5,1
    80000ece:	00007717          	auipc	a4,0x7
    80000ed2:	a2f72d23          	sw	a5,-1478(a4) # 80007908 <started>
    80000ed6:	b779                	j	80000e64 <main+0x3e>

0000000080000ed8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000ed8:	1141                	addi	sp,sp,-16
    80000eda:	e422                	sd	s0,8(sp)
    80000edc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ede:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ee2:	00007797          	auipc	a5,0x7
    80000ee6:	a2e7b783          	ld	a5,-1490(a5) # 80007910 <kernel_pagetable>
    80000eea:	83b1                	srli	a5,a5,0xc
    80000eec:	577d                	li	a4,-1
    80000eee:	177e                	slli	a4,a4,0x3f
    80000ef0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ef2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ef6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000efa:	6422                	ld	s0,8(sp)
    80000efc:	0141                	addi	sp,sp,16
    80000efe:	8082                	ret

0000000080000f00 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f00:	7139                	addi	sp,sp,-64
    80000f02:	fc06                	sd	ra,56(sp)
    80000f04:	f822                	sd	s0,48(sp)
    80000f06:	f426                	sd	s1,40(sp)
    80000f08:	f04a                	sd	s2,32(sp)
    80000f0a:	ec4e                	sd	s3,24(sp)
    80000f0c:	e852                	sd	s4,16(sp)
    80000f0e:	e456                	sd	s5,8(sp)
    80000f10:	e05a                	sd	s6,0(sp)
    80000f12:	0080                	addi	s0,sp,64
    80000f14:	84aa                	mv	s1,a0
    80000f16:	89ae                	mv	s3,a1
    80000f18:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f1a:	57fd                	li	a5,-1
    80000f1c:	83e9                	srli	a5,a5,0x1a
    80000f1e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f20:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f22:	02b7fc63          	bgeu	a5,a1,80000f5a <walk+0x5a>
    panic("walk");
    80000f26:	00006517          	auipc	a0,0x6
    80000f2a:	1a250513          	addi	a0,a0,418 # 800070c8 <digits+0x90>
    80000f2e:	82fff0ef          	jal	ra,8000075c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f32:	060a8263          	beqz	s5,80000f96 <walk+0x96>
    80000f36:	ba3ff0ef          	jal	ra,80000ad8 <kalloc>
    80000f3a:	84aa                	mv	s1,a0
    80000f3c:	c139                	beqz	a0,80000f82 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f3e:	6605                	lui	a2,0x1
    80000f40:	4581                	li	a1,0
    80000f42:	d3bff0ef          	jal	ra,80000c7c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f46:	00c4d793          	srli	a5,s1,0xc
    80000f4a:	07aa                	slli	a5,a5,0xa
    80000f4c:	0017e793          	ori	a5,a5,1
    80000f50:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f54:	3a5d                	addiw	s4,s4,-9
    80000f56:	036a0063          	beq	s4,s6,80000f76 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f5a:	0149d933          	srl	s2,s3,s4
    80000f5e:	1ff97913          	andi	s2,s2,511
    80000f62:	090e                	slli	s2,s2,0x3
    80000f64:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f66:	00093483          	ld	s1,0(s2)
    80000f6a:	0014f793          	andi	a5,s1,1
    80000f6e:	d3f1                	beqz	a5,80000f32 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f70:	80a9                	srli	s1,s1,0xa
    80000f72:	04b2                	slli	s1,s1,0xc
    80000f74:	b7c5                	j	80000f54 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f76:	00c9d513          	srli	a0,s3,0xc
    80000f7a:	1ff57513          	andi	a0,a0,511
    80000f7e:	050e                	slli	a0,a0,0x3
    80000f80:	9526                	add	a0,a0,s1
}
    80000f82:	70e2                	ld	ra,56(sp)
    80000f84:	7442                	ld	s0,48(sp)
    80000f86:	74a2                	ld	s1,40(sp)
    80000f88:	7902                	ld	s2,32(sp)
    80000f8a:	69e2                	ld	s3,24(sp)
    80000f8c:	6a42                	ld	s4,16(sp)
    80000f8e:	6aa2                	ld	s5,8(sp)
    80000f90:	6b02                	ld	s6,0(sp)
    80000f92:	6121                	addi	sp,sp,64
    80000f94:	8082                	ret
        return 0;
    80000f96:	4501                	li	a0,0
    80000f98:	b7ed                	j	80000f82 <walk+0x82>

0000000080000f9a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f9a:	57fd                	li	a5,-1
    80000f9c:	83e9                	srli	a5,a5,0x1a
    80000f9e:	00b7f463          	bgeu	a5,a1,80000fa6 <walkaddr+0xc>
    return 0;
    80000fa2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fa4:	8082                	ret
{
    80000fa6:	1141                	addi	sp,sp,-16
    80000fa8:	e406                	sd	ra,8(sp)
    80000faa:	e022                	sd	s0,0(sp)
    80000fac:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fae:	4601                	li	a2,0
    80000fb0:	f51ff0ef          	jal	ra,80000f00 <walk>
  if(pte == 0)
    80000fb4:	c105                	beqz	a0,80000fd4 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fb6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fb8:	0117f693          	andi	a3,a5,17
    80000fbc:	4745                	li	a4,17
    return 0;
    80000fbe:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fc0:	00e68663          	beq	a3,a4,80000fcc <walkaddr+0x32>
}
    80000fc4:	60a2                	ld	ra,8(sp)
    80000fc6:	6402                	ld	s0,0(sp)
    80000fc8:	0141                	addi	sp,sp,16
    80000fca:	8082                	ret
  pa = PTE2PA(*pte);
    80000fcc:	00a7d513          	srli	a0,a5,0xa
    80000fd0:	0532                	slli	a0,a0,0xc
  return pa;
    80000fd2:	bfcd                	j	80000fc4 <walkaddr+0x2a>
    return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	b7fd                	j	80000fc4 <walkaddr+0x2a>

0000000080000fd8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fd8:	715d                	addi	sp,sp,-80
    80000fda:	e486                	sd	ra,72(sp)
    80000fdc:	e0a2                	sd	s0,64(sp)
    80000fde:	fc26                	sd	s1,56(sp)
    80000fe0:	f84a                	sd	s2,48(sp)
    80000fe2:	f44e                	sd	s3,40(sp)
    80000fe4:	f052                	sd	s4,32(sp)
    80000fe6:	ec56                	sd	s5,24(sp)
    80000fe8:	e85a                	sd	s6,16(sp)
    80000fea:	e45e                	sd	s7,8(sp)
    80000fec:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fee:	03459793          	slli	a5,a1,0x34
    80000ff2:	e385                	bnez	a5,80001012 <mappages+0x3a>
    80000ff4:	8aaa                	mv	s5,a0
    80000ff6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000ff8:	03461793          	slli	a5,a2,0x34
    80000ffc:	e38d                	bnez	a5,8000101e <mappages+0x46>
    panic("mappages: size not aligned");

  if(size == 0)
    80000ffe:	c615                	beqz	a2,8000102a <mappages+0x52>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001000:	79fd                	lui	s3,0xfffff
    80001002:	964e                	add	a2,a2,s3
    80001004:	00b609b3          	add	s3,a2,a1
  a = va;
    80001008:	892e                	mv	s2,a1
    8000100a:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000100e:	6b85                	lui	s7,0x1
    80001010:	a815                	j	80001044 <mappages+0x6c>
    panic("mappages: va not aligned");
    80001012:	00006517          	auipc	a0,0x6
    80001016:	0be50513          	addi	a0,a0,190 # 800070d0 <digits+0x98>
    8000101a:	f42ff0ef          	jal	ra,8000075c <panic>
    panic("mappages: size not aligned");
    8000101e:	00006517          	auipc	a0,0x6
    80001022:	0d250513          	addi	a0,a0,210 # 800070f0 <digits+0xb8>
    80001026:	f36ff0ef          	jal	ra,8000075c <panic>
    panic("mappages: size");
    8000102a:	00006517          	auipc	a0,0x6
    8000102e:	0e650513          	addi	a0,a0,230 # 80007110 <digits+0xd8>
    80001032:	f2aff0ef          	jal	ra,8000075c <panic>
      panic("mappages: remap");
    80001036:	00006517          	auipc	a0,0x6
    8000103a:	0ea50513          	addi	a0,a0,234 # 80007120 <digits+0xe8>
    8000103e:	f1eff0ef          	jal	ra,8000075c <panic>
    a += PGSIZE;
    80001042:	995e                	add	s2,s2,s7
  for(;;){
    80001044:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001048:	4605                	li	a2,1
    8000104a:	85ca                	mv	a1,s2
    8000104c:	8556                	mv	a0,s5
    8000104e:	eb3ff0ef          	jal	ra,80000f00 <walk>
    80001052:	cd19                	beqz	a0,80001070 <mappages+0x98>
    if(*pte & PTE_V)
    80001054:	611c                	ld	a5,0(a0)
    80001056:	8b85                	andi	a5,a5,1
    80001058:	fff9                	bnez	a5,80001036 <mappages+0x5e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105a:	80b1                	srli	s1,s1,0xc
    8000105c:	04aa                	slli	s1,s1,0xa
    8000105e:	0164e4b3          	or	s1,s1,s6
    80001062:	0014e493          	ori	s1,s1,1
    80001066:	e104                	sd	s1,0(a0)
    if(a == last)
    80001068:	fd391de3          	bne	s2,s3,80001042 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    8000106c:	4501                	li	a0,0
    8000106e:	a011                	j	80001072 <mappages+0x9a>
      return -1;
    80001070:	557d                	li	a0,-1
}
    80001072:	60a6                	ld	ra,72(sp)
    80001074:	6406                	ld	s0,64(sp)
    80001076:	74e2                	ld	s1,56(sp)
    80001078:	7942                	ld	s2,48(sp)
    8000107a:	79a2                	ld	s3,40(sp)
    8000107c:	7a02                	ld	s4,32(sp)
    8000107e:	6ae2                	ld	s5,24(sp)
    80001080:	6b42                	ld	s6,16(sp)
    80001082:	6ba2                	ld	s7,8(sp)
    80001084:	6161                	addi	sp,sp,80
    80001086:	8082                	ret

0000000080001088 <kvmmap>:
{
    80001088:	1141                	addi	sp,sp,-16
    8000108a:	e406                	sd	ra,8(sp)
    8000108c:	e022                	sd	s0,0(sp)
    8000108e:	0800                	addi	s0,sp,16
    80001090:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001092:	86b2                	mv	a3,a2
    80001094:	863e                	mv	a2,a5
    80001096:	f43ff0ef          	jal	ra,80000fd8 <mappages>
    8000109a:	e509                	bnez	a0,800010a4 <kvmmap+0x1c>
}
    8000109c:	60a2                	ld	ra,8(sp)
    8000109e:	6402                	ld	s0,0(sp)
    800010a0:	0141                	addi	sp,sp,16
    800010a2:	8082                	ret
    panic("kvmmap");
    800010a4:	00006517          	auipc	a0,0x6
    800010a8:	08c50513          	addi	a0,a0,140 # 80007130 <digits+0xf8>
    800010ac:	eb0ff0ef          	jal	ra,8000075c <panic>

00000000800010b0 <kvmmake>:
{
    800010b0:	1101                	addi	sp,sp,-32
    800010b2:	ec06                	sd	ra,24(sp)
    800010b4:	e822                	sd	s0,16(sp)
    800010b6:	e426                	sd	s1,8(sp)
    800010b8:	e04a                	sd	s2,0(sp)
    800010ba:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010bc:	a1dff0ef          	jal	ra,80000ad8 <kalloc>
    800010c0:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010c2:	6605                	lui	a2,0x1
    800010c4:	4581                	li	a1,0
    800010c6:	bb7ff0ef          	jal	ra,80000c7c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010ca:	4719                	li	a4,6
    800010cc:	6685                	lui	a3,0x1
    800010ce:	10000637          	lui	a2,0x10000
    800010d2:	100005b7          	lui	a1,0x10000
    800010d6:	8526                	mv	a0,s1
    800010d8:	fb1ff0ef          	jal	ra,80001088 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010dc:	4719                	li	a4,6
    800010de:	6685                	lui	a3,0x1
    800010e0:	10001637          	lui	a2,0x10001
    800010e4:	100015b7          	lui	a1,0x10001
    800010e8:	8526                	mv	a0,s1
    800010ea:	f9fff0ef          	jal	ra,80001088 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010ee:	4719                	li	a4,6
    800010f0:	040006b7          	lui	a3,0x4000
    800010f4:	0c000637          	lui	a2,0xc000
    800010f8:	0c0005b7          	lui	a1,0xc000
    800010fc:	8526                	mv	a0,s1
    800010fe:	f8bff0ef          	jal	ra,80001088 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001102:	00006917          	auipc	s2,0x6
    80001106:	efe90913          	addi	s2,s2,-258 # 80007000 <etext>
    8000110a:	4729                	li	a4,10
    8000110c:	80006697          	auipc	a3,0x80006
    80001110:	ef468693          	addi	a3,a3,-268 # 7000 <_entry-0x7fff9000>
    80001114:	4605                	li	a2,1
    80001116:	067e                	slli	a2,a2,0x1f
    80001118:	85b2                	mv	a1,a2
    8000111a:	8526                	mv	a0,s1
    8000111c:	f6dff0ef          	jal	ra,80001088 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001120:	4719                	li	a4,6
    80001122:	46c5                	li	a3,17
    80001124:	06ee                	slli	a3,a3,0x1b
    80001126:	412686b3          	sub	a3,a3,s2
    8000112a:	864a                	mv	a2,s2
    8000112c:	85ca                	mv	a1,s2
    8000112e:	8526                	mv	a0,s1
    80001130:	f59ff0ef          	jal	ra,80001088 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001134:	4729                	li	a4,10
    80001136:	6685                	lui	a3,0x1
    80001138:	00005617          	auipc	a2,0x5
    8000113c:	ec860613          	addi	a2,a2,-312 # 80006000 <_trampoline>
    80001140:	040005b7          	lui	a1,0x4000
    80001144:	15fd                	addi	a1,a1,-1
    80001146:	05b2                	slli	a1,a1,0xc
    80001148:	8526                	mv	a0,s1
    8000114a:	f3fff0ef          	jal	ra,80001088 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000114e:	8526                	mv	a0,s1
    80001150:	592000ef          	jal	ra,800016e2 <proc_mapstacks>
}
    80001154:	8526                	mv	a0,s1
    80001156:	60e2                	ld	ra,24(sp)
    80001158:	6442                	ld	s0,16(sp)
    8000115a:	64a2                	ld	s1,8(sp)
    8000115c:	6902                	ld	s2,0(sp)
    8000115e:	6105                	addi	sp,sp,32
    80001160:	8082                	ret

0000000080001162 <kvminit>:
{
    80001162:	1141                	addi	sp,sp,-16
    80001164:	e406                	sd	ra,8(sp)
    80001166:	e022                	sd	s0,0(sp)
    80001168:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000116a:	f47ff0ef          	jal	ra,800010b0 <kvmmake>
    8000116e:	00006797          	auipc	a5,0x6
    80001172:	7aa7b123          	sd	a0,1954(a5) # 80007910 <kernel_pagetable>
}
    80001176:	60a2                	ld	ra,8(sp)
    80001178:	6402                	ld	s0,0(sp)
    8000117a:	0141                	addi	sp,sp,16
    8000117c:	8082                	ret

000000008000117e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000117e:	715d                	addi	sp,sp,-80
    80001180:	e486                	sd	ra,72(sp)
    80001182:	e0a2                	sd	s0,64(sp)
    80001184:	fc26                	sd	s1,56(sp)
    80001186:	f84a                	sd	s2,48(sp)
    80001188:	f44e                	sd	s3,40(sp)
    8000118a:	f052                	sd	s4,32(sp)
    8000118c:	ec56                	sd	s5,24(sp)
    8000118e:	e85a                	sd	s6,16(sp)
    80001190:	e45e                	sd	s7,8(sp)
    80001192:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001194:	03459793          	slli	a5,a1,0x34
    80001198:	e795                	bnez	a5,800011c4 <uvmunmap+0x46>
    8000119a:	8a2a                	mv	s4,a0
    8000119c:	892e                	mv	s2,a1
    8000119e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011a0:	0632                	slli	a2,a2,0xc
    800011a2:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011a6:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011a8:	6b05                	lui	s6,0x1
    800011aa:	0535ee63          	bltu	a1,s3,80001206 <uvmunmap+0x88>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800011ae:	60a6                	ld	ra,72(sp)
    800011b0:	6406                	ld	s0,64(sp)
    800011b2:	74e2                	ld	s1,56(sp)
    800011b4:	7942                	ld	s2,48(sp)
    800011b6:	79a2                	ld	s3,40(sp)
    800011b8:	7a02                	ld	s4,32(sp)
    800011ba:	6ae2                	ld	s5,24(sp)
    800011bc:	6b42                	ld	s6,16(sp)
    800011be:	6ba2                	ld	s7,8(sp)
    800011c0:	6161                	addi	sp,sp,80
    800011c2:	8082                	ret
    panic("uvmunmap: not aligned");
    800011c4:	00006517          	auipc	a0,0x6
    800011c8:	f7450513          	addi	a0,a0,-140 # 80007138 <digits+0x100>
    800011cc:	d90ff0ef          	jal	ra,8000075c <panic>
      panic("uvmunmap: walk");
    800011d0:	00006517          	auipc	a0,0x6
    800011d4:	f8050513          	addi	a0,a0,-128 # 80007150 <digits+0x118>
    800011d8:	d84ff0ef          	jal	ra,8000075c <panic>
      panic("uvmunmap: not mapped");
    800011dc:	00006517          	auipc	a0,0x6
    800011e0:	f8450513          	addi	a0,a0,-124 # 80007160 <digits+0x128>
    800011e4:	d78ff0ef          	jal	ra,8000075c <panic>
      panic("uvmunmap: not a leaf");
    800011e8:	00006517          	auipc	a0,0x6
    800011ec:	f9050513          	addi	a0,a0,-112 # 80007178 <digits+0x140>
    800011f0:	d6cff0ef          	jal	ra,8000075c <panic>
      uint64 pa = PTE2PA(*pte);
    800011f4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800011f6:	0532                	slli	a0,a0,0xc
    800011f8:	801ff0ef          	jal	ra,800009f8 <kfree>
    *pte = 0;
    800011fc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001200:	995a                	add	s2,s2,s6
    80001202:	fb3976e3          	bgeu	s2,s3,800011ae <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001206:	4601                	li	a2,0
    80001208:	85ca                	mv	a1,s2
    8000120a:	8552                	mv	a0,s4
    8000120c:	cf5ff0ef          	jal	ra,80000f00 <walk>
    80001210:	84aa                	mv	s1,a0
    80001212:	dd5d                	beqz	a0,800011d0 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    80001214:	6108                	ld	a0,0(a0)
    80001216:	00157793          	andi	a5,a0,1
    8000121a:	d3e9                	beqz	a5,800011dc <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000121c:	3ff57793          	andi	a5,a0,1023
    80001220:	fd7784e3          	beq	a5,s7,800011e8 <uvmunmap+0x6a>
    if(do_free){
    80001224:	fc0a8ce3          	beqz	s5,800011fc <uvmunmap+0x7e>
    80001228:	b7f1                	j	800011f4 <uvmunmap+0x76>

000000008000122a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000122a:	1101                	addi	sp,sp,-32
    8000122c:	ec06                	sd	ra,24(sp)
    8000122e:	e822                	sd	s0,16(sp)
    80001230:	e426                	sd	s1,8(sp)
    80001232:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001234:	8a5ff0ef          	jal	ra,80000ad8 <kalloc>
    80001238:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000123a:	c509                	beqz	a0,80001244 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000123c:	6605                	lui	a2,0x1
    8000123e:	4581                	li	a1,0
    80001240:	a3dff0ef          	jal	ra,80000c7c <memset>
  return pagetable;
}
    80001244:	8526                	mv	a0,s1
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	64a2                	ld	s1,8(sp)
    8000124c:	6105                	addi	sp,sp,32
    8000124e:	8082                	ret

0000000080001250 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001250:	7179                	addi	sp,sp,-48
    80001252:	f406                	sd	ra,40(sp)
    80001254:	f022                	sd	s0,32(sp)
    80001256:	ec26                	sd	s1,24(sp)
    80001258:	e84a                	sd	s2,16(sp)
    8000125a:	e44e                	sd	s3,8(sp)
    8000125c:	e052                	sd	s4,0(sp)
    8000125e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001260:	6785                	lui	a5,0x1
    80001262:	04f67063          	bgeu	a2,a5,800012a2 <uvmfirst+0x52>
    80001266:	8a2a                	mv	s4,a0
    80001268:	89ae                	mv	s3,a1
    8000126a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000126c:	86dff0ef          	jal	ra,80000ad8 <kalloc>
    80001270:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001272:	6605                	lui	a2,0x1
    80001274:	4581                	li	a1,0
    80001276:	a07ff0ef          	jal	ra,80000c7c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000127a:	4779                	li	a4,30
    8000127c:	86ca                	mv	a3,s2
    8000127e:	6605                	lui	a2,0x1
    80001280:	4581                	li	a1,0
    80001282:	8552                	mv	a0,s4
    80001284:	d55ff0ef          	jal	ra,80000fd8 <mappages>
  memmove(mem, src, sz);
    80001288:	8626                	mv	a2,s1
    8000128a:	85ce                	mv	a1,s3
    8000128c:	854a                	mv	a0,s2
    8000128e:	a4fff0ef          	jal	ra,80000cdc <memmove>
}
    80001292:	70a2                	ld	ra,40(sp)
    80001294:	7402                	ld	s0,32(sp)
    80001296:	64e2                	ld	s1,24(sp)
    80001298:	6942                	ld	s2,16(sp)
    8000129a:	69a2                	ld	s3,8(sp)
    8000129c:	6a02                	ld	s4,0(sp)
    8000129e:	6145                	addi	sp,sp,48
    800012a0:	8082                	ret
    panic("uvmfirst: more than a page");
    800012a2:	00006517          	auipc	a0,0x6
    800012a6:	eee50513          	addi	a0,a0,-274 # 80007190 <digits+0x158>
    800012aa:	cb2ff0ef          	jal	ra,8000075c <panic>

00000000800012ae <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012ae:	1101                	addi	sp,sp,-32
    800012b0:	ec06                	sd	ra,24(sp)
    800012b2:	e822                	sd	s0,16(sp)
    800012b4:	e426                	sd	s1,8(sp)
    800012b6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012b8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012ba:	00b67d63          	bgeu	a2,a1,800012d4 <uvmdealloc+0x26>
    800012be:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012c0:	6785                	lui	a5,0x1
    800012c2:	17fd                	addi	a5,a5,-1
    800012c4:	00f60733          	add	a4,a2,a5
    800012c8:	767d                	lui	a2,0xfffff
    800012ca:	8f71                	and	a4,a4,a2
    800012cc:	97ae                	add	a5,a5,a1
    800012ce:	8ff1                	and	a5,a5,a2
    800012d0:	00f76863          	bltu	a4,a5,800012e0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012d4:	8526                	mv	a0,s1
    800012d6:	60e2                	ld	ra,24(sp)
    800012d8:	6442                	ld	s0,16(sp)
    800012da:	64a2                	ld	s1,8(sp)
    800012dc:	6105                	addi	sp,sp,32
    800012de:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012e0:	8f99                	sub	a5,a5,a4
    800012e2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012e4:	4685                	li	a3,1
    800012e6:	0007861b          	sext.w	a2,a5
    800012ea:	85ba                	mv	a1,a4
    800012ec:	e93ff0ef          	jal	ra,8000117e <uvmunmap>
    800012f0:	b7d5                	j	800012d4 <uvmdealloc+0x26>

00000000800012f2 <uvmalloc>:
  if(newsz < oldsz)
    800012f2:	08b66963          	bltu	a2,a1,80001384 <uvmalloc+0x92>
{
    800012f6:	7139                	addi	sp,sp,-64
    800012f8:	fc06                	sd	ra,56(sp)
    800012fa:	f822                	sd	s0,48(sp)
    800012fc:	f426                	sd	s1,40(sp)
    800012fe:	f04a                	sd	s2,32(sp)
    80001300:	ec4e                	sd	s3,24(sp)
    80001302:	e852                	sd	s4,16(sp)
    80001304:	e456                	sd	s5,8(sp)
    80001306:	e05a                	sd	s6,0(sp)
    80001308:	0080                	addi	s0,sp,64
    8000130a:	8aaa                	mv	s5,a0
    8000130c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000130e:	6985                	lui	s3,0x1
    80001310:	19fd                	addi	s3,s3,-1
    80001312:	95ce                	add	a1,a1,s3
    80001314:	79fd                	lui	s3,0xfffff
    80001316:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000131a:	06c9f763          	bgeu	s3,a2,80001388 <uvmalloc+0x96>
    8000131e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001320:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001324:	fb4ff0ef          	jal	ra,80000ad8 <kalloc>
    80001328:	84aa                	mv	s1,a0
    if(mem == 0){
    8000132a:	c11d                	beqz	a0,80001350 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    8000132c:	6605                	lui	a2,0x1
    8000132e:	4581                	li	a1,0
    80001330:	94dff0ef          	jal	ra,80000c7c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001334:	875a                	mv	a4,s6
    80001336:	86a6                	mv	a3,s1
    80001338:	6605                	lui	a2,0x1
    8000133a:	85ca                	mv	a1,s2
    8000133c:	8556                	mv	a0,s5
    8000133e:	c9bff0ef          	jal	ra,80000fd8 <mappages>
    80001342:	e51d                	bnez	a0,80001370 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001344:	6785                	lui	a5,0x1
    80001346:	993e                	add	s2,s2,a5
    80001348:	fd496ee3          	bltu	s2,s4,80001324 <uvmalloc+0x32>
  return newsz;
    8000134c:	8552                	mv	a0,s4
    8000134e:	a039                	j	8000135c <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001350:	864e                	mv	a2,s3
    80001352:	85ca                	mv	a1,s2
    80001354:	8556                	mv	a0,s5
    80001356:	f59ff0ef          	jal	ra,800012ae <uvmdealloc>
      return 0;
    8000135a:	4501                	li	a0,0
}
    8000135c:	70e2                	ld	ra,56(sp)
    8000135e:	7442                	ld	s0,48(sp)
    80001360:	74a2                	ld	s1,40(sp)
    80001362:	7902                	ld	s2,32(sp)
    80001364:	69e2                	ld	s3,24(sp)
    80001366:	6a42                	ld	s4,16(sp)
    80001368:	6aa2                	ld	s5,8(sp)
    8000136a:	6b02                	ld	s6,0(sp)
    8000136c:	6121                	addi	sp,sp,64
    8000136e:	8082                	ret
      kfree(mem);
    80001370:	8526                	mv	a0,s1
    80001372:	e86ff0ef          	jal	ra,800009f8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001376:	864e                	mv	a2,s3
    80001378:	85ca                	mv	a1,s2
    8000137a:	8556                	mv	a0,s5
    8000137c:	f33ff0ef          	jal	ra,800012ae <uvmdealloc>
      return 0;
    80001380:	4501                	li	a0,0
    80001382:	bfe9                	j	8000135c <uvmalloc+0x6a>
    return oldsz;
    80001384:	852e                	mv	a0,a1
}
    80001386:	8082                	ret
  return newsz;
    80001388:	8532                	mv	a0,a2
    8000138a:	bfc9                	j	8000135c <uvmalloc+0x6a>

000000008000138c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000138c:	7179                	addi	sp,sp,-48
    8000138e:	f406                	sd	ra,40(sp)
    80001390:	f022                	sd	s0,32(sp)
    80001392:	ec26                	sd	s1,24(sp)
    80001394:	e84a                	sd	s2,16(sp)
    80001396:	e44e                	sd	s3,8(sp)
    80001398:	e052                	sd	s4,0(sp)
    8000139a:	1800                	addi	s0,sp,48
    8000139c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000139e:	84aa                	mv	s1,a0
    800013a0:	6905                	lui	s2,0x1
    800013a2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013a4:	4985                	li	s3,1
    800013a6:	a811                	j	800013ba <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800013a8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800013aa:	0532                	slli	a0,a0,0xc
    800013ac:	fe1ff0ef          	jal	ra,8000138c <freewalk>
      pagetable[i] = 0;
    800013b0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013b4:	04a1                	addi	s1,s1,8
    800013b6:	01248f63          	beq	s1,s2,800013d4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013ba:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013bc:	00f57793          	andi	a5,a0,15
    800013c0:	ff3784e3          	beq	a5,s3,800013a8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013c4:	8905                	andi	a0,a0,1
    800013c6:	d57d                	beqz	a0,800013b4 <freewalk+0x28>
      panic("freewalk: leaf");
    800013c8:	00006517          	auipc	a0,0x6
    800013cc:	de850513          	addi	a0,a0,-536 # 800071b0 <digits+0x178>
    800013d0:	b8cff0ef          	jal	ra,8000075c <panic>
    }
  }
  kfree((void*)pagetable);
    800013d4:	8552                	mv	a0,s4
    800013d6:	e22ff0ef          	jal	ra,800009f8 <kfree>
}
    800013da:	70a2                	ld	ra,40(sp)
    800013dc:	7402                	ld	s0,32(sp)
    800013de:	64e2                	ld	s1,24(sp)
    800013e0:	6942                	ld	s2,16(sp)
    800013e2:	69a2                	ld	s3,8(sp)
    800013e4:	6a02                	ld	s4,0(sp)
    800013e6:	6145                	addi	sp,sp,48
    800013e8:	8082                	ret

00000000800013ea <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013ea:	1101                	addi	sp,sp,-32
    800013ec:	ec06                	sd	ra,24(sp)
    800013ee:	e822                	sd	s0,16(sp)
    800013f0:	e426                	sd	s1,8(sp)
    800013f2:	1000                	addi	s0,sp,32
    800013f4:	84aa                	mv	s1,a0
  if(sz > 0)
    800013f6:	e989                	bnez	a1,80001408 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013f8:	8526                	mv	a0,s1
    800013fa:	f93ff0ef          	jal	ra,8000138c <freewalk>
}
    800013fe:	60e2                	ld	ra,24(sp)
    80001400:	6442                	ld	s0,16(sp)
    80001402:	64a2                	ld	s1,8(sp)
    80001404:	6105                	addi	sp,sp,32
    80001406:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001408:	6605                	lui	a2,0x1
    8000140a:	167d                	addi	a2,a2,-1
    8000140c:	962e                	add	a2,a2,a1
    8000140e:	4685                	li	a3,1
    80001410:	8231                	srli	a2,a2,0xc
    80001412:	4581                	li	a1,0
    80001414:	d6bff0ef          	jal	ra,8000117e <uvmunmap>
    80001418:	b7c5                	j	800013f8 <uvmfree+0xe>

000000008000141a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000141a:	c65d                	beqz	a2,800014c8 <uvmcopy+0xae>
{
    8000141c:	715d                	addi	sp,sp,-80
    8000141e:	e486                	sd	ra,72(sp)
    80001420:	e0a2                	sd	s0,64(sp)
    80001422:	fc26                	sd	s1,56(sp)
    80001424:	f84a                	sd	s2,48(sp)
    80001426:	f44e                	sd	s3,40(sp)
    80001428:	f052                	sd	s4,32(sp)
    8000142a:	ec56                	sd	s5,24(sp)
    8000142c:	e85a                	sd	s6,16(sp)
    8000142e:	e45e                	sd	s7,8(sp)
    80001430:	0880                	addi	s0,sp,80
    80001432:	8b2a                	mv	s6,a0
    80001434:	8aae                	mv	s5,a1
    80001436:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001438:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000143a:	4601                	li	a2,0
    8000143c:	85ce                	mv	a1,s3
    8000143e:	855a                	mv	a0,s6
    80001440:	ac1ff0ef          	jal	ra,80000f00 <walk>
    80001444:	c121                	beqz	a0,80001484 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001446:	6118                	ld	a4,0(a0)
    80001448:	00177793          	andi	a5,a4,1
    8000144c:	c3b1                	beqz	a5,80001490 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000144e:	00a75593          	srli	a1,a4,0xa
    80001452:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001456:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000145a:	e7eff0ef          	jal	ra,80000ad8 <kalloc>
    8000145e:	892a                	mv	s2,a0
    80001460:	c129                	beqz	a0,800014a2 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001462:	6605                	lui	a2,0x1
    80001464:	85de                	mv	a1,s7
    80001466:	877ff0ef          	jal	ra,80000cdc <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000146a:	8726                	mv	a4,s1
    8000146c:	86ca                	mv	a3,s2
    8000146e:	6605                	lui	a2,0x1
    80001470:	85ce                	mv	a1,s3
    80001472:	8556                	mv	a0,s5
    80001474:	b65ff0ef          	jal	ra,80000fd8 <mappages>
    80001478:	e115                	bnez	a0,8000149c <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000147a:	6785                	lui	a5,0x1
    8000147c:	99be                	add	s3,s3,a5
    8000147e:	fb49eee3          	bltu	s3,s4,8000143a <uvmcopy+0x20>
    80001482:	a805                	j	800014b2 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001484:	00006517          	auipc	a0,0x6
    80001488:	d3c50513          	addi	a0,a0,-708 # 800071c0 <digits+0x188>
    8000148c:	ad0ff0ef          	jal	ra,8000075c <panic>
      panic("uvmcopy: page not present");
    80001490:	00006517          	auipc	a0,0x6
    80001494:	d5050513          	addi	a0,a0,-688 # 800071e0 <digits+0x1a8>
    80001498:	ac4ff0ef          	jal	ra,8000075c <panic>
      kfree(mem);
    8000149c:	854a                	mv	a0,s2
    8000149e:	d5aff0ef          	jal	ra,800009f8 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014a2:	4685                	li	a3,1
    800014a4:	00c9d613          	srli	a2,s3,0xc
    800014a8:	4581                	li	a1,0
    800014aa:	8556                	mv	a0,s5
    800014ac:	cd3ff0ef          	jal	ra,8000117e <uvmunmap>
  return -1;
    800014b0:	557d                	li	a0,-1
}
    800014b2:	60a6                	ld	ra,72(sp)
    800014b4:	6406                	ld	s0,64(sp)
    800014b6:	74e2                	ld	s1,56(sp)
    800014b8:	7942                	ld	s2,48(sp)
    800014ba:	79a2                	ld	s3,40(sp)
    800014bc:	7a02                	ld	s4,32(sp)
    800014be:	6ae2                	ld	s5,24(sp)
    800014c0:	6b42                	ld	s6,16(sp)
    800014c2:	6ba2                	ld	s7,8(sp)
    800014c4:	6161                	addi	sp,sp,80
    800014c6:	8082                	ret
  return 0;
    800014c8:	4501                	li	a0,0
}
    800014ca:	8082                	ret

00000000800014cc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014cc:	1141                	addi	sp,sp,-16
    800014ce:	e406                	sd	ra,8(sp)
    800014d0:	e022                	sd	s0,0(sp)
    800014d2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014d4:	4601                	li	a2,0
    800014d6:	a2bff0ef          	jal	ra,80000f00 <walk>
  if(pte == 0)
    800014da:	c901                	beqz	a0,800014ea <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014dc:	611c                	ld	a5,0(a0)
    800014de:	9bbd                	andi	a5,a5,-17
    800014e0:	e11c                	sd	a5,0(a0)
}
    800014e2:	60a2                	ld	ra,8(sp)
    800014e4:	6402                	ld	s0,0(sp)
    800014e6:	0141                	addi	sp,sp,16
    800014e8:	8082                	ret
    panic("uvmclear");
    800014ea:	00006517          	auipc	a0,0x6
    800014ee:	d1650513          	addi	a0,a0,-746 # 80007200 <digits+0x1c8>
    800014f2:	a6aff0ef          	jal	ra,8000075c <panic>

00000000800014f6 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800014f6:	c6c9                	beqz	a3,80001580 <copyout+0x8a>
{
    800014f8:	711d                	addi	sp,sp,-96
    800014fa:	ec86                	sd	ra,88(sp)
    800014fc:	e8a2                	sd	s0,80(sp)
    800014fe:	e4a6                	sd	s1,72(sp)
    80001500:	e0ca                	sd	s2,64(sp)
    80001502:	fc4e                	sd	s3,56(sp)
    80001504:	f852                	sd	s4,48(sp)
    80001506:	f456                	sd	s5,40(sp)
    80001508:	f05a                	sd	s6,32(sp)
    8000150a:	ec5e                	sd	s7,24(sp)
    8000150c:	e862                	sd	s8,16(sp)
    8000150e:	e466                	sd	s9,8(sp)
    80001510:	e06a                	sd	s10,0(sp)
    80001512:	1080                	addi	s0,sp,96
    80001514:	8baa                	mv	s7,a0
    80001516:	8aae                	mv	s5,a1
    80001518:	8b32                	mv	s6,a2
    8000151a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000151c:	74fd                	lui	s1,0xfffff
    8000151e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001520:	57fd                	li	a5,-1
    80001522:	83e9                	srli	a5,a5,0x1a
    80001524:	0697e063          	bltu	a5,s1,80001584 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001528:	4cd5                	li	s9,21
    8000152a:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000152c:	8c3e                	mv	s8,a5
    8000152e:	a025                	j	80001556 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001530:	83a9                	srli	a5,a5,0xa
    80001532:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001534:	409a8533          	sub	a0,s5,s1
    80001538:	0009061b          	sext.w	a2,s2
    8000153c:	85da                	mv	a1,s6
    8000153e:	953e                	add	a0,a0,a5
    80001540:	f9cff0ef          	jal	ra,80000cdc <memmove>

    len -= n;
    80001544:	412989b3          	sub	s3,s3,s2
    src += n;
    80001548:	9b4a                	add	s6,s6,s2
  while(len > 0){
    8000154a:	02098963          	beqz	s3,8000157c <copyout+0x86>
    if(va0 >= MAXVA)
    8000154e:	034c6d63          	bltu	s8,s4,80001588 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80001552:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001554:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001556:	4601                	li	a2,0
    80001558:	85a6                	mv	a1,s1
    8000155a:	855e                	mv	a0,s7
    8000155c:	9a5ff0ef          	jal	ra,80000f00 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001560:	c515                	beqz	a0,8000158c <copyout+0x96>
    80001562:	611c                	ld	a5,0(a0)
    80001564:	0157f713          	andi	a4,a5,21
    80001568:	05971163          	bne	a4,s9,800015aa <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    8000156c:	01a48a33          	add	s4,s1,s10
    80001570:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001574:	fb29fee3          	bgeu	s3,s2,80001530 <copyout+0x3a>
    80001578:	894e                	mv	s2,s3
    8000157a:	bf5d                	j	80001530 <copyout+0x3a>
  }
  return 0;
    8000157c:	4501                	li	a0,0
    8000157e:	a801                	j	8000158e <copyout+0x98>
    80001580:	4501                	li	a0,0
}
    80001582:	8082                	ret
      return -1;
    80001584:	557d                	li	a0,-1
    80001586:	a021                	j	8000158e <copyout+0x98>
    80001588:	557d                	li	a0,-1
    8000158a:	a011                	j	8000158e <copyout+0x98>
      return -1;
    8000158c:	557d                	li	a0,-1
}
    8000158e:	60e6                	ld	ra,88(sp)
    80001590:	6446                	ld	s0,80(sp)
    80001592:	64a6                	ld	s1,72(sp)
    80001594:	6906                	ld	s2,64(sp)
    80001596:	79e2                	ld	s3,56(sp)
    80001598:	7a42                	ld	s4,48(sp)
    8000159a:	7aa2                	ld	s5,40(sp)
    8000159c:	7b02                	ld	s6,32(sp)
    8000159e:	6be2                	ld	s7,24(sp)
    800015a0:	6c42                	ld	s8,16(sp)
    800015a2:	6ca2                	ld	s9,8(sp)
    800015a4:	6d02                	ld	s10,0(sp)
    800015a6:	6125                	addi	sp,sp,96
    800015a8:	8082                	ret
      return -1;
    800015aa:	557d                	li	a0,-1
    800015ac:	b7cd                	j	8000158e <copyout+0x98>

00000000800015ae <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015ae:	c2bd                	beqz	a3,80001614 <copyin+0x66>
{
    800015b0:	715d                	addi	sp,sp,-80
    800015b2:	e486                	sd	ra,72(sp)
    800015b4:	e0a2                	sd	s0,64(sp)
    800015b6:	fc26                	sd	s1,56(sp)
    800015b8:	f84a                	sd	s2,48(sp)
    800015ba:	f44e                	sd	s3,40(sp)
    800015bc:	f052                	sd	s4,32(sp)
    800015be:	ec56                	sd	s5,24(sp)
    800015c0:	e85a                	sd	s6,16(sp)
    800015c2:	e45e                	sd	s7,8(sp)
    800015c4:	e062                	sd	s8,0(sp)
    800015c6:	0880                	addi	s0,sp,80
    800015c8:	8b2a                	mv	s6,a0
    800015ca:	8a2e                	mv	s4,a1
    800015cc:	8c32                	mv	s8,a2
    800015ce:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015d0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015d2:	6a85                	lui	s5,0x1
    800015d4:	a005                	j	800015f4 <copyin+0x46>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015d6:	9562                	add	a0,a0,s8
    800015d8:	0004861b          	sext.w	a2,s1
    800015dc:	412505b3          	sub	a1,a0,s2
    800015e0:	8552                	mv	a0,s4
    800015e2:	efaff0ef          	jal	ra,80000cdc <memmove>

    len -= n;
    800015e6:	409989b3          	sub	s3,s3,s1
    dst += n;
    800015ea:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800015ec:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015f0:	02098063          	beqz	s3,80001610 <copyin+0x62>
    va0 = PGROUNDDOWN(srcva);
    800015f4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015f8:	85ca                	mv	a1,s2
    800015fa:	855a                	mv	a0,s6
    800015fc:	99fff0ef          	jal	ra,80000f9a <walkaddr>
    if(pa0 == 0)
    80001600:	cd01                	beqz	a0,80001618 <copyin+0x6a>
    n = PGSIZE - (srcva - va0);
    80001602:	418904b3          	sub	s1,s2,s8
    80001606:	94d6                	add	s1,s1,s5
    if(n > len)
    80001608:	fc99f7e3          	bgeu	s3,s1,800015d6 <copyin+0x28>
    8000160c:	84ce                	mv	s1,s3
    8000160e:	b7e1                	j	800015d6 <copyin+0x28>
  }
  return 0;
    80001610:	4501                	li	a0,0
    80001612:	a021                	j	8000161a <copyin+0x6c>
    80001614:	4501                	li	a0,0
}
    80001616:	8082                	ret
      return -1;
    80001618:	557d                	li	a0,-1
}
    8000161a:	60a6                	ld	ra,72(sp)
    8000161c:	6406                	ld	s0,64(sp)
    8000161e:	74e2                	ld	s1,56(sp)
    80001620:	7942                	ld	s2,48(sp)
    80001622:	79a2                	ld	s3,40(sp)
    80001624:	7a02                	ld	s4,32(sp)
    80001626:	6ae2                	ld	s5,24(sp)
    80001628:	6b42                	ld	s6,16(sp)
    8000162a:	6ba2                	ld	s7,8(sp)
    8000162c:	6c02                	ld	s8,0(sp)
    8000162e:	6161                	addi	sp,sp,80
    80001630:	8082                	ret

0000000080001632 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001632:	c2d5                	beqz	a3,800016d6 <copyinstr+0xa4>
{
    80001634:	715d                	addi	sp,sp,-80
    80001636:	e486                	sd	ra,72(sp)
    80001638:	e0a2                	sd	s0,64(sp)
    8000163a:	fc26                	sd	s1,56(sp)
    8000163c:	f84a                	sd	s2,48(sp)
    8000163e:	f44e                	sd	s3,40(sp)
    80001640:	f052                	sd	s4,32(sp)
    80001642:	ec56                	sd	s5,24(sp)
    80001644:	e85a                	sd	s6,16(sp)
    80001646:	e45e                	sd	s7,8(sp)
    80001648:	0880                	addi	s0,sp,80
    8000164a:	8a2a                	mv	s4,a0
    8000164c:	8b2e                	mv	s6,a1
    8000164e:	8bb2                	mv	s7,a2
    80001650:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001652:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001654:	6985                	lui	s3,0x1
    80001656:	a035                	j	80001682 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001658:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000165c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000165e:	0017b793          	seqz	a5,a5
    80001662:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
    srcva = va0 + PGSIZE;
    8000167c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001680:	c4b9                	beqz	s1,800016ce <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001682:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001686:	85ca                	mv	a1,s2
    80001688:	8552                	mv	a0,s4
    8000168a:	911ff0ef          	jal	ra,80000f9a <walkaddr>
    if(pa0 == 0)
    8000168e:	c131                	beqz	a0,800016d2 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001690:	41790833          	sub	a6,s2,s7
    80001694:	984e                	add	a6,a6,s3
    if(n > max)
    80001696:	0104f363          	bgeu	s1,a6,8000169c <copyinstr+0x6a>
    8000169a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000169c:	955e                	add	a0,a0,s7
    8000169e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016a2:	fc080de3          	beqz	a6,8000167c <copyinstr+0x4a>
    800016a6:	985a                	add	a6,a6,s6
    800016a8:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016aa:	41650633          	sub	a2,a0,s6
    800016ae:	14fd                	addi	s1,s1,-1
    800016b0:	9b26                	add	s6,s6,s1
    800016b2:	00f60733          	add	a4,a2,a5
    800016b6:	00074703          	lbu	a4,0(a4)
    800016ba:	df59                	beqz	a4,80001658 <copyinstr+0x26>
        *dst = *p;
    800016bc:	00e78023          	sb	a4,0(a5)
      --max;
    800016c0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016c4:	0785                	addi	a5,a5,1
    while(n > 0){
    800016c6:	ff0796e3          	bne	a5,a6,800016b2 <copyinstr+0x80>
      dst++;
    800016ca:	8b42                	mv	s6,a6
    800016cc:	bf45                	j	8000167c <copyinstr+0x4a>
    800016ce:	4781                	li	a5,0
    800016d0:	b779                	j	8000165e <copyinstr+0x2c>
      return -1;
    800016d2:	557d                	li	a0,-1
    800016d4:	bf49                	j	80001666 <copyinstr+0x34>
  int got_null = 0;
    800016d6:	4781                	li	a5,0
  if(got_null){
    800016d8:	0017b793          	seqz	a5,a5
    800016dc:	40f00533          	neg	a0,a5
}
    800016e0:	8082                	ret

00000000800016e2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	e05a                	sd	s6,0(sp)
    800016f4:	0080                	addi	s0,sp,64
    800016f6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	0000e497          	auipc	s1,0xe
    800016fc:	78848493          	addi	s1,s1,1928 # 8000fe80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001700:	8b26                	mv	s6,s1
    80001702:	00006a97          	auipc	s5,0x6
    80001706:	8fea8a93          	addi	s5,s5,-1794 # 80007000 <etext>
    8000170a:	04000937          	lui	s2,0x4000
    8000170e:	197d                	addi	s2,s2,-1
    80001710:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001712:	00014a17          	auipc	s4,0x14
    80001716:	16ea0a13          	addi	s4,s4,366 # 80015880 <tickslock>
    char *pa = kalloc();
    8000171a:	bbeff0ef          	jal	ra,80000ad8 <kalloc>
    8000171e:	862a                	mv	a2,a0
    if(pa == 0)
    80001720:	c121                	beqz	a0,80001760 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80001722:	416485b3          	sub	a1,s1,s6
    80001726:	858d                	srai	a1,a1,0x3
    80001728:	000ab783          	ld	a5,0(s5)
    8000172c:	02f585b3          	mul	a1,a1,a5
    80001730:	2585                	addiw	a1,a1,1
    80001732:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001736:	4719                	li	a4,6
    80001738:	6685                	lui	a3,0x1
    8000173a:	40b905b3          	sub	a1,s2,a1
    8000173e:	854e                	mv	a0,s3
    80001740:	949ff0ef          	jal	ra,80001088 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001744:	16848493          	addi	s1,s1,360
    80001748:	fd4499e3          	bne	s1,s4,8000171a <proc_mapstacks+0x38>
  }
}
    8000174c:	70e2                	ld	ra,56(sp)
    8000174e:	7442                	ld	s0,48(sp)
    80001750:	74a2                	ld	s1,40(sp)
    80001752:	7902                	ld	s2,32(sp)
    80001754:	69e2                	ld	s3,24(sp)
    80001756:	6a42                	ld	s4,16(sp)
    80001758:	6aa2                	ld	s5,8(sp)
    8000175a:	6b02                	ld	s6,0(sp)
    8000175c:	6121                	addi	sp,sp,64
    8000175e:	8082                	ret
      panic("kalloc");
    80001760:	00006517          	auipc	a0,0x6
    80001764:	ab050513          	addi	a0,a0,-1360 # 80007210 <digits+0x1d8>
    80001768:	ff5fe0ef          	jal	ra,8000075c <panic>

000000008000176c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000176c:	7139                	addi	sp,sp,-64
    8000176e:	fc06                	sd	ra,56(sp)
    80001770:	f822                	sd	s0,48(sp)
    80001772:	f426                	sd	s1,40(sp)
    80001774:	f04a                	sd	s2,32(sp)
    80001776:	ec4e                	sd	s3,24(sp)
    80001778:	e852                	sd	s4,16(sp)
    8000177a:	e456                	sd	s5,8(sp)
    8000177c:	e05a                	sd	s6,0(sp)
    8000177e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001780:	00006597          	auipc	a1,0x6
    80001784:	a9858593          	addi	a1,a1,-1384 # 80007218 <digits+0x1e0>
    80001788:	0000e517          	auipc	a0,0xe
    8000178c:	2c850513          	addi	a0,a0,712 # 8000fa50 <pid_lock>
    80001790:	b98ff0ef          	jal	ra,80000b28 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001794:	00006597          	auipc	a1,0x6
    80001798:	a8c58593          	addi	a1,a1,-1396 # 80007220 <digits+0x1e8>
    8000179c:	0000e517          	auipc	a0,0xe
    800017a0:	2cc50513          	addi	a0,a0,716 # 8000fa68 <wait_lock>
    800017a4:	b84ff0ef          	jal	ra,80000b28 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	0000e497          	auipc	s1,0xe
    800017ac:	6d848493          	addi	s1,s1,1752 # 8000fe80 <proc>
      initlock(&p->lock, "proc");
    800017b0:	00006b17          	auipc	s6,0x6
    800017b4:	a80b0b13          	addi	s6,s6,-1408 # 80007230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017b8:	8aa6                	mv	s5,s1
    800017ba:	00006a17          	auipc	s4,0x6
    800017be:	846a0a13          	addi	s4,s4,-1978 # 80007000 <etext>
    800017c2:	04000937          	lui	s2,0x4000
    800017c6:	197d                	addi	s2,s2,-1
    800017c8:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ca:	00014997          	auipc	s3,0x14
    800017ce:	0b698993          	addi	s3,s3,182 # 80015880 <tickslock>
      initlock(&p->lock, "proc");
    800017d2:	85da                	mv	a1,s6
    800017d4:	8526                	mv	a0,s1
    800017d6:	b52ff0ef          	jal	ra,80000b28 <initlock>
      p->state = UNUSED;
    800017da:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017de:	415487b3          	sub	a5,s1,s5
    800017e2:	878d                	srai	a5,a5,0x3
    800017e4:	000a3703          	ld	a4,0(s4)
    800017e8:	02e787b3          	mul	a5,a5,a4
    800017ec:	2785                	addiw	a5,a5,1
    800017ee:	00d7979b          	slliw	a5,a5,0xd
    800017f2:	40f907b3          	sub	a5,s2,a5
    800017f6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f8:	16848493          	addi	s1,s1,360
    800017fc:	fd349be3          	bne	s1,s3,800017d2 <procinit+0x66>
  }
}
    80001800:	70e2                	ld	ra,56(sp)
    80001802:	7442                	ld	s0,48(sp)
    80001804:	74a2                	ld	s1,40(sp)
    80001806:	7902                	ld	s2,32(sp)
    80001808:	69e2                	ld	s3,24(sp)
    8000180a:	6a42                	ld	s4,16(sp)
    8000180c:	6aa2                	ld	s5,8(sp)
    8000180e:	6b02                	ld	s6,0(sp)
    80001810:	6121                	addi	sp,sp,64
    80001812:	8082                	ret

0000000080001814 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001814:	1141                	addi	sp,sp,-16
    80001816:	e422                	sd	s0,8(sp)
    80001818:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000181a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000181c:	2501                	sext.w	a0,a0
    8000181e:	6422                	ld	s0,8(sp)
    80001820:	0141                	addi	sp,sp,16
    80001822:	8082                	ret

0000000080001824 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001824:	1141                	addi	sp,sp,-16
    80001826:	e422                	sd	s0,8(sp)
    80001828:	0800                	addi	s0,sp,16
    8000182a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000182c:	2781                	sext.w	a5,a5
    8000182e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001830:	0000e517          	auipc	a0,0xe
    80001834:	25050513          	addi	a0,a0,592 # 8000fa80 <cpus>
    80001838:	953e                	add	a0,a0,a5
    8000183a:	6422                	ld	s0,8(sp)
    8000183c:	0141                	addi	sp,sp,16
    8000183e:	8082                	ret

0000000080001840 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001840:	1101                	addi	sp,sp,-32
    80001842:	ec06                	sd	ra,24(sp)
    80001844:	e822                	sd	s0,16(sp)
    80001846:	e426                	sd	s1,8(sp)
    80001848:	1000                	addi	s0,sp,32
  push_off();
    8000184a:	b1eff0ef          	jal	ra,80000b68 <push_off>
    8000184e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001850:	2781                	sext.w	a5,a5
    80001852:	079e                	slli	a5,a5,0x7
    80001854:	0000e717          	auipc	a4,0xe
    80001858:	1fc70713          	addi	a4,a4,508 # 8000fa50 <pid_lock>
    8000185c:	97ba                	add	a5,a5,a4
    8000185e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001860:	b8cff0ef          	jal	ra,80000bec <pop_off>
  return p;
}
    80001864:	8526                	mv	a0,s1
    80001866:	60e2                	ld	ra,24(sp)
    80001868:	6442                	ld	s0,16(sp)
    8000186a:	64a2                	ld	s1,8(sp)
    8000186c:	6105                	addi	sp,sp,32
    8000186e:	8082                	ret

0000000080001870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001870:	1141                	addi	sp,sp,-16
    80001872:	e406                	sd	ra,8(sp)
    80001874:	e022                	sd	s0,0(sp)
    80001876:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001878:	fc9ff0ef          	jal	ra,80001840 <myproc>
    8000187c:	bc4ff0ef          	jal	ra,80000c40 <release>

  if (first) {
    80001880:	00006797          	auipc	a5,0x6
    80001884:	0007a783          	lw	a5,0(a5) # 80007880 <first.2192>
    80001888:	e799                	bnez	a5,80001896 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000188a:	2b7000ef          	jal	ra,80002340 <usertrapret>
}
    8000188e:	60a2                	ld	ra,8(sp)
    80001890:	6402                	ld	s0,0(sp)
    80001892:	0141                	addi	sp,sp,16
    80001894:	8082                	ret
    fsinit(ROOTDEV);
    80001896:	4505                	li	a0,1
    80001898:	632010ef          	jal	ra,80002eca <fsinit>
    first = 0;
    8000189c:	00006797          	auipc	a5,0x6
    800018a0:	fe07a223          	sw	zero,-28(a5) # 80007880 <first.2192>
    __sync_synchronize();
    800018a4:	0ff0000f          	fence
    800018a8:	b7cd                	j	8000188a <forkret+0x1a>

00000000800018aa <allocpid>:
{
    800018aa:	1101                	addi	sp,sp,-32
    800018ac:	ec06                	sd	ra,24(sp)
    800018ae:	e822                	sd	s0,16(sp)
    800018b0:	e426                	sd	s1,8(sp)
    800018b2:	e04a                	sd	s2,0(sp)
    800018b4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018b6:	0000e917          	auipc	s2,0xe
    800018ba:	19a90913          	addi	s2,s2,410 # 8000fa50 <pid_lock>
    800018be:	854a                	mv	a0,s2
    800018c0:	ae8ff0ef          	jal	ra,80000ba8 <acquire>
  pid = nextpid;
    800018c4:	00006797          	auipc	a5,0x6
    800018c8:	fc078793          	addi	a5,a5,-64 # 80007884 <nextpid>
    800018cc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018ce:	0014871b          	addiw	a4,s1,1
    800018d2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018d4:	854a                	mv	a0,s2
    800018d6:	b6aff0ef          	jal	ra,80000c40 <release>
}
    800018da:	8526                	mv	a0,s1
    800018dc:	60e2                	ld	ra,24(sp)
    800018de:	6442                	ld	s0,16(sp)
    800018e0:	64a2                	ld	s1,8(sp)
    800018e2:	6902                	ld	s2,0(sp)
    800018e4:	6105                	addi	sp,sp,32
    800018e6:	8082                	ret

00000000800018e8 <proc_pagetable>:
{
    800018e8:	1101                	addi	sp,sp,-32
    800018ea:	ec06                	sd	ra,24(sp)
    800018ec:	e822                	sd	s0,16(sp)
    800018ee:	e426                	sd	s1,8(sp)
    800018f0:	e04a                	sd	s2,0(sp)
    800018f2:	1000                	addi	s0,sp,32
    800018f4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018f6:	935ff0ef          	jal	ra,8000122a <uvmcreate>
    800018fa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018fc:	cd05                	beqz	a0,80001934 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018fe:	4729                	li	a4,10
    80001900:	00004697          	auipc	a3,0x4
    80001904:	70068693          	addi	a3,a3,1792 # 80006000 <_trampoline>
    80001908:	6605                	lui	a2,0x1
    8000190a:	040005b7          	lui	a1,0x4000
    8000190e:	15fd                	addi	a1,a1,-1
    80001910:	05b2                	slli	a1,a1,0xc
    80001912:	ec6ff0ef          	jal	ra,80000fd8 <mappages>
    80001916:	02054663          	bltz	a0,80001942 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000191a:	4719                	li	a4,6
    8000191c:	05893683          	ld	a3,88(s2)
    80001920:	6605                	lui	a2,0x1
    80001922:	020005b7          	lui	a1,0x2000
    80001926:	15fd                	addi	a1,a1,-1
    80001928:	05b6                	slli	a1,a1,0xd
    8000192a:	8526                	mv	a0,s1
    8000192c:	eacff0ef          	jal	ra,80000fd8 <mappages>
    80001930:	00054f63          	bltz	a0,8000194e <proc_pagetable+0x66>
}
    80001934:	8526                	mv	a0,s1
    80001936:	60e2                	ld	ra,24(sp)
    80001938:	6442                	ld	s0,16(sp)
    8000193a:	64a2                	ld	s1,8(sp)
    8000193c:	6902                	ld	s2,0(sp)
    8000193e:	6105                	addi	sp,sp,32
    80001940:	8082                	ret
    uvmfree(pagetable, 0);
    80001942:	4581                	li	a1,0
    80001944:	8526                	mv	a0,s1
    80001946:	aa5ff0ef          	jal	ra,800013ea <uvmfree>
    return 0;
    8000194a:	4481                	li	s1,0
    8000194c:	b7e5                	j	80001934 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000194e:	4681                	li	a3,0
    80001950:	4605                	li	a2,1
    80001952:	040005b7          	lui	a1,0x4000
    80001956:	15fd                	addi	a1,a1,-1
    80001958:	05b2                	slli	a1,a1,0xc
    8000195a:	8526                	mv	a0,s1
    8000195c:	823ff0ef          	jal	ra,8000117e <uvmunmap>
    uvmfree(pagetable, 0);
    80001960:	4581                	li	a1,0
    80001962:	8526                	mv	a0,s1
    80001964:	a87ff0ef          	jal	ra,800013ea <uvmfree>
    return 0;
    80001968:	4481                	li	s1,0
    8000196a:	b7e9                	j	80001934 <proc_pagetable+0x4c>

000000008000196c <proc_freepagetable>:
{
    8000196c:	1101                	addi	sp,sp,-32
    8000196e:	ec06                	sd	ra,24(sp)
    80001970:	e822                	sd	s0,16(sp)
    80001972:	e426                	sd	s1,8(sp)
    80001974:	e04a                	sd	s2,0(sp)
    80001976:	1000                	addi	s0,sp,32
    80001978:	84aa                	mv	s1,a0
    8000197a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000197c:	4681                	li	a3,0
    8000197e:	4605                	li	a2,1
    80001980:	040005b7          	lui	a1,0x4000
    80001984:	15fd                	addi	a1,a1,-1
    80001986:	05b2                	slli	a1,a1,0xc
    80001988:	ff6ff0ef          	jal	ra,8000117e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000198c:	4681                	li	a3,0
    8000198e:	4605                	li	a2,1
    80001990:	020005b7          	lui	a1,0x2000
    80001994:	15fd                	addi	a1,a1,-1
    80001996:	05b6                	slli	a1,a1,0xd
    80001998:	8526                	mv	a0,s1
    8000199a:	fe4ff0ef          	jal	ra,8000117e <uvmunmap>
  uvmfree(pagetable, sz);
    8000199e:	85ca                	mv	a1,s2
    800019a0:	8526                	mv	a0,s1
    800019a2:	a49ff0ef          	jal	ra,800013ea <uvmfree>
}
    800019a6:	60e2                	ld	ra,24(sp)
    800019a8:	6442                	ld	s0,16(sp)
    800019aa:	64a2                	ld	s1,8(sp)
    800019ac:	6902                	ld	s2,0(sp)
    800019ae:	6105                	addi	sp,sp,32
    800019b0:	8082                	ret

00000000800019b2 <freeproc>:
{
    800019b2:	1101                	addi	sp,sp,-32
    800019b4:	ec06                	sd	ra,24(sp)
    800019b6:	e822                	sd	s0,16(sp)
    800019b8:	e426                	sd	s1,8(sp)
    800019ba:	1000                	addi	s0,sp,32
    800019bc:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019be:	6d28                	ld	a0,88(a0)
    800019c0:	c119                	beqz	a0,800019c6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019c2:	836ff0ef          	jal	ra,800009f8 <kfree>
  p->trapframe = 0;
    800019c6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019ca:	68a8                	ld	a0,80(s1)
    800019cc:	c501                	beqz	a0,800019d4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019ce:	64ac                	ld	a1,72(s1)
    800019d0:	f9dff0ef          	jal	ra,8000196c <proc_freepagetable>
  p->pagetable = 0;
    800019d4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019d8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019dc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019e0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019e4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800019e8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019ec:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019f0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019f4:	0004ac23          	sw	zero,24(s1)
}
    800019f8:	60e2                	ld	ra,24(sp)
    800019fa:	6442                	ld	s0,16(sp)
    800019fc:	64a2                	ld	s1,8(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret

0000000080001a02 <allocproc>:
{
    80001a02:	1101                	addi	sp,sp,-32
    80001a04:	ec06                	sd	ra,24(sp)
    80001a06:	e822                	sd	s0,16(sp)
    80001a08:	e426                	sd	s1,8(sp)
    80001a0a:	e04a                	sd	s2,0(sp)
    80001a0c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a0e:	0000e497          	auipc	s1,0xe
    80001a12:	47248493          	addi	s1,s1,1138 # 8000fe80 <proc>
    80001a16:	00014917          	auipc	s2,0x14
    80001a1a:	e6a90913          	addi	s2,s2,-406 # 80015880 <tickslock>
    acquire(&p->lock);
    80001a1e:	8526                	mv	a0,s1
    80001a20:	988ff0ef          	jal	ra,80000ba8 <acquire>
    if(p->state == UNUSED) {
    80001a24:	4c9c                	lw	a5,24(s1)
    80001a26:	cb91                	beqz	a5,80001a3a <allocproc+0x38>
      release(&p->lock);
    80001a28:	8526                	mv	a0,s1
    80001a2a:	a16ff0ef          	jal	ra,80000c40 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a2e:	16848493          	addi	s1,s1,360
    80001a32:	ff2496e3          	bne	s1,s2,80001a1e <allocproc+0x1c>
  return 0;
    80001a36:	4481                	li	s1,0
    80001a38:	a089                	j	80001a7a <allocproc+0x78>
  p->pid = allocpid();
    80001a3a:	e71ff0ef          	jal	ra,800018aa <allocpid>
    80001a3e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a40:	4785                	li	a5,1
    80001a42:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a44:	894ff0ef          	jal	ra,80000ad8 <kalloc>
    80001a48:	892a                	mv	s2,a0
    80001a4a:	eca8                	sd	a0,88(s1)
    80001a4c:	cd15                	beqz	a0,80001a88 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	e99ff0ef          	jal	ra,800018e8 <proc_pagetable>
    80001a54:	892a                	mv	s2,a0
    80001a56:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a58:	c121                	beqz	a0,80001a98 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a5a:	07000613          	li	a2,112
    80001a5e:	4581                	li	a1,0
    80001a60:	06048513          	addi	a0,s1,96
    80001a64:	a18ff0ef          	jal	ra,80000c7c <memset>
  p->context.ra = (uint64)forkret;
    80001a68:	00000797          	auipc	a5,0x0
    80001a6c:	e0878793          	addi	a5,a5,-504 # 80001870 <forkret>
    80001a70:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a72:	60bc                	ld	a5,64(s1)
    80001a74:	6705                	lui	a4,0x1
    80001a76:	97ba                	add	a5,a5,a4
    80001a78:	f4bc                	sd	a5,104(s1)
}
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	60e2                	ld	ra,24(sp)
    80001a7e:	6442                	ld	s0,16(sp)
    80001a80:	64a2                	ld	s1,8(sp)
    80001a82:	6902                	ld	s2,0(sp)
    80001a84:	6105                	addi	sp,sp,32
    80001a86:	8082                	ret
    freeproc(p);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	f29ff0ef          	jal	ra,800019b2 <freeproc>
    release(&p->lock);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	9b0ff0ef          	jal	ra,80000c40 <release>
    return 0;
    80001a94:	84ca                	mv	s1,s2
    80001a96:	b7d5                	j	80001a7a <allocproc+0x78>
    freeproc(p);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	f19ff0ef          	jal	ra,800019b2 <freeproc>
    release(&p->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	9a0ff0ef          	jal	ra,80000c40 <release>
    return 0;
    80001aa4:	84ca                	mv	s1,s2
    80001aa6:	bfd1                	j	80001a7a <allocproc+0x78>

0000000080001aa8 <userinit>:
{
    80001aa8:	1101                	addi	sp,sp,-32
    80001aaa:	ec06                	sd	ra,24(sp)
    80001aac:	e822                	sd	s0,16(sp)
    80001aae:	e426                	sd	s1,8(sp)
    80001ab0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ab2:	f51ff0ef          	jal	ra,80001a02 <allocproc>
    80001ab6:	84aa                	mv	s1,a0
  initproc = p;
    80001ab8:	00006797          	auipc	a5,0x6
    80001abc:	e6a7b023          	sd	a0,-416(a5) # 80007918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ac0:	03400613          	li	a2,52
    80001ac4:	00006597          	auipc	a1,0x6
    80001ac8:	dcc58593          	addi	a1,a1,-564 # 80007890 <initcode>
    80001acc:	6928                	ld	a0,80(a0)
    80001ace:	f82ff0ef          	jal	ra,80001250 <uvmfirst>
  p->sz = PGSIZE;
    80001ad2:	6785                	lui	a5,0x1
    80001ad4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ad6:	6cb8                	ld	a4,88(s1)
    80001ad8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001adc:	6cb8                	ld	a4,88(s1)
    80001ade:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ae0:	4641                	li	a2,16
    80001ae2:	00005597          	auipc	a1,0x5
    80001ae6:	75658593          	addi	a1,a1,1878 # 80007238 <digits+0x200>
    80001aea:	15848513          	addi	a0,s1,344
    80001aee:	adcff0ef          	jal	ra,80000dca <safestrcpy>
  p->cwd = namei("/");
    80001af2:	00005517          	auipc	a0,0x5
    80001af6:	75650513          	addi	a0,a0,1878 # 80007248 <digits+0x210>
    80001afa:	4af010ef          	jal	ra,800037a8 <namei>
    80001afe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b02:	478d                	li	a5,3
    80001b04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b06:	8526                	mv	a0,s1
    80001b08:	938ff0ef          	jal	ra,80000c40 <release>
}
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6105                	addi	sp,sp,32
    80001b14:	8082                	ret

0000000080001b16 <growproc>:
{
    80001b16:	1101                	addi	sp,sp,-32
    80001b18:	ec06                	sd	ra,24(sp)
    80001b1a:	e822                	sd	s0,16(sp)
    80001b1c:	e426                	sd	s1,8(sp)
    80001b1e:	e04a                	sd	s2,0(sp)
    80001b20:	1000                	addi	s0,sp,32
    80001b22:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b24:	d1dff0ef          	jal	ra,80001840 <myproc>
    80001b28:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b2c:	01204c63          	bgtz	s2,80001b44 <growproc+0x2e>
  } else if(n < 0){
    80001b30:	02094463          	bltz	s2,80001b58 <growproc+0x42>
  p->sz = sz;
    80001b34:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b36:	4501                	li	a0,0
}
    80001b38:	60e2                	ld	ra,24(sp)
    80001b3a:	6442                	ld	s0,16(sp)
    80001b3c:	64a2                	ld	s1,8(sp)
    80001b3e:	6902                	ld	s2,0(sp)
    80001b40:	6105                	addi	sp,sp,32
    80001b42:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b44:	4691                	li	a3,4
    80001b46:	00b90633          	add	a2,s2,a1
    80001b4a:	6928                	ld	a0,80(a0)
    80001b4c:	fa6ff0ef          	jal	ra,800012f2 <uvmalloc>
    80001b50:	85aa                	mv	a1,a0
    80001b52:	f16d                	bnez	a0,80001b34 <growproc+0x1e>
      return -1;
    80001b54:	557d                	li	a0,-1
    80001b56:	b7cd                	j	80001b38 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b58:	00b90633          	add	a2,s2,a1
    80001b5c:	6928                	ld	a0,80(a0)
    80001b5e:	f50ff0ef          	jal	ra,800012ae <uvmdealloc>
    80001b62:	85aa                	mv	a1,a0
    80001b64:	bfc1                	j	80001b34 <growproc+0x1e>

0000000080001b66 <fork>:
{
    80001b66:	7179                	addi	sp,sp,-48
    80001b68:	f406                	sd	ra,40(sp)
    80001b6a:	f022                	sd	s0,32(sp)
    80001b6c:	ec26                	sd	s1,24(sp)
    80001b6e:	e84a                	sd	s2,16(sp)
    80001b70:	e44e                	sd	s3,8(sp)
    80001b72:	e052                	sd	s4,0(sp)
    80001b74:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001b76:	ccbff0ef          	jal	ra,80001840 <myproc>
    80001b7a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001b7c:	e87ff0ef          	jal	ra,80001a02 <allocproc>
    80001b80:	0e050563          	beqz	a0,80001c6a <fork+0x104>
    80001b84:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b86:	04893603          	ld	a2,72(s2)
    80001b8a:	692c                	ld	a1,80(a0)
    80001b8c:	05093503          	ld	a0,80(s2)
    80001b90:	88bff0ef          	jal	ra,8000141a <uvmcopy>
    80001b94:	04054663          	bltz	a0,80001be0 <fork+0x7a>
  np->sz = p->sz;
    80001b98:	04893783          	ld	a5,72(s2)
    80001b9c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001ba0:	05893683          	ld	a3,88(s2)
    80001ba4:	87b6                	mv	a5,a3
    80001ba6:	0589b703          	ld	a4,88(s3)
    80001baa:	12068693          	addi	a3,a3,288
    80001bae:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bb2:	6788                	ld	a0,8(a5)
    80001bb4:	6b8c                	ld	a1,16(a5)
    80001bb6:	6f90                	ld	a2,24(a5)
    80001bb8:	01073023          	sd	a6,0(a4)
    80001bbc:	e708                	sd	a0,8(a4)
    80001bbe:	eb0c                	sd	a1,16(a4)
    80001bc0:	ef10                	sd	a2,24(a4)
    80001bc2:	02078793          	addi	a5,a5,32
    80001bc6:	02070713          	addi	a4,a4,32
    80001bca:	fed792e3          	bne	a5,a3,80001bae <fork+0x48>
  np->trapframe->a0 = 0;
    80001bce:	0589b783          	ld	a5,88(s3)
    80001bd2:	0607b823          	sd	zero,112(a5)
    80001bd6:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001bda:	15000a13          	li	s4,336
    80001bde:	a00d                	j	80001c00 <fork+0x9a>
    freeproc(np);
    80001be0:	854e                	mv	a0,s3
    80001be2:	dd1ff0ef          	jal	ra,800019b2 <freeproc>
    release(&np->lock);
    80001be6:	854e                	mv	a0,s3
    80001be8:	858ff0ef          	jal	ra,80000c40 <release>
    return -1;
    80001bec:	5a7d                	li	s4,-1
    80001bee:	a0ad                	j	80001c58 <fork+0xf2>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bf0:	166020ef          	jal	ra,80003d56 <filedup>
    80001bf4:	009987b3          	add	a5,s3,s1
    80001bf8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001bfa:	04a1                	addi	s1,s1,8
    80001bfc:	01448763          	beq	s1,s4,80001c0a <fork+0xa4>
    if(p->ofile[i])
    80001c00:	009907b3          	add	a5,s2,s1
    80001c04:	6388                	ld	a0,0(a5)
    80001c06:	f56d                	bnez	a0,80001bf0 <fork+0x8a>
    80001c08:	bfcd                	j	80001bfa <fork+0x94>
  np->cwd = idup(p->cwd);
    80001c0a:	15093503          	ld	a0,336(s2)
    80001c0e:	4b2010ef          	jal	ra,800030c0 <idup>
    80001c12:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c16:	4641                	li	a2,16
    80001c18:	15890593          	addi	a1,s2,344
    80001c1c:	15898513          	addi	a0,s3,344
    80001c20:	9aaff0ef          	jal	ra,80000dca <safestrcpy>
  pid = np->pid;
    80001c24:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001c28:	854e                	mv	a0,s3
    80001c2a:	816ff0ef          	jal	ra,80000c40 <release>
  acquire(&wait_lock);
    80001c2e:	0000e497          	auipc	s1,0xe
    80001c32:	e3a48493          	addi	s1,s1,-454 # 8000fa68 <wait_lock>
    80001c36:	8526                	mv	a0,s1
    80001c38:	f71fe0ef          	jal	ra,80000ba8 <acquire>
  np->parent = p;
    80001c3c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001c40:	8526                	mv	a0,s1
    80001c42:	ffffe0ef          	jal	ra,80000c40 <release>
  acquire(&np->lock);
    80001c46:	854e                	mv	a0,s3
    80001c48:	f61fe0ef          	jal	ra,80000ba8 <acquire>
  np->state = RUNNABLE;
    80001c4c:	478d                	li	a5,3
    80001c4e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c52:	854e                	mv	a0,s3
    80001c54:	fedfe0ef          	jal	ra,80000c40 <release>
}
    80001c58:	8552                	mv	a0,s4
    80001c5a:	70a2                	ld	ra,40(sp)
    80001c5c:	7402                	ld	s0,32(sp)
    80001c5e:	64e2                	ld	s1,24(sp)
    80001c60:	6942                	ld	s2,16(sp)
    80001c62:	69a2                	ld	s3,8(sp)
    80001c64:	6a02                	ld	s4,0(sp)
    80001c66:	6145                	addi	sp,sp,48
    80001c68:	8082                	ret
    return -1;
    80001c6a:	5a7d                	li	s4,-1
    80001c6c:	b7f5                	j	80001c58 <fork+0xf2>

0000000080001c6e <scheduler>:
{
    80001c6e:	715d                	addi	sp,sp,-80
    80001c70:	e486                	sd	ra,72(sp)
    80001c72:	e0a2                	sd	s0,64(sp)
    80001c74:	fc26                	sd	s1,56(sp)
    80001c76:	f84a                	sd	s2,48(sp)
    80001c78:	f44e                	sd	s3,40(sp)
    80001c7a:	f052                	sd	s4,32(sp)
    80001c7c:	ec56                	sd	s5,24(sp)
    80001c7e:	e85a                	sd	s6,16(sp)
    80001c80:	e45e                	sd	s7,8(sp)
    80001c82:	e062                	sd	s8,0(sp)
    80001c84:	0880                	addi	s0,sp,80
    80001c86:	8792                	mv	a5,tp
  int id = r_tp();
    80001c88:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c8a:	00779b13          	slli	s6,a5,0x7
    80001c8e:	0000e717          	auipc	a4,0xe
    80001c92:	dc270713          	addi	a4,a4,-574 # 8000fa50 <pid_lock>
    80001c96:	975a                	add	a4,a4,s6
    80001c98:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c9c:	0000e717          	auipc	a4,0xe
    80001ca0:	dec70713          	addi	a4,a4,-532 # 8000fa88 <cpus+0x8>
    80001ca4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ca6:	4c11                	li	s8,4
        c->proc = p;
    80001ca8:	079e                	slli	a5,a5,0x7
    80001caa:	0000ea17          	auipc	s4,0xe
    80001cae:	da6a0a13          	addi	s4,s4,-602 # 8000fa50 <pid_lock>
    80001cb2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cb4:	00014997          	auipc	s3,0x14
    80001cb8:	bcc98993          	addi	s3,s3,-1076 # 80015880 <tickslock>
        found = 1;
    80001cbc:	4b85                	li	s7,1
    80001cbe:	a0a9                	j	80001d08 <scheduler+0x9a>
        p->state = RUNNING;
    80001cc0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001cc4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001cc8:	06048593          	addi	a1,s1,96
    80001ccc:	855a                	mv	a0,s6
    80001cce:	5cc000ef          	jal	ra,8000229a <swtch>
        c->proc = 0;
    80001cd2:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001cd6:	8ade                	mv	s5,s7
      release(&p->lock);
    80001cd8:	8526                	mv	a0,s1
    80001cda:	f67fe0ef          	jal	ra,80000c40 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cde:	16848493          	addi	s1,s1,360
    80001ce2:	01348963          	beq	s1,s3,80001cf4 <scheduler+0x86>
      acquire(&p->lock);
    80001ce6:	8526                	mv	a0,s1
    80001ce8:	ec1fe0ef          	jal	ra,80000ba8 <acquire>
      if(p->state == RUNNABLE) {
    80001cec:	4c9c                	lw	a5,24(s1)
    80001cee:	ff2795e3          	bne	a5,s2,80001cd8 <scheduler+0x6a>
    80001cf2:	b7f9                	j	80001cc0 <scheduler+0x52>
    if(found == 0) {
    80001cf4:	000a9a63          	bnez	s5,80001d08 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cfc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d00:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d04:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d10:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d14:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d16:	0000e497          	auipc	s1,0xe
    80001d1a:	16a48493          	addi	s1,s1,362 # 8000fe80 <proc>
      if(p->state == RUNNABLE) {
    80001d1e:	490d                	li	s2,3
    80001d20:	b7d9                	j	80001ce6 <scheduler+0x78>

0000000080001d22 <sched>:
{
    80001d22:	7179                	addi	sp,sp,-48
    80001d24:	f406                	sd	ra,40(sp)
    80001d26:	f022                	sd	s0,32(sp)
    80001d28:	ec26                	sd	s1,24(sp)
    80001d2a:	e84a                	sd	s2,16(sp)
    80001d2c:	e44e                	sd	s3,8(sp)
    80001d2e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d30:	b11ff0ef          	jal	ra,80001840 <myproc>
    80001d34:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d36:	e09fe0ef          	jal	ra,80000b3e <holding>
    80001d3a:	c92d                	beqz	a0,80001dac <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d3c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d3e:	2781                	sext.w	a5,a5
    80001d40:	079e                	slli	a5,a5,0x7
    80001d42:	0000e717          	auipc	a4,0xe
    80001d46:	d0e70713          	addi	a4,a4,-754 # 8000fa50 <pid_lock>
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	0a87a703          	lw	a4,168(a5)
    80001d50:	4785                	li	a5,1
    80001d52:	06f71363          	bne	a4,a5,80001db8 <sched+0x96>
  if(p->state == RUNNING)
    80001d56:	4c98                	lw	a4,24(s1)
    80001d58:	4791                	li	a5,4
    80001d5a:	06f70563          	beq	a4,a5,80001dc4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d62:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d64:	e7b5                	bnez	a5,80001dd0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d66:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d68:	0000e917          	auipc	s2,0xe
    80001d6c:	ce890913          	addi	s2,s2,-792 # 8000fa50 <pid_lock>
    80001d70:	2781                	sext.w	a5,a5
    80001d72:	079e                	slli	a5,a5,0x7
    80001d74:	97ca                	add	a5,a5,s2
    80001d76:	0ac7a983          	lw	s3,172(a5)
    80001d7a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d7c:	2781                	sext.w	a5,a5
    80001d7e:	079e                	slli	a5,a5,0x7
    80001d80:	0000e597          	auipc	a1,0xe
    80001d84:	d0858593          	addi	a1,a1,-760 # 8000fa88 <cpus+0x8>
    80001d88:	95be                	add	a1,a1,a5
    80001d8a:	06048513          	addi	a0,s1,96
    80001d8e:	50c000ef          	jal	ra,8000229a <swtch>
    80001d92:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d94:	2781                	sext.w	a5,a5
    80001d96:	079e                	slli	a5,a5,0x7
    80001d98:	97ca                	add	a5,a5,s2
    80001d9a:	0b37a623          	sw	s3,172(a5)
}
    80001d9e:	70a2                	ld	ra,40(sp)
    80001da0:	7402                	ld	s0,32(sp)
    80001da2:	64e2                	ld	s1,24(sp)
    80001da4:	6942                	ld	s2,16(sp)
    80001da6:	69a2                	ld	s3,8(sp)
    80001da8:	6145                	addi	sp,sp,48
    80001daa:	8082                	ret
    panic("sched p->lock");
    80001dac:	00005517          	auipc	a0,0x5
    80001db0:	4a450513          	addi	a0,a0,1188 # 80007250 <digits+0x218>
    80001db4:	9a9fe0ef          	jal	ra,8000075c <panic>
    panic("sched locks");
    80001db8:	00005517          	auipc	a0,0x5
    80001dbc:	4a850513          	addi	a0,a0,1192 # 80007260 <digits+0x228>
    80001dc0:	99dfe0ef          	jal	ra,8000075c <panic>
    panic("sched running");
    80001dc4:	00005517          	auipc	a0,0x5
    80001dc8:	4ac50513          	addi	a0,a0,1196 # 80007270 <digits+0x238>
    80001dcc:	991fe0ef          	jal	ra,8000075c <panic>
    panic("sched interruptible");
    80001dd0:	00005517          	auipc	a0,0x5
    80001dd4:	4b050513          	addi	a0,a0,1200 # 80007280 <digits+0x248>
    80001dd8:	985fe0ef          	jal	ra,8000075c <panic>

0000000080001ddc <yield>:
{
    80001ddc:	1101                	addi	sp,sp,-32
    80001dde:	ec06                	sd	ra,24(sp)
    80001de0:	e822                	sd	s0,16(sp)
    80001de2:	e426                	sd	s1,8(sp)
    80001de4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001de6:	a5bff0ef          	jal	ra,80001840 <myproc>
    80001dea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001dec:	dbdfe0ef          	jal	ra,80000ba8 <acquire>
  p->state = RUNNABLE;
    80001df0:	478d                	li	a5,3
    80001df2:	cc9c                	sw	a5,24(s1)
  sched();
    80001df4:	f2fff0ef          	jal	ra,80001d22 <sched>
  release(&p->lock);
    80001df8:	8526                	mv	a0,s1
    80001dfa:	e47fe0ef          	jal	ra,80000c40 <release>
}
    80001dfe:	60e2                	ld	ra,24(sp)
    80001e00:	6442                	ld	s0,16(sp)
    80001e02:	64a2                	ld	s1,8(sp)
    80001e04:	6105                	addi	sp,sp,32
    80001e06:	8082                	ret

0000000080001e08 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e08:	7179                	addi	sp,sp,-48
    80001e0a:	f406                	sd	ra,40(sp)
    80001e0c:	f022                	sd	s0,32(sp)
    80001e0e:	ec26                	sd	s1,24(sp)
    80001e10:	e84a                	sd	s2,16(sp)
    80001e12:	e44e                	sd	s3,8(sp)
    80001e14:	1800                	addi	s0,sp,48
    80001e16:	89aa                	mv	s3,a0
    80001e18:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e1a:	a27ff0ef          	jal	ra,80001840 <myproc>
    80001e1e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e20:	d89fe0ef          	jal	ra,80000ba8 <acquire>
  release(lk);
    80001e24:	854a                	mv	a0,s2
    80001e26:	e1bfe0ef          	jal	ra,80000c40 <release>

  // Go to sleep.
  p->chan = chan;
    80001e2a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e2e:	4789                	li	a5,2
    80001e30:	cc9c                	sw	a5,24(s1)

  sched();
    80001e32:	ef1ff0ef          	jal	ra,80001d22 <sched>

  // Tidy up.
  p->chan = 0;
    80001e36:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	e05fe0ef          	jal	ra,80000c40 <release>
  acquire(lk);
    80001e40:	854a                	mv	a0,s2
    80001e42:	d67fe0ef          	jal	ra,80000ba8 <acquire>
}
    80001e46:	70a2                	ld	ra,40(sp)
    80001e48:	7402                	ld	s0,32(sp)
    80001e4a:	64e2                	ld	s1,24(sp)
    80001e4c:	6942                	ld	s2,16(sp)
    80001e4e:	69a2                	ld	s3,8(sp)
    80001e50:	6145                	addi	sp,sp,48
    80001e52:	8082                	ret

0000000080001e54 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e54:	7139                	addi	sp,sp,-64
    80001e56:	fc06                	sd	ra,56(sp)
    80001e58:	f822                	sd	s0,48(sp)
    80001e5a:	f426                	sd	s1,40(sp)
    80001e5c:	f04a                	sd	s2,32(sp)
    80001e5e:	ec4e                	sd	s3,24(sp)
    80001e60:	e852                	sd	s4,16(sp)
    80001e62:	e456                	sd	s5,8(sp)
    80001e64:	0080                	addi	s0,sp,64
    80001e66:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e68:	0000e497          	auipc	s1,0xe
    80001e6c:	01848493          	addi	s1,s1,24 # 8000fe80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e70:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e72:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e74:	00014917          	auipc	s2,0x14
    80001e78:	a0c90913          	addi	s2,s2,-1524 # 80015880 <tickslock>
    80001e7c:	a811                	j	80001e90 <wakeup+0x3c>
        p->state = RUNNABLE;
    80001e7e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001e82:	8526                	mv	a0,s1
    80001e84:	dbdfe0ef          	jal	ra,80000c40 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e88:	16848493          	addi	s1,s1,360
    80001e8c:	03248063          	beq	s1,s2,80001eac <wakeup+0x58>
    if(p != myproc()){
    80001e90:	9b1ff0ef          	jal	ra,80001840 <myproc>
    80001e94:	fea48ae3          	beq	s1,a0,80001e88 <wakeup+0x34>
      acquire(&p->lock);
    80001e98:	8526                	mv	a0,s1
    80001e9a:	d0ffe0ef          	jal	ra,80000ba8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e9e:	4c9c                	lw	a5,24(s1)
    80001ea0:	ff3791e3          	bne	a5,s3,80001e82 <wakeup+0x2e>
    80001ea4:	709c                	ld	a5,32(s1)
    80001ea6:	fd479ee3          	bne	a5,s4,80001e82 <wakeup+0x2e>
    80001eaa:	bfd1                	j	80001e7e <wakeup+0x2a>
    }
  }
}
    80001eac:	70e2                	ld	ra,56(sp)
    80001eae:	7442                	ld	s0,48(sp)
    80001eb0:	74a2                	ld	s1,40(sp)
    80001eb2:	7902                	ld	s2,32(sp)
    80001eb4:	69e2                	ld	s3,24(sp)
    80001eb6:	6a42                	ld	s4,16(sp)
    80001eb8:	6aa2                	ld	s5,8(sp)
    80001eba:	6121                	addi	sp,sp,64
    80001ebc:	8082                	ret

0000000080001ebe <reparent>:
{
    80001ebe:	7179                	addi	sp,sp,-48
    80001ec0:	f406                	sd	ra,40(sp)
    80001ec2:	f022                	sd	s0,32(sp)
    80001ec4:	ec26                	sd	s1,24(sp)
    80001ec6:	e84a                	sd	s2,16(sp)
    80001ec8:	e44e                	sd	s3,8(sp)
    80001eca:	e052                	sd	s4,0(sp)
    80001ecc:	1800                	addi	s0,sp,48
    80001ece:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ed0:	0000e497          	auipc	s1,0xe
    80001ed4:	fb048493          	addi	s1,s1,-80 # 8000fe80 <proc>
      pp->parent = initproc;
    80001ed8:	00006a17          	auipc	s4,0x6
    80001edc:	a40a0a13          	addi	s4,s4,-1472 # 80007918 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ee0:	00014997          	auipc	s3,0x14
    80001ee4:	9a098993          	addi	s3,s3,-1632 # 80015880 <tickslock>
    80001ee8:	a029                	j	80001ef2 <reparent+0x34>
    80001eea:	16848493          	addi	s1,s1,360
    80001eee:	01348b63          	beq	s1,s3,80001f04 <reparent+0x46>
    if(pp->parent == p){
    80001ef2:	7c9c                	ld	a5,56(s1)
    80001ef4:	ff279be3          	bne	a5,s2,80001eea <reparent+0x2c>
      pp->parent = initproc;
    80001ef8:	000a3503          	ld	a0,0(s4)
    80001efc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001efe:	f57ff0ef          	jal	ra,80001e54 <wakeup>
    80001f02:	b7e5                	j	80001eea <reparent+0x2c>
}
    80001f04:	70a2                	ld	ra,40(sp)
    80001f06:	7402                	ld	s0,32(sp)
    80001f08:	64e2                	ld	s1,24(sp)
    80001f0a:	6942                	ld	s2,16(sp)
    80001f0c:	69a2                	ld	s3,8(sp)
    80001f0e:	6a02                	ld	s4,0(sp)
    80001f10:	6145                	addi	sp,sp,48
    80001f12:	8082                	ret

0000000080001f14 <exit>:
{
    80001f14:	7179                	addi	sp,sp,-48
    80001f16:	f406                	sd	ra,40(sp)
    80001f18:	f022                	sd	s0,32(sp)
    80001f1a:	ec26                	sd	s1,24(sp)
    80001f1c:	e84a                	sd	s2,16(sp)
    80001f1e:	e44e                	sd	s3,8(sp)
    80001f20:	e052                	sd	s4,0(sp)
    80001f22:	1800                	addi	s0,sp,48
    80001f24:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f26:	91bff0ef          	jal	ra,80001840 <myproc>
    80001f2a:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f2c:	00006797          	auipc	a5,0x6
    80001f30:	9ec7b783          	ld	a5,-1556(a5) # 80007918 <initproc>
    80001f34:	0d050493          	addi	s1,a0,208
    80001f38:	15050913          	addi	s2,a0,336
    80001f3c:	00a79f63          	bne	a5,a0,80001f5a <exit+0x46>
    panic("init exiting");
    80001f40:	00005517          	auipc	a0,0x5
    80001f44:	35850513          	addi	a0,a0,856 # 80007298 <digits+0x260>
    80001f48:	815fe0ef          	jal	ra,8000075c <panic>
      fileclose(f);
    80001f4c:	651010ef          	jal	ra,80003d9c <fileclose>
      p->ofile[fd] = 0;
    80001f50:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f54:	04a1                	addi	s1,s1,8
    80001f56:	01248563          	beq	s1,s2,80001f60 <exit+0x4c>
    if(p->ofile[fd]){
    80001f5a:	6088                	ld	a0,0(s1)
    80001f5c:	f965                	bnez	a0,80001f4c <exit+0x38>
    80001f5e:	bfdd                	j	80001f54 <exit+0x40>
  begin_op();
    80001f60:	221010ef          	jal	ra,80003980 <begin_op>
  iput(p->cwd);
    80001f64:	1509b503          	ld	a0,336(s3)
    80001f68:	30c010ef          	jal	ra,80003274 <iput>
  end_op();
    80001f6c:	285010ef          	jal	ra,800039f0 <end_op>
  p->cwd = 0;
    80001f70:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f74:	0000e497          	auipc	s1,0xe
    80001f78:	af448493          	addi	s1,s1,-1292 # 8000fa68 <wait_lock>
    80001f7c:	8526                	mv	a0,s1
    80001f7e:	c2bfe0ef          	jal	ra,80000ba8 <acquire>
  reparent(p);
    80001f82:	854e                	mv	a0,s3
    80001f84:	f3bff0ef          	jal	ra,80001ebe <reparent>
  wakeup(p->parent);
    80001f88:	0389b503          	ld	a0,56(s3)
    80001f8c:	ec9ff0ef          	jal	ra,80001e54 <wakeup>
  acquire(&p->lock);
    80001f90:	854e                	mv	a0,s3
    80001f92:	c17fe0ef          	jal	ra,80000ba8 <acquire>
  p->xstate = status;
    80001f96:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f9a:	4795                	li	a5,5
    80001f9c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	c9ffe0ef          	jal	ra,80000c40 <release>
  sched();
    80001fa6:	d7dff0ef          	jal	ra,80001d22 <sched>
  panic("zombie exit");
    80001faa:	00005517          	auipc	a0,0x5
    80001fae:	2fe50513          	addi	a0,a0,766 # 800072a8 <digits+0x270>
    80001fb2:	faafe0ef          	jal	ra,8000075c <panic>

0000000080001fb6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fb6:	7179                	addi	sp,sp,-48
    80001fb8:	f406                	sd	ra,40(sp)
    80001fba:	f022                	sd	s0,32(sp)
    80001fbc:	ec26                	sd	s1,24(sp)
    80001fbe:	e84a                	sd	s2,16(sp)
    80001fc0:	e44e                	sd	s3,8(sp)
    80001fc2:	1800                	addi	s0,sp,48
    80001fc4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fc6:	0000e497          	auipc	s1,0xe
    80001fca:	eba48493          	addi	s1,s1,-326 # 8000fe80 <proc>
    80001fce:	00014997          	auipc	s3,0x14
    80001fd2:	8b298993          	addi	s3,s3,-1870 # 80015880 <tickslock>
    acquire(&p->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	bd1fe0ef          	jal	ra,80000ba8 <acquire>
    if(p->pid == pid){
    80001fdc:	589c                	lw	a5,48(s1)
    80001fde:	01278b63          	beq	a5,s2,80001ff4 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	c5dfe0ef          	jal	ra,80000c40 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fe8:	16848493          	addi	s1,s1,360
    80001fec:	ff3495e3          	bne	s1,s3,80001fd6 <kill+0x20>
  }
  return -1;
    80001ff0:	557d                	li	a0,-1
    80001ff2:	a819                	j	80002008 <kill+0x52>
      p->killed = 1;
    80001ff4:	4785                	li	a5,1
    80001ff6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ff8:	4c98                	lw	a4,24(s1)
    80001ffa:	4789                	li	a5,2
    80001ffc:	00f70d63          	beq	a4,a5,80002016 <kill+0x60>
      release(&p->lock);
    80002000:	8526                	mv	a0,s1
    80002002:	c3ffe0ef          	jal	ra,80000c40 <release>
      return 0;
    80002006:	4501                	li	a0,0
}
    80002008:	70a2                	ld	ra,40(sp)
    8000200a:	7402                	ld	s0,32(sp)
    8000200c:	64e2                	ld	s1,24(sp)
    8000200e:	6942                	ld	s2,16(sp)
    80002010:	69a2                	ld	s3,8(sp)
    80002012:	6145                	addi	sp,sp,48
    80002014:	8082                	ret
        p->state = RUNNABLE;
    80002016:	478d                	li	a5,3
    80002018:	cc9c                	sw	a5,24(s1)
    8000201a:	b7dd                	j	80002000 <kill+0x4a>

000000008000201c <setkilled>:

void
setkilled(struct proc *p)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	1000                	addi	s0,sp,32
    80002026:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002028:	b81fe0ef          	jal	ra,80000ba8 <acquire>
  p->killed = 1;
    8000202c:	4785                	li	a5,1
    8000202e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002030:	8526                	mv	a0,s1
    80002032:	c0ffe0ef          	jal	ra,80000c40 <release>
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <killed>:

int
killed(struct proc *p)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	e04a                	sd	s2,0(sp)
    8000204a:	1000                	addi	s0,sp,32
    8000204c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000204e:	b5bfe0ef          	jal	ra,80000ba8 <acquire>
  k = p->killed;
    80002052:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	be9fe0ef          	jal	ra,80000c40 <release>
  return k;
}
    8000205c:	854a                	mv	a0,s2
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6902                	ld	s2,0(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <wait>:
{
    8000206a:	715d                	addi	sp,sp,-80
    8000206c:	e486                	sd	ra,72(sp)
    8000206e:	e0a2                	sd	s0,64(sp)
    80002070:	fc26                	sd	s1,56(sp)
    80002072:	f84a                	sd	s2,48(sp)
    80002074:	f44e                	sd	s3,40(sp)
    80002076:	f052                	sd	s4,32(sp)
    80002078:	ec56                	sd	s5,24(sp)
    8000207a:	e85a                	sd	s6,16(sp)
    8000207c:	e45e                	sd	s7,8(sp)
    8000207e:	e062                	sd	s8,0(sp)
    80002080:	0880                	addi	s0,sp,80
    80002082:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002084:	fbcff0ef          	jal	ra,80001840 <myproc>
    80002088:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000208a:	0000e517          	auipc	a0,0xe
    8000208e:	9de50513          	addi	a0,a0,-1570 # 8000fa68 <wait_lock>
    80002092:	b17fe0ef          	jal	ra,80000ba8 <acquire>
    havekids = 0;
    80002096:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002098:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209a:	00013997          	auipc	s3,0x13
    8000209e:	7e698993          	addi	s3,s3,2022 # 80015880 <tickslock>
        havekids = 1;
    800020a2:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020a4:	0000ec17          	auipc	s8,0xe
    800020a8:	9c4c0c13          	addi	s8,s8,-1596 # 8000fa68 <wait_lock>
    havekids = 0;
    800020ac:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ae:	0000e497          	auipc	s1,0xe
    800020b2:	dd248493          	addi	s1,s1,-558 # 8000fe80 <proc>
    800020b6:	a899                	j	8000210c <wait+0xa2>
          pid = pp->pid;
    800020b8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020bc:	000b0c63          	beqz	s6,800020d4 <wait+0x6a>
    800020c0:	4691                	li	a3,4
    800020c2:	02c48613          	addi	a2,s1,44
    800020c6:	85da                	mv	a1,s6
    800020c8:	05093503          	ld	a0,80(s2)
    800020cc:	c2aff0ef          	jal	ra,800014f6 <copyout>
    800020d0:	00054f63          	bltz	a0,800020ee <wait+0x84>
          freeproc(pp);
    800020d4:	8526                	mv	a0,s1
    800020d6:	8ddff0ef          	jal	ra,800019b2 <freeproc>
          release(&pp->lock);
    800020da:	8526                	mv	a0,s1
    800020dc:	b65fe0ef          	jal	ra,80000c40 <release>
          release(&wait_lock);
    800020e0:	0000e517          	auipc	a0,0xe
    800020e4:	98850513          	addi	a0,a0,-1656 # 8000fa68 <wait_lock>
    800020e8:	b59fe0ef          	jal	ra,80000c40 <release>
          return pid;
    800020ec:	a891                	j	80002140 <wait+0xd6>
            release(&pp->lock);
    800020ee:	8526                	mv	a0,s1
    800020f0:	b51fe0ef          	jal	ra,80000c40 <release>
            release(&wait_lock);
    800020f4:	0000e517          	auipc	a0,0xe
    800020f8:	97450513          	addi	a0,a0,-1676 # 8000fa68 <wait_lock>
    800020fc:	b45fe0ef          	jal	ra,80000c40 <release>
            return -1;
    80002100:	59fd                	li	s3,-1
    80002102:	a83d                	j	80002140 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002104:	16848493          	addi	s1,s1,360
    80002108:	03348063          	beq	s1,s3,80002128 <wait+0xbe>
      if(pp->parent == p){
    8000210c:	7c9c                	ld	a5,56(s1)
    8000210e:	ff279be3          	bne	a5,s2,80002104 <wait+0x9a>
        acquire(&pp->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	a95fe0ef          	jal	ra,80000ba8 <acquire>
        if(pp->state == ZOMBIE){
    80002118:	4c9c                	lw	a5,24(s1)
    8000211a:	f9478fe3          	beq	a5,s4,800020b8 <wait+0x4e>
        release(&pp->lock);
    8000211e:	8526                	mv	a0,s1
    80002120:	b21fe0ef          	jal	ra,80000c40 <release>
        havekids = 1;
    80002124:	8756                	mv	a4,s5
    80002126:	bff9                	j	80002104 <wait+0x9a>
    if(!havekids || killed(p)){
    80002128:	c709                	beqz	a4,80002132 <wait+0xc8>
    8000212a:	854a                	mv	a0,s2
    8000212c:	f15ff0ef          	jal	ra,80002040 <killed>
    80002130:	c50d                	beqz	a0,8000215a <wait+0xf0>
      release(&wait_lock);
    80002132:	0000e517          	auipc	a0,0xe
    80002136:	93650513          	addi	a0,a0,-1738 # 8000fa68 <wait_lock>
    8000213a:	b07fe0ef          	jal	ra,80000c40 <release>
      return -1;
    8000213e:	59fd                	li	s3,-1
}
    80002140:	854e                	mv	a0,s3
    80002142:	60a6                	ld	ra,72(sp)
    80002144:	6406                	ld	s0,64(sp)
    80002146:	74e2                	ld	s1,56(sp)
    80002148:	7942                	ld	s2,48(sp)
    8000214a:	79a2                	ld	s3,40(sp)
    8000214c:	7a02                	ld	s4,32(sp)
    8000214e:	6ae2                	ld	s5,24(sp)
    80002150:	6b42                	ld	s6,16(sp)
    80002152:	6ba2                	ld	s7,8(sp)
    80002154:	6c02                	ld	s8,0(sp)
    80002156:	6161                	addi	sp,sp,80
    80002158:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000215a:	85e2                	mv	a1,s8
    8000215c:	854a                	mv	a0,s2
    8000215e:	cabff0ef          	jal	ra,80001e08 <sleep>
    havekids = 0;
    80002162:	b7a9                	j	800020ac <wait+0x42>

0000000080002164 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002164:	7179                	addi	sp,sp,-48
    80002166:	f406                	sd	ra,40(sp)
    80002168:	f022                	sd	s0,32(sp)
    8000216a:	ec26                	sd	s1,24(sp)
    8000216c:	e84a                	sd	s2,16(sp)
    8000216e:	e44e                	sd	s3,8(sp)
    80002170:	e052                	sd	s4,0(sp)
    80002172:	1800                	addi	s0,sp,48
    80002174:	84aa                	mv	s1,a0
    80002176:	892e                	mv	s2,a1
    80002178:	89b2                	mv	s3,a2
    8000217a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000217c:	ec4ff0ef          	jal	ra,80001840 <myproc>
  if(user_dst){
    80002180:	cc99                	beqz	s1,8000219e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002182:	86d2                	mv	a3,s4
    80002184:	864e                	mv	a2,s3
    80002186:	85ca                	mv	a1,s2
    80002188:	6928                	ld	a0,80(a0)
    8000218a:	b6cff0ef          	jal	ra,800014f6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000218e:	70a2                	ld	ra,40(sp)
    80002190:	7402                	ld	s0,32(sp)
    80002192:	64e2                	ld	s1,24(sp)
    80002194:	6942                	ld	s2,16(sp)
    80002196:	69a2                	ld	s3,8(sp)
    80002198:	6a02                	ld	s4,0(sp)
    8000219a:	6145                	addi	sp,sp,48
    8000219c:	8082                	ret
    memmove((char *)dst, src, len);
    8000219e:	000a061b          	sext.w	a2,s4
    800021a2:	85ce                	mv	a1,s3
    800021a4:	854a                	mv	a0,s2
    800021a6:	b37fe0ef          	jal	ra,80000cdc <memmove>
    return 0;
    800021aa:	8526                	mv	a0,s1
    800021ac:	b7cd                	j	8000218e <either_copyout+0x2a>

00000000800021ae <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021ae:	7179                	addi	sp,sp,-48
    800021b0:	f406                	sd	ra,40(sp)
    800021b2:	f022                	sd	s0,32(sp)
    800021b4:	ec26                	sd	s1,24(sp)
    800021b6:	e84a                	sd	s2,16(sp)
    800021b8:	e44e                	sd	s3,8(sp)
    800021ba:	e052                	sd	s4,0(sp)
    800021bc:	1800                	addi	s0,sp,48
    800021be:	892a                	mv	s2,a0
    800021c0:	84ae                	mv	s1,a1
    800021c2:	89b2                	mv	s3,a2
    800021c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021c6:	e7aff0ef          	jal	ra,80001840 <myproc>
  if(user_src){
    800021ca:	cc99                	beqz	s1,800021e8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021cc:	86d2                	mv	a3,s4
    800021ce:	864e                	mv	a2,s3
    800021d0:	85ca                	mv	a1,s2
    800021d2:	6928                	ld	a0,80(a0)
    800021d4:	bdaff0ef          	jal	ra,800015ae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6942                	ld	s2,16(sp)
    800021e0:	69a2                	ld	s3,8(sp)
    800021e2:	6a02                	ld	s4,0(sp)
    800021e4:	6145                	addi	sp,sp,48
    800021e6:	8082                	ret
    memmove(dst, (char*)src, len);
    800021e8:	000a061b          	sext.w	a2,s4
    800021ec:	85ce                	mv	a1,s3
    800021ee:	854a                	mv	a0,s2
    800021f0:	aedfe0ef          	jal	ra,80000cdc <memmove>
    return 0;
    800021f4:	8526                	mv	a0,s1
    800021f6:	b7cd                	j	800021d8 <either_copyin+0x2a>

00000000800021f8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800021f8:	715d                	addi	sp,sp,-80
    800021fa:	e486                	sd	ra,72(sp)
    800021fc:	e0a2                	sd	s0,64(sp)
    800021fe:	fc26                	sd	s1,56(sp)
    80002200:	f84a                	sd	s2,48(sp)
    80002202:	f44e                	sd	s3,40(sp)
    80002204:	f052                	sd	s4,32(sp)
    80002206:	ec56                	sd	s5,24(sp)
    80002208:	e85a                	sd	s6,16(sp)
    8000220a:	e45e                	sd	s7,8(sp)
    8000220c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000220e:	00005517          	auipc	a0,0x5
    80002212:	eb250513          	addi	a0,a0,-334 # 800070c0 <digits+0x88>
    80002216:	a92fe0ef          	jal	ra,800004a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000221a:	0000e497          	auipc	s1,0xe
    8000221e:	dbe48493          	addi	s1,s1,-578 # 8000ffd8 <proc+0x158>
    80002222:	00013917          	auipc	s2,0x13
    80002226:	7b690913          	addi	s2,s2,1974 # 800159d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000222a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000222c:	00005997          	auipc	s3,0x5
    80002230:	08c98993          	addi	s3,s3,140 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002234:	00005a97          	auipc	s5,0x5
    80002238:	08ca8a93          	addi	s5,s5,140 # 800072c0 <digits+0x288>
    printf("\n");
    8000223c:	00005a17          	auipc	s4,0x5
    80002240:	e84a0a13          	addi	s4,s4,-380 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002244:	00005b97          	auipc	s7,0x5
    80002248:	0bcb8b93          	addi	s7,s7,188 # 80007300 <states.2236>
    8000224c:	a829                	j	80002266 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000224e:	ed86a583          	lw	a1,-296(a3)
    80002252:	8556                	mv	a0,s5
    80002254:	a54fe0ef          	jal	ra,800004a8 <printf>
    printf("\n");
    80002258:	8552                	mv	a0,s4
    8000225a:	a4efe0ef          	jal	ra,800004a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000225e:	16848493          	addi	s1,s1,360
    80002262:	03248163          	beq	s1,s2,80002284 <procdump+0x8c>
    if(p->state == UNUSED)
    80002266:	86a6                	mv	a3,s1
    80002268:	ec04a783          	lw	a5,-320(s1)
    8000226c:	dbed                	beqz	a5,8000225e <procdump+0x66>
      state = "???";
    8000226e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002270:	fcfb6fe3          	bltu	s6,a5,8000224e <procdump+0x56>
    80002274:	1782                	slli	a5,a5,0x20
    80002276:	9381                	srli	a5,a5,0x20
    80002278:	078e                	slli	a5,a5,0x3
    8000227a:	97de                	add	a5,a5,s7
    8000227c:	6390                	ld	a2,0(a5)
    8000227e:	fa61                	bnez	a2,8000224e <procdump+0x56>
      state = "???";
    80002280:	864e                	mv	a2,s3
    80002282:	b7f1                	j	8000224e <procdump+0x56>
  }
}
    80002284:	60a6                	ld	ra,72(sp)
    80002286:	6406                	ld	s0,64(sp)
    80002288:	74e2                	ld	s1,56(sp)
    8000228a:	7942                	ld	s2,48(sp)
    8000228c:	79a2                	ld	s3,40(sp)
    8000228e:	7a02                	ld	s4,32(sp)
    80002290:	6ae2                	ld	s5,24(sp)
    80002292:	6b42                	ld	s6,16(sp)
    80002294:	6ba2                	ld	s7,8(sp)
    80002296:	6161                	addi	sp,sp,80
    80002298:	8082                	ret

000000008000229a <swtch>:
    8000229a:	00153023          	sd	ra,0(a0)
    8000229e:	00253423          	sd	sp,8(a0)
    800022a2:	e900                	sd	s0,16(a0)
    800022a4:	ed04                	sd	s1,24(a0)
    800022a6:	03253023          	sd	s2,32(a0)
    800022aa:	03353423          	sd	s3,40(a0)
    800022ae:	03453823          	sd	s4,48(a0)
    800022b2:	03553c23          	sd	s5,56(a0)
    800022b6:	05653023          	sd	s6,64(a0)
    800022ba:	05753423          	sd	s7,72(a0)
    800022be:	05853823          	sd	s8,80(a0)
    800022c2:	05953c23          	sd	s9,88(a0)
    800022c6:	07a53023          	sd	s10,96(a0)
    800022ca:	07b53423          	sd	s11,104(a0)
    800022ce:	0005b083          	ld	ra,0(a1)
    800022d2:	0085b103          	ld	sp,8(a1)
    800022d6:	6980                	ld	s0,16(a1)
    800022d8:	6d84                	ld	s1,24(a1)
    800022da:	0205b903          	ld	s2,32(a1)
    800022de:	0285b983          	ld	s3,40(a1)
    800022e2:	0305ba03          	ld	s4,48(a1)
    800022e6:	0385ba83          	ld	s5,56(a1)
    800022ea:	0405bb03          	ld	s6,64(a1)
    800022ee:	0485bb83          	ld	s7,72(a1)
    800022f2:	0505bc03          	ld	s8,80(a1)
    800022f6:	0585bc83          	ld	s9,88(a1)
    800022fa:	0605bd03          	ld	s10,96(a1)
    800022fe:	0685bd83          	ld	s11,104(a1)
    80002302:	8082                	ret

0000000080002304 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002304:	1141                	addi	sp,sp,-16
    80002306:	e406                	sd	ra,8(sp)
    80002308:	e022                	sd	s0,0(sp)
    8000230a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000230c:	00005597          	auipc	a1,0x5
    80002310:	02458593          	addi	a1,a1,36 # 80007330 <states.2236+0x30>
    80002314:	00013517          	auipc	a0,0x13
    80002318:	56c50513          	addi	a0,a0,1388 # 80015880 <tickslock>
    8000231c:	80dfe0ef          	jal	ra,80000b28 <initlock>
}
    80002320:	60a2                	ld	ra,8(sp)
    80002322:	6402                	ld	s0,0(sp)
    80002324:	0141                	addi	sp,sp,16
    80002326:	8082                	ret

0000000080002328 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002328:	1141                	addi	sp,sp,-16
    8000232a:	e422                	sd	s0,8(sp)
    8000232c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000232e:	00003797          	auipc	a5,0x3
    80002332:	d1278793          	addi	a5,a5,-750 # 80005040 <kernelvec>
    80002336:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000233a:	6422                	ld	s0,8(sp)
    8000233c:	0141                	addi	sp,sp,16
    8000233e:	8082                	ret

0000000080002340 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002340:	1141                	addi	sp,sp,-16
    80002342:	e406                	sd	ra,8(sp)
    80002344:	e022                	sd	s0,0(sp)
    80002346:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002348:	cf8ff0ef          	jal	ra,80001840 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000234c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002350:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002352:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002356:	00004617          	auipc	a2,0x4
    8000235a:	caa60613          	addi	a2,a2,-854 # 80006000 <_trampoline>
    8000235e:	00004697          	auipc	a3,0x4
    80002362:	ca268693          	addi	a3,a3,-862 # 80006000 <_trampoline>
    80002366:	8e91                	sub	a3,a3,a2
    80002368:	040007b7          	lui	a5,0x4000
    8000236c:	17fd                	addi	a5,a5,-1
    8000236e:	07b2                	slli	a5,a5,0xc
    80002370:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002372:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002376:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002378:	180026f3          	csrr	a3,satp
    8000237c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000237e:	6d38                	ld	a4,88(a0)
    80002380:	6134                	ld	a3,64(a0)
    80002382:	6585                	lui	a1,0x1
    80002384:	96ae                	add	a3,a3,a1
    80002386:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002388:	6d38                	ld	a4,88(a0)
    8000238a:	00000697          	auipc	a3,0x0
    8000238e:	10c68693          	addi	a3,a3,268 # 80002496 <usertrap>
    80002392:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002394:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002396:	8692                	mv	a3,tp
    80002398:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000239a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000239e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800023a2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023a6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800023aa:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800023ac:	6f18                	ld	a4,24(a4)
    800023ae:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800023b2:	6928                	ld	a0,80(a0)
    800023b4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800023b6:	00004717          	auipc	a4,0x4
    800023ba:	ce670713          	addi	a4,a4,-794 # 8000609c <userret>
    800023be:	8f11                	sub	a4,a4,a2
    800023c0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800023c2:	577d                	li	a4,-1
    800023c4:	177e                	slli	a4,a4,0x3f
    800023c6:	8d59                	or	a0,a0,a4
    800023c8:	9782                	jalr	a5
}
    800023ca:	60a2                	ld	ra,8(sp)
    800023cc:	6402                	ld	s0,0(sp)
    800023ce:	0141                	addi	sp,sp,16
    800023d0:	8082                	ret

00000000800023d2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800023d2:	1101                	addi	sp,sp,-32
    800023d4:	ec06                	sd	ra,24(sp)
    800023d6:	e822                	sd	s0,16(sp)
    800023d8:	e426                	sd	s1,8(sp)
    800023da:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800023dc:	c38ff0ef          	jal	ra,80001814 <cpuid>
    800023e0:	cd19                	beqz	a0,800023fe <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800023e2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800023e6:	000f4737          	lui	a4,0xf4
    800023ea:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800023ee:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800023f0:	14d79073          	csrw	0x14d,a5
}
    800023f4:	60e2                	ld	ra,24(sp)
    800023f6:	6442                	ld	s0,16(sp)
    800023f8:	64a2                	ld	s1,8(sp)
    800023fa:	6105                	addi	sp,sp,32
    800023fc:	8082                	ret
    acquire(&tickslock);
    800023fe:	00013497          	auipc	s1,0x13
    80002402:	48248493          	addi	s1,s1,1154 # 80015880 <tickslock>
    80002406:	8526                	mv	a0,s1
    80002408:	fa0fe0ef          	jal	ra,80000ba8 <acquire>
    ticks++;
    8000240c:	00005517          	auipc	a0,0x5
    80002410:	51450513          	addi	a0,a0,1300 # 80007920 <ticks>
    80002414:	411c                	lw	a5,0(a0)
    80002416:	2785                	addiw	a5,a5,1
    80002418:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000241a:	a3bff0ef          	jal	ra,80001e54 <wakeup>
    release(&tickslock);
    8000241e:	8526                	mv	a0,s1
    80002420:	821fe0ef          	jal	ra,80000c40 <release>
    80002424:	bf7d                	j	800023e2 <clockintr+0x10>

0000000080002426 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002426:	1101                	addi	sp,sp,-32
    80002428:	ec06                	sd	ra,24(sp)
    8000242a:	e822                	sd	s0,16(sp)
    8000242c:	e426                	sd	s1,8(sp)
    8000242e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002430:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002434:	57fd                	li	a5,-1
    80002436:	17fe                	slli	a5,a5,0x3f
    80002438:	07a5                	addi	a5,a5,9
    8000243a:	00f70d63          	beq	a4,a5,80002454 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000243e:	57fd                	li	a5,-1
    80002440:	17fe                	slli	a5,a5,0x3f
    80002442:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002444:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002446:	04f70463          	beq	a4,a5,8000248e <devintr+0x68>
  }
}
    8000244a:	60e2                	ld	ra,24(sp)
    8000244c:	6442                	ld	s0,16(sp)
    8000244e:	64a2                	ld	s1,8(sp)
    80002450:	6105                	addi	sp,sp,32
    80002452:	8082                	ret
    int irq = plic_claim();
    80002454:	495020ef          	jal	ra,800050e8 <plic_claim>
    80002458:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000245a:	47a9                	li	a5,10
    8000245c:	02f50363          	beq	a0,a5,80002482 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80002460:	4785                	li	a5,1
    80002462:	02f50363          	beq	a0,a5,80002488 <devintr+0x62>
    return 1;
    80002466:	4505                	li	a0,1
    } else if(irq){
    80002468:	d0ed                	beqz	s1,8000244a <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000246a:	85a6                	mv	a1,s1
    8000246c:	00005517          	auipc	a0,0x5
    80002470:	ecc50513          	addi	a0,a0,-308 # 80007338 <states.2236+0x38>
    80002474:	834fe0ef          	jal	ra,800004a8 <printf>
      plic_complete(irq);
    80002478:	8526                	mv	a0,s1
    8000247a:	48f020ef          	jal	ra,80005108 <plic_complete>
    return 1;
    8000247e:	4505                	li	a0,1
    80002480:	b7e9                	j	8000244a <devintr+0x24>
      uartintr();
    80002482:	d3afe0ef          	jal	ra,800009bc <uartintr>
    80002486:	bfcd                	j	80002478 <devintr+0x52>
      virtio_disk_intr();
    80002488:	146030ef          	jal	ra,800055ce <virtio_disk_intr>
    8000248c:	b7f5                	j	80002478 <devintr+0x52>
    clockintr();
    8000248e:	f45ff0ef          	jal	ra,800023d2 <clockintr>
    return 2;
    80002492:	4509                	li	a0,2
    80002494:	bf5d                	j	8000244a <devintr+0x24>

0000000080002496 <usertrap>:
{
    80002496:	1101                	addi	sp,sp,-32
    80002498:	ec06                	sd	ra,24(sp)
    8000249a:	e822                	sd	s0,16(sp)
    8000249c:	e426                	sd	s1,8(sp)
    8000249e:	e04a                	sd	s2,0(sp)
    800024a0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024a2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800024a6:	1007f793          	andi	a5,a5,256
    800024aa:	ef85                	bnez	a5,800024e2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024ac:	00003797          	auipc	a5,0x3
    800024b0:	b9478793          	addi	a5,a5,-1132 # 80005040 <kernelvec>
    800024b4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800024b8:	b88ff0ef          	jal	ra,80001840 <myproc>
    800024bc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800024be:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024c0:	14102773          	csrr	a4,sepc
    800024c4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024c6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800024ca:	47a1                	li	a5,8
    800024cc:	02f70163          	beq	a4,a5,800024ee <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800024d0:	f57ff0ef          	jal	ra,80002426 <devintr>
    800024d4:	892a                	mv	s2,a0
    800024d6:	c135                	beqz	a0,8000253a <usertrap+0xa4>
  if(killed(p))
    800024d8:	8526                	mv	a0,s1
    800024da:	b67ff0ef          	jal	ra,80002040 <killed>
    800024de:	cd1d                	beqz	a0,8000251c <usertrap+0x86>
    800024e0:	a81d                	j	80002516 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800024e2:	00005517          	auipc	a0,0x5
    800024e6:	e7650513          	addi	a0,a0,-394 # 80007358 <states.2236+0x58>
    800024ea:	a72fe0ef          	jal	ra,8000075c <panic>
    if(killed(p))
    800024ee:	b53ff0ef          	jal	ra,80002040 <killed>
    800024f2:	e121                	bnez	a0,80002532 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800024f4:	6cb8                	ld	a4,88(s1)
    800024f6:	6f1c                	ld	a5,24(a4)
    800024f8:	0791                	addi	a5,a5,4
    800024fa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002500:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002504:	10079073          	csrw	sstatus,a5
    syscall();
    80002508:	248000ef          	jal	ra,80002750 <syscall>
  if(killed(p))
    8000250c:	8526                	mv	a0,s1
    8000250e:	b33ff0ef          	jal	ra,80002040 <killed>
    80002512:	c901                	beqz	a0,80002522 <usertrap+0x8c>
    80002514:	4901                	li	s2,0
    exit(-1);
    80002516:	557d                	li	a0,-1
    80002518:	9fdff0ef          	jal	ra,80001f14 <exit>
  if(which_dev == 2)
    8000251c:	4789                	li	a5,2
    8000251e:	04f90563          	beq	s2,a5,80002568 <usertrap+0xd2>
  usertrapret();
    80002522:	e1fff0ef          	jal	ra,80002340 <usertrapret>
}
    80002526:	60e2                	ld	ra,24(sp)
    80002528:	6442                	ld	s0,16(sp)
    8000252a:	64a2                	ld	s1,8(sp)
    8000252c:	6902                	ld	s2,0(sp)
    8000252e:	6105                	addi	sp,sp,32
    80002530:	8082                	ret
      exit(-1);
    80002532:	557d                	li	a0,-1
    80002534:	9e1ff0ef          	jal	ra,80001f14 <exit>
    80002538:	bf75                	j	800024f4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000253a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000253e:	5890                	lw	a2,48(s1)
    80002540:	00005517          	auipc	a0,0x5
    80002544:	e3850513          	addi	a0,a0,-456 # 80007378 <states.2236+0x78>
    80002548:	f61fd0ef          	jal	ra,800004a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000254c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002550:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002554:	00005517          	auipc	a0,0x5
    80002558:	e5450513          	addi	a0,a0,-428 # 800073a8 <states.2236+0xa8>
    8000255c:	f4dfd0ef          	jal	ra,800004a8 <printf>
    setkilled(p);
    80002560:	8526                	mv	a0,s1
    80002562:	abbff0ef          	jal	ra,8000201c <setkilled>
    80002566:	b75d                	j	8000250c <usertrap+0x76>
    yield();
    80002568:	875ff0ef          	jal	ra,80001ddc <yield>
    8000256c:	bf5d                	j	80002522 <usertrap+0x8c>

000000008000256e <kerneltrap>:
{
    8000256e:	7179                	addi	sp,sp,-48
    80002570:	f406                	sd	ra,40(sp)
    80002572:	f022                	sd	s0,32(sp)
    80002574:	ec26                	sd	s1,24(sp)
    80002576:	e84a                	sd	s2,16(sp)
    80002578:	e44e                	sd	s3,8(sp)
    8000257a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000257c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002580:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002584:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002588:	1004f793          	andi	a5,s1,256
    8000258c:	c795                	beqz	a5,800025b8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000258e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002592:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002594:	eb85                	bnez	a5,800025c4 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002596:	e91ff0ef          	jal	ra,80002426 <devintr>
    8000259a:	c91d                	beqz	a0,800025d0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000259c:	4789                	li	a5,2
    8000259e:	04f50a63          	beq	a0,a5,800025f2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025a2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a6:	10049073          	csrw	sstatus,s1
}
    800025aa:	70a2                	ld	ra,40(sp)
    800025ac:	7402                	ld	s0,32(sp)
    800025ae:	64e2                	ld	s1,24(sp)
    800025b0:	6942                	ld	s2,16(sp)
    800025b2:	69a2                	ld	s3,8(sp)
    800025b4:	6145                	addi	sp,sp,48
    800025b6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800025b8:	00005517          	auipc	a0,0x5
    800025bc:	e1850513          	addi	a0,a0,-488 # 800073d0 <states.2236+0xd0>
    800025c0:	99cfe0ef          	jal	ra,8000075c <panic>
    panic("kerneltrap: interrupts enabled");
    800025c4:	00005517          	auipc	a0,0x5
    800025c8:	e3450513          	addi	a0,a0,-460 # 800073f8 <states.2236+0xf8>
    800025cc:	990fe0ef          	jal	ra,8000075c <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025d0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025d4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800025d8:	85ce                	mv	a1,s3
    800025da:	00005517          	auipc	a0,0x5
    800025de:	e3e50513          	addi	a0,a0,-450 # 80007418 <states.2236+0x118>
    800025e2:	ec7fd0ef          	jal	ra,800004a8 <printf>
    panic("kerneltrap");
    800025e6:	00005517          	auipc	a0,0x5
    800025ea:	e5a50513          	addi	a0,a0,-422 # 80007440 <states.2236+0x140>
    800025ee:	96efe0ef          	jal	ra,8000075c <panic>
  if(which_dev == 2 && myproc() != 0)
    800025f2:	a4eff0ef          	jal	ra,80001840 <myproc>
    800025f6:	d555                	beqz	a0,800025a2 <kerneltrap+0x34>
    yield();
    800025f8:	fe4ff0ef          	jal	ra,80001ddc <yield>
    800025fc:	b75d                	j	800025a2 <kerneltrap+0x34>

00000000800025fe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800025fe:	1101                	addi	sp,sp,-32
    80002600:	ec06                	sd	ra,24(sp)
    80002602:	e822                	sd	s0,16(sp)
    80002604:	e426                	sd	s1,8(sp)
    80002606:	1000                	addi	s0,sp,32
    80002608:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000260a:	a36ff0ef          	jal	ra,80001840 <myproc>
  switch (n) {
    8000260e:	4795                	li	a5,5
    80002610:	0497e163          	bltu	a5,s1,80002652 <argraw+0x54>
    80002614:	048a                	slli	s1,s1,0x2
    80002616:	00005717          	auipc	a4,0x5
    8000261a:	e6270713          	addi	a4,a4,-414 # 80007478 <states.2236+0x178>
    8000261e:	94ba                	add	s1,s1,a4
    80002620:	409c                	lw	a5,0(s1)
    80002622:	97ba                	add	a5,a5,a4
    80002624:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002626:	6d3c                	ld	a5,88(a0)
    80002628:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6105                	addi	sp,sp,32
    80002632:	8082                	ret
    return p->trapframe->a1;
    80002634:	6d3c                	ld	a5,88(a0)
    80002636:	7fa8                	ld	a0,120(a5)
    80002638:	bfcd                	j	8000262a <argraw+0x2c>
    return p->trapframe->a2;
    8000263a:	6d3c                	ld	a5,88(a0)
    8000263c:	63c8                	ld	a0,128(a5)
    8000263e:	b7f5                	j	8000262a <argraw+0x2c>
    return p->trapframe->a3;
    80002640:	6d3c                	ld	a5,88(a0)
    80002642:	67c8                	ld	a0,136(a5)
    80002644:	b7dd                	j	8000262a <argraw+0x2c>
    return p->trapframe->a4;
    80002646:	6d3c                	ld	a5,88(a0)
    80002648:	6bc8                	ld	a0,144(a5)
    8000264a:	b7c5                	j	8000262a <argraw+0x2c>
    return p->trapframe->a5;
    8000264c:	6d3c                	ld	a5,88(a0)
    8000264e:	6fc8                	ld	a0,152(a5)
    80002650:	bfe9                	j	8000262a <argraw+0x2c>
  panic("argraw");
    80002652:	00005517          	auipc	a0,0x5
    80002656:	dfe50513          	addi	a0,a0,-514 # 80007450 <states.2236+0x150>
    8000265a:	902fe0ef          	jal	ra,8000075c <panic>

000000008000265e <fetchaddr>:
{
    8000265e:	1101                	addi	sp,sp,-32
    80002660:	ec06                	sd	ra,24(sp)
    80002662:	e822                	sd	s0,16(sp)
    80002664:	e426                	sd	s1,8(sp)
    80002666:	e04a                	sd	s2,0(sp)
    80002668:	1000                	addi	s0,sp,32
    8000266a:	84aa                	mv	s1,a0
    8000266c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000266e:	9d2ff0ef          	jal	ra,80001840 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002672:	653c                	ld	a5,72(a0)
    80002674:	02f4f663          	bgeu	s1,a5,800026a0 <fetchaddr+0x42>
    80002678:	00848713          	addi	a4,s1,8
    8000267c:	02e7e463          	bltu	a5,a4,800026a4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002680:	46a1                	li	a3,8
    80002682:	8626                	mv	a2,s1
    80002684:	85ca                	mv	a1,s2
    80002686:	6928                	ld	a0,80(a0)
    80002688:	f27fe0ef          	jal	ra,800015ae <copyin>
    8000268c:	00a03533          	snez	a0,a0
    80002690:	40a00533          	neg	a0,a0
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6902                	ld	s2,0(sp)
    8000269c:	6105                	addi	sp,sp,32
    8000269e:	8082                	ret
    return -1;
    800026a0:	557d                	li	a0,-1
    800026a2:	bfcd                	j	80002694 <fetchaddr+0x36>
    800026a4:	557d                	li	a0,-1
    800026a6:	b7fd                	j	80002694 <fetchaddr+0x36>

00000000800026a8 <fetchstr>:
{
    800026a8:	7179                	addi	sp,sp,-48
    800026aa:	f406                	sd	ra,40(sp)
    800026ac:	f022                	sd	s0,32(sp)
    800026ae:	ec26                	sd	s1,24(sp)
    800026b0:	e84a                	sd	s2,16(sp)
    800026b2:	e44e                	sd	s3,8(sp)
    800026b4:	1800                	addi	s0,sp,48
    800026b6:	892a                	mv	s2,a0
    800026b8:	84ae                	mv	s1,a1
    800026ba:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800026bc:	984ff0ef          	jal	ra,80001840 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800026c0:	86ce                	mv	a3,s3
    800026c2:	864a                	mv	a2,s2
    800026c4:	85a6                	mv	a1,s1
    800026c6:	6928                	ld	a0,80(a0)
    800026c8:	f6bfe0ef          	jal	ra,80001632 <copyinstr>
    800026cc:	00054c63          	bltz	a0,800026e4 <fetchstr+0x3c>
  return strlen(buf);
    800026d0:	8526                	mv	a0,s1
    800026d2:	f2afe0ef          	jal	ra,80000dfc <strlen>
}
    800026d6:	70a2                	ld	ra,40(sp)
    800026d8:	7402                	ld	s0,32(sp)
    800026da:	64e2                	ld	s1,24(sp)
    800026dc:	6942                	ld	s2,16(sp)
    800026de:	69a2                	ld	s3,8(sp)
    800026e0:	6145                	addi	sp,sp,48
    800026e2:	8082                	ret
    return -1;
    800026e4:	557d                	li	a0,-1
    800026e6:	bfc5                	j	800026d6 <fetchstr+0x2e>

00000000800026e8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800026e8:	1101                	addi	sp,sp,-32
    800026ea:	ec06                	sd	ra,24(sp)
    800026ec:	e822                	sd	s0,16(sp)
    800026ee:	e426                	sd	s1,8(sp)
    800026f0:	1000                	addi	s0,sp,32
    800026f2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800026f4:	f0bff0ef          	jal	ra,800025fe <argraw>
    800026f8:	c088                	sw	a0,0(s1)
}
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6105                	addi	sp,sp,32
    80002702:	8082                	ret

0000000080002704 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002704:	1101                	addi	sp,sp,-32
    80002706:	ec06                	sd	ra,24(sp)
    80002708:	e822                	sd	s0,16(sp)
    8000270a:	e426                	sd	s1,8(sp)
    8000270c:	1000                	addi	s0,sp,32
    8000270e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002710:	eefff0ef          	jal	ra,800025fe <argraw>
    80002714:	e088                	sd	a0,0(s1)
}
    80002716:	60e2                	ld	ra,24(sp)
    80002718:	6442                	ld	s0,16(sp)
    8000271a:	64a2                	ld	s1,8(sp)
    8000271c:	6105                	addi	sp,sp,32
    8000271e:	8082                	ret

0000000080002720 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002720:	7179                	addi	sp,sp,-48
    80002722:	f406                	sd	ra,40(sp)
    80002724:	f022                	sd	s0,32(sp)
    80002726:	ec26                	sd	s1,24(sp)
    80002728:	e84a                	sd	s2,16(sp)
    8000272a:	1800                	addi	s0,sp,48
    8000272c:	84ae                	mv	s1,a1
    8000272e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002730:	fd840593          	addi	a1,s0,-40
    80002734:	fd1ff0ef          	jal	ra,80002704 <argaddr>
  return fetchstr(addr, buf, max);
    80002738:	864a                	mv	a2,s2
    8000273a:	85a6                	mv	a1,s1
    8000273c:	fd843503          	ld	a0,-40(s0)
    80002740:	f69ff0ef          	jal	ra,800026a8 <fetchstr>
}
    80002744:	70a2                	ld	ra,40(sp)
    80002746:	7402                	ld	s0,32(sp)
    80002748:	64e2                	ld	s1,24(sp)
    8000274a:	6942                	ld	s2,16(sp)
    8000274c:	6145                	addi	sp,sp,48
    8000274e:	8082                	ret

0000000080002750 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000275c:	8e4ff0ef          	jal	ra,80001840 <myproc>
    80002760:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002762:	05853903          	ld	s2,88(a0)
    80002766:	0a893783          	ld	a5,168(s2)
    8000276a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000276e:	37fd                	addiw	a5,a5,-1
    80002770:	4751                	li	a4,20
    80002772:	00f76f63          	bltu	a4,a5,80002790 <syscall+0x40>
    80002776:	00369713          	slli	a4,a3,0x3
    8000277a:	00005797          	auipc	a5,0x5
    8000277e:	d1678793          	addi	a5,a5,-746 # 80007490 <syscalls>
    80002782:	97ba                	add	a5,a5,a4
    80002784:	639c                	ld	a5,0(a5)
    80002786:	c789                	beqz	a5,80002790 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002788:	9782                	jalr	a5
    8000278a:	06a93823          	sd	a0,112(s2)
    8000278e:	a829                	j	800027a8 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002790:	15848613          	addi	a2,s1,344
    80002794:	588c                	lw	a1,48(s1)
    80002796:	00005517          	auipc	a0,0x5
    8000279a:	cc250513          	addi	a0,a0,-830 # 80007458 <states.2236+0x158>
    8000279e:	d0bfd0ef          	jal	ra,800004a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800027a2:	6cbc                	ld	a5,88(s1)
    800027a4:	577d                	li	a4,-1
    800027a6:	fbb8                	sd	a4,112(a5)
  }
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6902                	ld	s2,0(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret

00000000800027b4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800027bc:	fec40593          	addi	a1,s0,-20
    800027c0:	4501                	li	a0,0
    800027c2:	f27ff0ef          	jal	ra,800026e8 <argint>
  exit(n);
    800027c6:	fec42503          	lw	a0,-20(s0)
    800027ca:	f4aff0ef          	jal	ra,80001f14 <exit>
  return 0;  // not reached
}
    800027ce:	4501                	li	a0,0
    800027d0:	60e2                	ld	ra,24(sp)
    800027d2:	6442                	ld	s0,16(sp)
    800027d4:	6105                	addi	sp,sp,32
    800027d6:	8082                	ret

00000000800027d8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800027d8:	1141                	addi	sp,sp,-16
    800027da:	e406                	sd	ra,8(sp)
    800027dc:	e022                	sd	s0,0(sp)
    800027de:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800027e0:	860ff0ef          	jal	ra,80001840 <myproc>
}
    800027e4:	5908                	lw	a0,48(a0)
    800027e6:	60a2                	ld	ra,8(sp)
    800027e8:	6402                	ld	s0,0(sp)
    800027ea:	0141                	addi	sp,sp,16
    800027ec:	8082                	ret

00000000800027ee <sys_fork>:

uint64
sys_fork(void)
{
    800027ee:	1141                	addi	sp,sp,-16
    800027f0:	e406                	sd	ra,8(sp)
    800027f2:	e022                	sd	s0,0(sp)
    800027f4:	0800                	addi	s0,sp,16
  return fork();
    800027f6:	b70ff0ef          	jal	ra,80001b66 <fork>
}
    800027fa:	60a2                	ld	ra,8(sp)
    800027fc:	6402                	ld	s0,0(sp)
    800027fe:	0141                	addi	sp,sp,16
    80002800:	8082                	ret

0000000080002802 <sys_wait>:

uint64
sys_wait(void)
{
    80002802:	1101                	addi	sp,sp,-32
    80002804:	ec06                	sd	ra,24(sp)
    80002806:	e822                	sd	s0,16(sp)
    80002808:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000280a:	fe840593          	addi	a1,s0,-24
    8000280e:	4501                	li	a0,0
    80002810:	ef5ff0ef          	jal	ra,80002704 <argaddr>
  return wait(p);
    80002814:	fe843503          	ld	a0,-24(s0)
    80002818:	853ff0ef          	jal	ra,8000206a <wait>
}
    8000281c:	60e2                	ld	ra,24(sp)
    8000281e:	6442                	ld	s0,16(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002824:	7179                	addi	sp,sp,-48
    80002826:	f406                	sd	ra,40(sp)
    80002828:	f022                	sd	s0,32(sp)
    8000282a:	ec26                	sd	s1,24(sp)
    8000282c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000282e:	fdc40593          	addi	a1,s0,-36
    80002832:	4501                	li	a0,0
    80002834:	eb5ff0ef          	jal	ra,800026e8 <argint>
  addr = myproc()->sz;
    80002838:	808ff0ef          	jal	ra,80001840 <myproc>
    8000283c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000283e:	fdc42503          	lw	a0,-36(s0)
    80002842:	ad4ff0ef          	jal	ra,80001b16 <growproc>
    80002846:	00054863          	bltz	a0,80002856 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000284a:	8526                	mv	a0,s1
    8000284c:	70a2                	ld	ra,40(sp)
    8000284e:	7402                	ld	s0,32(sp)
    80002850:	64e2                	ld	s1,24(sp)
    80002852:	6145                	addi	sp,sp,48
    80002854:	8082                	ret
    return -1;
    80002856:	54fd                	li	s1,-1
    80002858:	bfcd                	j	8000284a <sys_sbrk+0x26>

000000008000285a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000285a:	7139                	addi	sp,sp,-64
    8000285c:	fc06                	sd	ra,56(sp)
    8000285e:	f822                	sd	s0,48(sp)
    80002860:	f426                	sd	s1,40(sp)
    80002862:	f04a                	sd	s2,32(sp)
    80002864:	ec4e                	sd	s3,24(sp)
    80002866:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002868:	fcc40593          	addi	a1,s0,-52
    8000286c:	4501                	li	a0,0
    8000286e:	e7bff0ef          	jal	ra,800026e8 <argint>
  if(n < 0)
    80002872:	fcc42783          	lw	a5,-52(s0)
    80002876:	0607c563          	bltz	a5,800028e0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000287a:	00013517          	auipc	a0,0x13
    8000287e:	00650513          	addi	a0,a0,6 # 80015880 <tickslock>
    80002882:	b26fe0ef          	jal	ra,80000ba8 <acquire>
  ticks0 = ticks;
    80002886:	00005917          	auipc	s2,0x5
    8000288a:	09a92903          	lw	s2,154(s2) # 80007920 <ticks>
  while(ticks - ticks0 < n){
    8000288e:	fcc42783          	lw	a5,-52(s0)
    80002892:	cb8d                	beqz	a5,800028c4 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002894:	00013997          	auipc	s3,0x13
    80002898:	fec98993          	addi	s3,s3,-20 # 80015880 <tickslock>
    8000289c:	00005497          	auipc	s1,0x5
    800028a0:	08448493          	addi	s1,s1,132 # 80007920 <ticks>
    if(killed(myproc())){
    800028a4:	f9dfe0ef          	jal	ra,80001840 <myproc>
    800028a8:	f98ff0ef          	jal	ra,80002040 <killed>
    800028ac:	ed0d                	bnez	a0,800028e6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800028ae:	85ce                	mv	a1,s3
    800028b0:	8526                	mv	a0,s1
    800028b2:	d56ff0ef          	jal	ra,80001e08 <sleep>
  while(ticks - ticks0 < n){
    800028b6:	409c                	lw	a5,0(s1)
    800028b8:	412787bb          	subw	a5,a5,s2
    800028bc:	fcc42703          	lw	a4,-52(s0)
    800028c0:	fee7e2e3          	bltu	a5,a4,800028a4 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800028c4:	00013517          	auipc	a0,0x13
    800028c8:	fbc50513          	addi	a0,a0,-68 # 80015880 <tickslock>
    800028cc:	b74fe0ef          	jal	ra,80000c40 <release>
  return 0;
    800028d0:	4501                	li	a0,0
}
    800028d2:	70e2                	ld	ra,56(sp)
    800028d4:	7442                	ld	s0,48(sp)
    800028d6:	74a2                	ld	s1,40(sp)
    800028d8:	7902                	ld	s2,32(sp)
    800028da:	69e2                	ld	s3,24(sp)
    800028dc:	6121                	addi	sp,sp,64
    800028de:	8082                	ret
    n = 0;
    800028e0:	fc042623          	sw	zero,-52(s0)
    800028e4:	bf59                	j	8000287a <sys_sleep+0x20>
      release(&tickslock);
    800028e6:	00013517          	auipc	a0,0x13
    800028ea:	f9a50513          	addi	a0,a0,-102 # 80015880 <tickslock>
    800028ee:	b52fe0ef          	jal	ra,80000c40 <release>
      return -1;
    800028f2:	557d                	li	a0,-1
    800028f4:	bff9                	j	800028d2 <sys_sleep+0x78>

00000000800028f6 <sys_kill>:

uint64
sys_kill(void)
{
    800028f6:	1101                	addi	sp,sp,-32
    800028f8:	ec06                	sd	ra,24(sp)
    800028fa:	e822                	sd	s0,16(sp)
    800028fc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800028fe:	fec40593          	addi	a1,s0,-20
    80002902:	4501                	li	a0,0
    80002904:	de5ff0ef          	jal	ra,800026e8 <argint>
  return kill(pid);
    80002908:	fec42503          	lw	a0,-20(s0)
    8000290c:	eaaff0ef          	jal	ra,80001fb6 <kill>
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	6105                	addi	sp,sp,32
    80002916:	8082                	ret

0000000080002918 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002918:	1101                	addi	sp,sp,-32
    8000291a:	ec06                	sd	ra,24(sp)
    8000291c:	e822                	sd	s0,16(sp)
    8000291e:	e426                	sd	s1,8(sp)
    80002920:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002922:	00013517          	auipc	a0,0x13
    80002926:	f5e50513          	addi	a0,a0,-162 # 80015880 <tickslock>
    8000292a:	a7efe0ef          	jal	ra,80000ba8 <acquire>
  xticks = ticks;
    8000292e:	00005497          	auipc	s1,0x5
    80002932:	ff24a483          	lw	s1,-14(s1) # 80007920 <ticks>
  release(&tickslock);
    80002936:	00013517          	auipc	a0,0x13
    8000293a:	f4a50513          	addi	a0,a0,-182 # 80015880 <tickslock>
    8000293e:	b02fe0ef          	jal	ra,80000c40 <release>
  return xticks;
}
    80002942:	02049513          	slli	a0,s1,0x20
    80002946:	9101                	srli	a0,a0,0x20
    80002948:	60e2                	ld	ra,24(sp)
    8000294a:	6442                	ld	s0,16(sp)
    8000294c:	64a2                	ld	s1,8(sp)
    8000294e:	6105                	addi	sp,sp,32
    80002950:	8082                	ret

0000000080002952 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002952:	7179                	addi	sp,sp,-48
    80002954:	f406                	sd	ra,40(sp)
    80002956:	f022                	sd	s0,32(sp)
    80002958:	ec26                	sd	s1,24(sp)
    8000295a:	e84a                	sd	s2,16(sp)
    8000295c:	e44e                	sd	s3,8(sp)
    8000295e:	e052                	sd	s4,0(sp)
    80002960:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002962:	00005597          	auipc	a1,0x5
    80002966:	bde58593          	addi	a1,a1,-1058 # 80007540 <syscalls+0xb0>
    8000296a:	00013517          	auipc	a0,0x13
    8000296e:	f2e50513          	addi	a0,a0,-210 # 80015898 <bcache>
    80002972:	9b6fe0ef          	jal	ra,80000b28 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002976:	0001b797          	auipc	a5,0x1b
    8000297a:	f2278793          	addi	a5,a5,-222 # 8001d898 <bcache+0x8000>
    8000297e:	0001b717          	auipc	a4,0x1b
    80002982:	18270713          	addi	a4,a4,386 # 8001db00 <bcache+0x8268>
    80002986:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000298a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000298e:	00013497          	auipc	s1,0x13
    80002992:	f2248493          	addi	s1,s1,-222 # 800158b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002996:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002998:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000299a:	00005a17          	auipc	s4,0x5
    8000299e:	baea0a13          	addi	s4,s4,-1106 # 80007548 <syscalls+0xb8>
    b->next = bcache.head.next;
    800029a2:	2b893783          	ld	a5,696(s2)
    800029a6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800029a8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800029ac:	85d2                	mv	a1,s4
    800029ae:	01048513          	addi	a0,s1,16
    800029b2:	224010ef          	jal	ra,80003bd6 <initsleeplock>
    bcache.head.next->prev = b;
    800029b6:	2b893783          	ld	a5,696(s2)
    800029ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800029bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029c0:	45848493          	addi	s1,s1,1112
    800029c4:	fd349fe3          	bne	s1,s3,800029a2 <binit+0x50>
  }
}
    800029c8:	70a2                	ld	ra,40(sp)
    800029ca:	7402                	ld	s0,32(sp)
    800029cc:	64e2                	ld	s1,24(sp)
    800029ce:	6942                	ld	s2,16(sp)
    800029d0:	69a2                	ld	s3,8(sp)
    800029d2:	6a02                	ld	s4,0(sp)
    800029d4:	6145                	addi	sp,sp,48
    800029d6:	8082                	ret

00000000800029d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800029d8:	7179                	addi	sp,sp,-48
    800029da:	f406                	sd	ra,40(sp)
    800029dc:	f022                	sd	s0,32(sp)
    800029de:	ec26                	sd	s1,24(sp)
    800029e0:	e84a                	sd	s2,16(sp)
    800029e2:	e44e                	sd	s3,8(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	89aa                	mv	s3,a0
    800029e8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800029ea:	00013517          	auipc	a0,0x13
    800029ee:	eae50513          	addi	a0,a0,-338 # 80015898 <bcache>
    800029f2:	9b6fe0ef          	jal	ra,80000ba8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800029f6:	0001b497          	auipc	s1,0x1b
    800029fa:	15a4b483          	ld	s1,346(s1) # 8001db50 <bcache+0x82b8>
    800029fe:	0001b797          	auipc	a5,0x1b
    80002a02:	10278793          	addi	a5,a5,258 # 8001db00 <bcache+0x8268>
    80002a06:	02f48b63          	beq	s1,a5,80002a3c <bread+0x64>
    80002a0a:	873e                	mv	a4,a5
    80002a0c:	a021                	j	80002a14 <bread+0x3c>
    80002a0e:	68a4                	ld	s1,80(s1)
    80002a10:	02e48663          	beq	s1,a4,80002a3c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a14:	449c                	lw	a5,8(s1)
    80002a16:	ff379ce3          	bne	a5,s3,80002a0e <bread+0x36>
    80002a1a:	44dc                	lw	a5,12(s1)
    80002a1c:	ff2799e3          	bne	a5,s2,80002a0e <bread+0x36>
      b->refcnt++;
    80002a20:	40bc                	lw	a5,64(s1)
    80002a22:	2785                	addiw	a5,a5,1
    80002a24:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a26:	00013517          	auipc	a0,0x13
    80002a2a:	e7250513          	addi	a0,a0,-398 # 80015898 <bcache>
    80002a2e:	a12fe0ef          	jal	ra,80000c40 <release>
      acquiresleep(&b->lock);
    80002a32:	01048513          	addi	a0,s1,16
    80002a36:	1d6010ef          	jal	ra,80003c0c <acquiresleep>
      return b;
    80002a3a:	a889                	j	80002a8c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a3c:	0001b497          	auipc	s1,0x1b
    80002a40:	10c4b483          	ld	s1,268(s1) # 8001db48 <bcache+0x82b0>
    80002a44:	0001b797          	auipc	a5,0x1b
    80002a48:	0bc78793          	addi	a5,a5,188 # 8001db00 <bcache+0x8268>
    80002a4c:	00f48863          	beq	s1,a5,80002a5c <bread+0x84>
    80002a50:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002a52:	40bc                	lw	a5,64(s1)
    80002a54:	cb91                	beqz	a5,80002a68 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a56:	64a4                	ld	s1,72(s1)
    80002a58:	fee49de3          	bne	s1,a4,80002a52 <bread+0x7a>
  panic("bget: no buffers");
    80002a5c:	00005517          	auipc	a0,0x5
    80002a60:	af450513          	addi	a0,a0,-1292 # 80007550 <syscalls+0xc0>
    80002a64:	cf9fd0ef          	jal	ra,8000075c <panic>
      b->dev = dev;
    80002a68:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002a6c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002a70:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002a74:	4785                	li	a5,1
    80002a76:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a78:	00013517          	auipc	a0,0x13
    80002a7c:	e2050513          	addi	a0,a0,-480 # 80015898 <bcache>
    80002a80:	9c0fe0ef          	jal	ra,80000c40 <release>
      acquiresleep(&b->lock);
    80002a84:	01048513          	addi	a0,s1,16
    80002a88:	184010ef          	jal	ra,80003c0c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002a8c:	409c                	lw	a5,0(s1)
    80002a8e:	cb89                	beqz	a5,80002aa0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002a90:	8526                	mv	a0,s1
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6145                	addi	sp,sp,48
    80002a9e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002aa0:	4581                	li	a1,0
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	0bd020ef          	jal	ra,80005360 <virtio_disk_rw>
    b->valid = 1;
    80002aa8:	4785                	li	a5,1
    80002aaa:	c09c                	sw	a5,0(s1)
  return b;
    80002aac:	b7d5                	j	80002a90 <bread+0xb8>

0000000080002aae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002aae:	1101                	addi	sp,sp,-32
    80002ab0:	ec06                	sd	ra,24(sp)
    80002ab2:	e822                	sd	s0,16(sp)
    80002ab4:	e426                	sd	s1,8(sp)
    80002ab6:	1000                	addi	s0,sp,32
    80002ab8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002aba:	0541                	addi	a0,a0,16
    80002abc:	1ce010ef          	jal	ra,80003c8a <holdingsleep>
    80002ac0:	c911                	beqz	a0,80002ad4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ac2:	4585                	li	a1,1
    80002ac4:	8526                	mv	a0,s1
    80002ac6:	09b020ef          	jal	ra,80005360 <virtio_disk_rw>
}
    80002aca:	60e2                	ld	ra,24(sp)
    80002acc:	6442                	ld	s0,16(sp)
    80002ace:	64a2                	ld	s1,8(sp)
    80002ad0:	6105                	addi	sp,sp,32
    80002ad2:	8082                	ret
    panic("bwrite");
    80002ad4:	00005517          	auipc	a0,0x5
    80002ad8:	a9450513          	addi	a0,a0,-1388 # 80007568 <syscalls+0xd8>
    80002adc:	c81fd0ef          	jal	ra,8000075c <panic>

0000000080002ae0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	e426                	sd	s1,8(sp)
    80002ae8:	e04a                	sd	s2,0(sp)
    80002aea:	1000                	addi	s0,sp,32
    80002aec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002aee:	01050913          	addi	s2,a0,16
    80002af2:	854a                	mv	a0,s2
    80002af4:	196010ef          	jal	ra,80003c8a <holdingsleep>
    80002af8:	c13d                	beqz	a0,80002b5e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002afa:	854a                	mv	a0,s2
    80002afc:	156010ef          	jal	ra,80003c52 <releasesleep>

  acquire(&bcache.lock);
    80002b00:	00013517          	auipc	a0,0x13
    80002b04:	d9850513          	addi	a0,a0,-616 # 80015898 <bcache>
    80002b08:	8a0fe0ef          	jal	ra,80000ba8 <acquire>
  b->refcnt--;
    80002b0c:	40bc                	lw	a5,64(s1)
    80002b0e:	37fd                	addiw	a5,a5,-1
    80002b10:	0007871b          	sext.w	a4,a5
    80002b14:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b16:	eb05                	bnez	a4,80002b46 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002b18:	68bc                	ld	a5,80(s1)
    80002b1a:	64b8                	ld	a4,72(s1)
    80002b1c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002b1e:	64bc                	ld	a5,72(s1)
    80002b20:	68b8                	ld	a4,80(s1)
    80002b22:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b24:	0001b797          	auipc	a5,0x1b
    80002b28:	d7478793          	addi	a5,a5,-652 # 8001d898 <bcache+0x8000>
    80002b2c:	2b87b703          	ld	a4,696(a5)
    80002b30:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b32:	0001b717          	auipc	a4,0x1b
    80002b36:	fce70713          	addi	a4,a4,-50 # 8001db00 <bcache+0x8268>
    80002b3a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b3c:	2b87b703          	ld	a4,696(a5)
    80002b40:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b42:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b46:	00013517          	auipc	a0,0x13
    80002b4a:	d5250513          	addi	a0,a0,-686 # 80015898 <bcache>
    80002b4e:	8f2fe0ef          	jal	ra,80000c40 <release>
}
    80002b52:	60e2                	ld	ra,24(sp)
    80002b54:	6442                	ld	s0,16(sp)
    80002b56:	64a2                	ld	s1,8(sp)
    80002b58:	6902                	ld	s2,0(sp)
    80002b5a:	6105                	addi	sp,sp,32
    80002b5c:	8082                	ret
    panic("brelse");
    80002b5e:	00005517          	auipc	a0,0x5
    80002b62:	a1250513          	addi	a0,a0,-1518 # 80007570 <syscalls+0xe0>
    80002b66:	bf7fd0ef          	jal	ra,8000075c <panic>

0000000080002b6a <bpin>:

void
bpin(struct buf *b) {
    80002b6a:	1101                	addi	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b76:	00013517          	auipc	a0,0x13
    80002b7a:	d2250513          	addi	a0,a0,-734 # 80015898 <bcache>
    80002b7e:	82afe0ef          	jal	ra,80000ba8 <acquire>
  b->refcnt++;
    80002b82:	40bc                	lw	a5,64(s1)
    80002b84:	2785                	addiw	a5,a5,1
    80002b86:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002b88:	00013517          	auipc	a0,0x13
    80002b8c:	d1050513          	addi	a0,a0,-752 # 80015898 <bcache>
    80002b90:	8b0fe0ef          	jal	ra,80000c40 <release>
}
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	64a2                	ld	s1,8(sp)
    80002b9a:	6105                	addi	sp,sp,32
    80002b9c:	8082                	ret

0000000080002b9e <bunpin>:

void
bunpin(struct buf *b) {
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	1000                	addi	s0,sp,32
    80002ba8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002baa:	00013517          	auipc	a0,0x13
    80002bae:	cee50513          	addi	a0,a0,-786 # 80015898 <bcache>
    80002bb2:	ff7fd0ef          	jal	ra,80000ba8 <acquire>
  b->refcnt--;
    80002bb6:	40bc                	lw	a5,64(s1)
    80002bb8:	37fd                	addiw	a5,a5,-1
    80002bba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bbc:	00013517          	auipc	a0,0x13
    80002bc0:	cdc50513          	addi	a0,a0,-804 # 80015898 <bcache>
    80002bc4:	87cfe0ef          	jal	ra,80000c40 <release>
}
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6105                	addi	sp,sp,32
    80002bd0:	8082                	ret

0000000080002bd2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002bd2:	1101                	addi	sp,sp,-32
    80002bd4:	ec06                	sd	ra,24(sp)
    80002bd6:	e822                	sd	s0,16(sp)
    80002bd8:	e426                	sd	s1,8(sp)
    80002bda:	e04a                	sd	s2,0(sp)
    80002bdc:	1000                	addi	s0,sp,32
    80002bde:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002be0:	00d5d59b          	srliw	a1,a1,0xd
    80002be4:	0001b797          	auipc	a5,0x1b
    80002be8:	3907a783          	lw	a5,912(a5) # 8001df74 <sb+0x1c>
    80002bec:	9dbd                	addw	a1,a1,a5
    80002bee:	debff0ef          	jal	ra,800029d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002bf2:	0074f713          	andi	a4,s1,7
    80002bf6:	4785                	li	a5,1
    80002bf8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002bfc:	14ce                	slli	s1,s1,0x33
    80002bfe:	90d9                	srli	s1,s1,0x36
    80002c00:	00950733          	add	a4,a0,s1
    80002c04:	05874703          	lbu	a4,88(a4)
    80002c08:	00e7f6b3          	and	a3,a5,a4
    80002c0c:	c29d                	beqz	a3,80002c32 <bfree+0x60>
    80002c0e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c10:	94aa                	add	s1,s1,a0
    80002c12:	fff7c793          	not	a5,a5
    80002c16:	8ff9                	and	a5,a5,a4
    80002c18:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002c1c:	6e9000ef          	jal	ra,80003b04 <log_write>
  brelse(bp);
    80002c20:	854a                	mv	a0,s2
    80002c22:	ebfff0ef          	jal	ra,80002ae0 <brelse>
}
    80002c26:	60e2                	ld	ra,24(sp)
    80002c28:	6442                	ld	s0,16(sp)
    80002c2a:	64a2                	ld	s1,8(sp)
    80002c2c:	6902                	ld	s2,0(sp)
    80002c2e:	6105                	addi	sp,sp,32
    80002c30:	8082                	ret
    panic("freeing free block");
    80002c32:	00005517          	auipc	a0,0x5
    80002c36:	94650513          	addi	a0,a0,-1722 # 80007578 <syscalls+0xe8>
    80002c3a:	b23fd0ef          	jal	ra,8000075c <panic>

0000000080002c3e <balloc>:
{
    80002c3e:	711d                	addi	sp,sp,-96
    80002c40:	ec86                	sd	ra,88(sp)
    80002c42:	e8a2                	sd	s0,80(sp)
    80002c44:	e4a6                	sd	s1,72(sp)
    80002c46:	e0ca                	sd	s2,64(sp)
    80002c48:	fc4e                	sd	s3,56(sp)
    80002c4a:	f852                	sd	s4,48(sp)
    80002c4c:	f456                	sd	s5,40(sp)
    80002c4e:	f05a                	sd	s6,32(sp)
    80002c50:	ec5e                	sd	s7,24(sp)
    80002c52:	e862                	sd	s8,16(sp)
    80002c54:	e466                	sd	s9,8(sp)
    80002c56:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002c58:	0001b797          	auipc	a5,0x1b
    80002c5c:	3047a783          	lw	a5,772(a5) # 8001df5c <sb+0x4>
    80002c60:	0e078163          	beqz	a5,80002d42 <balloc+0x104>
    80002c64:	8baa                	mv	s7,a0
    80002c66:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002c68:	0001bb17          	auipc	s6,0x1b
    80002c6c:	2f0b0b13          	addi	s6,s6,752 # 8001df58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c70:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002c72:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c74:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002c76:	6c89                	lui	s9,0x2
    80002c78:	a0b5                	j	80002ce4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002c7a:	974a                	add	a4,a4,s2
    80002c7c:	8fd5                	or	a5,a5,a3
    80002c7e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002c82:	854a                	mv	a0,s2
    80002c84:	681000ef          	jal	ra,80003b04 <log_write>
        brelse(bp);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	e57ff0ef          	jal	ra,80002ae0 <brelse>
  bp = bread(dev, bno);
    80002c8e:	85a6                	mv	a1,s1
    80002c90:	855e                	mv	a0,s7
    80002c92:	d47ff0ef          	jal	ra,800029d8 <bread>
    80002c96:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002c98:	40000613          	li	a2,1024
    80002c9c:	4581                	li	a1,0
    80002c9e:	05850513          	addi	a0,a0,88
    80002ca2:	fdbfd0ef          	jal	ra,80000c7c <memset>
  log_write(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	65d000ef          	jal	ra,80003b04 <log_write>
  brelse(bp);
    80002cac:	854a                	mv	a0,s2
    80002cae:	e33ff0ef          	jal	ra,80002ae0 <brelse>
}
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	60e6                	ld	ra,88(sp)
    80002cb6:	6446                	ld	s0,80(sp)
    80002cb8:	64a6                	ld	s1,72(sp)
    80002cba:	6906                	ld	s2,64(sp)
    80002cbc:	79e2                	ld	s3,56(sp)
    80002cbe:	7a42                	ld	s4,48(sp)
    80002cc0:	7aa2                	ld	s5,40(sp)
    80002cc2:	7b02                	ld	s6,32(sp)
    80002cc4:	6be2                	ld	s7,24(sp)
    80002cc6:	6c42                	ld	s8,16(sp)
    80002cc8:	6ca2                	ld	s9,8(sp)
    80002cca:	6125                	addi	sp,sp,96
    80002ccc:	8082                	ret
    brelse(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	e11ff0ef          	jal	ra,80002ae0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002cd4:	015c87bb          	addw	a5,s9,s5
    80002cd8:	00078a9b          	sext.w	s5,a5
    80002cdc:	004b2703          	lw	a4,4(s6)
    80002ce0:	06eaf163          	bgeu	s5,a4,80002d42 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002ce4:	41fad79b          	sraiw	a5,s5,0x1f
    80002ce8:	0137d79b          	srliw	a5,a5,0x13
    80002cec:	015787bb          	addw	a5,a5,s5
    80002cf0:	40d7d79b          	sraiw	a5,a5,0xd
    80002cf4:	01cb2583          	lw	a1,28(s6)
    80002cf8:	9dbd                	addw	a1,a1,a5
    80002cfa:	855e                	mv	a0,s7
    80002cfc:	cddff0ef          	jal	ra,800029d8 <bread>
    80002d00:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d02:	004b2503          	lw	a0,4(s6)
    80002d06:	000a849b          	sext.w	s1,s5
    80002d0a:	8662                	mv	a2,s8
    80002d0c:	fca4f1e3          	bgeu	s1,a0,80002cce <balloc+0x90>
      m = 1 << (bi % 8);
    80002d10:	41f6579b          	sraiw	a5,a2,0x1f
    80002d14:	01d7d69b          	srliw	a3,a5,0x1d
    80002d18:	00c6873b          	addw	a4,a3,a2
    80002d1c:	00777793          	andi	a5,a4,7
    80002d20:	9f95                	subw	a5,a5,a3
    80002d22:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002d26:	4037571b          	sraiw	a4,a4,0x3
    80002d2a:	00e906b3          	add	a3,s2,a4
    80002d2e:	0586c683          	lbu	a3,88(a3)
    80002d32:	00d7f5b3          	and	a1,a5,a3
    80002d36:	d1b1                	beqz	a1,80002c7a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d38:	2605                	addiw	a2,a2,1
    80002d3a:	2485                	addiw	s1,s1,1
    80002d3c:	fd4618e3          	bne	a2,s4,80002d0c <balloc+0xce>
    80002d40:	b779                	j	80002cce <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002d42:	00005517          	auipc	a0,0x5
    80002d46:	84e50513          	addi	a0,a0,-1970 # 80007590 <syscalls+0x100>
    80002d4a:	f5efd0ef          	jal	ra,800004a8 <printf>
  return 0;
    80002d4e:	4481                	li	s1,0
    80002d50:	b78d                	j	80002cb2 <balloc+0x74>

0000000080002d52 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002d52:	7179                	addi	sp,sp,-48
    80002d54:	f406                	sd	ra,40(sp)
    80002d56:	f022                	sd	s0,32(sp)
    80002d58:	ec26                	sd	s1,24(sp)
    80002d5a:	e84a                	sd	s2,16(sp)
    80002d5c:	e44e                	sd	s3,8(sp)
    80002d5e:	e052                	sd	s4,0(sp)
    80002d60:	1800                	addi	s0,sp,48
    80002d62:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002d64:	47ad                	li	a5,11
    80002d66:	02b7e563          	bltu	a5,a1,80002d90 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002d6a:	02059493          	slli	s1,a1,0x20
    80002d6e:	9081                	srli	s1,s1,0x20
    80002d70:	048a                	slli	s1,s1,0x2
    80002d72:	94aa                	add	s1,s1,a0
    80002d74:	0504a903          	lw	s2,80(s1)
    80002d78:	06091663          	bnez	s2,80002de4 <bmap+0x92>
      addr = balloc(ip->dev);
    80002d7c:	4108                	lw	a0,0(a0)
    80002d7e:	ec1ff0ef          	jal	ra,80002c3e <balloc>
    80002d82:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d86:	04090f63          	beqz	s2,80002de4 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80002d8a:	0524a823          	sw	s2,80(s1)
    80002d8e:	a899                	j	80002de4 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002d90:	ff45849b          	addiw	s1,a1,-12
    80002d94:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002d98:	0ff00793          	li	a5,255
    80002d9c:	06e7eb63          	bltu	a5,a4,80002e12 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002da0:	08052903          	lw	s2,128(a0)
    80002da4:	00091b63          	bnez	s2,80002dba <bmap+0x68>
      addr = balloc(ip->dev);
    80002da8:	4108                	lw	a0,0(a0)
    80002daa:	e95ff0ef          	jal	ra,80002c3e <balloc>
    80002dae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002db2:	02090963          	beqz	s2,80002de4 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002db6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002dba:	85ca                	mv	a1,s2
    80002dbc:	0009a503          	lw	a0,0(s3)
    80002dc0:	c19ff0ef          	jal	ra,800029d8 <bread>
    80002dc4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002dc6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002dca:	02049593          	slli	a1,s1,0x20
    80002dce:	9181                	srli	a1,a1,0x20
    80002dd0:	058a                	slli	a1,a1,0x2
    80002dd2:	00b784b3          	add	s1,a5,a1
    80002dd6:	0004a903          	lw	s2,0(s1)
    80002dda:	00090e63          	beqz	s2,80002df6 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002dde:	8552                	mv	a0,s4
    80002de0:	d01ff0ef          	jal	ra,80002ae0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002de4:	854a                	mv	a0,s2
    80002de6:	70a2                	ld	ra,40(sp)
    80002de8:	7402                	ld	s0,32(sp)
    80002dea:	64e2                	ld	s1,24(sp)
    80002dec:	6942                	ld	s2,16(sp)
    80002dee:	69a2                	ld	s3,8(sp)
    80002df0:	6a02                	ld	s4,0(sp)
    80002df2:	6145                	addi	sp,sp,48
    80002df4:	8082                	ret
      addr = balloc(ip->dev);
    80002df6:	0009a503          	lw	a0,0(s3)
    80002dfa:	e45ff0ef          	jal	ra,80002c3e <balloc>
    80002dfe:	0005091b          	sext.w	s2,a0
      if(addr){
    80002e02:	fc090ee3          	beqz	s2,80002dde <bmap+0x8c>
        a[bn] = addr;
    80002e06:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002e0a:	8552                	mv	a0,s4
    80002e0c:	4f9000ef          	jal	ra,80003b04 <log_write>
    80002e10:	b7f9                	j	80002dde <bmap+0x8c>
  panic("bmap: out of range");
    80002e12:	00004517          	auipc	a0,0x4
    80002e16:	79650513          	addi	a0,a0,1942 # 800075a8 <syscalls+0x118>
    80002e1a:	943fd0ef          	jal	ra,8000075c <panic>

0000000080002e1e <iget>:
{
    80002e1e:	7179                	addi	sp,sp,-48
    80002e20:	f406                	sd	ra,40(sp)
    80002e22:	f022                	sd	s0,32(sp)
    80002e24:	ec26                	sd	s1,24(sp)
    80002e26:	e84a                	sd	s2,16(sp)
    80002e28:	e44e                	sd	s3,8(sp)
    80002e2a:	e052                	sd	s4,0(sp)
    80002e2c:	1800                	addi	s0,sp,48
    80002e2e:	89aa                	mv	s3,a0
    80002e30:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e32:	0001b517          	auipc	a0,0x1b
    80002e36:	14650513          	addi	a0,a0,326 # 8001df78 <itable>
    80002e3a:	d6ffd0ef          	jal	ra,80000ba8 <acquire>
  empty = 0;
    80002e3e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e40:	0001b497          	auipc	s1,0x1b
    80002e44:	15048493          	addi	s1,s1,336 # 8001df90 <itable+0x18>
    80002e48:	0001d697          	auipc	a3,0x1d
    80002e4c:	bd868693          	addi	a3,a3,-1064 # 8001fa20 <log>
    80002e50:	a039                	j	80002e5e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002e52:	02090963          	beqz	s2,80002e84 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e56:	08848493          	addi	s1,s1,136
    80002e5a:	02d48863          	beq	s1,a3,80002e8a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002e5e:	449c                	lw	a5,8(s1)
    80002e60:	fef059e3          	blez	a5,80002e52 <iget+0x34>
    80002e64:	4098                	lw	a4,0(s1)
    80002e66:	ff3716e3          	bne	a4,s3,80002e52 <iget+0x34>
    80002e6a:	40d8                	lw	a4,4(s1)
    80002e6c:	ff4713e3          	bne	a4,s4,80002e52 <iget+0x34>
      ip->ref++;
    80002e70:	2785                	addiw	a5,a5,1
    80002e72:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002e74:	0001b517          	auipc	a0,0x1b
    80002e78:	10450513          	addi	a0,a0,260 # 8001df78 <itable>
    80002e7c:	dc5fd0ef          	jal	ra,80000c40 <release>
      return ip;
    80002e80:	8926                	mv	s2,s1
    80002e82:	a02d                	j	80002eac <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002e84:	fbe9                	bnez	a5,80002e56 <iget+0x38>
    80002e86:	8926                	mv	s2,s1
    80002e88:	b7f9                	j	80002e56 <iget+0x38>
  if(empty == 0)
    80002e8a:	02090a63          	beqz	s2,80002ebe <iget+0xa0>
  ip->dev = dev;
    80002e8e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002e92:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002e96:	4785                	li	a5,1
    80002e98:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002e9c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ea0:	0001b517          	auipc	a0,0x1b
    80002ea4:	0d850513          	addi	a0,a0,216 # 8001df78 <itable>
    80002ea8:	d99fd0ef          	jal	ra,80000c40 <release>
}
    80002eac:	854a                	mv	a0,s2
    80002eae:	70a2                	ld	ra,40(sp)
    80002eb0:	7402                	ld	s0,32(sp)
    80002eb2:	64e2                	ld	s1,24(sp)
    80002eb4:	6942                	ld	s2,16(sp)
    80002eb6:	69a2                	ld	s3,8(sp)
    80002eb8:	6a02                	ld	s4,0(sp)
    80002eba:	6145                	addi	sp,sp,48
    80002ebc:	8082                	ret
    panic("iget: no inodes");
    80002ebe:	00004517          	auipc	a0,0x4
    80002ec2:	70250513          	addi	a0,a0,1794 # 800075c0 <syscalls+0x130>
    80002ec6:	897fd0ef          	jal	ra,8000075c <panic>

0000000080002eca <fsinit>:
fsinit(int dev) {
    80002eca:	7179                	addi	sp,sp,-48
    80002ecc:	f406                	sd	ra,40(sp)
    80002ece:	f022                	sd	s0,32(sp)
    80002ed0:	ec26                	sd	s1,24(sp)
    80002ed2:	e84a                	sd	s2,16(sp)
    80002ed4:	e44e                	sd	s3,8(sp)
    80002ed6:	1800                	addi	s0,sp,48
    80002ed8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002eda:	4585                	li	a1,1
    80002edc:	afdff0ef          	jal	ra,800029d8 <bread>
    80002ee0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ee2:	0001b997          	auipc	s3,0x1b
    80002ee6:	07698993          	addi	s3,s3,118 # 8001df58 <sb>
    80002eea:	02000613          	li	a2,32
    80002eee:	05850593          	addi	a1,a0,88
    80002ef2:	854e                	mv	a0,s3
    80002ef4:	de9fd0ef          	jal	ra,80000cdc <memmove>
  brelse(bp);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	be7ff0ef          	jal	ra,80002ae0 <brelse>
  if(sb.magic != FSMAGIC)
    80002efe:	0009a703          	lw	a4,0(s3)
    80002f02:	102037b7          	lui	a5,0x10203
    80002f06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f0a:	02f71063          	bne	a4,a5,80002f2a <fsinit+0x60>
  initlog(dev, &sb);
    80002f0e:	0001b597          	auipc	a1,0x1b
    80002f12:	04a58593          	addi	a1,a1,74 # 8001df58 <sb>
    80002f16:	854a                	mv	a0,s2
    80002f18:	1d9000ef          	jal	ra,800038f0 <initlog>
}
    80002f1c:	70a2                	ld	ra,40(sp)
    80002f1e:	7402                	ld	s0,32(sp)
    80002f20:	64e2                	ld	s1,24(sp)
    80002f22:	6942                	ld	s2,16(sp)
    80002f24:	69a2                	ld	s3,8(sp)
    80002f26:	6145                	addi	sp,sp,48
    80002f28:	8082                	ret
    panic("invalid file system");
    80002f2a:	00004517          	auipc	a0,0x4
    80002f2e:	6a650513          	addi	a0,a0,1702 # 800075d0 <syscalls+0x140>
    80002f32:	82bfd0ef          	jal	ra,8000075c <panic>

0000000080002f36 <iinit>:
{
    80002f36:	7179                	addi	sp,sp,-48
    80002f38:	f406                	sd	ra,40(sp)
    80002f3a:	f022                	sd	s0,32(sp)
    80002f3c:	ec26                	sd	s1,24(sp)
    80002f3e:	e84a                	sd	s2,16(sp)
    80002f40:	e44e                	sd	s3,8(sp)
    80002f42:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002f44:	00004597          	auipc	a1,0x4
    80002f48:	6a458593          	addi	a1,a1,1700 # 800075e8 <syscalls+0x158>
    80002f4c:	0001b517          	auipc	a0,0x1b
    80002f50:	02c50513          	addi	a0,a0,44 # 8001df78 <itable>
    80002f54:	bd5fd0ef          	jal	ra,80000b28 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002f58:	0001b497          	auipc	s1,0x1b
    80002f5c:	04848493          	addi	s1,s1,72 # 8001dfa0 <itable+0x28>
    80002f60:	0001d997          	auipc	s3,0x1d
    80002f64:	ad098993          	addi	s3,s3,-1328 # 8001fa30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002f68:	00004917          	auipc	s2,0x4
    80002f6c:	68890913          	addi	s2,s2,1672 # 800075f0 <syscalls+0x160>
    80002f70:	85ca                	mv	a1,s2
    80002f72:	8526                	mv	a0,s1
    80002f74:	463000ef          	jal	ra,80003bd6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002f78:	08848493          	addi	s1,s1,136
    80002f7c:	ff349ae3          	bne	s1,s3,80002f70 <iinit+0x3a>
}
    80002f80:	70a2                	ld	ra,40(sp)
    80002f82:	7402                	ld	s0,32(sp)
    80002f84:	64e2                	ld	s1,24(sp)
    80002f86:	6942                	ld	s2,16(sp)
    80002f88:	69a2                	ld	s3,8(sp)
    80002f8a:	6145                	addi	sp,sp,48
    80002f8c:	8082                	ret

0000000080002f8e <ialloc>:
{
    80002f8e:	715d                	addi	sp,sp,-80
    80002f90:	e486                	sd	ra,72(sp)
    80002f92:	e0a2                	sd	s0,64(sp)
    80002f94:	fc26                	sd	s1,56(sp)
    80002f96:	f84a                	sd	s2,48(sp)
    80002f98:	f44e                	sd	s3,40(sp)
    80002f9a:	f052                	sd	s4,32(sp)
    80002f9c:	ec56                	sd	s5,24(sp)
    80002f9e:	e85a                	sd	s6,16(sp)
    80002fa0:	e45e                	sd	s7,8(sp)
    80002fa2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fa4:	0001b717          	auipc	a4,0x1b
    80002fa8:	fc072703          	lw	a4,-64(a4) # 8001df64 <sb+0xc>
    80002fac:	4785                	li	a5,1
    80002fae:	04e7f663          	bgeu	a5,a4,80002ffa <ialloc+0x6c>
    80002fb2:	8aaa                	mv	s5,a0
    80002fb4:	8bae                	mv	s7,a1
    80002fb6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002fb8:	0001ba17          	auipc	s4,0x1b
    80002fbc:	fa0a0a13          	addi	s4,s4,-96 # 8001df58 <sb>
    80002fc0:	00048b1b          	sext.w	s6,s1
    80002fc4:	0044d593          	srli	a1,s1,0x4
    80002fc8:	018a2783          	lw	a5,24(s4)
    80002fcc:	9dbd                	addw	a1,a1,a5
    80002fce:	8556                	mv	a0,s5
    80002fd0:	a09ff0ef          	jal	ra,800029d8 <bread>
    80002fd4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002fd6:	05850993          	addi	s3,a0,88
    80002fda:	00f4f793          	andi	a5,s1,15
    80002fde:	079a                	slli	a5,a5,0x6
    80002fe0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002fe2:	00099783          	lh	a5,0(s3)
    80002fe6:	cf85                	beqz	a5,8000301e <ialloc+0x90>
    brelse(bp);
    80002fe8:	af9ff0ef          	jal	ra,80002ae0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fec:	0485                	addi	s1,s1,1
    80002fee:	00ca2703          	lw	a4,12(s4)
    80002ff2:	0004879b          	sext.w	a5,s1
    80002ff6:	fce7e5e3          	bltu	a5,a4,80002fc0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002ffa:	00004517          	auipc	a0,0x4
    80002ffe:	5fe50513          	addi	a0,a0,1534 # 800075f8 <syscalls+0x168>
    80003002:	ca6fd0ef          	jal	ra,800004a8 <printf>
  return 0;
    80003006:	4501                	li	a0,0
}
    80003008:	60a6                	ld	ra,72(sp)
    8000300a:	6406                	ld	s0,64(sp)
    8000300c:	74e2                	ld	s1,56(sp)
    8000300e:	7942                	ld	s2,48(sp)
    80003010:	79a2                	ld	s3,40(sp)
    80003012:	7a02                	ld	s4,32(sp)
    80003014:	6ae2                	ld	s5,24(sp)
    80003016:	6b42                	ld	s6,16(sp)
    80003018:	6ba2                	ld	s7,8(sp)
    8000301a:	6161                	addi	sp,sp,80
    8000301c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000301e:	04000613          	li	a2,64
    80003022:	4581                	li	a1,0
    80003024:	854e                	mv	a0,s3
    80003026:	c57fd0ef          	jal	ra,80000c7c <memset>
      dip->type = type;
    8000302a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000302e:	854a                	mv	a0,s2
    80003030:	2d5000ef          	jal	ra,80003b04 <log_write>
      brelse(bp);
    80003034:	854a                	mv	a0,s2
    80003036:	aabff0ef          	jal	ra,80002ae0 <brelse>
      return iget(dev, inum);
    8000303a:	85da                	mv	a1,s6
    8000303c:	8556                	mv	a0,s5
    8000303e:	de1ff0ef          	jal	ra,80002e1e <iget>
    80003042:	b7d9                	j	80003008 <ialloc+0x7a>

0000000080003044 <iupdate>:
{
    80003044:	1101                	addi	sp,sp,-32
    80003046:	ec06                	sd	ra,24(sp)
    80003048:	e822                	sd	s0,16(sp)
    8000304a:	e426                	sd	s1,8(sp)
    8000304c:	e04a                	sd	s2,0(sp)
    8000304e:	1000                	addi	s0,sp,32
    80003050:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003052:	415c                	lw	a5,4(a0)
    80003054:	0047d79b          	srliw	a5,a5,0x4
    80003058:	0001b597          	auipc	a1,0x1b
    8000305c:	f185a583          	lw	a1,-232(a1) # 8001df70 <sb+0x18>
    80003060:	9dbd                	addw	a1,a1,a5
    80003062:	4108                	lw	a0,0(a0)
    80003064:	975ff0ef          	jal	ra,800029d8 <bread>
    80003068:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000306a:	05850793          	addi	a5,a0,88
    8000306e:	40c8                	lw	a0,4(s1)
    80003070:	893d                	andi	a0,a0,15
    80003072:	051a                	slli	a0,a0,0x6
    80003074:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003076:	04449703          	lh	a4,68(s1)
    8000307a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000307e:	04649703          	lh	a4,70(s1)
    80003082:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003086:	04849703          	lh	a4,72(s1)
    8000308a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000308e:	04a49703          	lh	a4,74(s1)
    80003092:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003096:	44f8                	lw	a4,76(s1)
    80003098:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000309a:	03400613          	li	a2,52
    8000309e:	05048593          	addi	a1,s1,80
    800030a2:	0531                	addi	a0,a0,12
    800030a4:	c39fd0ef          	jal	ra,80000cdc <memmove>
  log_write(bp);
    800030a8:	854a                	mv	a0,s2
    800030aa:	25b000ef          	jal	ra,80003b04 <log_write>
  brelse(bp);
    800030ae:	854a                	mv	a0,s2
    800030b0:	a31ff0ef          	jal	ra,80002ae0 <brelse>
}
    800030b4:	60e2                	ld	ra,24(sp)
    800030b6:	6442                	ld	s0,16(sp)
    800030b8:	64a2                	ld	s1,8(sp)
    800030ba:	6902                	ld	s2,0(sp)
    800030bc:	6105                	addi	sp,sp,32
    800030be:	8082                	ret

00000000800030c0 <idup>:
{
    800030c0:	1101                	addi	sp,sp,-32
    800030c2:	ec06                	sd	ra,24(sp)
    800030c4:	e822                	sd	s0,16(sp)
    800030c6:	e426                	sd	s1,8(sp)
    800030c8:	1000                	addi	s0,sp,32
    800030ca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030cc:	0001b517          	auipc	a0,0x1b
    800030d0:	eac50513          	addi	a0,a0,-340 # 8001df78 <itable>
    800030d4:	ad5fd0ef          	jal	ra,80000ba8 <acquire>
  ip->ref++;
    800030d8:	449c                	lw	a5,8(s1)
    800030da:	2785                	addiw	a5,a5,1
    800030dc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030de:	0001b517          	auipc	a0,0x1b
    800030e2:	e9a50513          	addi	a0,a0,-358 # 8001df78 <itable>
    800030e6:	b5bfd0ef          	jal	ra,80000c40 <release>
}
    800030ea:	8526                	mv	a0,s1
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6105                	addi	sp,sp,32
    800030f4:	8082                	ret

00000000800030f6 <ilock>:
{
    800030f6:	1101                	addi	sp,sp,-32
    800030f8:	ec06                	sd	ra,24(sp)
    800030fa:	e822                	sd	s0,16(sp)
    800030fc:	e426                	sd	s1,8(sp)
    800030fe:	e04a                	sd	s2,0(sp)
    80003100:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003102:	c105                	beqz	a0,80003122 <ilock+0x2c>
    80003104:	84aa                	mv	s1,a0
    80003106:	451c                	lw	a5,8(a0)
    80003108:	00f05d63          	blez	a5,80003122 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000310c:	0541                	addi	a0,a0,16
    8000310e:	2ff000ef          	jal	ra,80003c0c <acquiresleep>
  if(ip->valid == 0){
    80003112:	40bc                	lw	a5,64(s1)
    80003114:	cf89                	beqz	a5,8000312e <ilock+0x38>
}
    80003116:	60e2                	ld	ra,24(sp)
    80003118:	6442                	ld	s0,16(sp)
    8000311a:	64a2                	ld	s1,8(sp)
    8000311c:	6902                	ld	s2,0(sp)
    8000311e:	6105                	addi	sp,sp,32
    80003120:	8082                	ret
    panic("ilock");
    80003122:	00004517          	auipc	a0,0x4
    80003126:	4ee50513          	addi	a0,a0,1262 # 80007610 <syscalls+0x180>
    8000312a:	e32fd0ef          	jal	ra,8000075c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000312e:	40dc                	lw	a5,4(s1)
    80003130:	0047d79b          	srliw	a5,a5,0x4
    80003134:	0001b597          	auipc	a1,0x1b
    80003138:	e3c5a583          	lw	a1,-452(a1) # 8001df70 <sb+0x18>
    8000313c:	9dbd                	addw	a1,a1,a5
    8000313e:	4088                	lw	a0,0(s1)
    80003140:	899ff0ef          	jal	ra,800029d8 <bread>
    80003144:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003146:	05850593          	addi	a1,a0,88
    8000314a:	40dc                	lw	a5,4(s1)
    8000314c:	8bbd                	andi	a5,a5,15
    8000314e:	079a                	slli	a5,a5,0x6
    80003150:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003152:	00059783          	lh	a5,0(a1)
    80003156:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000315a:	00259783          	lh	a5,2(a1)
    8000315e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003162:	00459783          	lh	a5,4(a1)
    80003166:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000316a:	00659783          	lh	a5,6(a1)
    8000316e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003172:	459c                	lw	a5,8(a1)
    80003174:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003176:	03400613          	li	a2,52
    8000317a:	05b1                	addi	a1,a1,12
    8000317c:	05048513          	addi	a0,s1,80
    80003180:	b5dfd0ef          	jal	ra,80000cdc <memmove>
    brelse(bp);
    80003184:	854a                	mv	a0,s2
    80003186:	95bff0ef          	jal	ra,80002ae0 <brelse>
    ip->valid = 1;
    8000318a:	4785                	li	a5,1
    8000318c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000318e:	04449783          	lh	a5,68(s1)
    80003192:	f3d1                	bnez	a5,80003116 <ilock+0x20>
      panic("ilock: no type");
    80003194:	00004517          	auipc	a0,0x4
    80003198:	48450513          	addi	a0,a0,1156 # 80007618 <syscalls+0x188>
    8000319c:	dc0fd0ef          	jal	ra,8000075c <panic>

00000000800031a0 <iunlock>:
{
    800031a0:	1101                	addi	sp,sp,-32
    800031a2:	ec06                	sd	ra,24(sp)
    800031a4:	e822                	sd	s0,16(sp)
    800031a6:	e426                	sd	s1,8(sp)
    800031a8:	e04a                	sd	s2,0(sp)
    800031aa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800031ac:	c505                	beqz	a0,800031d4 <iunlock+0x34>
    800031ae:	84aa                	mv	s1,a0
    800031b0:	01050913          	addi	s2,a0,16
    800031b4:	854a                	mv	a0,s2
    800031b6:	2d5000ef          	jal	ra,80003c8a <holdingsleep>
    800031ba:	cd09                	beqz	a0,800031d4 <iunlock+0x34>
    800031bc:	449c                	lw	a5,8(s1)
    800031be:	00f05b63          	blez	a5,800031d4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800031c2:	854a                	mv	a0,s2
    800031c4:	28f000ef          	jal	ra,80003c52 <releasesleep>
}
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	64a2                	ld	s1,8(sp)
    800031ce:	6902                	ld	s2,0(sp)
    800031d0:	6105                	addi	sp,sp,32
    800031d2:	8082                	ret
    panic("iunlock");
    800031d4:	00004517          	auipc	a0,0x4
    800031d8:	45450513          	addi	a0,a0,1108 # 80007628 <syscalls+0x198>
    800031dc:	d80fd0ef          	jal	ra,8000075c <panic>

00000000800031e0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800031e0:	7179                	addi	sp,sp,-48
    800031e2:	f406                	sd	ra,40(sp)
    800031e4:	f022                	sd	s0,32(sp)
    800031e6:	ec26                	sd	s1,24(sp)
    800031e8:	e84a                	sd	s2,16(sp)
    800031ea:	e44e                	sd	s3,8(sp)
    800031ec:	e052                	sd	s4,0(sp)
    800031ee:	1800                	addi	s0,sp,48
    800031f0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800031f2:	05050493          	addi	s1,a0,80
    800031f6:	08050913          	addi	s2,a0,128
    800031fa:	a021                	j	80003202 <itrunc+0x22>
    800031fc:	0491                	addi	s1,s1,4
    800031fe:	01248b63          	beq	s1,s2,80003214 <itrunc+0x34>
    if(ip->addrs[i]){
    80003202:	408c                	lw	a1,0(s1)
    80003204:	dde5                	beqz	a1,800031fc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003206:	0009a503          	lw	a0,0(s3)
    8000320a:	9c9ff0ef          	jal	ra,80002bd2 <bfree>
      ip->addrs[i] = 0;
    8000320e:	0004a023          	sw	zero,0(s1)
    80003212:	b7ed                	j	800031fc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003214:	0809a583          	lw	a1,128(s3)
    80003218:	ed91                	bnez	a1,80003234 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000321a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000321e:	854e                	mv	a0,s3
    80003220:	e25ff0ef          	jal	ra,80003044 <iupdate>
}
    80003224:	70a2                	ld	ra,40(sp)
    80003226:	7402                	ld	s0,32(sp)
    80003228:	64e2                	ld	s1,24(sp)
    8000322a:	6942                	ld	s2,16(sp)
    8000322c:	69a2                	ld	s3,8(sp)
    8000322e:	6a02                	ld	s4,0(sp)
    80003230:	6145                	addi	sp,sp,48
    80003232:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003234:	0009a503          	lw	a0,0(s3)
    80003238:	fa0ff0ef          	jal	ra,800029d8 <bread>
    8000323c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000323e:	05850493          	addi	s1,a0,88
    80003242:	45850913          	addi	s2,a0,1112
    80003246:	a801                	j	80003256 <itrunc+0x76>
        bfree(ip->dev, a[j]);
    80003248:	0009a503          	lw	a0,0(s3)
    8000324c:	987ff0ef          	jal	ra,80002bd2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003250:	0491                	addi	s1,s1,4
    80003252:	01248563          	beq	s1,s2,8000325c <itrunc+0x7c>
      if(a[j])
    80003256:	408c                	lw	a1,0(s1)
    80003258:	dde5                	beqz	a1,80003250 <itrunc+0x70>
    8000325a:	b7fd                	j	80003248 <itrunc+0x68>
    brelse(bp);
    8000325c:	8552                	mv	a0,s4
    8000325e:	883ff0ef          	jal	ra,80002ae0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003262:	0809a583          	lw	a1,128(s3)
    80003266:	0009a503          	lw	a0,0(s3)
    8000326a:	969ff0ef          	jal	ra,80002bd2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000326e:	0809a023          	sw	zero,128(s3)
    80003272:	b765                	j	8000321a <itrunc+0x3a>

0000000080003274 <iput>:
{
    80003274:	1101                	addi	sp,sp,-32
    80003276:	ec06                	sd	ra,24(sp)
    80003278:	e822                	sd	s0,16(sp)
    8000327a:	e426                	sd	s1,8(sp)
    8000327c:	e04a                	sd	s2,0(sp)
    8000327e:	1000                	addi	s0,sp,32
    80003280:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003282:	0001b517          	auipc	a0,0x1b
    80003286:	cf650513          	addi	a0,a0,-778 # 8001df78 <itable>
    8000328a:	91ffd0ef          	jal	ra,80000ba8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000328e:	4498                	lw	a4,8(s1)
    80003290:	4785                	li	a5,1
    80003292:	02f70163          	beq	a4,a5,800032b4 <iput+0x40>
  ip->ref--;
    80003296:	449c                	lw	a5,8(s1)
    80003298:	37fd                	addiw	a5,a5,-1
    8000329a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000329c:	0001b517          	auipc	a0,0x1b
    800032a0:	cdc50513          	addi	a0,a0,-804 # 8001df78 <itable>
    800032a4:	99dfd0ef          	jal	ra,80000c40 <release>
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6902                	ld	s2,0(sp)
    800032b0:	6105                	addi	sp,sp,32
    800032b2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032b4:	40bc                	lw	a5,64(s1)
    800032b6:	d3e5                	beqz	a5,80003296 <iput+0x22>
    800032b8:	04a49783          	lh	a5,74(s1)
    800032bc:	ffe9                	bnez	a5,80003296 <iput+0x22>
    acquiresleep(&ip->lock);
    800032be:	01048913          	addi	s2,s1,16
    800032c2:	854a                	mv	a0,s2
    800032c4:	149000ef          	jal	ra,80003c0c <acquiresleep>
    release(&itable.lock);
    800032c8:	0001b517          	auipc	a0,0x1b
    800032cc:	cb050513          	addi	a0,a0,-848 # 8001df78 <itable>
    800032d0:	971fd0ef          	jal	ra,80000c40 <release>
    itrunc(ip);
    800032d4:	8526                	mv	a0,s1
    800032d6:	f0bff0ef          	jal	ra,800031e0 <itrunc>
    ip->type = 0;
    800032da:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800032de:	8526                	mv	a0,s1
    800032e0:	d65ff0ef          	jal	ra,80003044 <iupdate>
    ip->valid = 0;
    800032e4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800032e8:	854a                	mv	a0,s2
    800032ea:	169000ef          	jal	ra,80003c52 <releasesleep>
    acquire(&itable.lock);
    800032ee:	0001b517          	auipc	a0,0x1b
    800032f2:	c8a50513          	addi	a0,a0,-886 # 8001df78 <itable>
    800032f6:	8b3fd0ef          	jal	ra,80000ba8 <acquire>
    800032fa:	bf71                	j	80003296 <iput+0x22>

00000000800032fc <iunlockput>:
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	1000                	addi	s0,sp,32
    80003306:	84aa                	mv	s1,a0
  iunlock(ip);
    80003308:	e99ff0ef          	jal	ra,800031a0 <iunlock>
  iput(ip);
    8000330c:	8526                	mv	a0,s1
    8000330e:	f67ff0ef          	jal	ra,80003274 <iput>
}
    80003312:	60e2                	ld	ra,24(sp)
    80003314:	6442                	ld	s0,16(sp)
    80003316:	64a2                	ld	s1,8(sp)
    80003318:	6105                	addi	sp,sp,32
    8000331a:	8082                	ret

000000008000331c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000331c:	1141                	addi	sp,sp,-16
    8000331e:	e422                	sd	s0,8(sp)
    80003320:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003322:	411c                	lw	a5,0(a0)
    80003324:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003326:	415c                	lw	a5,4(a0)
    80003328:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000332a:	04451783          	lh	a5,68(a0)
    8000332e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003332:	04a51783          	lh	a5,74(a0)
    80003336:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000333a:	04c56783          	lwu	a5,76(a0)
    8000333e:	e99c                	sd	a5,16(a1)
}
    80003340:	6422                	ld	s0,8(sp)
    80003342:	0141                	addi	sp,sp,16
    80003344:	8082                	ret

0000000080003346 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003346:	457c                	lw	a5,76(a0)
    80003348:	0cd7ef63          	bltu	a5,a3,80003426 <readi+0xe0>
{
    8000334c:	7159                	addi	sp,sp,-112
    8000334e:	f486                	sd	ra,104(sp)
    80003350:	f0a2                	sd	s0,96(sp)
    80003352:	eca6                	sd	s1,88(sp)
    80003354:	e8ca                	sd	s2,80(sp)
    80003356:	e4ce                	sd	s3,72(sp)
    80003358:	e0d2                	sd	s4,64(sp)
    8000335a:	fc56                	sd	s5,56(sp)
    8000335c:	f85a                	sd	s6,48(sp)
    8000335e:	f45e                	sd	s7,40(sp)
    80003360:	f062                	sd	s8,32(sp)
    80003362:	ec66                	sd	s9,24(sp)
    80003364:	e86a                	sd	s10,16(sp)
    80003366:	e46e                	sd	s11,8(sp)
    80003368:	1880                	addi	s0,sp,112
    8000336a:	8b2a                	mv	s6,a0
    8000336c:	8bae                	mv	s7,a1
    8000336e:	8a32                	mv	s4,a2
    80003370:	84b6                	mv	s1,a3
    80003372:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003374:	9f35                	addw	a4,a4,a3
    return 0;
    80003376:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003378:	08d76663          	bltu	a4,a3,80003404 <readi+0xbe>
  if(off + n > ip->size)
    8000337c:	00e7f463          	bgeu	a5,a4,80003384 <readi+0x3e>
    n = ip->size - off;
    80003380:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003384:	080a8f63          	beqz	s5,80003422 <readi+0xdc>
    80003388:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000338a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000338e:	5c7d                	li	s8,-1
    80003390:	a80d                	j	800033c2 <readi+0x7c>
    80003392:	020d1d93          	slli	s11,s10,0x20
    80003396:	020ddd93          	srli	s11,s11,0x20
    8000339a:	05890613          	addi	a2,s2,88
    8000339e:	86ee                	mv	a3,s11
    800033a0:	963a                	add	a2,a2,a4
    800033a2:	85d2                	mv	a1,s4
    800033a4:	855e                	mv	a0,s7
    800033a6:	dbffe0ef          	jal	ra,80002164 <either_copyout>
    800033aa:	05850763          	beq	a0,s8,800033f8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800033ae:	854a                	mv	a0,s2
    800033b0:	f30ff0ef          	jal	ra,80002ae0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033b4:	013d09bb          	addw	s3,s10,s3
    800033b8:	009d04bb          	addw	s1,s10,s1
    800033bc:	9a6e                	add	s4,s4,s11
    800033be:	0559f163          	bgeu	s3,s5,80003400 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800033c2:	00a4d59b          	srliw	a1,s1,0xa
    800033c6:	855a                	mv	a0,s6
    800033c8:	98bff0ef          	jal	ra,80002d52 <bmap>
    800033cc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033d0:	c985                	beqz	a1,80003400 <readi+0xba>
    bp = bread(ip->dev, addr);
    800033d2:	000b2503          	lw	a0,0(s6)
    800033d6:	e02ff0ef          	jal	ra,800029d8 <bread>
    800033da:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033dc:	3ff4f713          	andi	a4,s1,1023
    800033e0:	40ec87bb          	subw	a5,s9,a4
    800033e4:	413a86bb          	subw	a3,s5,s3
    800033e8:	8d3e                	mv	s10,a5
    800033ea:	2781                	sext.w	a5,a5
    800033ec:	0006861b          	sext.w	a2,a3
    800033f0:	faf671e3          	bgeu	a2,a5,80003392 <readi+0x4c>
    800033f4:	8d36                	mv	s10,a3
    800033f6:	bf71                	j	80003392 <readi+0x4c>
      brelse(bp);
    800033f8:	854a                	mv	a0,s2
    800033fa:	ee6ff0ef          	jal	ra,80002ae0 <brelse>
      tot = -1;
    800033fe:	59fd                	li	s3,-1
  }
  return tot;
    80003400:	0009851b          	sext.w	a0,s3
}
    80003404:	70a6                	ld	ra,104(sp)
    80003406:	7406                	ld	s0,96(sp)
    80003408:	64e6                	ld	s1,88(sp)
    8000340a:	6946                	ld	s2,80(sp)
    8000340c:	69a6                	ld	s3,72(sp)
    8000340e:	6a06                	ld	s4,64(sp)
    80003410:	7ae2                	ld	s5,56(sp)
    80003412:	7b42                	ld	s6,48(sp)
    80003414:	7ba2                	ld	s7,40(sp)
    80003416:	7c02                	ld	s8,32(sp)
    80003418:	6ce2                	ld	s9,24(sp)
    8000341a:	6d42                	ld	s10,16(sp)
    8000341c:	6da2                	ld	s11,8(sp)
    8000341e:	6165                	addi	sp,sp,112
    80003420:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003422:	89d6                	mv	s3,s5
    80003424:	bff1                	j	80003400 <readi+0xba>
    return 0;
    80003426:	4501                	li	a0,0
}
    80003428:	8082                	ret

000000008000342a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000342a:	457c                	lw	a5,76(a0)
    8000342c:	0ed7ea63          	bltu	a5,a3,80003520 <writei+0xf6>
{
    80003430:	7159                	addi	sp,sp,-112
    80003432:	f486                	sd	ra,104(sp)
    80003434:	f0a2                	sd	s0,96(sp)
    80003436:	eca6                	sd	s1,88(sp)
    80003438:	e8ca                	sd	s2,80(sp)
    8000343a:	e4ce                	sd	s3,72(sp)
    8000343c:	e0d2                	sd	s4,64(sp)
    8000343e:	fc56                	sd	s5,56(sp)
    80003440:	f85a                	sd	s6,48(sp)
    80003442:	f45e                	sd	s7,40(sp)
    80003444:	f062                	sd	s8,32(sp)
    80003446:	ec66                	sd	s9,24(sp)
    80003448:	e86a                	sd	s10,16(sp)
    8000344a:	e46e                	sd	s11,8(sp)
    8000344c:	1880                	addi	s0,sp,112
    8000344e:	8aaa                	mv	s5,a0
    80003450:	8bae                	mv	s7,a1
    80003452:	8a32                	mv	s4,a2
    80003454:	8936                	mv	s2,a3
    80003456:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003458:	00e687bb          	addw	a5,a3,a4
    8000345c:	0cd7e463          	bltu	a5,a3,80003524 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003460:	00043737          	lui	a4,0x43
    80003464:	0cf76263          	bltu	a4,a5,80003528 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003468:	0a0b0a63          	beqz	s6,8000351c <writei+0xf2>
    8000346c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000346e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003472:	5c7d                	li	s8,-1
    80003474:	a825                	j	800034ac <writei+0x82>
    80003476:	020d1d93          	slli	s11,s10,0x20
    8000347a:	020ddd93          	srli	s11,s11,0x20
    8000347e:	05848513          	addi	a0,s1,88
    80003482:	86ee                	mv	a3,s11
    80003484:	8652                	mv	a2,s4
    80003486:	85de                	mv	a1,s7
    80003488:	953a                	add	a0,a0,a4
    8000348a:	d25fe0ef          	jal	ra,800021ae <either_copyin>
    8000348e:	05850a63          	beq	a0,s8,800034e2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003492:	8526                	mv	a0,s1
    80003494:	670000ef          	jal	ra,80003b04 <log_write>
    brelse(bp);
    80003498:	8526                	mv	a0,s1
    8000349a:	e46ff0ef          	jal	ra,80002ae0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000349e:	013d09bb          	addw	s3,s10,s3
    800034a2:	012d093b          	addw	s2,s10,s2
    800034a6:	9a6e                	add	s4,s4,s11
    800034a8:	0569f063          	bgeu	s3,s6,800034e8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800034ac:	00a9559b          	srliw	a1,s2,0xa
    800034b0:	8556                	mv	a0,s5
    800034b2:	8a1ff0ef          	jal	ra,80002d52 <bmap>
    800034b6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034ba:	c59d                	beqz	a1,800034e8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800034bc:	000aa503          	lw	a0,0(s5)
    800034c0:	d18ff0ef          	jal	ra,800029d8 <bread>
    800034c4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034c6:	3ff97713          	andi	a4,s2,1023
    800034ca:	40ec87bb          	subw	a5,s9,a4
    800034ce:	413b06bb          	subw	a3,s6,s3
    800034d2:	8d3e                	mv	s10,a5
    800034d4:	2781                	sext.w	a5,a5
    800034d6:	0006861b          	sext.w	a2,a3
    800034da:	f8f67ee3          	bgeu	a2,a5,80003476 <writei+0x4c>
    800034de:	8d36                	mv	s10,a3
    800034e0:	bf59                	j	80003476 <writei+0x4c>
      brelse(bp);
    800034e2:	8526                	mv	a0,s1
    800034e4:	dfcff0ef          	jal	ra,80002ae0 <brelse>
  }

  if(off > ip->size)
    800034e8:	04caa783          	lw	a5,76(s5)
    800034ec:	0127f463          	bgeu	a5,s2,800034f4 <writei+0xca>
    ip->size = off;
    800034f0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800034f4:	8556                	mv	a0,s5
    800034f6:	b4fff0ef          	jal	ra,80003044 <iupdate>

  return tot;
    800034fa:	0009851b          	sext.w	a0,s3
}
    800034fe:	70a6                	ld	ra,104(sp)
    80003500:	7406                	ld	s0,96(sp)
    80003502:	64e6                	ld	s1,88(sp)
    80003504:	6946                	ld	s2,80(sp)
    80003506:	69a6                	ld	s3,72(sp)
    80003508:	6a06                	ld	s4,64(sp)
    8000350a:	7ae2                	ld	s5,56(sp)
    8000350c:	7b42                	ld	s6,48(sp)
    8000350e:	7ba2                	ld	s7,40(sp)
    80003510:	7c02                	ld	s8,32(sp)
    80003512:	6ce2                	ld	s9,24(sp)
    80003514:	6d42                	ld	s10,16(sp)
    80003516:	6da2                	ld	s11,8(sp)
    80003518:	6165                	addi	sp,sp,112
    8000351a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000351c:	89da                	mv	s3,s6
    8000351e:	bfd9                	j	800034f4 <writei+0xca>
    return -1;
    80003520:	557d                	li	a0,-1
}
    80003522:	8082                	ret
    return -1;
    80003524:	557d                	li	a0,-1
    80003526:	bfe1                	j	800034fe <writei+0xd4>
    return -1;
    80003528:	557d                	li	a0,-1
    8000352a:	bfd1                	j	800034fe <writei+0xd4>

000000008000352c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000352c:	1141                	addi	sp,sp,-16
    8000352e:	e406                	sd	ra,8(sp)
    80003530:	e022                	sd	s0,0(sp)
    80003532:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003534:	4639                	li	a2,14
    80003536:	81bfd0ef          	jal	ra,80000d50 <strncmp>
}
    8000353a:	60a2                	ld	ra,8(sp)
    8000353c:	6402                	ld	s0,0(sp)
    8000353e:	0141                	addi	sp,sp,16
    80003540:	8082                	ret

0000000080003542 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003542:	7139                	addi	sp,sp,-64
    80003544:	fc06                	sd	ra,56(sp)
    80003546:	f822                	sd	s0,48(sp)
    80003548:	f426                	sd	s1,40(sp)
    8000354a:	f04a                	sd	s2,32(sp)
    8000354c:	ec4e                	sd	s3,24(sp)
    8000354e:	e852                	sd	s4,16(sp)
    80003550:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003552:	04451703          	lh	a4,68(a0)
    80003556:	4785                	li	a5,1
    80003558:	00f71a63          	bne	a4,a5,8000356c <dirlookup+0x2a>
    8000355c:	892a                	mv	s2,a0
    8000355e:	89ae                	mv	s3,a1
    80003560:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003562:	457c                	lw	a5,76(a0)
    80003564:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003566:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003568:	e39d                	bnez	a5,8000358e <dirlookup+0x4c>
    8000356a:	a095                	j	800035ce <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000356c:	00004517          	auipc	a0,0x4
    80003570:	0c450513          	addi	a0,a0,196 # 80007630 <syscalls+0x1a0>
    80003574:	9e8fd0ef          	jal	ra,8000075c <panic>
      panic("dirlookup read");
    80003578:	00004517          	auipc	a0,0x4
    8000357c:	0d050513          	addi	a0,a0,208 # 80007648 <syscalls+0x1b8>
    80003580:	9dcfd0ef          	jal	ra,8000075c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003584:	24c1                	addiw	s1,s1,16
    80003586:	04c92783          	lw	a5,76(s2)
    8000358a:	04f4f163          	bgeu	s1,a5,800035cc <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000358e:	4741                	li	a4,16
    80003590:	86a6                	mv	a3,s1
    80003592:	fc040613          	addi	a2,s0,-64
    80003596:	4581                	li	a1,0
    80003598:	854a                	mv	a0,s2
    8000359a:	dadff0ef          	jal	ra,80003346 <readi>
    8000359e:	47c1                	li	a5,16
    800035a0:	fcf51ce3          	bne	a0,a5,80003578 <dirlookup+0x36>
    if(de.inum == 0)
    800035a4:	fc045783          	lhu	a5,-64(s0)
    800035a8:	dff1                	beqz	a5,80003584 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800035aa:	fc240593          	addi	a1,s0,-62
    800035ae:	854e                	mv	a0,s3
    800035b0:	f7dff0ef          	jal	ra,8000352c <namecmp>
    800035b4:	f961                	bnez	a0,80003584 <dirlookup+0x42>
      if(poff)
    800035b6:	000a0463          	beqz	s4,800035be <dirlookup+0x7c>
        *poff = off;
    800035ba:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800035be:	fc045583          	lhu	a1,-64(s0)
    800035c2:	00092503          	lw	a0,0(s2)
    800035c6:	859ff0ef          	jal	ra,80002e1e <iget>
    800035ca:	a011                	j	800035ce <dirlookup+0x8c>
  return 0;
    800035cc:	4501                	li	a0,0
}
    800035ce:	70e2                	ld	ra,56(sp)
    800035d0:	7442                	ld	s0,48(sp)
    800035d2:	74a2                	ld	s1,40(sp)
    800035d4:	7902                	ld	s2,32(sp)
    800035d6:	69e2                	ld	s3,24(sp)
    800035d8:	6a42                	ld	s4,16(sp)
    800035da:	6121                	addi	sp,sp,64
    800035dc:	8082                	ret

00000000800035de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800035de:	711d                	addi	sp,sp,-96
    800035e0:	ec86                	sd	ra,88(sp)
    800035e2:	e8a2                	sd	s0,80(sp)
    800035e4:	e4a6                	sd	s1,72(sp)
    800035e6:	e0ca                	sd	s2,64(sp)
    800035e8:	fc4e                	sd	s3,56(sp)
    800035ea:	f852                	sd	s4,48(sp)
    800035ec:	f456                	sd	s5,40(sp)
    800035ee:	f05a                	sd	s6,32(sp)
    800035f0:	ec5e                	sd	s7,24(sp)
    800035f2:	e862                	sd	s8,16(sp)
    800035f4:	e466                	sd	s9,8(sp)
    800035f6:	1080                	addi	s0,sp,96
    800035f8:	84aa                	mv	s1,a0
    800035fa:	8b2e                	mv	s6,a1
    800035fc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800035fe:	00054703          	lbu	a4,0(a0)
    80003602:	02f00793          	li	a5,47
    80003606:	00f70f63          	beq	a4,a5,80003624 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000360a:	a36fe0ef          	jal	ra,80001840 <myproc>
    8000360e:	15053503          	ld	a0,336(a0)
    80003612:	aafff0ef          	jal	ra,800030c0 <idup>
    80003616:	89aa                	mv	s3,a0
  while(*path == '/')
    80003618:	02f00913          	li	s2,47
  len = path - s;
    8000361c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000361e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003620:	4c05                	li	s8,1
    80003622:	a861                	j	800036ba <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80003624:	4585                	li	a1,1
    80003626:	4505                	li	a0,1
    80003628:	ff6ff0ef          	jal	ra,80002e1e <iget>
    8000362c:	89aa                	mv	s3,a0
    8000362e:	b7ed                	j	80003618 <namex+0x3a>
      iunlockput(ip);
    80003630:	854e                	mv	a0,s3
    80003632:	ccbff0ef          	jal	ra,800032fc <iunlockput>
      return 0;
    80003636:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003638:	854e                	mv	a0,s3
    8000363a:	60e6                	ld	ra,88(sp)
    8000363c:	6446                	ld	s0,80(sp)
    8000363e:	64a6                	ld	s1,72(sp)
    80003640:	6906                	ld	s2,64(sp)
    80003642:	79e2                	ld	s3,56(sp)
    80003644:	7a42                	ld	s4,48(sp)
    80003646:	7aa2                	ld	s5,40(sp)
    80003648:	7b02                	ld	s6,32(sp)
    8000364a:	6be2                	ld	s7,24(sp)
    8000364c:	6c42                	ld	s8,16(sp)
    8000364e:	6ca2                	ld	s9,8(sp)
    80003650:	6125                	addi	sp,sp,96
    80003652:	8082                	ret
      iunlock(ip);
    80003654:	854e                	mv	a0,s3
    80003656:	b4bff0ef          	jal	ra,800031a0 <iunlock>
      return ip;
    8000365a:	bff9                	j	80003638 <namex+0x5a>
      iunlockput(ip);
    8000365c:	854e                	mv	a0,s3
    8000365e:	c9fff0ef          	jal	ra,800032fc <iunlockput>
      return 0;
    80003662:	89d2                	mv	s3,s4
    80003664:	bfd1                	j	80003638 <namex+0x5a>
  len = path - s;
    80003666:	40b48633          	sub	a2,s1,a1
    8000366a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000366e:	074cdc63          	bge	s9,s4,800036e6 <namex+0x108>
    memmove(name, s, DIRSIZ);
    80003672:	4639                	li	a2,14
    80003674:	8556                	mv	a0,s5
    80003676:	e66fd0ef          	jal	ra,80000cdc <memmove>
  while(*path == '/')
    8000367a:	0004c783          	lbu	a5,0(s1)
    8000367e:	01279763          	bne	a5,s2,8000368c <namex+0xae>
    path++;
    80003682:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003684:	0004c783          	lbu	a5,0(s1)
    80003688:	ff278de3          	beq	a5,s2,80003682 <namex+0xa4>
    ilock(ip);
    8000368c:	854e                	mv	a0,s3
    8000368e:	a69ff0ef          	jal	ra,800030f6 <ilock>
    if(ip->type != T_DIR){
    80003692:	04499783          	lh	a5,68(s3)
    80003696:	f9879de3          	bne	a5,s8,80003630 <namex+0x52>
    if(nameiparent && *path == '\0'){
    8000369a:	000b0563          	beqz	s6,800036a4 <namex+0xc6>
    8000369e:	0004c783          	lbu	a5,0(s1)
    800036a2:	dbcd                	beqz	a5,80003654 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    800036a4:	865e                	mv	a2,s7
    800036a6:	85d6                	mv	a1,s5
    800036a8:	854e                	mv	a0,s3
    800036aa:	e99ff0ef          	jal	ra,80003542 <dirlookup>
    800036ae:	8a2a                	mv	s4,a0
    800036b0:	d555                	beqz	a0,8000365c <namex+0x7e>
    iunlockput(ip);
    800036b2:	854e                	mv	a0,s3
    800036b4:	c49ff0ef          	jal	ra,800032fc <iunlockput>
    ip = next;
    800036b8:	89d2                	mv	s3,s4
  while(*path == '/')
    800036ba:	0004c783          	lbu	a5,0(s1)
    800036be:	05279363          	bne	a5,s2,80003704 <namex+0x126>
    path++;
    800036c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036c4:	0004c783          	lbu	a5,0(s1)
    800036c8:	ff278de3          	beq	a5,s2,800036c2 <namex+0xe4>
  if(*path == 0)
    800036cc:	c78d                	beqz	a5,800036f6 <namex+0x118>
    path++;
    800036ce:	85a6                	mv	a1,s1
  len = path - s;
    800036d0:	8a5e                	mv	s4,s7
    800036d2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800036d4:	01278963          	beq	a5,s2,800036e6 <namex+0x108>
    800036d8:	d7d9                	beqz	a5,80003666 <namex+0x88>
    path++;
    800036da:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800036dc:	0004c783          	lbu	a5,0(s1)
    800036e0:	ff279ce3          	bne	a5,s2,800036d8 <namex+0xfa>
    800036e4:	b749                	j	80003666 <namex+0x88>
    memmove(name, s, len);
    800036e6:	2601                	sext.w	a2,a2
    800036e8:	8556                	mv	a0,s5
    800036ea:	df2fd0ef          	jal	ra,80000cdc <memmove>
    name[len] = 0;
    800036ee:	9a56                	add	s4,s4,s5
    800036f0:	000a0023          	sb	zero,0(s4)
    800036f4:	b759                	j	8000367a <namex+0x9c>
  if(nameiparent){
    800036f6:	f40b01e3          	beqz	s6,80003638 <namex+0x5a>
    iput(ip);
    800036fa:	854e                	mv	a0,s3
    800036fc:	b79ff0ef          	jal	ra,80003274 <iput>
    return 0;
    80003700:	4981                	li	s3,0
    80003702:	bf1d                	j	80003638 <namex+0x5a>
  if(*path == 0)
    80003704:	dbed                	beqz	a5,800036f6 <namex+0x118>
  while(*path != '/' && *path != 0)
    80003706:	0004c783          	lbu	a5,0(s1)
    8000370a:	85a6                	mv	a1,s1
    8000370c:	b7f1                	j	800036d8 <namex+0xfa>

000000008000370e <dirlink>:
{
    8000370e:	7139                	addi	sp,sp,-64
    80003710:	fc06                	sd	ra,56(sp)
    80003712:	f822                	sd	s0,48(sp)
    80003714:	f426                	sd	s1,40(sp)
    80003716:	f04a                	sd	s2,32(sp)
    80003718:	ec4e                	sd	s3,24(sp)
    8000371a:	e852                	sd	s4,16(sp)
    8000371c:	0080                	addi	s0,sp,64
    8000371e:	892a                	mv	s2,a0
    80003720:	8a2e                	mv	s4,a1
    80003722:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003724:	4601                	li	a2,0
    80003726:	e1dff0ef          	jal	ra,80003542 <dirlookup>
    8000372a:	e52d                	bnez	a0,80003794 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000372c:	04c92483          	lw	s1,76(s2)
    80003730:	c48d                	beqz	s1,8000375a <dirlink+0x4c>
    80003732:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003734:	4741                	li	a4,16
    80003736:	86a6                	mv	a3,s1
    80003738:	fc040613          	addi	a2,s0,-64
    8000373c:	4581                	li	a1,0
    8000373e:	854a                	mv	a0,s2
    80003740:	c07ff0ef          	jal	ra,80003346 <readi>
    80003744:	47c1                	li	a5,16
    80003746:	04f51b63          	bne	a0,a5,8000379c <dirlink+0x8e>
    if(de.inum == 0)
    8000374a:	fc045783          	lhu	a5,-64(s0)
    8000374e:	c791                	beqz	a5,8000375a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003750:	24c1                	addiw	s1,s1,16
    80003752:	04c92783          	lw	a5,76(s2)
    80003756:	fcf4efe3          	bltu	s1,a5,80003734 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000375a:	4639                	li	a2,14
    8000375c:	85d2                	mv	a1,s4
    8000375e:	fc240513          	addi	a0,s0,-62
    80003762:	e2afd0ef          	jal	ra,80000d8c <strncpy>
  de.inum = inum;
    80003766:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000376a:	4741                	li	a4,16
    8000376c:	86a6                	mv	a3,s1
    8000376e:	fc040613          	addi	a2,s0,-64
    80003772:	4581                	li	a1,0
    80003774:	854a                	mv	a0,s2
    80003776:	cb5ff0ef          	jal	ra,8000342a <writei>
    8000377a:	1541                	addi	a0,a0,-16
    8000377c:	00a03533          	snez	a0,a0
    80003780:	40a00533          	neg	a0,a0
}
    80003784:	70e2                	ld	ra,56(sp)
    80003786:	7442                	ld	s0,48(sp)
    80003788:	74a2                	ld	s1,40(sp)
    8000378a:	7902                	ld	s2,32(sp)
    8000378c:	69e2                	ld	s3,24(sp)
    8000378e:	6a42                	ld	s4,16(sp)
    80003790:	6121                	addi	sp,sp,64
    80003792:	8082                	ret
    iput(ip);
    80003794:	ae1ff0ef          	jal	ra,80003274 <iput>
    return -1;
    80003798:	557d                	li	a0,-1
    8000379a:	b7ed                	j	80003784 <dirlink+0x76>
      panic("dirlink read");
    8000379c:	00004517          	auipc	a0,0x4
    800037a0:	ebc50513          	addi	a0,a0,-324 # 80007658 <syscalls+0x1c8>
    800037a4:	fb9fc0ef          	jal	ra,8000075c <panic>

00000000800037a8 <namei>:

struct inode*
namei(char *path)
{
    800037a8:	1101                	addi	sp,sp,-32
    800037aa:	ec06                	sd	ra,24(sp)
    800037ac:	e822                	sd	s0,16(sp)
    800037ae:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800037b0:	fe040613          	addi	a2,s0,-32
    800037b4:	4581                	li	a1,0
    800037b6:	e29ff0ef          	jal	ra,800035de <namex>
}
    800037ba:	60e2                	ld	ra,24(sp)
    800037bc:	6442                	ld	s0,16(sp)
    800037be:	6105                	addi	sp,sp,32
    800037c0:	8082                	ret

00000000800037c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800037c2:	1141                	addi	sp,sp,-16
    800037c4:	e406                	sd	ra,8(sp)
    800037c6:	e022                	sd	s0,0(sp)
    800037c8:	0800                	addi	s0,sp,16
    800037ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800037cc:	4585                	li	a1,1
    800037ce:	e11ff0ef          	jal	ra,800035de <namex>
}
    800037d2:	60a2                	ld	ra,8(sp)
    800037d4:	6402                	ld	s0,0(sp)
    800037d6:	0141                	addi	sp,sp,16
    800037d8:	8082                	ret

00000000800037da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800037e6:	0001c917          	auipc	s2,0x1c
    800037ea:	23a90913          	addi	s2,s2,570 # 8001fa20 <log>
    800037ee:	01892583          	lw	a1,24(s2)
    800037f2:	02892503          	lw	a0,40(s2)
    800037f6:	9e2ff0ef          	jal	ra,800029d8 <bread>
    800037fa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800037fc:	02c92683          	lw	a3,44(s2)
    80003800:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003802:	02d05763          	blez	a3,80003830 <write_head+0x56>
    80003806:	0001c797          	auipc	a5,0x1c
    8000380a:	24a78793          	addi	a5,a5,586 # 8001fa50 <log+0x30>
    8000380e:	05c50713          	addi	a4,a0,92
    80003812:	36fd                	addiw	a3,a3,-1
    80003814:	1682                	slli	a3,a3,0x20
    80003816:	9281                	srli	a3,a3,0x20
    80003818:	068a                	slli	a3,a3,0x2
    8000381a:	0001c617          	auipc	a2,0x1c
    8000381e:	23a60613          	addi	a2,a2,570 # 8001fa54 <log+0x34>
    80003822:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003824:	4390                	lw	a2,0(a5)
    80003826:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003828:	0791                	addi	a5,a5,4
    8000382a:	0711                	addi	a4,a4,4
    8000382c:	fed79ce3          	bne	a5,a3,80003824 <write_head+0x4a>
  }
  bwrite(buf);
    80003830:	8526                	mv	a0,s1
    80003832:	a7cff0ef          	jal	ra,80002aae <bwrite>
  brelse(buf);
    80003836:	8526                	mv	a0,s1
    80003838:	aa8ff0ef          	jal	ra,80002ae0 <brelse>
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003848:	0001c797          	auipc	a5,0x1c
    8000384c:	2047a783          	lw	a5,516(a5) # 8001fa4c <log+0x2c>
    80003850:	08f05f63          	blez	a5,800038ee <install_trans+0xa6>
{
    80003854:	7139                	addi	sp,sp,-64
    80003856:	fc06                	sd	ra,56(sp)
    80003858:	f822                	sd	s0,48(sp)
    8000385a:	f426                	sd	s1,40(sp)
    8000385c:	f04a                	sd	s2,32(sp)
    8000385e:	ec4e                	sd	s3,24(sp)
    80003860:	e852                	sd	s4,16(sp)
    80003862:	e456                	sd	s5,8(sp)
    80003864:	e05a                	sd	s6,0(sp)
    80003866:	0080                	addi	s0,sp,64
    80003868:	8b2a                	mv	s6,a0
    8000386a:	0001ca97          	auipc	s5,0x1c
    8000386e:	1e6a8a93          	addi	s5,s5,486 # 8001fa50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003872:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003874:	0001c997          	auipc	s3,0x1c
    80003878:	1ac98993          	addi	s3,s3,428 # 8001fa20 <log>
    8000387c:	a005                	j	8000389c <install_trans+0x54>
      bunpin(dbuf);
    8000387e:	8526                	mv	a0,s1
    80003880:	b1eff0ef          	jal	ra,80002b9e <bunpin>
    brelse(lbuf);
    80003884:	854a                	mv	a0,s2
    80003886:	a5aff0ef          	jal	ra,80002ae0 <brelse>
    brelse(dbuf);
    8000388a:	8526                	mv	a0,s1
    8000388c:	a54ff0ef          	jal	ra,80002ae0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003890:	2a05                	addiw	s4,s4,1
    80003892:	0a91                	addi	s5,s5,4
    80003894:	02c9a783          	lw	a5,44(s3)
    80003898:	04fa5163          	bge	s4,a5,800038da <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000389c:	0189a583          	lw	a1,24(s3)
    800038a0:	014585bb          	addw	a1,a1,s4
    800038a4:	2585                	addiw	a1,a1,1
    800038a6:	0289a503          	lw	a0,40(s3)
    800038aa:	92eff0ef          	jal	ra,800029d8 <bread>
    800038ae:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800038b0:	000aa583          	lw	a1,0(s5)
    800038b4:	0289a503          	lw	a0,40(s3)
    800038b8:	920ff0ef          	jal	ra,800029d8 <bread>
    800038bc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800038be:	40000613          	li	a2,1024
    800038c2:	05890593          	addi	a1,s2,88
    800038c6:	05850513          	addi	a0,a0,88
    800038ca:	c12fd0ef          	jal	ra,80000cdc <memmove>
    bwrite(dbuf);  // write dst to disk
    800038ce:	8526                	mv	a0,s1
    800038d0:	9deff0ef          	jal	ra,80002aae <bwrite>
    if(recovering == 0)
    800038d4:	fa0b18e3          	bnez	s6,80003884 <install_trans+0x3c>
    800038d8:	b75d                	j	8000387e <install_trans+0x36>
}
    800038da:	70e2                	ld	ra,56(sp)
    800038dc:	7442                	ld	s0,48(sp)
    800038de:	74a2                	ld	s1,40(sp)
    800038e0:	7902                	ld	s2,32(sp)
    800038e2:	69e2                	ld	s3,24(sp)
    800038e4:	6a42                	ld	s4,16(sp)
    800038e6:	6aa2                	ld	s5,8(sp)
    800038e8:	6b02                	ld	s6,0(sp)
    800038ea:	6121                	addi	sp,sp,64
    800038ec:	8082                	ret
    800038ee:	8082                	ret

00000000800038f0 <initlog>:
{
    800038f0:	7179                	addi	sp,sp,-48
    800038f2:	f406                	sd	ra,40(sp)
    800038f4:	f022                	sd	s0,32(sp)
    800038f6:	ec26                	sd	s1,24(sp)
    800038f8:	e84a                	sd	s2,16(sp)
    800038fa:	e44e                	sd	s3,8(sp)
    800038fc:	1800                	addi	s0,sp,48
    800038fe:	892a                	mv	s2,a0
    80003900:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003902:	0001c497          	auipc	s1,0x1c
    80003906:	11e48493          	addi	s1,s1,286 # 8001fa20 <log>
    8000390a:	00004597          	auipc	a1,0x4
    8000390e:	d5e58593          	addi	a1,a1,-674 # 80007668 <syscalls+0x1d8>
    80003912:	8526                	mv	a0,s1
    80003914:	a14fd0ef          	jal	ra,80000b28 <initlock>
  log.start = sb->logstart;
    80003918:	0149a583          	lw	a1,20(s3)
    8000391c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000391e:	0109a783          	lw	a5,16(s3)
    80003922:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003924:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003928:	854a                	mv	a0,s2
    8000392a:	8aeff0ef          	jal	ra,800029d8 <bread>
  log.lh.n = lh->n;
    8000392e:	4d3c                	lw	a5,88(a0)
    80003930:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003932:	02f05563          	blez	a5,8000395c <initlog+0x6c>
    80003936:	05c50713          	addi	a4,a0,92
    8000393a:	0001c697          	auipc	a3,0x1c
    8000393e:	11668693          	addi	a3,a3,278 # 8001fa50 <log+0x30>
    80003942:	37fd                	addiw	a5,a5,-1
    80003944:	1782                	slli	a5,a5,0x20
    80003946:	9381                	srli	a5,a5,0x20
    80003948:	078a                	slli	a5,a5,0x2
    8000394a:	06050613          	addi	a2,a0,96
    8000394e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003950:	4310                	lw	a2,0(a4)
    80003952:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003954:	0711                	addi	a4,a4,4
    80003956:	0691                	addi	a3,a3,4
    80003958:	fef71ce3          	bne	a4,a5,80003950 <initlog+0x60>
  brelse(buf);
    8000395c:	984ff0ef          	jal	ra,80002ae0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003960:	4505                	li	a0,1
    80003962:	ee7ff0ef          	jal	ra,80003848 <install_trans>
  log.lh.n = 0;
    80003966:	0001c797          	auipc	a5,0x1c
    8000396a:	0e07a323          	sw	zero,230(a5) # 8001fa4c <log+0x2c>
  write_head(); // clear the log
    8000396e:	e6dff0ef          	jal	ra,800037da <write_head>
}
    80003972:	70a2                	ld	ra,40(sp)
    80003974:	7402                	ld	s0,32(sp)
    80003976:	64e2                	ld	s1,24(sp)
    80003978:	6942                	ld	s2,16(sp)
    8000397a:	69a2                	ld	s3,8(sp)
    8000397c:	6145                	addi	sp,sp,48
    8000397e:	8082                	ret

0000000080003980 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	e04a                	sd	s2,0(sp)
    8000398a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000398c:	0001c517          	auipc	a0,0x1c
    80003990:	09450513          	addi	a0,a0,148 # 8001fa20 <log>
    80003994:	a14fd0ef          	jal	ra,80000ba8 <acquire>
  while(1){
    if(log.committing){
    80003998:	0001c497          	auipc	s1,0x1c
    8000399c:	08848493          	addi	s1,s1,136 # 8001fa20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039a0:	4979                	li	s2,30
    800039a2:	a029                	j	800039ac <begin_op+0x2c>
      sleep(&log, &log.lock);
    800039a4:	85a6                	mv	a1,s1
    800039a6:	8526                	mv	a0,s1
    800039a8:	c60fe0ef          	jal	ra,80001e08 <sleep>
    if(log.committing){
    800039ac:	50dc                	lw	a5,36(s1)
    800039ae:	fbfd                	bnez	a5,800039a4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039b0:	509c                	lw	a5,32(s1)
    800039b2:	0017871b          	addiw	a4,a5,1
    800039b6:	0007069b          	sext.w	a3,a4
    800039ba:	0027179b          	slliw	a5,a4,0x2
    800039be:	9fb9                	addw	a5,a5,a4
    800039c0:	0017979b          	slliw	a5,a5,0x1
    800039c4:	54d8                	lw	a4,44(s1)
    800039c6:	9fb9                	addw	a5,a5,a4
    800039c8:	00f95763          	bge	s2,a5,800039d6 <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800039cc:	85a6                	mv	a1,s1
    800039ce:	8526                	mv	a0,s1
    800039d0:	c38fe0ef          	jal	ra,80001e08 <sleep>
    800039d4:	bfe1                	j	800039ac <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800039d6:	0001c517          	auipc	a0,0x1c
    800039da:	04a50513          	addi	a0,a0,74 # 8001fa20 <log>
    800039de:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800039e0:	a60fd0ef          	jal	ra,80000c40 <release>
      break;
    }
  }
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800039f0:	7139                	addi	sp,sp,-64
    800039f2:	fc06                	sd	ra,56(sp)
    800039f4:	f822                	sd	s0,48(sp)
    800039f6:	f426                	sd	s1,40(sp)
    800039f8:	f04a                	sd	s2,32(sp)
    800039fa:	ec4e                	sd	s3,24(sp)
    800039fc:	e852                	sd	s4,16(sp)
    800039fe:	e456                	sd	s5,8(sp)
    80003a00:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003a02:	0001c497          	auipc	s1,0x1c
    80003a06:	01e48493          	addi	s1,s1,30 # 8001fa20 <log>
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	99cfd0ef          	jal	ra,80000ba8 <acquire>
  log.outstanding -= 1;
    80003a10:	509c                	lw	a5,32(s1)
    80003a12:	37fd                	addiw	a5,a5,-1
    80003a14:	0007891b          	sext.w	s2,a5
    80003a18:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003a1a:	50dc                	lw	a5,36(s1)
    80003a1c:	e7b9                	bnez	a5,80003a6a <end_op+0x7a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a1e:	04091c63          	bnez	s2,80003a76 <end_op+0x86>
    do_commit = 1;
    log.committing = 1;
    80003a22:	0001c497          	auipc	s1,0x1c
    80003a26:	ffe48493          	addi	s1,s1,-2 # 8001fa20 <log>
    80003a2a:	4785                	li	a5,1
    80003a2c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003a2e:	8526                	mv	a0,s1
    80003a30:	a10fd0ef          	jal	ra,80000c40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a34:	54dc                	lw	a5,44(s1)
    80003a36:	04f04b63          	bgtz	a5,80003a8c <end_op+0x9c>
    acquire(&log.lock);
    80003a3a:	0001c497          	auipc	s1,0x1c
    80003a3e:	fe648493          	addi	s1,s1,-26 # 8001fa20 <log>
    80003a42:	8526                	mv	a0,s1
    80003a44:	964fd0ef          	jal	ra,80000ba8 <acquire>
    log.committing = 0;
    80003a48:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	c06fe0ef          	jal	ra,80001e54 <wakeup>
    release(&log.lock);
    80003a52:	8526                	mv	a0,s1
    80003a54:	9ecfd0ef          	jal	ra,80000c40 <release>
}
    80003a58:	70e2                	ld	ra,56(sp)
    80003a5a:	7442                	ld	s0,48(sp)
    80003a5c:	74a2                	ld	s1,40(sp)
    80003a5e:	7902                	ld	s2,32(sp)
    80003a60:	69e2                	ld	s3,24(sp)
    80003a62:	6a42                	ld	s4,16(sp)
    80003a64:	6aa2                	ld	s5,8(sp)
    80003a66:	6121                	addi	sp,sp,64
    80003a68:	8082                	ret
    panic("log.committing");
    80003a6a:	00004517          	auipc	a0,0x4
    80003a6e:	c0650513          	addi	a0,a0,-1018 # 80007670 <syscalls+0x1e0>
    80003a72:	cebfc0ef          	jal	ra,8000075c <panic>
    wakeup(&log);
    80003a76:	0001c497          	auipc	s1,0x1c
    80003a7a:	faa48493          	addi	s1,s1,-86 # 8001fa20 <log>
    80003a7e:	8526                	mv	a0,s1
    80003a80:	bd4fe0ef          	jal	ra,80001e54 <wakeup>
  release(&log.lock);
    80003a84:	8526                	mv	a0,s1
    80003a86:	9bafd0ef          	jal	ra,80000c40 <release>
  if(do_commit){
    80003a8a:	b7f9                	j	80003a58 <end_op+0x68>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a8c:	0001ca97          	auipc	s5,0x1c
    80003a90:	fc4a8a93          	addi	s5,s5,-60 # 8001fa50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a94:	0001ca17          	auipc	s4,0x1c
    80003a98:	f8ca0a13          	addi	s4,s4,-116 # 8001fa20 <log>
    80003a9c:	018a2583          	lw	a1,24(s4)
    80003aa0:	012585bb          	addw	a1,a1,s2
    80003aa4:	2585                	addiw	a1,a1,1
    80003aa6:	028a2503          	lw	a0,40(s4)
    80003aaa:	f2ffe0ef          	jal	ra,800029d8 <bread>
    80003aae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003ab0:	000aa583          	lw	a1,0(s5)
    80003ab4:	028a2503          	lw	a0,40(s4)
    80003ab8:	f21fe0ef          	jal	ra,800029d8 <bread>
    80003abc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003abe:	40000613          	li	a2,1024
    80003ac2:	05850593          	addi	a1,a0,88
    80003ac6:	05848513          	addi	a0,s1,88
    80003aca:	a12fd0ef          	jal	ra,80000cdc <memmove>
    bwrite(to);  // write the log
    80003ace:	8526                	mv	a0,s1
    80003ad0:	fdffe0ef          	jal	ra,80002aae <bwrite>
    brelse(from);
    80003ad4:	854e                	mv	a0,s3
    80003ad6:	80aff0ef          	jal	ra,80002ae0 <brelse>
    brelse(to);
    80003ada:	8526                	mv	a0,s1
    80003adc:	804ff0ef          	jal	ra,80002ae0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ae0:	2905                	addiw	s2,s2,1
    80003ae2:	0a91                	addi	s5,s5,4
    80003ae4:	02ca2783          	lw	a5,44(s4)
    80003ae8:	faf94ae3          	blt	s2,a5,80003a9c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003aec:	cefff0ef          	jal	ra,800037da <write_head>
    install_trans(0); // Now install writes to home locations
    80003af0:	4501                	li	a0,0
    80003af2:	d57ff0ef          	jal	ra,80003848 <install_trans>
    log.lh.n = 0;
    80003af6:	0001c797          	auipc	a5,0x1c
    80003afa:	f407ab23          	sw	zero,-170(a5) # 8001fa4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003afe:	cddff0ef          	jal	ra,800037da <write_head>
    80003b02:	bf25                	j	80003a3a <end_op+0x4a>

0000000080003b04 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	e04a                	sd	s2,0(sp)
    80003b0e:	1000                	addi	s0,sp,32
    80003b10:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b12:	0001c917          	auipc	s2,0x1c
    80003b16:	f0e90913          	addi	s2,s2,-242 # 8001fa20 <log>
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	88cfd0ef          	jal	ra,80000ba8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b20:	02c92603          	lw	a2,44(s2)
    80003b24:	47f5                	li	a5,29
    80003b26:	06c7c363          	blt	a5,a2,80003b8c <log_write+0x88>
    80003b2a:	0001c797          	auipc	a5,0x1c
    80003b2e:	f127a783          	lw	a5,-238(a5) # 8001fa3c <log+0x1c>
    80003b32:	37fd                	addiw	a5,a5,-1
    80003b34:	04f65c63          	bge	a2,a5,80003b8c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b38:	0001c797          	auipc	a5,0x1c
    80003b3c:	f087a783          	lw	a5,-248(a5) # 8001fa40 <log+0x20>
    80003b40:	04f05c63          	blez	a5,80003b98 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b44:	4781                	li	a5,0
    80003b46:	04c05f63          	blez	a2,80003ba4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b4a:	44cc                	lw	a1,12(s1)
    80003b4c:	0001c717          	auipc	a4,0x1c
    80003b50:	f0470713          	addi	a4,a4,-252 # 8001fa50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b54:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b56:	4314                	lw	a3,0(a4)
    80003b58:	04b68663          	beq	a3,a1,80003ba4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003b5c:	2785                	addiw	a5,a5,1
    80003b5e:	0711                	addi	a4,a4,4
    80003b60:	fef61be3          	bne	a2,a5,80003b56 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b64:	0621                	addi	a2,a2,8
    80003b66:	060a                	slli	a2,a2,0x2
    80003b68:	0001c797          	auipc	a5,0x1c
    80003b6c:	eb878793          	addi	a5,a5,-328 # 8001fa20 <log>
    80003b70:	963e                	add	a2,a2,a5
    80003b72:	44dc                	lw	a5,12(s1)
    80003b74:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b76:	8526                	mv	a0,s1
    80003b78:	ff3fe0ef          	jal	ra,80002b6a <bpin>
    log.lh.n++;
    80003b7c:	0001c717          	auipc	a4,0x1c
    80003b80:	ea470713          	addi	a4,a4,-348 # 8001fa20 <log>
    80003b84:	575c                	lw	a5,44(a4)
    80003b86:	2785                	addiw	a5,a5,1
    80003b88:	d75c                	sw	a5,44(a4)
    80003b8a:	a815                	j	80003bbe <log_write+0xba>
    panic("too big a transaction");
    80003b8c:	00004517          	auipc	a0,0x4
    80003b90:	af450513          	addi	a0,a0,-1292 # 80007680 <syscalls+0x1f0>
    80003b94:	bc9fc0ef          	jal	ra,8000075c <panic>
    panic("log_write outside of trans");
    80003b98:	00004517          	auipc	a0,0x4
    80003b9c:	b0050513          	addi	a0,a0,-1280 # 80007698 <syscalls+0x208>
    80003ba0:	bbdfc0ef          	jal	ra,8000075c <panic>
  log.lh.block[i] = b->blockno;
    80003ba4:	00878713          	addi	a4,a5,8
    80003ba8:	00271693          	slli	a3,a4,0x2
    80003bac:	0001c717          	auipc	a4,0x1c
    80003bb0:	e7470713          	addi	a4,a4,-396 # 8001fa20 <log>
    80003bb4:	9736                	add	a4,a4,a3
    80003bb6:	44d4                	lw	a3,12(s1)
    80003bb8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003bba:	faf60ee3          	beq	a2,a5,80003b76 <log_write+0x72>
  }
  release(&log.lock);
    80003bbe:	0001c517          	auipc	a0,0x1c
    80003bc2:	e6250513          	addi	a0,a0,-414 # 8001fa20 <log>
    80003bc6:	87afd0ef          	jal	ra,80000c40 <release>
}
    80003bca:	60e2                	ld	ra,24(sp)
    80003bcc:	6442                	ld	s0,16(sp)
    80003bce:	64a2                	ld	s1,8(sp)
    80003bd0:	6902                	ld	s2,0(sp)
    80003bd2:	6105                	addi	sp,sp,32
    80003bd4:	8082                	ret

0000000080003bd6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bd6:	1101                	addi	sp,sp,-32
    80003bd8:	ec06                	sd	ra,24(sp)
    80003bda:	e822                	sd	s0,16(sp)
    80003bdc:	e426                	sd	s1,8(sp)
    80003bde:	e04a                	sd	s2,0(sp)
    80003be0:	1000                	addi	s0,sp,32
    80003be2:	84aa                	mv	s1,a0
    80003be4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003be6:	00004597          	auipc	a1,0x4
    80003bea:	ad258593          	addi	a1,a1,-1326 # 800076b8 <syscalls+0x228>
    80003bee:	0521                	addi	a0,a0,8
    80003bf0:	f39fc0ef          	jal	ra,80000b28 <initlock>
  lk->name = name;
    80003bf4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003bf8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bfc:	0204a423          	sw	zero,40(s1)
}
    80003c00:	60e2                	ld	ra,24(sp)
    80003c02:	6442                	ld	s0,16(sp)
    80003c04:	64a2                	ld	s1,8(sp)
    80003c06:	6902                	ld	s2,0(sp)
    80003c08:	6105                	addi	sp,sp,32
    80003c0a:	8082                	ret

0000000080003c0c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c0c:	1101                	addi	sp,sp,-32
    80003c0e:	ec06                	sd	ra,24(sp)
    80003c10:	e822                	sd	s0,16(sp)
    80003c12:	e426                	sd	s1,8(sp)
    80003c14:	e04a                	sd	s2,0(sp)
    80003c16:	1000                	addi	s0,sp,32
    80003c18:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c1a:	00850913          	addi	s2,a0,8
    80003c1e:	854a                	mv	a0,s2
    80003c20:	f89fc0ef          	jal	ra,80000ba8 <acquire>
  while (lk->locked) {
    80003c24:	409c                	lw	a5,0(s1)
    80003c26:	c799                	beqz	a5,80003c34 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003c28:	85ca                	mv	a1,s2
    80003c2a:	8526                	mv	a0,s1
    80003c2c:	9dcfe0ef          	jal	ra,80001e08 <sleep>
  while (lk->locked) {
    80003c30:	409c                	lw	a5,0(s1)
    80003c32:	fbfd                	bnez	a5,80003c28 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c34:	4785                	li	a5,1
    80003c36:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c38:	c09fd0ef          	jal	ra,80001840 <myproc>
    80003c3c:	591c                	lw	a5,48(a0)
    80003c3e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c40:	854a                	mv	a0,s2
    80003c42:	ffffc0ef          	jal	ra,80000c40 <release>
}
    80003c46:	60e2                	ld	ra,24(sp)
    80003c48:	6442                	ld	s0,16(sp)
    80003c4a:	64a2                	ld	s1,8(sp)
    80003c4c:	6902                	ld	s2,0(sp)
    80003c4e:	6105                	addi	sp,sp,32
    80003c50:	8082                	ret

0000000080003c52 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c52:	1101                	addi	sp,sp,-32
    80003c54:	ec06                	sd	ra,24(sp)
    80003c56:	e822                	sd	s0,16(sp)
    80003c58:	e426                	sd	s1,8(sp)
    80003c5a:	e04a                	sd	s2,0(sp)
    80003c5c:	1000                	addi	s0,sp,32
    80003c5e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c60:	00850913          	addi	s2,a0,8
    80003c64:	854a                	mv	a0,s2
    80003c66:	f43fc0ef          	jal	ra,80000ba8 <acquire>
  lk->locked = 0;
    80003c6a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c6e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c72:	8526                	mv	a0,s1
    80003c74:	9e0fe0ef          	jal	ra,80001e54 <wakeup>
  release(&lk->lk);
    80003c78:	854a                	mv	a0,s2
    80003c7a:	fc7fc0ef          	jal	ra,80000c40 <release>
}
    80003c7e:	60e2                	ld	ra,24(sp)
    80003c80:	6442                	ld	s0,16(sp)
    80003c82:	64a2                	ld	s1,8(sp)
    80003c84:	6902                	ld	s2,0(sp)
    80003c86:	6105                	addi	sp,sp,32
    80003c88:	8082                	ret

0000000080003c8a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c8a:	7179                	addi	sp,sp,-48
    80003c8c:	f406                	sd	ra,40(sp)
    80003c8e:	f022                	sd	s0,32(sp)
    80003c90:	ec26                	sd	s1,24(sp)
    80003c92:	e84a                	sd	s2,16(sp)
    80003c94:	e44e                	sd	s3,8(sp)
    80003c96:	1800                	addi	s0,sp,48
    80003c98:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c9a:	00850913          	addi	s2,a0,8
    80003c9e:	854a                	mv	a0,s2
    80003ca0:	f09fc0ef          	jal	ra,80000ba8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ca4:	409c                	lw	a5,0(s1)
    80003ca6:	ef89                	bnez	a5,80003cc0 <holdingsleep+0x36>
    80003ca8:	4481                	li	s1,0
  release(&lk->lk);
    80003caa:	854a                	mv	a0,s2
    80003cac:	f95fc0ef          	jal	ra,80000c40 <release>
  return r;
}
    80003cb0:	8526                	mv	a0,s1
    80003cb2:	70a2                	ld	ra,40(sp)
    80003cb4:	7402                	ld	s0,32(sp)
    80003cb6:	64e2                	ld	s1,24(sp)
    80003cb8:	6942                	ld	s2,16(sp)
    80003cba:	69a2                	ld	s3,8(sp)
    80003cbc:	6145                	addi	sp,sp,48
    80003cbe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cc0:	0284a983          	lw	s3,40(s1)
    80003cc4:	b7dfd0ef          	jal	ra,80001840 <myproc>
    80003cc8:	5904                	lw	s1,48(a0)
    80003cca:	413484b3          	sub	s1,s1,s3
    80003cce:	0014b493          	seqz	s1,s1
    80003cd2:	bfe1                	j	80003caa <holdingsleep+0x20>

0000000080003cd4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003cd4:	1141                	addi	sp,sp,-16
    80003cd6:	e406                	sd	ra,8(sp)
    80003cd8:	e022                	sd	s0,0(sp)
    80003cda:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003cdc:	00004597          	auipc	a1,0x4
    80003ce0:	9ec58593          	addi	a1,a1,-1556 # 800076c8 <syscalls+0x238>
    80003ce4:	0001c517          	auipc	a0,0x1c
    80003ce8:	e8450513          	addi	a0,a0,-380 # 8001fb68 <ftable>
    80003cec:	e3dfc0ef          	jal	ra,80000b28 <initlock>
}
    80003cf0:	60a2                	ld	ra,8(sp)
    80003cf2:	6402                	ld	s0,0(sp)
    80003cf4:	0141                	addi	sp,sp,16
    80003cf6:	8082                	ret

0000000080003cf8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003cf8:	1101                	addi	sp,sp,-32
    80003cfa:	ec06                	sd	ra,24(sp)
    80003cfc:	e822                	sd	s0,16(sp)
    80003cfe:	e426                	sd	s1,8(sp)
    80003d00:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d02:	0001c517          	auipc	a0,0x1c
    80003d06:	e6650513          	addi	a0,a0,-410 # 8001fb68 <ftable>
    80003d0a:	e9ffc0ef          	jal	ra,80000ba8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d0e:	0001c497          	auipc	s1,0x1c
    80003d12:	e7248493          	addi	s1,s1,-398 # 8001fb80 <ftable+0x18>
    80003d16:	0001d717          	auipc	a4,0x1d
    80003d1a:	e0a70713          	addi	a4,a4,-502 # 80020b20 <disk>
    if(f->ref == 0){
    80003d1e:	40dc                	lw	a5,4(s1)
    80003d20:	cf89                	beqz	a5,80003d3a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d22:	02848493          	addi	s1,s1,40
    80003d26:	fee49ce3          	bne	s1,a4,80003d1e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d2a:	0001c517          	auipc	a0,0x1c
    80003d2e:	e3e50513          	addi	a0,a0,-450 # 8001fb68 <ftable>
    80003d32:	f0ffc0ef          	jal	ra,80000c40 <release>
  return 0;
    80003d36:	4481                	li	s1,0
    80003d38:	a809                	j	80003d4a <filealloc+0x52>
      f->ref = 1;
    80003d3a:	4785                	li	a5,1
    80003d3c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d3e:	0001c517          	auipc	a0,0x1c
    80003d42:	e2a50513          	addi	a0,a0,-470 # 8001fb68 <ftable>
    80003d46:	efbfc0ef          	jal	ra,80000c40 <release>
}
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	60e2                	ld	ra,24(sp)
    80003d4e:	6442                	ld	s0,16(sp)
    80003d50:	64a2                	ld	s1,8(sp)
    80003d52:	6105                	addi	sp,sp,32
    80003d54:	8082                	ret

0000000080003d56 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d56:	1101                	addi	sp,sp,-32
    80003d58:	ec06                	sd	ra,24(sp)
    80003d5a:	e822                	sd	s0,16(sp)
    80003d5c:	e426                	sd	s1,8(sp)
    80003d5e:	1000                	addi	s0,sp,32
    80003d60:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d62:	0001c517          	auipc	a0,0x1c
    80003d66:	e0650513          	addi	a0,a0,-506 # 8001fb68 <ftable>
    80003d6a:	e3ffc0ef          	jal	ra,80000ba8 <acquire>
  if(f->ref < 1)
    80003d6e:	40dc                	lw	a5,4(s1)
    80003d70:	02f05063          	blez	a5,80003d90 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003d74:	2785                	addiw	a5,a5,1
    80003d76:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d78:	0001c517          	auipc	a0,0x1c
    80003d7c:	df050513          	addi	a0,a0,-528 # 8001fb68 <ftable>
    80003d80:	ec1fc0ef          	jal	ra,80000c40 <release>
  return f;
}
    80003d84:	8526                	mv	a0,s1
    80003d86:	60e2                	ld	ra,24(sp)
    80003d88:	6442                	ld	s0,16(sp)
    80003d8a:	64a2                	ld	s1,8(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret
    panic("filedup");
    80003d90:	00004517          	auipc	a0,0x4
    80003d94:	94050513          	addi	a0,a0,-1728 # 800076d0 <syscalls+0x240>
    80003d98:	9c5fc0ef          	jal	ra,8000075c <panic>

0000000080003d9c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d9c:	7139                	addi	sp,sp,-64
    80003d9e:	fc06                	sd	ra,56(sp)
    80003da0:	f822                	sd	s0,48(sp)
    80003da2:	f426                	sd	s1,40(sp)
    80003da4:	f04a                	sd	s2,32(sp)
    80003da6:	ec4e                	sd	s3,24(sp)
    80003da8:	e852                	sd	s4,16(sp)
    80003daa:	e456                	sd	s5,8(sp)
    80003dac:	0080                	addi	s0,sp,64
    80003dae:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003db0:	0001c517          	auipc	a0,0x1c
    80003db4:	db850513          	addi	a0,a0,-584 # 8001fb68 <ftable>
    80003db8:	df1fc0ef          	jal	ra,80000ba8 <acquire>
  if(f->ref < 1)
    80003dbc:	40dc                	lw	a5,4(s1)
    80003dbe:	04f05963          	blez	a5,80003e10 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003dc2:	37fd                	addiw	a5,a5,-1
    80003dc4:	0007871b          	sext.w	a4,a5
    80003dc8:	c0dc                	sw	a5,4(s1)
    80003dca:	04e04963          	bgtz	a4,80003e1c <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003dce:	0004a903          	lw	s2,0(s1)
    80003dd2:	0094ca83          	lbu	s5,9(s1)
    80003dd6:	0104ba03          	ld	s4,16(s1)
    80003dda:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003dde:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003de2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003de6:	0001c517          	auipc	a0,0x1c
    80003dea:	d8250513          	addi	a0,a0,-638 # 8001fb68 <ftable>
    80003dee:	e53fc0ef          	jal	ra,80000c40 <release>

  if(ff.type == FD_PIPE){
    80003df2:	4785                	li	a5,1
    80003df4:	04f90363          	beq	s2,a5,80003e3a <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003df8:	3979                	addiw	s2,s2,-2
    80003dfa:	4785                	li	a5,1
    80003dfc:	0327e663          	bltu	a5,s2,80003e28 <fileclose+0x8c>
    begin_op();
    80003e00:	b81ff0ef          	jal	ra,80003980 <begin_op>
    iput(ff.ip);
    80003e04:	854e                	mv	a0,s3
    80003e06:	c6eff0ef          	jal	ra,80003274 <iput>
    end_op();
    80003e0a:	be7ff0ef          	jal	ra,800039f0 <end_op>
    80003e0e:	a829                	j	80003e28 <fileclose+0x8c>
    panic("fileclose");
    80003e10:	00004517          	auipc	a0,0x4
    80003e14:	8c850513          	addi	a0,a0,-1848 # 800076d8 <syscalls+0x248>
    80003e18:	945fc0ef          	jal	ra,8000075c <panic>
    release(&ftable.lock);
    80003e1c:	0001c517          	auipc	a0,0x1c
    80003e20:	d4c50513          	addi	a0,a0,-692 # 8001fb68 <ftable>
    80003e24:	e1dfc0ef          	jal	ra,80000c40 <release>
  }
}
    80003e28:	70e2                	ld	ra,56(sp)
    80003e2a:	7442                	ld	s0,48(sp)
    80003e2c:	74a2                	ld	s1,40(sp)
    80003e2e:	7902                	ld	s2,32(sp)
    80003e30:	69e2                	ld	s3,24(sp)
    80003e32:	6a42                	ld	s4,16(sp)
    80003e34:	6aa2                	ld	s5,8(sp)
    80003e36:	6121                	addi	sp,sp,64
    80003e38:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e3a:	85d6                	mv	a1,s5
    80003e3c:	8552                	mv	a0,s4
    80003e3e:	2ec000ef          	jal	ra,8000412a <pipeclose>
    80003e42:	b7dd                	j	80003e28 <fileclose+0x8c>

0000000080003e44 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e44:	715d                	addi	sp,sp,-80
    80003e46:	e486                	sd	ra,72(sp)
    80003e48:	e0a2                	sd	s0,64(sp)
    80003e4a:	fc26                	sd	s1,56(sp)
    80003e4c:	f84a                	sd	s2,48(sp)
    80003e4e:	f44e                	sd	s3,40(sp)
    80003e50:	0880                	addi	s0,sp,80
    80003e52:	84aa                	mv	s1,a0
    80003e54:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e56:	9ebfd0ef          	jal	ra,80001840 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e5a:	409c                	lw	a5,0(s1)
    80003e5c:	37f9                	addiw	a5,a5,-2
    80003e5e:	4705                	li	a4,1
    80003e60:	02f76f63          	bltu	a4,a5,80003e9e <filestat+0x5a>
    80003e64:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e66:	6c88                	ld	a0,24(s1)
    80003e68:	a8eff0ef          	jal	ra,800030f6 <ilock>
    stati(f->ip, &st);
    80003e6c:	fb840593          	addi	a1,s0,-72
    80003e70:	6c88                	ld	a0,24(s1)
    80003e72:	caaff0ef          	jal	ra,8000331c <stati>
    iunlock(f->ip);
    80003e76:	6c88                	ld	a0,24(s1)
    80003e78:	b28ff0ef          	jal	ra,800031a0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e7c:	46e1                	li	a3,24
    80003e7e:	fb840613          	addi	a2,s0,-72
    80003e82:	85ce                	mv	a1,s3
    80003e84:	05093503          	ld	a0,80(s2)
    80003e88:	e6efd0ef          	jal	ra,800014f6 <copyout>
    80003e8c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e90:	60a6                	ld	ra,72(sp)
    80003e92:	6406                	ld	s0,64(sp)
    80003e94:	74e2                	ld	s1,56(sp)
    80003e96:	7942                	ld	s2,48(sp)
    80003e98:	79a2                	ld	s3,40(sp)
    80003e9a:	6161                	addi	sp,sp,80
    80003e9c:	8082                	ret
  return -1;
    80003e9e:	557d                	li	a0,-1
    80003ea0:	bfc5                	j	80003e90 <filestat+0x4c>

0000000080003ea2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ea2:	7179                	addi	sp,sp,-48
    80003ea4:	f406                	sd	ra,40(sp)
    80003ea6:	f022                	sd	s0,32(sp)
    80003ea8:	ec26                	sd	s1,24(sp)
    80003eaa:	e84a                	sd	s2,16(sp)
    80003eac:	e44e                	sd	s3,8(sp)
    80003eae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003eb0:	00854783          	lbu	a5,8(a0)
    80003eb4:	cbc1                	beqz	a5,80003f44 <fileread+0xa2>
    80003eb6:	84aa                	mv	s1,a0
    80003eb8:	89ae                	mv	s3,a1
    80003eba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ebc:	411c                	lw	a5,0(a0)
    80003ebe:	4705                	li	a4,1
    80003ec0:	04e78363          	beq	a5,a4,80003f06 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ec4:	470d                	li	a4,3
    80003ec6:	04e78563          	beq	a5,a4,80003f10 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eca:	4709                	li	a4,2
    80003ecc:	06e79663          	bne	a5,a4,80003f38 <fileread+0x96>
    ilock(f->ip);
    80003ed0:	6d08                	ld	a0,24(a0)
    80003ed2:	a24ff0ef          	jal	ra,800030f6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ed6:	874a                	mv	a4,s2
    80003ed8:	5094                	lw	a3,32(s1)
    80003eda:	864e                	mv	a2,s3
    80003edc:	4585                	li	a1,1
    80003ede:	6c88                	ld	a0,24(s1)
    80003ee0:	c66ff0ef          	jal	ra,80003346 <readi>
    80003ee4:	892a                	mv	s2,a0
    80003ee6:	00a05563          	blez	a0,80003ef0 <fileread+0x4e>
      f->off += r;
    80003eea:	509c                	lw	a5,32(s1)
    80003eec:	9fa9                	addw	a5,a5,a0
    80003eee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ef0:	6c88                	ld	a0,24(s1)
    80003ef2:	aaeff0ef          	jal	ra,800031a0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ef6:	854a                	mv	a0,s2
    80003ef8:	70a2                	ld	ra,40(sp)
    80003efa:	7402                	ld	s0,32(sp)
    80003efc:	64e2                	ld	s1,24(sp)
    80003efe:	6942                	ld	s2,16(sp)
    80003f00:	69a2                	ld	s3,8(sp)
    80003f02:	6145                	addi	sp,sp,48
    80003f04:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f06:	6908                	ld	a0,16(a0)
    80003f08:	356000ef          	jal	ra,8000425e <piperead>
    80003f0c:	892a                	mv	s2,a0
    80003f0e:	b7e5                	j	80003ef6 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f10:	02451783          	lh	a5,36(a0)
    80003f14:	03079693          	slli	a3,a5,0x30
    80003f18:	92c1                	srli	a3,a3,0x30
    80003f1a:	4725                	li	a4,9
    80003f1c:	02d76663          	bltu	a4,a3,80003f48 <fileread+0xa6>
    80003f20:	0792                	slli	a5,a5,0x4
    80003f22:	0001c717          	auipc	a4,0x1c
    80003f26:	ba670713          	addi	a4,a4,-1114 # 8001fac8 <devsw>
    80003f2a:	97ba                	add	a5,a5,a4
    80003f2c:	639c                	ld	a5,0(a5)
    80003f2e:	cf99                	beqz	a5,80003f4c <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003f30:	4505                	li	a0,1
    80003f32:	9782                	jalr	a5
    80003f34:	892a                	mv	s2,a0
    80003f36:	b7c1                	j	80003ef6 <fileread+0x54>
    panic("fileread");
    80003f38:	00003517          	auipc	a0,0x3
    80003f3c:	7b050513          	addi	a0,a0,1968 # 800076e8 <syscalls+0x258>
    80003f40:	81dfc0ef          	jal	ra,8000075c <panic>
    return -1;
    80003f44:	597d                	li	s2,-1
    80003f46:	bf45                	j	80003ef6 <fileread+0x54>
      return -1;
    80003f48:	597d                	li	s2,-1
    80003f4a:	b775                	j	80003ef6 <fileread+0x54>
    80003f4c:	597d                	li	s2,-1
    80003f4e:	b765                	j	80003ef6 <fileread+0x54>

0000000080003f50 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f50:	715d                	addi	sp,sp,-80
    80003f52:	e486                	sd	ra,72(sp)
    80003f54:	e0a2                	sd	s0,64(sp)
    80003f56:	fc26                	sd	s1,56(sp)
    80003f58:	f84a                	sd	s2,48(sp)
    80003f5a:	f44e                	sd	s3,40(sp)
    80003f5c:	f052                	sd	s4,32(sp)
    80003f5e:	ec56                	sd	s5,24(sp)
    80003f60:	e85a                	sd	s6,16(sp)
    80003f62:	e45e                	sd	s7,8(sp)
    80003f64:	e062                	sd	s8,0(sp)
    80003f66:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f68:	00954783          	lbu	a5,9(a0)
    80003f6c:	0e078863          	beqz	a5,8000405c <filewrite+0x10c>
    80003f70:	892a                	mv	s2,a0
    80003f72:	8aae                	mv	s5,a1
    80003f74:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f76:	411c                	lw	a5,0(a0)
    80003f78:	4705                	li	a4,1
    80003f7a:	02e78263          	beq	a5,a4,80003f9e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f7e:	470d                	li	a4,3
    80003f80:	02e78463          	beq	a5,a4,80003fa8 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f84:	4709                	li	a4,2
    80003f86:	0ce79563          	bne	a5,a4,80004050 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f8a:	0ac05163          	blez	a2,8000402c <filewrite+0xdc>
    int i = 0;
    80003f8e:	4981                	li	s3,0
    80003f90:	6b05                	lui	s6,0x1
    80003f92:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003f96:	6b85                	lui	s7,0x1
    80003f98:	c00b8b9b          	addiw	s7,s7,-1024
    80003f9c:	a041                	j	8000401c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003f9e:	6908                	ld	a0,16(a0)
    80003fa0:	1e2000ef          	jal	ra,80004182 <pipewrite>
    80003fa4:	8a2a                	mv	s4,a0
    80003fa6:	a071                	j	80004032 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003fa8:	02451783          	lh	a5,36(a0)
    80003fac:	03079693          	slli	a3,a5,0x30
    80003fb0:	92c1                	srli	a3,a3,0x30
    80003fb2:	4725                	li	a4,9
    80003fb4:	0ad76663          	bltu	a4,a3,80004060 <filewrite+0x110>
    80003fb8:	0792                	slli	a5,a5,0x4
    80003fba:	0001c717          	auipc	a4,0x1c
    80003fbe:	b0e70713          	addi	a4,a4,-1266 # 8001fac8 <devsw>
    80003fc2:	97ba                	add	a5,a5,a4
    80003fc4:	679c                	ld	a5,8(a5)
    80003fc6:	cfd9                	beqz	a5,80004064 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80003fc8:	4505                	li	a0,1
    80003fca:	9782                	jalr	a5
    80003fcc:	8a2a                	mv	s4,a0
    80003fce:	a095                	j	80004032 <filewrite+0xe2>
    80003fd0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003fd4:	9adff0ef          	jal	ra,80003980 <begin_op>
      ilock(f->ip);
    80003fd8:	01893503          	ld	a0,24(s2)
    80003fdc:	91aff0ef          	jal	ra,800030f6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fe0:	8762                	mv	a4,s8
    80003fe2:	02092683          	lw	a3,32(s2)
    80003fe6:	01598633          	add	a2,s3,s5
    80003fea:	4585                	li	a1,1
    80003fec:	01893503          	ld	a0,24(s2)
    80003ff0:	c3aff0ef          	jal	ra,8000342a <writei>
    80003ff4:	84aa                	mv	s1,a0
    80003ff6:	00a05763          	blez	a0,80004004 <filewrite+0xb4>
        f->off += r;
    80003ffa:	02092783          	lw	a5,32(s2)
    80003ffe:	9fa9                	addw	a5,a5,a0
    80004000:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004004:	01893503          	ld	a0,24(s2)
    80004008:	998ff0ef          	jal	ra,800031a0 <iunlock>
      end_op();
    8000400c:	9e5ff0ef          	jal	ra,800039f0 <end_op>

      if(r != n1){
    80004010:	009c1f63          	bne	s8,s1,8000402e <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80004014:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004018:	0149db63          	bge	s3,s4,8000402e <filewrite+0xde>
      int n1 = n - i;
    8000401c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004020:	84be                	mv	s1,a5
    80004022:	2781                	sext.w	a5,a5
    80004024:	fafb56e3          	bge	s6,a5,80003fd0 <filewrite+0x80>
    80004028:	84de                	mv	s1,s7
    8000402a:	b75d                	j	80003fd0 <filewrite+0x80>
    int i = 0;
    8000402c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000402e:	013a1f63          	bne	s4,s3,8000404c <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004032:	8552                	mv	a0,s4
    80004034:	60a6                	ld	ra,72(sp)
    80004036:	6406                	ld	s0,64(sp)
    80004038:	74e2                	ld	s1,56(sp)
    8000403a:	7942                	ld	s2,48(sp)
    8000403c:	79a2                	ld	s3,40(sp)
    8000403e:	7a02                	ld	s4,32(sp)
    80004040:	6ae2                	ld	s5,24(sp)
    80004042:	6b42                	ld	s6,16(sp)
    80004044:	6ba2                	ld	s7,8(sp)
    80004046:	6c02                	ld	s8,0(sp)
    80004048:	6161                	addi	sp,sp,80
    8000404a:	8082                	ret
    ret = (i == n ? n : -1);
    8000404c:	5a7d                	li	s4,-1
    8000404e:	b7d5                	j	80004032 <filewrite+0xe2>
    panic("filewrite");
    80004050:	00003517          	auipc	a0,0x3
    80004054:	6a850513          	addi	a0,a0,1704 # 800076f8 <syscalls+0x268>
    80004058:	f04fc0ef          	jal	ra,8000075c <panic>
    return -1;
    8000405c:	5a7d                	li	s4,-1
    8000405e:	bfd1                	j	80004032 <filewrite+0xe2>
      return -1;
    80004060:	5a7d                	li	s4,-1
    80004062:	bfc1                	j	80004032 <filewrite+0xe2>
    80004064:	5a7d                	li	s4,-1
    80004066:	b7f1                	j	80004032 <filewrite+0xe2>

0000000080004068 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004068:	7179                	addi	sp,sp,-48
    8000406a:	f406                	sd	ra,40(sp)
    8000406c:	f022                	sd	s0,32(sp)
    8000406e:	ec26                	sd	s1,24(sp)
    80004070:	e84a                	sd	s2,16(sp)
    80004072:	e44e                	sd	s3,8(sp)
    80004074:	e052                	sd	s4,0(sp)
    80004076:	1800                	addi	s0,sp,48
    80004078:	84aa                	mv	s1,a0
    8000407a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000407c:	0005b023          	sd	zero,0(a1)
    80004080:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004084:	c75ff0ef          	jal	ra,80003cf8 <filealloc>
    80004088:	e088                	sd	a0,0(s1)
    8000408a:	cd35                	beqz	a0,80004106 <pipealloc+0x9e>
    8000408c:	c6dff0ef          	jal	ra,80003cf8 <filealloc>
    80004090:	00aa3023          	sd	a0,0(s4)
    80004094:	c52d                	beqz	a0,800040fe <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004096:	a43fc0ef          	jal	ra,80000ad8 <kalloc>
    8000409a:	892a                	mv	s2,a0
    8000409c:	cd31                	beqz	a0,800040f8 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    8000409e:	4985                	li	s3,1
    800040a0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800040a4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040a8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040ac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040b0:	00003597          	auipc	a1,0x3
    800040b4:	65858593          	addi	a1,a1,1624 # 80007708 <syscalls+0x278>
    800040b8:	a71fc0ef          	jal	ra,80000b28 <initlock>
  (*f0)->type = FD_PIPE;
    800040bc:	609c                	ld	a5,0(s1)
    800040be:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040c2:	609c                	ld	a5,0(s1)
    800040c4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040c8:	609c                	ld	a5,0(s1)
    800040ca:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040ce:	609c                	ld	a5,0(s1)
    800040d0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040d4:	000a3783          	ld	a5,0(s4)
    800040d8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040dc:	000a3783          	ld	a5,0(s4)
    800040e0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040e4:	000a3783          	ld	a5,0(s4)
    800040e8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040ec:	000a3783          	ld	a5,0(s4)
    800040f0:	0127b823          	sd	s2,16(a5)
  return 0;
    800040f4:	4501                	li	a0,0
    800040f6:	a005                	j	80004116 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040f8:	6088                	ld	a0,0(s1)
    800040fa:	e501                	bnez	a0,80004102 <pipealloc+0x9a>
    800040fc:	a029                	j	80004106 <pipealloc+0x9e>
    800040fe:	6088                	ld	a0,0(s1)
    80004100:	c11d                	beqz	a0,80004126 <pipealloc+0xbe>
    fileclose(*f0);
    80004102:	c9bff0ef          	jal	ra,80003d9c <fileclose>
  if(*f1)
    80004106:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000410a:	557d                	li	a0,-1
  if(*f1)
    8000410c:	c789                	beqz	a5,80004116 <pipealloc+0xae>
    fileclose(*f1);
    8000410e:	853e                	mv	a0,a5
    80004110:	c8dff0ef          	jal	ra,80003d9c <fileclose>
  return -1;
    80004114:	557d                	li	a0,-1
}
    80004116:	70a2                	ld	ra,40(sp)
    80004118:	7402                	ld	s0,32(sp)
    8000411a:	64e2                	ld	s1,24(sp)
    8000411c:	6942                	ld	s2,16(sp)
    8000411e:	69a2                	ld	s3,8(sp)
    80004120:	6a02                	ld	s4,0(sp)
    80004122:	6145                	addi	sp,sp,48
    80004124:	8082                	ret
  return -1;
    80004126:	557d                	li	a0,-1
    80004128:	b7fd                	j	80004116 <pipealloc+0xae>

000000008000412a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000412a:	1101                	addi	sp,sp,-32
    8000412c:	ec06                	sd	ra,24(sp)
    8000412e:	e822                	sd	s0,16(sp)
    80004130:	e426                	sd	s1,8(sp)
    80004132:	e04a                	sd	s2,0(sp)
    80004134:	1000                	addi	s0,sp,32
    80004136:	84aa                	mv	s1,a0
    80004138:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000413a:	a6ffc0ef          	jal	ra,80000ba8 <acquire>
  if(writable){
    8000413e:	02090763          	beqz	s2,8000416c <pipeclose+0x42>
    pi->writeopen = 0;
    80004142:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004146:	21848513          	addi	a0,s1,536
    8000414a:	d0bfd0ef          	jal	ra,80001e54 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000414e:	2204b783          	ld	a5,544(s1)
    80004152:	e785                	bnez	a5,8000417a <pipeclose+0x50>
    release(&pi->lock);
    80004154:	8526                	mv	a0,s1
    80004156:	aebfc0ef          	jal	ra,80000c40 <release>
    kfree((char*)pi);
    8000415a:	8526                	mv	a0,s1
    8000415c:	89dfc0ef          	jal	ra,800009f8 <kfree>
  } else
    release(&pi->lock);
}
    80004160:	60e2                	ld	ra,24(sp)
    80004162:	6442                	ld	s0,16(sp)
    80004164:	64a2                	ld	s1,8(sp)
    80004166:	6902                	ld	s2,0(sp)
    80004168:	6105                	addi	sp,sp,32
    8000416a:	8082                	ret
    pi->readopen = 0;
    8000416c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004170:	21c48513          	addi	a0,s1,540
    80004174:	ce1fd0ef          	jal	ra,80001e54 <wakeup>
    80004178:	bfd9                	j	8000414e <pipeclose+0x24>
    release(&pi->lock);
    8000417a:	8526                	mv	a0,s1
    8000417c:	ac5fc0ef          	jal	ra,80000c40 <release>
}
    80004180:	b7c5                	j	80004160 <pipeclose+0x36>

0000000080004182 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004182:	7159                	addi	sp,sp,-112
    80004184:	f486                	sd	ra,104(sp)
    80004186:	f0a2                	sd	s0,96(sp)
    80004188:	eca6                	sd	s1,88(sp)
    8000418a:	e8ca                	sd	s2,80(sp)
    8000418c:	e4ce                	sd	s3,72(sp)
    8000418e:	e0d2                	sd	s4,64(sp)
    80004190:	fc56                	sd	s5,56(sp)
    80004192:	f85a                	sd	s6,48(sp)
    80004194:	f45e                	sd	s7,40(sp)
    80004196:	f062                	sd	s8,32(sp)
    80004198:	ec66                	sd	s9,24(sp)
    8000419a:	1880                	addi	s0,sp,112
    8000419c:	84aa                	mv	s1,a0
    8000419e:	8aae                	mv	s5,a1
    800041a0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041a2:	e9efd0ef          	jal	ra,80001840 <myproc>
    800041a6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041a8:	8526                	mv	a0,s1
    800041aa:	9fffc0ef          	jal	ra,80000ba8 <acquire>
  while(i < n){
    800041ae:	0b405663          	blez	s4,8000425a <pipewrite+0xd8>
    800041b2:	8ba6                	mv	s7,s1
  int i = 0;
    800041b4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041b8:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041bc:	21c48c13          	addi	s8,s1,540
    800041c0:	a899                	j	80004216 <pipewrite+0x94>
      release(&pi->lock);
    800041c2:	8526                	mv	a0,s1
    800041c4:	a7dfc0ef          	jal	ra,80000c40 <release>
      return -1;
    800041c8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041ca:	854a                	mv	a0,s2
    800041cc:	70a6                	ld	ra,104(sp)
    800041ce:	7406                	ld	s0,96(sp)
    800041d0:	64e6                	ld	s1,88(sp)
    800041d2:	6946                	ld	s2,80(sp)
    800041d4:	69a6                	ld	s3,72(sp)
    800041d6:	6a06                	ld	s4,64(sp)
    800041d8:	7ae2                	ld	s5,56(sp)
    800041da:	7b42                	ld	s6,48(sp)
    800041dc:	7ba2                	ld	s7,40(sp)
    800041de:	7c02                	ld	s8,32(sp)
    800041e0:	6ce2                	ld	s9,24(sp)
    800041e2:	6165                	addi	sp,sp,112
    800041e4:	8082                	ret
      wakeup(&pi->nread);
    800041e6:	8566                	mv	a0,s9
    800041e8:	c6dfd0ef          	jal	ra,80001e54 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041ec:	85de                	mv	a1,s7
    800041ee:	8562                	mv	a0,s8
    800041f0:	c19fd0ef          	jal	ra,80001e08 <sleep>
    800041f4:	a839                	j	80004212 <pipewrite+0x90>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041f6:	21c4a783          	lw	a5,540(s1)
    800041fa:	0017871b          	addiw	a4,a5,1
    800041fe:	20e4ae23          	sw	a4,540(s1)
    80004202:	1ff7f793          	andi	a5,a5,511
    80004206:	97a6                	add	a5,a5,s1
    80004208:	f9f44703          	lbu	a4,-97(s0)
    8000420c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004210:	2905                	addiw	s2,s2,1
  while(i < n){
    80004212:	03495c63          	bge	s2,s4,8000424a <pipewrite+0xc8>
    if(pi->readopen == 0 || killed(pr)){
    80004216:	2204a783          	lw	a5,544(s1)
    8000421a:	d7c5                	beqz	a5,800041c2 <pipewrite+0x40>
    8000421c:	854e                	mv	a0,s3
    8000421e:	e23fd0ef          	jal	ra,80002040 <killed>
    80004222:	f145                	bnez	a0,800041c2 <pipewrite+0x40>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004224:	2184a783          	lw	a5,536(s1)
    80004228:	21c4a703          	lw	a4,540(s1)
    8000422c:	2007879b          	addiw	a5,a5,512
    80004230:	faf70be3          	beq	a4,a5,800041e6 <pipewrite+0x64>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004234:	4685                	li	a3,1
    80004236:	01590633          	add	a2,s2,s5
    8000423a:	f9f40593          	addi	a1,s0,-97
    8000423e:	0509b503          	ld	a0,80(s3)
    80004242:	b6cfd0ef          	jal	ra,800015ae <copyin>
    80004246:	fb6518e3          	bne	a0,s6,800041f6 <pipewrite+0x74>
  wakeup(&pi->nread);
    8000424a:	21848513          	addi	a0,s1,536
    8000424e:	c07fd0ef          	jal	ra,80001e54 <wakeup>
  release(&pi->lock);
    80004252:	8526                	mv	a0,s1
    80004254:	9edfc0ef          	jal	ra,80000c40 <release>
  return i;
    80004258:	bf8d                	j	800041ca <pipewrite+0x48>
  int i = 0;
    8000425a:	4901                	li	s2,0
    8000425c:	b7fd                	j	8000424a <pipewrite+0xc8>

000000008000425e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000425e:	715d                	addi	sp,sp,-80
    80004260:	e486                	sd	ra,72(sp)
    80004262:	e0a2                	sd	s0,64(sp)
    80004264:	fc26                	sd	s1,56(sp)
    80004266:	f84a                	sd	s2,48(sp)
    80004268:	f44e                	sd	s3,40(sp)
    8000426a:	f052                	sd	s4,32(sp)
    8000426c:	ec56                	sd	s5,24(sp)
    8000426e:	e85a                	sd	s6,16(sp)
    80004270:	0880                	addi	s0,sp,80
    80004272:	84aa                	mv	s1,a0
    80004274:	892e                	mv	s2,a1
    80004276:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004278:	dc8fd0ef          	jal	ra,80001840 <myproc>
    8000427c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000427e:	8b26                	mv	s6,s1
    80004280:	8526                	mv	a0,s1
    80004282:	927fc0ef          	jal	ra,80000ba8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004286:	2184a703          	lw	a4,536(s1)
    8000428a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000428e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004292:	02f71363          	bne	a4,a5,800042b8 <piperead+0x5a>
    80004296:	2244a783          	lw	a5,548(s1)
    8000429a:	cf99                	beqz	a5,800042b8 <piperead+0x5a>
    if(killed(pr)){
    8000429c:	8552                	mv	a0,s4
    8000429e:	da3fd0ef          	jal	ra,80002040 <killed>
    800042a2:	e141                	bnez	a0,80004322 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042a4:	85da                	mv	a1,s6
    800042a6:	854e                	mv	a0,s3
    800042a8:	b61fd0ef          	jal	ra,80001e08 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042ac:	2184a703          	lw	a4,536(s1)
    800042b0:	21c4a783          	lw	a5,540(s1)
    800042b4:	fef701e3          	beq	a4,a5,80004296 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042b8:	07505a63          	blez	s5,8000432c <piperead+0xce>
    800042bc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042be:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800042c0:	2184a783          	lw	a5,536(s1)
    800042c4:	21c4a703          	lw	a4,540(s1)
    800042c8:	02f70b63          	beq	a4,a5,800042fe <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042cc:	0017871b          	addiw	a4,a5,1
    800042d0:	20e4ac23          	sw	a4,536(s1)
    800042d4:	1ff7f793          	andi	a5,a5,511
    800042d8:	97a6                	add	a5,a5,s1
    800042da:	0187c783          	lbu	a5,24(a5)
    800042de:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042e2:	4685                	li	a3,1
    800042e4:	fbf40613          	addi	a2,s0,-65
    800042e8:	85ca                	mv	a1,s2
    800042ea:	050a3503          	ld	a0,80(s4)
    800042ee:	a08fd0ef          	jal	ra,800014f6 <copyout>
    800042f2:	01650663          	beq	a0,s6,800042fe <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042f6:	2985                	addiw	s3,s3,1
    800042f8:	0905                	addi	s2,s2,1
    800042fa:	fd3a93e3          	bne	s5,s3,800042c0 <piperead+0x62>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042fe:	21c48513          	addi	a0,s1,540
    80004302:	b53fd0ef          	jal	ra,80001e54 <wakeup>
  release(&pi->lock);
    80004306:	8526                	mv	a0,s1
    80004308:	939fc0ef          	jal	ra,80000c40 <release>
  return i;
}
    8000430c:	854e                	mv	a0,s3
    8000430e:	60a6                	ld	ra,72(sp)
    80004310:	6406                	ld	s0,64(sp)
    80004312:	74e2                	ld	s1,56(sp)
    80004314:	7942                	ld	s2,48(sp)
    80004316:	79a2                	ld	s3,40(sp)
    80004318:	7a02                	ld	s4,32(sp)
    8000431a:	6ae2                	ld	s5,24(sp)
    8000431c:	6b42                	ld	s6,16(sp)
    8000431e:	6161                	addi	sp,sp,80
    80004320:	8082                	ret
      release(&pi->lock);
    80004322:	8526                	mv	a0,s1
    80004324:	91dfc0ef          	jal	ra,80000c40 <release>
      return -1;
    80004328:	59fd                	li	s3,-1
    8000432a:	b7cd                	j	8000430c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000432c:	4981                	li	s3,0
    8000432e:	bfc1                	j	800042fe <piperead+0xa0>

0000000080004330 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004330:	1141                	addi	sp,sp,-16
    80004332:	e422                	sd	s0,8(sp)
    80004334:	0800                	addi	s0,sp,16
    80004336:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004338:	8905                	andi	a0,a0,1
    8000433a:	c111                	beqz	a0,8000433e <flags2perm+0xe>
      perm = PTE_X;
    8000433c:	4521                	li	a0,8
    if(flags & 0x2)
    8000433e:	8b89                	andi	a5,a5,2
    80004340:	c399                	beqz	a5,80004346 <flags2perm+0x16>
      perm |= PTE_W;
    80004342:	00456513          	ori	a0,a0,4
    return perm;
}
    80004346:	6422                	ld	s0,8(sp)
    80004348:	0141                	addi	sp,sp,16
    8000434a:	8082                	ret

000000008000434c <exec>:

int
exec(char *path, char **argv)
{
    8000434c:	df010113          	addi	sp,sp,-528
    80004350:	20113423          	sd	ra,520(sp)
    80004354:	20813023          	sd	s0,512(sp)
    80004358:	ffa6                	sd	s1,504(sp)
    8000435a:	fbca                	sd	s2,496(sp)
    8000435c:	f7ce                	sd	s3,488(sp)
    8000435e:	f3d2                	sd	s4,480(sp)
    80004360:	efd6                	sd	s5,472(sp)
    80004362:	ebda                	sd	s6,464(sp)
    80004364:	e7de                	sd	s7,456(sp)
    80004366:	e3e2                	sd	s8,448(sp)
    80004368:	ff66                	sd	s9,440(sp)
    8000436a:	fb6a                	sd	s10,432(sp)
    8000436c:	f76e                	sd	s11,424(sp)
    8000436e:	0c00                	addi	s0,sp,528
    80004370:	84aa                	mv	s1,a0
    80004372:	dea43c23          	sd	a0,-520(s0)
    80004376:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000437a:	cc6fd0ef          	jal	ra,80001840 <myproc>
    8000437e:	892a                	mv	s2,a0

  begin_op();
    80004380:	e00ff0ef          	jal	ra,80003980 <begin_op>

  if((ip = namei(path)) == 0){
    80004384:	8526                	mv	a0,s1
    80004386:	c22ff0ef          	jal	ra,800037a8 <namei>
    8000438a:	c12d                	beqz	a0,800043ec <exec+0xa0>
    8000438c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000438e:	d69fe0ef          	jal	ra,800030f6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004392:	04000713          	li	a4,64
    80004396:	4681                	li	a3,0
    80004398:	e5040613          	addi	a2,s0,-432
    8000439c:	4581                	li	a1,0
    8000439e:	8526                	mv	a0,s1
    800043a0:	fa7fe0ef          	jal	ra,80003346 <readi>
    800043a4:	04000793          	li	a5,64
    800043a8:	00f51a63          	bne	a0,a5,800043bc <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800043ac:	e5042703          	lw	a4,-432(s0)
    800043b0:	464c47b7          	lui	a5,0x464c4
    800043b4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043b8:	02f70e63          	beq	a4,a5,800043f4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043bc:	8526                	mv	a0,s1
    800043be:	f3ffe0ef          	jal	ra,800032fc <iunlockput>
    end_op();
    800043c2:	e2eff0ef          	jal	ra,800039f0 <end_op>
  }
  return -1;
    800043c6:	557d                	li	a0,-1
}
    800043c8:	20813083          	ld	ra,520(sp)
    800043cc:	20013403          	ld	s0,512(sp)
    800043d0:	74fe                	ld	s1,504(sp)
    800043d2:	795e                	ld	s2,496(sp)
    800043d4:	79be                	ld	s3,488(sp)
    800043d6:	7a1e                	ld	s4,480(sp)
    800043d8:	6afe                	ld	s5,472(sp)
    800043da:	6b5e                	ld	s6,464(sp)
    800043dc:	6bbe                	ld	s7,456(sp)
    800043de:	6c1e                	ld	s8,448(sp)
    800043e0:	7cfa                	ld	s9,440(sp)
    800043e2:	7d5a                	ld	s10,432(sp)
    800043e4:	7dba                	ld	s11,424(sp)
    800043e6:	21010113          	addi	sp,sp,528
    800043ea:	8082                	ret
    end_op();
    800043ec:	e04ff0ef          	jal	ra,800039f0 <end_op>
    return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	bfd9                	j	800043c8 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800043f4:	854a                	mv	a0,s2
    800043f6:	cf2fd0ef          	jal	ra,800018e8 <proc_pagetable>
    800043fa:	8baa                	mv	s7,a0
    800043fc:	d161                	beqz	a0,800043bc <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043fe:	e7042983          	lw	s3,-400(s0)
    80004402:	e8845783          	lhu	a5,-376(s0)
    80004406:	cfb9                	beqz	a5,80004464 <exec+0x118>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004408:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000440a:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000440c:	6c85                	lui	s9,0x1
    8000440e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004412:	def43823          	sd	a5,-528(s0)
    80004416:	aadd                	j	8000460c <exec+0x2c0>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004418:	00003517          	auipc	a0,0x3
    8000441c:	2f850513          	addi	a0,a0,760 # 80007710 <syscalls+0x280>
    80004420:	b3cfc0ef          	jal	ra,8000075c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004424:	8756                	mv	a4,s5
    80004426:	012d86bb          	addw	a3,s11,s2
    8000442a:	4581                	li	a1,0
    8000442c:	8526                	mv	a0,s1
    8000442e:	f19fe0ef          	jal	ra,80003346 <readi>
    80004432:	2501                	sext.w	a0,a0
    80004434:	18aa9263          	bne	s5,a0,800045b8 <exec+0x26c>
  for(i = 0; i < sz; i += PGSIZE){
    80004438:	6785                	lui	a5,0x1
    8000443a:	0127893b          	addw	s2,a5,s2
    8000443e:	77fd                	lui	a5,0xfffff
    80004440:	01478a3b          	addw	s4,a5,s4
    80004444:	1b897b63          	bgeu	s2,s8,800045fa <exec+0x2ae>
    pa = walkaddr(pagetable, va + i);
    80004448:	02091593          	slli	a1,s2,0x20
    8000444c:	9181                	srli	a1,a1,0x20
    8000444e:	95ea                	add	a1,a1,s10
    80004450:	855e                	mv	a0,s7
    80004452:	b49fc0ef          	jal	ra,80000f9a <walkaddr>
    80004456:	862a                	mv	a2,a0
    if(pa == 0)
    80004458:	d161                	beqz	a0,80004418 <exec+0xcc>
      n = PGSIZE;
    8000445a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000445c:	fd9a74e3          	bgeu	s4,s9,80004424 <exec+0xd8>
      n = sz - i;
    80004460:	8ad2                	mv	s5,s4
    80004462:	b7c9                	j	80004424 <exec+0xd8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004464:	4a01                	li	s4,0
  iunlockput(ip);
    80004466:	8526                	mv	a0,s1
    80004468:	e95fe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    8000446c:	d84ff0ef          	jal	ra,800039f0 <end_op>
  p = myproc();
    80004470:	bd0fd0ef          	jal	ra,80001840 <myproc>
    80004474:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004476:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000447a:	6785                	lui	a5,0x1
    8000447c:	17fd                	addi	a5,a5,-1
    8000447e:	9a3e                	add	s4,s4,a5
    80004480:	757d                	lui	a0,0xfffff
    80004482:	00aa77b3          	and	a5,s4,a0
    80004486:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000448a:	4691                	li	a3,4
    8000448c:	6609                	lui	a2,0x2
    8000448e:	963e                	add	a2,a2,a5
    80004490:	85be                	mv	a1,a5
    80004492:	855e                	mv	a0,s7
    80004494:	e5ffc0ef          	jal	ra,800012f2 <uvmalloc>
    80004498:	8b2a                	mv	s6,a0
  ip = 0;
    8000449a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000449c:	10050e63          	beqz	a0,800045b8 <exec+0x26c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800044a0:	75f9                	lui	a1,0xffffe
    800044a2:	95aa                	add	a1,a1,a0
    800044a4:	855e                	mv	a0,s7
    800044a6:	826fd0ef          	jal	ra,800014cc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800044aa:	7c7d                	lui	s8,0xfffff
    800044ac:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800044ae:	e0043783          	ld	a5,-512(s0)
    800044b2:	6388                	ld	a0,0(a5)
    800044b4:	c125                	beqz	a0,80004514 <exec+0x1c8>
    800044b6:	e9040993          	addi	s3,s0,-368
    800044ba:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044be:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800044c0:	93dfc0ef          	jal	ra,80000dfc <strlen>
    800044c4:	2505                	addiw	a0,a0,1
    800044c6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044ca:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800044ce:	11896a63          	bltu	s2,s8,800045e2 <exec+0x296>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044d2:	e0043d83          	ld	s11,-512(s0)
    800044d6:	000dba03          	ld	s4,0(s11)
    800044da:	8552                	mv	a0,s4
    800044dc:	921fc0ef          	jal	ra,80000dfc <strlen>
    800044e0:	0015069b          	addiw	a3,a0,1
    800044e4:	8652                	mv	a2,s4
    800044e6:	85ca                	mv	a1,s2
    800044e8:	855e                	mv	a0,s7
    800044ea:	80cfd0ef          	jal	ra,800014f6 <copyout>
    800044ee:	0e054e63          	bltz	a0,800045ea <exec+0x29e>
    ustack[argc] = sp;
    800044f2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044f6:	0485                	addi	s1,s1,1
    800044f8:	008d8793          	addi	a5,s11,8
    800044fc:	e0f43023          	sd	a5,-512(s0)
    80004500:	008db503          	ld	a0,8(s11)
    80004504:	c911                	beqz	a0,80004518 <exec+0x1cc>
    if(argc >= MAXARG)
    80004506:	09a1                	addi	s3,s3,8
    80004508:	fb3c9ce3          	bne	s9,s3,800044c0 <exec+0x174>
  sz = sz1;
    8000450c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004510:	4481                	li	s1,0
    80004512:	a05d                	j	800045b8 <exec+0x26c>
  sp = sz;
    80004514:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004516:	4481                	li	s1,0
  ustack[argc] = 0;
    80004518:	00349793          	slli	a5,s1,0x3
    8000451c:	f9040713          	addi	a4,s0,-112
    80004520:	97ba                	add	a5,a5,a4
    80004522:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004526:	00148693          	addi	a3,s1,1
    8000452a:	068e                	slli	a3,a3,0x3
    8000452c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004530:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004534:	01897663          	bgeu	s2,s8,80004540 <exec+0x1f4>
  sz = sz1;
    80004538:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000453c:	4481                	li	s1,0
    8000453e:	a8ad                	j	800045b8 <exec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004540:	e9040613          	addi	a2,s0,-368
    80004544:	85ca                	mv	a1,s2
    80004546:	855e                	mv	a0,s7
    80004548:	faffc0ef          	jal	ra,800014f6 <copyout>
    8000454c:	0a054363          	bltz	a0,800045f2 <exec+0x2a6>
  p->trapframe->a1 = sp;
    80004550:	058ab783          	ld	a5,88(s5)
    80004554:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004558:	df843783          	ld	a5,-520(s0)
    8000455c:	0007c703          	lbu	a4,0(a5)
    80004560:	cf11                	beqz	a4,8000457c <exec+0x230>
    80004562:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004564:	02f00693          	li	a3,47
    80004568:	a039                	j	80004576 <exec+0x22a>
      last = s+1;
    8000456a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000456e:	0785                	addi	a5,a5,1
    80004570:	fff7c703          	lbu	a4,-1(a5)
    80004574:	c701                	beqz	a4,8000457c <exec+0x230>
    if(*s == '/')
    80004576:	fed71ce3          	bne	a4,a3,8000456e <exec+0x222>
    8000457a:	bfc5                	j	8000456a <exec+0x21e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000457c:	4641                	li	a2,16
    8000457e:	df843583          	ld	a1,-520(s0)
    80004582:	158a8513          	addi	a0,s5,344
    80004586:	845fc0ef          	jal	ra,80000dca <safestrcpy>
  oldpagetable = p->pagetable;
    8000458a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000458e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004592:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004596:	058ab783          	ld	a5,88(s5)
    8000459a:	e6843703          	ld	a4,-408(s0)
    8000459e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045a0:	058ab783          	ld	a5,88(s5)
    800045a4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045a8:	85ea                	mv	a1,s10
    800045aa:	bc2fd0ef          	jal	ra,8000196c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045ae:	0004851b          	sext.w	a0,s1
    800045b2:	bd19                	j	800043c8 <exec+0x7c>
    800045b4:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045b8:	e0843583          	ld	a1,-504(s0)
    800045bc:	855e                	mv	a0,s7
    800045be:	baefd0ef          	jal	ra,8000196c <proc_freepagetable>
  if(ip){
    800045c2:	de049de3          	bnez	s1,800043bc <exec+0x70>
  return -1;
    800045c6:	557d                	li	a0,-1
    800045c8:	b501                	j	800043c8 <exec+0x7c>
    800045ca:	e1443423          	sd	s4,-504(s0)
    800045ce:	b7ed                	j	800045b8 <exec+0x26c>
    800045d0:	e1443423          	sd	s4,-504(s0)
    800045d4:	b7d5                	j	800045b8 <exec+0x26c>
    800045d6:	e1443423          	sd	s4,-504(s0)
    800045da:	bff9                	j	800045b8 <exec+0x26c>
    800045dc:	e1443423          	sd	s4,-504(s0)
    800045e0:	bfe1                	j	800045b8 <exec+0x26c>
  sz = sz1;
    800045e2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045e6:	4481                	li	s1,0
    800045e8:	bfc1                	j	800045b8 <exec+0x26c>
  sz = sz1;
    800045ea:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045ee:	4481                	li	s1,0
    800045f0:	b7e1                	j	800045b8 <exec+0x26c>
  sz = sz1;
    800045f2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045f6:	4481                	li	s1,0
    800045f8:	b7c1                	j	800045b8 <exec+0x26c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045fa:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045fe:	2b05                	addiw	s6,s6,1
    80004600:	0389899b          	addiw	s3,s3,56
    80004604:	e8845783          	lhu	a5,-376(s0)
    80004608:	e4fb5fe3          	bge	s6,a5,80004466 <exec+0x11a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000460c:	2981                	sext.w	s3,s3
    8000460e:	03800713          	li	a4,56
    80004612:	86ce                	mv	a3,s3
    80004614:	e1840613          	addi	a2,s0,-488
    80004618:	4581                	li	a1,0
    8000461a:	8526                	mv	a0,s1
    8000461c:	d2bfe0ef          	jal	ra,80003346 <readi>
    80004620:	03800793          	li	a5,56
    80004624:	f8f518e3          	bne	a0,a5,800045b4 <exec+0x268>
    if(ph.type != ELF_PROG_LOAD)
    80004628:	e1842783          	lw	a5,-488(s0)
    8000462c:	4705                	li	a4,1
    8000462e:	fce798e3          	bne	a5,a4,800045fe <exec+0x2b2>
    if(ph.memsz < ph.filesz)
    80004632:	e4043903          	ld	s2,-448(s0)
    80004636:	e3843783          	ld	a5,-456(s0)
    8000463a:	f8f968e3          	bltu	s2,a5,800045ca <exec+0x27e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000463e:	e2843783          	ld	a5,-472(s0)
    80004642:	993e                	add	s2,s2,a5
    80004644:	f8f966e3          	bltu	s2,a5,800045d0 <exec+0x284>
    if(ph.vaddr % PGSIZE != 0)
    80004648:	df043703          	ld	a4,-528(s0)
    8000464c:	8ff9                	and	a5,a5,a4
    8000464e:	f7c1                	bnez	a5,800045d6 <exec+0x28a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004650:	e1c42503          	lw	a0,-484(s0)
    80004654:	cddff0ef          	jal	ra,80004330 <flags2perm>
    80004658:	86aa                	mv	a3,a0
    8000465a:	864a                	mv	a2,s2
    8000465c:	85d2                	mv	a1,s4
    8000465e:	855e                	mv	a0,s7
    80004660:	c93fc0ef          	jal	ra,800012f2 <uvmalloc>
    80004664:	e0a43423          	sd	a0,-504(s0)
    80004668:	d935                	beqz	a0,800045dc <exec+0x290>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000466a:	e2843d03          	ld	s10,-472(s0)
    8000466e:	e2042d83          	lw	s11,-480(s0)
    80004672:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004676:	f80c02e3          	beqz	s8,800045fa <exec+0x2ae>
    8000467a:	8a62                	mv	s4,s8
    8000467c:	4901                	li	s2,0
    8000467e:	b3e9                	j	80004448 <exec+0xfc>

0000000080004680 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004680:	7179                	addi	sp,sp,-48
    80004682:	f406                	sd	ra,40(sp)
    80004684:	f022                	sd	s0,32(sp)
    80004686:	ec26                	sd	s1,24(sp)
    80004688:	e84a                	sd	s2,16(sp)
    8000468a:	1800                	addi	s0,sp,48
    8000468c:	892e                	mv	s2,a1
    8000468e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004690:	fdc40593          	addi	a1,s0,-36
    80004694:	854fe0ef          	jal	ra,800026e8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004698:	fdc42703          	lw	a4,-36(s0)
    8000469c:	47bd                	li	a5,15
    8000469e:	02e7e963          	bltu	a5,a4,800046d0 <argfd+0x50>
    800046a2:	99efd0ef          	jal	ra,80001840 <myproc>
    800046a6:	fdc42703          	lw	a4,-36(s0)
    800046aa:	01a70793          	addi	a5,a4,26
    800046ae:	078e                	slli	a5,a5,0x3
    800046b0:	953e                	add	a0,a0,a5
    800046b2:	611c                	ld	a5,0(a0)
    800046b4:	c385                	beqz	a5,800046d4 <argfd+0x54>
    return -1;
  if(pfd)
    800046b6:	00090463          	beqz	s2,800046be <argfd+0x3e>
    *pfd = fd;
    800046ba:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046be:	4501                	li	a0,0
  if(pf)
    800046c0:	c091                	beqz	s1,800046c4 <argfd+0x44>
    *pf = f;
    800046c2:	e09c                	sd	a5,0(s1)
}
    800046c4:	70a2                	ld	ra,40(sp)
    800046c6:	7402                	ld	s0,32(sp)
    800046c8:	64e2                	ld	s1,24(sp)
    800046ca:	6942                	ld	s2,16(sp)
    800046cc:	6145                	addi	sp,sp,48
    800046ce:	8082                	ret
    return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	bfcd                	j	800046c4 <argfd+0x44>
    800046d4:	557d                	li	a0,-1
    800046d6:	b7fd                	j	800046c4 <argfd+0x44>

00000000800046d8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046d8:	1101                	addi	sp,sp,-32
    800046da:	ec06                	sd	ra,24(sp)
    800046dc:	e822                	sd	s0,16(sp)
    800046de:	e426                	sd	s1,8(sp)
    800046e0:	1000                	addi	s0,sp,32
    800046e2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046e4:	95cfd0ef          	jal	ra,80001840 <myproc>
    800046e8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046ea:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffde470>
    800046ee:	4501                	li	a0,0
    800046f0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046f2:	6398                	ld	a4,0(a5)
    800046f4:	cb19                	beqz	a4,8000470a <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800046f6:	2505                	addiw	a0,a0,1
    800046f8:	07a1                	addi	a5,a5,8
    800046fa:	fed51ce3          	bne	a0,a3,800046f2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046fe:	557d                	li	a0,-1
}
    80004700:	60e2                	ld	ra,24(sp)
    80004702:	6442                	ld	s0,16(sp)
    80004704:	64a2                	ld	s1,8(sp)
    80004706:	6105                	addi	sp,sp,32
    80004708:	8082                	ret
      p->ofile[fd] = f;
    8000470a:	01a50793          	addi	a5,a0,26
    8000470e:	078e                	slli	a5,a5,0x3
    80004710:	963e                	add	a2,a2,a5
    80004712:	e204                	sd	s1,0(a2)
      return fd;
    80004714:	b7f5                	j	80004700 <fdalloc+0x28>

0000000080004716 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004716:	715d                	addi	sp,sp,-80
    80004718:	e486                	sd	ra,72(sp)
    8000471a:	e0a2                	sd	s0,64(sp)
    8000471c:	fc26                	sd	s1,56(sp)
    8000471e:	f84a                	sd	s2,48(sp)
    80004720:	f44e                	sd	s3,40(sp)
    80004722:	f052                	sd	s4,32(sp)
    80004724:	ec56                	sd	s5,24(sp)
    80004726:	e85a                	sd	s6,16(sp)
    80004728:	0880                	addi	s0,sp,80
    8000472a:	8b2e                	mv	s6,a1
    8000472c:	89b2                	mv	s3,a2
    8000472e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004730:	fb040593          	addi	a1,s0,-80
    80004734:	88eff0ef          	jal	ra,800037c2 <nameiparent>
    80004738:	84aa                	mv	s1,a0
    8000473a:	10050c63          	beqz	a0,80004852 <create+0x13c>
    return 0;

  ilock(dp);
    8000473e:	9b9fe0ef          	jal	ra,800030f6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004742:	4601                	li	a2,0
    80004744:	fb040593          	addi	a1,s0,-80
    80004748:	8526                	mv	a0,s1
    8000474a:	df9fe0ef          	jal	ra,80003542 <dirlookup>
    8000474e:	8aaa                	mv	s5,a0
    80004750:	c521                	beqz	a0,80004798 <create+0x82>
    iunlockput(dp);
    80004752:	8526                	mv	a0,s1
    80004754:	ba9fe0ef          	jal	ra,800032fc <iunlockput>
    ilock(ip);
    80004758:	8556                	mv	a0,s5
    8000475a:	99dfe0ef          	jal	ra,800030f6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000475e:	000b059b          	sext.w	a1,s6
    80004762:	4789                	li	a5,2
    80004764:	02f59563          	bne	a1,a5,8000478e <create+0x78>
    80004768:	044ad783          	lhu	a5,68(s5)
    8000476c:	37f9                	addiw	a5,a5,-2
    8000476e:	17c2                	slli	a5,a5,0x30
    80004770:	93c1                	srli	a5,a5,0x30
    80004772:	4705                	li	a4,1
    80004774:	00f76d63          	bltu	a4,a5,8000478e <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004778:	8556                	mv	a0,s5
    8000477a:	60a6                	ld	ra,72(sp)
    8000477c:	6406                	ld	s0,64(sp)
    8000477e:	74e2                	ld	s1,56(sp)
    80004780:	7942                	ld	s2,48(sp)
    80004782:	79a2                	ld	s3,40(sp)
    80004784:	7a02                	ld	s4,32(sp)
    80004786:	6ae2                	ld	s5,24(sp)
    80004788:	6b42                	ld	s6,16(sp)
    8000478a:	6161                	addi	sp,sp,80
    8000478c:	8082                	ret
    iunlockput(ip);
    8000478e:	8556                	mv	a0,s5
    80004790:	b6dfe0ef          	jal	ra,800032fc <iunlockput>
    return 0;
    80004794:	4a81                	li	s5,0
    80004796:	b7cd                	j	80004778 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004798:	85da                	mv	a1,s6
    8000479a:	4088                	lw	a0,0(s1)
    8000479c:	ff2fe0ef          	jal	ra,80002f8e <ialloc>
    800047a0:	8a2a                	mv	s4,a0
    800047a2:	c121                	beqz	a0,800047e2 <create+0xcc>
  ilock(ip);
    800047a4:	953fe0ef          	jal	ra,800030f6 <ilock>
  ip->major = major;
    800047a8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047ac:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047b0:	4785                	li	a5,1
    800047b2:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800047b6:	8552                	mv	a0,s4
    800047b8:	88dfe0ef          	jal	ra,80003044 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047bc:	000b059b          	sext.w	a1,s6
    800047c0:	4785                	li	a5,1
    800047c2:	02f58563          	beq	a1,a5,800047ec <create+0xd6>
  if(dirlink(dp, name, ip->inum) < 0)
    800047c6:	004a2603          	lw	a2,4(s4)
    800047ca:	fb040593          	addi	a1,s0,-80
    800047ce:	8526                	mv	a0,s1
    800047d0:	f3ffe0ef          	jal	ra,8000370e <dirlink>
    800047d4:	06054363          	bltz	a0,8000483a <create+0x124>
  iunlockput(dp);
    800047d8:	8526                	mv	a0,s1
    800047da:	b23fe0ef          	jal	ra,800032fc <iunlockput>
  return ip;
    800047de:	8ad2                	mv	s5,s4
    800047e0:	bf61                	j	80004778 <create+0x62>
    iunlockput(dp);
    800047e2:	8526                	mv	a0,s1
    800047e4:	b19fe0ef          	jal	ra,800032fc <iunlockput>
    return 0;
    800047e8:	8ad2                	mv	s5,s4
    800047ea:	b779                	j	80004778 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ec:	004a2603          	lw	a2,4(s4)
    800047f0:	00003597          	auipc	a1,0x3
    800047f4:	f4058593          	addi	a1,a1,-192 # 80007730 <syscalls+0x2a0>
    800047f8:	8552                	mv	a0,s4
    800047fa:	f15fe0ef          	jal	ra,8000370e <dirlink>
    800047fe:	02054e63          	bltz	a0,8000483a <create+0x124>
    80004802:	40d0                	lw	a2,4(s1)
    80004804:	00003597          	auipc	a1,0x3
    80004808:	f3458593          	addi	a1,a1,-204 # 80007738 <syscalls+0x2a8>
    8000480c:	8552                	mv	a0,s4
    8000480e:	f01fe0ef          	jal	ra,8000370e <dirlink>
    80004812:	02054463          	bltz	a0,8000483a <create+0x124>
  if(dirlink(dp, name, ip->inum) < 0)
    80004816:	004a2603          	lw	a2,4(s4)
    8000481a:	fb040593          	addi	a1,s0,-80
    8000481e:	8526                	mv	a0,s1
    80004820:	eeffe0ef          	jal	ra,8000370e <dirlink>
    80004824:	00054b63          	bltz	a0,8000483a <create+0x124>
    dp->nlink++;  // for ".."
    80004828:	04a4d783          	lhu	a5,74(s1)
    8000482c:	2785                	addiw	a5,a5,1
    8000482e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004832:	8526                	mv	a0,s1
    80004834:	811fe0ef          	jal	ra,80003044 <iupdate>
    80004838:	b745                	j	800047d8 <create+0xc2>
  ip->nlink = 0;
    8000483a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000483e:	8552                	mv	a0,s4
    80004840:	805fe0ef          	jal	ra,80003044 <iupdate>
  iunlockput(ip);
    80004844:	8552                	mv	a0,s4
    80004846:	ab7fe0ef          	jal	ra,800032fc <iunlockput>
  iunlockput(dp);
    8000484a:	8526                	mv	a0,s1
    8000484c:	ab1fe0ef          	jal	ra,800032fc <iunlockput>
  return 0;
    80004850:	b725                	j	80004778 <create+0x62>
    return 0;
    80004852:	8aaa                	mv	s5,a0
    80004854:	b715                	j	80004778 <create+0x62>

0000000080004856 <sys_dup>:
{
    80004856:	7179                	addi	sp,sp,-48
    80004858:	f406                	sd	ra,40(sp)
    8000485a:	f022                	sd	s0,32(sp)
    8000485c:	ec26                	sd	s1,24(sp)
    8000485e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004860:	fd840613          	addi	a2,s0,-40
    80004864:	4581                	li	a1,0
    80004866:	4501                	li	a0,0
    80004868:	e19ff0ef          	jal	ra,80004680 <argfd>
    return -1;
    8000486c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000486e:	00054f63          	bltz	a0,8000488c <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80004872:	fd843503          	ld	a0,-40(s0)
    80004876:	e63ff0ef          	jal	ra,800046d8 <fdalloc>
    8000487a:	84aa                	mv	s1,a0
    return -1;
    8000487c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000487e:	00054763          	bltz	a0,8000488c <sys_dup+0x36>
  filedup(f);
    80004882:	fd843503          	ld	a0,-40(s0)
    80004886:	cd0ff0ef          	jal	ra,80003d56 <filedup>
  return fd;
    8000488a:	87a6                	mv	a5,s1
}
    8000488c:	853e                	mv	a0,a5
    8000488e:	70a2                	ld	ra,40(sp)
    80004890:	7402                	ld	s0,32(sp)
    80004892:	64e2                	ld	s1,24(sp)
    80004894:	6145                	addi	sp,sp,48
    80004896:	8082                	ret

0000000080004898 <sys_read>:
{
    80004898:	7179                	addi	sp,sp,-48
    8000489a:	f406                	sd	ra,40(sp)
    8000489c:	f022                	sd	s0,32(sp)
    8000489e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048a0:	fd840593          	addi	a1,s0,-40
    800048a4:	4505                	li	a0,1
    800048a6:	e5ffd0ef          	jal	ra,80002704 <argaddr>
  argint(2, &n);
    800048aa:	fe440593          	addi	a1,s0,-28
    800048ae:	4509                	li	a0,2
    800048b0:	e39fd0ef          	jal	ra,800026e8 <argint>
  if(argfd(0, 0, &f) < 0)
    800048b4:	fe840613          	addi	a2,s0,-24
    800048b8:	4581                	li	a1,0
    800048ba:	4501                	li	a0,0
    800048bc:	dc5ff0ef          	jal	ra,80004680 <argfd>
    800048c0:	87aa                	mv	a5,a0
    return -1;
    800048c2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c4:	0007ca63          	bltz	a5,800048d8 <sys_read+0x40>
  return fileread(f, p, n);
    800048c8:	fe442603          	lw	a2,-28(s0)
    800048cc:	fd843583          	ld	a1,-40(s0)
    800048d0:	fe843503          	ld	a0,-24(s0)
    800048d4:	dceff0ef          	jal	ra,80003ea2 <fileread>
}
    800048d8:	70a2                	ld	ra,40(sp)
    800048da:	7402                	ld	s0,32(sp)
    800048dc:	6145                	addi	sp,sp,48
    800048de:	8082                	ret

00000000800048e0 <sys_write>:
{
    800048e0:	7179                	addi	sp,sp,-48
    800048e2:	f406                	sd	ra,40(sp)
    800048e4:	f022                	sd	s0,32(sp)
    800048e6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048e8:	fd840593          	addi	a1,s0,-40
    800048ec:	4505                	li	a0,1
    800048ee:	e17fd0ef          	jal	ra,80002704 <argaddr>
  argint(2, &n);
    800048f2:	fe440593          	addi	a1,s0,-28
    800048f6:	4509                	li	a0,2
    800048f8:	df1fd0ef          	jal	ra,800026e8 <argint>
  if(argfd(0, 0, &f) < 0)
    800048fc:	fe840613          	addi	a2,s0,-24
    80004900:	4581                	li	a1,0
    80004902:	4501                	li	a0,0
    80004904:	d7dff0ef          	jal	ra,80004680 <argfd>
    80004908:	87aa                	mv	a5,a0
    return -1;
    8000490a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000490c:	0007ca63          	bltz	a5,80004920 <sys_write+0x40>
  return filewrite(f, p, n);
    80004910:	fe442603          	lw	a2,-28(s0)
    80004914:	fd843583          	ld	a1,-40(s0)
    80004918:	fe843503          	ld	a0,-24(s0)
    8000491c:	e34ff0ef          	jal	ra,80003f50 <filewrite>
}
    80004920:	70a2                	ld	ra,40(sp)
    80004922:	7402                	ld	s0,32(sp)
    80004924:	6145                	addi	sp,sp,48
    80004926:	8082                	ret

0000000080004928 <sys_close>:
{
    80004928:	1101                	addi	sp,sp,-32
    8000492a:	ec06                	sd	ra,24(sp)
    8000492c:	e822                	sd	s0,16(sp)
    8000492e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004930:	fe040613          	addi	a2,s0,-32
    80004934:	fec40593          	addi	a1,s0,-20
    80004938:	4501                	li	a0,0
    8000493a:	d47ff0ef          	jal	ra,80004680 <argfd>
    return -1;
    8000493e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004940:	02054063          	bltz	a0,80004960 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004944:	efdfc0ef          	jal	ra,80001840 <myproc>
    80004948:	fec42783          	lw	a5,-20(s0)
    8000494c:	07e9                	addi	a5,a5,26
    8000494e:	078e                	slli	a5,a5,0x3
    80004950:	97aa                	add	a5,a5,a0
    80004952:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004956:	fe043503          	ld	a0,-32(s0)
    8000495a:	c42ff0ef          	jal	ra,80003d9c <fileclose>
  return 0;
    8000495e:	4781                	li	a5,0
}
    80004960:	853e                	mv	a0,a5
    80004962:	60e2                	ld	ra,24(sp)
    80004964:	6442                	ld	s0,16(sp)
    80004966:	6105                	addi	sp,sp,32
    80004968:	8082                	ret

000000008000496a <sys_fstat>:
{
    8000496a:	1101                	addi	sp,sp,-32
    8000496c:	ec06                	sd	ra,24(sp)
    8000496e:	e822                	sd	s0,16(sp)
    80004970:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004972:	fe040593          	addi	a1,s0,-32
    80004976:	4505                	li	a0,1
    80004978:	d8dfd0ef          	jal	ra,80002704 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000497c:	fe840613          	addi	a2,s0,-24
    80004980:	4581                	li	a1,0
    80004982:	4501                	li	a0,0
    80004984:	cfdff0ef          	jal	ra,80004680 <argfd>
    80004988:	87aa                	mv	a5,a0
    return -1;
    8000498a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000498c:	0007c863          	bltz	a5,8000499c <sys_fstat+0x32>
  return filestat(f, st);
    80004990:	fe043583          	ld	a1,-32(s0)
    80004994:	fe843503          	ld	a0,-24(s0)
    80004998:	cacff0ef          	jal	ra,80003e44 <filestat>
}
    8000499c:	60e2                	ld	ra,24(sp)
    8000499e:	6442                	ld	s0,16(sp)
    800049a0:	6105                	addi	sp,sp,32
    800049a2:	8082                	ret

00000000800049a4 <sys_link>:
{
    800049a4:	7169                	addi	sp,sp,-304
    800049a6:	f606                	sd	ra,296(sp)
    800049a8:	f222                	sd	s0,288(sp)
    800049aa:	ee26                	sd	s1,280(sp)
    800049ac:	ea4a                	sd	s2,272(sp)
    800049ae:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b0:	08000613          	li	a2,128
    800049b4:	ed040593          	addi	a1,s0,-304
    800049b8:	4501                	li	a0,0
    800049ba:	d67fd0ef          	jal	ra,80002720 <argstr>
    return -1;
    800049be:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c0:	0c054663          	bltz	a0,80004a8c <sys_link+0xe8>
    800049c4:	08000613          	li	a2,128
    800049c8:	f5040593          	addi	a1,s0,-176
    800049cc:	4505                	li	a0,1
    800049ce:	d53fd0ef          	jal	ra,80002720 <argstr>
    return -1;
    800049d2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d4:	0a054c63          	bltz	a0,80004a8c <sys_link+0xe8>
  begin_op();
    800049d8:	fa9fe0ef          	jal	ra,80003980 <begin_op>
  if((ip = namei(old)) == 0){
    800049dc:	ed040513          	addi	a0,s0,-304
    800049e0:	dc9fe0ef          	jal	ra,800037a8 <namei>
    800049e4:	84aa                	mv	s1,a0
    800049e6:	c525                	beqz	a0,80004a4e <sys_link+0xaa>
  ilock(ip);
    800049e8:	f0efe0ef          	jal	ra,800030f6 <ilock>
  if(ip->type == T_DIR){
    800049ec:	04449703          	lh	a4,68(s1)
    800049f0:	4785                	li	a5,1
    800049f2:	06f70263          	beq	a4,a5,80004a56 <sys_link+0xb2>
  ip->nlink++;
    800049f6:	04a4d783          	lhu	a5,74(s1)
    800049fa:	2785                	addiw	a5,a5,1
    800049fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	e42fe0ef          	jal	ra,80003044 <iupdate>
  iunlock(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	f98fe0ef          	jal	ra,800031a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a0c:	fd040593          	addi	a1,s0,-48
    80004a10:	f5040513          	addi	a0,s0,-176
    80004a14:	daffe0ef          	jal	ra,800037c2 <nameiparent>
    80004a18:	892a                	mv	s2,a0
    80004a1a:	c921                	beqz	a0,80004a6a <sys_link+0xc6>
  ilock(dp);
    80004a1c:	edafe0ef          	jal	ra,800030f6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a20:	00092703          	lw	a4,0(s2)
    80004a24:	409c                	lw	a5,0(s1)
    80004a26:	02f71f63          	bne	a4,a5,80004a64 <sys_link+0xc0>
    80004a2a:	40d0                	lw	a2,4(s1)
    80004a2c:	fd040593          	addi	a1,s0,-48
    80004a30:	854a                	mv	a0,s2
    80004a32:	cddfe0ef          	jal	ra,8000370e <dirlink>
    80004a36:	02054763          	bltz	a0,80004a64 <sys_link+0xc0>
  iunlockput(dp);
    80004a3a:	854a                	mv	a0,s2
    80004a3c:	8c1fe0ef          	jal	ra,800032fc <iunlockput>
  iput(ip);
    80004a40:	8526                	mv	a0,s1
    80004a42:	833fe0ef          	jal	ra,80003274 <iput>
  end_op();
    80004a46:	fabfe0ef          	jal	ra,800039f0 <end_op>
  return 0;
    80004a4a:	4781                	li	a5,0
    80004a4c:	a081                	j	80004a8c <sys_link+0xe8>
    end_op();
    80004a4e:	fa3fe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004a52:	57fd                	li	a5,-1
    80004a54:	a825                	j	80004a8c <sys_link+0xe8>
    iunlockput(ip);
    80004a56:	8526                	mv	a0,s1
    80004a58:	8a5fe0ef          	jal	ra,800032fc <iunlockput>
    end_op();
    80004a5c:	f95fe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004a60:	57fd                	li	a5,-1
    80004a62:	a02d                	j	80004a8c <sys_link+0xe8>
    iunlockput(dp);
    80004a64:	854a                	mv	a0,s2
    80004a66:	897fe0ef          	jal	ra,800032fc <iunlockput>
  ilock(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	e8afe0ef          	jal	ra,800030f6 <ilock>
  ip->nlink--;
    80004a70:	04a4d783          	lhu	a5,74(s1)
    80004a74:	37fd                	addiw	a5,a5,-1
    80004a76:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	dc8fe0ef          	jal	ra,80003044 <iupdate>
  iunlockput(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	87bfe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    80004a86:	f6bfe0ef          	jal	ra,800039f0 <end_op>
  return -1;
    80004a8a:	57fd                	li	a5,-1
}
    80004a8c:	853e                	mv	a0,a5
    80004a8e:	70b2                	ld	ra,296(sp)
    80004a90:	7412                	ld	s0,288(sp)
    80004a92:	64f2                	ld	s1,280(sp)
    80004a94:	6952                	ld	s2,272(sp)
    80004a96:	6155                	addi	sp,sp,304
    80004a98:	8082                	ret

0000000080004a9a <sys_unlink>:
{
    80004a9a:	7151                	addi	sp,sp,-240
    80004a9c:	f586                	sd	ra,232(sp)
    80004a9e:	f1a2                	sd	s0,224(sp)
    80004aa0:	eda6                	sd	s1,216(sp)
    80004aa2:	e9ca                	sd	s2,208(sp)
    80004aa4:	e5ce                	sd	s3,200(sp)
    80004aa6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aa8:	08000613          	li	a2,128
    80004aac:	f3040593          	addi	a1,s0,-208
    80004ab0:	4501                	li	a0,0
    80004ab2:	c6ffd0ef          	jal	ra,80002720 <argstr>
    80004ab6:	12054b63          	bltz	a0,80004bec <sys_unlink+0x152>
  begin_op();
    80004aba:	ec7fe0ef          	jal	ra,80003980 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004abe:	fb040593          	addi	a1,s0,-80
    80004ac2:	f3040513          	addi	a0,s0,-208
    80004ac6:	cfdfe0ef          	jal	ra,800037c2 <nameiparent>
    80004aca:	84aa                	mv	s1,a0
    80004acc:	c54d                	beqz	a0,80004b76 <sys_unlink+0xdc>
  ilock(dp);
    80004ace:	e28fe0ef          	jal	ra,800030f6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad2:	00003597          	auipc	a1,0x3
    80004ad6:	c5e58593          	addi	a1,a1,-930 # 80007730 <syscalls+0x2a0>
    80004ada:	fb040513          	addi	a0,s0,-80
    80004ade:	a4ffe0ef          	jal	ra,8000352c <namecmp>
    80004ae2:	10050a63          	beqz	a0,80004bf6 <sys_unlink+0x15c>
    80004ae6:	00003597          	auipc	a1,0x3
    80004aea:	c5258593          	addi	a1,a1,-942 # 80007738 <syscalls+0x2a8>
    80004aee:	fb040513          	addi	a0,s0,-80
    80004af2:	a3bfe0ef          	jal	ra,8000352c <namecmp>
    80004af6:	10050063          	beqz	a0,80004bf6 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004afa:	f2c40613          	addi	a2,s0,-212
    80004afe:	fb040593          	addi	a1,s0,-80
    80004b02:	8526                	mv	a0,s1
    80004b04:	a3ffe0ef          	jal	ra,80003542 <dirlookup>
    80004b08:	892a                	mv	s2,a0
    80004b0a:	0e050663          	beqz	a0,80004bf6 <sys_unlink+0x15c>
  ilock(ip);
    80004b0e:	de8fe0ef          	jal	ra,800030f6 <ilock>
  if(ip->nlink < 1)
    80004b12:	04a91783          	lh	a5,74(s2)
    80004b16:	06f05463          	blez	a5,80004b7e <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b1a:	04491703          	lh	a4,68(s2)
    80004b1e:	4785                	li	a5,1
    80004b20:	06f70563          	beq	a4,a5,80004b8a <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004b24:	4641                	li	a2,16
    80004b26:	4581                	li	a1,0
    80004b28:	fc040513          	addi	a0,s0,-64
    80004b2c:	950fc0ef          	jal	ra,80000c7c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b30:	4741                	li	a4,16
    80004b32:	f2c42683          	lw	a3,-212(s0)
    80004b36:	fc040613          	addi	a2,s0,-64
    80004b3a:	4581                	li	a1,0
    80004b3c:	8526                	mv	a0,s1
    80004b3e:	8edfe0ef          	jal	ra,8000342a <writei>
    80004b42:	47c1                	li	a5,16
    80004b44:	08f51563          	bne	a0,a5,80004bce <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004b48:	04491703          	lh	a4,68(s2)
    80004b4c:	4785                	li	a5,1
    80004b4e:	08f70663          	beq	a4,a5,80004bda <sys_unlink+0x140>
  iunlockput(dp);
    80004b52:	8526                	mv	a0,s1
    80004b54:	fa8fe0ef          	jal	ra,800032fc <iunlockput>
  ip->nlink--;
    80004b58:	04a95783          	lhu	a5,74(s2)
    80004b5c:	37fd                	addiw	a5,a5,-1
    80004b5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b62:	854a                	mv	a0,s2
    80004b64:	ce0fe0ef          	jal	ra,80003044 <iupdate>
  iunlockput(ip);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	f92fe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    80004b6e:	e83fe0ef          	jal	ra,800039f0 <end_op>
  return 0;
    80004b72:	4501                	li	a0,0
    80004b74:	a079                	j	80004c02 <sys_unlink+0x168>
    end_op();
    80004b76:	e7bfe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004b7a:	557d                	li	a0,-1
    80004b7c:	a059                	j	80004c02 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004b7e:	00003517          	auipc	a0,0x3
    80004b82:	bc250513          	addi	a0,a0,-1086 # 80007740 <syscalls+0x2b0>
    80004b86:	bd7fb0ef          	jal	ra,8000075c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8a:	04c92703          	lw	a4,76(s2)
    80004b8e:	02000793          	li	a5,32
    80004b92:	f8e7f9e3          	bgeu	a5,a4,80004b24 <sys_unlink+0x8a>
    80004b96:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b9a:	4741                	li	a4,16
    80004b9c:	86ce                	mv	a3,s3
    80004b9e:	f1840613          	addi	a2,s0,-232
    80004ba2:	4581                	li	a1,0
    80004ba4:	854a                	mv	a0,s2
    80004ba6:	fa0fe0ef          	jal	ra,80003346 <readi>
    80004baa:	47c1                	li	a5,16
    80004bac:	00f51b63          	bne	a0,a5,80004bc2 <sys_unlink+0x128>
    if(de.inum != 0)
    80004bb0:	f1845783          	lhu	a5,-232(s0)
    80004bb4:	ef95                	bnez	a5,80004bf0 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb6:	29c1                	addiw	s3,s3,16
    80004bb8:	04c92783          	lw	a5,76(s2)
    80004bbc:	fcf9efe3          	bltu	s3,a5,80004b9a <sys_unlink+0x100>
    80004bc0:	b795                	j	80004b24 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004bc2:	00003517          	auipc	a0,0x3
    80004bc6:	b9650513          	addi	a0,a0,-1130 # 80007758 <syscalls+0x2c8>
    80004bca:	b93fb0ef          	jal	ra,8000075c <panic>
    panic("unlink: writei");
    80004bce:	00003517          	auipc	a0,0x3
    80004bd2:	ba250513          	addi	a0,a0,-1118 # 80007770 <syscalls+0x2e0>
    80004bd6:	b87fb0ef          	jal	ra,8000075c <panic>
    dp->nlink--;
    80004bda:	04a4d783          	lhu	a5,74(s1)
    80004bde:	37fd                	addiw	a5,a5,-1
    80004be0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004be4:	8526                	mv	a0,s1
    80004be6:	c5efe0ef          	jal	ra,80003044 <iupdate>
    80004bea:	b7a5                	j	80004b52 <sys_unlink+0xb8>
    return -1;
    80004bec:	557d                	li	a0,-1
    80004bee:	a811                	j	80004c02 <sys_unlink+0x168>
    iunlockput(ip);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	f0afe0ef          	jal	ra,800032fc <iunlockput>
  iunlockput(dp);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	f04fe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    80004bfc:	df5fe0ef          	jal	ra,800039f0 <end_op>
  return -1;
    80004c00:	557d                	li	a0,-1
}
    80004c02:	70ae                	ld	ra,232(sp)
    80004c04:	740e                	ld	s0,224(sp)
    80004c06:	64ee                	ld	s1,216(sp)
    80004c08:	694e                	ld	s2,208(sp)
    80004c0a:	69ae                	ld	s3,200(sp)
    80004c0c:	616d                	addi	sp,sp,240
    80004c0e:	8082                	ret

0000000080004c10 <sys_open>:

uint64
sys_open(void)
{
    80004c10:	7131                	addi	sp,sp,-192
    80004c12:	fd06                	sd	ra,184(sp)
    80004c14:	f922                	sd	s0,176(sp)
    80004c16:	f526                	sd	s1,168(sp)
    80004c18:	f14a                	sd	s2,160(sp)
    80004c1a:	ed4e                	sd	s3,152(sp)
    80004c1c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c1e:	f4c40593          	addi	a1,s0,-180
    80004c22:	4505                	li	a0,1
    80004c24:	ac5fd0ef          	jal	ra,800026e8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c28:	08000613          	li	a2,128
    80004c2c:	f5040593          	addi	a1,s0,-176
    80004c30:	4501                	li	a0,0
    80004c32:	aeffd0ef          	jal	ra,80002720 <argstr>
    80004c36:	87aa                	mv	a5,a0
    return -1;
    80004c38:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c3a:	0807cd63          	bltz	a5,80004cd4 <sys_open+0xc4>

  begin_op();
    80004c3e:	d43fe0ef          	jal	ra,80003980 <begin_op>

  if(omode & O_CREATE){
    80004c42:	f4c42783          	lw	a5,-180(s0)
    80004c46:	2007f793          	andi	a5,a5,512
    80004c4a:	c3c5                	beqz	a5,80004cea <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004c4c:	4681                	li	a3,0
    80004c4e:	4601                	li	a2,0
    80004c50:	4589                	li	a1,2
    80004c52:	f5040513          	addi	a0,s0,-176
    80004c56:	ac1ff0ef          	jal	ra,80004716 <create>
    80004c5a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c5c:	c159                	beqz	a0,80004ce2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c5e:	04449703          	lh	a4,68(s1)
    80004c62:	478d                	li	a5,3
    80004c64:	00f71763          	bne	a4,a5,80004c72 <sys_open+0x62>
    80004c68:	0464d703          	lhu	a4,70(s1)
    80004c6c:	47a5                	li	a5,9
    80004c6e:	0ae7e963          	bltu	a5,a4,80004d20 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c72:	886ff0ef          	jal	ra,80003cf8 <filealloc>
    80004c76:	89aa                	mv	s3,a0
    80004c78:	0c050963          	beqz	a0,80004d4a <sys_open+0x13a>
    80004c7c:	a5dff0ef          	jal	ra,800046d8 <fdalloc>
    80004c80:	892a                	mv	s2,a0
    80004c82:	0c054163          	bltz	a0,80004d44 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c86:	04449703          	lh	a4,68(s1)
    80004c8a:	478d                	li	a5,3
    80004c8c:	0af70163          	beq	a4,a5,80004d2e <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c90:	4789                	li	a5,2
    80004c92:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c96:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c9a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c9e:	f4c42783          	lw	a5,-180(s0)
    80004ca2:	0017c713          	xori	a4,a5,1
    80004ca6:	8b05                	andi	a4,a4,1
    80004ca8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cac:	0037f713          	andi	a4,a5,3
    80004cb0:	00e03733          	snez	a4,a4
    80004cb4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cb8:	4007f793          	andi	a5,a5,1024
    80004cbc:	c791                	beqz	a5,80004cc8 <sys_open+0xb8>
    80004cbe:	04449703          	lh	a4,68(s1)
    80004cc2:	4789                	li	a5,2
    80004cc4:	06f70c63          	beq	a4,a5,80004d3c <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	cd6fe0ef          	jal	ra,800031a0 <iunlock>
  end_op();
    80004cce:	d23fe0ef          	jal	ra,800039f0 <end_op>

  return fd;
    80004cd2:	854a                	mv	a0,s2
}
    80004cd4:	70ea                	ld	ra,184(sp)
    80004cd6:	744a                	ld	s0,176(sp)
    80004cd8:	74aa                	ld	s1,168(sp)
    80004cda:	790a                	ld	s2,160(sp)
    80004cdc:	69ea                	ld	s3,152(sp)
    80004cde:	6129                	addi	sp,sp,192
    80004ce0:	8082                	ret
      end_op();
    80004ce2:	d0ffe0ef          	jal	ra,800039f0 <end_op>
      return -1;
    80004ce6:	557d                	li	a0,-1
    80004ce8:	b7f5                	j	80004cd4 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004cea:	f5040513          	addi	a0,s0,-176
    80004cee:	abbfe0ef          	jal	ra,800037a8 <namei>
    80004cf2:	84aa                	mv	s1,a0
    80004cf4:	c115                	beqz	a0,80004d18 <sys_open+0x108>
    ilock(ip);
    80004cf6:	c00fe0ef          	jal	ra,800030f6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cfa:	04449703          	lh	a4,68(s1)
    80004cfe:	4785                	li	a5,1
    80004d00:	f4f71fe3          	bne	a4,a5,80004c5e <sys_open+0x4e>
    80004d04:	f4c42783          	lw	a5,-180(s0)
    80004d08:	d7ad                	beqz	a5,80004c72 <sys_open+0x62>
      iunlockput(ip);
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	df0fe0ef          	jal	ra,800032fc <iunlockput>
      end_op();
    80004d10:	ce1fe0ef          	jal	ra,800039f0 <end_op>
      return -1;
    80004d14:	557d                	li	a0,-1
    80004d16:	bf7d                	j	80004cd4 <sys_open+0xc4>
      end_op();
    80004d18:	cd9fe0ef          	jal	ra,800039f0 <end_op>
      return -1;
    80004d1c:	557d                	li	a0,-1
    80004d1e:	bf5d                	j	80004cd4 <sys_open+0xc4>
    iunlockput(ip);
    80004d20:	8526                	mv	a0,s1
    80004d22:	ddafe0ef          	jal	ra,800032fc <iunlockput>
    end_op();
    80004d26:	ccbfe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004d2a:	557d                	li	a0,-1
    80004d2c:	b765                	j	80004cd4 <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004d2e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d32:	04649783          	lh	a5,70(s1)
    80004d36:	02f99223          	sh	a5,36(s3)
    80004d3a:	b785                	j	80004c9a <sys_open+0x8a>
    itrunc(ip);
    80004d3c:	8526                	mv	a0,s1
    80004d3e:	ca2fe0ef          	jal	ra,800031e0 <itrunc>
    80004d42:	b759                	j	80004cc8 <sys_open+0xb8>
      fileclose(f);
    80004d44:	854e                	mv	a0,s3
    80004d46:	856ff0ef          	jal	ra,80003d9c <fileclose>
    iunlockput(ip);
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	db0fe0ef          	jal	ra,800032fc <iunlockput>
    end_op();
    80004d50:	ca1fe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	bfbd                	j	80004cd4 <sys_open+0xc4>

0000000080004d58 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d58:	7175                	addi	sp,sp,-144
    80004d5a:	e506                	sd	ra,136(sp)
    80004d5c:	e122                	sd	s0,128(sp)
    80004d5e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d60:	c21fe0ef          	jal	ra,80003980 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d64:	08000613          	li	a2,128
    80004d68:	f7040593          	addi	a1,s0,-144
    80004d6c:	4501                	li	a0,0
    80004d6e:	9b3fd0ef          	jal	ra,80002720 <argstr>
    80004d72:	02054363          	bltz	a0,80004d98 <sys_mkdir+0x40>
    80004d76:	4681                	li	a3,0
    80004d78:	4601                	li	a2,0
    80004d7a:	4585                	li	a1,1
    80004d7c:	f7040513          	addi	a0,s0,-144
    80004d80:	997ff0ef          	jal	ra,80004716 <create>
    80004d84:	c911                	beqz	a0,80004d98 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d86:	d76fe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    80004d8a:	c67fe0ef          	jal	ra,800039f0 <end_op>
  return 0;
    80004d8e:	4501                	li	a0,0
}
    80004d90:	60aa                	ld	ra,136(sp)
    80004d92:	640a                	ld	s0,128(sp)
    80004d94:	6149                	addi	sp,sp,144
    80004d96:	8082                	ret
    end_op();
    80004d98:	c59fe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004d9c:	557d                	li	a0,-1
    80004d9e:	bfcd                	j	80004d90 <sys_mkdir+0x38>

0000000080004da0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004da0:	7135                	addi	sp,sp,-160
    80004da2:	ed06                	sd	ra,152(sp)
    80004da4:	e922                	sd	s0,144(sp)
    80004da6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004da8:	bd9fe0ef          	jal	ra,80003980 <begin_op>
  argint(1, &major);
    80004dac:	f6c40593          	addi	a1,s0,-148
    80004db0:	4505                	li	a0,1
    80004db2:	937fd0ef          	jal	ra,800026e8 <argint>
  argint(2, &minor);
    80004db6:	f6840593          	addi	a1,s0,-152
    80004dba:	4509                	li	a0,2
    80004dbc:	92dfd0ef          	jal	ra,800026e8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dc0:	08000613          	li	a2,128
    80004dc4:	f7040593          	addi	a1,s0,-144
    80004dc8:	4501                	li	a0,0
    80004dca:	957fd0ef          	jal	ra,80002720 <argstr>
    80004dce:	02054563          	bltz	a0,80004df8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dd2:	f6841683          	lh	a3,-152(s0)
    80004dd6:	f6c41603          	lh	a2,-148(s0)
    80004dda:	458d                	li	a1,3
    80004ddc:	f7040513          	addi	a0,s0,-144
    80004de0:	937ff0ef          	jal	ra,80004716 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004de4:	c911                	beqz	a0,80004df8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de6:	d16fe0ef          	jal	ra,800032fc <iunlockput>
  end_op();
    80004dea:	c07fe0ef          	jal	ra,800039f0 <end_op>
  return 0;
    80004dee:	4501                	li	a0,0
}
    80004df0:	60ea                	ld	ra,152(sp)
    80004df2:	644a                	ld	s0,144(sp)
    80004df4:	610d                	addi	sp,sp,160
    80004df6:	8082                	ret
    end_op();
    80004df8:	bf9fe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	bfcd                	j	80004df0 <sys_mknod+0x50>

0000000080004e00 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e00:	7135                	addi	sp,sp,-160
    80004e02:	ed06                	sd	ra,152(sp)
    80004e04:	e922                	sd	s0,144(sp)
    80004e06:	e526                	sd	s1,136(sp)
    80004e08:	e14a                	sd	s2,128(sp)
    80004e0a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e0c:	a35fc0ef          	jal	ra,80001840 <myproc>
    80004e10:	892a                	mv	s2,a0
  
  begin_op();
    80004e12:	b6ffe0ef          	jal	ra,80003980 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e16:	08000613          	li	a2,128
    80004e1a:	f6040593          	addi	a1,s0,-160
    80004e1e:	4501                	li	a0,0
    80004e20:	901fd0ef          	jal	ra,80002720 <argstr>
    80004e24:	04054163          	bltz	a0,80004e66 <sys_chdir+0x66>
    80004e28:	f6040513          	addi	a0,s0,-160
    80004e2c:	97dfe0ef          	jal	ra,800037a8 <namei>
    80004e30:	84aa                	mv	s1,a0
    80004e32:	c915                	beqz	a0,80004e66 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e34:	ac2fe0ef          	jal	ra,800030f6 <ilock>
  if(ip->type != T_DIR){
    80004e38:	04449703          	lh	a4,68(s1)
    80004e3c:	4785                	li	a5,1
    80004e3e:	02f71863          	bne	a4,a5,80004e6e <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e42:	8526                	mv	a0,s1
    80004e44:	b5cfe0ef          	jal	ra,800031a0 <iunlock>
  iput(p->cwd);
    80004e48:	15093503          	ld	a0,336(s2)
    80004e4c:	c28fe0ef          	jal	ra,80003274 <iput>
  end_op();
    80004e50:	ba1fe0ef          	jal	ra,800039f0 <end_op>
  p->cwd = ip;
    80004e54:	14993823          	sd	s1,336(s2)
  return 0;
    80004e58:	4501                	li	a0,0
}
    80004e5a:	60ea                	ld	ra,152(sp)
    80004e5c:	644a                	ld	s0,144(sp)
    80004e5e:	64aa                	ld	s1,136(sp)
    80004e60:	690a                	ld	s2,128(sp)
    80004e62:	610d                	addi	sp,sp,160
    80004e64:	8082                	ret
    end_op();
    80004e66:	b8bfe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004e6a:	557d                	li	a0,-1
    80004e6c:	b7fd                	j	80004e5a <sys_chdir+0x5a>
    iunlockput(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	c8cfe0ef          	jal	ra,800032fc <iunlockput>
    end_op();
    80004e74:	b7dfe0ef          	jal	ra,800039f0 <end_op>
    return -1;
    80004e78:	557d                	li	a0,-1
    80004e7a:	b7c5                	j	80004e5a <sys_chdir+0x5a>

0000000080004e7c <sys_exec>:

uint64
sys_exec(void)
{
    80004e7c:	7145                	addi	sp,sp,-464
    80004e7e:	e786                	sd	ra,456(sp)
    80004e80:	e3a2                	sd	s0,448(sp)
    80004e82:	ff26                	sd	s1,440(sp)
    80004e84:	fb4a                	sd	s2,432(sp)
    80004e86:	f74e                	sd	s3,424(sp)
    80004e88:	f352                	sd	s4,416(sp)
    80004e8a:	ef56                	sd	s5,408(sp)
    80004e8c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e8e:	e3840593          	addi	a1,s0,-456
    80004e92:	4505                	li	a0,1
    80004e94:	871fd0ef          	jal	ra,80002704 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e98:	08000613          	li	a2,128
    80004e9c:	f4040593          	addi	a1,s0,-192
    80004ea0:	4501                	li	a0,0
    80004ea2:	87ffd0ef          	jal	ra,80002720 <argstr>
    80004ea6:	87aa                	mv	a5,a0
    return -1;
    80004ea8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eaa:	0a07c463          	bltz	a5,80004f52 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80004eae:	10000613          	li	a2,256
    80004eb2:	4581                	li	a1,0
    80004eb4:	e4040513          	addi	a0,s0,-448
    80004eb8:	dc5fb0ef          	jal	ra,80000c7c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ebc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ec0:	89a6                	mv	s3,s1
    80004ec2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ec4:	02000a13          	li	s4,32
    80004ec8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ecc:	00391513          	slli	a0,s2,0x3
    80004ed0:	e3040593          	addi	a1,s0,-464
    80004ed4:	e3843783          	ld	a5,-456(s0)
    80004ed8:	953e                	add	a0,a0,a5
    80004eda:	f84fd0ef          	jal	ra,8000265e <fetchaddr>
    80004ede:	02054663          	bltz	a0,80004f0a <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004ee2:	e3043783          	ld	a5,-464(s0)
    80004ee6:	cf8d                	beqz	a5,80004f20 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ee8:	bf1fb0ef          	jal	ra,80000ad8 <kalloc>
    80004eec:	85aa                	mv	a1,a0
    80004eee:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef2:	cd01                	beqz	a0,80004f0a <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ef4:	6605                	lui	a2,0x1
    80004ef6:	e3043503          	ld	a0,-464(s0)
    80004efa:	faefd0ef          	jal	ra,800026a8 <fetchstr>
    80004efe:	00054663          	bltz	a0,80004f0a <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004f02:	0905                	addi	s2,s2,1
    80004f04:	09a1                	addi	s3,s3,8
    80004f06:	fd4911e3          	bne	s2,s4,80004ec8 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0a:	10048913          	addi	s2,s1,256
    80004f0e:	6088                	ld	a0,0(s1)
    80004f10:	c121                	beqz	a0,80004f50 <sys_exec+0xd4>
    kfree(argv[i]);
    80004f12:	ae7fb0ef          	jal	ra,800009f8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f16:	04a1                	addi	s1,s1,8
    80004f18:	ff249be3          	bne	s1,s2,80004f0e <sys_exec+0x92>
  return -1;
    80004f1c:	557d                	li	a0,-1
    80004f1e:	a815                	j	80004f52 <sys_exec+0xd6>
      argv[i] = 0;
    80004f20:	0a8e                	slli	s5,s5,0x3
    80004f22:	fc040793          	addi	a5,s0,-64
    80004f26:	9abe                	add	s5,s5,a5
    80004f28:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f2c:	e4040593          	addi	a1,s0,-448
    80004f30:	f4040513          	addi	a0,s0,-192
    80004f34:	c18ff0ef          	jal	ra,8000434c <exec>
    80004f38:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3a:	10048993          	addi	s3,s1,256
    80004f3e:	6088                	ld	a0,0(s1)
    80004f40:	c511                	beqz	a0,80004f4c <sys_exec+0xd0>
    kfree(argv[i]);
    80004f42:	ab7fb0ef          	jal	ra,800009f8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f46:	04a1                	addi	s1,s1,8
    80004f48:	ff349be3          	bne	s1,s3,80004f3e <sys_exec+0xc2>
  return ret;
    80004f4c:	854a                	mv	a0,s2
    80004f4e:	a011                	j	80004f52 <sys_exec+0xd6>
  return -1;
    80004f50:	557d                	li	a0,-1
}
    80004f52:	60be                	ld	ra,456(sp)
    80004f54:	641e                	ld	s0,448(sp)
    80004f56:	74fa                	ld	s1,440(sp)
    80004f58:	795a                	ld	s2,432(sp)
    80004f5a:	79ba                	ld	s3,424(sp)
    80004f5c:	7a1a                	ld	s4,416(sp)
    80004f5e:	6afa                	ld	s5,408(sp)
    80004f60:	6179                	addi	sp,sp,464
    80004f62:	8082                	ret

0000000080004f64 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f64:	7139                	addi	sp,sp,-64
    80004f66:	fc06                	sd	ra,56(sp)
    80004f68:	f822                	sd	s0,48(sp)
    80004f6a:	f426                	sd	s1,40(sp)
    80004f6c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f6e:	8d3fc0ef          	jal	ra,80001840 <myproc>
    80004f72:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f74:	fd840593          	addi	a1,s0,-40
    80004f78:	4501                	li	a0,0
    80004f7a:	f8afd0ef          	jal	ra,80002704 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f7e:	fc840593          	addi	a1,s0,-56
    80004f82:	fd040513          	addi	a0,s0,-48
    80004f86:	8e2ff0ef          	jal	ra,80004068 <pipealloc>
    return -1;
    80004f8a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f8c:	0a054463          	bltz	a0,80005034 <sys_pipe+0xd0>
  fd0 = -1;
    80004f90:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f94:	fd043503          	ld	a0,-48(s0)
    80004f98:	f40ff0ef          	jal	ra,800046d8 <fdalloc>
    80004f9c:	fca42223          	sw	a0,-60(s0)
    80004fa0:	08054163          	bltz	a0,80005022 <sys_pipe+0xbe>
    80004fa4:	fc843503          	ld	a0,-56(s0)
    80004fa8:	f30ff0ef          	jal	ra,800046d8 <fdalloc>
    80004fac:	fca42023          	sw	a0,-64(s0)
    80004fb0:	06054063          	bltz	a0,80005010 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb4:	4691                	li	a3,4
    80004fb6:	fc440613          	addi	a2,s0,-60
    80004fba:	fd843583          	ld	a1,-40(s0)
    80004fbe:	68a8                	ld	a0,80(s1)
    80004fc0:	d36fc0ef          	jal	ra,800014f6 <copyout>
    80004fc4:	00054e63          	bltz	a0,80004fe0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fc8:	4691                	li	a3,4
    80004fca:	fc040613          	addi	a2,s0,-64
    80004fce:	fd843583          	ld	a1,-40(s0)
    80004fd2:	0591                	addi	a1,a1,4
    80004fd4:	68a8                	ld	a0,80(s1)
    80004fd6:	d20fc0ef          	jal	ra,800014f6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fda:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fdc:	04055c63          	bgez	a0,80005034 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004fe0:	fc442783          	lw	a5,-60(s0)
    80004fe4:	07e9                	addi	a5,a5,26
    80004fe6:	078e                	slli	a5,a5,0x3
    80004fe8:	97a6                	add	a5,a5,s1
    80004fea:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fee:	fc042503          	lw	a0,-64(s0)
    80004ff2:	0569                	addi	a0,a0,26
    80004ff4:	050e                	slli	a0,a0,0x3
    80004ff6:	94aa                	add	s1,s1,a0
    80004ff8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004ffc:	fd043503          	ld	a0,-48(s0)
    80005000:	d9dfe0ef          	jal	ra,80003d9c <fileclose>
    fileclose(wf);
    80005004:	fc843503          	ld	a0,-56(s0)
    80005008:	d95fe0ef          	jal	ra,80003d9c <fileclose>
    return -1;
    8000500c:	57fd                	li	a5,-1
    8000500e:	a01d                	j	80005034 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005010:	fc442783          	lw	a5,-60(s0)
    80005014:	0007c763          	bltz	a5,80005022 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005018:	07e9                	addi	a5,a5,26
    8000501a:	078e                	slli	a5,a5,0x3
    8000501c:	94be                	add	s1,s1,a5
    8000501e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005022:	fd043503          	ld	a0,-48(s0)
    80005026:	d77fe0ef          	jal	ra,80003d9c <fileclose>
    fileclose(wf);
    8000502a:	fc843503          	ld	a0,-56(s0)
    8000502e:	d6ffe0ef          	jal	ra,80003d9c <fileclose>
    return -1;
    80005032:	57fd                	li	a5,-1
}
    80005034:	853e                	mv	a0,a5
    80005036:	70e2                	ld	ra,56(sp)
    80005038:	7442                	ld	s0,48(sp)
    8000503a:	74a2                	ld	s1,40(sp)
    8000503c:	6121                	addi	sp,sp,64
    8000503e:	8082                	ret

0000000080005040 <kernelvec>:
    80005040:	7111                	addi	sp,sp,-256
    80005042:	e006                	sd	ra,0(sp)
    80005044:	e40a                	sd	sp,8(sp)
    80005046:	e80e                	sd	gp,16(sp)
    80005048:	ec12                	sd	tp,24(sp)
    8000504a:	f016                	sd	t0,32(sp)
    8000504c:	f41a                	sd	t1,40(sp)
    8000504e:	f81e                	sd	t2,48(sp)
    80005050:	e4aa                	sd	a0,72(sp)
    80005052:	e8ae                	sd	a1,80(sp)
    80005054:	ecb2                	sd	a2,88(sp)
    80005056:	f0b6                	sd	a3,96(sp)
    80005058:	f4ba                	sd	a4,104(sp)
    8000505a:	f8be                	sd	a5,112(sp)
    8000505c:	fcc2                	sd	a6,120(sp)
    8000505e:	e146                	sd	a7,128(sp)
    80005060:	edf2                	sd	t3,216(sp)
    80005062:	f1f6                	sd	t4,224(sp)
    80005064:	f5fa                	sd	t5,232(sp)
    80005066:	f9fe                	sd	t6,240(sp)
    80005068:	d06fd0ef          	jal	ra,8000256e <kerneltrap>
    8000506c:	6082                	ld	ra,0(sp)
    8000506e:	6122                	ld	sp,8(sp)
    80005070:	61c2                	ld	gp,16(sp)
    80005072:	7282                	ld	t0,32(sp)
    80005074:	7322                	ld	t1,40(sp)
    80005076:	73c2                	ld	t2,48(sp)
    80005078:	6526                	ld	a0,72(sp)
    8000507a:	65c6                	ld	a1,80(sp)
    8000507c:	6666                	ld	a2,88(sp)
    8000507e:	7686                	ld	a3,96(sp)
    80005080:	7726                	ld	a4,104(sp)
    80005082:	77c6                	ld	a5,112(sp)
    80005084:	7866                	ld	a6,120(sp)
    80005086:	688a                	ld	a7,128(sp)
    80005088:	6e6e                	ld	t3,216(sp)
    8000508a:	7e8e                	ld	t4,224(sp)
    8000508c:	7f2e                	ld	t5,232(sp)
    8000508e:	7fce                	ld	t6,240(sp)
    80005090:	6111                	addi	sp,sp,256
    80005092:	10200073          	sret
	...

000000008000509e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000509e:	1141                	addi	sp,sp,-16
    800050a0:	e422                	sd	s0,8(sp)
    800050a2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050a4:	0c0007b7          	lui	a5,0xc000
    800050a8:	4705                	li	a4,1
    800050aa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050ac:	c3d8                	sw	a4,4(a5)
}
    800050ae:	6422                	ld	s0,8(sp)
    800050b0:	0141                	addi	sp,sp,16
    800050b2:	8082                	ret

00000000800050b4 <plicinithart>:

void
plicinithart(void)
{
    800050b4:	1141                	addi	sp,sp,-16
    800050b6:	e406                	sd	ra,8(sp)
    800050b8:	e022                	sd	s0,0(sp)
    800050ba:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050bc:	f58fc0ef          	jal	ra,80001814 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050c0:	0085171b          	slliw	a4,a0,0x8
    800050c4:	0c0027b7          	lui	a5,0xc002
    800050c8:	97ba                	add	a5,a5,a4
    800050ca:	40200713          	li	a4,1026
    800050ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050d2:	00d5151b          	slliw	a0,a0,0xd
    800050d6:	0c2017b7          	lui	a5,0xc201
    800050da:	953e                	add	a0,a0,a5
    800050dc:	00052023          	sw	zero,0(a0)
}
    800050e0:	60a2                	ld	ra,8(sp)
    800050e2:	6402                	ld	s0,0(sp)
    800050e4:	0141                	addi	sp,sp,16
    800050e6:	8082                	ret

00000000800050e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050e8:	1141                	addi	sp,sp,-16
    800050ea:	e406                	sd	ra,8(sp)
    800050ec:	e022                	sd	s0,0(sp)
    800050ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050f0:	f24fc0ef          	jal	ra,80001814 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050f4:	00d5179b          	slliw	a5,a0,0xd
    800050f8:	0c201537          	lui	a0,0xc201
    800050fc:	953e                	add	a0,a0,a5
  return irq;
}
    800050fe:	4148                	lw	a0,4(a0)
    80005100:	60a2                	ld	ra,8(sp)
    80005102:	6402                	ld	s0,0(sp)
    80005104:	0141                	addi	sp,sp,16
    80005106:	8082                	ret

0000000080005108 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005108:	1101                	addi	sp,sp,-32
    8000510a:	ec06                	sd	ra,24(sp)
    8000510c:	e822                	sd	s0,16(sp)
    8000510e:	e426                	sd	s1,8(sp)
    80005110:	1000                	addi	s0,sp,32
    80005112:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005114:	f00fc0ef          	jal	ra,80001814 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005118:	00d5151b          	slliw	a0,a0,0xd
    8000511c:	0c2017b7          	lui	a5,0xc201
    80005120:	97aa                	add	a5,a5,a0
    80005122:	c3c4                	sw	s1,4(a5)
}
    80005124:	60e2                	ld	ra,24(sp)
    80005126:	6442                	ld	s0,16(sp)
    80005128:	64a2                	ld	s1,8(sp)
    8000512a:	6105                	addi	sp,sp,32
    8000512c:	8082                	ret

000000008000512e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000512e:	1141                	addi	sp,sp,-16
    80005130:	e406                	sd	ra,8(sp)
    80005132:	e022                	sd	s0,0(sp)
    80005134:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005136:	479d                	li	a5,7
    80005138:	04a7ca63          	blt	a5,a0,8000518c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000513c:	0001c797          	auipc	a5,0x1c
    80005140:	9e478793          	addi	a5,a5,-1564 # 80020b20 <disk>
    80005144:	97aa                	add	a5,a5,a0
    80005146:	0187c783          	lbu	a5,24(a5)
    8000514a:	e7b9                	bnez	a5,80005198 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000514c:	00451613          	slli	a2,a0,0x4
    80005150:	0001c797          	auipc	a5,0x1c
    80005154:	9d078793          	addi	a5,a5,-1584 # 80020b20 <disk>
    80005158:	6394                	ld	a3,0(a5)
    8000515a:	96b2                	add	a3,a3,a2
    8000515c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005160:	6398                	ld	a4,0(a5)
    80005162:	9732                	add	a4,a4,a2
    80005164:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005168:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000516c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005170:	953e                	add	a0,a0,a5
    80005172:	4785                	li	a5,1
    80005174:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005178:	0001c517          	auipc	a0,0x1c
    8000517c:	9c050513          	addi	a0,a0,-1600 # 80020b38 <disk+0x18>
    80005180:	cd5fc0ef          	jal	ra,80001e54 <wakeup>
}
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret
    panic("free_desc 1");
    8000518c:	00002517          	auipc	a0,0x2
    80005190:	5f450513          	addi	a0,a0,1524 # 80007780 <syscalls+0x2f0>
    80005194:	dc8fb0ef          	jal	ra,8000075c <panic>
    panic("free_desc 2");
    80005198:	00002517          	auipc	a0,0x2
    8000519c:	5f850513          	addi	a0,a0,1528 # 80007790 <syscalls+0x300>
    800051a0:	dbcfb0ef          	jal	ra,8000075c <panic>

00000000800051a4 <virtio_disk_init>:
{
    800051a4:	1101                	addi	sp,sp,-32
    800051a6:	ec06                	sd	ra,24(sp)
    800051a8:	e822                	sd	s0,16(sp)
    800051aa:	e426                	sd	s1,8(sp)
    800051ac:	e04a                	sd	s2,0(sp)
    800051ae:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051b0:	00002597          	auipc	a1,0x2
    800051b4:	5f058593          	addi	a1,a1,1520 # 800077a0 <syscalls+0x310>
    800051b8:	0001c517          	auipc	a0,0x1c
    800051bc:	a9050513          	addi	a0,a0,-1392 # 80020c48 <disk+0x128>
    800051c0:	969fb0ef          	jal	ra,80000b28 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c4:	100017b7          	lui	a5,0x10001
    800051c8:	4398                	lw	a4,0(a5)
    800051ca:	2701                	sext.w	a4,a4
    800051cc:	747277b7          	lui	a5,0x74727
    800051d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051d4:	14f71263          	bne	a4,a5,80005318 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d8:	100017b7          	lui	a5,0x10001
    800051dc:	43dc                	lw	a5,4(a5)
    800051de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051e0:	4709                	li	a4,2
    800051e2:	12e79b63          	bne	a5,a4,80005318 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e6:	100017b7          	lui	a5,0x10001
    800051ea:	479c                	lw	a5,8(a5)
    800051ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051ee:	12e79563          	bne	a5,a4,80005318 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051f2:	100017b7          	lui	a5,0x10001
    800051f6:	47d8                	lw	a4,12(a5)
    800051f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051fa:	554d47b7          	lui	a5,0x554d4
    800051fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005202:	10f71b63          	bne	a4,a5,80005318 <virtio_disk_init+0x174>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005206:	100017b7          	lui	a5,0x10001
    8000520a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	4705                	li	a4,1
    80005210:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005212:	470d                	li	a4,3
    80005214:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005216:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005218:	c7ffe737          	lui	a4,0xc7ffe
    8000521c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddaff>
    80005220:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005222:	2701                	sext.w	a4,a4
    80005224:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005226:	472d                	li	a4,11
    80005228:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000522a:	0707a903          	lw	s2,112(a5)
    8000522e:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005230:	00897793          	andi	a5,s2,8
    80005234:	0e078863          	beqz	a5,80005324 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005238:	100017b7          	lui	a5,0x10001
    8000523c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005240:	43fc                	lw	a5,68(a5)
    80005242:	2781                	sext.w	a5,a5
    80005244:	0e079663          	bnez	a5,80005330 <virtio_disk_init+0x18c>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005248:	100017b7          	lui	a5,0x10001
    8000524c:	5bdc                	lw	a5,52(a5)
    8000524e:	2781                	sext.w	a5,a5
  if(max == 0)
    80005250:	0e078663          	beqz	a5,8000533c <virtio_disk_init+0x198>
  if(max < NUM)
    80005254:	471d                	li	a4,7
    80005256:	0ef77963          	bgeu	a4,a5,80005348 <virtio_disk_init+0x1a4>
  disk.desc = kalloc();
    8000525a:	87ffb0ef          	jal	ra,80000ad8 <kalloc>
    8000525e:	0001c497          	auipc	s1,0x1c
    80005262:	8c248493          	addi	s1,s1,-1854 # 80020b20 <disk>
    80005266:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005268:	871fb0ef          	jal	ra,80000ad8 <kalloc>
    8000526c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000526e:	86bfb0ef          	jal	ra,80000ad8 <kalloc>
    80005272:	87aa                	mv	a5,a0
    80005274:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005276:	6088                	ld	a0,0(s1)
    80005278:	cd71                	beqz	a0,80005354 <virtio_disk_init+0x1b0>
    8000527a:	0001c717          	auipc	a4,0x1c
    8000527e:	8ae73703          	ld	a4,-1874(a4) # 80020b28 <disk+0x8>
    80005282:	cb69                	beqz	a4,80005354 <virtio_disk_init+0x1b0>
    80005284:	cbe1                	beqz	a5,80005354 <virtio_disk_init+0x1b0>
  memset(disk.desc, 0, PGSIZE);
    80005286:	6605                	lui	a2,0x1
    80005288:	4581                	li	a1,0
    8000528a:	9f3fb0ef          	jal	ra,80000c7c <memset>
  memset(disk.avail, 0, PGSIZE);
    8000528e:	0001c497          	auipc	s1,0x1c
    80005292:	89248493          	addi	s1,s1,-1902 # 80020b20 <disk>
    80005296:	6605                	lui	a2,0x1
    80005298:	4581                	li	a1,0
    8000529a:	6488                	ld	a0,8(s1)
    8000529c:	9e1fb0ef          	jal	ra,80000c7c <memset>
  memset(disk.used, 0, PGSIZE);
    800052a0:	6605                	lui	a2,0x1
    800052a2:	4581                	li	a1,0
    800052a4:	6888                	ld	a0,16(s1)
    800052a6:	9d7fb0ef          	jal	ra,80000c7c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052aa:	100017b7          	lui	a5,0x10001
    800052ae:	4721                	li	a4,8
    800052b0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052b2:	4098                	lw	a4,0(s1)
    800052b4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052b8:	40d8                	lw	a4,4(s1)
    800052ba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052be:	6498                	ld	a4,8(s1)
    800052c0:	0007069b          	sext.w	a3,a4
    800052c4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052c8:	9701                	srai	a4,a4,0x20
    800052ca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ce:	6898                	ld	a4,16(s1)
    800052d0:	0007069b          	sext.w	a3,a4
    800052d4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052d8:	9701                	srai	a4,a4,0x20
    800052da:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052de:	4685                	li	a3,1
    800052e0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800052e2:	4705                	li	a4,1
    800052e4:	00d48c23          	sb	a3,24(s1)
    800052e8:	00e48ca3          	sb	a4,25(s1)
    800052ec:	00e48d23          	sb	a4,26(s1)
    800052f0:	00e48da3          	sb	a4,27(s1)
    800052f4:	00e48e23          	sb	a4,28(s1)
    800052f8:	00e48ea3          	sb	a4,29(s1)
    800052fc:	00e48f23          	sb	a4,30(s1)
    80005300:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005304:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	0727a823          	sw	s2,112(a5)
}
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	64a2                	ld	s1,8(sp)
    80005312:	6902                	ld	s2,0(sp)
    80005314:	6105                	addi	sp,sp,32
    80005316:	8082                	ret
    panic("could not find virtio disk");
    80005318:	00002517          	auipc	a0,0x2
    8000531c:	49850513          	addi	a0,a0,1176 # 800077b0 <syscalls+0x320>
    80005320:	c3cfb0ef          	jal	ra,8000075c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005324:	00002517          	auipc	a0,0x2
    80005328:	4ac50513          	addi	a0,a0,1196 # 800077d0 <syscalls+0x340>
    8000532c:	c30fb0ef          	jal	ra,8000075c <panic>
    panic("virtio disk should not be ready");
    80005330:	00002517          	auipc	a0,0x2
    80005334:	4c050513          	addi	a0,a0,1216 # 800077f0 <syscalls+0x360>
    80005338:	c24fb0ef          	jal	ra,8000075c <panic>
    panic("virtio disk has no queue 0");
    8000533c:	00002517          	auipc	a0,0x2
    80005340:	4d450513          	addi	a0,a0,1236 # 80007810 <syscalls+0x380>
    80005344:	c18fb0ef          	jal	ra,8000075c <panic>
    panic("virtio disk max queue too short");
    80005348:	00002517          	auipc	a0,0x2
    8000534c:	4e850513          	addi	a0,a0,1256 # 80007830 <syscalls+0x3a0>
    80005350:	c0cfb0ef          	jal	ra,8000075c <panic>
    panic("virtio disk kalloc");
    80005354:	00002517          	auipc	a0,0x2
    80005358:	4fc50513          	addi	a0,a0,1276 # 80007850 <syscalls+0x3c0>
    8000535c:	c00fb0ef          	jal	ra,8000075c <panic>

0000000080005360 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005360:	7159                	addi	sp,sp,-112
    80005362:	f486                	sd	ra,104(sp)
    80005364:	f0a2                	sd	s0,96(sp)
    80005366:	eca6                	sd	s1,88(sp)
    80005368:	e8ca                	sd	s2,80(sp)
    8000536a:	e4ce                	sd	s3,72(sp)
    8000536c:	e0d2                	sd	s4,64(sp)
    8000536e:	fc56                	sd	s5,56(sp)
    80005370:	f85a                	sd	s6,48(sp)
    80005372:	f45e                	sd	s7,40(sp)
    80005374:	f062                	sd	s8,32(sp)
    80005376:	ec66                	sd	s9,24(sp)
    80005378:	e86a                	sd	s10,16(sp)
    8000537a:	1880                	addi	s0,sp,112
    8000537c:	892a                	mv	s2,a0
    8000537e:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005380:	00c52c83          	lw	s9,12(a0)
    80005384:	001c9c9b          	slliw	s9,s9,0x1
    80005388:	1c82                	slli	s9,s9,0x20
    8000538a:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000538e:	0001c517          	auipc	a0,0x1c
    80005392:	8ba50513          	addi	a0,a0,-1862 # 80020c48 <disk+0x128>
    80005396:	813fb0ef          	jal	ra,80000ba8 <acquire>
  for(int i = 0; i < 3; i++){
    8000539a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000539c:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000539e:	0001bb17          	auipc	s6,0x1b
    800053a2:	782b0b13          	addi	s6,s6,1922 # 80020b20 <disk>
  for(int i = 0; i < 3; i++){
    800053a6:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053a8:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053aa:	0001cc17          	auipc	s8,0x1c
    800053ae:	89ec0c13          	addi	s8,s8,-1890 # 80020c48 <disk+0x128>
    800053b2:	a0b5                	j	8000541e <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800053b4:	00fb06b3          	add	a3,s6,a5
    800053b8:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053bc:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053be:	0207c563          	bltz	a5,800053e8 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053c2:	2485                	addiw	s1,s1,1
    800053c4:	0711                	addi	a4,a4,4
    800053c6:	1d548c63          	beq	s1,s5,8000559e <virtio_disk_rw+0x23e>
    idx[i] = alloc_desc();
    800053ca:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053cc:	0001b697          	auipc	a3,0x1b
    800053d0:	75468693          	addi	a3,a3,1876 # 80020b20 <disk>
    800053d4:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053d6:	0186c583          	lbu	a1,24(a3)
    800053da:	fde9                	bnez	a1,800053b4 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800053dc:	2785                	addiw	a5,a5,1
    800053de:	0685                	addi	a3,a3,1
    800053e0:	ff779be3          	bne	a5,s7,800053d6 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053e4:	57fd                	li	a5,-1
    800053e6:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800053e8:	02905463          	blez	s1,80005410 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    800053ec:	f9042503          	lw	a0,-112(s0)
    800053f0:	d3fff0ef          	jal	ra,8000512e <free_desc>
      for(int j = 0; j < i; j++)
    800053f4:	4785                	li	a5,1
    800053f6:	0097dd63          	bge	a5,s1,80005410 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    800053fa:	f9442503          	lw	a0,-108(s0)
    800053fe:	d31ff0ef          	jal	ra,8000512e <free_desc>
      for(int j = 0; j < i; j++)
    80005402:	4789                	li	a5,2
    80005404:	0097d663          	bge	a5,s1,80005410 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80005408:	f9842503          	lw	a0,-104(s0)
    8000540c:	d23ff0ef          	jal	ra,8000512e <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005410:	85e2                	mv	a1,s8
    80005412:	0001b517          	auipc	a0,0x1b
    80005416:	72650513          	addi	a0,a0,1830 # 80020b38 <disk+0x18>
    8000541a:	9effc0ef          	jal	ra,80001e08 <sleep>
  for(int i = 0; i < 3; i++){
    8000541e:	f9040713          	addi	a4,s0,-112
    80005422:	84ce                	mv	s1,s3
    80005424:	b75d                	j	800053ca <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005426:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    8000542a:	00479693          	slli	a3,a5,0x4
    8000542e:	0001b797          	auipc	a5,0x1b
    80005432:	6f278793          	addi	a5,a5,1778 # 80020b20 <disk>
    80005436:	97b6                	add	a5,a5,a3
    80005438:	4685                	li	a3,1
    8000543a:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000543c:	0001b597          	auipc	a1,0x1b
    80005440:	6e458593          	addi	a1,a1,1764 # 80020b20 <disk>
    80005444:	00a60793          	addi	a5,a2,10
    80005448:	0792                	slli	a5,a5,0x4
    8000544a:	97ae                	add	a5,a5,a1
    8000544c:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    80005450:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005454:	f6070693          	addi	a3,a4,-160
    80005458:	619c                	ld	a5,0(a1)
    8000545a:	97b6                	add	a5,a5,a3
    8000545c:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000545e:	6188                	ld	a0,0(a1)
    80005460:	96aa                	add	a3,a3,a0
    80005462:	47c1                	li	a5,16
    80005464:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005466:	4785                	li	a5,1
    80005468:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    8000546c:	f9442783          	lw	a5,-108(s0)
    80005470:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005474:	0792                	slli	a5,a5,0x4
    80005476:	953e                	add	a0,a0,a5
    80005478:	05890693          	addi	a3,s2,88
    8000547c:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000547e:	6188                	ld	a0,0(a1)
    80005480:	97aa                	add	a5,a5,a0
    80005482:	40000693          	li	a3,1024
    80005486:	c794                	sw	a3,8(a5)
  if(write)
    80005488:	100d0763          	beqz	s10,80005596 <virtio_disk_rw+0x236>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000548c:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005490:	00c7d683          	lhu	a3,12(a5)
    80005494:	0016e693          	ori	a3,a3,1
    80005498:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    8000549c:	f9842583          	lw	a1,-104(s0)
    800054a0:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054a4:	0001b697          	auipc	a3,0x1b
    800054a8:	67c68693          	addi	a3,a3,1660 # 80020b20 <disk>
    800054ac:	00260793          	addi	a5,a2,2
    800054b0:	0792                	slli	a5,a5,0x4
    800054b2:	97b6                	add	a5,a5,a3
    800054b4:	587d                	li	a6,-1
    800054b6:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054ba:	0592                	slli	a1,a1,0x4
    800054bc:	952e                	add	a0,a0,a1
    800054be:	f9070713          	addi	a4,a4,-112
    800054c2:	9736                	add	a4,a4,a3
    800054c4:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800054c6:	6298                	ld	a4,0(a3)
    800054c8:	972e                	add	a4,a4,a1
    800054ca:	4585                	li	a1,1
    800054cc:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054ce:	4509                	li	a0,2
    800054d0:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800054d4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054d8:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800054dc:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054e0:	6698                	ld	a4,8(a3)
    800054e2:	00275783          	lhu	a5,2(a4)
    800054e6:	8b9d                	andi	a5,a5,7
    800054e8:	0786                	slli	a5,a5,0x1
    800054ea:	97ba                	add	a5,a5,a4
    800054ec:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800054f0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054f4:	6698                	ld	a4,8(a3)
    800054f6:	00275783          	lhu	a5,2(a4)
    800054fa:	2785                	addiw	a5,a5,1
    800054fc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005500:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005504:	100017b7          	lui	a5,0x10001
    80005508:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000550c:	00492703          	lw	a4,4(s2)
    80005510:	4785                	li	a5,1
    80005512:	00f71f63          	bne	a4,a5,80005530 <virtio_disk_rw+0x1d0>
    sleep(b, &disk.vdisk_lock);
    80005516:	0001b997          	auipc	s3,0x1b
    8000551a:	73298993          	addi	s3,s3,1842 # 80020c48 <disk+0x128>
  while(b->disk == 1) {
    8000551e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005520:	85ce                	mv	a1,s3
    80005522:	854a                	mv	a0,s2
    80005524:	8e5fc0ef          	jal	ra,80001e08 <sleep>
  while(b->disk == 1) {
    80005528:	00492783          	lw	a5,4(s2)
    8000552c:	fe978ae3          	beq	a5,s1,80005520 <virtio_disk_rw+0x1c0>
  }

  disk.info[idx[0]].b = 0;
    80005530:	f9042903          	lw	s2,-112(s0)
    80005534:	00290793          	addi	a5,s2,2
    80005538:	00479713          	slli	a4,a5,0x4
    8000553c:	0001b797          	auipc	a5,0x1b
    80005540:	5e478793          	addi	a5,a5,1508 # 80020b20 <disk>
    80005544:	97ba                	add	a5,a5,a4
    80005546:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000554a:	0001b997          	auipc	s3,0x1b
    8000554e:	5d698993          	addi	s3,s3,1494 # 80020b20 <disk>
    80005552:	00491713          	slli	a4,s2,0x4
    80005556:	0009b783          	ld	a5,0(s3)
    8000555a:	97ba                	add	a5,a5,a4
    8000555c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005560:	854a                	mv	a0,s2
    80005562:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005566:	bc9ff0ef          	jal	ra,8000512e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000556a:	8885                	andi	s1,s1,1
    8000556c:	f0fd                	bnez	s1,80005552 <virtio_disk_rw+0x1f2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000556e:	0001b517          	auipc	a0,0x1b
    80005572:	6da50513          	addi	a0,a0,1754 # 80020c48 <disk+0x128>
    80005576:	ecafb0ef          	jal	ra,80000c40 <release>
}
    8000557a:	70a6                	ld	ra,104(sp)
    8000557c:	7406                	ld	s0,96(sp)
    8000557e:	64e6                	ld	s1,88(sp)
    80005580:	6946                	ld	s2,80(sp)
    80005582:	69a6                	ld	s3,72(sp)
    80005584:	6a06                	ld	s4,64(sp)
    80005586:	7ae2                	ld	s5,56(sp)
    80005588:	7b42                	ld	s6,48(sp)
    8000558a:	7ba2                	ld	s7,40(sp)
    8000558c:	7c02                	ld	s8,32(sp)
    8000558e:	6ce2                	ld	s9,24(sp)
    80005590:	6d42                	ld	s10,16(sp)
    80005592:	6165                	addi	sp,sp,112
    80005594:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005596:	4689                	li	a3,2
    80005598:	00d79623          	sh	a3,12(a5)
    8000559c:	bdd5                	j	80005490 <virtio_disk_rw+0x130>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000559e:	f9042603          	lw	a2,-112(s0)
    800055a2:	00a60713          	addi	a4,a2,10
    800055a6:	0712                	slli	a4,a4,0x4
    800055a8:	0001b517          	auipc	a0,0x1b
    800055ac:	58050513          	addi	a0,a0,1408 # 80020b28 <disk+0x8>
    800055b0:	953a                	add	a0,a0,a4
  if(write)
    800055b2:	e60d1ae3          	bnez	s10,80005426 <virtio_disk_rw+0xc6>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800055b6:	00a60793          	addi	a5,a2,10
    800055ba:	00479693          	slli	a3,a5,0x4
    800055be:	0001b797          	auipc	a5,0x1b
    800055c2:	56278793          	addi	a5,a5,1378 # 80020b20 <disk>
    800055c6:	97b6                	add	a5,a5,a3
    800055c8:	0007a423          	sw	zero,8(a5)
    800055cc:	bd85                	j	8000543c <virtio_disk_rw+0xdc>

00000000800055ce <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055ce:	1101                	addi	sp,sp,-32
    800055d0:	ec06                	sd	ra,24(sp)
    800055d2:	e822                	sd	s0,16(sp)
    800055d4:	e426                	sd	s1,8(sp)
    800055d6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055d8:	0001b497          	auipc	s1,0x1b
    800055dc:	54848493          	addi	s1,s1,1352 # 80020b20 <disk>
    800055e0:	0001b517          	auipc	a0,0x1b
    800055e4:	66850513          	addi	a0,a0,1640 # 80020c48 <disk+0x128>
    800055e8:	dc0fb0ef          	jal	ra,80000ba8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055ec:	10001737          	lui	a4,0x10001
    800055f0:	533c                	lw	a5,96(a4)
    800055f2:	8b8d                	andi	a5,a5,3
    800055f4:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055f6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055fa:	689c                	ld	a5,16(s1)
    800055fc:	0204d703          	lhu	a4,32(s1)
    80005600:	0027d783          	lhu	a5,2(a5)
    80005604:	04f70663          	beq	a4,a5,80005650 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80005608:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000560c:	6898                	ld	a4,16(s1)
    8000560e:	0204d783          	lhu	a5,32(s1)
    80005612:	8b9d                	andi	a5,a5,7
    80005614:	078e                	slli	a5,a5,0x3
    80005616:	97ba                	add	a5,a5,a4
    80005618:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000561a:	00278713          	addi	a4,a5,2
    8000561e:	0712                	slli	a4,a4,0x4
    80005620:	9726                	add	a4,a4,s1
    80005622:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005626:	e321                	bnez	a4,80005666 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005628:	0789                	addi	a5,a5,2
    8000562a:	0792                	slli	a5,a5,0x4
    8000562c:	97a6                	add	a5,a5,s1
    8000562e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005630:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005634:	821fc0ef          	jal	ra,80001e54 <wakeup>

    disk.used_idx += 1;
    80005638:	0204d783          	lhu	a5,32(s1)
    8000563c:	2785                	addiw	a5,a5,1
    8000563e:	17c2                	slli	a5,a5,0x30
    80005640:	93c1                	srli	a5,a5,0x30
    80005642:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005646:	6898                	ld	a4,16(s1)
    80005648:	00275703          	lhu	a4,2(a4)
    8000564c:	faf71ee3          	bne	a4,a5,80005608 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80005650:	0001b517          	auipc	a0,0x1b
    80005654:	5f850513          	addi	a0,a0,1528 # 80020c48 <disk+0x128>
    80005658:	de8fb0ef          	jal	ra,80000c40 <release>
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6105                	addi	sp,sp,32
    80005664:	8082                	ret
      panic("virtio_disk_intr status");
    80005666:	00002517          	auipc	a0,0x2
    8000566a:	20250513          	addi	a0,a0,514 # 80007868 <syscalls+0x3d8>
    8000566e:	8eefb0ef          	jal	ra,8000075c <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
