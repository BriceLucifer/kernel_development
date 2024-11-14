
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2ae000ef          	jal	ra,2be <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	286000ef          	jal	ra,2be <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	268000ef          	jal	ra,2be <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.1613>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3bc000ef          	jal	ra,426 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	24e000ef          	jal	ra,2be <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	244000ef          	jal	ra,2be <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	258000ef          	jal	ra,2e8 <memset>
  return buf;
  94:	84ce                	mv	s1,s3
  96:	b77d                	j	44 <fmtname+0x44>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	24913c23          	sd	s1,600(sp)
  a8:	25213823          	sd	s2,592(sp)
  ac:	25313423          	sd	s3,584(sp)
  b0:	25413023          	sd	s4,576(sp)
  b4:	23513c23          	sd	s5,568(sp)
  b8:	1c80                	addi	s0,sp,624
  ba:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  bc:	4581                	li	a1,0
  be:	45a000ef          	jal	ra,518 <open>
  c2:	06054963          	bltz	a0,134 <ls+0x9c>
  c6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  c8:	d9840593          	addi	a1,s0,-616
  cc:	464000ef          	jal	ra,530 <fstat>
  d0:	06054b63          	bltz	a0,146 <ls+0xae>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d4:	da041783          	lh	a5,-608(s0)
  d8:	0007869b          	sext.w	a3,a5
  dc:	4705                	li	a4,1
  de:	08e68063          	beq	a3,a4,15e <ls+0xc6>
  e2:	37f9                	addiw	a5,a5,-2
  e4:	17c2                	slli	a5,a5,0x30
  e6:	93c1                	srli	a5,a5,0x30
  e8:	02f76263          	bltu	a4,a5,10c <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  ec:	854a                	mv	a0,s2
  ee:	f13ff0ef          	jal	ra,0 <fmtname>
  f2:	85aa                	mv	a1,a0
  f4:	da842703          	lw	a4,-600(s0)
  f8:	d9c42683          	lw	a3,-612(s0)
  fc:	da041603          	lh	a2,-608(s0)
 100:	00001517          	auipc	a0,0x1
 104:	9b050513          	addi	a0,a0,-1616 # ab0 <malloc+0x114>
 108:	7da000ef          	jal	ra,8e2 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 10c:	8526                	mv	a0,s1
 10e:	3f2000ef          	jal	ra,500 <close>
}
 112:	26813083          	ld	ra,616(sp)
 116:	26013403          	ld	s0,608(sp)
 11a:	25813483          	ld	s1,600(sp)
 11e:	25013903          	ld	s2,592(sp)
 122:	24813983          	ld	s3,584(sp)
 126:	24013a03          	ld	s4,576(sp)
 12a:	23813a83          	ld	s5,568(sp)
 12e:	27010113          	addi	sp,sp,624
 132:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 134:	864a                	mv	a2,s2
 136:	00001597          	auipc	a1,0x1
 13a:	94a58593          	addi	a1,a1,-1718 # a80 <malloc+0xe4>
 13e:	4509                	li	a0,2
 140:	778000ef          	jal	ra,8b8 <fprintf>
    return;
 144:	b7f9                	j	112 <ls+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 146:	864a                	mv	a2,s2
 148:	00001597          	auipc	a1,0x1
 14c:	95058593          	addi	a1,a1,-1712 # a98 <malloc+0xfc>
 150:	4509                	li	a0,2
 152:	766000ef          	jal	ra,8b8 <fprintf>
    close(fd);
 156:	8526                	mv	a0,s1
 158:	3a8000ef          	jal	ra,500 <close>
    return;
 15c:	bf5d                	j	112 <ls+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 15e:	854a                	mv	a0,s2
 160:	15e000ef          	jal	ra,2be <strlen>
 164:	2541                	addiw	a0,a0,16
 166:	20000793          	li	a5,512
 16a:	00a7f963          	bgeu	a5,a0,17c <ls+0xe4>
      printf("ls: path too long\n");
 16e:	00001517          	auipc	a0,0x1
 172:	95250513          	addi	a0,a0,-1710 # ac0 <malloc+0x124>
 176:	76c000ef          	jal	ra,8e2 <printf>
      break;
 17a:	bf49                	j	10c <ls+0x74>
    strcpy(buf, path);
 17c:	85ca                	mv	a1,s2
 17e:	dc040513          	addi	a0,s0,-576
 182:	0f4000ef          	jal	ra,276 <strcpy>
    p = buf+strlen(buf);
 186:	dc040513          	addi	a0,s0,-576
 18a:	134000ef          	jal	ra,2be <strlen>
 18e:	02051913          	slli	s2,a0,0x20
 192:	02095913          	srli	s2,s2,0x20
 196:	dc040793          	addi	a5,s0,-576
 19a:	993e                	add	s2,s2,a5
    *p++ = '/';
 19c:	00190993          	addi	s3,s2,1
 1a0:	02f00793          	li	a5,47
 1a4:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1a8:	00001a17          	auipc	s4,0x1
 1ac:	908a0a13          	addi	s4,s4,-1784 # ab0 <malloc+0x114>
        printf("ls: cannot stat %s\n", buf);
 1b0:	00001a97          	auipc	s5,0x1
 1b4:	8e8a8a93          	addi	s5,s5,-1816 # a98 <malloc+0xfc>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b8:	a031                	j	1c4 <ls+0x12c>
        printf("ls: cannot stat %s\n", buf);
 1ba:	dc040593          	addi	a1,s0,-576
 1be:	8556                	mv	a0,s5
 1c0:	722000ef          	jal	ra,8e2 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c4:	4641                	li	a2,16
 1c6:	db040593          	addi	a1,s0,-592
 1ca:	8526                	mv	a0,s1
 1cc:	324000ef          	jal	ra,4f0 <read>
 1d0:	47c1                	li	a5,16
 1d2:	f2f51de3          	bne	a0,a5,10c <ls+0x74>
      if(de.inum == 0)
 1d6:	db045783          	lhu	a5,-592(s0)
 1da:	d7ed                	beqz	a5,1c4 <ls+0x12c>
      memmove(p, de.name, DIRSIZ);
 1dc:	4639                	li	a2,14
 1de:	db240593          	addi	a1,s0,-590
 1e2:	854e                	mv	a0,s3
 1e4:	242000ef          	jal	ra,426 <memmove>
      p[DIRSIZ] = 0;
 1e8:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1ec:	d9840593          	addi	a1,s0,-616
 1f0:	dc040513          	addi	a0,s0,-576
 1f4:	1ae000ef          	jal	ra,3a2 <stat>
 1f8:	fc0541e3          	bltz	a0,1ba <ls+0x122>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	dc040513          	addi	a0,s0,-576
 200:	e01ff0ef          	jal	ra,0 <fmtname>
 204:	85aa                	mv	a1,a0
 206:	da842703          	lw	a4,-600(s0)
 20a:	d9c42683          	lw	a3,-612(s0)
 20e:	da041603          	lh	a2,-608(s0)
 212:	8552                	mv	a0,s4
 214:	6ce000ef          	jal	ra,8e2 <printf>
 218:	b775                	j	1c4 <ls+0x12c>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e426                	sd	s1,8(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 226:	4785                	li	a5,1
 228:	02a7d563          	bge	a5,a0,252 <main+0x38>
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	1902                	slli	s2,s2,0x20
 236:	02095913          	srli	s2,s2,0x20
 23a:	090e                	slli	s2,s2,0x3
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	ra,98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	28a000ef          	jal	ra,4d8 <exit>
    ls(".");
 252:	00001517          	auipc	a0,0x1
 256:	88650513          	addi	a0,a0,-1914 # ad8 <malloc+0x13c>
 25a:	e3fff0ef          	jal	ra,98 <ls>
    exit(0);
 25e:	4501                	li	a0,0
 260:	278000ef          	jal	ra,4d8 <exit>

0000000000000264 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 26c:	fafff0ef          	jal	ra,21a <main>
  exit(0);
 270:	4501                	li	a0,0
 272:	266000ef          	jal	ra,4d8 <exit>

0000000000000276 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27c:	87aa                	mv	a5,a0
 27e:	0585                	addi	a1,a1,1
 280:	0785                	addi	a5,a5,1
 282:	fff5c703          	lbu	a4,-1(a1)
 286:	fee78fa3          	sb	a4,-1(a5)
 28a:	fb75                	bnez	a4,27e <strcpy+0x8>
    ;
  return os;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb91                	beqz	a5,2b0 <strcmp+0x1e>
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00f71763          	bne	a4,a5,2b0 <strcmp+0x1e>
    p++, q++;
 2a6:	0505                	addi	a0,a0,1
 2a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbe5                	bnez	a5,29e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b0:	0005c503          	lbu	a0,0(a1)
}
 2b4:	40a7853b          	subw	a0,a5,a0
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strlen>:

