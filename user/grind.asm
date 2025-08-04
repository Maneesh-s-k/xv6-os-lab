
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	3f1000ef          	jal	ca8 <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	11050513          	addi	a0,a0,272 # 11d0 <malloc+0xf4>
      c8:	3c1000ef          	jal	c88 <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	10450513          	addi	a0,a0,260 # 11d0 <malloc+0xf4>
      d4:	3bd000ef          	jal	c90 <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	0ea50513          	addi	a0,a0,234 # 11d8 <malloc+0xfc>
      f6:	72f000ef          	jal	1024 <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	325000ef          	jal	c20 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	0ec50513          	addi	a0,a0,236 # 1200 <malloc+0x124>
     11c:	375000ef          	jal	c90 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	0f0c0c13          	addi	s8,s8,240 # 1210 <malloc+0x134>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	0dec0c13          	addi	s8,s8,222 # 1208 <malloc+0x12c>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     136:	e353f7b7          	lui	a5,0xe353f
     13a:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     13e:	20c4a9b7          	lui	s3,0x20c4a
     142:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     146:	1982                	slli	s3,s3,0x20
     148:	99be                	add	s3,s3,a5
     14a:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     14e:	4b85                	li	s7,1
    int what = rand() % 23;
     150:	b2164a37          	lui	s4,0xb2164
     154:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     158:	4ad9                	li	s5,22
     15a:	00001917          	auipc	s2,0x1
     15e:	38690913          	addi	s2,s2,902 # 14e0 <malloc+0x404>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     162:	f6840d93          	addi	s11,s0,-152
     166:	a819                	j	17c <go+0xd2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     168:	20200593          	li	a1,514
     16c:	00001517          	auipc	a0,0x1
     170:	0ac50513          	addi	a0,a0,172 # 1218 <malloc+0x13c>
     174:	2ed000ef          	jal	c60 <open>
     178:	2d1000ef          	jal	c48 <close>
    iters++;
     17c:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     17e:	0024d793          	srli	a5,s1,0x2
     182:	0337b7b3          	mulhu	a5,a5,s3
     186:	8391                	srli	a5,a5,0x4
     188:	036787b3          	mul	a5,a5,s6
     18c:	00f49763          	bne	s1,a5,19a <go+0xf0>
      write(1, which_child?"B":"A", 1);
     190:	865e                	mv	a2,s7
     192:	85e2                	mv	a1,s8
     194:	855e                	mv	a0,s7
     196:	2ab000ef          	jal	c40 <write>
    int what = rand() % 23;
     19a:	ef5ff0ef          	jal	8e <rand>
     19e:	034507b3          	mul	a5,a0,s4
     1a2:	9381                	srli	a5,a5,0x20
     1a4:	9fa9                	addw	a5,a5,a0
     1a6:	4047d79b          	sraiw	a5,a5,0x4
     1aa:	41f5571b          	sraiw	a4,a0,0x1f
     1ae:	9f99                	subw	a5,a5,a4
     1b0:	0017971b          	slliw	a4,a5,0x1
     1b4:	9f3d                	addw	a4,a4,a5
     1b6:	0037171b          	slliw	a4,a4,0x3
     1ba:	40f707bb          	subw	a5,a4,a5
     1be:	9d1d                	subw	a0,a0,a5
     1c0:	faaaeee3          	bltu	s5,a0,17c <go+0xd2>
     1c4:	02051793          	slli	a5,a0,0x20
     1c8:	01e7d513          	srli	a0,a5,0x1e
     1cc:	954a                	add	a0,a0,s2
     1ce:	411c                	lw	a5,0(a0)
     1d0:	97ca                	add	a5,a5,s2
     1d2:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d4:	20200593          	li	a1,514
     1d8:	00001517          	auipc	a0,0x1
     1dc:	05050513          	addi	a0,a0,80 # 1228 <malloc+0x14c>
     1e0:	281000ef          	jal	c60 <open>
     1e4:	265000ef          	jal	c48 <close>
     1e8:	bf51                	j	17c <go+0xd2>
      unlink("grindir/../a");
     1ea:	00001517          	auipc	a0,0x1
     1ee:	02e50513          	addi	a0,a0,46 # 1218 <malloc+0x13c>
     1f2:	27f000ef          	jal	c70 <unlink>
     1f6:	b759                	j	17c <go+0xd2>
      if(chdir("grindir") != 0){
     1f8:	00001517          	auipc	a0,0x1
     1fc:	fd850513          	addi	a0,a0,-40 # 11d0 <malloc+0xf4>
     200:	291000ef          	jal	c90 <chdir>
     204:	ed11                	bnez	a0,220 <go+0x176>
      unlink("../b");
     206:	00001517          	auipc	a0,0x1
     20a:	03a50513          	addi	a0,a0,58 # 1240 <malloc+0x164>
     20e:	263000ef          	jal	c70 <unlink>
      chdir("/");
     212:	00001517          	auipc	a0,0x1
     216:	fee50513          	addi	a0,a0,-18 # 1200 <malloc+0x124>
     21a:	277000ef          	jal	c90 <chdir>
     21e:	bfb9                	j	17c <go+0xd2>
        printf("grind: chdir grindir failed\n");
     220:	00001517          	auipc	a0,0x1
     224:	fb850513          	addi	a0,a0,-72 # 11d8 <malloc+0xfc>
     228:	5fd000ef          	jal	1024 <printf>
        exit(1);
     22c:	4505                	li	a0,1
     22e:	1f3000ef          	jal	c20 <exit>
      close(fd);
     232:	8566                	mv	a0,s9
     234:	215000ef          	jal	c48 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	00c50513          	addi	a0,a0,12 # 1248 <malloc+0x16c>
     244:	21d000ef          	jal	c60 <open>
     248:	8caa                	mv	s9,a0
     24a:	bf0d                	j	17c <go+0xd2>
      close(fd);
     24c:	8566                	mv	a0,s9
     24e:	1fb000ef          	jal	c48 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     252:	20200593          	li	a1,514
     256:	00001517          	auipc	a0,0x1
     25a:	00250513          	addi	a0,a0,2 # 1258 <malloc+0x17c>
     25e:	203000ef          	jal	c60 <open>
     262:	8caa                	mv	s9,a0
     264:	bf21                	j	17c <go+0xd2>
      write(fd, buf, sizeof(buf));
     266:	3e700613          	li	a2,999
     26a:	00002597          	auipc	a1,0x2
     26e:	db658593          	addi	a1,a1,-586 # 2020 <buf.0>
     272:	8566                	mv	a0,s9
     274:	1cd000ef          	jal	c40 <write>
     278:	b711                	j	17c <go+0xd2>
      read(fd, buf, sizeof(buf));
     27a:	3e700613          	li	a2,999
     27e:	00002597          	auipc	a1,0x2
     282:	da258593          	addi	a1,a1,-606 # 2020 <buf.0>
     286:	8566                	mv	a0,s9
     288:	1b1000ef          	jal	c38 <read>
     28c:	bdc5                	j	17c <go+0xd2>
      mkdir("grindir/../a");
     28e:	00001517          	auipc	a0,0x1
     292:	f8a50513          	addi	a0,a0,-118 # 1218 <malloc+0x13c>
     296:	1f3000ef          	jal	c88 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29a:	20200593          	li	a1,514
     29e:	00001517          	auipc	a0,0x1
     2a2:	fd250513          	addi	a0,a0,-46 # 1270 <malloc+0x194>
     2a6:	1bb000ef          	jal	c60 <open>
     2aa:	19f000ef          	jal	c48 <close>
      unlink("a/a");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	fd250513          	addi	a0,a0,-46 # 1280 <malloc+0x1a4>
     2b6:	1bb000ef          	jal	c70 <unlink>
     2ba:	b5c9                	j	17c <go+0xd2>
      mkdir("/../b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	fcc50513          	addi	a0,a0,-52 # 1288 <malloc+0x1ac>
     2c4:	1c5000ef          	jal	c88 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2c8:	20200593          	li	a1,514
     2cc:	00001517          	auipc	a0,0x1
     2d0:	fc450513          	addi	a0,a0,-60 # 1290 <malloc+0x1b4>
     2d4:	18d000ef          	jal	c60 <open>
     2d8:	171000ef          	jal	c48 <close>
      unlink("b/b");
     2dc:	00001517          	auipc	a0,0x1
     2e0:	fc450513          	addi	a0,a0,-60 # 12a0 <malloc+0x1c4>
     2e4:	18d000ef          	jal	c70 <unlink>
     2e8:	bd51                	j	17c <go+0xd2>
      unlink("b");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	fbe50513          	addi	a0,a0,-66 # 12a8 <malloc+0x1cc>
     2f2:	17f000ef          	jal	c70 <unlink>
      link("../grindir/./../a", "../b");
     2f6:	00001597          	auipc	a1,0x1
     2fa:	f4a58593          	addi	a1,a1,-182 # 1240 <malloc+0x164>
     2fe:	00001517          	auipc	a0,0x1
     302:	fb250513          	addi	a0,a0,-78 # 12b0 <malloc+0x1d4>
     306:	17b000ef          	jal	c80 <link>
     30a:	bd8d                	j	17c <go+0xd2>
      unlink("../grindir/../a");
     30c:	00001517          	auipc	a0,0x1
     310:	fbc50513          	addi	a0,a0,-68 # 12c8 <malloc+0x1ec>
     314:	15d000ef          	jal	c70 <unlink>
      link(".././b", "/grindir/../a");
     318:	00001597          	auipc	a1,0x1
     31c:	f3058593          	addi	a1,a1,-208 # 1248 <malloc+0x16c>
     320:	00001517          	auipc	a0,0x1
     324:	fb850513          	addi	a0,a0,-72 # 12d8 <malloc+0x1fc>
     328:	159000ef          	jal	c80 <link>
     32c:	bd81                	j	17c <go+0xd2>
      int pid = fork();
     32e:	0eb000ef          	jal	c18 <fork>
      if(pid == 0){
     332:	c519                	beqz	a0,340 <go+0x296>
      } else if(pid < 0){
     334:	00054863          	bltz	a0,344 <go+0x29a>
      wait(0);
     338:	4501                	li	a0,0
     33a:	0ef000ef          	jal	c28 <wait>
     33e:	bd3d                	j	17c <go+0xd2>
        exit(0);
     340:	0e1000ef          	jal	c20 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	f9c50513          	addi	a0,a0,-100 # 12e0 <malloc+0x204>
     34c:	4d9000ef          	jal	1024 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	0cf000ef          	jal	c20 <exit>
      int pid = fork();
     356:	0c3000ef          	jal	c18 <fork>
      if(pid == 0){
     35a:	c519                	beqz	a0,368 <go+0x2be>
      } else if(pid < 0){
     35c:	00054d63          	bltz	a0,376 <go+0x2cc>
      wait(0);
     360:	4501                	li	a0,0
     362:	0c7000ef          	jal	c28 <wait>
     366:	bd19                	j	17c <go+0xd2>
        fork();
     368:	0b1000ef          	jal	c18 <fork>
        fork();
     36c:	0ad000ef          	jal	c18 <fork>
        exit(0);
     370:	4501                	li	a0,0
     372:	0af000ef          	jal	c20 <exit>
        printf("grind: fork failed\n");
     376:	00001517          	auipc	a0,0x1
     37a:	f6a50513          	addi	a0,a0,-150 # 12e0 <malloc+0x204>
     37e:	4a7000ef          	jal	1024 <printf>
        exit(1);
     382:	4505                	li	a0,1
     384:	09d000ef          	jal	c20 <exit>
      sbrk(6011);
     388:	6505                	lui	a0,0x1
     38a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x23b>
     38e:	11b000ef          	jal	ca8 <sbrk>
     392:	b3ed                	j	17c <go+0xd2>
      if(sbrk(0) > break0)
     394:	4501                	li	a0,0
     396:	113000ef          	jal	ca8 <sbrk>
     39a:	f5843783          	ld	a5,-168(s0)
     39e:	dca7ffe3          	bgeu	a5,a0,17c <go+0xd2>
        sbrk(-(sbrk(0) - break0));
     3a2:	4501                	li	a0,0
     3a4:	105000ef          	jal	ca8 <sbrk>
     3a8:	f5843783          	ld	a5,-168(s0)
     3ac:	40a7853b          	subw	a0,a5,a0
     3b0:	0f9000ef          	jal	ca8 <sbrk>
     3b4:	b3e1                	j	17c <go+0xd2>
      int pid = fork();
     3b6:	063000ef          	jal	c18 <fork>
     3ba:	8d2a                	mv	s10,a0
      if(pid == 0){
     3bc:	c10d                	beqz	a0,3de <go+0x334>
      } else if(pid < 0){
     3be:	02054d63          	bltz	a0,3f8 <go+0x34e>
      if(chdir("../grindir/..") != 0){
     3c2:	00001517          	auipc	a0,0x1
     3c6:	f3e50513          	addi	a0,a0,-194 # 1300 <malloc+0x224>
     3ca:	0c7000ef          	jal	c90 <chdir>
     3ce:	ed15                	bnez	a0,40a <go+0x360>
      kill(pid);
     3d0:	856a                	mv	a0,s10
     3d2:	07f000ef          	jal	c50 <kill>
      wait(0);
     3d6:	4501                	li	a0,0
     3d8:	051000ef          	jal	c28 <wait>
     3dc:	b345                	j	17c <go+0xd2>
        close(open("a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	f1650513          	addi	a0,a0,-234 # 12f8 <malloc+0x21c>
     3ea:	077000ef          	jal	c60 <open>
     3ee:	05b000ef          	jal	c48 <close>
        exit(0);
     3f2:	4501                	li	a0,0
     3f4:	02d000ef          	jal	c20 <exit>
        printf("grind: fork failed\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	ee850513          	addi	a0,a0,-280 # 12e0 <malloc+0x204>
     400:	425000ef          	jal	1024 <printf>
        exit(1);
     404:	4505                	li	a0,1
     406:	01b000ef          	jal	c20 <exit>
        printf("grind: chdir failed\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f0650513          	addi	a0,a0,-250 # 1310 <malloc+0x234>
     412:	413000ef          	jal	1024 <printf>
        exit(1);
     416:	4505                	li	a0,1
     418:	009000ef          	jal	c20 <exit>
      int pid = fork();
     41c:	7fc000ef          	jal	c18 <fork>
      if(pid == 0){
     420:	c519                	beqz	a0,42e <go+0x384>
      } else if(pid < 0){
     422:	00054d63          	bltz	a0,43c <go+0x392>
      wait(0);
     426:	4501                	li	a0,0
     428:	001000ef          	jal	c28 <wait>
     42c:	bb81                	j	17c <go+0xd2>
        kill(getpid());
     42e:	073000ef          	jal	ca0 <getpid>
     432:	01f000ef          	jal	c50 <kill>
        exit(0);
     436:	4501                	li	a0,0
     438:	7e8000ef          	jal	c20 <exit>
        printf("grind: fork failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	ea450513          	addi	a0,a0,-348 # 12e0 <malloc+0x204>
     444:	3e1000ef          	jal	1024 <printf>
        exit(1);
     448:	4505                	li	a0,1
     44a:	7d6000ef          	jal	c20 <exit>
      if(pipe(fds) < 0){
     44e:	f7840513          	addi	a0,s0,-136
     452:	7de000ef          	jal	c30 <pipe>
     456:	02054363          	bltz	a0,47c <go+0x3d2>
      int pid = fork();
     45a:	7be000ef          	jal	c18 <fork>
      if(pid == 0){
     45e:	c905                	beqz	a0,48e <go+0x3e4>
      } else if(pid < 0){
     460:	08054263          	bltz	a0,4e4 <go+0x43a>
      close(fds[0]);
     464:	f7842503          	lw	a0,-136(s0)
     468:	7e0000ef          	jal	c48 <close>
      close(fds[1]);
     46c:	f7c42503          	lw	a0,-132(s0)
     470:	7d8000ef          	jal	c48 <close>
      wait(0);
     474:	4501                	li	a0,0
     476:	7b2000ef          	jal	c28 <wait>
     47a:	b309                	j	17c <go+0xd2>
        printf("grind: pipe failed\n");
     47c:	00001517          	auipc	a0,0x1
     480:	eac50513          	addi	a0,a0,-340 # 1328 <malloc+0x24c>
     484:	3a1000ef          	jal	1024 <printf>
        exit(1);
     488:	4505                	li	a0,1
     48a:	796000ef          	jal	c20 <exit>
        fork();
     48e:	78a000ef          	jal	c18 <fork>
        fork();
     492:	786000ef          	jal	c18 <fork>
        if(write(fds[1], "x", 1) != 1)
     496:	4605                	li	a2,1
     498:	00001597          	auipc	a1,0x1
     49c:	ea858593          	addi	a1,a1,-344 # 1340 <malloc+0x264>
     4a0:	f7c42503          	lw	a0,-132(s0)
     4a4:	79c000ef          	jal	c40 <write>
     4a8:	4785                	li	a5,1
     4aa:	00f51f63          	bne	a0,a5,4c8 <go+0x41e>
        if(read(fds[0], &c, 1) != 1)
     4ae:	4605                	li	a2,1
     4b0:	f7040593          	addi	a1,s0,-144
     4b4:	f7842503          	lw	a0,-136(s0)
     4b8:	780000ef          	jal	c38 <read>
     4bc:	4785                	li	a5,1
     4be:	00f51c63          	bne	a0,a5,4d6 <go+0x42c>
        exit(0);
     4c2:	4501                	li	a0,0
     4c4:	75c000ef          	jal	c20 <exit>
          printf("grind: pipe write failed\n");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	e8050513          	addi	a0,a0,-384 # 1348 <malloc+0x26c>
     4d0:	355000ef          	jal	1024 <printf>
     4d4:	bfe9                	j	4ae <go+0x404>
          printf("grind: pipe read failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	e9250513          	addi	a0,a0,-366 # 1368 <malloc+0x28c>
     4de:	347000ef          	jal	1024 <printf>
     4e2:	b7c5                	j	4c2 <go+0x418>
        printf("grind: fork failed\n");
     4e4:	00001517          	auipc	a0,0x1
     4e8:	dfc50513          	addi	a0,a0,-516 # 12e0 <malloc+0x204>
     4ec:	339000ef          	jal	1024 <printf>
        exit(1);
     4f0:	4505                	li	a0,1
     4f2:	72e000ef          	jal	c20 <exit>
      int pid = fork();
     4f6:	722000ef          	jal	c18 <fork>
      if(pid == 0){
     4fa:	c519                	beqz	a0,508 <go+0x45e>
      } else if(pid < 0){
     4fc:	04054f63          	bltz	a0,55a <go+0x4b0>
      wait(0);
     500:	4501                	li	a0,0
     502:	726000ef          	jal	c28 <wait>
     506:	b99d                	j	17c <go+0xd2>
        unlink("a");
     508:	00001517          	auipc	a0,0x1
     50c:	df050513          	addi	a0,a0,-528 # 12f8 <malloc+0x21c>
     510:	760000ef          	jal	c70 <unlink>
        mkdir("a");
     514:	00001517          	auipc	a0,0x1
     518:	de450513          	addi	a0,a0,-540 # 12f8 <malloc+0x21c>
     51c:	76c000ef          	jal	c88 <mkdir>
        chdir("a");
     520:	00001517          	auipc	a0,0x1
     524:	dd850513          	addi	a0,a0,-552 # 12f8 <malloc+0x21c>
     528:	768000ef          	jal	c90 <chdir>
        unlink("../a");
     52c:	00001517          	auipc	a0,0x1
     530:	e5c50513          	addi	a0,a0,-420 # 1388 <malloc+0x2ac>
     534:	73c000ef          	jal	c70 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     538:	20200593          	li	a1,514
     53c:	00001517          	auipc	a0,0x1
     540:	e0450513          	addi	a0,a0,-508 # 1340 <malloc+0x264>
     544:	71c000ef          	jal	c60 <open>
        unlink("x");
     548:	00001517          	auipc	a0,0x1
     54c:	df850513          	addi	a0,a0,-520 # 1340 <malloc+0x264>
     550:	720000ef          	jal	c70 <unlink>
        exit(0);
     554:	4501                	li	a0,0
     556:	6ca000ef          	jal	c20 <exit>
        printf("grind: fork failed\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	d8650513          	addi	a0,a0,-634 # 12e0 <malloc+0x204>
     562:	2c3000ef          	jal	1024 <printf>
        exit(1);
     566:	4505                	li	a0,1
     568:	6b8000ef          	jal	c20 <exit>
      unlink("c");
     56c:	00001517          	auipc	a0,0x1
     570:	e2450513          	addi	a0,a0,-476 # 1390 <malloc+0x2b4>
     574:	6fc000ef          	jal	c70 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     578:	20200593          	li	a1,514
     57c:	00001517          	auipc	a0,0x1
     580:	e1450513          	addi	a0,a0,-492 # 1390 <malloc+0x2b4>
     584:	6dc000ef          	jal	c60 <open>
     588:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58a:	04054563          	bltz	a0,5d4 <go+0x52a>
      if(write(fd1, "x", 1) != 1){
     58e:	865e                	mv	a2,s7
     590:	00001597          	auipc	a1,0x1
     594:	db058593          	addi	a1,a1,-592 # 1340 <malloc+0x264>
     598:	6a8000ef          	jal	c40 <write>
     59c:	05751563          	bne	a0,s7,5e6 <go+0x53c>
      if(fstat(fd1, &st) != 0){
     5a0:	f7840593          	addi	a1,s0,-136
     5a4:	856a                	mv	a0,s10
     5a6:	6d2000ef          	jal	c78 <fstat>
     5aa:	e539                	bnez	a0,5f8 <go+0x54e>
      if(st.size != 1){
     5ac:	f8843583          	ld	a1,-120(s0)
     5b0:	05759d63          	bne	a1,s7,60a <go+0x560>
      if(st.ino > 200){
     5b4:	f7c42583          	lw	a1,-132(s0)
     5b8:	0c800793          	li	a5,200
     5bc:	06b7e163          	bltu	a5,a1,61e <go+0x574>
      close(fd1);
     5c0:	856a                	mv	a0,s10
     5c2:	686000ef          	jal	c48 <close>
      unlink("c");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	dca50513          	addi	a0,a0,-566 # 1390 <malloc+0x2b4>
     5ce:	6a2000ef          	jal	c70 <unlink>
     5d2:	b66d                	j	17c <go+0xd2>
        printf("grind: create c failed\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	dc450513          	addi	a0,a0,-572 # 1398 <malloc+0x2bc>
     5dc:	249000ef          	jal	1024 <printf>
        exit(1);
     5e0:	4505                	li	a0,1
     5e2:	63e000ef          	jal	c20 <exit>
        printf("grind: write c failed\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	dca50513          	addi	a0,a0,-566 # 13b0 <malloc+0x2d4>
     5ee:	237000ef          	jal	1024 <printf>
        exit(1);
     5f2:	4505                	li	a0,1
     5f4:	62c000ef          	jal	c20 <exit>
        printf("grind: fstat failed\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	dd050513          	addi	a0,a0,-560 # 13c8 <malloc+0x2ec>
     600:	225000ef          	jal	1024 <printf>
        exit(1);
     604:	4505                	li	a0,1
     606:	61a000ef          	jal	c20 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60a:	2581                	sext.w	a1,a1
     60c:	00001517          	auipc	a0,0x1
     610:	dd450513          	addi	a0,a0,-556 # 13e0 <malloc+0x304>
     614:	211000ef          	jal	1024 <printf>
        exit(1);
     618:	4505                	li	a0,1
     61a:	606000ef          	jal	c20 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     61e:	00001517          	auipc	a0,0x1
     622:	dea50513          	addi	a0,a0,-534 # 1408 <malloc+0x32c>
     626:	1ff000ef          	jal	1024 <printf>
        exit(1);
     62a:	4505                	li	a0,1
     62c:	5f4000ef          	jal	c20 <exit>
      if(pipe(aa) < 0){
     630:	856e                	mv	a0,s11
     632:	5fe000ef          	jal	c30 <pipe>
     636:	0a054863          	bltz	a0,6e6 <go+0x63c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63a:	f7040513          	addi	a0,s0,-144
     63e:	5f2000ef          	jal	c30 <pipe>
     642:	0a054c63          	bltz	a0,6fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     646:	5d2000ef          	jal	c18 <fork>
      if(pid1 == 0){
     64a:	0c050263          	beqz	a0,70e <go+0x664>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     64e:	14054463          	bltz	a0,796 <go+0x6ec>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     652:	5c6000ef          	jal	c18 <fork>
      if(pid2 == 0){
     656:	14050a63          	beqz	a0,7aa <go+0x700>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     65a:	1e054863          	bltz	a0,84a <go+0x7a0>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     65e:	f6842503          	lw	a0,-152(s0)
     662:	5e6000ef          	jal	c48 <close>
      close(aa[1]);
     666:	f6c42503          	lw	a0,-148(s0)
     66a:	5de000ef          	jal	c48 <close>
      close(bb[1]);
     66e:	f7442503          	lw	a0,-140(s0)
     672:	5d6000ef          	jal	c48 <close>
      char buf[4] = { 0, 0, 0, 0 };
     676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67a:	865e                	mv	a2,s7
     67c:	f6040593          	addi	a1,s0,-160
     680:	f7042503          	lw	a0,-144(s0)
     684:	5b4000ef          	jal	c38 <read>
      read(bb[0], buf+1, 1);
     688:	865e                	mv	a2,s7
     68a:	f6140593          	addi	a1,s0,-159
     68e:	f7042503          	lw	a0,-144(s0)
     692:	5a6000ef          	jal	c38 <read>
      read(bb[0], buf+2, 1);
     696:	865e                	mv	a2,s7
     698:	f6240593          	addi	a1,s0,-158
     69c:	f7042503          	lw	a0,-144(s0)
     6a0:	598000ef          	jal	c38 <read>
      close(bb[0]);
     6a4:	f7042503          	lw	a0,-144(s0)
     6a8:	5a0000ef          	jal	c48 <close>
      int st1, st2;
      wait(&st1);
     6ac:	f6440513          	addi	a0,s0,-156
     6b0:	578000ef          	jal	c28 <wait>
      wait(&st2);
     6b4:	f7840513          	addi	a0,s0,-136
     6b8:	570000ef          	jal	c28 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6bc:	f6442783          	lw	a5,-156(s0)
     6c0:	f7842703          	lw	a4,-136(s0)
     6c4:	f4e43823          	sd	a4,-176(s0)
     6c8:	00e7ed33          	or	s10,a5,a4
     6cc:	180d1963          	bnez	s10,85e <go+0x7b4>
     6d0:	00001597          	auipc	a1,0x1
     6d4:	dd858593          	addi	a1,a1,-552 # 14a8 <malloc+0x3cc>
     6d8:	f6040513          	addi	a0,s0,-160
     6dc:	2d8000ef          	jal	9b4 <strcmp>
     6e0:	a8050ee3          	beqz	a0,17c <go+0xd2>
     6e4:	aab5                	j	860 <go+0x7b6>
        fprintf(2, "grind: pipe failed\n");
     6e6:	00001597          	auipc	a1,0x1
     6ea:	c4258593          	addi	a1,a1,-958 # 1328 <malloc+0x24c>
     6ee:	4509                	li	a0,2
     6f0:	10b000ef          	jal	ffa <fprintf>
        exit(1);
     6f4:	4505                	li	a0,1
     6f6:	52a000ef          	jal	c20 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fa:	00001597          	auipc	a1,0x1
     6fe:	c2e58593          	addi	a1,a1,-978 # 1328 <malloc+0x24c>
     702:	4509                	li	a0,2
     704:	0f7000ef          	jal	ffa <fprintf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	516000ef          	jal	c20 <exit>
        close(bb[0]);
     70e:	f7042503          	lw	a0,-144(s0)
     712:	536000ef          	jal	c48 <close>
        close(bb[1]);
     716:	f7442503          	lw	a0,-140(s0)
     71a:	52e000ef          	jal	c48 <close>
        close(aa[0]);
     71e:	f6842503          	lw	a0,-152(s0)
     722:	526000ef          	jal	c48 <close>
        close(1);
     726:	4505                	li	a0,1
     728:	520000ef          	jal	c48 <close>
        if(dup(aa[1]) != 1){
     72c:	f6c42503          	lw	a0,-148(s0)
     730:	568000ef          	jal	c98 <dup>
     734:	4785                	li	a5,1
     736:	00f50c63          	beq	a0,a5,74e <go+0x6a4>
          fprintf(2, "grind: dup failed\n");
     73a:	00001597          	auipc	a1,0x1
     73e:	cf658593          	addi	a1,a1,-778 # 1430 <malloc+0x354>
     742:	4509                	li	a0,2
     744:	0b7000ef          	jal	ffa <fprintf>
          exit(1);
     748:	4505                	li	a0,1
     74a:	4d6000ef          	jal	c20 <exit>
        close(aa[1]);
     74e:	f6c42503          	lw	a0,-148(s0)
     752:	4f6000ef          	jal	c48 <close>
        char *args[3] = { "echo", "hi", 0 };
     756:	00001797          	auipc	a5,0x1
     75a:	cf278793          	addi	a5,a5,-782 # 1448 <malloc+0x36c>
     75e:	f6f43c23          	sd	a5,-136(s0)
     762:	00001797          	auipc	a5,0x1
     766:	cee78793          	addi	a5,a5,-786 # 1450 <malloc+0x374>
     76a:	f8f43023          	sd	a5,-128(s0)
     76e:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     772:	f7840593          	addi	a1,s0,-136
     776:	00001517          	auipc	a0,0x1
     77a:	ce250513          	addi	a0,a0,-798 # 1458 <malloc+0x37c>
     77e:	4da000ef          	jal	c58 <exec>
        fprintf(2, "grind: echo: not found\n");
     782:	00001597          	auipc	a1,0x1
     786:	ce658593          	addi	a1,a1,-794 # 1468 <malloc+0x38c>
     78a:	4509                	li	a0,2
     78c:	06f000ef          	jal	ffa <fprintf>
        exit(2);
     790:	4509                	li	a0,2
     792:	48e000ef          	jal	c20 <exit>
        fprintf(2, "grind: fork failed\n");
     796:	00001597          	auipc	a1,0x1
     79a:	b4a58593          	addi	a1,a1,-1206 # 12e0 <malloc+0x204>
     79e:	4509                	li	a0,2
     7a0:	05b000ef          	jal	ffa <fprintf>
        exit(3);
     7a4:	450d                	li	a0,3
     7a6:	47a000ef          	jal	c20 <exit>
        close(aa[1]);
     7aa:	f6c42503          	lw	a0,-148(s0)
     7ae:	49a000ef          	jal	c48 <close>
        close(bb[0]);
     7b2:	f7042503          	lw	a0,-144(s0)
     7b6:	492000ef          	jal	c48 <close>
        close(0);
     7ba:	4501                	li	a0,0
     7bc:	48c000ef          	jal	c48 <close>
        if(dup(aa[0]) != 0){
     7c0:	f6842503          	lw	a0,-152(s0)
     7c4:	4d4000ef          	jal	c98 <dup>
     7c8:	c919                	beqz	a0,7de <go+0x734>
          fprintf(2, "grind: dup failed\n");
     7ca:	00001597          	auipc	a1,0x1
     7ce:	c6658593          	addi	a1,a1,-922 # 1430 <malloc+0x354>
     7d2:	4509                	li	a0,2
     7d4:	027000ef          	jal	ffa <fprintf>
          exit(4);
     7d8:	4511                	li	a0,4
     7da:	446000ef          	jal	c20 <exit>
        close(aa[0]);
     7de:	f6842503          	lw	a0,-152(s0)
     7e2:	466000ef          	jal	c48 <close>
        close(1);
     7e6:	4505                	li	a0,1
     7e8:	460000ef          	jal	c48 <close>
        if(dup(bb[1]) != 1){
     7ec:	f7442503          	lw	a0,-140(s0)
     7f0:	4a8000ef          	jal	c98 <dup>
     7f4:	4785                	li	a5,1
     7f6:	00f50c63          	beq	a0,a5,80e <go+0x764>
          fprintf(2, "grind: dup failed\n");
     7fa:	00001597          	auipc	a1,0x1
     7fe:	c3658593          	addi	a1,a1,-970 # 1430 <malloc+0x354>
     802:	4509                	li	a0,2
     804:	7f6000ef          	jal	ffa <fprintf>
          exit(5);
     808:	4515                	li	a0,5
     80a:	416000ef          	jal	c20 <exit>
        close(bb[1]);
     80e:	f7442503          	lw	a0,-140(s0)
     812:	436000ef          	jal	c48 <close>
        char *args[2] = { "cat", 0 };
     816:	00001797          	auipc	a5,0x1
     81a:	c6a78793          	addi	a5,a5,-918 # 1480 <malloc+0x3a4>
     81e:	f6f43c23          	sd	a5,-136(s0)
     822:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     826:	f7840593          	addi	a1,s0,-136
     82a:	00001517          	auipc	a0,0x1
     82e:	c5e50513          	addi	a0,a0,-930 # 1488 <malloc+0x3ac>
     832:	426000ef          	jal	c58 <exec>
        fprintf(2, "grind: cat: not found\n");
     836:	00001597          	auipc	a1,0x1
     83a:	c5a58593          	addi	a1,a1,-934 # 1490 <malloc+0x3b4>
     83e:	4509                	li	a0,2
     840:	7ba000ef          	jal	ffa <fprintf>
        exit(6);
     844:	4519                	li	a0,6
     846:	3da000ef          	jal	c20 <exit>
        fprintf(2, "grind: fork failed\n");
     84a:	00001597          	auipc	a1,0x1
     84e:	a9658593          	addi	a1,a1,-1386 # 12e0 <malloc+0x204>
     852:	4509                	li	a0,2
     854:	7a6000ef          	jal	ffa <fprintf>
        exit(7);
     858:	451d                	li	a0,7
     85a:	3c6000ef          	jal	c20 <exit>
     85e:	8d3e                	mv	s10,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     860:	f6040693          	addi	a3,s0,-160
     864:	f5043603          	ld	a2,-176(s0)
     868:	85ea                	mv	a1,s10
     86a:	00001517          	auipc	a0,0x1
     86e:	c4650513          	addi	a0,a0,-954 # 14b0 <malloc+0x3d4>
     872:	7b2000ef          	jal	1024 <printf>
        exit(1);
     876:	4505                	li	a0,1
     878:	3a8000ef          	jal	c20 <exit>

000000000000087c <iter>:
  }
}

void
iter()
{
     87c:	7179                	addi	sp,sp,-48
     87e:	f406                	sd	ra,40(sp)
     880:	f022                	sd	s0,32(sp)
     882:	1800                	addi	s0,sp,48
  unlink("a");
     884:	00001517          	auipc	a0,0x1
     888:	a7450513          	addi	a0,a0,-1420 # 12f8 <malloc+0x21c>
     88c:	3e4000ef          	jal	c70 <unlink>
  unlink("b");
     890:	00001517          	auipc	a0,0x1
     894:	a1850513          	addi	a0,a0,-1512 # 12a8 <malloc+0x1cc>
     898:	3d8000ef          	jal	c70 <unlink>
  
  int pid1 = fork();
     89c:	37c000ef          	jal	c18 <fork>
  if(pid1 < 0){
     8a0:	02054163          	bltz	a0,8c2 <iter+0x46>
     8a4:	ec26                	sd	s1,24(sp)
     8a6:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     8a8:	e905                	bnez	a0,8d8 <iter+0x5c>
     8aa:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8ac:	00001717          	auipc	a4,0x1
     8b0:	75470713          	addi	a4,a4,1876 # 2000 <rand_next>
     8b4:	631c                	ld	a5,0(a4)
     8b6:	01f7c793          	xori	a5,a5,31
     8ba:	e31c                	sd	a5,0(a4)
    go(0);
     8bc:	4501                	li	a0,0
     8be:	fecff0ef          	jal	aa <go>
     8c2:	ec26                	sd	s1,24(sp)
     8c4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8c6:	00001517          	auipc	a0,0x1
     8ca:	a1a50513          	addi	a0,a0,-1510 # 12e0 <malloc+0x204>
     8ce:	756000ef          	jal	1024 <printf>
    exit(1);
     8d2:	4505                	li	a0,1
     8d4:	34c000ef          	jal	c20 <exit>
     8d8:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8da:	33e000ef          	jal	c18 <fork>
     8de:	892a                	mv	s2,a0
  if(pid2 < 0){
     8e0:	02054063          	bltz	a0,900 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     8e4:	e51d                	bnez	a0,912 <iter+0x96>
    rand_next ^= 7177;
     8e6:	00001697          	auipc	a3,0x1
     8ea:	71a68693          	addi	a3,a3,1818 # 2000 <rand_next>
     8ee:	629c                	ld	a5,0(a3)
     8f0:	6709                	lui	a4,0x2
     8f2:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x6c9>
     8f6:	8fb9                	xor	a5,a5,a4
     8f8:	e29c                	sd	a5,0(a3)
    go(1);
     8fa:	4505                	li	a0,1
     8fc:	faeff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     900:	00001517          	auipc	a0,0x1
     904:	9e050513          	addi	a0,a0,-1568 # 12e0 <malloc+0x204>
     908:	71c000ef          	jal	1024 <printf>
    exit(1);
     90c:	4505                	li	a0,1
     90e:	312000ef          	jal	c20 <exit>
    exit(0);
  }

  int st1 = -1;
     912:	57fd                	li	a5,-1
     914:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     918:	fdc40513          	addi	a0,s0,-36
     91c:	30c000ef          	jal	c28 <wait>
  if(st1 != 0){
     920:	fdc42783          	lw	a5,-36(s0)
     924:	eb99                	bnez	a5,93a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     926:	57fd                	li	a5,-1
     928:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     92c:	fd840513          	addi	a0,s0,-40
     930:	2f8000ef          	jal	c28 <wait>

  exit(0);
     934:	4501                	li	a0,0
     936:	2ea000ef          	jal	c20 <exit>
    kill(pid1);
     93a:	8526                	mv	a0,s1
     93c:	314000ef          	jal	c50 <kill>
    kill(pid2);
     940:	854a                	mv	a0,s2
     942:	30e000ef          	jal	c50 <kill>
     946:	b7c5                	j	926 <iter+0xaa>

0000000000000948 <main>:
}

int
main()
{
     948:	1101                	addi	sp,sp,-32
     94a:	ec06                	sd	ra,24(sp)
     94c:	e822                	sd	s0,16(sp)
     94e:	e426                	sd	s1,8(sp)
     950:	e04a                	sd	s2,0(sp)
     952:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     954:	4951                	li	s2,20
    rand_next += 1;
     956:	00001497          	auipc	s1,0x1
     95a:	6aa48493          	addi	s1,s1,1706 # 2000 <rand_next>
     95e:	a809                	j	970 <main+0x28>
      iter();
     960:	f1dff0ef          	jal	87c <iter>
    sleep(20);
     964:	854a                	mv	a0,s2
     966:	34a000ef          	jal	cb0 <sleep>
    rand_next += 1;
     96a:	609c                	ld	a5,0(s1)
     96c:	0785                	addi	a5,a5,1
     96e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     970:	2a8000ef          	jal	c18 <fork>
    if(pid == 0){
     974:	d575                	beqz	a0,960 <main+0x18>
    if(pid > 0){
     976:	fea057e3          	blez	a0,964 <main+0x1c>
      wait(0);
     97a:	4501                	li	a0,0
     97c:	2ac000ef          	jal	c28 <wait>
     980:	b7d5                	j	964 <main+0x1c>

0000000000000982 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     982:	1141                	addi	sp,sp,-16
     984:	e406                	sd	ra,8(sp)
     986:	e022                	sd	s0,0(sp)
     988:	0800                	addi	s0,sp,16
  extern int main();
  main();
     98a:	fbfff0ef          	jal	948 <main>
  exit(0);
     98e:	4501                	li	a0,0
     990:	290000ef          	jal	c20 <exit>

0000000000000994 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     994:	1141                	addi	sp,sp,-16
     996:	e406                	sd	ra,8(sp)
     998:	e022                	sd	s0,0(sp)
     99a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     99c:	87aa                	mv	a5,a0
     99e:	0585                	addi	a1,a1,1
     9a0:	0785                	addi	a5,a5,1
     9a2:	fff5c703          	lbu	a4,-1(a1)
     9a6:	fee78fa3          	sb	a4,-1(a5)
     9aa:	fb75                	bnez	a4,99e <strcpy+0xa>
    ;
  return os;
}
     9ac:	60a2                	ld	ra,8(sp)
     9ae:	6402                	ld	s0,0(sp)
     9b0:	0141                	addi	sp,sp,16
     9b2:	8082                	ret

00000000000009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9b4:	1141                	addi	sp,sp,-16
     9b6:	e406                	sd	ra,8(sp)
     9b8:	e022                	sd	s0,0(sp)
     9ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9bc:	00054783          	lbu	a5,0(a0)
     9c0:	cb91                	beqz	a5,9d4 <strcmp+0x20>
     9c2:	0005c703          	lbu	a4,0(a1)
     9c6:	00f71763          	bne	a4,a5,9d4 <strcmp+0x20>
    p++, q++;
     9ca:	0505                	addi	a0,a0,1
     9cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9ce:	00054783          	lbu	a5,0(a0)
     9d2:	fbe5                	bnez	a5,9c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9d4:	0005c503          	lbu	a0,0(a1)
}
     9d8:	40a7853b          	subw	a0,a5,a0
     9dc:	60a2                	ld	ra,8(sp)
     9de:	6402                	ld	s0,0(sp)
     9e0:	0141                	addi	sp,sp,16
     9e2:	8082                	ret

00000000000009e4 <strlen>:

uint
strlen(const char *s)
{
     9e4:	1141                	addi	sp,sp,-16
     9e6:	e406                	sd	ra,8(sp)
     9e8:	e022                	sd	s0,0(sp)
     9ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9ec:	00054783          	lbu	a5,0(a0)
     9f0:	cf99                	beqz	a5,a0e <strlen+0x2a>
     9f2:	0505                	addi	a0,a0,1
     9f4:	87aa                	mv	a5,a0
     9f6:	86be                	mv	a3,a5
     9f8:	0785                	addi	a5,a5,1
     9fa:	fff7c703          	lbu	a4,-1(a5)
     9fe:	ff65                	bnez	a4,9f6 <strlen+0x12>
     a00:	40a6853b          	subw	a0,a3,a0
     a04:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a06:	60a2                	ld	ra,8(sp)
     a08:	6402                	ld	s0,0(sp)
     a0a:	0141                	addi	sp,sp,16
     a0c:	8082                	ret
  for(n = 0; s[n]; n++)
     a0e:	4501                	li	a0,0
     a10:	bfdd                	j	a06 <strlen+0x22>

0000000000000a12 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a12:	1141                	addi	sp,sp,-16
     a14:	e406                	sd	ra,8(sp)
     a16:	e022                	sd	s0,0(sp)
     a18:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a1a:	ca19                	beqz	a2,a30 <memset+0x1e>
     a1c:	87aa                	mv	a5,a0
     a1e:	1602                	slli	a2,a2,0x20
     a20:	9201                	srli	a2,a2,0x20
     a22:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a26:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2a:	0785                	addi	a5,a5,1
     a2c:	fee79de3          	bne	a5,a4,a26 <memset+0x14>
  }
  return dst;
}
     a30:	60a2                	ld	ra,8(sp)
     a32:	6402                	ld	s0,0(sp)
     a34:	0141                	addi	sp,sp,16
     a36:	8082                	ret

0000000000000a38 <strchr>:

char*
strchr(const char *s, char c)
{
     a38:	1141                	addi	sp,sp,-16
     a3a:	e406                	sd	ra,8(sp)
     a3c:	e022                	sd	s0,0(sp)
     a3e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a40:	00054783          	lbu	a5,0(a0)
     a44:	cf81                	beqz	a5,a5c <strchr+0x24>
    if(*s == c)
     a46:	00f58763          	beq	a1,a5,a54 <strchr+0x1c>
  for(; *s; s++)
     a4a:	0505                	addi	a0,a0,1
     a4c:	00054783          	lbu	a5,0(a0)
     a50:	fbfd                	bnez	a5,a46 <strchr+0xe>
      return (char*)s;
  return 0;
     a52:	4501                	li	a0,0
}
     a54:	60a2                	ld	ra,8(sp)
     a56:	6402                	ld	s0,0(sp)
     a58:	0141                	addi	sp,sp,16
     a5a:	8082                	ret
  return 0;
     a5c:	4501                	li	a0,0
     a5e:	bfdd                	j	a54 <strchr+0x1c>

0000000000000a60 <gets>:

char*
gets(char *buf, int max)
{
     a60:	7159                	addi	sp,sp,-112
     a62:	f486                	sd	ra,104(sp)
     a64:	f0a2                	sd	s0,96(sp)
     a66:	eca6                	sd	s1,88(sp)
     a68:	e8ca                	sd	s2,80(sp)
     a6a:	e4ce                	sd	s3,72(sp)
     a6c:	e0d2                	sd	s4,64(sp)
     a6e:	fc56                	sd	s5,56(sp)
     a70:	f85a                	sd	s6,48(sp)
     a72:	f45e                	sd	s7,40(sp)
     a74:	f062                	sd	s8,32(sp)
     a76:	ec66                	sd	s9,24(sp)
     a78:	e86a                	sd	s10,16(sp)
     a7a:	1880                	addi	s0,sp,112
     a7c:	8caa                	mv	s9,a0
     a7e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a80:	892a                	mv	s2,a0
     a82:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a84:	f9f40b13          	addi	s6,s0,-97
     a88:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a8a:	4ba9                	li	s7,10
     a8c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     a8e:	8d26                	mv	s10,s1
     a90:	0014899b          	addiw	s3,s1,1
     a94:	84ce                	mv	s1,s3
     a96:	0349d563          	bge	s3,s4,ac0 <gets+0x60>
    cc = read(0, &c, 1);
     a9a:	8656                	mv	a2,s5
     a9c:	85da                	mv	a1,s6
     a9e:	4501                	li	a0,0
     aa0:	198000ef          	jal	c38 <read>
    if(cc < 1)
     aa4:	00a05e63          	blez	a0,ac0 <gets+0x60>
    buf[i++] = c;
     aa8:	f9f44783          	lbu	a5,-97(s0)
     aac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ab0:	01778763          	beq	a5,s7,abe <gets+0x5e>
     ab4:	0905                	addi	s2,s2,1
     ab6:	fd879ce3          	bne	a5,s8,a8e <gets+0x2e>
    buf[i++] = c;
     aba:	8d4e                	mv	s10,s3
     abc:	a011                	j	ac0 <gets+0x60>
     abe:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     ac0:	9d66                	add	s10,s10,s9
     ac2:	000d0023          	sb	zero,0(s10)
  return buf;
}
     ac6:	8566                	mv	a0,s9
     ac8:	70a6                	ld	ra,104(sp)
     aca:	7406                	ld	s0,96(sp)
     acc:	64e6                	ld	s1,88(sp)
     ace:	6946                	ld	s2,80(sp)
     ad0:	69a6                	ld	s3,72(sp)
     ad2:	6a06                	ld	s4,64(sp)
     ad4:	7ae2                	ld	s5,56(sp)
     ad6:	7b42                	ld	s6,48(sp)
     ad8:	7ba2                	ld	s7,40(sp)
     ada:	7c02                	ld	s8,32(sp)
     adc:	6ce2                	ld	s9,24(sp)
     ade:	6d42                	ld	s10,16(sp)
     ae0:	6165                	addi	sp,sp,112
     ae2:	8082                	ret

0000000000000ae4 <stat>:

int
stat(const char *n, struct stat *st)
{
     ae4:	1101                	addi	sp,sp,-32
     ae6:	ec06                	sd	ra,24(sp)
     ae8:	e822                	sd	s0,16(sp)
     aea:	e04a                	sd	s2,0(sp)
     aec:	1000                	addi	s0,sp,32
     aee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     af0:	4581                	li	a1,0
     af2:	16e000ef          	jal	c60 <open>
  if(fd < 0)
     af6:	02054263          	bltz	a0,b1a <stat+0x36>
     afa:	e426                	sd	s1,8(sp)
     afc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     afe:	85ca                	mv	a1,s2
     b00:	178000ef          	jal	c78 <fstat>
     b04:	892a                	mv	s2,a0
  close(fd);
     b06:	8526                	mv	a0,s1
     b08:	140000ef          	jal	c48 <close>
  return r;
     b0c:	64a2                	ld	s1,8(sp)
}
     b0e:	854a                	mv	a0,s2
     b10:	60e2                	ld	ra,24(sp)
     b12:	6442                	ld	s0,16(sp)
     b14:	6902                	ld	s2,0(sp)
     b16:	6105                	addi	sp,sp,32
     b18:	8082                	ret
    return -1;
     b1a:	597d                	li	s2,-1
     b1c:	bfcd                	j	b0e <stat+0x2a>

0000000000000b1e <atoi>:

int
atoi(const char *s)
{
     b1e:	1141                	addi	sp,sp,-16
     b20:	e406                	sd	ra,8(sp)
     b22:	e022                	sd	s0,0(sp)
     b24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b26:	00054683          	lbu	a3,0(a0)
     b2a:	fd06879b          	addiw	a5,a3,-48
     b2e:	0ff7f793          	zext.b	a5,a5
     b32:	4625                	li	a2,9
     b34:	02f66963          	bltu	a2,a5,b66 <atoi+0x48>
     b38:	872a                	mv	a4,a0
  n = 0;
     b3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b3c:	0705                	addi	a4,a4,1
     b3e:	0025179b          	slliw	a5,a0,0x2
     b42:	9fa9                	addw	a5,a5,a0
     b44:	0017979b          	slliw	a5,a5,0x1
     b48:	9fb5                	addw	a5,a5,a3
     b4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b4e:	00074683          	lbu	a3,0(a4)
     b52:	fd06879b          	addiw	a5,a3,-48
     b56:	0ff7f793          	zext.b	a5,a5
     b5a:	fef671e3          	bgeu	a2,a5,b3c <atoi+0x1e>
  return n;
}
     b5e:	60a2                	ld	ra,8(sp)
     b60:	6402                	ld	s0,0(sp)
     b62:	0141                	addi	sp,sp,16
     b64:	8082                	ret
  n = 0;
     b66:	4501                	li	a0,0
     b68:	bfdd                	j	b5e <atoi+0x40>

0000000000000b6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b6a:	1141                	addi	sp,sp,-16
     b6c:	e406                	sd	ra,8(sp)
     b6e:	e022                	sd	s0,0(sp)
     b70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b72:	02b57563          	bgeu	a0,a1,b9c <memmove+0x32>
    while(n-- > 0)
     b76:	00c05f63          	blez	a2,b94 <memmove+0x2a>
     b7a:	1602                	slli	a2,a2,0x20
     b7c:	9201                	srli	a2,a2,0x20
     b7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b82:	872a                	mv	a4,a0
      *dst++ = *src++;
     b84:	0585                	addi	a1,a1,1
     b86:	0705                	addi	a4,a4,1
     b88:	fff5c683          	lbu	a3,-1(a1)
     b8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b90:	fee79ae3          	bne	a5,a4,b84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b94:	60a2                	ld	ra,8(sp)
     b96:	6402                	ld	s0,0(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret
    dst += n;
     b9c:	00c50733          	add	a4,a0,a2
    src += n;
     ba0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ba2:	fec059e3          	blez	a2,b94 <memmove+0x2a>
     ba6:	fff6079b          	addiw	a5,a2,-1
     baa:	1782                	slli	a5,a5,0x20
     bac:	9381                	srli	a5,a5,0x20
     bae:	fff7c793          	not	a5,a5
     bb2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bb4:	15fd                	addi	a1,a1,-1
     bb6:	177d                	addi	a4,a4,-1
     bb8:	0005c683          	lbu	a3,0(a1)
     bbc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bc0:	fef71ae3          	bne	a4,a5,bb4 <memmove+0x4a>
     bc4:	bfc1                	j	b94 <memmove+0x2a>

0000000000000bc6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e406                	sd	ra,8(sp)
     bca:	e022                	sd	s0,0(sp)
     bcc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bce:	ca0d                	beqz	a2,c00 <memcmp+0x3a>
     bd0:	fff6069b          	addiw	a3,a2,-1
     bd4:	1682                	slli	a3,a3,0x20
     bd6:	9281                	srli	a3,a3,0x20
     bd8:	0685                	addi	a3,a3,1
     bda:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bdc:	00054783          	lbu	a5,0(a0)
     be0:	0005c703          	lbu	a4,0(a1)
     be4:	00e79863          	bne	a5,a4,bf4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     be8:	0505                	addi	a0,a0,1
    p2++;
     bea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bec:	fed518e3          	bne	a0,a3,bdc <memcmp+0x16>
  }
  return 0;
     bf0:	4501                	li	a0,0
     bf2:	a019                	j	bf8 <memcmp+0x32>
      return *p1 - *p2;
     bf4:	40e7853b          	subw	a0,a5,a4
}
     bf8:	60a2                	ld	ra,8(sp)
     bfa:	6402                	ld	s0,0(sp)
     bfc:	0141                	addi	sp,sp,16
     bfe:	8082                	ret
  return 0;
     c00:	4501                	li	a0,0
     c02:	bfdd                	j	bf8 <memcmp+0x32>

0000000000000c04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c04:	1141                	addi	sp,sp,-16
     c06:	e406                	sd	ra,8(sp)
     c08:	e022                	sd	s0,0(sp)
     c0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c0c:	f5fff0ef          	jal	b6a <memmove>
}
     c10:	60a2                	ld	ra,8(sp)
     c12:	6402                	ld	s0,0(sp)
     c14:	0141                	addi	sp,sp,16
     c16:	8082                	ret

0000000000000c18 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c18:	4885                	li	a7,1
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c20:	4889                	li	a7,2
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c28:	488d                	li	a7,3
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c30:	4891                	li	a7,4
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <read>:
.global read
read:
 li a7, SYS_read
     c38:	4895                	li	a7,5
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <write>:
.global write
write:
 li a7, SYS_write
     c40:	48c1                	li	a7,16
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <close>:
.global close
close:
 li a7, SYS_close
     c48:	48d5                	li	a7,21
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c50:	4899                	li	a7,6
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c58:	489d                	li	a7,7
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <open>:
.global open
open:
 li a7, SYS_open
     c60:	48bd                	li	a7,15
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c68:	48c5                	li	a7,17
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c70:	48c9                	li	a7,18
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c78:	48a1                	li	a7,8
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <link>:
.global link
link:
 li a7, SYS_link
     c80:	48cd                	li	a7,19
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c88:	48d1                	li	a7,20
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c90:	48a5                	li	a7,9
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c98:	48a9                	li	a7,10
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ca0:	48ad                	li	a7,11
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ca8:	48b1                	li	a7,12
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     cb0:	48b5                	li	a7,13
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cb8:	48b9                	li	a7,14
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cc0:	1101                	addi	sp,sp,-32
     cc2:	ec06                	sd	ra,24(sp)
     cc4:	e822                	sd	s0,16(sp)
     cc6:	1000                	addi	s0,sp,32
     cc8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ccc:	4605                	li	a2,1
     cce:	fef40593          	addi	a1,s0,-17
     cd2:	f6fff0ef          	jal	c40 <write>
}
     cd6:	60e2                	ld	ra,24(sp)
     cd8:	6442                	ld	s0,16(sp)
     cda:	6105                	addi	sp,sp,32
     cdc:	8082                	ret

0000000000000cde <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     cde:	715d                	addi	sp,sp,-80
     ce0:	e486                	sd	ra,72(sp)
     ce2:	e0a2                	sd	s0,64(sp)
     ce4:	fc26                	sd	s1,56(sp)
     ce6:	f84a                	sd	s2,48(sp)
     ce8:	f44e                	sd	s3,40(sp)
     cea:	0880                	addi	s0,sp,80
     cec:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cee:	c299                	beqz	a3,cf4 <printint+0x16>
     cf0:	0605cf63          	bltz	a1,d6e <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cf4:	2581                	sext.w	a1,a1
  neg = 0;
     cf6:	4e01                	li	t3,0
  }

  i = 0;
     cf8:	fb840313          	addi	t1,s0,-72
  neg = 0;
     cfc:	869a                	mv	a3,t1
  i = 0;
     cfe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d00:	00001817          	auipc	a6,0x1
     d04:	84080813          	addi	a6,a6,-1984 # 1540 <digits>
     d08:	88be                	mv	a7,a5
     d0a:	0017851b          	addiw	a0,a5,1
     d0e:	87aa                	mv	a5,a0
     d10:	02c5f73b          	remuw	a4,a1,a2
     d14:	1702                	slli	a4,a4,0x20
     d16:	9301                	srli	a4,a4,0x20
     d18:	9742                	add	a4,a4,a6
     d1a:	00074703          	lbu	a4,0(a4)
     d1e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     d22:	872e                	mv	a4,a1
     d24:	02c5d5bb          	divuw	a1,a1,a2
     d28:	0685                	addi	a3,a3,1
     d2a:	fcc77fe3          	bgeu	a4,a2,d08 <printint+0x2a>
  if(neg)
     d2e:	000e0c63          	beqz	t3,d46 <printint+0x68>
    buf[i++] = '-';
     d32:	fd050793          	addi	a5,a0,-48
     d36:	00878533          	add	a0,a5,s0
     d3a:	02d00793          	li	a5,45
     d3e:	fef50423          	sb	a5,-24(a0)
     d42:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     d46:	fff7899b          	addiw	s3,a5,-1
     d4a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     d4e:	fff4c583          	lbu	a1,-1(s1)
     d52:	854a                	mv	a0,s2
     d54:	f6dff0ef          	jal	cc0 <putc>
  while(--i >= 0)
     d58:	39fd                	addiw	s3,s3,-1
     d5a:	14fd                	addi	s1,s1,-1
     d5c:	fe09d9e3          	bgez	s3,d4e <printint+0x70>
}
     d60:	60a6                	ld	ra,72(sp)
     d62:	6406                	ld	s0,64(sp)
     d64:	74e2                	ld	s1,56(sp)
     d66:	7942                	ld	s2,48(sp)
     d68:	79a2                	ld	s3,40(sp)
     d6a:	6161                	addi	sp,sp,80
     d6c:	8082                	ret
    x = -xx;
     d6e:	40b005bb          	negw	a1,a1
    neg = 1;
     d72:	4e05                	li	t3,1
    x = -xx;
     d74:	b751                	j	cf8 <printint+0x1a>

0000000000000d76 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d76:	711d                	addi	sp,sp,-96
     d78:	ec86                	sd	ra,88(sp)
     d7a:	e8a2                	sd	s0,80(sp)
     d7c:	e4a6                	sd	s1,72(sp)
     d7e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d80:	0005c483          	lbu	s1,0(a1)
     d84:	26048663          	beqz	s1,ff0 <vprintf+0x27a>
     d88:	e0ca                	sd	s2,64(sp)
     d8a:	fc4e                	sd	s3,56(sp)
     d8c:	f852                	sd	s4,48(sp)
     d8e:	f456                	sd	s5,40(sp)
     d90:	f05a                	sd	s6,32(sp)
     d92:	ec5e                	sd	s7,24(sp)
     d94:	e862                	sd	s8,16(sp)
     d96:	e466                	sd	s9,8(sp)
     d98:	8b2a                	mv	s6,a0
     d9a:	8a2e                	mv	s4,a1
     d9c:	8bb2                	mv	s7,a2
  state = 0;
     d9e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     da0:	4901                	li	s2,0
     da2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     da4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     da8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     dac:	06c00c93          	li	s9,108
     db0:	a00d                	j	dd2 <vprintf+0x5c>
        putc(fd, c0);
     db2:	85a6                	mv	a1,s1
     db4:	855a                	mv	a0,s6
     db6:	f0bff0ef          	jal	cc0 <putc>
     dba:	a019                	j	dc0 <vprintf+0x4a>
    } else if(state == '%'){
     dbc:	03598363          	beq	s3,s5,de2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     dc0:	0019079b          	addiw	a5,s2,1
     dc4:	893e                	mv	s2,a5
     dc6:	873e                	mv	a4,a5
     dc8:	97d2                	add	a5,a5,s4
     dca:	0007c483          	lbu	s1,0(a5)
     dce:	20048963          	beqz	s1,fe0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
     dd2:	0004879b          	sext.w	a5,s1
    if(state == 0){
     dd6:	fe0993e3          	bnez	s3,dbc <vprintf+0x46>
      if(c0 == '%'){
     dda:	fd579ce3          	bne	a5,s5,db2 <vprintf+0x3c>
        state = '%';
     dde:	89be                	mv	s3,a5
     de0:	b7c5                	j	dc0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     de2:	00ea06b3          	add	a3,s4,a4
     de6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     dec:	c681                	beqz	a3,df4 <vprintf+0x7e>
     dee:	9752                	add	a4,a4,s4
     df0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     df4:	03878e63          	beq	a5,s8,e30 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     df8:	05978863          	beq	a5,s9,e48 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     dfc:	07500713          	li	a4,117
     e00:	0ee78263          	beq	a5,a4,ee4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e04:	07800713          	li	a4,120
     e08:	12e78463          	beq	a5,a4,f30 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e0c:	07000713          	li	a4,112
     e10:	14e78963          	beq	a5,a4,f62 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e14:	07300713          	li	a4,115
     e18:	18e78863          	beq	a5,a4,fa8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e1c:	02500713          	li	a4,37
     e20:	04e79463          	bne	a5,a4,e68 <vprintf+0xf2>
        putc(fd, '%');
     e24:	85ba                	mv	a1,a4
     e26:	855a                	mv	a0,s6
     e28:	e99ff0ef          	jal	cc0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	bf49                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e30:	008b8493          	addi	s1,s7,8
     e34:	4685                	li	a3,1
     e36:	4629                	li	a2,10
     e38:	000ba583          	lw	a1,0(s7)
     e3c:	855a                	mv	a0,s6
     e3e:	ea1ff0ef          	jal	cde <printint>
     e42:	8ba6                	mv	s7,s1
      state = 0;
     e44:	4981                	li	s3,0
     e46:	bfad                	j	dc0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     e48:	06400793          	li	a5,100
     e4c:	02f68963          	beq	a3,a5,e7e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e50:	06c00793          	li	a5,108
     e54:	04f68263          	beq	a3,a5,e98 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     e58:	07500793          	li	a5,117
     e5c:	0af68063          	beq	a3,a5,efc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     e60:	07800793          	li	a5,120
     e64:	0ef68263          	beq	a3,a5,f48 <vprintf+0x1d2>
        putc(fd, '%');
     e68:	02500593          	li	a1,37
     e6c:	855a                	mv	a0,s6
     e6e:	e53ff0ef          	jal	cc0 <putc>
        putc(fd, c0);
     e72:	85a6                	mv	a1,s1
     e74:	855a                	mv	a0,s6
     e76:	e4bff0ef          	jal	cc0 <putc>
      state = 0;
     e7a:	4981                	li	s3,0
     e7c:	b791                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e7e:	008b8493          	addi	s1,s7,8
     e82:	4685                	li	a3,1
     e84:	4629                	li	a2,10
     e86:	000bb583          	ld	a1,0(s7)
     e8a:	855a                	mv	a0,s6
     e8c:	e53ff0ef          	jal	cde <printint>
        i += 1;
     e90:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e92:	8ba6                	mv	s7,s1
      state = 0;
     e94:	4981                	li	s3,0
        i += 1;
     e96:	b72d                	j	dc0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e98:	06400793          	li	a5,100
     e9c:	02f60763          	beq	a2,a5,eca <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ea0:	07500793          	li	a5,117
     ea4:	06f60963          	beq	a2,a5,f16 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ea8:	07800793          	li	a5,120
     eac:	faf61ee3          	bne	a2,a5,e68 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eb0:	008b8493          	addi	s1,s7,8
     eb4:	4681                	li	a3,0
     eb6:	4641                	li	a2,16
     eb8:	000bb583          	ld	a1,0(s7)
     ebc:	855a                	mv	a0,s6
     ebe:	e21ff0ef          	jal	cde <printint>
        i += 2;
     ec2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec4:	8ba6                	mv	s7,s1
      state = 0;
     ec6:	4981                	li	s3,0
        i += 2;
     ec8:	bde5                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eca:	008b8493          	addi	s1,s7,8
     ece:	4685                	li	a3,1
     ed0:	4629                	li	a2,10
     ed2:	000bb583          	ld	a1,0(s7)
     ed6:	855a                	mv	a0,s6
     ed8:	e07ff0ef          	jal	cde <printint>
        i += 2;
     edc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ede:	8ba6                	mv	s7,s1
      state = 0;
     ee0:	4981                	li	s3,0
        i += 2;
     ee2:	bdf9                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     ee4:	008b8493          	addi	s1,s7,8
     ee8:	4681                	li	a3,0
     eea:	4629                	li	a2,10
     eec:	000ba583          	lw	a1,0(s7)
     ef0:	855a                	mv	a0,s6
     ef2:	dedff0ef          	jal	cde <printint>
     ef6:	8ba6                	mv	s7,s1
      state = 0;
     ef8:	4981                	li	s3,0
     efa:	b5d9                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     efc:	008b8493          	addi	s1,s7,8
     f00:	4681                	li	a3,0
     f02:	4629                	li	a2,10
     f04:	000bb583          	ld	a1,0(s7)
     f08:	855a                	mv	a0,s6
     f0a:	dd5ff0ef          	jal	cde <printint>
        i += 1;
     f0e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f10:	8ba6                	mv	s7,s1
      state = 0;
     f12:	4981                	li	s3,0
        i += 1;
     f14:	b575                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f16:	008b8493          	addi	s1,s7,8
     f1a:	4681                	li	a3,0
     f1c:	4629                	li	a2,10
     f1e:	000bb583          	ld	a1,0(s7)
     f22:	855a                	mv	a0,s6
     f24:	dbbff0ef          	jal	cde <printint>
        i += 2;
     f28:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f2a:	8ba6                	mv	s7,s1
      state = 0;
     f2c:	4981                	li	s3,0
        i += 2;
     f2e:	bd49                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     f30:	008b8493          	addi	s1,s7,8
     f34:	4681                	li	a3,0
     f36:	4641                	li	a2,16
     f38:	000ba583          	lw	a1,0(s7)
     f3c:	855a                	mv	a0,s6
     f3e:	da1ff0ef          	jal	cde <printint>
     f42:	8ba6                	mv	s7,s1
      state = 0;
     f44:	4981                	li	s3,0
     f46:	bdad                	j	dc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f48:	008b8493          	addi	s1,s7,8
     f4c:	4681                	li	a3,0
     f4e:	4641                	li	a2,16
     f50:	000bb583          	ld	a1,0(s7)
     f54:	855a                	mv	a0,s6
     f56:	d89ff0ef          	jal	cde <printint>
        i += 1;
     f5a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f5c:	8ba6                	mv	s7,s1
      state = 0;
     f5e:	4981                	li	s3,0
        i += 1;
     f60:	b585                	j	dc0 <vprintf+0x4a>
     f62:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     f64:	008b8d13          	addi	s10,s7,8
     f68:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f6c:	03000593          	li	a1,48
     f70:	855a                	mv	a0,s6
     f72:	d4fff0ef          	jal	cc0 <putc>
  putc(fd, 'x');
     f76:	07800593          	li	a1,120
     f7a:	855a                	mv	a0,s6
     f7c:	d45ff0ef          	jal	cc0 <putc>
     f80:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f82:	00000b97          	auipc	s7,0x0
     f86:	5beb8b93          	addi	s7,s7,1470 # 1540 <digits>
     f8a:	03c9d793          	srli	a5,s3,0x3c
     f8e:	97de                	add	a5,a5,s7
     f90:	0007c583          	lbu	a1,0(a5)
     f94:	855a                	mv	a0,s6
     f96:	d2bff0ef          	jal	cc0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f9a:	0992                	slli	s3,s3,0x4
     f9c:	34fd                	addiw	s1,s1,-1
     f9e:	f4f5                	bnez	s1,f8a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     fa0:	8bea                	mv	s7,s10
      state = 0;
     fa2:	4981                	li	s3,0
     fa4:	6d02                	ld	s10,0(sp)
     fa6:	bd29                	j	dc0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     fa8:	008b8993          	addi	s3,s7,8
     fac:	000bb483          	ld	s1,0(s7)
     fb0:	cc91                	beqz	s1,fcc <vprintf+0x256>
        for(; *s; s++)
     fb2:	0004c583          	lbu	a1,0(s1)
     fb6:	c195                	beqz	a1,fda <vprintf+0x264>
          putc(fd, *s);
     fb8:	855a                	mv	a0,s6
     fba:	d07ff0ef          	jal	cc0 <putc>
        for(; *s; s++)
     fbe:	0485                	addi	s1,s1,1
     fc0:	0004c583          	lbu	a1,0(s1)
     fc4:	f9f5                	bnez	a1,fb8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
     fc6:	8bce                	mv	s7,s3
      state = 0;
     fc8:	4981                	li	s3,0
     fca:	bbdd                	j	dc0 <vprintf+0x4a>
          s = "(null)";
     fcc:	00000497          	auipc	s1,0x0
     fd0:	50c48493          	addi	s1,s1,1292 # 14d8 <malloc+0x3fc>
        for(; *s; s++)
     fd4:	02800593          	li	a1,40
     fd8:	b7c5                	j	fb8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
     fda:	8bce                	mv	s7,s3
      state = 0;
     fdc:	4981                	li	s3,0
     fde:	b3cd                	j	dc0 <vprintf+0x4a>
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6c42                	ld	s8,16(sp)
     fee:	6ca2                	ld	s9,8(sp)
    }
  }
}
     ff0:	60e6                	ld	ra,88(sp)
     ff2:	6446                	ld	s0,80(sp)
     ff4:	64a6                	ld	s1,72(sp)
     ff6:	6125                	addi	sp,sp,96
     ff8:	8082                	ret

0000000000000ffa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ffa:	715d                	addi	sp,sp,-80
     ffc:	ec06                	sd	ra,24(sp)
     ffe:	e822                	sd	s0,16(sp)
    1000:	1000                	addi	s0,sp,32
    1002:	e010                	sd	a2,0(s0)
    1004:	e414                	sd	a3,8(s0)
    1006:	e818                	sd	a4,16(s0)
    1008:	ec1c                	sd	a5,24(s0)
    100a:	03043023          	sd	a6,32(s0)
    100e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1012:	8622                	mv	a2,s0
    1014:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1018:	d5fff0ef          	jal	d76 <vprintf>
}
    101c:	60e2                	ld	ra,24(sp)
    101e:	6442                	ld	s0,16(sp)
    1020:	6161                	addi	sp,sp,80
    1022:	8082                	ret

0000000000001024 <printf>:

void
printf(const char *fmt, ...)
{
    1024:	711d                	addi	sp,sp,-96
    1026:	ec06                	sd	ra,24(sp)
    1028:	e822                	sd	s0,16(sp)
    102a:	1000                	addi	s0,sp,32
    102c:	e40c                	sd	a1,8(s0)
    102e:	e810                	sd	a2,16(s0)
    1030:	ec14                	sd	a3,24(s0)
    1032:	f018                	sd	a4,32(s0)
    1034:	f41c                	sd	a5,40(s0)
    1036:	03043823          	sd	a6,48(s0)
    103a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    103e:	00840613          	addi	a2,s0,8
    1042:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1046:	85aa                	mv	a1,a0
    1048:	4505                	li	a0,1
    104a:	d2dff0ef          	jal	d76 <vprintf>
}
    104e:	60e2                	ld	ra,24(sp)
    1050:	6442                	ld	s0,16(sp)
    1052:	6125                	addi	sp,sp,96
    1054:	8082                	ret

0000000000001056 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1056:	1141                	addi	sp,sp,-16
    1058:	e406                	sd	ra,8(sp)
    105a:	e022                	sd	s0,0(sp)
    105c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    105e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1062:	00001797          	auipc	a5,0x1
    1066:	fae7b783          	ld	a5,-82(a5) # 2010 <freep>
    106a:	a02d                	j	1094 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    106c:	4618                	lw	a4,8(a2)
    106e:	9f2d                	addw	a4,a4,a1
    1070:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1074:	6398                	ld	a4,0(a5)
    1076:	6310                	ld	a2,0(a4)
    1078:	a83d                	j	10b6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    107a:	ff852703          	lw	a4,-8(a0)
    107e:	9f31                	addw	a4,a4,a2
    1080:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1082:	ff053683          	ld	a3,-16(a0)
    1086:	a091                	j	10ca <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1088:	6398                	ld	a4,0(a5)
    108a:	00e7e463          	bltu	a5,a4,1092 <free+0x3c>
    108e:	00e6ea63          	bltu	a3,a4,10a2 <free+0x4c>
{
    1092:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1094:	fed7fae3          	bgeu	a5,a3,1088 <free+0x32>
    1098:	6398                	ld	a4,0(a5)
    109a:	00e6e463          	bltu	a3,a4,10a2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    109e:	fee7eae3          	bltu	a5,a4,1092 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    10a2:	ff852583          	lw	a1,-8(a0)
    10a6:	6390                	ld	a2,0(a5)
    10a8:	02059813          	slli	a6,a1,0x20
    10ac:	01c85713          	srli	a4,a6,0x1c
    10b0:	9736                	add	a4,a4,a3
    10b2:	fae60de3          	beq	a2,a4,106c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    10b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10ba:	4790                	lw	a2,8(a5)
    10bc:	02061593          	slli	a1,a2,0x20
    10c0:	01c5d713          	srli	a4,a1,0x1c
    10c4:	973e                	add	a4,a4,a5
    10c6:	fae68ae3          	beq	a3,a4,107a <free+0x24>
    p->s.ptr = bp->s.ptr;
    10ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10cc:	00001717          	auipc	a4,0x1
    10d0:	f4f73223          	sd	a5,-188(a4) # 2010 <freep>
}
    10d4:	60a2                	ld	ra,8(sp)
    10d6:	6402                	ld	s0,0(sp)
    10d8:	0141                	addi	sp,sp,16
    10da:	8082                	ret

00000000000010dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10dc:	7139                	addi	sp,sp,-64
    10de:	fc06                	sd	ra,56(sp)
    10e0:	f822                	sd	s0,48(sp)
    10e2:	f04a                	sd	s2,32(sp)
    10e4:	ec4e                	sd	s3,24(sp)
    10e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10e8:	02051993          	slli	s3,a0,0x20
    10ec:	0209d993          	srli	s3,s3,0x20
    10f0:	09bd                	addi	s3,s3,15
    10f2:	0049d993          	srli	s3,s3,0x4
    10f6:	2985                	addiw	s3,s3,1
    10f8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    10fa:	00001517          	auipc	a0,0x1
    10fe:	f1653503          	ld	a0,-234(a0) # 2010 <freep>
    1102:	c905                	beqz	a0,1132 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1104:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1106:	4798                	lw	a4,8(a5)
    1108:	09377663          	bgeu	a4,s3,1194 <malloc+0xb8>
    110c:	f426                	sd	s1,40(sp)
    110e:	e852                	sd	s4,16(sp)
    1110:	e456                	sd	s5,8(sp)
    1112:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1114:	8a4e                	mv	s4,s3
    1116:	6705                	lui	a4,0x1
    1118:	00e9f363          	bgeu	s3,a4,111e <malloc+0x42>
    111c:	6a05                	lui	s4,0x1
    111e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1122:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1126:	00001497          	auipc	s1,0x1
    112a:	eea48493          	addi	s1,s1,-278 # 2010 <freep>
  if(p == (char*)-1)
    112e:	5afd                	li	s5,-1
    1130:	a83d                	j	116e <malloc+0x92>
    1132:	f426                	sd	s1,40(sp)
    1134:	e852                	sd	s4,16(sp)
    1136:	e456                	sd	s5,8(sp)
    1138:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    113a:	00001797          	auipc	a5,0x1
    113e:	2ce78793          	addi	a5,a5,718 # 2408 <base>
    1142:	00001717          	auipc	a4,0x1
    1146:	ecf73723          	sd	a5,-306(a4) # 2010 <freep>
    114a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    114c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1150:	b7d1                	j	1114 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1152:	6398                	ld	a4,0(a5)
    1154:	e118                	sd	a4,0(a0)
    1156:	a899                	j	11ac <malloc+0xd0>
  hp->s.size = nu;
    1158:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    115c:	0541                	addi	a0,a0,16
    115e:	ef9ff0ef          	jal	1056 <free>
  return freep;
    1162:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1164:	c125                	beqz	a0,11c4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1166:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1168:	4798                	lw	a4,8(a5)
    116a:	03277163          	bgeu	a4,s2,118c <malloc+0xb0>
    if(p == freep)
    116e:	6098                	ld	a4,0(s1)
    1170:	853e                	mv	a0,a5
    1172:	fef71ae3          	bne	a4,a5,1166 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1176:	8552                	mv	a0,s4
    1178:	b31ff0ef          	jal	ca8 <sbrk>
  if(p == (char*)-1)
    117c:	fd551ee3          	bne	a0,s5,1158 <malloc+0x7c>
        return 0;
    1180:	4501                	li	a0,0
    1182:	74a2                	ld	s1,40(sp)
    1184:	6a42                	ld	s4,16(sp)
    1186:	6aa2                	ld	s5,8(sp)
    1188:	6b02                	ld	s6,0(sp)
    118a:	a03d                	j	11b8 <malloc+0xdc>
    118c:	74a2                	ld	s1,40(sp)
    118e:	6a42                	ld	s4,16(sp)
    1190:	6aa2                	ld	s5,8(sp)
    1192:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1194:	fae90fe3          	beq	s2,a4,1152 <malloc+0x76>
        p->s.size -= nunits;
    1198:	4137073b          	subw	a4,a4,s3
    119c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    119e:	02071693          	slli	a3,a4,0x20
    11a2:	01c6d713          	srli	a4,a3,0x1c
    11a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11ac:	00001717          	auipc	a4,0x1
    11b0:	e6a73223          	sd	a0,-412(a4) # 2010 <freep>
      return (void*)(p + 1);
    11b4:	01078513          	addi	a0,a5,16
  }
}
    11b8:	70e2                	ld	ra,56(sp)
    11ba:	7442                	ld	s0,48(sp)
    11bc:	7902                	ld	s2,32(sp)
    11be:	69e2                	ld	s3,24(sp)
    11c0:	6121                	addi	sp,sp,64
    11c2:	8082                	ret
    11c4:	74a2                	ld	s1,40(sp)
    11c6:	6a42                	ld	s4,16(sp)
    11c8:	6aa2                	ld	s5,8(sp)
    11ca:	6b02                	ld	s6,0(sp)
    11cc:	b7f5                	j	11b8 <malloc+0xdc>
