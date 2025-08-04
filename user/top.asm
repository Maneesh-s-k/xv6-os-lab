
user/_top:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getprocs>:

#define MAX_PROC 64
#define SYS_getprocs 22  

//----------invocation of syscall for user-----------------
int getprocs(struct proc_info *info, int max) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	87aa                	mv	a5,a0
   a:	872e                	mv	a4,a1
    int ret;
    asm volatile (
   c:	48d9                	li	a7,22
   e:	853e                	mv	a0,a5
  10:	85ba                	mv	a1,a4
  12:	00000073          	ecall
  16:	87aa                	mv	a5,a0
        : "=r"(ret)
        : "i"(SYS_getprocs), "r"(info), "r"(max)
        : "a0", "a1", "a7"
    );
    return ret;
}
  18:	0007851b          	sext.w	a0,a5
  1c:	60a2                	ld	ra,8(sp)
  1e:	6402                	ld	s0,0(sp)
  20:	0141                	addi	sp,sp,16
  22:	8082                	ret

0000000000000024 <main>:
//-----------------------------------------------------------

static char* states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};

int main(void) {
  24:	8a010113          	addi	sp,sp,-1888
  28:	74113c23          	sd	ra,1880(sp)
  2c:	74813823          	sd	s0,1872(sp)
  30:	74913423          	sd	s1,1864(sp)
  34:	75213023          	sd	s2,1856(sp)
  38:	73313c23          	sd	s3,1848(sp)
  3c:	73413823          	sd	s4,1840(sp)
  40:	73513423          	sd	s5,1832(sp)
  44:	73613023          	sd	s6,1824(sp)
  48:	71713c23          	sd	s7,1816(sp)
  4c:	71813823          	sd	s8,1808(sp)
  50:	71913423          	sd	s9,1800(sp)
  54:	76010413          	addi	s0,sp,1888
    
    
    while (1) {
    struct proc_info pinfo[MAX_PROC];
    int n = getprocs(pinfo, MAX_PROC);
  58:	8a040c93          	addi	s9,s0,-1888
  5c:	04000c13          	li	s8,64
    printf("PID\tSTATE\t\tTICKS\tNAME\n");
  60:	00001b97          	auipc	s7,0x1
  64:	8d8b8b93          	addi	s7,s7,-1832 # 938 <malloc+0xfa>
    for (int i = 0; i < n; i++) {
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  68:	00001a97          	auipc	s5,0x1
  6c:	8c8a8a93          	addi	s5,s5,-1848 # 930 <malloc+0xf2>
  70:	00001b17          	auipc	s6,0x1
  74:	940b0b13          	addi	s6,s6,-1728 # 9b0 <states>
  78:	a835                	j	b4 <main+0x90>
        printf("%d\t%s\t%d\t%s\n", pinfo[i].pid, state, pinfo[i].ticks, pinfo[i].name);
  7a:	ffc72683          	lw	a3,-4(a4)
  7e:	ff472583          	lw	a1,-12(a4)
  82:	854e                	mv	a0,s3
  84:	702000ef          	jal	786 <printf>
    for (int i = 0; i < n; i++) {
  88:	04f1                	addi	s1,s1,28
  8a:	01248c63          	beq	s1,s2,a2 <main+0x7e>
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  8e:	8726                	mv	a4,s1
  90:	ff84a783          	lw	a5,-8(s1)
  94:	8656                	mv	a2,s5
  96:	fefa62e3          	bltu	s4,a5,7a <main+0x56>
  9a:	078e                	slli	a5,a5,0x3
  9c:	97da                	add	a5,a5,s6
  9e:	6390                	ld	a2,0(a5)
  a0:	bfe9                	j	7a <main+0x56>
    }
    sleep(20);                  // sleep for 200 ticks (~2 seconds)
  a2:	4551                	li	a0,20
  a4:	36e000ef          	jal	412 <sleep>
    printf("\033[2J\033[H");   // clear screen and move cursor home
  a8:	00001517          	auipc	a0,0x1
  ac:	8b850513          	addi	a0,a0,-1864 # 960 <malloc+0x122>
  b0:	6d6000ef          	jal	786 <printf>
    int n = getprocs(pinfo, MAX_PROC);
  b4:	85e2                	mv	a1,s8
  b6:	8566                	mv	a0,s9
  b8:	f49ff0ef          	jal	0 <getprocs>
  bc:	89aa                	mv	s3,a0
    printf("PID\tSTATE\t\tTICKS\tNAME\n");
  be:	855e                	mv	a0,s7
  c0:	6c6000ef          	jal	786 <printf>
    for (int i = 0; i < n; i++) {
  c4:	fd305fe3          	blez	s3,a2 <main+0x7e>
  c8:	8ac40493          	addi	s1,s0,-1876
  cc:	00399913          	slli	s2,s3,0x3
  d0:	41390933          	sub	s2,s2,s3
  d4:	090a                	slli	s2,s2,0x2
  d6:	9926                	add	s2,s2,s1
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  d8:	4a15                	li	s4,5
        printf("%d\t%s\t%d\t%s\n", pinfo[i].pid, state, pinfo[i].ticks, pinfo[i].name);
  da:	00001997          	auipc	s3,0x1
  de:	87698993          	addi	s3,s3,-1930 # 950 <malloc+0x112>
  e2:	b775                	j	8e <main+0x6a>

00000000000000e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ec:	f39ff0ef          	jal	24 <main>
  exit(0);
  f0:	4501                	li	a0,0
  f2:	290000ef          	jal	382 <exit>

00000000000000f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0xa>
    ;
  return os;
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x20>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x20>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret

0000000000000146 <strlen>:

uint
strlen(const char *s)
{
 146:	1141                	addi	sp,sp,-16
 148:	e406                	sd	ra,8(sp)
 14a:	e022                	sd	s0,0(sp)
 14c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14e:	00054783          	lbu	a5,0(a0)
 152:	cf99                	beqz	a5,170 <strlen+0x2a>
 154:	0505                	addi	a0,a0,1
 156:	87aa                	mv	a5,a0
 158:	86be                	mv	a3,a5
 15a:	0785                	addi	a5,a5,1
 15c:	fff7c703          	lbu	a4,-1(a5)
 160:	ff65                	bnez	a4,158 <strlen+0x12>
 162:	40a6853b          	subw	a0,a3,a0
 166:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for(n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x22>

0000000000000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cf81                	beqz	a5,1be <strchr+0x24>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfdd                	j	1b6 <strchr+0x1c>

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	7159                	addi	sp,sp,-112
 1c4:	f486                	sd	ra,104(sp)
 1c6:	f0a2                	sd	s0,96(sp)
 1c8:	eca6                	sd	s1,88(sp)
 1ca:	e8ca                	sd	s2,80(sp)
 1cc:	e4ce                	sd	s3,72(sp)
 1ce:	e0d2                	sd	s4,64(sp)
 1d0:	fc56                	sd	s5,56(sp)
 1d2:	f85a                	sd	s6,48(sp)
 1d4:	f45e                	sd	s7,40(sp)
 1d6:	f062                	sd	s8,32(sp)
 1d8:	ec66                	sd	s9,24(sp)
 1da:	e86a                	sd	s10,16(sp)
 1dc:	1880                	addi	s0,sp,112
 1de:	8caa                	mv	s9,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e6:	f9f40b13          	addi	s6,s0,-97
 1ea:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ec:	4ba9                	li	s7,10
 1ee:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f0:	8d26                	mv	s10,s1
 1f2:	0014899b          	addiw	s3,s1,1
 1f6:	84ce                	mv	s1,s3
 1f8:	0349d563          	bge	s3,s4,222 <gets+0x60>
    cc = read(0, &c, 1);
 1fc:	8656                	mv	a2,s5
 1fe:	85da                	mv	a1,s6
 200:	4501                	li	a0,0
 202:	198000ef          	jal	39a <read>
    if(cc < 1)
 206:	00a05e63          	blez	a0,222 <gets+0x60>
    buf[i++] = c;
 20a:	f9f44783          	lbu	a5,-97(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 212:	01778763          	beq	a5,s7,220 <gets+0x5e>
 216:	0905                	addi	s2,s2,1
 218:	fd879ce3          	bne	a5,s8,1f0 <gets+0x2e>
    buf[i++] = c;
 21c:	8d4e                	mv	s10,s3
 21e:	a011                	j	222 <gets+0x60>
 220:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 222:	9d66                	add	s10,s10,s9
 224:	000d0023          	sb	zero,0(s10)
  return buf;
}
 228:	8566                	mv	a0,s9
 22a:	70a6                	ld	ra,104(sp)
 22c:	7406                	ld	s0,96(sp)
 22e:	64e6                	ld	s1,88(sp)
 230:	6946                	ld	s2,80(sp)
 232:	69a6                	ld	s3,72(sp)
 234:	6a06                	ld	s4,64(sp)
 236:	7ae2                	ld	s5,56(sp)
 238:	7b42                	ld	s6,48(sp)
 23a:	7ba2                	ld	s7,40(sp)
 23c:	7c02                	ld	s8,32(sp)
 23e:	6ce2                	ld	s9,24(sp)
 240:	6d42                	ld	s10,16(sp)
 242:	6165                	addi	sp,sp,112
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	16e000ef          	jal	3c2 <open>
  if(fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	178000ef          	jal	3da <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	140000ef          	jal	3aa <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	597d                	li	s2,-1
 27e:	bfcd                	j	270 <stat+0x2a>

0000000000000280 <atoi>:

int
atoi(const char *s)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	00054683          	lbu	a3,0(a0)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	4625                	li	a2,9
 296:	02f66963          	bltu	a2,a5,2c8 <atoi+0x48>
 29a:	872a                	mv	a4,a0
  n = 0;
 29c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29e:	0705                	addi	a4,a4,1
 2a0:	0025179b          	slliw	a5,a0,0x2
 2a4:	9fa9                	addw	a5,a5,a0
 2a6:	0017979b          	slliw	a5,a5,0x1
 2aa:	9fb5                	addw	a5,a5,a3
 2ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b0:	00074683          	lbu	a3,0(a4)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	fef671e3          	bgeu	a2,a5,29e <atoi+0x1e>
  return n;
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfdd                	j	2c0 <atoi+0x40>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d4:	02b57563          	bgeu	a0,a1,2fe <memmove+0x32>
    while(n-- > 0)
 2d8:	00c05f63          	blez	a2,2f6 <memmove+0x2a>
 2dc:	1602                	slli	a2,a2,0x20
 2de:	9201                	srli	a2,a2,0x20
 2e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e6:	0585                	addi	a1,a1,1
 2e8:	0705                	addi	a4,a4,1
 2ea:	fff5c683          	lbu	a3,-1(a1)
 2ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
    dst += n;
 2fe:	00c50733          	add	a4,a0,a2
    src += n;
 302:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 304:	fec059e3          	blez	a2,2f6 <memmove+0x2a>
 308:	fff6079b          	addiw	a5,a2,-1
 30c:	1782                	slli	a5,a5,0x20
 30e:	9381                	srli	a5,a5,0x20
 310:	fff7c793          	not	a5,a5
 314:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 316:	15fd                	addi	a1,a1,-1
 318:	177d                	addi	a4,a4,-1
 31a:	0005c683          	lbu	a3,0(a1)
 31e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 322:	fef71ae3          	bne	a4,a5,316 <memmove+0x4a>
 326:	bfc1                	j	2f6 <memmove+0x2a>

0000000000000328 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 330:	ca0d                	beqz	a2,362 <memcmp+0x3a>
 332:	fff6069b          	addiw	a3,a2,-1
 336:	1682                	slli	a3,a3,0x20
 338:	9281                	srli	a3,a3,0x20
 33a:	0685                	addi	a3,a3,1
 33c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33e:	00054783          	lbu	a5,0(a0)
 342:	0005c703          	lbu	a4,0(a1)
 346:	00e79863          	bne	a5,a4,356 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 34a:	0505                	addi	a0,a0,1
    p2++;
 34c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34e:	fed518e3          	bne	a0,a3,33e <memcmp+0x16>
  }
  return 0;
 352:	4501                	li	a0,0
 354:	a019                	j	35a <memcmp+0x32>
      return *p1 - *p2;
 356:	40e7853b          	subw	a0,a5,a4
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <memcmp+0x32>

0000000000000366 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36e:	f5fff0ef          	jal	2cc <memmove>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37a:	4885                	li	a7,1
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exit>:
.global exit
exit:
 li a7, SYS_exit
 382:	4889                	li	a7,2
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <wait>:
.global wait
wait:
 li a7, SYS_wait
 38a:	488d                	li	a7,3
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 392:	4891                	li	a7,4
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <read>:
.global read
read:
 li a7, SYS_read
 39a:	4895                	li	a7,5
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <write>:
.global write
write:
 li a7, SYS_write
 3a2:	48c1                	li	a7,16
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <close>:
.global close
close:
 li a7, SYS_close
 3aa:	48d5                	li	a7,21
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b2:	4899                	li	a7,6
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ba:	489d                	li	a7,7
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <open>:
.global open
open:
 li a7, SYS_open
 3c2:	48bd                	li	a7,15
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ca:	48c5                	li	a7,17
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d2:	48c9                	li	a7,18
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3da:	48a1                	li	a7,8
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <link>:
.global link
link:
 li a7, SYS_link
 3e2:	48cd                	li	a7,19
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ea:	48d1                	li	a7,20
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f2:	48a5                	li	a7,9
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fa:	48a9                	li	a7,10
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 402:	48ad                	li	a7,11
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 40a:	48b1                	li	a7,12
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 412:	48b5                	li	a7,13
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41a:	48b9                	li	a7,14
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	1000                	addi	s0,sp,32
 42a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42e:	4605                	li	a2,1
 430:	fef40593          	addi	a1,s0,-17
 434:	f6fff0ef          	jal	3a2 <write>
}
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	6105                	addi	sp,sp,32
 43e:	8082                	ret

0000000000000440 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 440:	715d                	addi	sp,sp,-80
 442:	e486                	sd	ra,72(sp)
 444:	e0a2                	sd	s0,64(sp)
 446:	fc26                	sd	s1,56(sp)
 448:	f84a                	sd	s2,48(sp)
 44a:	f44e                	sd	s3,40(sp)
 44c:	0880                	addi	s0,sp,80
 44e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	c299                	beqz	a3,456 <printint+0x16>
 452:	0605cf63          	bltz	a1,4d0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 456:	2581                	sext.w	a1,a1
  neg = 0;
 458:	4e01                	li	t3,0
  }

  i = 0;
 45a:	fb840313          	addi	t1,s0,-72
  neg = 0;
 45e:	869a                	mv	a3,t1
  i = 0;
 460:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 462:	00000817          	auipc	a6,0x0
 466:	57e80813          	addi	a6,a6,1406 # 9e0 <digits>
 46a:	88be                	mv	a7,a5
 46c:	0017851b          	addiw	a0,a5,1
 470:	87aa                	mv	a5,a0
 472:	02c5f73b          	remuw	a4,a1,a2
 476:	1702                	slli	a4,a4,0x20
 478:	9301                	srli	a4,a4,0x20
 47a:	9742                	add	a4,a4,a6
 47c:	00074703          	lbu	a4,0(a4)
 480:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 484:	872e                	mv	a4,a1
 486:	02c5d5bb          	divuw	a1,a1,a2
 48a:	0685                	addi	a3,a3,1
 48c:	fcc77fe3          	bgeu	a4,a2,46a <printint+0x2a>
  if(neg)
 490:	000e0c63          	beqz	t3,4a8 <printint+0x68>
    buf[i++] = '-';
 494:	fd050793          	addi	a5,a0,-48
 498:	00878533          	add	a0,a5,s0
 49c:	02d00793          	li	a5,45
 4a0:	fef50423          	sb	a5,-24(a0)
 4a4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4a8:	fff7899b          	addiw	s3,a5,-1
 4ac:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4b0:	fff4c583          	lbu	a1,-1(s1)
 4b4:	854a                	mv	a0,s2
 4b6:	f6dff0ef          	jal	422 <putc>
  while(--i >= 0)
 4ba:	39fd                	addiw	s3,s3,-1
 4bc:	14fd                	addi	s1,s1,-1
 4be:	fe09d9e3          	bgez	s3,4b0 <printint+0x70>
}
 4c2:	60a6                	ld	ra,72(sp)
 4c4:	6406                	ld	s0,64(sp)
 4c6:	74e2                	ld	s1,56(sp)
 4c8:	7942                	ld	s2,48(sp)
 4ca:	79a2                	ld	s3,40(sp)
 4cc:	6161                	addi	sp,sp,80
 4ce:	8082                	ret
    x = -xx;
 4d0:	40b005bb          	negw	a1,a1
    neg = 1;
 4d4:	4e05                	li	t3,1
    x = -xx;
 4d6:	b751                	j	45a <printint+0x1a>

00000000000004d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d8:	711d                	addi	sp,sp,-96
 4da:	ec86                	sd	ra,88(sp)
 4dc:	e8a2                	sd	s0,80(sp)
 4de:	e4a6                	sd	s1,72(sp)
 4e0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e2:	0005c483          	lbu	s1,0(a1)
 4e6:	26048663          	beqz	s1,752 <vprintf+0x27a>
 4ea:	e0ca                	sd	s2,64(sp)
 4ec:	fc4e                	sd	s3,56(sp)
 4ee:	f852                	sd	s4,48(sp)
 4f0:	f456                	sd	s5,40(sp)
 4f2:	f05a                	sd	s6,32(sp)
 4f4:	ec5e                	sd	s7,24(sp)
 4f6:	e862                	sd	s8,16(sp)
 4f8:	e466                	sd	s9,8(sp)
 4fa:	8b2a                	mv	s6,a0
 4fc:	8a2e                	mv	s4,a1
 4fe:	8bb2                	mv	s7,a2
  state = 0;
 500:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 502:	4901                	li	s2,0
 504:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 506:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 50a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50e:	06c00c93          	li	s9,108
 512:	a00d                	j	534 <vprintf+0x5c>
        putc(fd, c0);
 514:	85a6                	mv	a1,s1
 516:	855a                	mv	a0,s6
 518:	f0bff0ef          	jal	422 <putc>
 51c:	a019                	j	522 <vprintf+0x4a>
    } else if(state == '%'){
 51e:	03598363          	beq	s3,s5,544 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 522:	0019079b          	addiw	a5,s2,1
 526:	893e                	mv	s2,a5
 528:	873e                	mv	a4,a5
 52a:	97d2                	add	a5,a5,s4
 52c:	0007c483          	lbu	s1,0(a5)
 530:	20048963          	beqz	s1,742 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 534:	0004879b          	sext.w	a5,s1
    if(state == 0){
 538:	fe0993e3          	bnez	s3,51e <vprintf+0x46>
      if(c0 == '%'){
 53c:	fd579ce3          	bne	a5,s5,514 <vprintf+0x3c>
        state = '%';
 540:	89be                	mv	s3,a5
 542:	b7c5                	j	522 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 544:	00ea06b3          	add	a3,s4,a4
 548:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	c681                	beqz	a3,556 <vprintf+0x7e>
 550:	9752                	add	a4,a4,s4
 552:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 556:	03878e63          	beq	a5,s8,592 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 55a:	05978863          	beq	a5,s9,5aa <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 55e:	07500713          	li	a4,117
 562:	0ee78263          	beq	a5,a4,646 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 566:	07800713          	li	a4,120
 56a:	12e78463          	beq	a5,a4,692 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56e:	07000713          	li	a4,112
 572:	14e78963          	beq	a5,a4,6c4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 576:	07300713          	li	a4,115
 57a:	18e78863          	beq	a5,a4,70a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57e:	02500713          	li	a4,37
 582:	04e79463          	bne	a5,a4,5ca <vprintf+0xf2>
        putc(fd, '%');
 586:	85ba                	mv	a1,a4
 588:	855a                	mv	a0,s6
 58a:	e99ff0ef          	jal	422 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf49                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	ea1ff0ef          	jal	440 <printint>
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bfad                	j	522 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	06400793          	li	a5,100
 5ae:	02f68963          	beq	a3,a5,5e0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b2:	06c00793          	li	a5,108
 5b6:	04f68263          	beq	a3,a5,5fa <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5ba:	07500793          	li	a5,117
 5be:	0af68063          	beq	a3,a5,65e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5c2:	07800793          	li	a5,120
 5c6:	0ef68263          	beq	a3,a5,6aa <vprintf+0x1d2>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	e53ff0ef          	jal	422 <putc>
        putc(fd, c0);
 5d4:	85a6                	mv	a1,s1
 5d6:	855a                	mv	a0,s6
 5d8:	e4bff0ef          	jal	422 <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b791                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e53ff0ef          	jal	440 <printint>
        i += 1;
 5f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 1;
 5f8:	b72d                	j	522 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06400793          	li	a5,100
 5fe:	02f60763          	beq	a2,a5,62c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 602:	07500793          	li	a5,117
 606:	06f60963          	beq	a2,a5,678 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	faf61ee3          	bne	a2,a5,5ca <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e21ff0ef          	jal	440 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bde5                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	008b8493          	addi	s1,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e07ff0ef          	jal	440 <printint>
        i += 2;
 63e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	bdf9                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 646:	008b8493          	addi	s1,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	dedff0ef          	jal	440 <printint>
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b5d9                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	dd5ff0ef          	jal	440 <printint>
        i += 1;
 670:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	b575                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	dbbff0ef          	jal	440 <printint>
        i += 2;
 68a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bd49                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 692:	008b8493          	addi	s1,s7,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	da1ff0ef          	jal	440 <printint>
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bdad                	j	522 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d89ff0ef          	jal	440 <printint>
        i += 1;
 6bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	b585                	j	522 <vprintf+0x4a>
 6c4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c6:	008b8d13          	addi	s10,s7,8
 6ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ce:	03000593          	li	a1,48
 6d2:	855a                	mv	a0,s6
 6d4:	d4fff0ef          	jal	422 <putc>
  putc(fd, 'x');
 6d8:	07800593          	li	a1,120
 6dc:	855a                	mv	a0,s6
 6de:	d45ff0ef          	jal	422 <putc>
 6e2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e4:	00000b97          	auipc	s7,0x0
 6e8:	2fcb8b93          	addi	s7,s7,764 # 9e0 <digits>
 6ec:	03c9d793          	srli	a5,s3,0x3c
 6f0:	97de                	add	a5,a5,s7
 6f2:	0007c583          	lbu	a1,0(a5)
 6f6:	855a                	mv	a0,s6
 6f8:	d2bff0ef          	jal	422 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fc:	0992                	slli	s3,s3,0x4
 6fe:	34fd                	addiw	s1,s1,-1
 700:	f4f5                	bnez	s1,6ec <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 702:	8bea                	mv	s7,s10
      state = 0;
 704:	4981                	li	s3,0
 706:	6d02                	ld	s10,0(sp)
 708:	bd29                	j	522 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 70a:	008b8993          	addi	s3,s7,8
 70e:	000bb483          	ld	s1,0(s7)
 712:	cc91                	beqz	s1,72e <vprintf+0x256>
        for(; *s; s++)
 714:	0004c583          	lbu	a1,0(s1)
 718:	c195                	beqz	a1,73c <vprintf+0x264>
          putc(fd, *s);
 71a:	855a                	mv	a0,s6
 71c:	d07ff0ef          	jal	422 <putc>
        for(; *s; s++)
 720:	0485                	addi	s1,s1,1
 722:	0004c583          	lbu	a1,0(s1)
 726:	f9f5                	bnez	a1,71a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bbdd                	j	522 <vprintf+0x4a>
          s = "(null)";
 72e:	00000497          	auipc	s1,0x0
 732:	27a48493          	addi	s1,s1,634 # 9a8 <malloc+0x16a>
        for(; *s; s++)
 736:	02800593          	li	a1,40
 73a:	b7c5                	j	71a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b3cd                	j	522 <vprintf+0x4a>
 742:	6906                	ld	s2,64(sp)
 744:	79e2                	ld	s3,56(sp)
 746:	7a42                	ld	s4,48(sp)
 748:	7aa2                	ld	s5,40(sp)
 74a:	7b02                	ld	s6,32(sp)
 74c:	6be2                	ld	s7,24(sp)
 74e:	6c42                	ld	s8,16(sp)
 750:	6ca2                	ld	s9,8(sp)
    }
  }
}
 752:	60e6                	ld	ra,88(sp)
 754:	6446                	ld	s0,80(sp)
 756:	64a6                	ld	s1,72(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75c:	715d                	addi	sp,sp,-80
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e010                	sd	a2,0(s0)
 766:	e414                	sd	a3,8(s0)
 768:	e818                	sd	a4,16(s0)
 76a:	ec1c                	sd	a5,24(s0)
 76c:	03043023          	sd	a6,32(s0)
 770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	8622                	mv	a2,s0
 776:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77a:	d5fff0ef          	jal	4d8 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6161                	addi	sp,sp,80
 784:	8082                	ret

0000000000000786 <printf>:

void
printf(const char *fmt, ...)
{
 786:	711d                	addi	sp,sp,-96
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e40c                	sd	a1,8(s0)
 790:	e810                	sd	a2,16(s0)
 792:	ec14                	sd	a3,24(s0)
 794:	f018                	sd	a4,32(s0)
 796:	f41c                	sd	a5,40(s0)
 798:	03043823          	sd	a6,48(s0)
 79c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	00840613          	addi	a2,s0,8
 7a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a8:	85aa                	mv	a1,a0
 7aa:	4505                	li	a0,1
 7ac:	d2dff0ef          	jal	4d8 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6125                	addi	sp,sp,96
 7b6:	8082                	ret

00000000000007b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b8:	1141                	addi	sp,sp,-16
 7ba:	e406                	sd	ra,8(sp)
 7bc:	e022                	sd	s0,0(sp)
 7be:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	00001797          	auipc	a5,0x1
 7c8:	83c7b783          	ld	a5,-1988(a5) # 1000 <freep>
 7cc:	a02d                	j	7f6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ce:	4618                	lw	a4,8(a2)
 7d0:	9f2d                	addw	a4,a4,a1
 7d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	6398                	ld	a4,0(a5)
 7d8:	6310                	ld	a2,0(a4)
 7da:	a83d                	j	818 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7dc:	ff852703          	lw	a4,-8(a0)
 7e0:	9f31                	addw	a4,a4,a2
 7e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e4:	ff053683          	ld	a3,-16(a0)
 7e8:	a091                	j	82c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x3c>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x4c>
{
 7f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x32>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059813          	slli	a6,a1,0x20
 80e:	01c85713          	srli	a4,a6,0x1c
 812:	9736                	add	a4,a4,a3
 814:	fae60de3          	beq	a2,a4,7ce <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81c:	4790                	lw	a2,8(a5)
 81e:	02061593          	slli	a1,a2,0x20
 822:	01c5d713          	srli	a4,a1,0x1c
 826:	973e                	add	a4,a4,a5
 828:	fae68ae3          	beq	a3,a4,7dc <free+0x24>
    p->s.ptr = bp->s.ptr;
 82c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
}
 836:	60a2                	ld	ra,8(sp)
 838:	6402                	ld	s0,0(sp)
 83a:	0141                	addi	sp,sp,16
 83c:	8082                	ret

000000000000083e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83e:	7139                	addi	sp,sp,-64
 840:	fc06                	sd	ra,56(sp)
 842:	f822                	sd	s0,48(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84a:	02051993          	slli	s3,a0,0x20
 84e:	0209d993          	srli	s3,s3,0x20
 852:	09bd                	addi	s3,s3,15
 854:	0049d993          	srli	s3,s3,0x4
 858:	2985                	addiw	s3,s3,1
 85a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 85c:	00000517          	auipc	a0,0x0
 860:	7a453503          	ld	a0,1956(a0) # 1000 <freep>
 864:	c905                	beqz	a0,894 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	09377663          	bgeu	a4,s3,8f6 <malloc+0xb8>
 86e:	f426                	sd	s1,40(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 876:	8a4e                	mv	s4,s3
 878:	6705                	lui	a4,0x1
 87a:	00e9f363          	bgeu	s3,a4,880 <malloc+0x42>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 888:	00000497          	auipc	s1,0x0
 88c:	77848493          	addi	s1,s1,1912 # 1000 <freep>
  if(p == (char*)-1)
 890:	5afd                	li	s5,-1
 892:	a83d                	j	8d0 <malloc+0x92>
 894:	f426                	sd	s1,40(sp)
 896:	e852                	sd	s4,16(sp)
 898:	e456                	sd	s5,8(sp)
 89a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89c:	00000797          	auipc	a5,0x0
 8a0:	77478793          	addi	a5,a5,1908 # 1010 <base>
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
 8ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b2:	b7d1                	j	876 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	e118                	sd	a4,0(a0)
 8b8:	a899                	j	90e <malloc+0xd0>
  hp->s.size = nu;
 8ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8be:	0541                	addi	a0,a0,16
 8c0:	ef9ff0ef          	jal	7b8 <free>
  return freep;
 8c4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c6:	c125                	beqz	a0,926 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	03277163          	bgeu	a4,s2,8ee <malloc+0xb0>
    if(p == freep)
 8d0:	6098                	ld	a4,0(s1)
 8d2:	853e                	mv	a0,a5
 8d4:	fef71ae3          	bne	a4,a5,8c8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	b31ff0ef          	jal	40a <sbrk>
  if(p == (char*)-1)
 8de:	fd551ee3          	bne	a0,s5,8ba <malloc+0x7c>
        return 0;
 8e2:	4501                	li	a0,0
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	6a42                	ld	s4,16(sp)
 8e8:	6aa2                	ld	s5,8(sp)
 8ea:	6b02                	ld	s6,0(sp)
 8ec:	a03d                	j	91a <malloc+0xdc>
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f6:	fae90fe3          	beq	s2,a4,8b4 <malloc+0x76>
        p->s.size -= nunits;
 8fa:	4137073b          	subw	a4,a4,s3
 8fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 900:	02071693          	slli	a3,a4,0x20
 904:	01c6d713          	srli	a4,a3,0x1c
 908:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90e:	00000717          	auipc	a4,0x0
 912:	6ea73923          	sd	a0,1778(a4) # 1000 <freep>
      return (void*)(p + 1);
 916:	01078513          	addi	a0,a5,16
  }
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	7902                	ld	s2,32(sp)
 920:	69e2                	ld	s3,24(sp)
 922:	6121                	addi	sp,sp,64
 924:	8082                	ret
 926:	74a2                	ld	s1,40(sp)
 928:	6a42                	ld	s4,16(sp)
 92a:	6aa2                	ld	s5,8(sp)
 92c:	6b02                	ld	s6,0(sp)
 92e:	b7f5                	j	91a <malloc+0xdc>