uint
strlen(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x26>
 2ca:	0505                	addi	a0,a0,1
 2cc:	87aa                	mv	a5,a0
 2ce:	4685                	li	a3,1
 2d0:	9e89                	subw	a3,a3,a0
 2d2:	00f6853b          	addw	a0,a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	fb7d                	bnez	a4,2d2 <strlen+0x14>
    ;
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ce09                	beqz	a2,308 <memset+0x20>
 2f0:	87aa                	mv	a5,a0
 2f2:	fff6071b          	addiw	a4,a2,-1
 2f6:	1702                	slli	a4,a4,0x20
 2f8:	9301                	srli	a4,a4,0x20
 2fa:	0705                	addi	a4,a4,1
 2fc:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x16>
  }
  return dst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb99                	beqz	a5,32e <strchr+0x20>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1a>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xc>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strchr+0x1a>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 350:	4aa9                	li	s5,10
 352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	2485                	addiw	s1,s1,1
 358:	0344d663          	bge	s1,s4,384 <gets+0x52>
    cc = read(0, &c, 1);
 35c:	4605                	li	a2,1
 35e:	faf40593          	addi	a1,s0,-81
 362:	4501                	li	a0,0
 364:	18c000ef          	jal	ra,4f0 <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x52>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x50>
 378:	0905                	addi	s2,s2,1
 37a:	fd679de3          	bne	a5,s6,354 <gets+0x22>
  for(i=0; i+1 < max; ){
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x52>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e426                	sd	s1,8(sp)
 3aa:	e04a                	sd	s2,0(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	4581                	li	a1,0
 3b2:	166000ef          	jal	ra,518 <open>
  if(fd < 0)
 3b6:	02054163          	bltz	a0,3d8 <stat+0x36>
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	172000ef          	jal	ra,530 <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	13a000ef          	jal	ra,500 <close>
  return r;
}
 3ca:	854a                	mv	a0,s2
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	64a2                	ld	s1,8(sp)
 3d2:	6902                	ld	s2,0(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret
    return -1;
 3d8:	597d                	li	s2,-1
 3da:	bfc5                	j	3ca <stat+0x28>

00000000000003dc <atoi>:

int
atoi(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054603          	lbu	a2,0(a0)
 3e6:	fd06079b          	addiw	a5,a2,-48
 3ea:	0ff7f793          	andi	a5,a5,255
 3ee:	4725                	li	a4,9
 3f0:	02f76963          	bltu	a4,a5,422 <atoi+0x46>
 3f4:	86aa                	mv	a3,a0
  n = 0;
 3f6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3fa:	0685                	addi	a3,a3,1
 3fc:	0025179b          	slliw	a5,a0,0x2
 400:	9fa9                	addw	a5,a5,a0
 402:	0017979b          	slliw	a5,a5,0x1
 406:	9fb1                	addw	a5,a5,a2
 408:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40c:	0006c603          	lbu	a2,0(a3)
 410:	fd06071b          	addiw	a4,a2,-48
 414:	0ff77713          	andi	a4,a4,255
 418:	fee5f1e3          	bgeu	a1,a4,3fa <atoi+0x1e>
  return n;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  n = 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <atoi+0x40>

0000000000000426 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42c:	02b57663          	bgeu	a0,a1,458 <memmove+0x32>
    while(n-- > 0)
 430:	02c05163          	blez	a2,452 <memmove+0x2c>
 434:	fff6079b          	addiw	a5,a2,-1
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	0785                	addi	a5,a5,1
 43e:	97aa                	add	a5,a5,a0
  dst = vdst;
 440:	872a                	mv	a4,a0
      *dst++ = *src++;
 442:	0585                	addi	a1,a1,1
 444:	0705                	addi	a4,a4,1
 446:	fff5c683          	lbu	a3,-1(a1)
 44a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44e:	fee79ae3          	bne	a5,a4,442 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 452:	6422                	ld	s0,8(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret
    dst += n;
 458:	00c50733          	add	a4,a0,a2
    src += n;
 45c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45e:	fec05ae3          	blez	a2,452 <memmove+0x2c>
 462:	fff6079b          	addiw	a5,a2,-1
 466:	1782                	slli	a5,a5,0x20
 468:	9381                	srli	a5,a5,0x20
 46a:	fff7c793          	not	a5,a5
 46e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 470:	15fd                	addi	a1,a1,-1
 472:	177d                	addi	a4,a4,-1
 474:	0005c683          	lbu	a3,0(a1)
 478:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 47c:	fee79ae3          	bne	a5,a4,470 <memmove+0x4a>
 480:	bfc9                	j	452 <memmove+0x2c>

0000000000000482 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 482:	1141                	addi	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 488:	ca05                	beqz	a2,4b8 <memcmp+0x36>
 48a:	fff6069b          	addiw	a3,a2,-1
 48e:	1682                	slli	a3,a3,0x20
 490:	9281                	srli	a3,a3,0x20
 492:	0685                	addi	a3,a3,1
 494:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 496:	00054783          	lbu	a5,0(a0)
 49a:	0005c703          	lbu	a4,0(a1)
 49e:	00e79863          	bne	a5,a4,4ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a2:	0505                	addi	a0,a0,1
    p2++;
 4a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a6:	fed518e3          	bne	a0,a3,496 <memcmp+0x14>
  }
  return 0;
 4aa:	4501                	li	a0,0
 4ac:	a019                	j	4b2 <memcmp+0x30>
      return *p1 - *p2;
 4ae:	40e7853b          	subw	a0,a5,a4
}
 4b2:	6422                	ld	s0,8(sp)
 4b4:	0141                	addi	sp,sp,16
 4b6:	8082                	ret
  return 0;
 4b8:	4501                	li	a0,0
 4ba:	bfe5                	j	4b2 <memcmp+0x30>

00000000000004bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4bc:	1141                	addi	sp,sp,-16
 4be:	e406                	sd	ra,8(sp)
 4c0:	e022                	sd	s0,0(sp)
 4c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c4:	f63ff0ef          	jal	ra,426 <memmove>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d0:	4885                	li	a7,1
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	4889                	li	a7,2
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e0:	488d                	li	a7,3
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e8:	4891                	li	a7,4
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <read>:
.global read
read:
 li a7, SYS_read
 4f0:	4895                	li	a7,5
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <write>:
.global write
write:
 li a7, SYS_write
 4f8:	48c1                	li	a7,16
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <close>:
.global close
close:
 li a7, SYS_close
 500:	48d5                	li	a7,21
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	48bd                	li	a7,15
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 520:	48c5                	li	a7,17
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 528:	48c9                	li	a7,18
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	48a1                	li	a7,8
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <link>:
.global link
link:
 li a7, SYS_link
 538:	48cd                	li	a7,19
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 540:	48d1                	li	a7,20
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 548:	48a5                	li	a7,9
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <dup>:
.global dup
dup:
 li a7, SYS_dup
 550:	48a9                	li	a7,10
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 558:	48ad                	li	a7,11
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 560:	48b1                	li	a7,12
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 568:	48b5                	li	a7,13
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 570:	48b9                	li	a7,14
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	f6fff0ef          	jal	ra,4f8 <write>
}
 58e:	60e2                	ld	ra,24(sp)
 590:	6442                	ld	s0,16(sp)
 592:	6105                	addi	sp,sp,32
 594:	8082                	ret

0000000000000596 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 596:	7139                	addi	sp,sp,-64
 598:	fc06                	sd	ra,56(sp)
 59a:	f822                	sd	s0,48(sp)
 59c:	f426                	sd	s1,40(sp)
 59e:	f04a                	sd	s2,32(sp)
 5a0:	ec4e                	sd	s3,24(sp)
 5a2:	0080                	addi	s0,sp,64
 5a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a6:	c299                	beqz	a3,5ac <printint+0x16>
 5a8:	0805c663          	bltz	a1,634 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ac:	2581                	sext.w	a1,a1
  neg = 0;
 5ae:	4881                	li	a7,0
 5b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b6:	2601                	sext.w	a2,a2
 5b8:	00000517          	auipc	a0,0x0
 5bc:	53050513          	addi	a0,a0,1328 # ae8 <digits>
 5c0:	883a                	mv	a6,a4
 5c2:	2705                	addiw	a4,a4,1
 5c4:	02c5f7bb          	remuw	a5,a1,a2
 5c8:	1782                	slli	a5,a5,0x20
 5ca:	9381                	srli	a5,a5,0x20
 5cc:	97aa                	add	a5,a5,a0
 5ce:	0007c783          	lbu	a5,0(a5)
 5d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d6:	0005879b          	sext.w	a5,a1
 5da:	02c5d5bb          	divuw	a1,a1,a2
 5de:	0685                	addi	a3,a3,1
 5e0:	fec7f0e3          	bgeu	a5,a2,5c0 <printint+0x2a>
  if(neg)
 5e4:	00088b63          	beqz	a7,5fa <printint+0x64>
    buf[i++] = '-';
 5e8:	fd040793          	addi	a5,s0,-48
 5ec:	973e                	add	a4,a4,a5
 5ee:	02d00793          	li	a5,45
 5f2:	fef70823          	sb	a5,-16(a4)
 5f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5fa:	02e05663          	blez	a4,626 <printint+0x90>
 5fe:	fc040793          	addi	a5,s0,-64
 602:	00e78933          	add	s2,a5,a4
 606:	fff78993          	addi	s3,a5,-1
 60a:	99ba                	add	s3,s3,a4
 60c:	377d                	addiw	a4,a4,-1
 60e:	1702                	slli	a4,a4,0x20
 610:	9301                	srli	a4,a4,0x20
 612:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 616:	fff94583          	lbu	a1,-1(s2)
 61a:	8526                	mv	a0,s1
 61c:	f5dff0ef          	jal	ra,578 <putc>
  while(--i >= 0)
 620:	197d                	addi	s2,s2,-1
 622:	ff391ae3          	bne	s2,s3,616 <printint+0x80>
}
 626:	70e2                	ld	ra,56(sp)
 628:	7442                	ld	s0,48(sp)
 62a:	74a2                	ld	s1,40(sp)
 62c:	7902                	ld	s2,32(sp)
 62e:	69e2                	ld	s3,24(sp)
 630:	6121                	addi	sp,sp,64
 632:	8082                	ret
    x = -xx;
 634:	40b005bb          	negw	a1,a1
    neg = 1;
 638:	4885                	li	a7,1
    x = -xx;
 63a:	bf9d                	j	5b0 <printint+0x1a>

