
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	32c000ef          	jal	354 <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2cc000ef          	jal	304 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	88058593          	addi	a1,a1,-1920 # 8c0 <malloc+0xf8>
  48:	4509                	li	a0,2
  4a:	69c000ef          	jal	6e6 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2b4000ef          	jal	304 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	88258593          	addi	a1,a1,-1918 # 8d8 <malloc+0x110>
  5e:	4509                	li	a0,2
  60:	686000ef          	jal	6e6 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	290000ef          	jal	304 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0xa>
    ;
  return os;
}
  90:	60a2                	ld	ra,8(sp)
  92:	6402                	ld	s0,0(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x20>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x20>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf99                	beqz	a5,f2 <strlen+0x2a>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x12>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x22>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf81                	beqz	a5,140 <strchr+0x24>
    if(*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfdd                	j	138 <strchr+0x1c>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	7159                	addi	sp,sp,-112
 146:	f486                	sd	ra,104(sp)
 148:	f0a2                	sd	s0,96(sp)
 14a:	eca6                	sd	s1,88(sp)
 14c:	e8ca                	sd	s2,80(sp)
 14e:	e4ce                	sd	s3,72(sp)
 150:	e0d2                	sd	s4,64(sp)
 152:	fc56                	sd	s5,56(sp)
 154:	f85a                	sd	s6,48(sp)
 156:	f45e                	sd	s7,40(sp)
 158:	f062                	sd	s8,32(sp)
 15a:	ec66                	sd	s9,24(sp)
 15c:	e86a                	sd	s10,16(sp)
 15e:	1880                	addi	s0,sp,112
 160:	8caa                	mv	s9,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
 168:	f9f40b13          	addi	s6,s0,-97
 16c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4ba9                	li	s7,10
 170:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 172:	8d26                	mv	s10,s1
 174:	0014899b          	addiw	s3,s1,1
 178:	84ce                	mv	s1,s3
 17a:	0349d563          	bge	s3,s4,1a4 <gets+0x60>
    cc = read(0, &c, 1);
 17e:	8656                	mv	a2,s5
 180:	85da                	mv	a1,s6
 182:	4501                	li	a0,0
 184:	198000ef          	jal	31c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x60>
    buf[i++] = c;
 18c:	f9f44783          	lbu	a5,-97(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01778763          	beq	a5,s7,1a2 <gets+0x5e>
 198:	0905                	addi	s2,s2,1
 19a:	fd879ce3          	bne	a5,s8,172 <gets+0x2e>
    buf[i++] = c;
 19e:	8d4e                	mv	s10,s3
 1a0:	a011                	j	1a4 <gets+0x60>
 1a2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a4:	9d66                	add	s10,s10,s9
 1a6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1aa:	8566                	mv	a0,s9
 1ac:	70a6                	ld	ra,104(sp)
 1ae:	7406                	ld	s0,96(sp)
 1b0:	64e6                	ld	s1,88(sp)
 1b2:	6946                	ld	s2,80(sp)
 1b4:	69a6                	ld	s3,72(sp)
 1b6:	6a06                	ld	s4,64(sp)
 1b8:	7ae2                	ld	s5,56(sp)
 1ba:	7b42                	ld	s6,48(sp)
 1bc:	7ba2                	ld	s7,40(sp)
 1be:	7c02                	ld	s8,32(sp)
 1c0:	6ce2                	ld	s9,24(sp)
 1c2:	6d42                	ld	s10,16(sp)
 1c4:	6165                	addi	sp,sp,112
 1c6:	8082                	ret

00000000000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	e04a                	sd	s2,0(sp)
 1d0:	1000                	addi	s0,sp,32
 1d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	4581                	li	a1,0
 1d6:	16e000ef          	jal	344 <open>
  if(fd < 0)
 1da:	02054263          	bltz	a0,1fe <stat+0x36>
 1de:	e426                	sd	s1,8(sp)
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	178000ef          	jal	35c <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	140000ef          	jal	32c <close>
  return r;
 1f0:	64a2                	ld	s1,8(sp)
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfcd                	j	1f2 <stat+0x2a>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66963          	bltu	a2,a5,24a <atoi+0x48>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1e>
  return n;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfdd                	j	242 <atoi+0x40>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 256:	02b57563          	bgeu	a0,a1,280 <memmove+0x32>
    while(n-- > 0)
 25a:	00c05f63          	blez	a2,278 <memmove+0x2a>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec059e3          	blez	a2,278 <memmove+0x2a>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x4a>
 2a8:	bfc1                	j	278 <memmove+0x2a>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca0d                	beqz	a2,2e4 <memcmp+0x3a>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x16>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x32>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <memcmp+0x32>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	f5fff0ef          	jal	24e <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	f67ff0ef          	jal	324 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ca:	715d                	addi	sp,sp,-80
 3cc:	e486                	sd	ra,72(sp)
 3ce:	e0a2                	sd	s0,64(sp)
 3d0:	fc26                	sd	s1,56(sp)
 3d2:	f84a                	sd	s2,48(sp)
 3d4:	f44e                	sd	s3,40(sp)
 3d6:	0880                	addi	s0,sp,80
 3d8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	c299                	beqz	a3,3e0 <printint+0x16>
 3dc:	0605cf63          	bltz	a1,45a <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e0:	2581                	sext.w	a1,a1
  neg = 0;
 3e2:	4e01                	li	t3,0
  }

  i = 0;
 3e4:	fb840313          	addi	t1,s0,-72
  neg = 0;
 3e8:	869a                	mv	a3,t1
  i = 0;
 3ea:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	51480813          	addi	a6,a6,1300 # 900 <digits>
 3f4:	88be                	mv	a7,a5
 3f6:	0017851b          	addiw	a0,a5,1
 3fa:	87aa                	mv	a5,a0
 3fc:	02c5f73b          	remuw	a4,a1,a2
 400:	1702                	slli	a4,a4,0x20
 402:	9301                	srli	a4,a4,0x20
 404:	9742                	add	a4,a4,a6
 406:	00074703          	lbu	a4,0(a4)
 40a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 40e:	872e                	mv	a4,a1
 410:	02c5d5bb          	divuw	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fcc77fe3          	bgeu	a4,a2,3f4 <printint+0x2a>
  if(neg)
 41a:	000e0c63          	beqz	t3,432 <printint+0x68>
    buf[i++] = '-';
 41e:	fd050793          	addi	a5,a0,-48
 422:	00878533          	add	a0,a5,s0
 426:	02d00793          	li	a5,45
 42a:	fef50423          	sb	a5,-24(a0)
 42e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 432:	fff7899b          	addiw	s3,a5,-1
 436:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 43a:	fff4c583          	lbu	a1,-1(s1)
 43e:	854a                	mv	a0,s2
 440:	f6dff0ef          	jal	3ac <putc>
  while(--i >= 0)
 444:	39fd                	addiw	s3,s3,-1
 446:	14fd                	addi	s1,s1,-1
 448:	fe09d9e3          	bgez	s3,43a <printint+0x70>
}
 44c:	60a6                	ld	ra,72(sp)
 44e:	6406                	ld	s0,64(sp)
 450:	74e2                	ld	s1,56(sp)
 452:	7942                	ld	s2,48(sp)
 454:	79a2                	ld	s3,40(sp)
 456:	6161                	addi	sp,sp,80
 458:	8082                	ret
    x = -xx;
 45a:	40b005bb          	negw	a1,a1
    neg = 1;
 45e:	4e05                	li	t3,1
    x = -xx;
 460:	b751                	j	3e4 <printint+0x1a>

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	711d                	addi	sp,sp,-96
 464:	ec86                	sd	ra,88(sp)
 466:	e8a2                	sd	s0,80(sp)
 468:	e4a6                	sd	s1,72(sp)
 46a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46c:	0005c483          	lbu	s1,0(a1)
 470:	26048663          	beqz	s1,6dc <vprintf+0x27a>
 474:	e0ca                	sd	s2,64(sp)
 476:	fc4e                	sd	s3,56(sp)
 478:	f852                	sd	s4,48(sp)
 47a:	f456                	sd	s5,40(sp)
 47c:	f05a                	sd	s6,32(sp)
 47e:	ec5e                	sd	s7,24(sp)
 480:	e862                	sd	s8,16(sp)
 482:	e466                	sd	s9,8(sp)
 484:	8b2a                	mv	s6,a0
 486:	8a2e                	mv	s4,a1
 488:	8bb2                	mv	s7,a2
  state = 0;
 48a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 48c:	4901                	li	s2,0
 48e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 490:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 494:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 498:	06c00c93          	li	s9,108
 49c:	a00d                	j	4be <vprintf+0x5c>
        putc(fd, c0);
 49e:	85a6                	mv	a1,s1
 4a0:	855a                	mv	a0,s6
 4a2:	f0bff0ef          	jal	3ac <putc>
 4a6:	a019                	j	4ac <vprintf+0x4a>
    } else if(state == '%'){
 4a8:	03598363          	beq	s3,s5,4ce <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4ac:	0019079b          	addiw	a5,s2,1
 4b0:	893e                	mv	s2,a5
 4b2:	873e                	mv	a4,a5
 4b4:	97d2                	add	a5,a5,s4
 4b6:	0007c483          	lbu	s1,0(a5)
 4ba:	20048963          	beqz	s1,6cc <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4be:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c2:	fe0993e3          	bnez	s3,4a8 <vprintf+0x46>
      if(c0 == '%'){
 4c6:	fd579ce3          	bne	a5,s5,49e <vprintf+0x3c>
        state = '%';
 4ca:	89be                	mv	s3,a5
 4cc:	b7c5                	j	4ac <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ce:	00ea06b3          	add	a3,s4,a4
 4d2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4d6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4d8:	c681                	beqz	a3,4e0 <vprintf+0x7e>
 4da:	9752                	add	a4,a4,s4
 4dc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e0:	03878e63          	beq	a5,s8,51c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4e4:	05978863          	beq	a5,s9,534 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4e8:	07500713          	li	a4,117
 4ec:	0ee78263          	beq	a5,a4,5d0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f0:	07800713          	li	a4,120
 4f4:	12e78463          	beq	a5,a4,61c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4f8:	07000713          	li	a4,112
 4fc:	14e78963          	beq	a5,a4,64e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 500:	07300713          	li	a4,115
 504:	18e78863          	beq	a5,a4,694 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 508:	02500713          	li	a4,37
 50c:	04e79463          	bne	a5,a4,554 <vprintf+0xf2>
        putc(fd, '%');
 510:	85ba                	mv	a1,a4
 512:	855a                	mv	a0,s6
 514:	e99ff0ef          	jal	3ac <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 518:	4981                	li	s3,0
 51a:	bf49                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b8493          	addi	s1,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000ba583          	lw	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	ea1ff0ef          	jal	3ca <printint>
 52e:	8ba6                	mv	s7,s1
      state = 0;
 530:	4981                	li	s3,0
 532:	bfad                	j	4ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 534:	06400793          	li	a5,100
 538:	02f68963          	beq	a3,a5,56a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53c:	06c00793          	li	a5,108
 540:	04f68263          	beq	a3,a5,584 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 544:	07500793          	li	a5,117
 548:	0af68063          	beq	a3,a5,5e8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 54c:	07800793          	li	a5,120
 550:	0ef68263          	beq	a3,a5,634 <vprintf+0x1d2>
        putc(fd, '%');
 554:	02500593          	li	a1,37
 558:	855a                	mv	a0,s6
 55a:	e53ff0ef          	jal	3ac <putc>
        putc(fd, c0);
 55e:	85a6                	mv	a1,s1
 560:	855a                	mv	a0,s6
 562:	e4bff0ef          	jal	3ac <putc>
      state = 0;
 566:	4981                	li	s3,0
 568:	b791                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8493          	addi	s1,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000bb583          	ld	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e53ff0ef          	jal	3ca <printint>
        i += 1;
 57c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8ba6                	mv	s7,s1
      state = 0;
 580:	4981                	li	s3,0
        i += 1;
 582:	b72d                	j	4ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 584:	06400793          	li	a5,100
 588:	02f60763          	beq	a2,a5,5b6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 58c:	07500793          	li	a5,117
 590:	06f60963          	beq	a2,a5,602 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 594:	07800793          	li	a5,120
 598:	faf61ee3          	bne	a2,a5,554 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e21ff0ef          	jal	3ca <printint>
        i += 2;
 5ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	bde5                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e07ff0ef          	jal	3ca <printint>
        i += 2;
 5c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bdf9                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dedff0ef          	jal	3ca <printint>
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b5d9                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dd5ff0ef          	jal	3ca <printint>
        i += 1;
 5fa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 1;
 600:	b575                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	dbbff0ef          	jal	3ca <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bd49                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	da1ff0ef          	jal	3ca <printint>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	bdad                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d89ff0ef          	jal	3ca <printint>
        i += 1;
 646:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b585                	j	4ac <vprintf+0x4a>
 64e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 650:	008b8d13          	addi	s10,s7,8
 654:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	855a                	mv	a0,s6
 65e:	d4fff0ef          	jal	3ac <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	855a                	mv	a0,s6
 668:	d45ff0ef          	jal	3ac <putc>
 66c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	00000b97          	auipc	s7,0x0
 672:	292b8b93          	addi	s7,s7,658 # 900 <digits>
 676:	03c9d793          	srli	a5,s3,0x3c
 67a:	97de                	add	a5,a5,s7
 67c:	0007c583          	lbu	a1,0(a5)
 680:	855a                	mv	a0,s6
 682:	d2bff0ef          	jal	3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 686:	0992                	slli	s3,s3,0x4
 688:	34fd                	addiw	s1,s1,-1
 68a:	f4f5                	bnez	s1,676 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 68c:	8bea                	mv	s7,s10
      state = 0;
 68e:	4981                	li	s3,0
 690:	6d02                	ld	s10,0(sp)
 692:	bd29                	j	4ac <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 694:	008b8993          	addi	s3,s7,8
 698:	000bb483          	ld	s1,0(s7)
 69c:	cc91                	beqz	s1,6b8 <vprintf+0x256>
        for(; *s; s++)
 69e:	0004c583          	lbu	a1,0(s1)
 6a2:	c195                	beqz	a1,6c6 <vprintf+0x264>
          putc(fd, *s);
 6a4:	855a                	mv	a0,s6
 6a6:	d07ff0ef          	jal	3ac <putc>
        for(; *s; s++)
 6aa:	0485                	addi	s1,s1,1
 6ac:	0004c583          	lbu	a1,0(s1)
 6b0:	f9f5                	bnez	a1,6a4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	8bce                	mv	s7,s3
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bbdd                	j	4ac <vprintf+0x4a>
          s = "(null)";
 6b8:	00000497          	auipc	s1,0x0
 6bc:	24048493          	addi	s1,s1,576 # 8f8 <malloc+0x130>
        for(; *s; s++)
 6c0:	02800593          	li	a1,40
 6c4:	b7c5                	j	6a4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6c6:	8bce                	mv	s7,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b3cd                	j	4ac <vprintf+0x4a>
 6cc:	6906                	ld	s2,64(sp)
 6ce:	79e2                	ld	s3,56(sp)
 6d0:	7a42                	ld	s4,48(sp)
 6d2:	7aa2                	ld	s5,40(sp)
 6d4:	7b02                	ld	s6,32(sp)
 6d6:	6be2                	ld	s7,24(sp)
 6d8:	6c42                	ld	s8,16(sp)
 6da:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6dc:	60e6                	ld	ra,88(sp)
 6de:	6446                	ld	s0,80(sp)
 6e0:	64a6                	ld	s1,72(sp)
 6e2:	6125                	addi	sp,sp,96
 6e4:	8082                	ret

00000000000006e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e6:	715d                	addi	sp,sp,-80
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e010                	sd	a2,0(s0)
 6f0:	e414                	sd	a3,8(s0)
 6f2:	e818                	sd	a4,16(s0)
 6f4:	ec1c                	sd	a5,24(s0)
 6f6:	03043023          	sd	a6,32(s0)
 6fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	8622                	mv	a2,s0
 700:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 704:	d5fff0ef          	jal	462 <vprintf>
}
 708:	60e2                	ld	ra,24(sp)
 70a:	6442                	ld	s0,16(sp)
 70c:	6161                	addi	sp,sp,80
 70e:	8082                	ret

0000000000000710 <printf>:

void
printf(const char *fmt, ...)
{
 710:	711d                	addi	sp,sp,-96
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	addi	s0,sp,32
 718:	e40c                	sd	a1,8(s0)
 71a:	e810                	sd	a2,16(s0)
 71c:	ec14                	sd	a3,24(s0)
 71e:	f018                	sd	a4,32(s0)
 720:	f41c                	sd	a5,40(s0)
 722:	03043823          	sd	a6,48(s0)
 726:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72a:	00840613          	addi	a2,s0,8
 72e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 732:	85aa                	mv	a1,a0
 734:	4505                	li	a0,1
 736:	d2dff0ef          	jal	462 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret

0000000000000742 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 742:	1141                	addi	sp,sp,-16
 744:	e406                	sd	ra,8(sp)
 746:	e022                	sd	s0,0(sp)
 748:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	00001797          	auipc	a5,0x1
 752:	8b27b783          	ld	a5,-1870(a5) # 1000 <freep>
 756:	a02d                	j	780 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 758:	4618                	lw	a4,8(a2)
 75a:	9f2d                	addw	a4,a4,a1
 75c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	6398                	ld	a4,0(a5)
 762:	6310                	ld	a2,0(a4)
 764:	a83d                	j	7a2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 766:	ff852703          	lw	a4,-8(a0)
 76a:	9f31                	addw	a4,a4,a2
 76c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76e:	ff053683          	ld	a3,-16(a0)
 772:	a091                	j	7b6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	6398                	ld	a4,0(a5)
 776:	00e7e463          	bltu	a5,a4,77e <free+0x3c>
 77a:	00e6ea63          	bltu	a3,a4,78e <free+0x4c>
{
 77e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	fed7fae3          	bgeu	a5,a3,774 <free+0x32>
 784:	6398                	ld	a4,0(a5)
 786:	00e6e463          	bltu	a3,a4,78e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	fee7eae3          	bltu	a5,a4,77e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 78e:	ff852583          	lw	a1,-8(a0)
 792:	6390                	ld	a2,0(a5)
 794:	02059813          	slli	a6,a1,0x20
 798:	01c85713          	srli	a4,a6,0x1c
 79c:	9736                	add	a4,a4,a3
 79e:	fae60de3          	beq	a2,a4,758 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a6:	4790                	lw	a2,8(a5)
 7a8:	02061593          	slli	a1,a2,0x20
 7ac:	01c5d713          	srli	a4,a1,0x1c
 7b0:	973e                	add	a4,a4,a5
 7b2:	fae68ae3          	beq	a3,a4,766 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
}
 7c0:	60a2                	ld	ra,8(sp)
 7c2:	6402                	ld	s0,0(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	addi	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051993          	slli	s3,a0,0x20
 7d8:	0209d993          	srli	s3,s3,0x20
 7dc:	09bd                	addi	s3,s3,15
 7de:	0049d993          	srli	s3,s3,0x4
 7e2:	2985                	addiw	s3,s3,1
 7e4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7e6:	00001517          	auipc	a0,0x1
 7ea:	81a53503          	ld	a0,-2022(a0) # 1000 <freep>
 7ee:	c905                	beqz	a0,81e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f2:	4798                	lw	a4,8(a5)
 7f4:	09377663          	bgeu	a4,s3,880 <malloc+0xb8>
 7f8:	f426                	sd	s1,40(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 800:	8a4e                	mv	s4,s3
 802:	6705                	lui	a4,0x1
 804:	00e9f363          	bgeu	s3,a4,80a <malloc+0x42>
 808:	6a05                	lui	s4,0x1
 80a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 80e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 812:	00000497          	auipc	s1,0x0
 816:	7ee48493          	addi	s1,s1,2030 # 1000 <freep>
  if(p == (char*)-1)
 81a:	5afd                	li	s5,-1
 81c:	a83d                	j	85a <malloc+0x92>
 81e:	f426                	sd	s1,40(sp)
 820:	e852                	sd	s4,16(sp)
 822:	e456                	sd	s5,8(sp)
 824:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 826:	00000797          	auipc	a5,0x0
 82a:	7ea78793          	addi	a5,a5,2026 # 1010 <base>
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
 836:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 838:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83c:	b7d1                	j	800 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	e118                	sd	a4,0(a0)
 842:	a899                	j	898 <malloc+0xd0>
  hp->s.size = nu;
 844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 848:	0541                	addi	a0,a0,16
 84a:	ef9ff0ef          	jal	742 <free>
  return freep;
 84e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 850:	c125                	beqz	a0,8b0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 854:	4798                	lw	a4,8(a5)
 856:	03277163          	bgeu	a4,s2,878 <malloc+0xb0>
    if(p == freep)
 85a:	6098                	ld	a4,0(s1)
 85c:	853e                	mv	a0,a5
 85e:	fef71ae3          	bne	a4,a5,852 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 862:	8552                	mv	a0,s4
 864:	b29ff0ef          	jal	38c <sbrk>
  if(p == (char*)-1)
 868:	fd551ee3          	bne	a0,s5,844 <malloc+0x7c>
        return 0;
 86c:	4501                	li	a0,0
 86e:	74a2                	ld	s1,40(sp)
 870:	6a42                	ld	s4,16(sp)
 872:	6aa2                	ld	s5,8(sp)
 874:	6b02                	ld	s6,0(sp)
 876:	a03d                	j	8a4 <malloc+0xdc>
 878:	74a2                	ld	s1,40(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 880:	fae90fe3          	beq	s2,a4,83e <malloc+0x76>
        p->s.size -= nunits;
 884:	4137073b          	subw	a4,a4,s3
 888:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88a:	02071693          	slli	a3,a4,0x20
 88e:	01c6d713          	srli	a4,a3,0x1c
 892:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 894:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 898:	00000717          	auipc	a4,0x0
 89c:	76a73423          	sd	a0,1896(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a0:	01078513          	addi	a0,a5,16
  }
}
 8a4:	70e2                	ld	ra,56(sp)
 8a6:	7442                	ld	s0,48(sp)
 8a8:	7902                	ld	s2,32(sp)
 8aa:	69e2                	ld	s3,24(sp)
 8ac:	6121                	addi	sp,sp,64
 8ae:	8082                	ret
 8b0:	74a2                	ld	s1,40(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
 8b8:	b7f5                	j	8a4 <malloc+0xdc>