000000000000063c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63c:	7119                	addi	sp,sp,-128
 63e:	fc86                	sd	ra,120(sp)
 640:	f8a2                	sd	s0,112(sp)
 642:	f4a6                	sd	s1,104(sp)
 644:	f0ca                	sd	s2,96(sp)
 646:	ecce                	sd	s3,88(sp)
 648:	e8d2                	sd	s4,80(sp)
 64a:	e4d6                	sd	s5,72(sp)
 64c:	e0da                	sd	s6,64(sp)
 64e:	fc5e                	sd	s7,56(sp)
 650:	f862                	sd	s8,48(sp)
 652:	f466                	sd	s9,40(sp)
 654:	f06a                	sd	s10,32(sp)
 656:	ec6e                	sd	s11,24(sp)
 658:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 65a:	0005c903          	lbu	s2,0(a1)
 65e:	22090e63          	beqz	s2,89a <vprintf+0x25e>
 662:	8b2a                	mv	s6,a0
 664:	8a2e                	mv	s4,a1
 666:	8bb2                	mv	s7,a2
  state = 0;
 668:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 66a:	4481                	li	s1,0
 66c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 66e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 672:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 676:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 67a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000c97          	auipc	s9,0x0
 682:	46ac8c93          	addi	s9,s9,1130 # ae8 <digits>
 686:	a005                	j	6a6 <vprintf+0x6a>
        putc(fd, c0);
 688:	85ca                	mv	a1,s2
 68a:	855a                	mv	a0,s6
 68c:	eedff0ef          	jal	ra,578 <putc>
 690:	a019                	j	696 <vprintf+0x5a>
    } else if(state == '%'){
 692:	03598263          	beq	s3,s5,6b6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 696:	2485                	addiw	s1,s1,1
 698:	8726                	mv	a4,s1
 69a:	009a07b3          	add	a5,s4,s1
 69e:	0007c903          	lbu	s2,0(a5)
 6a2:	1e090c63          	beqz	s2,89a <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 6a6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6aa:	fe0994e3          	bnez	s3,692 <vprintf+0x56>
      if(c0 == '%'){
 6ae:	fd579de3          	bne	a5,s5,688 <vprintf+0x4c>
        state = '%';
 6b2:	89be                	mv	s3,a5
 6b4:	b7cd                	j	696 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6b6:	cfa5                	beqz	a5,72e <vprintf+0xf2>
 6b8:	00ea06b3          	add	a3,s4,a4
 6bc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6c0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6c2:	c681                	beqz	a3,6ca <vprintf+0x8e>
 6c4:	9752                	add	a4,a4,s4
 6c6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ca:	03878a63          	beq	a5,s8,6fe <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	05a78463          	beq	a5,s10,716 <vprintf+0xda>
      } else if(c0 == 'u'){
 6d2:	0db78763          	beq	a5,s11,7a0 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6d6:	07800713          	li	a4,120
 6da:	10e78963          	beq	a5,a4,7ec <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6de:	07000713          	li	a4,112
 6e2:	12e78e63          	beq	a5,a4,81e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6e6:	07300713          	li	a4,115
 6ea:	16e78b63          	beq	a5,a4,860 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ee:	05579063          	bne	a5,s5,72e <vprintf+0xf2>
        putc(fd, '%');
 6f2:	85d6                	mv	a1,s5
 6f4:	855a                	mv	a0,s6
 6f6:	e83ff0ef          	jal	ra,578 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bf69                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6fe:	008b8913          	addi	s2,s7,8
 702:	4685                	li	a3,1
 704:	4629                	li	a2,10
 706:	000ba583          	lw	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	e8bff0ef          	jal	ra,596 <printint>
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	b749                	j	696 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 716:	03868663          	beq	a3,s8,742 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71a:	05a68163          	beq	a3,s10,75c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 71e:	09b68d63          	beq	a3,s11,7b8 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 722:	03a68f63          	beq	a3,s10,760 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 726:	07800793          	li	a5,120
 72a:	0cf68d63          	beq	a3,a5,804 <vprintf+0x1c8>
        putc(fd, '%');
 72e:	85d6                	mv	a1,s5
 730:	855a                	mv	a0,s6
 732:	e47ff0ef          	jal	ra,578 <putc>
        putc(fd, c0);
 736:	85ca                	mv	a1,s2
 738:	855a                	mv	a0,s6
 73a:	e3fff0ef          	jal	ra,578 <putc>
      state = 0;
 73e:	4981                	li	s3,0
 740:	bf99                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 742:	008b8913          	addi	s2,s7,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	e47ff0ef          	jal	ra,596 <printint>
        i += 1;
 754:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
        i += 1;
 75a:	bf35                	j	696 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75c:	03860563          	beq	a2,s8,786 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 760:	07b60963          	beq	a2,s11,7d2 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 764:	07800793          	li	a5,120
 768:	fcf613e3          	bne	a2,a5,72e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000ba583          	lw	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	e1dff0ef          	jal	ra,596 <printint>
        i += 2;
 77e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 2;
 784:	bf09                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	008b8913          	addi	s2,s7,8
 78a:	4685                	li	a3,1
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	e03ff0ef          	jal	ra,596 <printint>
        i += 2;
 798:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
        i += 2;
 79e:	bde5                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	de9ff0ef          	jal	ra,596 <printint>
 7b2:	8bca                	mv	s7,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b5c5                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	4681                	li	a3,0
 7be:	4629                	li	a2,10
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	dd1ff0ef          	jal	ra,596 <printint>
        i += 1;
 7ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7cc:	8bca                	mv	s7,s2
      state = 0;
 7ce:	4981                	li	s3,0
        i += 1;
 7d0:	b5d9                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	4681                	li	a3,0
 7d8:	4629                	li	a2,10
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	db7ff0ef          	jal	ra,596 <printint>
        i += 2;
 7e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	b575                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	d9dff0ef          	jal	ra,596 <printint>
 7fe:	8bca                	mv	s7,s2
      state = 0;
 800:	4981                	li	s3,0
 802:	bd51                	j	696 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	008b8913          	addi	s2,s7,8
 808:	4681                	li	a3,0
 80a:	4641                	li	a2,16
 80c:	000ba583          	lw	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	d85ff0ef          	jal	ra,596 <printint>
        i += 1;
 816:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
        i += 1;
 81c:	bdad                	j	696 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 81e:	008b8793          	addi	a5,s7,8
 822:	f8f43423          	sd	a5,-120(s0)
 826:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 82a:	03000593          	li	a1,48
 82e:	855a                	mv	a0,s6
 830:	d49ff0ef          	jal	ra,578 <putc>
  putc(fd, 'x');
 834:	07800593          	li	a1,120
 838:	855a                	mv	a0,s6
 83a:	d3fff0ef          	jal	ra,578 <putc>
 83e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97e6                	add	a5,a5,s9
 846:	0007c583          	lbu	a1,0(a5)
 84a:	855a                	mv	a0,s6
 84c:	d2dff0ef          	jal	ra,578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	0992                	slli	s3,s3,0x4
 852:	397d                	addiw	s2,s2,-1
 854:	fe0916e3          	bnez	s2,840 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 858:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 85c:	4981                	li	s3,0
 85e:	bd25                	j	696 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 860:	008b8993          	addi	s3,s7,8
 864:	000bb903          	ld	s2,0(s7)
 868:	00090f63          	beqz	s2,886 <vprintf+0x24a>
        for(; *s; s++)
 86c:	00094583          	lbu	a1,0(s2)
 870:	c195                	beqz	a1,894 <vprintf+0x258>
          putc(fd, *s);
 872:	855a                	mv	a0,s6
 874:	d05ff0ef          	jal	ra,578 <putc>
        for(; *s; s++)
 878:	0905                	addi	s2,s2,1
 87a:	00094583          	lbu	a1,0(s2)
 87e:	f9f5                	bnez	a1,872 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 880:	8bce                	mv	s7,s3
      state = 0;
 882:	4981                	li	s3,0
 884:	bd09                	j	696 <vprintf+0x5a>
          s = "(null)";
 886:	00000917          	auipc	s2,0x0
 88a:	25a90913          	addi	s2,s2,602 # ae0 <malloc+0x144>
        for(; *s; s++)
 88e:	02800593          	li	a1,40
 892:	b7c5                	j	872 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 894:	8bce                	mv	s7,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	bbfd                	j	696 <vprintf+0x5a>
    }
  }
}
 89a:	70e6                	ld	ra,120(sp)
 89c:	7446                	ld	s0,112(sp)
 89e:	74a6                	ld	s1,104(sp)
 8a0:	7906                	ld	s2,96(sp)
 8a2:	69e6                	ld	s3,88(sp)
 8a4:	6a46                	ld	s4,80(sp)
 8a6:	6aa6                	ld	s5,72(sp)
 8a8:	6b06                	ld	s6,64(sp)
 8aa:	7be2                	ld	s7,56(sp)
 8ac:	7c42                	ld	s8,48(sp)
 8ae:	7ca2                	ld	s9,40(sp)
 8b0:	7d02                	ld	s10,32(sp)
 8b2:	6de2                	ld	s11,24(sp)
 8b4:	6109                	addi	sp,sp,128
 8b6:	8082                	ret

00000000000008b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	e010                	sd	a2,0(s0)
 8c2:	e414                	sd	a3,8(s0)
 8c4:	e818                	sd	a4,16(s0)
 8c6:	ec1c                	sd	a5,24(s0)
 8c8:	03043023          	sd	a6,32(s0)
 8cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d4:	8622                	mv	a2,s0
 8d6:	d67ff0ef          	jal	ra,63c <vprintf>
}
 8da:	60e2                	ld	ra,24(sp)
 8dc:	6442                	ld	s0,16(sp)
 8de:	6161                	addi	sp,sp,80
 8e0:	8082                	ret

00000000000008e2 <printf>:

void
printf(const char *fmt, ...)
{
 8e2:	711d                	addi	sp,sp,-96
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	1000                	addi	s0,sp,32
 8ea:	e40c                	sd	a1,8(s0)
 8ec:	e810                	sd	a2,16(s0)
 8ee:	ec14                	sd	a3,24(s0)
 8f0:	f018                	sd	a4,32(s0)
 8f2:	f41c                	sd	a5,40(s0)
 8f4:	03043823          	sd	a6,48(s0)
 8f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fc:	00840613          	addi	a2,s0,8
 900:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 904:	85aa                	mv	a1,a0
 906:	4505                	li	a0,1
 908:	d35ff0ef          	jal	ra,63c <vprintf>
}
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	6125                	addi	sp,sp,96
 912:	8082                	ret

0000000000000914 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 914:	1141                	addi	sp,sp,-16
 916:	e422                	sd	s0,8(sp)
 918:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	00000797          	auipc	a5,0x0
 922:	6e27b783          	ld	a5,1762(a5) # 1000 <freep>
 926:	a805                	j	956 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 928:	4618                	lw	a4,8(a2)
 92a:	9db9                	addw	a1,a1,a4
 92c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	6318                	ld	a4,0(a4)
 934:	fee53823          	sd	a4,-16(a0)
 938:	a091                	j	97c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 93a:	ff852703          	lw	a4,-8(a0)
 93e:	9e39                	addw	a2,a2,a4
 940:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 942:	ff053703          	ld	a4,-16(a0)
 946:	e398                	sd	a4,0(a5)
 948:	a099                	j	98e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	6398                	ld	a4,0(a5)
 94c:	00e7e463          	bltu	a5,a4,954 <free+0x40>
 950:	00e6ea63          	bltu	a3,a4,964 <free+0x50>
{
 954:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	fed7fae3          	bgeu	a5,a3,94a <free+0x36>
 95a:	6398                	ld	a4,0(a5)
 95c:	00e6e463          	bltu	a3,a4,964 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 960:	fee7eae3          	bltu	a5,a4,954 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 964:	ff852583          	lw	a1,-8(a0)
 968:	6390                	ld	a2,0(a5)
 96a:	02059713          	slli	a4,a1,0x20
 96e:	9301                	srli	a4,a4,0x20
 970:	0712                	slli	a4,a4,0x4
 972:	9736                	add	a4,a4,a3
 974:	fae60ae3          	beq	a2,a4,928 <free+0x14>
    bp->s.ptr = p->s.ptr;
 978:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 97c:	4790                	lw	a2,8(a5)
 97e:	02061713          	slli	a4,a2,0x20
 982:	9301                	srli	a4,a4,0x20
 984:	0712                	slli	a4,a4,0x4
 986:	973e                	add	a4,a4,a5
 988:	fae689e3          	beq	a3,a4,93a <free+0x26>
  } else
    p->s.ptr = bp;
 98c:	e394                	sd	a3,0(a5)
  freep = p;
 98e:	00000717          	auipc	a4,0x0
 992:	66f73923          	sd	a5,1650(a4) # 1000 <freep>
}
 996:	6422                	ld	s0,8(sp)
 998:	0141                	addi	sp,sp,16
 99a:	8082                	ret

000000000000099c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 99c:	7139                	addi	sp,sp,-64
 99e:	fc06                	sd	ra,56(sp)
 9a0:	f822                	sd	s0,48(sp)
 9a2:	f426                	sd	s1,40(sp)
 9a4:	f04a                	sd	s2,32(sp)
 9a6:	ec4e                	sd	s3,24(sp)
 9a8:	e852                	sd	s4,16(sp)
 9aa:	e456                	sd	s5,8(sp)
 9ac:	e05a                	sd	s6,0(sp)
 9ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b0:	02051493          	slli	s1,a0,0x20
 9b4:	9081                	srli	s1,s1,0x20
 9b6:	04bd                	addi	s1,s1,15
 9b8:	8091                	srli	s1,s1,0x4
 9ba:	0014899b          	addiw	s3,s1,1
 9be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9c0:	00000517          	auipc	a0,0x0
 9c4:	64053503          	ld	a0,1600(a0) # 1000 <freep>
 9c8:	c515                	beqz	a0,9f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9cc:	4798                	lw	a4,8(a5)
 9ce:	02977f63          	bgeu	a4,s1,a0c <malloc+0x70>
 9d2:	8a4e                	mv	s4,s3
 9d4:	0009871b          	sext.w	a4,s3
 9d8:	6685                	lui	a3,0x1
 9da:	00d77363          	bgeu	a4,a3,9e0 <malloc+0x44>
 9de:	6a05                	lui	s4,0x1
 9e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e8:	00000917          	auipc	s2,0x0
 9ec:	61890913          	addi	s2,s2,1560 # 1000 <freep>
  if(p == (char*)-1)
 9f0:	5afd                	li	s5,-1
 9f2:	a0bd                	j	a60 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 9f4:	00000797          	auipc	a5,0x0
 9f8:	62c78793          	addi	a5,a5,1580 # 1020 <base>
 9fc:	00000717          	auipc	a4,0x0
 a00:	60f73223          	sd	a5,1540(a4) # 1000 <freep>
 a04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0a:	b7e1                	j	9d2 <malloc+0x36>
      if(p->s.size == nunits)
 a0c:	02e48b63          	beq	s1,a4,a42 <malloc+0xa6>
        p->s.size -= nunits;
 a10:	4137073b          	subw	a4,a4,s3
 a14:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a16:	1702                	slli	a4,a4,0x20
 a18:	9301                	srli	a4,a4,0x20
 a1a:	0712                	slli	a4,a4,0x4
 a1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a22:	00000717          	auipc	a4,0x0
 a26:	5ca73f23          	sd	a0,1502(a4) # 1000 <freep>
      return (void*)(p + 1);
 a2a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a2e:	70e2                	ld	ra,56(sp)
 a30:	7442                	ld	s0,48(sp)
 a32:	74a2                	ld	s1,40(sp)
 a34:	7902                	ld	s2,32(sp)
 a36:	69e2                	ld	s3,24(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
 a3e:	6121                	addi	sp,sp,64
 a40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a42:	6398                	ld	a4,0(a5)
 a44:	e118                	sd	a4,0(a0)
 a46:	bff1                	j	a22 <malloc+0x86>
  hp->s.size = nu;
 a48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a4c:	0541                	addi	a0,a0,16
 a4e:	ec7ff0ef          	jal	ra,914 <free>
  return freep;
 a52:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a56:	dd61                	beqz	a0,a2e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5a:	4798                	lw	a4,8(a5)
 a5c:	fa9778e3          	bgeu	a4,s1,a0c <malloc+0x70>
    if(p == freep)
 a60:	00093703          	ld	a4,0(s2)
 a64:	853e                	mv	a0,a5
 a66:	fef719e3          	bne	a4,a5,a58 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a6a:	8552                	mv	a0,s4
 a6c:	af5ff0ef          	jal	ra,560 <sbrk>
  if(p == (char*)-1)
 a70:	fd551ce3          	bne	a0,s5,a48 <malloc+0xac>
        return 0;
 a74:	4501                	li	a0,0
 a76:	bf65                	j	a2e <malloc+0x92>
