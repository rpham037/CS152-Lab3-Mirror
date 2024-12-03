
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 20 58 11 80       	mov    $0x80115820,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 75 43 00 00       	call   801043d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 23 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 f7 43 00 00       	call   801044e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 99 44 00 00       	call   80104600 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 41 00 00       	call   80104300 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 74 10 80       	push   $0x801074ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 dd 41 00 00       	call   801043a0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 74 10 80       	push   $0x801074ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 41 00 00       	call   801043a0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 4c 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 c0 42 00 00       	call   801044e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 8f 43 00 00       	jmp    80104600 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 75 10 80       	push   $0x80107506
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 3b 42 00 00       	call   801044e0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 8e 3d 00 00       	call   80104060 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 05 43 00 00       	call   80104600 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 af 42 00 00       	call   80104600 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 25 00 00       	call   80102910 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 75 10 80       	push   $0x8010750d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 3f 7e 10 80 	movl   $0x80107e3f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 40 00 00       	call   801043f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 75 10 80       	push   $0x80107521
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 59 00 00       	call   80105d30 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 58 00 00       	call   80105d30 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 58 00 00       	call   80105d30 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 58 00 00       	call   80105d30 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 9a 41 00 00       	call   801046f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 e5 40 00 00       	call   80104650 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 75 10 80       	push   $0x80107525
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 dc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 30 3f 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 17 40 00 00       	call   80104600 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ae 11 00 00       	call   801017a0 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 f3 3c 00 00       	call   801044e0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 75 10 80       	mov    $0x80107538,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 a0 3d 00 00       	call   80104600 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 75 10 80       	push   $0x8010753f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 48 3c 00 00       	call   801044e0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 2b 3c 00 00       	call   80104600 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 ed 37 00 00       	jmp    80104200 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 d7 36 00 00       	call   80104120 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 75 10 80       	push   $0x80107548
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 5b 39 00 00       	call   801043d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 02 1a 00 00       	call   801024a0 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 2e 00 00       	call   80103990 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 b4 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 e9 15 00 00       	call   801020c0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 21 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100b0f:	e8 dc 22 00 00       	call   80102df0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 87 63 00 00       	call   80106ec0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 38 61 00 00       	call   80106ce0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 12 60 00 00       	call   80106bf0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 aa 0e 00 00       	call   80101ab0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 20 62 00 00       	call   80106e40 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 9a 21 00 00       	call   80102df0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 79 60 00 00       	call   80106ce0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 d8 62 00 00       	call   80106f60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 78 3b 00 00       	call   80104850 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 64 3b 00 00       	call   80104850 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 23 64 00 00       	call   80107120 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 61 00 00       	call   80106e40 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 b8 63 00 00       	call   80107120 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 6a 3a 00 00       	call   80104810 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 8e 5c 00 00       	call   80106a60 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 60 00 00       	call   80106e40 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 07 20 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 75 10 80       	push   $0x80107561
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 75 10 80       	push   $0x8010756d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 ab 35 00 00       	call   801043d0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 9a 36 00 00       	call   801044e0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 8a 37 00 00       	call   80104600 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 71 37 00 00       	call   80104600 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 2c 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 2f 37 00 00       	call   80104600 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 75 10 80       	push   $0x80107574
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 da 35 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 bf 36 00 00       	call   80104600 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 8d 36 00 00       	jmp    80104600 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 03 1e 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 48 09 00 00       	call   801018d0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 59 1e 00 00       	jmp    80102df0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 a2 25 00 00       	call   80103550 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 7c 75 10 80       	push   $0x8010757c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 b6 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 89 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 80 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 51 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 54 0a 00 00       	call   80101ab0 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 0d 08 00 00       	call   80101880 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 5e 26 00 00       	jmp    801036f0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 75 10 80       	push   $0x80107586
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 77 07 00 00       	call   80101880 <iunlock>
      end_op();
80101109:	e8 e2 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 4d 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 62 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 60 0a 00 00       	call   80101bb0 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 1b 07 00 00       	call   80101880 <iunlock>
      end_op();
80101165:	e8 86 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 8f 75 10 80       	push   $0x8010758f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 42 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 95 75 10 80       	push   $0x80107595
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	push   -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	83 c4 10             	add    $0x10,%esp
801011fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101201:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
80101212:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101217:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	89 fa                	mov    %edi,%edx
8010122b:	85 df                	test   %ebx,%edi
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	push   -0x1c(%ebp)
80101247:	e8 a4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 9f 75 10 80       	push   $0x8010759f
80101269:	e8 12 f1 ff ff       	call   80100380 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 de 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	push   -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101295:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101298:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010129a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 a6 33 00 00       	call   80104650 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 ae 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 36 ef ff ff       	call   801001f0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012cf:	90                   	nop

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	89 c7                	mov    %eax,%edi
801012d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d7:	31 f6                	xor    %esi,%esi
{
801012d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 60 f9 10 80       	push   $0x8010f960
801012ea:	e8 f1 31 00 00       	call   801044e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012f2:	83 c4 10             	add    $0x10,%esp
801012f5:	eb 1b                	jmp    80101312 <iget+0x42>
801012f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012fe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101300:	39 3b                	cmp    %edi,(%ebx)
80101302:	74 6c                	je     80101370 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101304:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010130a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101310:	73 26                	jae    80101338 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101312:	8b 43 08             	mov    0x8(%ebx),%eax
80101315:	85 c0                	test   %eax,%eax
80101317:	7f e7                	jg     80101300 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e7                	jne    80101304 <iget+0x34>
8010131d:	85 c0                	test   %eax,%eax
8010131f:	75 76                	jne    80101397 <iget+0xc7>
80101321:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101323:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101329:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010132f:	72 e1                	jb     80101312 <iget+0x42>
80101331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101338:	85 f6                	test   %esi,%esi
8010133a:	74 79                	je     801013b5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010133c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010133f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101341:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101344:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010134b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101352:	68 60 f9 10 80       	push   $0x8010f960
80101357:	e8 a4 32 00 00       	call   80104600 <release>

  return ip;
8010135c:	83 c4 10             	add    $0x10,%esp
}
8010135f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101362:	89 f0                	mov    %esi,%eax
80101364:	5b                   	pop    %ebx
80101365:	5e                   	pop    %esi
80101366:	5f                   	pop    %edi
80101367:	5d                   	pop    %ebp
80101368:	c3                   	ret    
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 53 04             	cmp    %edx,0x4(%ebx)
80101373:	75 8f                	jne    80101304 <iget+0x34>
      release(&icache.lock);
80101375:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101378:	83 c0 01             	add    $0x1,%eax
      return ip;
8010137b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010137d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101382:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101385:	e8 76 32 00 00       	call   80104600 <release>
      return ip;
8010138a:	83 c4 10             	add    $0x10,%esp
}
8010138d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101390:	89 f0                	mov    %esi,%eax
80101392:	5b                   	pop    %ebx
80101393:	5e                   	pop    %esi
80101394:	5f                   	pop    %edi
80101395:	5d                   	pop    %ebp
80101396:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101397:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013a3:	73 10                	jae    801013b5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a5:	8b 43 08             	mov    0x8(%ebx),%eax
801013a8:	85 c0                	test   %eax,%eax
801013aa:	0f 8f 50 ff ff ff    	jg     80101300 <iget+0x30>
801013b0:	e9 68 ff ff ff       	jmp    8010131d <iget+0x4d>
    panic("iget: no inodes");
801013b5:	83 ec 0c             	sub    $0xc,%esp
801013b8:	68 b5 75 10 80       	push   $0x801075b5
801013bd:	e8 be ef ff ff       	call   80100380 <panic>
801013c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	89 c6                	mov    %eax,%esi
801013d7:	53                   	push   %ebx
801013d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013db:	83 fa 0b             	cmp    $0xb,%edx
801013de:	0f 86 8c 00 00 00    	jbe    80101470 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013e4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013e7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ea:	0f 87 a2 00 00 00    	ja     80101492 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013f6:	85 c0                	test   %eax,%eax
801013f8:	74 5e                	je     80101458 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013fa:	83 ec 08             	sub    $0x8,%esp
801013fd:	50                   	push   %eax
801013fe:	ff 36                	push   (%esi)
80101400:	e8 cb ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101405:	83 c4 10             	add    $0x10,%esp
80101408:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010140c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010140e:	8b 3b                	mov    (%ebx),%edi
80101410:	85 ff                	test   %edi,%edi
80101412:	74 1c                	je     80101430 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101414:	83 ec 0c             	sub    $0xc,%esp
80101417:	52                   	push   %edx
80101418:	e8 d3 ed ff ff       	call   801001f0 <brelse>
8010141d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101423:	89 f8                	mov    %edi,%eax
80101425:	5b                   	pop    %ebx
80101426:	5e                   	pop    %esi
80101427:	5f                   	pop    %edi
80101428:	5d                   	pop    %ebp
80101429:	c3                   	ret    
8010142a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101433:	8b 06                	mov    (%esi),%eax
80101435:	e8 86 fd ff ff       	call   801011c0 <balloc>
      log_write(bp);
8010143a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010143d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101440:	89 03                	mov    %eax,(%ebx)
80101442:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101444:	52                   	push   %edx
80101445:	e8 16 1b 00 00       	call   80102f60 <log_write>
8010144a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010144d:	83 c4 10             	add    $0x10,%esp
80101450:	eb c2                	jmp    80101414 <bmap+0x44>
80101452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101458:	8b 06                	mov    (%esi),%eax
8010145a:	e8 61 fd ff ff       	call   801011c0 <balloc>
8010145f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101465:	eb 93                	jmp    801013fa <bmap+0x2a>
80101467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101470:	8d 5a 14             	lea    0x14(%edx),%ebx
80101473:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101477:	85 ff                	test   %edi,%edi
80101479:	75 a5                	jne    80101420 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010147b:	8b 00                	mov    (%eax),%eax
8010147d:	e8 3e fd ff ff       	call   801011c0 <balloc>
80101482:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101486:	89 c7                	mov    %eax,%edi
}
80101488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148b:	5b                   	pop    %ebx
8010148c:	89 f8                	mov    %edi,%eax
8010148e:	5e                   	pop    %esi
8010148f:	5f                   	pop    %edi
80101490:	5d                   	pop    %ebp
80101491:	c3                   	ret    
  panic("bmap: out of range");
80101492:	83 ec 0c             	sub    $0xc,%esp
80101495:	68 c5 75 10 80       	push   $0x801075c5
8010149a:	e8 e1 ee ff ff       	call   80100380 <panic>
8010149f:	90                   	nop

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	89 d3                	mov    %edx,%ebx
801014aa:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801014ad:	6a 01                	push   $0x1
801014af:	50                   	push   %eax
801014b0:	e8 1b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801014b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801014b8:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
801014ba:	83 c0 5c             	add    $0x5c,%eax
801014bd:	6a 1c                	push   $0x1c
801014bf:	50                   	push   %eax
801014c0:	68 b4 15 11 80       	push   $0x801115b4
801014c5:	e8 26 32 00 00       	call   801046f0 <memmove>
  brelse(bp);
801014ca:	89 3c 24             	mov    %edi,(%esp)
801014cd:	e8 1e ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
801014d2:	58                   	pop    %eax
801014d3:	89 d8                	mov    %ebx,%eax
801014d5:	5a                   	pop    %edx
801014d6:	c1 e8 0c             	shr    $0xc,%eax
801014d9:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801014df:	50                   	push   %eax
801014e0:	56                   	push   %esi
801014e1:	e8 ea eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014e6:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e8:	c1 fb 03             	sar    $0x3,%ebx
801014eb:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014ee:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014f0:	83 e1 07             	and    $0x7,%ecx
801014f3:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014fe:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101500:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101505:	85 c1                	test   %eax,%ecx
80101507:	74 24                	je     8010152d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101509:	f7 d0                	not    %eax
  log_write(bp);
8010150b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010150e:	21 c8                	and    %ecx,%eax
80101510:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101514:	56                   	push   %esi
80101515:	e8 46 1a 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010151a:	89 34 24             	mov    %esi,(%esp)
8010151d:	e8 ce ec ff ff       	call   801001f0 <brelse>
}
80101522:	83 c4 10             	add    $0x10,%esp
80101525:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101528:	5b                   	pop    %ebx
80101529:	5e                   	pop    %esi
8010152a:	5f                   	pop    %edi
8010152b:	5d                   	pop    %ebp
8010152c:	c3                   	ret    
    panic("freeing free block");
8010152d:	83 ec 0c             	sub    $0xc,%esp
80101530:	68 d8 75 10 80       	push   $0x801075d8
80101535:	e8 46 ee ff ff       	call   80100380 <panic>
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 8a 31 00 00       	call   801046f0 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 eb 75 10 80       	push   $0x801075eb
80101591:	68 60 f9 10 80       	push   $0x8010f960
80101596:	e8 35 2e 00 00       	call   801043d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 f2 75 10 80       	push   $0x801075f2
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 0c 2d 00 00       	call   801042c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 15 11 80       	push   $0x801115b4
801015dc:	e8 0f 31 00 00       	call   801046f0 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 15 11 80    	push   0x801115cc
801015ef:	ff 35 c8 15 11 80    	push   0x801115c8
801015f5:	ff 35 c4 15 11 80    	push   0x801115c4
801015fb:	ff 35 c0 15 11 80    	push   0x801115c0
80101601:	ff 35 bc 15 11 80    	push   0x801115bc
80101607:	ff 35 b8 15 11 80    	push   0x801115b8
8010160d:	ff 35 b4 15 11 80    	push   0x801115b4
80101613:	68 58 76 10 80       	push   $0x80107658
80101618:	e8 83 f0 ff ff       	call   801006a0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave  
80101624:	c3                   	ret    
80101625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 9d 2f 00 00       	call   80104650 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 9b 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 f0 fb ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 f8 75 10 80       	push   $0x801075f8
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 9a 2f 00 00       	call   801046f0 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 02 18 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 f9 10 80       	push   $0x8010f960
8010177f:	e8 5c 2d 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010178f:	e8 6c 2e 00 00       	call   80104600 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave  
8010179a:	c3                   	ret    
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 39 2b 00 00       	call   80104300 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret    
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 b3 2e 00 00       	call   801046f0 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 10 76 10 80       	push   $0x80107610
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 0a 76 10 80       	push   $0x8010760a
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 08 2b 00 00       	call   801043a0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 ac 2a 00 00       	jmp    80104360 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 1f 76 10 80       	push   $0x8010761f
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 1b 2a 00 00       	call   80104300 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 61 2a 00 00       	call   80104360 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101906:	e8 d5 2b 00 00       	call   801044e0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 db 2c 00 00       	jmp    80104600 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 f9 10 80       	push   $0x8010f960
80101930:	e8 ab 2b 00 00       	call   801044e0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010193f:	e8 bc 2c 00 00       	call   80104600 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x97>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 fe                	cmp    %edi,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 03                	mov    (%ebx),%eax
8010196f:	e8 2c fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2d                	jne    801019ba <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101990:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101997:	53                   	push   %ebx
80101998:	e8 53 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199d:	31 c0                	xor    %eax,%eax
8010199f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a3:	89 1c 24             	mov    %ebx,(%esp)
801019a6:	e8 45 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b2:	83 c4 10             	add    $0x10,%esp
801019b5:	e9 3c ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ba:	83 ec 08             	sub    $0x8,%esp
801019bd:	50                   	push   %eax
801019be:	ff 33                	push   (%ebx)
801019c0:	e8 0b e7 ff ff       	call   801000d0 <bread>
801019c5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d7:	89 cf                	mov    %ecx,%edi
801019d9:	eb 0c                	jmp    801019e7 <iput+0x117>
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 ac fa ff ff       	call   801014a0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	ff 75 e4             	push   -0x1c(%ebp)
801019fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ff:	e8 ec e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a04:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0a:	8b 03                	mov    (%ebx),%eax
80101a0c:	e8 8f fa ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1b:	00 00 00 
80101a1e:	e9 6a ff ff ff       	jmp    8010198d <iput+0xbd>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 58 29 00 00       	call   801043a0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 01 29 00 00       	call   80104360 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 1f 76 10 80       	push   $0x8010761f
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 a7 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	8b 40 58             	mov    0x58(%eax),%eax
80101adf:	39 c6                	cmp    %eax,%esi
80101ae1:	0f 87 ba 00 00 00    	ja     80101ba1 <readi+0xf1>
80101ae7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aea:	31 c9                	xor    %ecx,%ecx
80101aec:	89 da                	mov    %ebx,%edx
80101aee:	01 f2                	add    %esi,%edx
80101af0:	0f 92 c1             	setb   %cl
80101af3:	89 cf                	mov    %ecx,%edi
80101af5:	0f 82 a6 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101afb:	89 c1                	mov    %eax,%ecx
80101afd:	29 f1                	sub    %esi,%ecx
80101aff:	39 d0                	cmp    %edx,%eax
80101b01:	0f 43 cb             	cmovae %ebx,%ecx
80101b04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b07:	85 c9                	test   %ecx,%ecx
80101b09:	74 67                	je     80101b72 <readi+0xc2>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 b1 f8 ff ff       	call   801013d0 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f0                	mov    %esi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b40:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	39 d9                	cmp    %ebx,%ecx
80101b48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4b:	83 c4 0c             	add    $0xc,%esp
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 94 2b 00 00       	call   801046f0 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bbf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd3:	0f 84 b7 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	0f 87 e7 00 00 00    	ja     80101ccc <writei+0x11c>
80101be5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be8:	31 d2                	xor    %edx,%edx
80101bea:	89 f8                	mov    %edi,%eax
80101bec:	01 f0                	add    %esi,%eax
80101bee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bf6:	0f 87 d0 00 00 00    	ja     80101ccc <writei+0x11c>
80101bfc:	85 d2                	test   %edx,%edx
80101bfe:	0f 85 c8 00 00 00    	jne    80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c0b:	85 ff                	test   %edi,%edi
80101c0d:	74 72                	je     80101c81 <writei+0xd1>
80101c0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 b1 f7 ff ff       	call   801013d0 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	push   (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c40:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	39 d9                	cmp    %ebx,%ecx
80101c46:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	push   -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 98 2a 00 00       	call   801046f0 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 00 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ce6:	6a 0e                	push   $0xe
80101ce8:	ff 75 0c             	push   0xc(%ebp)
80101ceb:	ff 75 08             	push   0x8(%ebp)
80101cee:	e8 6d 2a 00 00       	call   80104760 <strncmp>
}
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    
80101cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d11:	0f 85 85 00 00 00    	jne    80101d9c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d17:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1a:	31 ff                	xor    %edi,%edi
80101d1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d1f:	85 d2                	test   %edx,%edx
80101d21:	74 3e                	je     80101d61 <dirlookup+0x61>
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d28:	6a 10                	push   $0x10
80101d2a:	57                   	push   %edi
80101d2b:	56                   	push   %esi
80101d2c:	53                   	push   %ebx
80101d2d:	e8 7e fd ff ff       	call   80101ab0 <readi>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	83 f8 10             	cmp    $0x10,%eax
80101d38:	75 55                	jne    80101d8f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d3f:	74 18                	je     80101d59 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d41:	83 ec 04             	sub    $0x4,%esp
80101d44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d47:	6a 0e                	push   $0xe
80101d49:	50                   	push   %eax
80101d4a:	ff 75 0c             	push   0xc(%ebp)
80101d4d:	e8 0e 2a 00 00       	call   80104760 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	85 c0                	test   %eax,%eax
80101d57:	74 17                	je     80101d70 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d59:	83 c7 10             	add    $0x10,%edi
80101d5c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d5f:	72 c7                	jb     80101d28 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d64:	31 c0                	xor    %eax,%eax
}
80101d66:	5b                   	pop    %ebx
80101d67:	5e                   	pop    %esi
80101d68:	5f                   	pop    %edi
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
      if(poff)
80101d70:	8b 45 10             	mov    0x10(%ebp),%eax
80101d73:	85 c0                	test   %eax,%eax
80101d75:	74 05                	je     80101d7c <dirlookup+0x7c>
        *poff = off;
80101d77:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d7c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d80:	8b 03                	mov    (%ebx),%eax
80101d82:	e8 49 f5 ff ff       	call   801012d0 <iget>
}
80101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8a:	5b                   	pop    %ebx
80101d8b:	5e                   	pop    %esi
80101d8c:	5f                   	pop    %edi
80101d8d:	5d                   	pop    %ebp
80101d8e:	c3                   	ret    
      panic("dirlookup read");
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	68 39 76 10 80       	push   $0x80107639
80101d97:	e8 e4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 27 76 10 80       	push   $0x80107627
80101da4:	e8 d7 e5 ff ff       	call   80100380 <panic>
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 64 01 00 00    	je     80101f2e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 c1 1b 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dd2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd5:	68 60 f9 10 80       	push   $0x8010f960
80101dda:	e8 01 27 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101ddf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dea:	e8 11 28 00 00       	call   80104600 <release>
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	eb 07                	jmp    80101dfb <namex+0x4b>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101df8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dfb:	0f b6 03             	movzbl (%ebx),%eax
80101dfe:	3c 2f                	cmp    $0x2f,%al
80101e00:	74 f6                	je     80101df8 <namex+0x48>
  if(*path == 0)
80101e02:	84 c0                	test   %al,%al
80101e04:	0f 84 06 01 00 00    	je     80101f10 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e0a:	0f b6 03             	movzbl (%ebx),%eax
80101e0d:	84 c0                	test   %al,%al
80101e0f:	0f 84 10 01 00 00    	je     80101f25 <namex+0x175>
80101e15:	89 df                	mov    %ebx,%edi
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	0f 84 06 01 00 00    	je     80101f25 <namex+0x175>
80101e1f:	90                   	nop
80101e20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e24:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x7f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x70>
  len = path - s;
80101e2f:	89 f8                	mov    %edi,%eax
80101e31:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e ac 00 00 00    	jle    80101ee8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	53                   	push   %ebx
    path++;
80101e42:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	push   -0x1c(%ebp)
80101e47:	e8 a4 28 00 00       	call   801046f0 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e52:	75 0c                	jne    80101e60 <namex+0xb0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e5e:	74 f8                	je     80101e58 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 37 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 cd 00 00 00    	jne    80101f44 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 09                	je     80101e87 <namex+0xd7>
80101e7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e81:	0f 84 22 01 00 00    	je     80101fa9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	push   -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 6b fe ff ff       	call   80101d00 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	89 c7                	mov    %eax,%edi
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	0f 84 e1 00 00 00    	je     80101f86 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eab:	52                   	push   %edx
80101eac:	e8 ef 24 00 00       	call   801043a0 <holdingsleep>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	85 c0                	test   %eax,%eax
80101eb6:	0f 84 30 01 00 00    	je     80101fec <namex+0x23c>
80101ebc:	8b 56 08             	mov    0x8(%esi),%edx
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	0f 8e 25 01 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	52                   	push   %edx
80101ece:	e8 8d 24 00 00       	call   80104360 <releasesleep>
  iput(ip);
80101ed3:	89 34 24             	mov    %esi,(%esp)
80101ed6:	89 fe                	mov    %edi,%esi
80101ed8:	e8 f3 f9 ff ff       	call   801018d0 <iput>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	e9 16 ff ff ff       	jmp    80101dfb <namex+0x4b>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eeb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101eee:	83 ec 04             	sub    $0x4,%esp
80101ef1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
    name[len] = 0;
80101ef6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ef8:	ff 75 e4             	push   -0x1c(%ebp)
80101efb:	e8 f0 27 00 00       	call   801046f0 <memmove>
    name[len] = 0;
80101f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 02 00             	movb   $0x0,(%edx)
80101f09:	e9 41 ff ff ff       	jmp    80101e4f <namex+0x9f>
80101f0e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 be 00 00 00    	jne    80101fd9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f28:	89 df                	mov    %ebx,%edi
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb c0                	jmp    80101eee <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f33:	b8 01 00 00 00       	mov    $0x1,%eax
80101f38:	e8 93 f3 ff ff       	call   801012d0 <iget>
80101f3d:	89 c6                	mov    %eax,%esi
80101f3f:	e9 b7 fe ff ff       	jmp    80101dfb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f4a:	53                   	push   %ebx
80101f4b:	e8 50 24 00 00       	call   801043a0 <holdingsleep>
80101f50:	83 c4 10             	add    $0x10,%esp
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 84 91 00 00 00    	je     80101fec <namex+0x23c>
80101f5b:	8b 46 08             	mov    0x8(%esi),%eax
80101f5e:	85 c0                	test   %eax,%eax
80101f60:	0f 8e 86 00 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	53                   	push   %ebx
80101f6a:	e8 f1 23 00 00       	call   80104360 <releasesleep>
  iput(ip);
80101f6f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f72:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f74:	e8 57 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f86:	83 ec 0c             	sub    $0xc,%esp
80101f89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f8c:	52                   	push   %edx
80101f8d:	e8 0e 24 00 00       	call   801043a0 <holdingsleep>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 53                	je     80101fec <namex+0x23c>
80101f99:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f9c:	85 c9                	test   %ecx,%ecx
80101f9e:	7e 4c                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	52                   	push   %edx
80101fa7:	eb c1                	jmp    80101f6a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faf:	53                   	push   %ebx
80101fb0:	e8 eb 23 00 00       	call   801043a0 <holdingsleep>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	74 30                	je     80101fec <namex+0x23c>
80101fbc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fbf:	85 ff                	test   %edi,%edi
80101fc1:	7e 29                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fc3:	83 ec 0c             	sub    $0xc,%esp
80101fc6:	53                   	push   %ebx
80101fc7:	e8 94 23 00 00       	call   80104360 <releasesleep>
}
80101fcc:	83 c4 10             	add    $0x10,%esp
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
    iput(ip);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	56                   	push   %esi
    return 0;
80101fdd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fdf:	e8 ec f8 ff ff       	call   801018d0 <iput>
    return 0;
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 2f ff ff ff       	jmp    80101f1b <namex+0x16b>
    panic("iunlock");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 1f 76 10 80       	push   $0x8010761f
80101ff4:	e8 87 e3 ff ff       	call   80100380 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 20             	sub    $0x20,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010200c:	6a 00                	push   $0x0
8010200e:	ff 75 0c             	push   0xc(%ebp)
80102011:	53                   	push   %ebx
80102012:	e8 e9 fc ff ff       	call   80101d00 <dirlookup>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	75 67                	jne    80102085 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010201e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102021:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102024:	85 ff                	test   %edi,%edi
80102026:	74 29                	je     80102051 <dirlink+0x51>
80102028:	31 ff                	xor    %edi,%edi
8010202a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010202d:	eb 09                	jmp    80102038 <dirlink+0x38>
8010202f:	90                   	nop
80102030:	83 c7 10             	add    $0x10,%edi
80102033:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102036:	73 19                	jae    80102051 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102038:	6a 10                	push   $0x10
8010203a:	57                   	push   %edi
8010203b:	56                   	push   %esi
8010203c:	53                   	push   %ebx
8010203d:	e8 6e fa ff ff       	call   80101ab0 <readi>
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	83 f8 10             	cmp    $0x10,%eax
80102048:	75 4e                	jne    80102098 <dirlink+0x98>
    if(de.inum == 0)
8010204a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010204f:	75 df                	jne    80102030 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102051:	83 ec 04             	sub    $0x4,%esp
80102054:	8d 45 da             	lea    -0x26(%ebp),%eax
80102057:	6a 0e                	push   $0xe
80102059:	ff 75 0c             	push   0xc(%ebp)
8010205c:	50                   	push   %eax
8010205d:	e8 4e 27 00 00       	call   801047b0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102062:	6a 10                	push   $0x10
  de.inum = inum;
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
  de.inum = inum;
8010206a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206e:	e8 3d fb ff ff       	call   80101bb0 <writei>
80102073:	83 c4 20             	add    $0x20,%esp
80102076:	83 f8 10             	cmp    $0x10,%eax
80102079:	75 2a                	jne    801020a5 <dirlink+0xa5>
  return 0;
8010207b:	31 c0                	xor    %eax,%eax
}
8010207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
    iput(ip);
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	50                   	push   %eax
80102089:	e8 42 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010208e:	83 c4 10             	add    $0x10,%esp
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb e5                	jmp    8010207d <dirlink+0x7d>
      panic("dirlink read");
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	68 48 76 10 80       	push   $0x80107648
801020a0:	e8 db e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 26 7c 10 80       	push   $0x80107c26
801020ad:	e8 ce e2 ff ff       	call   80100380 <panic>
801020b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c1:	31 d2                	xor    %edx,%edx
{
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ce:	e8 dd fc ff ff       	call   80101db0 <namex>
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    
801020d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	55                   	push   %ebp
  return namex(path, 1, name);
801020e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ef:	e9 bc fc ff ff       	jmp    80101db0 <namex>
801020f4:	66 90                	xchg   %ax,%ax
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212e:	66 90                	xchg   %ax,%ax
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret    
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld    
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret    
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 b4 76 10 80       	push   $0x801076b4
801021c0:	e8 bb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 ab 76 10 80       	push   $0x801076ab
801021cd:	e8 ae e1 ff ff       	call   80100380 <panic>
801021d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021e0 <ideinit>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021e6:	68 c6 76 10 80       	push   $0x801076c6
801021eb:	68 00 16 11 80       	push   $0x80111600
801021f0:	e8 db 21 00 00       	call   801043d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f5:	58                   	pop    %eax
801021f6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021fb:	5a                   	pop    %edx
801021fc:	83 e8 01             	sub    $0x1,%eax
801021ff:	50                   	push   %eax
80102200:	6a 0e                	push   $0xe
80102202:	e8 99 02 00 00       	call   801024a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102207:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220f:	90                   	nop
80102210:	ec                   	in     (%dx),%al
80102211:	83 e0 c0             	and    $0xffffffc0,%eax
80102214:	3c 40                	cmp    $0x40,%al
80102216:	75 f8                	jne    80102210 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102222:	ee                   	out    %al,(%dx)
80102223:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102228:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222d:	eb 06                	jmp    80102235 <ideinit+0x55>
8010222f:	90                   	nop
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x64>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x50>
      havedisk1 = 1;
8010223a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 16 11 80       	push   $0x80111600
8010226e:	e8 6d 22 00 00       	call   801044e0 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229e:	66 90                	xchg   %ax,%ax
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld    
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 4e 1e 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 1d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 16 11 80       	push   $0x80111600
801022eb:	e8 10 23 00 00       	call   80104600 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 8d 20 00 00       	call   801043a0 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 16 11 80       	push   $0x80111600
80102348:	e8 93 21 00 00       	call   801044e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 16 11 80       	push   $0x80111600
80102388:	53                   	push   %ebx
80102389:	e8 d2 1c 00 00       	call   80104060 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 55 22 00 00       	jmp    80104600 <release>
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 f5 76 10 80       	push   $0x801076f5
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 e0 76 10 80       	push   $0x801076e0
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 ca 76 10 80       	push   $0x801076ca
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 14 77 10 80       	push   $0x80107714
8010243f:	e8 5c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	83 c6 21             	add    $0x21,%esi
{
80102450:	ba 10 00 00 00       	mov    $0x10,%edx
80102455:	b8 20 00 00 00       	mov    $0x20,%eax
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102462:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102464:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010246a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010246d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102473:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102476:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102479:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010247c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010247e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102484:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248b:	39 f0                	cmp    %esi,%eax
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb 20 58 11 80    	cmp    $0x80115820,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 39 21 00 00       	call   80104650 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 16 11 80       	mov    0x80111678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 16 11 80       	push   $0x80111640
80102548:	e8 93 1f 00 00       	call   801044e0 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
    release(&kmem.lock);
80102563:	e9 98 20 00 00       	jmp    80104600 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 46 77 10 80       	push   $0x80107746
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 d3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 4c 77 10 80       	push   $0x8010774c
80102640:	68 40 16 11 80       	push   $0x80111640
80102645:	e8 86 1d 00 00       	call   801043d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102650:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102657:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 5b fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026a0:	a1 74 16 11 80       	mov    0x80111674,%eax
801026a5:	85 c0                	test   %eax,%eax
801026a7:	75 1f                	jne    801026c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a9:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801026ae:	85 c0                	test   %eax,%eax
801026b0:	74 0e                	je     801026c0 <kalloc+0x20>
    kmem.freelist = r->next;
801026b2:	8b 10                	mov    (%eax),%edx
801026b4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026c0:	c3                   	ret    
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ce:	68 40 16 11 80       	push   $0x80111640
801026d3:	e8 08 1e 00 00       	call   801044e0 <acquire>
  r = kmem.freelist;
801026d8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026dd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	85 c0                	test   %eax,%eax
801026e8:	74 08                	je     801026f2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ea:	8b 08                	mov    (%eax),%ecx
801026ec:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026f2:	85 d2                	test   %edx,%edx
801026f4:	74 16                	je     8010270c <kalloc+0x6c>
    release(&kmem.lock);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026fc:	68 40 16 11 80       	push   $0x80111640
80102701:	e8 fa 1e 00 00       	call   80104600 <release>
  return (char*)r;
80102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	c9                   	leave  
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 80 78 10 80 	movzbl -0x7fef8780(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 80 77 10 80 	movzbl -0x7fef8880(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave  
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
}
801027b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027bc:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027c1:	31 c0                	xor    %eax,%eax
}
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret    
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret    
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 80 e0 ff ff       	call   80100880 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 16 11 80       	mov    0x80111680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 cb 00 00 00    	je     801028e8 <lapicinit+0xd8>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	c1 ea 10             	shr    $0x10,%edx
80102871:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102877:	75 77                	jne    801028f0 <lapicinit+0xe0>
  lapic[index] = value;
80102879:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102880:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102886:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102890:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102893:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
801028c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028d6:	80 e6 10             	and    $0x10,%dh
801028d9:	75 f5                	jne    801028d0 <lapicinit+0xc0>
  lapic[index] = value;
801028db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e8:	c3                   	ret    
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028fd:	e9 77 ff ff ff       	jmp    80102879 <lapicinit+0x69>
80102902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102910:	a1 80 16 11 80       	mov    0x80111680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 07                	je     80102920 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102919:	8b 40 20             	mov    0x20(%eax),%eax
8010291c:	c1 e8 18             	shr    $0x18,%eax
8010291f:	c3                   	ret    
    return 0;
80102920:	31 c0                	xor    %eax,%eax
}
80102922:	c3                   	ret    
80102923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102930:	a1 80 16 11 80       	mov    0x80111680,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	74 0d                	je     80102946 <lapiceoi+0x16>
  lapic[index] = value;
80102939:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102946:	c3                   	ret    
80102947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294e:	66 90                	xchg   %ax,%ax

80102950 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102950:	c3                   	ret    
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102961:	b8 0f 00 00 00       	mov    $0xf,%eax
80102966:	ba 70 00 00 00       	mov    $0x70,%edx
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	53                   	push   %ebx
8010296e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102974:	ee                   	out    %al,(%dx)
80102975:	b8 0a 00 00 00       	mov    $0xa,%eax
8010297a:	ba 71 00 00 00       	mov    $0x71,%edx
8010297f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102980:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102982:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102985:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010298b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010298d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102990:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102992:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102995:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102998:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010299e:	a1 80 16 11 80       	mov    0x80111680,%eax
801029a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave  
801029ee:	c3                   	ret    
801029ef:	90                   	nop

801029f0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801029f0:	55                   	push   %ebp
801029f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	57                   	push   %edi
801029fe:	56                   	push   %esi
801029ff:	53                   	push   %ebx
80102a00:	83 ec 4c             	sub    $0x4c,%esp
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	ba 71 00 00 00       	mov    $0x71,%edx
80102a09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a15:	8d 76 00             	lea    0x0(%esi),%esi
80102a18:	31 c0                	xor    %eax,%eax
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a28:	89 da                	mov    %ebx,%edx
80102a2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
80102a33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 da                	mov    %ebx,%edx
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
80102a41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	b8 08 00 00 00       	mov    $0x8,%eax
80102a59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
80102a5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5f:	89 da                	mov    %ebx,%edx
80102a61:	b8 09 00 00 00       	mov    $0x9,%eax
80102a66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a67:	89 ca                	mov    %ecx,%edx
80102a69:	ec                   	in     (%dx),%al
80102a6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a77:	84 c0                	test   %al,%al
80102a79:	78 9d                	js     80102a18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	0f b6 fa             	movzbl %dl,%edi
80102a84:	89 f2                	mov    %esi,%edx
80102a86:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a89:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a8d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 da                	mov    %ebx,%edx
80102a92:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a95:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a98:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a9c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aa2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aa6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa9:	31 c0                	xor    %eax,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ab7:	b8 02 00 00 00       	mov    $0x2,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac3:	89 da                	mov    %ebx,%edx
80102ac5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ade:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adf:	89 ca                	mov    %ecx,%edx
80102ae1:	ec                   	in     (%dx),%al
80102ae2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aea:	b8 08 00 00 00       	mov    $0x8,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 da                	mov    %ebx,%edx
80102af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102afb:	b8 09 00 00 00       	mov    $0x9,%eax
80102b00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b01:	89 ca                	mov    %ecx,%edx
80102b03:	ec                   	in     (%dx),%al
80102b04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b10:	6a 18                	push   $0x18
80102b12:	50                   	push   %eax
80102b13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b16:	50                   	push   %eax
80102b17:	e8 84 1b 00 00       	call   801046a0 <memcmp>
80102b1c:	83 c4 10             	add    $0x10,%esp
80102b1f:	85 c0                	test   %eax,%eax
80102b21:	0f 85 f1 fe ff ff    	jne    80102a18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b2b:	75 78                	jne    80102ba5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bab:	89 06                	mov    %eax,(%esi)
80102bad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb0:	89 46 04             	mov    %eax,0x4(%esi)
80102bb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb6:	89 46 08             	mov    %eax,0x8(%esi)
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc2:	89 46 10             	mov    %eax,0x10(%esi)
80102bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bcb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bd5:	5b                   	pop    %ebx
80102bd6:	5e                   	pop    %esi
80102bd7:	5f                   	pop    %edi
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c24:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 a7 1a 00 00       	call   801046f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 d4 16 11 80    	push   0x801116d4
80102c8d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 2c             	sub    $0x2c,%esp
80102ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cea:	68 80 79 10 80       	push   $0x80107980
80102cef:	68 a0 16 11 80       	push   $0x801116a0
80102cf4:	e8 d7 16 00 00       	call   801043d0 <initlock>
  readsb(dev, &sb);
80102cf9:	58                   	pop    %eax
80102cfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 3b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d08:	59                   	pop    %ecx
  log.dev = dev;
80102d09:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d12:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d17:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 ab d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d28:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d2b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d31:	85 db                	test   %ebx,%ebx
80102d33:	7e 1d                	jle    80102d52 <initlog+0x72>
80102d35:	31 d2                	xor    %edx,%edx
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d40:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d44:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d3                	cmp    %edx,%ebx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d86:	68 a0 16 11 80       	push   $0x801116a0
80102d8b:	e8 50 17 00 00       	call   801044e0 <acquire>
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	eb 18                	jmp    80102dad <begin_op+0x2d>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d98:	83 ec 08             	sub    $0x8,%esp
80102d9b:	68 a0 16 11 80       	push   $0x801116a0
80102da0:	68 a0 16 11 80       	push   $0x801116a0
80102da5:	e8 b6 12 00 00       	call   80104060 <sleep>
80102daa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dad:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102db2:	85 c0                	test   %eax,%eax
80102db4:	75 e2                	jne    80102d98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102db6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dbb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102dc1:	83 c0 01             	add    $0x1,%eax
80102dc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dca:	83 fa 1e             	cmp    $0x1e,%edx
80102dcd:	7f c9                	jg     80102d98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dcf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dd2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102dd7:	68 a0 16 11 80       	push   $0x801116a0
80102ddc:	e8 1f 18 00 00       	call   80104600 <release>
      break;
    }
  }
}
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	c9                   	leave  
80102de5:	c3                   	ret    
80102de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ded:	8d 76 00             	lea    0x0(%esi),%esi

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	57                   	push   %edi
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102df9:	68 a0 16 11 80       	push   $0x801116a0
80102dfe:	e8 dd 16 00 00       	call   801044e0 <acquire>
  log.outstanding -= 1;
80102e03:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e08:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e11:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e14:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e1a:	85 f6                	test   %esi,%esi
80102e1c:	0f 85 22 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e22:	85 db                	test   %ebx,%ebx
80102e24:	0f 85 f6 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e31:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	68 a0 16 11 80       	push   $0x801116a0
80102e3c:	e8 bf 17 00 00       	call   80104600 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e41:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e47:	83 c4 10             	add    $0x10,%esp
80102e4a:	85 c9                	test   %ecx,%ecx
80102e4c:	7f 42                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e4e:	83 ec 0c             	sub    $0xc,%esp
80102e51:	68 a0 16 11 80       	push   $0x801116a0
80102e56:	e8 85 16 00 00       	call   801044e0 <acquire>
    wakeup(&log);
80102e5b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e62:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e69:	00 00 00 
    wakeup(&log);
80102e6c:	e8 af 12 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102e71:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e78:	e8 83 17 00 00       	call   80104600 <release>
80102e7d:	83 c4 10             	add    $0x10,%esp
}
80102e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e83:	5b                   	pop    %ebx
80102e84:	5e                   	pop    %esi
80102e85:	5f                   	pop    %edi
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    
80102e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 e4 16 11 80    	push   0x801116e4
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102eb4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 17 18 00 00       	call   801046f0 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 34 ff ff ff       	jmp    80102e4e <end_op+0x5e>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 a0 16 11 80       	push   $0x801116a0
80102f28:	e8 f3 11 00 00       	call   80104120 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f34:	e8 c7 16 00 00       	call   80104600 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 84 79 10 80       	push   $0x80107984
80102f4c:	e8 2f d4 ff ff       	call   80100380 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f67:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f70:	83 fa 1d             	cmp    $0x1d,%edx
80102f73:	0f 8f 85 00 00 00    	jg     80102ffe <log_write+0x9e>
80102f79:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f7e:	83 e8 01             	sub    $0x1,%eax
80102f81:	39 c2                	cmp    %eax,%edx
80102f83:	7d 79                	jge    80102ffe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f85:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f8a:	85 c0                	test   %eax,%eax
80102f8c:	7e 7d                	jle    8010300b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 16 11 80       	push   $0x801116a0
80102f96:	e8 45 15 00 00       	call   801044e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	85 d2                	test   %edx,%edx
80102fa6:	7e 4a                	jle    80102ff2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fab:	31 c0                	xor    %eax,%eax
80102fad:	eb 08                	jmp    80102fb7 <log_write+0x57>
80102faf:	90                   	nop
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	39 c2                	cmp    %eax,%edx
80102fb5:	74 29                	je     80102fe0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fbe:	75 f0                	jne    80102fb0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fc7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fcd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fd4:	c9                   	leave  
  release(&log.lock);
80102fd5:	e9 26 16 00 00       	jmp    80104600 <release>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fe7:	83 c2 01             	add    $0x1,%edx
80102fea:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102ff0:	eb d5                	jmp    80102fc7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ff2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102ffa:	75 cb                	jne    80102fc7 <log_write+0x67>
80102ffc:	eb e9                	jmp    80102fe7 <log_write+0x87>
    panic("too big a transaction");
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 93 79 10 80       	push   $0x80107993
80103006:	e8 75 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	68 a9 79 10 80       	push   $0x801079a9
80103013:	e8 68 d3 ff ff       	call   80100380 <panic>
80103018:	66 90                	xchg   %ax,%ax
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 44 09 00 00       	call   80103970 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 3d 09 00 00       	call   80103970 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 c4 79 10 80       	push   $0x801079c4
8010303d:	e8 5e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 19 29 00 00       	call   80105960 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 c4 08 00 00       	call   80103910 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 f1 0b 00 00       	call   80103c50 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 e5 39 00 00       	call   80106a50 <switchkvm>
  seginit();
8010306b:	e8 60 38 00 00       	call   801068d0 <seginit>
  lapicinit();
80103070:	e8 9b f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 20 58 11 80       	push   $0x80115820
8010309c:	e8 8f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 9a 3e 00 00       	call   80106f40 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 85 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 60 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 1b 38 00 00       	call   801068d0 <seginit>
  picinit();       // disable pic
801030b5:	e8 76 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 31 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 9c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 87 2b 00 00       	call   80105c50 <uartinit>
  pinit();         // process table
801030c9:	e8 22 08 00 00       	call   801038f0 <pinit>
  shminit();       // shared memory
801030ce:	e8 2d 41 00 00       	call   80107200 <shminit>
  tvinit();        // trap vectors
801030d3:	e8 08 28 00 00       	call   801058e0 <tvinit>
  binit();         // buffer cache
801030d8:	e8 63 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030dd:	e8 2e dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030e2:	e8 f9 f0 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030e7:	83 c4 0c             	add    $0xc,%esp
801030ea:	68 8a 00 00 00       	push   $0x8a
801030ef:	68 8c a4 10 80       	push   $0x8010a48c
801030f4:	68 00 70 00 80       	push   $0x80007000
801030f9:	e8 f2 15 00 00       	call   801046f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030fe:	83 c4 10             	add    $0x10,%esp
80103101:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103108:	00 00 00 
8010310b:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103110:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103115:	76 79                	jbe    80103190 <main+0x110>
80103117:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
8010311c:	eb 1b                	jmp    80103139 <main+0xb9>
8010311e:	66 90                	xchg   %ax,%ax
80103120:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103127:	00 00 00 
8010312a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103130:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103135:	39 c3                	cmp    %eax,%ebx
80103137:	73 57                	jae    80103190 <main+0x110>
    if(c == mycpu())  // We've started already.
80103139:	e8 d2 07 00 00       	call   80103910 <mycpu>
8010313e:	39 c3                	cmp    %eax,%ebx
80103140:	74 de                	je     80103120 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103142:	e8 59 f5 ff ff       	call   801026a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103147:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010314a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103151:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103154:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010315b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010315e:	05 00 10 00 00       	add    $0x1000,%eax
80103163:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	68 00 70 00 00       	push   $0x7000
80103170:	50                   	push   %eax
80103171:	e8 ea f7 ff ff       	call   80102960 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0x100>
8010318a:	eb 94                	jmp    80103120 <main+0xa0>
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	68 00 00 00 8e       	push   $0x8e000000
80103198:	68 00 00 40 80       	push   $0x80400000
8010319d:	e8 2e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031a2:	e8 19 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
801031a7:	e8 74 fe ff ff       	call   80103020 <mpmain>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 fb                	cmp    %edi,%ebx
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 d8 79 10 80       	push   $0x801079d8
801031e3:	56                   	push   %esi
801031e4:	e8 b7 14 00 00       	call   801046a0 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f2                	mov    %esi,%edx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103200:	39 fa                	cmp    %edi,%edx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c3                	mov    %eax,%ebx
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 40 01 00 00    	je     801033c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 73 04             	mov    0x4(%ebx),%esi
80103283:	85 f6                	test   %esi,%esi
80103285:	0f 84 25 01 00 00    	je     801033b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103294:	6a 04                	push   $0x4
80103296:	68 dd 79 10 80       	push   $0x801079dd
8010329b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	e8 fc 13 00 00       	call   801046a0 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 01 01 00 00    	jne    801033b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032b6:	3c 01                	cmp    $0x1,%al
801032b8:	74 08                	je     801032c2 <mpinit+0x92>
801032ba:	3c 04                	cmp    $0x4,%al
801032bc:	0f 85 ee 00 00 00    	jne    801033b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032c9:	66 85 d2             	test   %dx,%dx
801032cc:	74 22                	je     801032f0 <mpinit+0xc0>
801032ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032d3:	31 d2                	xor    %edx,%edx
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e4:	39 c7                	cmp    %eax,%edi
801032e6:	75 f0                	jne    801032d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032e8:	84 d2                	test   %dl,%dl
801032ea:	0f 85 c0 00 00 00    	jne    801033b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032f6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103302:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103308:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103310:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103317:	90                   	nop
80103318:	39 d0                	cmp    %edx,%eax
8010331a:	73 15                	jae    80103331 <mpinit+0x101>
    switch(*p){
8010331c:	0f b6 08             	movzbl (%eax),%ecx
8010331f:	80 f9 02             	cmp    $0x2,%cl
80103322:	74 4c                	je     80103370 <mpinit+0x140>
80103324:	77 3a                	ja     80103360 <mpinit+0x130>
80103326:	84 c9                	test   %cl,%cl
80103328:	74 56                	je     80103380 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010332a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332d:	39 d0                	cmp    %edx,%eax
8010332f:	72 eb                	jb     8010331c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103331:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103334:	85 f6                	test   %esi,%esi
80103336:	0f 84 d9 00 00 00    	je     80103415 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010333c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103340:	74 15                	je     80103357 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	b8 70 00 00 00       	mov    $0x70,%eax
80103347:	ba 22 00 00 00       	mov    $0x22,%edx
8010334c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010334d:	ba 23 00 00 00       	mov    $0x23,%edx
80103352:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103353:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103356:	ee                   	out    %al,(%dx)
  }
}
80103357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335a:	5b                   	pop    %ebx
8010335b:	5e                   	pop    %esi
8010335c:	5f                   	pop    %edi
8010335d:	5d                   	pop    %ebp
8010335e:	c3                   	ret    
8010335f:	90                   	nop
    switch(*p){
80103360:	83 e9 03             	sub    $0x3,%ecx
80103363:	80 f9 01             	cmp    $0x1,%cl
80103366:	76 c2                	jbe    8010332a <mpinit+0xfa>
80103368:	31 f6                	xor    %esi,%esi
8010336a:	eb ac                	jmp    80103318 <mpinit+0xe8>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103370:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103374:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103377:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010337d:	eb 99                	jmp    80103318 <mpinit+0xe8>
8010337f:	90                   	nop
      if(ncpu < NCPU) {
80103380:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 6c ff ff ff       	jmp    80103318 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 e2 79 10 80       	push   $0x801079e2
801033b8:	e8 c3 cf ff ff       	call   80100380 <panic>
801033bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801033c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033c5:	eb 13                	jmp    801033da <mpinit+0x1aa>
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033d0:	89 f3                	mov    %esi,%ebx
801033d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033d8:	74 d6                	je     801033b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033da:	83 ec 04             	sub    $0x4,%esp
801033dd:	8d 73 10             	lea    0x10(%ebx),%esi
801033e0:	6a 04                	push   $0x4
801033e2:	68 d8 79 10 80       	push   $0x801079d8
801033e7:	53                   	push   %ebx
801033e8:	e8 b3 12 00 00       	call   801046a0 <memcmp>
801033ed:	83 c4 10             	add    $0x10,%esp
801033f0:	85 c0                	test   %eax,%eax
801033f2:	75 dc                	jne    801033d0 <mpinit+0x1a0>
801033f4:	89 da                	mov    %ebx,%edx
801033f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103400:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103403:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103406:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103408:	39 d6                	cmp    %edx,%esi
8010340a:	75 f4                	jne    80103400 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340c:	84 c0                	test   %al,%al
8010340e:	75 c0                	jne    801033d0 <mpinit+0x1a0>
80103410:	e9 6b fe ff ff       	jmp    80103280 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103415:	83 ec 0c             	sub    $0xc,%esp
80103418:	68 fc 79 10 80       	push   $0x801079fc
8010341d:	e8 5e cf ff ff       	call   80100380 <panic>
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
80103430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103435:	ba 21 00 00 00       	mov    $0x21,%edx
8010343a:	ee                   	out    %al,(%dx)
8010343b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103440:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010345c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010345f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346b:	e8 c0 d9 ff ff       	call   80100e30 <filealloc>
80103470:	89 03                	mov    %eax,(%ebx)
80103472:	85 c0                	test   %eax,%eax
80103474:	0f 84 a8 00 00 00    	je     80103522 <pipealloc+0xd2>
8010347a:	e8 b1 d9 ff ff       	call   80100e30 <filealloc>
8010347f:	89 06                	mov    %eax,(%esi)
80103481:	85 c0                	test   %eax,%eax
80103483:	0f 84 87 00 00 00    	je     80103510 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103489:	e8 12 f2 ff ff       	call   801026a0 <kalloc>
8010348e:	89 c7                	mov    %eax,%edi
80103490:	85 c0                	test   %eax,%eax
80103492:	0f 84 b0 00 00 00    	je     80103548 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103498:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010349f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ac:	00 00 00 
  p->nwrite = 0;
801034af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034b6:	00 00 00 
  p->nread = 0;
801034b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c0:	00 00 00 
  initlock(&p->lock, "pipe");
801034c3:	68 1b 7a 10 80       	push   $0x80107a1b
801034c8:	50                   	push   %eax
801034c9:	e8 02 0f 00 00       	call   801043d0 <initlock>
  (*f0)->type = FD_PIPE;
801034ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034df:	8b 03                	mov    (%ebx),%eax
801034e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e5:	8b 03                	mov    (%ebx),%eax
801034e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034fe:	8b 06                	mov    (%esi),%eax
80103500:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103506:	31 c0                	xor    %eax,%eax
}
80103508:	5b                   	pop    %ebx
80103509:	5e                   	pop    %esi
8010350a:	5f                   	pop    %edi
8010350b:	5d                   	pop    %ebp
8010350c:	c3                   	ret    
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	74 1e                	je     80103534 <pipealloc+0xe4>
    fileclose(*f0);
80103516:	83 ec 0c             	sub    $0xc,%esp
80103519:	50                   	push   %eax
8010351a:	e8 d1 d9 ff ff       	call   80100ef0 <fileclose>
8010351f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103522:	8b 06                	mov    (%esi),%eax
80103524:	85 c0                	test   %eax,%eax
80103526:	74 0c                	je     80103534 <pipealloc+0xe4>
    fileclose(*f1);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	50                   	push   %eax
8010352c:	e8 bf d9 ff ff       	call   80100ef0 <fileclose>
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010353c:	5b                   	pop    %ebx
8010353d:	5e                   	pop    %esi
8010353e:	5f                   	pop    %edi
8010353f:	5d                   	pop    %ebp
80103540:	c3                   	ret    
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103548:	8b 03                	mov    (%ebx),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	75 c8                	jne    80103516 <pipealloc+0xc6>
8010354e:	eb d2                	jmp    80103522 <pipealloc+0xd2>

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 7c 0f 00 00       	call   801044e0 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 65                	je     801035d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 9c 0b 00 00       	call   80104120 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 15                	je     801035b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 57 10 00 00       	jmp    80104600 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 47 10 00 00       	call   80104600 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 16 ef ff ff       	jmp    801024e0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 37 0b 00 00       	call   80104120 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb 99                	jmp    80103587 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035fc:	53                   	push   %ebx
801035fd:	e8 de 0e 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++){
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 8e c0 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103610:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103613:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103619:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010361f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103622:	03 45 10             	add    0x10(%ebp),%eax
80103625:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103628:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103634:	89 ca                	mov    %ecx,%edx
80103636:	05 00 02 00 00       	add    $0x200,%eax
8010363b:	39 c1                	cmp    %eax,%ecx
8010363d:	74 3f                	je     8010367e <pipewrite+0x8e>
8010363f:	eb 67                	jmp    801036a8 <pipewrite+0xb8>
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 43 03 00 00       	call   80103990 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 c3 0a 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 fa 09 00 00       	call   80104060 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 6f 0f 00 00       	call   80104600 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 58 ff ff ff    	jne    80103628 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 41 0a 00 00       	call   80104120 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 19 0f 00 00       	call   80104600 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 d5 0d 00 00       	call   801044e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 6b 02 00 00       	call   80103990 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 26 09 00 00       	call   80104060 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103751:	85 c0                	test   %eax,%eax
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 55 10             	mov    0x10(%ebp),%edx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 d2                	test   %edx,%edx
8010375c:	7f 20                	jg     8010377e <piperead+0x8e>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 85 09 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 5d 0e 00 00       	call   80104600 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret    
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 42 0e 00 00       	call   80104600 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret    
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037dc:	68 20 1d 11 80       	push   $0x80111d20
801037e1:	e8 fa 0c 00 00       	call   801044e0 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 10                	jmp    801037fb <allocproc+0x2b>
801037eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	83 c3 7c             	add    $0x7c,%ebx
801037f3:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801037f9:	74 75                	je     80103870 <allocproc+0xa0>
    if(p->state == UNUSED)
801037fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 ee                	jne    801037f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103802:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103807:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010380a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103811:	89 43 10             	mov    %eax,0x10(%ebx)
80103814:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103817:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010381c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103822:	e8 d9 0d 00 00       	call   80104600 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103827:	e8 74 ee ff ff       	call   801026a0 <kalloc>
8010382c:	83 c4 10             	add    $0x10,%esp
8010382f:	89 43 08             	mov    %eax,0x8(%ebx)
80103832:	85 c0                	test   %eax,%eax
80103834:	74 53                	je     80103889 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103836:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103844:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103847:	c7 40 14 d2 58 10 80 	movl   $0x801058d2,0x14(%eax)
  p->context = (struct context*)sp;
8010384e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103851:	6a 14                	push   $0x14
80103853:	6a 00                	push   $0x0
80103855:	50                   	push   %eax
80103856:	e8 f5 0d 00 00       	call   80104650 <memset>
  p->context->eip = (uint)forkret;
8010385b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010385e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103861:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103868:	89 d8                	mov    %ebx,%eax
8010386a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386d:	c9                   	leave  
8010386e:	c3                   	ret    
8010386f:	90                   	nop
  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103873:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103875:	68 20 1d 11 80       	push   $0x80111d20
8010387a:	e8 81 0d 00 00       	call   80104600 <release>
}
8010387f:	89 d8                	mov    %ebx,%eax
  return 0;
80103881:	83 c4 10             	add    $0x10,%esp
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
    p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103890:	31 db                	xor    %ebx,%ebx
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 20 1d 11 80       	push   $0x80111d20
801038ab:	e8 50 0d 00 00       	call   80104600 <release>

  if (first) {
801038b0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
    first = 0;
801038c0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038c7:	00 00 00 
    iinit(ROOTDEV);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	6a 01                	push   $0x1
801038cf:	e8 ac dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 00 f4 ff ff       	call   80102ce0 <initlog>
}
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 20 7a 10 80       	push   $0x80107a20
801038fb:	68 20 1d 11 80       	push   $0x80111d20
80103900:	e8 cb 0a 00 00       	call   801043d0 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 46                	jne    80103962 <mycpu+0x52>
  apicid = lapicid();
8010391c:	e8 ef ef ff ff       	call   80102910 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 2a                	jle    80103955 <mycpu+0x45>
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	eb 08                	jmp    80103937 <mycpu+0x27>
8010392f:	90                   	nop
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 1e                	je     80103955 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103937:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010393d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103944:	39 c3                	cmp    %eax,%ebx
80103946:	75 e8                	jne    80103930 <mycpu+0x20>
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010394b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103951:	5b                   	pop    %ebx
80103952:	5e                   	pop    %esi
80103953:	5d                   	pop    %ebp
80103954:	c3                   	ret    
  panic("unknown apicid\n");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 27 7a 10 80       	push   $0x80107a27
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 04 7b 10 80       	push   $0x80107b04
8010396a:	e8 11 ca ff ff       	call   80100380 <panic>
8010396f:	90                   	nop

80103970 <cpuid>:
cpuid() {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103976:	e8 95 ff ff ff       	call   80103910 <mycpu>
}
8010397b:	c9                   	leave  
  return mycpu()-cpus;
8010397c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103981:	c1 f8 04             	sar    $0x4,%eax
80103984:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398a:	c3                   	ret    
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <myproc>:
myproc(void) {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103997:	e8 f4 0a 00 00       	call   80104490 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 f4 0b 00 00       	call   801045a0 <popcli>
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <userinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039c7:	e8 04 fe ff ff       	call   801037d0 <allocproc>
801039cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ce:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
801039d3:	e8 e8 34 00 00       	call   80106ec0 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 a4 10 80       	push   $0x8010a460
801039f0:	50                   	push   %eax
801039f1:	e8 7a 31 00 00       	call   80106b70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 45 0c 00 00       	call   80104650 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a31:	8b 43 18             	mov    0x18(%ebx),%eax
80103a34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a50:	8b 43 18             	mov    0x18(%ebx),%eax
80103a53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	68 50 7a 10 80       	push   $0x80107a50
80103a64:	50                   	push   %eax
80103a65:	e8 a6 0d 00 00       	call   80104810 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 59 7a 10 80 	movl   $0x80107a59,(%esp)
80103a71:	e8 4a e6 ff ff       	call   801020c0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a80:	e8 5b 0a 00 00       	call   801044e0 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a93:	e8 68 0b 00 00       	call   80104600 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 37 7a 10 80       	push   $0x80107a37
80103aa8:	e8 d3 c8 ff ff       	call   80100380 <panic>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <growproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ab8:	e8 d3 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 d3 0a 00 00       	call   801045a0 <popcli>
  sz = curproc->sz;
80103acd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103acf:	85 f6                	test   %esi,%esi
80103ad1:	7f 1d                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad3:	75 3b                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ad8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ada:	53                   	push   %ebx
80103adb:	e8 80 2f 00 00       	call   80106a60 <switchuvm>
  return 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	31 c0                	xor    %eax,%eax
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 e1 31 00 00       	call   80106ce0 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 cf                	jne    80103ad5 <growproc+0x25>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb d8                	jmp    80103ae5 <growproc+0x35>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 f1 32 00 00       	call   80106e10 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 af                	jne    80103ad5 <growproc+0x25>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b39:	e8 52 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 52 0a 00 00       	call   801045a0 <popcli>
  if((np = allocproc()) == 0){
80103b4e:	e8 7d fc ff ff       	call   801037d0 <allocproc>
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 b7 00 00 00    	je     80103c15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	ff 33                	push   (%ebx)
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	ff 73 04             	push   0x4(%ebx)
80103b68:	e8 43 34 00 00       	call   80106fb0 <copyuvm>
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	89 47 04             	mov    %eax,0x4(%edi)
80103b73:	85 c0                	test   %eax,%eax
80103b75:	0f 84 a1 00 00 00    	je     80103c1c <fork+0xec>
  np->sz = curproc->sz;
80103b7b:	8b 03                	mov    (%ebx),%eax
80103b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
80103b87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b96:	8b 40 18             	mov    0x18(%eax),%eax
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 ef d2 ff ff       	call   80100ea0 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 9f db ff ff       	call   80101770 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 2a 0c 00 00       	call   80104810 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bf0:	e8 eb 08 00 00       	call   801044e0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c03:	e8 f8 09 00 00       	call   80104600 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xdb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 08             	push   0x8(%ebx)
80103c25:	e8 b6 e8 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xdb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c59:	e8 b2 fc ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6a:	8d 78 04             	lea    0x4(%eax),%edi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c74:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c79:	68 20 1d 11 80       	push   $0x80111d20
80103c7e:	e8 5d 08 00 00       	call   801044e0 <acquire>
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 bb 2d 00 00       	call   80106a60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	push   0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 b4 0b 00 00       	call   8010486b <swtch>
      switchkvm();
80103cb7:	e8 94 2d 00 00       	call   80106a50 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	83 c3 7c             	add    $0x7c,%ebx
80103ccc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103cd2:	75 bc                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 20 1d 11 80       	push   $0x80111d20
80103cdc:	e8 1f 09 00 00       	call   80104600 <release>
    sti();
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	eb 8a                	jmp    80103c70 <scheduler+0x20>
80103ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi

80103cf0 <sched>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
  pushcli();
80103cf5:	e8 96 07 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103cfa:	e8 11 fc ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103cff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d05:	e8 96 08 00 00       	call   801045a0 <popcli>
  if(!holding(&ptable.lock))
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 20 1d 11 80       	push   $0x80111d20
80103d12:	e8 39 07 00 00       	call   80104450 <holding>
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 4f                	je     80103d6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d1e:	e8 ed fb ff ff       	call   80103910 <mycpu>
80103d23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2a:	75 68                	jne    80103d94 <sched+0xa4>
  if(p->state == RUNNING)
80103d2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d30:	74 55                	je     80103d87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d32:	9c                   	pushf  
80103d33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d34:	f6 c4 02             	test   $0x2,%ah
80103d37:	75 41                	jne    80103d7a <sched+0x8a>
  intena = mycpu()->intena;
80103d39:	e8 d2 fb ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d47:	e8 c4 fb ff ff       	call   80103910 <mycpu>
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	ff 70 04             	push   0x4(%eax)
80103d52:	53                   	push   %ebx
80103d53:	e8 13 0b 00 00       	call   8010486b <swtch>
  mycpu()->intena = intena;
80103d58:	e8 b3 fb ff ff       	call   80103910 <mycpu>
}
80103d5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d69:	5b                   	pop    %ebx
80103d6a:	5e                   	pop    %esi
80103d6b:	5d                   	pop    %ebp
80103d6c:	c3                   	ret    
    panic("sched ptable.lock");
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	68 5b 7a 10 80       	push   $0x80107a5b
80103d75:	e8 06 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 87 7a 10 80       	push   $0x80107a87
80103d82:	e8 f9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 79 7a 10 80       	push   $0x80107a79
80103d8f:	e8 ec c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 6d 7a 10 80       	push   $0x80107a6d
80103d9c:	e8 df c5 ff ff       	call   80100380 <panic>
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <exit>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103db9:	e8 d2 fb ff ff       	call   80103990 <myproc>
  if(curproc == initproc)
80103dbe:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103dc4:	0f 84 fd 00 00 00    	je     80103ec7 <exit+0x117>
80103dca:	89 c3                	mov    %eax,%ebx
80103dcc:	8d 70 28             	lea    0x28(%eax),%esi
80103dcf:	8d 78 68             	lea    0x68(%eax),%edi
80103dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dd8:	8b 06                	mov    (%esi),%eax
80103dda:	85 c0                	test   %eax,%eax
80103ddc:	74 12                	je     80103df0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	50                   	push   %eax
80103de2:	e8 09 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103de7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ded:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103df0:	83 c6 04             	add    $0x4,%esi
80103df3:	39 f7                	cmp    %esi,%edi
80103df5:	75 e1                	jne    80103dd8 <exit+0x28>
  begin_op();
80103df7:	e8 84 ef ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80103dfc:	83 ec 0c             	sub    $0xc,%esp
80103dff:	ff 73 68             	push   0x68(%ebx)
80103e02:	e8 c9 da ff ff       	call   801018d0 <iput>
  end_op();
80103e07:	e8 e4 ef ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80103e0c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e13:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e1a:	e8 c1 06 00 00       	call   801044e0 <acquire>
  wakeup1(curproc->parent);
80103e1f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e22:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e25:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e2a:	eb 0e                	jmp    80103e3a <exit+0x8a>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	83 c0 7c             	add    $0x7c,%eax
80103e33:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e38:	74 1c                	je     80103e56 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e3e:	75 f0                	jne    80103e30 <exit+0x80>
80103e40:	3b 50 20             	cmp    0x20(%eax),%edx
80103e43:	75 eb                	jne    80103e30 <exit+0x80>
      p->state = RUNNABLE;
80103e45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e4c:	83 c0 7c             	add    $0x7c,%eax
80103e4f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e54:	75 e4                	jne    80103e3a <exit+0x8a>
      p->parent = initproc;
80103e56:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e61:	eb 10                	jmp    80103e73 <exit+0xc3>
80103e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e67:	90                   	nop
80103e68:	83 c2 7c             	add    $0x7c,%edx
80103e6b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103e71:	74 3b                	je     80103eae <exit+0xfe>
    if(p->parent == curproc){
80103e73:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e76:	75 f0                	jne    80103e68 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e78:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e7c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e7f:	75 e7                	jne    80103e68 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e81:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e86:	eb 12                	jmp    80103e9a <exit+0xea>
80103e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop
80103e90:	83 c0 7c             	add    $0x7c,%eax
80103e93:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e98:	74 ce                	je     80103e68 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e9e:	75 f0                	jne    80103e90 <exit+0xe0>
80103ea0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ea3:	75 eb                	jne    80103e90 <exit+0xe0>
      p->state = RUNNABLE;
80103ea5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eac:	eb e2                	jmp    80103e90 <exit+0xe0>
  curproc->state = ZOMBIE;
80103eae:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103eb5:	e8 36 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 a8 7a 10 80       	push   $0x80107aa8
80103ec2:	e8 b9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 9b 7a 10 80       	push   $0x80107a9b
80103ecf:	e8 ac c4 ff ff       	call   80100380 <panic>
80103ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 a6 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103eea:	e8 21 fa ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 a6 06 00 00       	call   801045a0 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 1d 11 80       	push   $0x80111d20
80103f02:	e8 d9 05 00 00       	call   801044e0 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f11:	eb 10                	jmp    80103f23 <wait+0x43>
80103f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f17:	90                   	nop
80103f18:	83 c3 7c             	add    $0x7c,%ebx
80103f1b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f21:	74 1b                	je     80103f3e <wait+0x5e>
      if(p->parent != curproc)
80103f23:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f26:	75 f0                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f28:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f2c:	74 62                	je     80103f90 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f31:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f36:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f3c:	75 e5                	jne    80103f23 <wait+0x43>
    if(!havekids || curproc->killed){
80103f3e:	85 c0                	test   %eax,%eax
80103f40:	0f 84 a0 00 00 00    	je     80103fe6 <wait+0x106>
80103f46:	8b 46 24             	mov    0x24(%esi),%eax
80103f49:	85 c0                	test   %eax,%eax
80103f4b:	0f 85 95 00 00 00    	jne    80103fe6 <wait+0x106>
  pushcli();
80103f51:	e8 3a 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103f56:	e8 b5 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f61:	e8 3a 06 00 00       	call   801045a0 <popcli>
  if(p == 0)
80103f66:	85 db                	test   %ebx,%ebx
80103f68:	0f 84 8f 00 00 00    	je     80103ffd <wait+0x11d>
  p->chan = chan;
80103f6e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f71:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f78:	e8 73 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103f7d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f84:	eb 84                	jmp    80103f0a <wait+0x2a>
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f90:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f93:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f96:	ff 73 08             	push   0x8(%ebx)
80103f99:	e8 42 e5 ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
80103f9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fa5:	5a                   	pop    %edx
80103fa6:	ff 73 04             	push   0x4(%ebx)
80103fa9:	e8 92 2e 00 00       	call   80106e40 <freevm>
        p->pid = 0;
80103fae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fb5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fbc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fc0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fce:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fd5:	e8 26 06 00 00       	call   80104600 <release>
        return pid;
80103fda:	83 c4 10             	add    $0x10,%esp
}
80103fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe0:	89 f0                	mov    %esi,%eax
80103fe2:	5b                   	pop    %ebx
80103fe3:	5e                   	pop    %esi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
      release(&ptable.lock);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fe9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fee:	68 20 1d 11 80       	push   $0x80111d20
80103ff3:	e8 08 06 00 00       	call   80104600 <release>
      return -1;
80103ff8:	83 c4 10             	add    $0x10,%esp
80103ffb:	eb e0                	jmp    80103fdd <wait+0xfd>
    panic("sleep");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 b4 7a 10 80       	push   $0x80107ab4
80104005:	e8 76 c3 ff ff       	call   80100380 <panic>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <yield>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104017:	68 20 1d 11 80       	push   $0x80111d20
8010401c:	e8 bf 04 00 00       	call   801044e0 <acquire>
  pushcli();
80104021:	e8 6a 04 00 00       	call   80104490 <pushcli>
  c = mycpu();
80104026:	e8 e5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010402b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104031:	e8 6a 05 00 00       	call   801045a0 <popcli>
  myproc()->state = RUNNABLE;
80104036:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010403d:	e8 ae fc ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80104042:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104049:	e8 b2 05 00 00       	call   80104600 <release>
}
8010404e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	c9                   	leave  
80104055:	c3                   	ret    
80104056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405d:	8d 76 00             	lea    0x0(%esi),%esi

80104060 <sleep>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
80104069:	8b 7d 08             	mov    0x8(%ebp),%edi
8010406c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010406f:	e8 1c 04 00 00       	call   80104490 <pushcli>
  c = mycpu();
80104074:	e8 97 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104079:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010407f:	e8 1c 05 00 00       	call   801045a0 <popcli>
  if(p == 0)
80104084:	85 db                	test   %ebx,%ebx
80104086:	0f 84 87 00 00 00    	je     80104113 <sleep+0xb3>
  if(lk == 0)
8010408c:	85 f6                	test   %esi,%esi
8010408e:	74 76                	je     80104106 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104090:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104096:	74 50                	je     801040e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 20 1d 11 80       	push   $0x80111d20
801040a0:	e8 3b 04 00 00       	call   801044e0 <acquire>
    release(lk);
801040a5:	89 34 24             	mov    %esi,(%esp)
801040a8:	e8 53 05 00 00       	call   80104600 <release>
  p->chan = chan;
801040ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b7:	e8 34 fc ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040ca:	e8 31 05 00 00       	call   80104600 <release>
    acquire(lk);
801040cf:	89 75 08             	mov    %esi,0x8(%ebp)
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
    acquire(lk);
801040dc:	e9 ff 03 00 00       	jmp    801044e0 <acquire>
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040f2:	e8 f9 fb ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104101:	5b                   	pop    %ebx
80104102:	5e                   	pop    %esi
80104103:	5f                   	pop    %edi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
    panic("sleep without lk");
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	68 ba 7a 10 80       	push   $0x80107aba
8010410e:	e8 6d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 b4 7a 10 80       	push   $0x80107ab4
8010411b:	e8 60 c2 ff ff       	call   80100380 <panic>

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
80104127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412a:	68 20 1d 11 80       	push   $0x80111d20
8010412f:	e8 ac 03 00 00       	call   801044e0 <acquire>
80104134:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104137:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010413c:	eb 0c                	jmp    8010414a <wakeup+0x2a>
8010413e:	66 90                	xchg   %ax,%ax
80104140:	83 c0 7c             	add    $0x7c,%eax
80104143:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104148:	74 1c                	je     80104166 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010414a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010414e:	75 f0                	jne    80104140 <wakeup+0x20>
80104150:	3b 58 20             	cmp    0x20(%eax),%ebx
80104153:	75 eb                	jne    80104140 <wakeup+0x20>
      p->state = RUNNABLE;
80104155:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415c:	83 c0 7c             	add    $0x7c,%eax
8010415f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104164:	75 e4                	jne    8010414a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104166:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010416d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104170:	c9                   	leave  
  release(&ptable.lock);
80104171:	e9 8a 04 00 00       	jmp    80104600 <release>
80104176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417d:	8d 76 00             	lea    0x0(%esi),%esi

80104180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010418a:	68 20 1d 11 80       	push   $0x80111d20
8010418f:	e8 4c 03 00 00       	call   801044e0 <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104197:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010419c:	eb 0c                	jmp    801041aa <kill+0x2a>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	83 c0 7c             	add    $0x7c,%eax
801041a3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041a8:	74 36                	je     801041e0 <kill+0x60>
    if(p->pid == pid){
801041aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ad:	75 f1                	jne    801041a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ba:	75 07                	jne    801041c3 <kill+0x43>
        p->state = RUNNABLE;
801041bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	68 20 1d 11 80       	push   $0x80111d20
801041cb:	e8 30 04 00 00       	call   80104600 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041d3:	83 c4 10             	add    $0x10,%esp
801041d6:	31 c0                	xor    %eax,%eax
}
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 20 1d 11 80       	push   $0x80111d20
801041e8:	e8 13 04 00 00       	call   80104600 <release>
}
801041ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104208:	53                   	push   %ebx
80104209:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010420e:	83 ec 3c             	sub    $0x3c,%esp
80104211:	eb 24                	jmp    80104237 <procdump+0x37>
80104213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104217:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 3f 7e 10 80       	push   $0x80107e3f
80104220:	e8 7b c4 ff ff       	call   801006a0 <cprintf>
80104225:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104228:	83 c3 7c             	add    $0x7c,%ebx
8010422b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104231:	0f 84 81 00 00 00    	je     801042b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104237:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010423a:	85 c0                	test   %eax,%eax
8010423c:	74 ea                	je     80104228 <procdump+0x28>
      state = "???";
8010423e:	ba cb 7a 10 80       	mov    $0x80107acb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104243:	83 f8 05             	cmp    $0x5,%eax
80104246:	77 11                	ja     80104259 <procdump+0x59>
80104248:	8b 14 85 2c 7b 10 80 	mov    -0x7fef84d4(,%eax,4),%edx
      state = "???";
8010424f:	b8 cb 7a 10 80       	mov    $0x80107acb,%eax
80104254:	85 d2                	test   %edx,%edx
80104256:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104259:	53                   	push   %ebx
8010425a:	52                   	push   %edx
8010425b:	ff 73 a4             	push   -0x5c(%ebx)
8010425e:	68 cf 7a 10 80       	push   $0x80107acf
80104263:	e8 38 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104268:	83 c4 10             	add    $0x10,%esp
8010426b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010426f:	75 a7                	jne    80104218 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104271:	83 ec 08             	sub    $0x8,%esp
80104274:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104277:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010427a:	50                   	push   %eax
8010427b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010427e:	8b 40 0c             	mov    0xc(%eax),%eax
80104281:	83 c0 08             	add    $0x8,%eax
80104284:	50                   	push   %eax
80104285:	e8 66 01 00 00       	call   801043f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010428a:	83 c4 10             	add    $0x10,%esp
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
80104290:	8b 17                	mov    (%edi),%edx
80104292:	85 d2                	test   %edx,%edx
80104294:	74 82                	je     80104218 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104296:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104299:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010429c:	52                   	push   %edx
8010429d:	68 21 75 10 80       	push   $0x80107521
801042a2:	e8 f9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042a7:	83 c4 10             	add    $0x10,%esp
801042aa:	39 fe                	cmp    %edi,%esi
801042ac:	75 e2                	jne    80104290 <procdump+0x90>
801042ae:	e9 65 ff ff ff       	jmp    80104218 <procdump+0x18>
801042b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b7:	90                   	nop
  }
}
801042b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042bb:	5b                   	pop    %ebx
801042bc:	5e                   	pop    %esi
801042bd:	5f                   	pop    %edi
801042be:	5d                   	pop    %ebp
801042bf:	c3                   	ret    

801042c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ca:	68 44 7b 10 80       	push   $0x80107b44
801042cf:	8d 43 04             	lea    0x4(%ebx),%eax
801042d2:	50                   	push   %eax
801042d3:	e8 f8 00 00 00       	call   801043d0 <initlock>
  lk->name = name;
801042d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f1:	c9                   	leave  
801042f2:	c3                   	ret    
801042f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104308:	8d 73 04             	lea    0x4(%ebx),%esi
8010430b:	83 ec 0c             	sub    $0xc,%esp
8010430e:	56                   	push   %esi
8010430f:	e8 cc 01 00 00       	call   801044e0 <acquire>
  while (lk->locked) {
80104314:	8b 13                	mov    (%ebx),%edx
80104316:	83 c4 10             	add    $0x10,%esp
80104319:	85 d2                	test   %edx,%edx
8010431b:	74 16                	je     80104333 <acquiresleep+0x33>
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104320:	83 ec 08             	sub    $0x8,%esp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	e8 36 fd ff ff       	call   80104060 <sleep>
  while (lk->locked) {
8010432a:	8b 03                	mov    (%ebx),%eax
8010432c:	83 c4 10             	add    $0x10,%esp
8010432f:	85 c0                	test   %eax,%eax
80104331:	75 ed                	jne    80104320 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104333:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104339:	e8 52 f6 ff ff       	call   80103990 <myproc>
8010433e:	8b 40 10             	mov    0x10(%eax),%eax
80104341:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104344:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104347:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434a:	5b                   	pop    %ebx
8010434b:	5e                   	pop    %esi
8010434c:	5d                   	pop    %ebp
  release(&lk->lk);
8010434d:	e9 ae 02 00 00       	jmp    80104600 <release>
80104352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104368:	8d 73 04             	lea    0x4(%ebx),%esi
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	56                   	push   %esi
8010436f:	e8 6c 01 00 00       	call   801044e0 <acquire>
  lk->locked = 0;
80104374:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010437a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104381:	89 1c 24             	mov    %ebx,(%esp)
80104384:	e8 97 fd ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
80104389:	89 75 08             	mov    %esi,0x8(%ebp)
8010438c:	83 c4 10             	add    $0x10,%esp
}
8010438f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104392:	5b                   	pop    %ebx
80104393:	5e                   	pop    %esi
80104394:	5d                   	pop    %ebp
  release(&lk->lk);
80104395:	e9 66 02 00 00       	jmp    80104600 <release>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801043a8:	8d 5e 04             	lea    0x4(%esi),%ebx
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	53                   	push   %ebx
801043af:	e8 2c 01 00 00       	call   801044e0 <acquire>
  r = lk->locked;
801043b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801043b6:	89 1c 24             	mov    %ebx,(%esp)
801043b9:	e8 42 02 00 00       	call   80104600 <release>
  return r;
}
801043be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c1:	89 f0                	mov    %esi,%eax
801043c3:	5b                   	pop    %ebx
801043c4:	5e                   	pop    %esi
801043c5:	5d                   	pop    %ebp
801043c6:	c3                   	ret    
801043c7:	66 90                	xchg   %ax,%ax
801043c9:	66 90                	xchg   %ax,%ax
801043cb:	66 90                	xchg   %ax,%ax
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043e9:	5d                   	pop    %ebp
801043ea:	c3                   	ret    
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop

801043f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043f1:	31 d2                	xor    %edx,%edx
{
801043f3:	89 e5                	mov    %esp,%ebp
801043f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801043ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104400:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104406:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010440c:	77 1a                	ja     80104428 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010440e:	8b 58 04             	mov    0x4(%eax),%ebx
80104411:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104414:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104417:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104419:	83 fa 0a             	cmp    $0xa,%edx
8010441c:	75 e2                	jne    80104400 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010441e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104421:	c9                   	leave  
80104422:	c3                   	ret    
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
  for(; i < 10; i++)
80104428:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010442b:	8d 51 28             	lea    0x28(%ecx),%edx
8010442e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104436:	83 c0 04             	add    $0x4,%eax
80104439:	39 d0                	cmp    %edx,%eax
8010443b:	75 f3                	jne    80104430 <getcallerpcs+0x40>
}
8010443d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104440:	c9                   	leave  
80104441:	c3                   	ret    
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104450 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 04             	sub    $0x4,%esp
80104457:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010445a:	8b 02                	mov    (%edx),%eax
8010445c:	85 c0                	test   %eax,%eax
8010445e:	75 10                	jne    80104470 <holding+0x20>
}
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104463:	31 c0                	xor    %eax,%eax
80104465:	c9                   	leave  
80104466:	c3                   	ret    
80104467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446e:	66 90                	xchg   %ax,%ax
80104470:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
80104473:	e8 98 f4 ff ff       	call   80103910 <mycpu>
80104478:	39 c3                	cmp    %eax,%ebx
}
8010447a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447d:	c9                   	leave  
  return lock->locked && lock->cpu == mycpu();
8010447e:	0f 94 c0             	sete   %al
80104481:	0f b6 c0             	movzbl %al,%eax
}
80104484:	c3                   	ret    
80104485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 04             	sub    $0x4,%esp
80104497:	9c                   	pushf  
80104498:	5b                   	pop    %ebx
  asm volatile("cli");
80104499:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010449a:	e8 71 f4 ff ff       	call   80103910 <mycpu>
8010449f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044a5:	85 c0                	test   %eax,%eax
801044a7:	74 17                	je     801044c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044a9:	e8 62 f4 ff ff       	call   80103910 <mycpu>
801044ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044c0:	e8 4b f4 ff ff       	call   80103910 <mycpu>
801044c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044d1:	eb d6                	jmp    801044a9 <pushcli+0x19>
801044d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <acquire>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801044e7:	e8 a4 ff ff ff       	call   80104490 <pushcli>
  if(holding(lk))
801044ec:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801044ef:	8b 02                	mov    (%edx),%eax
801044f1:	85 c0                	test   %eax,%eax
801044f3:	0f 85 7f 00 00 00    	jne    80104578 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801044f9:	b9 01 00 00 00       	mov    $0x1,%ecx
801044fe:	eb 03                	jmp    80104503 <acquire+0x23>
  while(xchg(&lk->locked, 1) != 0)
80104500:	8b 55 08             	mov    0x8(%ebp),%edx
80104503:	89 c8                	mov    %ecx,%eax
80104505:	f0 87 02             	lock xchg %eax,(%edx)
80104508:	85 c0                	test   %eax,%eax
8010450a:	75 f4                	jne    80104500 <acquire+0x20>
  __sync_synchronize();
8010450c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104511:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104514:	e8 f7 f3 ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
8010451c:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010451e:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104521:	31 c0                	xor    %eax,%eax
80104523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104527:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104528:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010452e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104534:	77 1a                	ja     80104550 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104536:	8b 5a 04             	mov    0x4(%edx),%ebx
80104539:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
8010453d:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104540:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104542:	83 f8 0a             	cmp    $0xa,%eax
80104545:	75 e1                	jne    80104528 <acquire+0x48>
}
80104547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010454a:	c9                   	leave  
8010454b:	c3                   	ret    
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104550:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104554:	8d 51 34             	lea    0x34(%ecx),%edx
80104557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104566:	83 c0 04             	add    $0x4,%eax
80104569:	39 c2                	cmp    %eax,%edx
8010456b:	75 f3                	jne    80104560 <acquire+0x80>
}
8010456d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104570:	c9                   	leave  
80104571:	c3                   	ret    
80104572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104578:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
8010457b:	e8 90 f3 ff ff       	call   80103910 <mycpu>
80104580:	39 c3                	cmp    %eax,%ebx
80104582:	74 0c                	je     80104590 <acquire+0xb0>
  while(xchg(&lk->locked, 1) != 0)
80104584:	8b 55 08             	mov    0x8(%ebp),%edx
80104587:	e9 6d ff ff ff       	jmp    801044f9 <acquire+0x19>
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	68 4f 7b 10 80       	push   $0x80107b4f
80104598:	e8 e3 bd ff ff       	call   80100380 <panic>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi

801045a0 <popcli>:

void
popcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045a6:	9c                   	pushf  
801045a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045a8:	f6 c4 02             	test   $0x2,%ah
801045ab:	75 35                	jne    801045e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ad:	e8 5e f3 ff ff       	call   80103910 <mycpu>
801045b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045b9:	78 34                	js     801045ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045bb:	e8 50 f3 ff ff       	call   80103910 <mycpu>
801045c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045c6:	85 d2                	test   %edx,%edx
801045c8:	74 06                	je     801045d0 <popcli+0x30>
    sti();
}
801045ca:	c9                   	leave  
801045cb:	c3                   	ret    
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045d0:	e8 3b f3 ff ff       	call   80103910 <mycpu>
801045d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045db:	85 c0                	test   %eax,%eax
801045dd:	74 eb                	je     801045ca <popcli+0x2a>
  asm volatile("sti");
801045df:	fb                   	sti    
}
801045e0:	c9                   	leave  
801045e1:	c3                   	ret    
    panic("popcli - interruptible");
801045e2:	83 ec 0c             	sub    $0xc,%esp
801045e5:	68 57 7b 10 80       	push   $0x80107b57
801045ea:	e8 91 bd ff ff       	call   80100380 <panic>
    panic("popcli");
801045ef:	83 ec 0c             	sub    $0xc,%esp
801045f2:	68 6e 7b 10 80       	push   $0x80107b6e
801045f7:	e8 84 bd ff ff       	call   80100380 <panic>
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104600 <release>:
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104608:	8b 03                	mov    (%ebx),%eax
8010460a:	85 c0                	test   %eax,%eax
8010460c:	75 12                	jne    80104620 <release+0x20>
    panic("release");
8010460e:	83 ec 0c             	sub    $0xc,%esp
80104611:	68 75 7b 10 80       	push   $0x80107b75
80104616:	e8 65 bd ff ff       	call   80100380 <panic>
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
80104620:	8b 73 08             	mov    0x8(%ebx),%esi
  return lock->locked && lock->cpu == mycpu();
80104623:	e8 e8 f2 ff ff       	call   80103910 <mycpu>
80104628:	39 c6                	cmp    %eax,%esi
8010462a:	75 e2                	jne    8010460e <release+0xe>
  lk->pcs[0] = 0;
8010462c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104633:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010463a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010463f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104645:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104648:	5b                   	pop    %ebx
80104649:	5e                   	pop    %esi
8010464a:	5d                   	pop    %ebp
  popcli();
8010464b:	e9 50 ff ff ff       	jmp    801045a0 <popcli>

80104650 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	8b 55 08             	mov    0x8(%ebp),%edx
80104657:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010465a:	53                   	push   %ebx
8010465b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010465e:	89 d7                	mov    %edx,%edi
80104660:	09 cf                	or     %ecx,%edi
80104662:	83 e7 03             	and    $0x3,%edi
80104665:	75 29                	jne    80104690 <memset+0x40>
    c &= 0xFF;
80104667:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010466a:	c1 e0 18             	shl    $0x18,%eax
8010466d:	89 fb                	mov    %edi,%ebx
8010466f:	c1 e9 02             	shr    $0x2,%ecx
80104672:	c1 e3 10             	shl    $0x10,%ebx
80104675:	09 d8                	or     %ebx,%eax
80104677:	09 f8                	or     %edi,%eax
80104679:	c1 e7 08             	shl    $0x8,%edi
8010467c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010467e:	89 d7                	mov    %edx,%edi
80104680:	fc                   	cld    
80104681:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104683:	5b                   	pop    %ebx
80104684:	89 d0                	mov    %edx,%eax
80104686:	5f                   	pop    %edi
80104687:	5d                   	pop    %ebp
80104688:	c3                   	ret    
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104690:	89 d7                	mov    %edx,%edi
80104692:	fc                   	cld    
80104693:	f3 aa                	rep stos %al,%es:(%edi)
80104695:	5b                   	pop    %ebx
80104696:	89 d0                	mov    %edx,%eax
80104698:	5f                   	pop    %edi
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	8b 75 10             	mov    0x10(%ebp),%esi
801046a7:	8b 55 08             	mov    0x8(%ebp),%edx
801046aa:	53                   	push   %ebx
801046ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ae:	85 f6                	test   %esi,%esi
801046b0:	74 2e                	je     801046e0 <memcmp+0x40>
801046b2:	01 c6                	add    %eax,%esi
801046b4:	eb 14                	jmp    801046ca <memcmp+0x2a>
801046b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801046c0:	83 c0 01             	add    $0x1,%eax
801046c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801046c6:	39 f0                	cmp    %esi,%eax
801046c8:	74 16                	je     801046e0 <memcmp+0x40>
    if(*s1 != *s2)
801046ca:	0f b6 0a             	movzbl (%edx),%ecx
801046cd:	0f b6 18             	movzbl (%eax),%ebx
801046d0:	38 d9                	cmp    %bl,%cl
801046d2:	74 ec                	je     801046c0 <memcmp+0x20>
      return *s1 - *s2;
801046d4:	0f b6 c1             	movzbl %cl,%eax
801046d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801046d9:	5b                   	pop    %ebx
801046da:	5e                   	pop    %esi
801046db:	5d                   	pop    %ebp
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
801046e0:	5b                   	pop    %ebx
  return 0;
801046e1:	31 c0                	xor    %eax,%eax
}
801046e3:	5e                   	pop    %esi
801046e4:	5d                   	pop    %ebp
801046e5:	c3                   	ret    
801046e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	8b 55 08             	mov    0x8(%ebp),%edx
801046f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046fa:	56                   	push   %esi
801046fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046fe:	39 d6                	cmp    %edx,%esi
80104700:	73 26                	jae    80104728 <memmove+0x38>
80104702:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104705:	39 fa                	cmp    %edi,%edx
80104707:	73 1f                	jae    80104728 <memmove+0x38>
80104709:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010470c:	85 c9                	test   %ecx,%ecx
8010470e:	74 0c                	je     8010471c <memmove+0x2c>
      *--d = *--s;
80104710:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104714:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104717:	83 e8 01             	sub    $0x1,%eax
8010471a:	73 f4                	jae    80104710 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010471c:	5e                   	pop    %esi
8010471d:	89 d0                	mov    %edx,%eax
8010471f:	5f                   	pop    %edi
80104720:	5d                   	pop    %ebp
80104721:	c3                   	ret    
80104722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104728:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010472b:	89 d7                	mov    %edx,%edi
8010472d:	85 c9                	test   %ecx,%ecx
8010472f:	74 eb                	je     8010471c <memmove+0x2c>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104738:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104739:	39 c6                	cmp    %eax,%esi
8010473b:	75 fb                	jne    80104738 <memmove+0x48>
}
8010473d:	5e                   	pop    %esi
8010473e:	89 d0                	mov    %edx,%eax
80104740:	5f                   	pop    %edi
80104741:	5d                   	pop    %ebp
80104742:	c3                   	ret    
80104743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104750:	eb 9e                	jmp    801046f0 <memmove>
80104752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104760 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	8b 75 10             	mov    0x10(%ebp),%esi
80104767:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010476a:	53                   	push   %ebx
8010476b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010476e:	85 f6                	test   %esi,%esi
80104770:	74 2e                	je     801047a0 <strncmp+0x40>
80104772:	01 d6                	add    %edx,%esi
80104774:	eb 18                	jmp    8010478e <strncmp+0x2e>
80104776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	38 d8                	cmp    %bl,%al
80104782:	75 14                	jne    80104798 <strncmp+0x38>
    n--, p++, q++;
80104784:	83 c2 01             	add    $0x1,%edx
80104787:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010478a:	39 f2                	cmp    %esi,%edx
8010478c:	74 12                	je     801047a0 <strncmp+0x40>
8010478e:	0f b6 01             	movzbl (%ecx),%eax
80104791:	0f b6 1a             	movzbl (%edx),%ebx
80104794:	84 c0                	test   %al,%al
80104796:	75 e8                	jne    80104780 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104798:	29 d8                	sub    %ebx,%eax
}
8010479a:	5b                   	pop    %ebx
8010479b:	5e                   	pop    %esi
8010479c:	5d                   	pop    %ebp
8010479d:	c3                   	ret    
8010479e:	66 90                	xchg   %ax,%ax
801047a0:	5b                   	pop    %ebx
    return 0;
801047a1:	31 c0                	xor    %eax,%eax
}
801047a3:	5e                   	pop    %esi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    
801047a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ad:	8d 76 00             	lea    0x0(%esi),%esi

801047b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	56                   	push   %esi
801047b5:	8b 75 08             	mov    0x8(%ebp),%esi
801047b8:	53                   	push   %ebx
801047b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047bc:	89 f0                	mov    %esi,%eax
801047be:	eb 15                	jmp    801047d5 <strncpy+0x25>
801047c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801047c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801047c7:	83 c0 01             	add    $0x1,%eax
801047ca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801047ce:	88 50 ff             	mov    %dl,-0x1(%eax)
801047d1:	84 d2                	test   %dl,%dl
801047d3:	74 09                	je     801047de <strncpy+0x2e>
801047d5:	89 cb                	mov    %ecx,%ebx
801047d7:	83 e9 01             	sub    $0x1,%ecx
801047da:	85 db                	test   %ebx,%ebx
801047dc:	7f e2                	jg     801047c0 <strncpy+0x10>
    ;
  while(n-- > 0)
801047de:	89 c2                	mov    %eax,%edx
801047e0:	85 c9                	test   %ecx,%ecx
801047e2:	7e 17                	jle    801047fb <strncpy+0x4b>
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801047e8:	83 c2 01             	add    $0x1,%edx
801047eb:	89 c1                	mov    %eax,%ecx
801047ed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801047f1:	29 d1                	sub    %edx,%ecx
801047f3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801047f7:	85 c9                	test   %ecx,%ecx
801047f9:	7f ed                	jg     801047e8 <strncpy+0x38>
  return os;
}
801047fb:	5b                   	pop    %ebx
801047fc:	89 f0                	mov    %esi,%eax
801047fe:	5e                   	pop    %esi
801047ff:	5f                   	pop    %edi
80104800:	5d                   	pop    %ebp
80104801:	c3                   	ret    
80104802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	8b 55 10             	mov    0x10(%ebp),%edx
80104817:	8b 75 08             	mov    0x8(%ebp),%esi
8010481a:	53                   	push   %ebx
8010481b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010481e:	85 d2                	test   %edx,%edx
80104820:	7e 25                	jle    80104847 <safestrcpy+0x37>
80104822:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104826:	89 f2                	mov    %esi,%edx
80104828:	eb 16                	jmp    80104840 <safestrcpy+0x30>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104830:	0f b6 08             	movzbl (%eax),%ecx
80104833:	83 c0 01             	add    $0x1,%eax
80104836:	83 c2 01             	add    $0x1,%edx
80104839:	88 4a ff             	mov    %cl,-0x1(%edx)
8010483c:	84 c9                	test   %cl,%cl
8010483e:	74 04                	je     80104844 <safestrcpy+0x34>
80104840:	39 d8                	cmp    %ebx,%eax
80104842:	75 ec                	jne    80104830 <safestrcpy+0x20>
    ;
  *s = 0;
80104844:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104847:	89 f0                	mov    %esi,%eax
80104849:	5b                   	pop    %ebx
8010484a:	5e                   	pop    %esi
8010484b:	5d                   	pop    %ebp
8010484c:	c3                   	ret    
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <strlen>:

int
strlen(const char *s)
{
80104850:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104851:	31 c0                	xor    %eax,%eax
{
80104853:	89 e5                	mov    %esp,%ebp
80104855:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104858:	80 3a 00             	cmpb   $0x0,(%edx)
8010485b:	74 0c                	je     80104869 <strlen+0x19>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	83 c0 01             	add    $0x1,%eax
80104863:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104867:	75 f7                	jne    80104860 <strlen+0x10>
    ;
  return n;
}
80104869:	5d                   	pop    %ebp
8010486a:	c3                   	ret    

8010486b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010486b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010486f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104873:	55                   	push   %ebp
  pushl %ebx
80104874:	53                   	push   %ebx
  pushl %esi
80104875:	56                   	push   %esi
  pushl %edi
80104876:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104877:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104879:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010487b:	5f                   	pop    %edi
  popl %esi
8010487c:	5e                   	pop    %esi
  popl %ebx
8010487d:	5b                   	pop    %ebx
  popl %ebp
8010487e:	5d                   	pop    %ebp
  ret
8010487f:	c3                   	ret    

80104880 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	83 ec 04             	sub    $0x4,%esp
80104887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010488a:	e8 01 f1 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010488f:	8b 00                	mov    (%eax),%eax
80104891:	39 d8                	cmp    %ebx,%eax
80104893:	76 1b                	jbe    801048b0 <fetchint+0x30>
80104895:	8d 53 04             	lea    0x4(%ebx),%edx
80104898:	39 d0                	cmp    %edx,%eax
8010489a:	72 14                	jb     801048b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010489c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010489f:	8b 13                	mov    (%ebx),%edx
801048a1:	89 10                	mov    %edx,(%eax)
  return 0;
801048a3:	31 c0                	xor    %eax,%eax
}
801048a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a8:	c9                   	leave  
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801048b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048b5:	eb ee                	jmp    801048a5 <fetchint+0x25>
801048b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048be:	66 90                	xchg   %ax,%ax

801048c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048ca:	e8 c1 f0 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
801048cf:	39 18                	cmp    %ebx,(%eax)
801048d1:	76 2d                	jbe    80104900 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801048d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801048d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048da:	39 d3                	cmp    %edx,%ebx
801048dc:	73 22                	jae    80104900 <fetchstr+0x40>
801048de:	89 d8                	mov    %ebx,%eax
801048e0:	eb 0d                	jmp    801048ef <fetchstr+0x2f>
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e8:	83 c0 01             	add    $0x1,%eax
801048eb:	39 c2                	cmp    %eax,%edx
801048ed:	76 11                	jbe    80104900 <fetchstr+0x40>
    if(*s == 0)
801048ef:	80 38 00             	cmpb   $0x0,(%eax)
801048f2:	75 f4                	jne    801048e8 <fetchstr+0x28>
      return s - *pp;
801048f4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801048f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f9:	c9                   	leave  
801048fa:	c3                   	ret    
801048fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ff:	90                   	nop
80104900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104908:	c9                   	leave  
80104909:	c3                   	ret    
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104910 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104915:	e8 76 f0 ff ff       	call   80103990 <myproc>
8010491a:	8b 55 08             	mov    0x8(%ebp),%edx
8010491d:	8b 40 18             	mov    0x18(%eax),%eax
80104920:	8b 40 44             	mov    0x44(%eax),%eax
80104923:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104926:	e8 65 f0 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010492b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010492e:	8b 00                	mov    (%eax),%eax
80104930:	39 c6                	cmp    %eax,%esi
80104932:	73 1c                	jae    80104950 <argint+0x40>
80104934:	8d 53 08             	lea    0x8(%ebx),%edx
80104937:	39 d0                	cmp    %edx,%eax
80104939:	72 15                	jb     80104950 <argint+0x40>
  *ip = *(int*)(addr);
8010493b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493e:	8b 53 04             	mov    0x4(%ebx),%edx
80104941:	89 10                	mov    %edx,(%eax)
  return 0;
80104943:	31 c0                	xor    %eax,%eax
}
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104955:	eb ee                	jmp    80104945 <argint+0x35>
80104957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495e:	66 90                	xchg   %ax,%ax

80104960 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104969:	e8 22 f0 ff ff       	call   80103990 <myproc>
8010496e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104970:	e8 1b f0 ff ff       	call   80103990 <myproc>
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
80104978:	8b 40 18             	mov    0x18(%eax),%eax
8010497b:	8b 40 44             	mov    0x44(%eax),%eax
8010497e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104981:	e8 0a f0 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104986:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104989:	8b 00                	mov    (%eax),%eax
8010498b:	39 c7                	cmp    %eax,%edi
8010498d:	73 31                	jae    801049c0 <argptr+0x60>
8010498f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104992:	39 c8                	cmp    %ecx,%eax
80104994:	72 2a                	jb     801049c0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104996:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104999:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010499c:	85 d2                	test   %edx,%edx
8010499e:	78 20                	js     801049c0 <argptr+0x60>
801049a0:	8b 16                	mov    (%esi),%edx
801049a2:	39 c2                	cmp    %eax,%edx
801049a4:	76 1a                	jbe    801049c0 <argptr+0x60>
801049a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049a9:	01 c3                	add    %eax,%ebx
801049ab:	39 da                	cmp    %ebx,%edx
801049ad:	72 11                	jb     801049c0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801049af:	8b 55 0c             	mov    0xc(%ebp),%edx
801049b2:	89 02                	mov    %eax,(%edx)
  return 0;
801049b4:	31 c0                	xor    %eax,%eax
}
801049b6:	83 c4 0c             	add    $0xc,%esp
801049b9:	5b                   	pop    %ebx
801049ba:	5e                   	pop    %esi
801049bb:	5f                   	pop    %edi
801049bc:	5d                   	pop    %ebp
801049bd:	c3                   	ret    
801049be:	66 90                	xchg   %ax,%ax
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049c5:	eb ef                	jmp    801049b6 <argptr+0x56>
801049c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d5:	e8 b6 ef ff ff       	call   80103990 <myproc>
801049da:	8b 55 08             	mov    0x8(%ebp),%edx
801049dd:	8b 40 18             	mov    0x18(%eax),%eax
801049e0:	8b 40 44             	mov    0x44(%eax),%eax
801049e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049e6:	e8 a5 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ee:	8b 00                	mov    (%eax),%eax
801049f0:	39 c6                	cmp    %eax,%esi
801049f2:	73 44                	jae    80104a38 <argstr+0x68>
801049f4:	8d 53 08             	lea    0x8(%ebx),%edx
801049f7:	39 d0                	cmp    %edx,%eax
801049f9:	72 3d                	jb     80104a38 <argstr+0x68>
  *ip = *(int*)(addr);
801049fb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801049fe:	e8 8d ef ff ff       	call   80103990 <myproc>
  if(addr >= curproc->sz)
80104a03:	3b 18                	cmp    (%eax),%ebx
80104a05:	73 31                	jae    80104a38 <argstr+0x68>
  *pp = (char*)addr;
80104a07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a0e:	39 d3                	cmp    %edx,%ebx
80104a10:	73 26                	jae    80104a38 <argstr+0x68>
80104a12:	89 d8                	mov    %ebx,%eax
80104a14:	eb 11                	jmp    80104a27 <argstr+0x57>
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	39 c2                	cmp    %eax,%edx
80104a25:	76 11                	jbe    80104a38 <argstr+0x68>
    if(*s == 0)
80104a27:	80 38 00             	cmpb   $0x0,(%eax)
80104a2a:	75 f4                	jne    80104a20 <argstr+0x50>
      return s - *pp;
80104a2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a2e:	5b                   	pop    %ebx
80104a2f:	5e                   	pop    %esi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret    
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a38:	5b                   	pop    %ebx
    return -1;
80104a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a3e:	5e                   	pop    %esi
80104a3f:	5d                   	pop    %ebp
80104a40:	c3                   	ret    
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop

80104a50 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a57:	e8 34 ef ff ff       	call   80103990 <myproc>
80104a5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a5e:	8b 40 18             	mov    0x18(%eax),%eax
80104a61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a67:	83 fa 16             	cmp    $0x16,%edx
80104a6a:	77 24                	ja     80104a90 <syscall+0x40>
80104a6c:	8b 14 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%edx
80104a73:	85 d2                	test   %edx,%edx
80104a75:	74 19                	je     80104a90 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a77:	ff d2                	call   *%edx
80104a79:	89 c2                	mov    %eax,%edx
80104a7b:	8b 43 18             	mov    0x18(%ebx),%eax
80104a7e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a84:	c9                   	leave  
80104a85:	c3                   	ret    
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a90:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a91:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a94:	50                   	push   %eax
80104a95:	ff 73 10             	push   0x10(%ebx)
80104a98:	68 7d 7b 10 80       	push   $0x80107b7d
80104a9d:	e8 fe bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104aa2:	8b 43 18             	mov    0x18(%ebx),%eax
80104aa5:	83 c4 10             	add    $0x10,%esp
80104aa8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab2:	c9                   	leave  
80104ab3:	c3                   	ret    
80104ab4:	66 90                	xchg   %ax,%ax
80104ab6:	66 90                	xchg   %ax,%ax
80104ab8:	66 90                	xchg   %ax,%ax
80104aba:	66 90                	xchg   %ax,%ax
80104abc:	66 90                	xchg   %ax,%ax
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ac5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ac8:	53                   	push   %ebx
80104ac9:	83 ec 44             	sub    $0x44,%esp
80104acc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ad2:	57                   	push   %edi
80104ad3:	50                   	push   %eax
{
80104ad4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ad7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ada:	e8 01 d6 ff ff       	call   801020e0 <nameiparent>
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	85 c0                	test   %eax,%eax
80104ae4:	0f 84 46 01 00 00    	je     80104c30 <create+0x170>
    return 0;
  ilock(dp);
80104aea:	83 ec 0c             	sub    $0xc,%esp
80104aed:	89 c3                	mov    %eax,%ebx
80104aef:	50                   	push   %eax
80104af0:	e8 ab cc ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104af5:	83 c4 0c             	add    $0xc,%esp
80104af8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104afb:	50                   	push   %eax
80104afc:	57                   	push   %edi
80104afd:	53                   	push   %ebx
80104afe:	e8 fd d1 ff ff       	call   80101d00 <dirlookup>
80104b03:	83 c4 10             	add    $0x10,%esp
80104b06:	89 c6                	mov    %eax,%esi
80104b08:	85 c0                	test   %eax,%eax
80104b0a:	74 54                	je     80104b60 <create+0xa0>
    iunlockput(dp);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	53                   	push   %ebx
80104b10:	e8 1b cf ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104b15:	89 34 24             	mov    %esi,(%esp)
80104b18:	e8 83 cc ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b25:	75 19                	jne    80104b40 <create+0x80>
80104b27:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b2c:	75 12                	jne    80104b40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b31:	89 f0                	mov    %esi,%eax
80104b33:	5b                   	pop    %ebx
80104b34:	5e                   	pop    %esi
80104b35:	5f                   	pop    %edi
80104b36:	5d                   	pop    %ebp
80104b37:	c3                   	ret    
80104b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
    iunlockput(ip);
80104b40:	83 ec 0c             	sub    $0xc,%esp
80104b43:	56                   	push   %esi
    return 0;
80104b44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b46:	e8 e5 ce ff ff       	call   80101a30 <iunlockput>
    return 0;
80104b4b:	83 c4 10             	add    $0x10,%esp
}
80104b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b51:	89 f0                	mov    %esi,%eax
80104b53:	5b                   	pop    %ebx
80104b54:	5e                   	pop    %esi
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    
80104b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b60:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b64:	83 ec 08             	sub    $0x8,%esp
80104b67:	50                   	push   %eax
80104b68:	ff 33                	push   (%ebx)
80104b6a:	e8 c1 ca ff ff       	call   80101630 <ialloc>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	89 c6                	mov    %eax,%esi
80104b74:	85 c0                	test   %eax,%eax
80104b76:	0f 84 cd 00 00 00    	je     80104c49 <create+0x189>
  ilock(ip);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	50                   	push   %eax
80104b80:	e8 1b cc ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104b85:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b8d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b95:	b8 01 00 00 00       	mov    $0x1,%eax
80104b9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b9e:	89 34 24             	mov    %esi,(%esp)
80104ba1:	e8 4a cb ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ba6:	83 c4 10             	add    $0x10,%esp
80104ba9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bae:	74 30                	je     80104be0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bb0:	83 ec 04             	sub    $0x4,%esp
80104bb3:	ff 76 04             	push   0x4(%esi)
80104bb6:	57                   	push   %edi
80104bb7:	53                   	push   %ebx
80104bb8:	e8 43 d4 ff ff       	call   80102000 <dirlink>
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	78 78                	js     80104c3c <create+0x17c>
  iunlockput(dp);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	53                   	push   %ebx
80104bc8:	e8 63 ce ff ff       	call   80101a30 <iunlockput>
  return ip;
80104bcd:	83 c4 10             	add    $0x10,%esp
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd3:	89 f0                	mov    %esi,%eax
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5f                   	pop    %edi
80104bd8:	5d                   	pop    %ebp
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104be0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104be3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104be8:	53                   	push   %ebx
80104be9:	e8 02 cb ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bee:	83 c4 0c             	add    $0xc,%esp
80104bf1:	ff 76 04             	push   0x4(%esi)
80104bf4:	68 1c 7c 10 80       	push   $0x80107c1c
80104bf9:	56                   	push   %esi
80104bfa:	e8 01 d4 ff ff       	call   80102000 <dirlink>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	85 c0                	test   %eax,%eax
80104c04:	78 18                	js     80104c1e <create+0x15e>
80104c06:	83 ec 04             	sub    $0x4,%esp
80104c09:	ff 73 04             	push   0x4(%ebx)
80104c0c:	68 1b 7c 10 80       	push   $0x80107c1b
80104c11:	56                   	push   %esi
80104c12:	e8 e9 d3 ff ff       	call   80102000 <dirlink>
80104c17:	83 c4 10             	add    $0x10,%esp
80104c1a:	85 c0                	test   %eax,%eax
80104c1c:	79 92                	jns    80104bb0 <create+0xf0>
      panic("create dots");
80104c1e:	83 ec 0c             	sub    $0xc,%esp
80104c21:	68 0f 7c 10 80       	push   $0x80107c0f
80104c26:	e8 55 b7 ff ff       	call   80100380 <panic>
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop
}
80104c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c33:	31 f6                	xor    %esi,%esi
}
80104c35:	5b                   	pop    %ebx
80104c36:	89 f0                	mov    %esi,%eax
80104c38:	5e                   	pop    %esi
80104c39:	5f                   	pop    %edi
80104c3a:	5d                   	pop    %ebp
80104c3b:	c3                   	ret    
    panic("create: dirlink");
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	68 1e 7c 10 80       	push   $0x80107c1e
80104c44:	e8 37 b7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c49:	83 ec 0c             	sub    $0xc,%esp
80104c4c:	68 00 7c 10 80       	push   $0x80107c00
80104c51:	e8 2a b7 ff ff       	call   80100380 <panic>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi

80104c60 <sys_dup>:
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104c65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104c68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c6b:	50                   	push   %eax
80104c6c:	6a 00                	push   $0x0
80104c6e:	e8 9d fc ff ff       	call   80104910 <argint>
80104c73:	83 c4 10             	add    $0x10,%esp
80104c76:	85 c0                	test   %eax,%eax
80104c78:	78 36                	js     80104cb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c7e:	77 30                	ja     80104cb0 <sys_dup+0x50>
80104c80:	e8 0b ed ff ff       	call   80103990 <myproc>
80104c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104c8c:	85 f6                	test   %esi,%esi
80104c8e:	74 20                	je     80104cb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104c90:	e8 fb ec ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104c95:	31 db                	xor    %ebx,%ebx
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ca0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ca4:	85 d2                	test   %edx,%edx
80104ca6:	74 18                	je     80104cc0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ca8:	83 c3 01             	add    $0x1,%ebx
80104cab:	83 fb 10             	cmp    $0x10,%ebx
80104cae:	75 f0                	jne    80104ca0 <sys_dup+0x40>
}
80104cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104cb8:	89 d8                	mov    %ebx,%eax
80104cba:	5b                   	pop    %ebx
80104cbb:	5e                   	pop    %esi
80104cbc:	5d                   	pop    %ebp
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104cc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104cc3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104cc7:	56                   	push   %esi
80104cc8:	e8 d3 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104ccd:	83 c4 10             	add    $0x10,%esp
}
80104cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd3:	89 d8                	mov    %ebx,%eax
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <sys_read>:
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ce5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ce8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ceb:	53                   	push   %ebx
80104cec:	6a 00                	push   $0x0
80104cee:	e8 1d fc ff ff       	call   80104910 <argint>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	78 5e                	js     80104d58 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cfe:	77 58                	ja     80104d58 <sys_read+0x78>
80104d00:	e8 8b ec ff ff       	call   80103990 <myproc>
80104d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d0c:	85 f6                	test   %esi,%esi
80104d0e:	74 48                	je     80104d58 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d10:	83 ec 08             	sub    $0x8,%esp
80104d13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d16:	50                   	push   %eax
80104d17:	6a 02                	push   $0x2
80104d19:	e8 f2 fb ff ff       	call   80104910 <argint>
80104d1e:	83 c4 10             	add    $0x10,%esp
80104d21:	85 c0                	test   %eax,%eax
80104d23:	78 33                	js     80104d58 <sys_read+0x78>
80104d25:	83 ec 04             	sub    $0x4,%esp
80104d28:	ff 75 f0             	push   -0x10(%ebp)
80104d2b:	53                   	push   %ebx
80104d2c:	6a 01                	push   $0x1
80104d2e:	e8 2d fc ff ff       	call   80104960 <argptr>
80104d33:	83 c4 10             	add    $0x10,%esp
80104d36:	85 c0                	test   %eax,%eax
80104d38:	78 1e                	js     80104d58 <sys_read+0x78>
  return fileread(f, p, n);
80104d3a:	83 ec 04             	sub    $0x4,%esp
80104d3d:	ff 75 f0             	push   -0x10(%ebp)
80104d40:	ff 75 f4             	push   -0xc(%ebp)
80104d43:	56                   	push   %esi
80104d44:	e8 d7 c2 ff ff       	call   80101020 <fileread>
80104d49:	83 c4 10             	add    $0x10,%esp
}
80104d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d4f:	5b                   	pop    %ebx
80104d50:	5e                   	pop    %esi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d57:	90                   	nop
    return -1;
80104d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d5d:	eb ed                	jmp    80104d4c <sys_read+0x6c>
80104d5f:	90                   	nop

80104d60 <sys_write>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d6b:	53                   	push   %ebx
80104d6c:	6a 00                	push   $0x0
80104d6e:	e8 9d fb ff ff       	call   80104910 <argint>
80104d73:	83 c4 10             	add    $0x10,%esp
80104d76:	85 c0                	test   %eax,%eax
80104d78:	78 5e                	js     80104dd8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d7e:	77 58                	ja     80104dd8 <sys_write+0x78>
80104d80:	e8 0b ec ff ff       	call   80103990 <myproc>
80104d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d8c:	85 f6                	test   %esi,%esi
80104d8e:	74 48                	je     80104dd8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d90:	83 ec 08             	sub    $0x8,%esp
80104d93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d96:	50                   	push   %eax
80104d97:	6a 02                	push   $0x2
80104d99:	e8 72 fb ff ff       	call   80104910 <argint>
80104d9e:	83 c4 10             	add    $0x10,%esp
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 33                	js     80104dd8 <sys_write+0x78>
80104da5:	83 ec 04             	sub    $0x4,%esp
80104da8:	ff 75 f0             	push   -0x10(%ebp)
80104dab:	53                   	push   %ebx
80104dac:	6a 01                	push   $0x1
80104dae:	e8 ad fb ff ff       	call   80104960 <argptr>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	78 1e                	js     80104dd8 <sys_write+0x78>
  return filewrite(f, p, n);
80104dba:	83 ec 04             	sub    $0x4,%esp
80104dbd:	ff 75 f0             	push   -0x10(%ebp)
80104dc0:	ff 75 f4             	push   -0xc(%ebp)
80104dc3:	56                   	push   %esi
80104dc4:	e8 e7 c2 ff ff       	call   801010b0 <filewrite>
80104dc9:	83 c4 10             	add    $0x10,%esp
}
80104dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dcf:	5b                   	pop    %ebx
80104dd0:	5e                   	pop    %esi
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    
80104dd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dd7:	90                   	nop
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddd:	eb ed                	jmp    80104dcc <sys_write+0x6c>
80104ddf:	90                   	nop

80104de0 <sys_close>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104de8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104deb:	50                   	push   %eax
80104dec:	6a 00                	push   $0x0
80104dee:	e8 1d fb ff ff       	call   80104910 <argint>
80104df3:	83 c4 10             	add    $0x10,%esp
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 3e                	js     80104e38 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dfe:	77 38                	ja     80104e38 <sys_close+0x58>
80104e00:	e8 8b eb ff ff       	call   80103990 <myproc>
80104e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e08:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e0b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e0f:	85 f6                	test   %esi,%esi
80104e11:	74 25                	je     80104e38 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e13:	e8 78 eb ff ff       	call   80103990 <myproc>
  fileclose(f);
80104e18:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e1b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e22:	00 
  fileclose(f);
80104e23:	56                   	push   %esi
80104e24:	e8 c7 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104e29:	83 c4 10             	add    $0x10,%esp
80104e2c:	31 c0                	xor    %eax,%eax
}
80104e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e31:	5b                   	pop    %ebx
80104e32:	5e                   	pop    %esi
80104e33:	5d                   	pop    %ebp
80104e34:	c3                   	ret    
80104e35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3d:	eb ef                	jmp    80104e2e <sys_close+0x4e>
80104e3f:	90                   	nop

80104e40 <sys_fstat>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	53                   	push   %ebx
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 bd fa ff ff       	call   80104910 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 46                	js     80104ea0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 40                	ja     80104ea0 <sys_fstat+0x60>
80104e60:	e8 2b eb ff ff       	call   80103990 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e6c:	85 f6                	test   %esi,%esi
80104e6e:	74 30                	je     80104ea0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	6a 14                	push   $0x14
80104e75:	53                   	push   %ebx
80104e76:	6a 01                	push   $0x1
80104e78:	e8 e3 fa ff ff       	call   80104960 <argptr>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 1c                	js     80104ea0 <sys_fstat+0x60>
  return filestat(f, st);
80104e84:	83 ec 08             	sub    $0x8,%esp
80104e87:	ff 75 f4             	push   -0xc(%ebp)
80104e8a:	56                   	push   %esi
80104e8b:	e8 40 c1 ff ff       	call   80100fd0 <filestat>
80104e90:	83 c4 10             	add    $0x10,%esp
}
80104e93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e96:	5b                   	pop    %ebx
80104e97:	5e                   	pop    %esi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret    
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea5:	eb ec                	jmp    80104e93 <sys_fstat+0x53>
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <sys_link>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104eb5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104eb8:	53                   	push   %ebx
80104eb9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ebc:	50                   	push   %eax
80104ebd:	6a 00                	push   $0x0
80104ebf:	e8 0c fb ff ff       	call   801049d0 <argstr>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	0f 88 fb 00 00 00    	js     80104fca <sys_link+0x11a>
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ed5:	50                   	push   %eax
80104ed6:	6a 01                	push   $0x1
80104ed8:	e8 f3 fa ff ff       	call   801049d0 <argstr>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	0f 88 e2 00 00 00    	js     80104fca <sys_link+0x11a>
  begin_op();
80104ee8:	e8 93 de ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	ff 75 d4             	push   -0x2c(%ebp)
80104ef3:	e8 c8 d1 ff ff       	call   801020c0 <namei>
80104ef8:	83 c4 10             	add    $0x10,%esp
80104efb:	89 c3                	mov    %eax,%ebx
80104efd:	85 c0                	test   %eax,%eax
80104eff:	0f 84 e4 00 00 00    	je     80104fe9 <sys_link+0x139>
  ilock(ip);
80104f05:	83 ec 0c             	sub    $0xc,%esp
80104f08:	50                   	push   %eax
80104f09:	e8 92 c8 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f16:	0f 84 b5 00 00 00    	je     80104fd1 <sys_link+0x121>
  iupdate(ip);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f1f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f24:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f27:	53                   	push   %ebx
80104f28:	e8 c3 c7 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
80104f2d:	89 1c 24             	mov    %ebx,(%esp)
80104f30:	e8 4b c9 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f35:	58                   	pop    %eax
80104f36:	5a                   	pop    %edx
80104f37:	57                   	push   %edi
80104f38:	ff 75 d0             	push   -0x30(%ebp)
80104f3b:	e8 a0 d1 ff ff       	call   801020e0 <nameiparent>
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	89 c6                	mov    %eax,%esi
80104f45:	85 c0                	test   %eax,%eax
80104f47:	74 5b                	je     80104fa4 <sys_link+0xf4>
  ilock(dp);
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	50                   	push   %eax
80104f4d:	e8 4e c8 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f52:	8b 03                	mov    (%ebx),%eax
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	39 06                	cmp    %eax,(%esi)
80104f59:	75 3d                	jne    80104f98 <sys_link+0xe8>
80104f5b:	83 ec 04             	sub    $0x4,%esp
80104f5e:	ff 73 04             	push   0x4(%ebx)
80104f61:	57                   	push   %edi
80104f62:	56                   	push   %esi
80104f63:	e8 98 d0 ff ff       	call   80102000 <dirlink>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	78 29                	js     80104f98 <sys_link+0xe8>
  iunlockput(dp);
80104f6f:	83 ec 0c             	sub    $0xc,%esp
80104f72:	56                   	push   %esi
80104f73:	e8 b8 ca ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80104f78:	89 1c 24             	mov    %ebx,(%esp)
80104f7b:	e8 50 c9 ff ff       	call   801018d0 <iput>
  end_op();
80104f80:	e8 6b de ff ff       	call   80102df0 <end_op>
  return 0;
80104f85:	83 c4 10             	add    $0x10,%esp
80104f88:	31 c0                	xor    %eax,%eax
}
80104f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f8d:	5b                   	pop    %ebx
80104f8e:	5e                   	pop    %esi
80104f8f:	5f                   	pop    %edi
80104f90:	5d                   	pop    %ebp
80104f91:	c3                   	ret    
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	56                   	push   %esi
80104f9c:	e8 8f ca ff ff       	call   80101a30 <iunlockput>
    goto bad;
80104fa1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	53                   	push   %ebx
80104fa8:	e8 f3 c7 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80104fad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fb2:	89 1c 24             	mov    %ebx,(%esp)
80104fb5:	e8 36 c7 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80104fba:	89 1c 24             	mov    %ebx,(%esp)
80104fbd:	e8 6e ca ff ff       	call   80101a30 <iunlockput>
  end_op();
80104fc2:	e8 29 de ff ff       	call   80102df0 <end_op>
  return -1;
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcf:	eb b9                	jmp    80104f8a <sys_link+0xda>
    iunlockput(ip);
80104fd1:	83 ec 0c             	sub    $0xc,%esp
80104fd4:	53                   	push   %ebx
80104fd5:	e8 56 ca ff ff       	call   80101a30 <iunlockput>
    end_op();
80104fda:	e8 11 de ff ff       	call   80102df0 <end_op>
    return -1;
80104fdf:	83 c4 10             	add    $0x10,%esp
80104fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe7:	eb a1                	jmp    80104f8a <sys_link+0xda>
    end_op();
80104fe9:	e8 02 de ff ff       	call   80102df0 <end_op>
    return -1;
80104fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff3:	eb 95                	jmp    80104f8a <sys_link+0xda>
80104ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_unlink>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105005:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105008:	53                   	push   %ebx
80105009:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010500c:	50                   	push   %eax
8010500d:	6a 00                	push   $0x0
8010500f:	e8 bc f9 ff ff       	call   801049d0 <argstr>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 7a 01 00 00    	js     80105199 <sys_unlink+0x199>
  begin_op();
8010501f:	e8 5c dd ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105024:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105027:	83 ec 08             	sub    $0x8,%esp
8010502a:	53                   	push   %ebx
8010502b:	ff 75 c0             	push   -0x40(%ebp)
8010502e:	e8 ad d0 ff ff       	call   801020e0 <nameiparent>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105039:	85 c0                	test   %eax,%eax
8010503b:	0f 84 62 01 00 00    	je     801051a3 <sys_unlink+0x1a3>
  ilock(dp);
80105041:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	57                   	push   %edi
80105048:	e8 53 c7 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010504d:	58                   	pop    %eax
8010504e:	5a                   	pop    %edx
8010504f:	68 1c 7c 10 80       	push   $0x80107c1c
80105054:	53                   	push   %ebx
80105055:	e8 86 cc ff ff       	call   80101ce0 <namecmp>
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	85 c0                	test   %eax,%eax
8010505f:	0f 84 fb 00 00 00    	je     80105160 <sys_unlink+0x160>
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	68 1b 7c 10 80       	push   $0x80107c1b
8010506d:	53                   	push   %ebx
8010506e:	e8 6d cc ff ff       	call   80101ce0 <namecmp>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	0f 84 e2 00 00 00    	je     80105160 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010507e:	83 ec 04             	sub    $0x4,%esp
80105081:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105084:	50                   	push   %eax
80105085:	53                   	push   %ebx
80105086:	57                   	push   %edi
80105087:	e8 74 cc ff ff       	call   80101d00 <dirlookup>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	89 c3                	mov    %eax,%ebx
80105091:	85 c0                	test   %eax,%eax
80105093:	0f 84 c7 00 00 00    	je     80105160 <sys_unlink+0x160>
  ilock(ip);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 fe c6 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050aa:	0f 8e 1c 01 00 00    	jle    801051cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050b8:	74 66                	je     80105120 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050ba:	83 ec 04             	sub    $0x4,%esp
801050bd:	6a 10                	push   $0x10
801050bf:	6a 00                	push   $0x0
801050c1:	57                   	push   %edi
801050c2:	e8 89 f5 ff ff       	call   80104650 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050c7:	6a 10                	push   $0x10
801050c9:	ff 75 c4             	push   -0x3c(%ebp)
801050cc:	57                   	push   %edi
801050cd:	ff 75 b4             	push   -0x4c(%ebp)
801050d0:	e8 db ca ff ff       	call   80101bb0 <writei>
801050d5:	83 c4 20             	add    $0x20,%esp
801050d8:	83 f8 10             	cmp    $0x10,%eax
801050db:	0f 85 de 00 00 00    	jne    801051bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801050e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050e6:	0f 84 94 00 00 00    	je     80105180 <sys_unlink+0x180>
  iunlockput(dp);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	ff 75 b4             	push   -0x4c(%ebp)
801050f2:	e8 39 c9 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801050f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050fc:	89 1c 24             	mov    %ebx,(%esp)
801050ff:	e8 ec c5 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105104:	89 1c 24             	mov    %ebx,(%esp)
80105107:	e8 24 c9 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010510c:	e8 df dc ff ff       	call   80102df0 <end_op>
  return 0;
80105111:	83 c4 10             	add    $0x10,%esp
80105114:	31 c0                	xor    %eax,%eax
}
80105116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5f                   	pop    %edi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105120:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105124:	76 94                	jbe    801050ba <sys_unlink+0xba>
80105126:	be 20 00 00 00       	mov    $0x20,%esi
8010512b:	eb 0b                	jmp    80105138 <sys_unlink+0x138>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c6 10             	add    $0x10,%esi
80105133:	3b 73 58             	cmp    0x58(%ebx),%esi
80105136:	73 82                	jae    801050ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105138:	6a 10                	push   $0x10
8010513a:	56                   	push   %esi
8010513b:	57                   	push   %edi
8010513c:	53                   	push   %ebx
8010513d:	e8 6e c9 ff ff       	call   80101ab0 <readi>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	83 f8 10             	cmp    $0x10,%eax
80105148:	75 68                	jne    801051b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010514a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010514f:	74 df                	je     80105130 <sys_unlink+0x130>
    iunlockput(ip);
80105151:	83 ec 0c             	sub    $0xc,%esp
80105154:	53                   	push   %ebx
80105155:	e8 d6 c8 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	ff 75 b4             	push   -0x4c(%ebp)
80105166:	e8 c5 c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010516b:	e8 80 dc ff ff       	call   80102df0 <end_op>
  return -1;
80105170:	83 c4 10             	add    $0x10,%esp
80105173:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105178:	eb 9c                	jmp    80105116 <sys_unlink+0x116>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105180:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105183:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105186:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010518b:	50                   	push   %eax
8010518c:	e8 5f c5 ff ff       	call   801016f0 <iupdate>
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	e9 53 ff ff ff       	jmp    801050ec <sys_unlink+0xec>
    return -1;
80105199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519e:	e9 73 ff ff ff       	jmp    80105116 <sys_unlink+0x116>
    end_op();
801051a3:	e8 48 dc ff ff       	call   80102df0 <end_op>
    return -1;
801051a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ad:	e9 64 ff ff ff       	jmp    80105116 <sys_unlink+0x116>
      panic("isdirempty: readi");
801051b2:	83 ec 0c             	sub    $0xc,%esp
801051b5:	68 40 7c 10 80       	push   $0x80107c40
801051ba:	e8 c1 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	68 52 7c 10 80       	push   $0x80107c52
801051c7:	e8 b4 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	68 2e 7c 10 80       	push   $0x80107c2e
801051d4:	e8 a7 b1 ff ff       	call   80100380 <panic>
801051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_open>:

int
sys_open(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801051e8:	53                   	push   %ebx
801051e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051ec:	50                   	push   %eax
801051ed:	6a 00                	push   $0x0
801051ef:	e8 dc f7 ff ff       	call   801049d0 <argstr>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	0f 88 8e 00 00 00    	js     8010528d <sys_open+0xad>
801051ff:	83 ec 08             	sub    $0x8,%esp
80105202:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105205:	50                   	push   %eax
80105206:	6a 01                	push   $0x1
80105208:	e8 03 f7 ff ff       	call   80104910 <argint>
8010520d:	83 c4 10             	add    $0x10,%esp
80105210:	85 c0                	test   %eax,%eax
80105212:	78 79                	js     8010528d <sys_open+0xad>
    return -1;

  begin_op();
80105214:	e8 67 db ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
80105219:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010521d:	75 79                	jne    80105298 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	ff 75 e0             	push   -0x20(%ebp)
80105225:	e8 96 ce ff ff       	call   801020c0 <namei>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	89 c6                	mov    %eax,%esi
8010522f:	85 c0                	test   %eax,%eax
80105231:	0f 84 7e 00 00 00    	je     801052b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	50                   	push   %eax
8010523b:	e8 60 c5 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105248:	0f 84 c2 00 00 00    	je     80105310 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010524e:	e8 dd bb ff ff       	call   80100e30 <filealloc>
80105253:	89 c7                	mov    %eax,%edi
80105255:	85 c0                	test   %eax,%eax
80105257:	74 23                	je     8010527c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105259:	e8 32 e7 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010525e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105260:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105264:	85 d2                	test   %edx,%edx
80105266:	74 60                	je     801052c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105268:	83 c3 01             	add    $0x1,%ebx
8010526b:	83 fb 10             	cmp    $0x10,%ebx
8010526e:	75 f0                	jne    80105260 <sys_open+0x80>
    if(f)
      fileclose(f);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	57                   	push   %edi
80105274:	e8 77 bc ff ff       	call   80100ef0 <fileclose>
80105279:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	56                   	push   %esi
80105280:	e8 ab c7 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105285:	e8 66 db ff ff       	call   80102df0 <end_op>
    return -1;
8010528a:	83 c4 10             	add    $0x10,%esp
8010528d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105292:	eb 6d                	jmp    80105301 <sys_open+0x121>
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010529e:	31 c9                	xor    %ecx,%ecx
801052a0:	ba 02 00 00 00       	mov    $0x2,%edx
801052a5:	6a 00                	push   $0x0
801052a7:	e8 14 f8 ff ff       	call   80104ac0 <create>
    if(ip == 0){
801052ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052b1:	85 c0                	test   %eax,%eax
801052b3:	75 99                	jne    8010524e <sys_open+0x6e>
      end_op();
801052b5:	e8 36 db ff ff       	call   80102df0 <end_op>
      return -1;
801052ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052bf:	eb 40                	jmp    80105301 <sys_open+0x121>
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052cf:	56                   	push   %esi
801052d0:	e8 ab c5 ff ff       	call   80101880 <iunlock>
  end_op();
801052d5:	e8 16 db ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
801052da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801052e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801052eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801052f2:	f7 d0                	not    %eax
801052f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801052fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105304:	89 d8                	mov    %ebx,%eax
80105306:	5b                   	pop    %ebx
80105307:	5e                   	pop    %esi
80105308:	5f                   	pop    %edi
80105309:	5d                   	pop    %ebp
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105313:	85 c9                	test   %ecx,%ecx
80105315:	0f 84 33 ff ff ff    	je     8010524e <sys_open+0x6e>
8010531b:	e9 5c ff ff ff       	jmp    8010527c <sys_open+0x9c>

80105320 <sys_mkdir>:

int
sys_mkdir(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105326:	e8 55 da ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010532b:	83 ec 08             	sub    $0x8,%esp
8010532e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105331:	50                   	push   %eax
80105332:	6a 00                	push   $0x0
80105334:	e8 97 f6 ff ff       	call   801049d0 <argstr>
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	85 c0                	test   %eax,%eax
8010533e:	78 30                	js     80105370 <sys_mkdir+0x50>
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105346:	31 c9                	xor    %ecx,%ecx
80105348:	ba 01 00 00 00       	mov    $0x1,%edx
8010534d:	6a 00                	push   $0x0
8010534f:	e8 6c f7 ff ff       	call   80104ac0 <create>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	74 15                	je     80105370 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535b:	83 ec 0c             	sub    $0xc,%esp
8010535e:	50                   	push   %eax
8010535f:	e8 cc c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105364:	e8 87 da ff ff       	call   80102df0 <end_op>
  return 0;
80105369:	83 c4 10             	add    $0x10,%esp
8010536c:	31 c0                	xor    %eax,%eax
}
8010536e:	c9                   	leave  
8010536f:	c3                   	ret    
    end_op();
80105370:	e8 7b da ff ff       	call   80102df0 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_mknod>:

int
sys_mknod(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105386:	e8 f5 d9 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010538b:	83 ec 08             	sub    $0x8,%esp
8010538e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105391:	50                   	push   %eax
80105392:	6a 00                	push   $0x0
80105394:	e8 37 f6 ff ff       	call   801049d0 <argstr>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	85 c0                	test   %eax,%eax
8010539e:	78 60                	js     80105400 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053a0:	83 ec 08             	sub    $0x8,%esp
801053a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053a6:	50                   	push   %eax
801053a7:	6a 01                	push   $0x1
801053a9:	e8 62 f5 ff ff       	call   80104910 <argint>
  if((argstr(0, &path)) < 0 ||
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 4b                	js     80105400 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053b5:	83 ec 08             	sub    $0x8,%esp
801053b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053bb:	50                   	push   %eax
801053bc:	6a 02                	push   $0x2
801053be:	e8 4d f5 ff ff       	call   80104910 <argint>
     argint(1, &major) < 0 ||
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	78 36                	js     80105400 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053ce:	83 ec 0c             	sub    $0xc,%esp
801053d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053d5:	ba 03 00 00 00       	mov    $0x3,%edx
801053da:	50                   	push   %eax
801053db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053de:	e8 dd f6 ff ff       	call   80104ac0 <create>
     argint(2, &minor) < 0 ||
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 16                	je     80105400 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	50                   	push   %eax
801053ee:	e8 3d c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
801053f3:	e8 f8 d9 ff ff       	call   80102df0 <end_op>
  return 0;
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	31 c0                	xor    %eax,%eax
}
801053fd:	c9                   	leave  
801053fe:	c3                   	ret    
801053ff:	90                   	nop
    end_op();
80105400:	e8 eb d9 ff ff       	call   80102df0 <end_op>
    return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540a:	c9                   	leave  
8010540b:	c3                   	ret    
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_chdir>:

int
sys_chdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	56                   	push   %esi
80105414:	53                   	push   %ebx
80105415:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105418:	e8 73 e5 ff ff       	call   80103990 <myproc>
8010541d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010541f:	e8 5c d9 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105424:	83 ec 08             	sub    $0x8,%esp
80105427:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542a:	50                   	push   %eax
8010542b:	6a 00                	push   $0x0
8010542d:	e8 9e f5 ff ff       	call   801049d0 <argstr>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	78 77                	js     801054b0 <sys_chdir+0xa0>
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	ff 75 f4             	push   -0xc(%ebp)
8010543f:	e8 7c cc ff ff       	call   801020c0 <namei>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	89 c3                	mov    %eax,%ebx
80105449:	85 c0                	test   %eax,%eax
8010544b:	74 63                	je     801054b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010544d:	83 ec 0c             	sub    $0xc,%esp
80105450:	50                   	push   %eax
80105451:	e8 4a c3 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010545e:	75 30                	jne    80105490 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	53                   	push   %ebx
80105464:	e8 17 c4 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105469:	58                   	pop    %eax
8010546a:	ff 76 68             	push   0x68(%esi)
8010546d:	e8 5e c4 ff ff       	call   801018d0 <iput>
  end_op();
80105472:	e8 79 d9 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
80105477:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	31 c0                	xor    %eax,%eax
}
8010547f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105482:	5b                   	pop    %ebx
80105483:	5e                   	pop    %esi
80105484:	5d                   	pop    %ebp
80105485:	c3                   	ret    
80105486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	53                   	push   %ebx
80105494:	e8 97 c5 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105499:	e8 52 d9 ff ff       	call   80102df0 <end_op>
    return -1;
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a6:	eb d7                	jmp    8010547f <sys_chdir+0x6f>
801054a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop
    end_op();
801054b0:	e8 3b d9 ff ff       	call   80102df0 <end_op>
    return -1;
801054b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ba:	eb c3                	jmp    8010547f <sys_chdir+0x6f>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <sys_exec>:

int
sys_exec(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054cb:	53                   	push   %ebx
801054cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054d2:	50                   	push   %eax
801054d3:	6a 00                	push   $0x0
801054d5:	e8 f6 f4 ff ff       	call   801049d0 <argstr>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	85 c0                	test   %eax,%eax
801054df:	0f 88 87 00 00 00    	js     8010556c <sys_exec+0xac>
801054e5:	83 ec 08             	sub    $0x8,%esp
801054e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054ee:	50                   	push   %eax
801054ef:	6a 01                	push   $0x1
801054f1:	e8 1a f4 ff ff       	call   80104910 <argint>
801054f6:	83 c4 10             	add    $0x10,%esp
801054f9:	85 c0                	test   %eax,%eax
801054fb:	78 6f                	js     8010556c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054fd:	83 ec 04             	sub    $0x4,%esp
80105500:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105506:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105508:	68 80 00 00 00       	push   $0x80
8010550d:	6a 00                	push   $0x0
8010550f:	56                   	push   %esi
80105510:	e8 3b f1 ff ff       	call   80104650 <memset>
80105515:	83 c4 10             	add    $0x10,%esp
80105518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105529:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105530:	50                   	push   %eax
80105531:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105537:	01 f8                	add    %edi,%eax
80105539:	50                   	push   %eax
8010553a:	e8 41 f3 ff ff       	call   80104880 <fetchint>
8010553f:	83 c4 10             	add    $0x10,%esp
80105542:	85 c0                	test   %eax,%eax
80105544:	78 26                	js     8010556c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105546:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010554c:	85 c0                	test   %eax,%eax
8010554e:	74 30                	je     80105580 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105550:	83 ec 08             	sub    $0x8,%esp
80105553:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105556:	52                   	push   %edx
80105557:	50                   	push   %eax
80105558:	e8 63 f3 ff ff       	call   801048c0 <fetchstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 08                	js     8010556c <sys_exec+0xac>
  for(i=0;; i++){
80105564:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105567:	83 fb 20             	cmp    $0x20,%ebx
8010556a:	75 b4                	jne    80105520 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010556c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010556f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105574:	5b                   	pop    %ebx
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105580:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105587:	00 00 00 00 
  return exec(path, argv);
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	56                   	push   %esi
8010558f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105595:	e8 16 b5 ff ff       	call   80100ab0 <exec>
8010559a:	83 c4 10             	add    $0x10,%esp
}
8010559d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a0:	5b                   	pop    %ebx
801055a1:	5e                   	pop    %esi
801055a2:	5f                   	pop    %edi
801055a3:	5d                   	pop    %ebp
801055a4:	c3                   	ret    
801055a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_pipe>:

int
sys_pipe(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055b8:	53                   	push   %ebx
801055b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055bc:	6a 08                	push   $0x8
801055be:	50                   	push   %eax
801055bf:	6a 00                	push   $0x0
801055c1:	e8 9a f3 ff ff       	call   80104960 <argptr>
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	85 c0                	test   %eax,%eax
801055cb:	78 4a                	js     80105617 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055cd:	83 ec 08             	sub    $0x8,%esp
801055d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055d3:	50                   	push   %eax
801055d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055d7:	50                   	push   %eax
801055d8:	e8 73 de ff ff       	call   80103450 <pipealloc>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 33                	js     80105617 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801055e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055e9:	e8 a2 e3 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801055f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055f4:	85 f6                	test   %esi,%esi
801055f6:	74 28                	je     80105620 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801055f8:	83 c3 01             	add    $0x1,%ebx
801055fb:	83 fb 10             	cmp    $0x10,%ebx
801055fe:	75 f0                	jne    801055f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	ff 75 e0             	push   -0x20(%ebp)
80105606:	e8 e5 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010560b:	58                   	pop    %eax
8010560c:	ff 75 e4             	push   -0x1c(%ebp)
8010560f:	e8 dc b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561c:	eb 53                	jmp    80105671 <sys_pipe+0xc1>
8010561e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105620:	8d 73 08             	lea    0x8(%ebx),%esi
80105623:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105627:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010562a:	e8 61 e3 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010562f:	31 d2                	xor    %edx,%edx
80105631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105638:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010563c:	85 c9                	test   %ecx,%ecx
8010563e:	74 20                	je     80105660 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105640:	83 c2 01             	add    $0x1,%edx
80105643:	83 fa 10             	cmp    $0x10,%edx
80105646:	75 f0                	jne    80105638 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105648:	e8 43 e3 ff ff       	call   80103990 <myproc>
8010564d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105654:	00 
80105655:	eb a9                	jmp    80105600 <sys_pipe+0x50>
80105657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105660:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105664:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105667:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105669:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010566c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010566f:	31 c0                	xor    %eax,%eax
}
80105671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105674:	5b                   	pop    %ebx
80105675:	5e                   	pop    %esi
80105676:	5f                   	pop    %edi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	66 90                	xchg   %ax,%ax
8010567b:	66 90                	xchg   %ax,%ax
8010567d:	66 90                	xchg   %ax,%ax
8010567f:	90                   	nop

80105680 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105686:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105689:	50                   	push   %eax
8010568a:	6a 00                	push   $0x0
8010568c:	e8 7f f2 ff ff       	call   80104910 <argint>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	78 30                	js     801056c8 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
80105698:	83 ec 04             	sub    $0x4,%esp
8010569b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569e:	6a 04                	push   $0x4
801056a0:	50                   	push   %eax
801056a1:	6a 01                	push   $0x1
801056a3:	e8 b8 f2 ff ff       	call   80104960 <argptr>
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	85 c0                	test   %eax,%eax
801056ad:	78 19                	js     801056c8 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	ff 75 f4             	push   -0xc(%ebp)
801056b5:	ff 75 f0             	push   -0x10(%ebp)
801056b8:	e8 a3 1b 00 00       	call   80107260 <shm_open>
801056bd:	83 c4 10             	add    $0x10,%esp
}
801056c0:	c9                   	leave  
801056c1:	c3                   	ret    
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c8:	c9                   	leave  
    return -1;
801056c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_shm_close>:

int sys_shm_close(void) {
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
801056d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d9:	50                   	push   %eax
801056da:	6a 00                	push   $0x0
801056dc:	e8 2f f2 ff ff       	call   80104910 <argint>
801056e1:	83 c4 10             	add    $0x10,%esp
801056e4:	85 c0                	test   %eax,%eax
801056e6:	78 18                	js     80105700 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801056e8:	83 ec 0c             	sub    $0xc,%esp
801056eb:	ff 75 f4             	push   -0xc(%ebp)
801056ee:	e8 2d 1d 00 00       	call   80107420 <shm_close>
801056f3:	83 c4 10             	add    $0x10,%esp
}
801056f6:	c9                   	leave  
801056f7:	c3                   	ret    
801056f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop
80105700:	c9                   	leave  
    return -1;
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105706:	c3                   	ret    
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105710:	e9 1b e4 ff ff       	jmp    80103b30 <fork>
80105715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_exit>:
}

int
sys_exit(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 08             	sub    $0x8,%esp
  exit();
80105726:	e8 85 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
8010572b:	31 c0                	xor    %eax,%eax
8010572d:	c9                   	leave  
8010572e:	c3                   	ret    
8010572f:	90                   	nop

80105730 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105730:	e9 ab e7 ff ff       	jmp    80103ee0 <wait>
80105735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_kill>:
}

int
sys_kill(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105749:	50                   	push   %eax
8010574a:	6a 00                	push   $0x0
8010574c:	e8 bf f1 ff ff       	call   80104910 <argint>
80105751:	83 c4 10             	add    $0x10,%esp
80105754:	85 c0                	test   %eax,%eax
80105756:	78 18                	js     80105770 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	ff 75 f4             	push   -0xc(%ebp)
8010575e:	e8 1d ea ff ff       	call   80104180 <kill>
80105763:	83 c4 10             	add    $0x10,%esp
}
80105766:	c9                   	leave  
80105767:	c3                   	ret    
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
80105770:	c9                   	leave  
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret    
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_getpid>:

int
sys_getpid(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105786:	e8 05 e2 ff ff       	call   80103990 <myproc>
8010578b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010578e:	c9                   	leave  
8010578f:	c3                   	ret    

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105797:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 6e f1 ff ff       	call   80104910 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 27                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057a9:	e8 e2 e1 ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
801057ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b3:	ff 75 f4             	push   -0xc(%ebp)
801057b6:	e8 f5 e2 ff ff       	call   80103ab0 <growproc>
801057bb:	83 c4 10             	add    $0x10,%esp
801057be:	85 c0                	test   %eax,%eax
801057c0:	78 0e                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c2:	89 d8                	mov    %ebx,%eax
801057c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb eb                	jmp    801057c2 <sys_sbrk+0x32>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 1e f1 ff ff       	call   80104910 <argint>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	0f 88 8a 00 00 00    	js     80105887 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 80 3c 11 80       	push   $0x80113c80
80105805:	e8 d6 ec ff ff       	call   801044e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010580a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010580d:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 d2                	test   %edx,%edx
80105818:	75 27                	jne    80105841 <sys_sleep+0x61>
8010581a:	eb 54                	jmp    80105870 <sys_sleep+0x90>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 80 3c 11 80       	push   $0x80113c80
80105828:	68 60 3c 11 80       	push   $0x80113c60
8010582d:	e8 2e e8 ff ff       	call   80104060 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 4a e1 ff ff       	call   80103990 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 80 3c 11 80       	push   $0x80113c80
80105855:	e8 a6 ed ff ff       	call   80104600 <release>
  }
  release(&tickslock);
  return 0;
}
8010585a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 80 3c 11 80       	push   $0x80113c80
80105878:	e8 83 ed ff ff       	call   80104600 <release>
  return 0;
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
    return -1;
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb f4                	jmp    80105882 <sys_sleep+0xa2>
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
80105894:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105897:	68 80 3c 11 80       	push   $0x80113c80
8010589c:	e8 3f ec ff ff       	call   801044e0 <acquire>
  xticks = ticks;
801058a1:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
801058a7:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
801058ae:	e8 4d ed ff ff       	call   80104600 <release>
  return xticks;
}
801058b3:	89 d8                	mov    %ebx,%eax
801058b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058b8:	c9                   	leave  
801058b9:	c3                   	ret    

801058ba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ba:	1e                   	push   %ds
  pushl %es
801058bb:	06                   	push   %es
  pushl %fs
801058bc:	0f a0                	push   %fs
  pushl %gs
801058be:	0f a8                	push   %gs
  pushal
801058c0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058c1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058c5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058c7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058c9:	54                   	push   %esp
  call trap
801058ca:	e8 c1 00 00 00       	call   80105990 <trap>
  addl $4, %esp
801058cf:	83 c4 04             	add    $0x4,%esp

801058d2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058d2:	61                   	popa   
  popl %gs
801058d3:	0f a9                	pop    %gs
  popl %fs
801058d5:	0f a1                	pop    %fs
  popl %es
801058d7:	07                   	pop    %es
  popl %ds
801058d8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058d9:	83 c4 08             	add    $0x8,%esp
  iret
801058dc:	cf                   	iret   
801058dd:	66 90                	xchg   %ax,%ax
801058df:	90                   	nop

801058e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058e1:	31 c0                	xor    %eax,%eax
{
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058f0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058f7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801058fe:	08 00 00 8e 
80105902:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105909:	80 
8010590a:	c1 ea 10             	shr    $0x10,%edx
8010590d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105914:	80 
  for(i = 0; i < 256; i++)
80105915:	83 c0 01             	add    $0x1,%eax
80105918:	3d 00 01 00 00       	cmp    $0x100,%eax
8010591d:	75 d1                	jne    801058f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010591f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105922:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105927:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
8010592e:	00 00 ef 
  initlock(&tickslock, "time");
80105931:	68 61 7c 10 80       	push   $0x80107c61
80105936:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010593b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105941:	c1 e8 10             	shr    $0x10,%eax
80105944:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
8010594a:	e8 81 ea ff ff       	call   801043d0 <initlock>
}
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	c9                   	leave  
80105953:	c3                   	ret    
80105954:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop

80105960 <idtinit>:

void
idtinit(void)
{
80105960:	55                   	push   %ebp
  pd[0] = size-1;
80105961:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105966:	89 e5                	mov    %esp,%ebp
80105968:	83 ec 10             	sub    $0x10,%esp
8010596b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010596f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105974:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105978:	c1 e8 10             	shr    $0x10,%eax
8010597b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010597f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105982:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
80105995:	53                   	push   %ebx
80105996:	83 ec 1c             	sub    $0x1c,%esp
80105999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010599c:	8b 43 30             	mov    0x30(%ebx),%eax
8010599f:	83 f8 40             	cmp    $0x40,%eax
801059a2:	0f 84 68 01 00 00    	je     80105b10 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059a8:	83 e8 20             	sub    $0x20,%eax
801059ab:	83 f8 1f             	cmp    $0x1f,%eax
801059ae:	0f 87 8c 00 00 00    	ja     80105a40 <trap+0xb0>
801059b4:	ff 24 85 08 7d 10 80 	jmp    *-0x7fef82f8(,%eax,4)
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059c0:	e8 9b c8 ff ff       	call   80102260 <ideintr>
    lapiceoi();
801059c5:	e8 66 cf ff ff       	call   80102930 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059ca:	e8 c1 df ff ff       	call   80103990 <myproc>
801059cf:	85 c0                	test   %eax,%eax
801059d1:	74 1d                	je     801059f0 <trap+0x60>
801059d3:	e8 b8 df ff ff       	call   80103990 <myproc>
801059d8:	8b 50 24             	mov    0x24(%eax),%edx
801059db:	85 d2                	test   %edx,%edx
801059dd:	74 11                	je     801059f0 <trap+0x60>
801059df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059e3:	83 e0 03             	and    $0x3,%eax
801059e6:	66 83 f8 03          	cmp    $0x3,%ax
801059ea:	0f 84 e8 01 00 00    	je     80105bd8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059f0:	e8 9b df ff ff       	call   80103990 <myproc>
801059f5:	85 c0                	test   %eax,%eax
801059f7:	74 0f                	je     80105a08 <trap+0x78>
801059f9:	e8 92 df ff ff       	call   80103990 <myproc>
801059fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a02:	0f 84 b8 00 00 00    	je     80105ac0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a08:	e8 83 df ff ff       	call   80103990 <myproc>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	74 1d                	je     80105a2e <trap+0x9e>
80105a11:	e8 7a df ff ff       	call   80103990 <myproc>
80105a16:	8b 40 24             	mov    0x24(%eax),%eax
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 11                	je     80105a2e <trap+0x9e>
80105a1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a21:	83 e0 03             	and    $0x3,%eax
80105a24:	66 83 f8 03          	cmp    $0x3,%ax
80105a28:	0f 84 0f 01 00 00    	je     80105b3d <trap+0x1ad>
    exit();
}
80105a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a31:	5b                   	pop    %ebx
80105a32:	5e                   	pop    %esi
80105a33:	5f                   	pop    %edi
80105a34:	5d                   	pop    %ebp
80105a35:	c3                   	ret    
80105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a40:	e8 4b df ff ff       	call   80103990 <myproc>
80105a45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	0f 84 a2 01 00 00    	je     80105bf2 <trap+0x262>
80105a50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a54:	0f 84 98 01 00 00    	je     80105bf2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a5a:	0f 20 d1             	mov    %cr2,%ecx
80105a5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a60:	e8 0b df ff ff       	call   80103970 <cpuid>
80105a65:	8b 73 30             	mov    0x30(%ebx),%esi
80105a68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a71:	e8 1a df ff ff       	call   80103990 <myproc>
80105a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a79:	e8 12 df ff ff       	call   80103990 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a84:	51                   	push   %ecx
80105a85:	57                   	push   %edi
80105a86:	52                   	push   %edx
80105a87:	ff 75 e4             	push   -0x1c(%ebp)
80105a8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a91:	56                   	push   %esi
80105a92:	ff 70 10             	push   0x10(%eax)
80105a95:	68 c4 7c 10 80       	push   $0x80107cc4
80105a9a:	e8 01 ac ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105a9f:	83 c4 20             	add    $0x20,%esp
80105aa2:	e8 e9 de ff ff       	call   80103990 <myproc>
80105aa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aae:	e8 dd de ff ff       	call   80103990 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	0f 85 18 ff ff ff    	jne    801059d3 <trap+0x43>
80105abb:	e9 30 ff ff ff       	jmp    801059f0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ac0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ac4:	0f 85 3e ff ff ff    	jne    80105a08 <trap+0x78>
    yield();
80105aca:	e8 41 e5 ff ff       	call   80104010 <yield>
80105acf:	e9 34 ff ff ff       	jmp    80105a08 <trap+0x78>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ad8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105adb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105adf:	e8 8c de ff ff       	call   80103970 <cpuid>
80105ae4:	57                   	push   %edi
80105ae5:	56                   	push   %esi
80105ae6:	50                   	push   %eax
80105ae7:	68 6c 7c 10 80       	push   $0x80107c6c
80105aec:	e8 af ab ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105af1:	e8 3a ce ff ff       	call   80102930 <lapiceoi>
    break;
80105af6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af9:	e8 92 de ff ff       	call   80103990 <myproc>
80105afe:	85 c0                	test   %eax,%eax
80105b00:	0f 85 cd fe ff ff    	jne    801059d3 <trap+0x43>
80105b06:	e9 e5 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
    if(myproc()->killed)
80105b10:	e8 7b de ff ff       	call   80103990 <myproc>
80105b15:	8b 70 24             	mov    0x24(%eax),%esi
80105b18:	85 f6                	test   %esi,%esi
80105b1a:	0f 85 c8 00 00 00    	jne    80105be8 <trap+0x258>
    myproc()->tf = tf;
80105b20:	e8 6b de ff ff       	call   80103990 <myproc>
80105b25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b28:	e8 23 ef ff ff       	call   80104a50 <syscall>
    if(myproc()->killed)
80105b2d:	e8 5e de ff ff       	call   80103990 <myproc>
80105b32:	8b 48 24             	mov    0x24(%eax),%ecx
80105b35:	85 c9                	test   %ecx,%ecx
80105b37:	0f 84 f1 fe ff ff    	je     80105a2e <trap+0x9e>
}
80105b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b40:	5b                   	pop    %ebx
80105b41:	5e                   	pop    %esi
80105b42:	5f                   	pop    %edi
80105b43:	5d                   	pop    %ebp
      exit();
80105b44:	e9 67 e2 ff ff       	jmp    80103db0 <exit>
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b50:	e8 3b 02 00 00       	call   80105d90 <uartintr>
    lapiceoi();
80105b55:	e8 d6 cd ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5a:	e8 31 de ff ff       	call   80103990 <myproc>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	0f 85 6c fe ff ff    	jne    801059d3 <trap+0x43>
80105b67:	e9 84 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b70:	e8 7b cc ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
80105b75:	e8 b6 cd ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7a:	e8 11 de ff ff       	call   80103990 <myproc>
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	0f 85 4c fe ff ff    	jne    801059d3 <trap+0x43>
80105b87:	e9 64 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b90:	e8 db dd ff ff       	call   80103970 <cpuid>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 85 28 fe ff ff    	jne    801059c5 <trap+0x35>
      acquire(&tickslock);
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 80 3c 11 80       	push   $0x80113c80
80105ba5:	e8 36 e9 ff ff       	call   801044e0 <acquire>
      wakeup(&ticks);
80105baa:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
      ticks++;
80105bb1:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105bb8:	e8 63 e5 ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80105bbd:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105bc4:	e8 37 ea ff ff       	call   80104600 <release>
80105bc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105bcc:	e9 f4 fd ff ff       	jmp    801059c5 <trap+0x35>
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105bd8:	e8 d3 e1 ff ff       	call   80103db0 <exit>
80105bdd:	e9 0e fe ff ff       	jmp    801059f0 <trap+0x60>
80105be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105be8:	e8 c3 e1 ff ff       	call   80103db0 <exit>
80105bed:	e9 2e ff ff ff       	jmp    80105b20 <trap+0x190>
80105bf2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bf5:	e8 76 dd ff ff       	call   80103970 <cpuid>
80105bfa:	83 ec 0c             	sub    $0xc,%esp
80105bfd:	56                   	push   %esi
80105bfe:	57                   	push   %edi
80105bff:	50                   	push   %eax
80105c00:	ff 73 30             	push   0x30(%ebx)
80105c03:	68 90 7c 10 80       	push   $0x80107c90
80105c08:	e8 93 aa ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105c0d:	83 c4 14             	add    $0x14,%esp
80105c10:	68 66 7c 10 80       	push   $0x80107c66
80105c15:	e8 66 a7 ff ff       	call   80100380 <panic>
80105c1a:	66 90                	xchg   %ax,%ax
80105c1c:	66 90                	xchg   %ax,%ax
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c20:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105c25:	85 c0                	test   %eax,%eax
80105c27:	74 17                	je     80105c40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c2f:	a8 01                	test   $0x1,%al
80105c31:	74 0d                	je     80105c40 <uartgetc+0x20>
80105c33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c39:	0f b6 c0             	movzbl %al,%eax
80105c3c:	c3                   	ret    
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c45:	c3                   	ret    
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi

80105c50 <uartinit>:
{
80105c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c51:	31 c9                	xor    %ecx,%ecx
80105c53:	89 c8                	mov    %ecx,%eax
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	57                   	push   %edi
80105c58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c5d:	56                   	push   %esi
80105c5e:	89 fa                	mov    %edi,%edx
80105c60:	53                   	push   %ebx
80105c61:	83 ec 1c             	sub    $0x1c,%esp
80105c64:	ee                   	out    %al,(%dx)
80105c65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c6f:	89 f2                	mov    %esi,%edx
80105c71:	ee                   	out    %al,(%dx)
80105c72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7c:	ee                   	out    %al,(%dx)
80105c7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c82:	89 c8                	mov    %ecx,%eax
80105c84:	89 da                	mov    %ebx,%edx
80105c86:	ee                   	out    %al,(%dx)
80105c87:	b8 03 00 00 00       	mov    $0x3,%eax
80105c8c:	89 f2                	mov    %esi,%edx
80105c8e:	ee                   	out    %al,(%dx)
80105c8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c94:	89 c8                	mov    %ecx,%eax
80105c96:	ee                   	out    %al,(%dx)
80105c97:	b8 01 00 00 00       	mov    $0x1,%eax
80105c9c:	89 da                	mov    %ebx,%edx
80105c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ca5:	3c ff                	cmp    $0xff,%al
80105ca7:	74 78                	je     80105d21 <uartinit+0xd1>
  uart = 1;
80105ca9:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105cb0:	00 00 00 
80105cb3:	89 fa                	mov    %edi,%edx
80105cb5:	ec                   	in     (%dx),%al
80105cb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105cbf:	bf 88 7d 10 80       	mov    $0x80107d88,%edi
80105cc4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105cc9:	6a 00                	push   $0x0
80105ccb:	6a 04                	push   $0x4
80105ccd:	e8 ce c7 ff ff       	call   801024a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105cd2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ce0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ce5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cea:	85 c0                	test   %eax,%eax
80105cec:	75 14                	jne    80105d02 <uartinit+0xb2>
80105cee:	eb 23                	jmp    80105d13 <uartinit+0xc3>
    microdelay(10);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	6a 0a                	push   $0xa
80105cf5:	e8 56 cc ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	83 eb 01             	sub    $0x1,%ebx
80105d00:	74 07                	je     80105d09 <uartinit+0xb9>
80105d02:	89 f2                	mov    %esi,%edx
80105d04:	ec                   	in     (%dx),%al
80105d05:	a8 20                	test   $0x20,%al
80105d07:	74 e7                	je     80105cf0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d09:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d0d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d12:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d17:	83 c7 01             	add    $0x1,%edi
80105d1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d1d:	84 c0                	test   %al,%al
80105d1f:	75 bf                	jne    80105ce0 <uartinit+0x90>
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <uartputc>:
  if(!uart)
80105d30:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d35:	85 c0                	test   %eax,%eax
80105d37:	74 47                	je     80105d80 <uartputc+0x50>
{
80105d39:	55                   	push   %ebp
80105d3a:	89 e5                	mov    %esp,%ebp
80105d3c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d42:	53                   	push   %ebx
80105d43:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d48:	eb 18                	jmp    80105d62 <uartputc+0x32>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	6a 0a                	push   $0xa
80105d55:	e8 f6 cb ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	83 eb 01             	sub    $0x1,%ebx
80105d60:	74 07                	je     80105d69 <uartputc+0x39>
80105d62:	89 f2                	mov    %esi,%edx
80105d64:	ec                   	in     (%dx),%al
80105d65:	a8 20                	test   $0x20,%al
80105d67:	74 e7                	je     80105d50 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d69:	8b 45 08             	mov    0x8(%ebp),%eax
80105d6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d71:	ee                   	out    %al,(%dx)
}
80105d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d75:	5b                   	pop    %ebx
80105d76:	5e                   	pop    %esi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d80:	c3                   	ret    
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop

80105d90 <uartintr>:

void
uartintr(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d96:	68 20 5c 10 80       	push   $0x80105c20
80105d9b:	e8 e0 aa ff ff       	call   80100880 <consoleintr>
}
80105da0:	83 c4 10             	add    $0x10,%esp
80105da3:	c9                   	leave  
80105da4:	c3                   	ret    

80105da5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $0
80105da7:	6a 00                	push   $0x0
  jmp alltraps
80105da9:	e9 0c fb ff ff       	jmp    801058ba <alltraps>

80105dae <vector1>:
.globl vector1
vector1:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $1
80105db0:	6a 01                	push   $0x1
  jmp alltraps
80105db2:	e9 03 fb ff ff       	jmp    801058ba <alltraps>

80105db7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $2
80105db9:	6a 02                	push   $0x2
  jmp alltraps
80105dbb:	e9 fa fa ff ff       	jmp    801058ba <alltraps>

80105dc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $3
80105dc2:	6a 03                	push   $0x3
  jmp alltraps
80105dc4:	e9 f1 fa ff ff       	jmp    801058ba <alltraps>

80105dc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $4
80105dcb:	6a 04                	push   $0x4
  jmp alltraps
80105dcd:	e9 e8 fa ff ff       	jmp    801058ba <alltraps>

80105dd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $5
80105dd4:	6a 05                	push   $0x5
  jmp alltraps
80105dd6:	e9 df fa ff ff       	jmp    801058ba <alltraps>

80105ddb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $6
80105ddd:	6a 06                	push   $0x6
  jmp alltraps
80105ddf:	e9 d6 fa ff ff       	jmp    801058ba <alltraps>

80105de4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $7
80105de6:	6a 07                	push   $0x7
  jmp alltraps
80105de8:	e9 cd fa ff ff       	jmp    801058ba <alltraps>

80105ded <vector8>:
.globl vector8
vector8:
  pushl $8
80105ded:	6a 08                	push   $0x8
  jmp alltraps
80105def:	e9 c6 fa ff ff       	jmp    801058ba <alltraps>

80105df4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $9
80105df6:	6a 09                	push   $0x9
  jmp alltraps
80105df8:	e9 bd fa ff ff       	jmp    801058ba <alltraps>

80105dfd <vector10>:
.globl vector10
vector10:
  pushl $10
80105dfd:	6a 0a                	push   $0xa
  jmp alltraps
80105dff:	e9 b6 fa ff ff       	jmp    801058ba <alltraps>

80105e04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e04:	6a 0b                	push   $0xb
  jmp alltraps
80105e06:	e9 af fa ff ff       	jmp    801058ba <alltraps>

80105e0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e0b:	6a 0c                	push   $0xc
  jmp alltraps
80105e0d:	e9 a8 fa ff ff       	jmp    801058ba <alltraps>

80105e12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e12:	6a 0d                	push   $0xd
  jmp alltraps
80105e14:	e9 a1 fa ff ff       	jmp    801058ba <alltraps>

80105e19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e19:	6a 0e                	push   $0xe
  jmp alltraps
80105e1b:	e9 9a fa ff ff       	jmp    801058ba <alltraps>

80105e20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $15
80105e22:	6a 0f                	push   $0xf
  jmp alltraps
80105e24:	e9 91 fa ff ff       	jmp    801058ba <alltraps>

80105e29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $16
80105e2b:	6a 10                	push   $0x10
  jmp alltraps
80105e2d:	e9 88 fa ff ff       	jmp    801058ba <alltraps>

80105e32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e32:	6a 11                	push   $0x11
  jmp alltraps
80105e34:	e9 81 fa ff ff       	jmp    801058ba <alltraps>

80105e39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $18
80105e3b:	6a 12                	push   $0x12
  jmp alltraps
80105e3d:	e9 78 fa ff ff       	jmp    801058ba <alltraps>

80105e42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $19
80105e44:	6a 13                	push   $0x13
  jmp alltraps
80105e46:	e9 6f fa ff ff       	jmp    801058ba <alltraps>

80105e4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $20
80105e4d:	6a 14                	push   $0x14
  jmp alltraps
80105e4f:	e9 66 fa ff ff       	jmp    801058ba <alltraps>

80105e54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $21
80105e56:	6a 15                	push   $0x15
  jmp alltraps
80105e58:	e9 5d fa ff ff       	jmp    801058ba <alltraps>

80105e5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $22
80105e5f:	6a 16                	push   $0x16
  jmp alltraps
80105e61:	e9 54 fa ff ff       	jmp    801058ba <alltraps>

80105e66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $23
80105e68:	6a 17                	push   $0x17
  jmp alltraps
80105e6a:	e9 4b fa ff ff       	jmp    801058ba <alltraps>

80105e6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $24
80105e71:	6a 18                	push   $0x18
  jmp alltraps
80105e73:	e9 42 fa ff ff       	jmp    801058ba <alltraps>

80105e78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $25
80105e7a:	6a 19                	push   $0x19
  jmp alltraps
80105e7c:	e9 39 fa ff ff       	jmp    801058ba <alltraps>

80105e81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $26
80105e83:	6a 1a                	push   $0x1a
  jmp alltraps
80105e85:	e9 30 fa ff ff       	jmp    801058ba <alltraps>

80105e8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $27
80105e8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e8e:	e9 27 fa ff ff       	jmp    801058ba <alltraps>

80105e93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $28
80105e95:	6a 1c                	push   $0x1c
  jmp alltraps
80105e97:	e9 1e fa ff ff       	jmp    801058ba <alltraps>

80105e9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $29
80105e9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105ea0:	e9 15 fa ff ff       	jmp    801058ba <alltraps>

80105ea5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $30
80105ea7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ea9:	e9 0c fa ff ff       	jmp    801058ba <alltraps>

80105eae <vector31>:
.globl vector31
vector31:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $31
80105eb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105eb2:	e9 03 fa ff ff       	jmp    801058ba <alltraps>

80105eb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $32
80105eb9:	6a 20                	push   $0x20
  jmp alltraps
80105ebb:	e9 fa f9 ff ff       	jmp    801058ba <alltraps>

80105ec0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $33
80105ec2:	6a 21                	push   $0x21
  jmp alltraps
80105ec4:	e9 f1 f9 ff ff       	jmp    801058ba <alltraps>

80105ec9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $34
80105ecb:	6a 22                	push   $0x22
  jmp alltraps
80105ecd:	e9 e8 f9 ff ff       	jmp    801058ba <alltraps>

80105ed2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $35
80105ed4:	6a 23                	push   $0x23
  jmp alltraps
80105ed6:	e9 df f9 ff ff       	jmp    801058ba <alltraps>

80105edb <vector36>:
.globl vector36
vector36:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $36
80105edd:	6a 24                	push   $0x24
  jmp alltraps
80105edf:	e9 d6 f9 ff ff       	jmp    801058ba <alltraps>

80105ee4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $37
80105ee6:	6a 25                	push   $0x25
  jmp alltraps
80105ee8:	e9 cd f9 ff ff       	jmp    801058ba <alltraps>

80105eed <vector38>:
.globl vector38
vector38:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $38
80105eef:	6a 26                	push   $0x26
  jmp alltraps
80105ef1:	e9 c4 f9 ff ff       	jmp    801058ba <alltraps>

80105ef6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $39
80105ef8:	6a 27                	push   $0x27
  jmp alltraps
80105efa:	e9 bb f9 ff ff       	jmp    801058ba <alltraps>

80105eff <vector40>:
.globl vector40
vector40:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $40
80105f01:	6a 28                	push   $0x28
  jmp alltraps
80105f03:	e9 b2 f9 ff ff       	jmp    801058ba <alltraps>

80105f08 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $41
80105f0a:	6a 29                	push   $0x29
  jmp alltraps
80105f0c:	e9 a9 f9 ff ff       	jmp    801058ba <alltraps>

80105f11 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $42
80105f13:	6a 2a                	push   $0x2a
  jmp alltraps
80105f15:	e9 a0 f9 ff ff       	jmp    801058ba <alltraps>

80105f1a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $43
80105f1c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f1e:	e9 97 f9 ff ff       	jmp    801058ba <alltraps>

80105f23 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $44
80105f25:	6a 2c                	push   $0x2c
  jmp alltraps
80105f27:	e9 8e f9 ff ff       	jmp    801058ba <alltraps>

80105f2c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $45
80105f2e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f30:	e9 85 f9 ff ff       	jmp    801058ba <alltraps>

80105f35 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $46
80105f37:	6a 2e                	push   $0x2e
  jmp alltraps
80105f39:	e9 7c f9 ff ff       	jmp    801058ba <alltraps>

80105f3e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $47
80105f40:	6a 2f                	push   $0x2f
  jmp alltraps
80105f42:	e9 73 f9 ff ff       	jmp    801058ba <alltraps>

80105f47 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $48
80105f49:	6a 30                	push   $0x30
  jmp alltraps
80105f4b:	e9 6a f9 ff ff       	jmp    801058ba <alltraps>

80105f50 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $49
80105f52:	6a 31                	push   $0x31
  jmp alltraps
80105f54:	e9 61 f9 ff ff       	jmp    801058ba <alltraps>

80105f59 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $50
80105f5b:	6a 32                	push   $0x32
  jmp alltraps
80105f5d:	e9 58 f9 ff ff       	jmp    801058ba <alltraps>

80105f62 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $51
80105f64:	6a 33                	push   $0x33
  jmp alltraps
80105f66:	e9 4f f9 ff ff       	jmp    801058ba <alltraps>

80105f6b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $52
80105f6d:	6a 34                	push   $0x34
  jmp alltraps
80105f6f:	e9 46 f9 ff ff       	jmp    801058ba <alltraps>

80105f74 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $53
80105f76:	6a 35                	push   $0x35
  jmp alltraps
80105f78:	e9 3d f9 ff ff       	jmp    801058ba <alltraps>

80105f7d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $54
80105f7f:	6a 36                	push   $0x36
  jmp alltraps
80105f81:	e9 34 f9 ff ff       	jmp    801058ba <alltraps>

80105f86 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $55
80105f88:	6a 37                	push   $0x37
  jmp alltraps
80105f8a:	e9 2b f9 ff ff       	jmp    801058ba <alltraps>

80105f8f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $56
80105f91:	6a 38                	push   $0x38
  jmp alltraps
80105f93:	e9 22 f9 ff ff       	jmp    801058ba <alltraps>

80105f98 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $57
80105f9a:	6a 39                	push   $0x39
  jmp alltraps
80105f9c:	e9 19 f9 ff ff       	jmp    801058ba <alltraps>

80105fa1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $58
80105fa3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fa5:	e9 10 f9 ff ff       	jmp    801058ba <alltraps>

80105faa <vector59>:
.globl vector59
vector59:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $59
80105fac:	6a 3b                	push   $0x3b
  jmp alltraps
80105fae:	e9 07 f9 ff ff       	jmp    801058ba <alltraps>

80105fb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $60
80105fb5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fb7:	e9 fe f8 ff ff       	jmp    801058ba <alltraps>

80105fbc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $61
80105fbe:	6a 3d                	push   $0x3d
  jmp alltraps
80105fc0:	e9 f5 f8 ff ff       	jmp    801058ba <alltraps>

80105fc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $62
80105fc7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fc9:	e9 ec f8 ff ff       	jmp    801058ba <alltraps>

80105fce <vector63>:
.globl vector63
vector63:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $63
80105fd0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fd2:	e9 e3 f8 ff ff       	jmp    801058ba <alltraps>

80105fd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $64
80105fd9:	6a 40                	push   $0x40
  jmp alltraps
80105fdb:	e9 da f8 ff ff       	jmp    801058ba <alltraps>

80105fe0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $65
80105fe2:	6a 41                	push   $0x41
  jmp alltraps
80105fe4:	e9 d1 f8 ff ff       	jmp    801058ba <alltraps>

80105fe9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $66
80105feb:	6a 42                	push   $0x42
  jmp alltraps
80105fed:	e9 c8 f8 ff ff       	jmp    801058ba <alltraps>

80105ff2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $67
80105ff4:	6a 43                	push   $0x43
  jmp alltraps
80105ff6:	e9 bf f8 ff ff       	jmp    801058ba <alltraps>

80105ffb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $68
80105ffd:	6a 44                	push   $0x44
  jmp alltraps
80105fff:	e9 b6 f8 ff ff       	jmp    801058ba <alltraps>

80106004 <vector69>:
.globl vector69
vector69:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $69
80106006:	6a 45                	push   $0x45
  jmp alltraps
80106008:	e9 ad f8 ff ff       	jmp    801058ba <alltraps>

8010600d <vector70>:
.globl vector70
vector70:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $70
8010600f:	6a 46                	push   $0x46
  jmp alltraps
80106011:	e9 a4 f8 ff ff       	jmp    801058ba <alltraps>

80106016 <vector71>:
.globl vector71
vector71:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $71
80106018:	6a 47                	push   $0x47
  jmp alltraps
8010601a:	e9 9b f8 ff ff       	jmp    801058ba <alltraps>

8010601f <vector72>:
.globl vector72
vector72:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $72
80106021:	6a 48                	push   $0x48
  jmp alltraps
80106023:	e9 92 f8 ff ff       	jmp    801058ba <alltraps>

80106028 <vector73>:
.globl vector73
vector73:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $73
8010602a:	6a 49                	push   $0x49
  jmp alltraps
8010602c:	e9 89 f8 ff ff       	jmp    801058ba <alltraps>

80106031 <vector74>:
.globl vector74
vector74:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $74
80106033:	6a 4a                	push   $0x4a
  jmp alltraps
80106035:	e9 80 f8 ff ff       	jmp    801058ba <alltraps>

8010603a <vector75>:
.globl vector75
vector75:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $75
8010603c:	6a 4b                	push   $0x4b
  jmp alltraps
8010603e:	e9 77 f8 ff ff       	jmp    801058ba <alltraps>

80106043 <vector76>:
.globl vector76
vector76:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $76
80106045:	6a 4c                	push   $0x4c
  jmp alltraps
80106047:	e9 6e f8 ff ff       	jmp    801058ba <alltraps>

8010604c <vector77>:
.globl vector77
vector77:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $77
8010604e:	6a 4d                	push   $0x4d
  jmp alltraps
80106050:	e9 65 f8 ff ff       	jmp    801058ba <alltraps>

80106055 <vector78>:
.globl vector78
vector78:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $78
80106057:	6a 4e                	push   $0x4e
  jmp alltraps
80106059:	e9 5c f8 ff ff       	jmp    801058ba <alltraps>

8010605e <vector79>:
.globl vector79
vector79:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $79
80106060:	6a 4f                	push   $0x4f
  jmp alltraps
80106062:	e9 53 f8 ff ff       	jmp    801058ba <alltraps>

80106067 <vector80>:
.globl vector80
vector80:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $80
80106069:	6a 50                	push   $0x50
  jmp alltraps
8010606b:	e9 4a f8 ff ff       	jmp    801058ba <alltraps>

80106070 <vector81>:
.globl vector81
vector81:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $81
80106072:	6a 51                	push   $0x51
  jmp alltraps
80106074:	e9 41 f8 ff ff       	jmp    801058ba <alltraps>

80106079 <vector82>:
.globl vector82
vector82:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $82
8010607b:	6a 52                	push   $0x52
  jmp alltraps
8010607d:	e9 38 f8 ff ff       	jmp    801058ba <alltraps>

80106082 <vector83>:
.globl vector83
vector83:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $83
80106084:	6a 53                	push   $0x53
  jmp alltraps
80106086:	e9 2f f8 ff ff       	jmp    801058ba <alltraps>

8010608b <vector84>:
.globl vector84
vector84:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $84
8010608d:	6a 54                	push   $0x54
  jmp alltraps
8010608f:	e9 26 f8 ff ff       	jmp    801058ba <alltraps>

80106094 <vector85>:
.globl vector85
vector85:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $85
80106096:	6a 55                	push   $0x55
  jmp alltraps
80106098:	e9 1d f8 ff ff       	jmp    801058ba <alltraps>

8010609d <vector86>:
.globl vector86
vector86:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $86
8010609f:	6a 56                	push   $0x56
  jmp alltraps
801060a1:	e9 14 f8 ff ff       	jmp    801058ba <alltraps>

801060a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $87
801060a8:	6a 57                	push   $0x57
  jmp alltraps
801060aa:	e9 0b f8 ff ff       	jmp    801058ba <alltraps>

801060af <vector88>:
.globl vector88
vector88:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $88
801060b1:	6a 58                	push   $0x58
  jmp alltraps
801060b3:	e9 02 f8 ff ff       	jmp    801058ba <alltraps>

801060b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $89
801060ba:	6a 59                	push   $0x59
  jmp alltraps
801060bc:	e9 f9 f7 ff ff       	jmp    801058ba <alltraps>

801060c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $90
801060c3:	6a 5a                	push   $0x5a
  jmp alltraps
801060c5:	e9 f0 f7 ff ff       	jmp    801058ba <alltraps>

801060ca <vector91>:
.globl vector91
vector91:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $91
801060cc:	6a 5b                	push   $0x5b
  jmp alltraps
801060ce:	e9 e7 f7 ff ff       	jmp    801058ba <alltraps>

801060d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $92
801060d5:	6a 5c                	push   $0x5c
  jmp alltraps
801060d7:	e9 de f7 ff ff       	jmp    801058ba <alltraps>

801060dc <vector93>:
.globl vector93
vector93:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $93
801060de:	6a 5d                	push   $0x5d
  jmp alltraps
801060e0:	e9 d5 f7 ff ff       	jmp    801058ba <alltraps>

801060e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $94
801060e7:	6a 5e                	push   $0x5e
  jmp alltraps
801060e9:	e9 cc f7 ff ff       	jmp    801058ba <alltraps>

801060ee <vector95>:
.globl vector95
vector95:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $95
801060f0:	6a 5f                	push   $0x5f
  jmp alltraps
801060f2:	e9 c3 f7 ff ff       	jmp    801058ba <alltraps>

801060f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $96
801060f9:	6a 60                	push   $0x60
  jmp alltraps
801060fb:	e9 ba f7 ff ff       	jmp    801058ba <alltraps>

80106100 <vector97>:
.globl vector97
vector97:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $97
80106102:	6a 61                	push   $0x61
  jmp alltraps
80106104:	e9 b1 f7 ff ff       	jmp    801058ba <alltraps>

80106109 <vector98>:
.globl vector98
vector98:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $98
8010610b:	6a 62                	push   $0x62
  jmp alltraps
8010610d:	e9 a8 f7 ff ff       	jmp    801058ba <alltraps>

80106112 <vector99>:
.globl vector99
vector99:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $99
80106114:	6a 63                	push   $0x63
  jmp alltraps
80106116:	e9 9f f7 ff ff       	jmp    801058ba <alltraps>

8010611b <vector100>:
.globl vector100
vector100:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $100
8010611d:	6a 64                	push   $0x64
  jmp alltraps
8010611f:	e9 96 f7 ff ff       	jmp    801058ba <alltraps>

80106124 <vector101>:
.globl vector101
vector101:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $101
80106126:	6a 65                	push   $0x65
  jmp alltraps
80106128:	e9 8d f7 ff ff       	jmp    801058ba <alltraps>

8010612d <vector102>:
.globl vector102
vector102:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $102
8010612f:	6a 66                	push   $0x66
  jmp alltraps
80106131:	e9 84 f7 ff ff       	jmp    801058ba <alltraps>

80106136 <vector103>:
.globl vector103
vector103:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $103
80106138:	6a 67                	push   $0x67
  jmp alltraps
8010613a:	e9 7b f7 ff ff       	jmp    801058ba <alltraps>

8010613f <vector104>:
.globl vector104
vector104:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $104
80106141:	6a 68                	push   $0x68
  jmp alltraps
80106143:	e9 72 f7 ff ff       	jmp    801058ba <alltraps>

80106148 <vector105>:
.globl vector105
vector105:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $105
8010614a:	6a 69                	push   $0x69
  jmp alltraps
8010614c:	e9 69 f7 ff ff       	jmp    801058ba <alltraps>

80106151 <vector106>:
.globl vector106
vector106:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $106
80106153:	6a 6a                	push   $0x6a
  jmp alltraps
80106155:	e9 60 f7 ff ff       	jmp    801058ba <alltraps>

8010615a <vector107>:
.globl vector107
vector107:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $107
8010615c:	6a 6b                	push   $0x6b
  jmp alltraps
8010615e:	e9 57 f7 ff ff       	jmp    801058ba <alltraps>

80106163 <vector108>:
.globl vector108
vector108:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $108
80106165:	6a 6c                	push   $0x6c
  jmp alltraps
80106167:	e9 4e f7 ff ff       	jmp    801058ba <alltraps>

8010616c <vector109>:
.globl vector109
vector109:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $109
8010616e:	6a 6d                	push   $0x6d
  jmp alltraps
80106170:	e9 45 f7 ff ff       	jmp    801058ba <alltraps>

80106175 <vector110>:
.globl vector110
vector110:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $110
80106177:	6a 6e                	push   $0x6e
  jmp alltraps
80106179:	e9 3c f7 ff ff       	jmp    801058ba <alltraps>

8010617e <vector111>:
.globl vector111
vector111:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $111
80106180:	6a 6f                	push   $0x6f
  jmp alltraps
80106182:	e9 33 f7 ff ff       	jmp    801058ba <alltraps>

80106187 <vector112>:
.globl vector112
vector112:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $112
80106189:	6a 70                	push   $0x70
  jmp alltraps
8010618b:	e9 2a f7 ff ff       	jmp    801058ba <alltraps>

80106190 <vector113>:
.globl vector113
vector113:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $113
80106192:	6a 71                	push   $0x71
  jmp alltraps
80106194:	e9 21 f7 ff ff       	jmp    801058ba <alltraps>

80106199 <vector114>:
.globl vector114
vector114:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $114
8010619b:	6a 72                	push   $0x72
  jmp alltraps
8010619d:	e9 18 f7 ff ff       	jmp    801058ba <alltraps>

801061a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $115
801061a4:	6a 73                	push   $0x73
  jmp alltraps
801061a6:	e9 0f f7 ff ff       	jmp    801058ba <alltraps>

801061ab <vector116>:
.globl vector116
vector116:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $116
801061ad:	6a 74                	push   $0x74
  jmp alltraps
801061af:	e9 06 f7 ff ff       	jmp    801058ba <alltraps>

801061b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $117
801061b6:	6a 75                	push   $0x75
  jmp alltraps
801061b8:	e9 fd f6 ff ff       	jmp    801058ba <alltraps>

801061bd <vector118>:
.globl vector118
vector118:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $118
801061bf:	6a 76                	push   $0x76
  jmp alltraps
801061c1:	e9 f4 f6 ff ff       	jmp    801058ba <alltraps>

801061c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $119
801061c8:	6a 77                	push   $0x77
  jmp alltraps
801061ca:	e9 eb f6 ff ff       	jmp    801058ba <alltraps>

801061cf <vector120>:
.globl vector120
vector120:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $120
801061d1:	6a 78                	push   $0x78
  jmp alltraps
801061d3:	e9 e2 f6 ff ff       	jmp    801058ba <alltraps>

801061d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $121
801061da:	6a 79                	push   $0x79
  jmp alltraps
801061dc:	e9 d9 f6 ff ff       	jmp    801058ba <alltraps>

801061e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $122
801061e3:	6a 7a                	push   $0x7a
  jmp alltraps
801061e5:	e9 d0 f6 ff ff       	jmp    801058ba <alltraps>

801061ea <vector123>:
.globl vector123
vector123:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $123
801061ec:	6a 7b                	push   $0x7b
  jmp alltraps
801061ee:	e9 c7 f6 ff ff       	jmp    801058ba <alltraps>

801061f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $124
801061f5:	6a 7c                	push   $0x7c
  jmp alltraps
801061f7:	e9 be f6 ff ff       	jmp    801058ba <alltraps>

801061fc <vector125>:
.globl vector125
vector125:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $125
801061fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106200:	e9 b5 f6 ff ff       	jmp    801058ba <alltraps>

80106205 <vector126>:
.globl vector126
vector126:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $126
80106207:	6a 7e                	push   $0x7e
  jmp alltraps
80106209:	e9 ac f6 ff ff       	jmp    801058ba <alltraps>

8010620e <vector127>:
.globl vector127
vector127:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $127
80106210:	6a 7f                	push   $0x7f
  jmp alltraps
80106212:	e9 a3 f6 ff ff       	jmp    801058ba <alltraps>

80106217 <vector128>:
.globl vector128
vector128:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $128
80106219:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010621e:	e9 97 f6 ff ff       	jmp    801058ba <alltraps>

80106223 <vector129>:
.globl vector129
vector129:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $129
80106225:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010622a:	e9 8b f6 ff ff       	jmp    801058ba <alltraps>

8010622f <vector130>:
.globl vector130
vector130:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $130
80106231:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106236:	e9 7f f6 ff ff       	jmp    801058ba <alltraps>

8010623b <vector131>:
.globl vector131
vector131:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $131
8010623d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106242:	e9 73 f6 ff ff       	jmp    801058ba <alltraps>

80106247 <vector132>:
.globl vector132
vector132:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $132
80106249:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010624e:	e9 67 f6 ff ff       	jmp    801058ba <alltraps>

80106253 <vector133>:
.globl vector133
vector133:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $133
80106255:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010625a:	e9 5b f6 ff ff       	jmp    801058ba <alltraps>

8010625f <vector134>:
.globl vector134
vector134:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $134
80106261:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106266:	e9 4f f6 ff ff       	jmp    801058ba <alltraps>

8010626b <vector135>:
.globl vector135
vector135:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $135
8010626d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106272:	e9 43 f6 ff ff       	jmp    801058ba <alltraps>

80106277 <vector136>:
.globl vector136
vector136:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $136
80106279:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010627e:	e9 37 f6 ff ff       	jmp    801058ba <alltraps>

80106283 <vector137>:
.globl vector137
vector137:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $137
80106285:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010628a:	e9 2b f6 ff ff       	jmp    801058ba <alltraps>

8010628f <vector138>:
.globl vector138
vector138:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $138
80106291:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106296:	e9 1f f6 ff ff       	jmp    801058ba <alltraps>

8010629b <vector139>:
.globl vector139
vector139:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $139
8010629d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062a2:	e9 13 f6 ff ff       	jmp    801058ba <alltraps>

801062a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $140
801062a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ae:	e9 07 f6 ff ff       	jmp    801058ba <alltraps>

801062b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $141
801062b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ba:	e9 fb f5 ff ff       	jmp    801058ba <alltraps>

801062bf <vector142>:
.globl vector142
vector142:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $142
801062c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062c6:	e9 ef f5 ff ff       	jmp    801058ba <alltraps>

801062cb <vector143>:
.globl vector143
vector143:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $143
801062cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062d2:	e9 e3 f5 ff ff       	jmp    801058ba <alltraps>

801062d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $144
801062d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062de:	e9 d7 f5 ff ff       	jmp    801058ba <alltraps>

801062e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $145
801062e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ea:	e9 cb f5 ff ff       	jmp    801058ba <alltraps>

801062ef <vector146>:
.globl vector146
vector146:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $146
801062f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062f6:	e9 bf f5 ff ff       	jmp    801058ba <alltraps>

801062fb <vector147>:
.globl vector147
vector147:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $147
801062fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106302:	e9 b3 f5 ff ff       	jmp    801058ba <alltraps>

80106307 <vector148>:
.globl vector148
vector148:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $148
80106309:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010630e:	e9 a7 f5 ff ff       	jmp    801058ba <alltraps>

80106313 <vector149>:
.globl vector149
vector149:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $149
80106315:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010631a:	e9 9b f5 ff ff       	jmp    801058ba <alltraps>

8010631f <vector150>:
.globl vector150
vector150:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $150
80106321:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106326:	e9 8f f5 ff ff       	jmp    801058ba <alltraps>

8010632b <vector151>:
.globl vector151
vector151:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $151
8010632d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106332:	e9 83 f5 ff ff       	jmp    801058ba <alltraps>

80106337 <vector152>:
.globl vector152
vector152:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $152
80106339:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010633e:	e9 77 f5 ff ff       	jmp    801058ba <alltraps>

80106343 <vector153>:
.globl vector153
vector153:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $153
80106345:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010634a:	e9 6b f5 ff ff       	jmp    801058ba <alltraps>

8010634f <vector154>:
.globl vector154
vector154:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $154
80106351:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106356:	e9 5f f5 ff ff       	jmp    801058ba <alltraps>

8010635b <vector155>:
.globl vector155
vector155:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $155
8010635d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106362:	e9 53 f5 ff ff       	jmp    801058ba <alltraps>

80106367 <vector156>:
.globl vector156
vector156:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $156
80106369:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010636e:	e9 47 f5 ff ff       	jmp    801058ba <alltraps>

80106373 <vector157>:
.globl vector157
vector157:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $157
80106375:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010637a:	e9 3b f5 ff ff       	jmp    801058ba <alltraps>

8010637f <vector158>:
.globl vector158
vector158:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $158
80106381:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106386:	e9 2f f5 ff ff       	jmp    801058ba <alltraps>

8010638b <vector159>:
.globl vector159
vector159:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $159
8010638d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106392:	e9 23 f5 ff ff       	jmp    801058ba <alltraps>

80106397 <vector160>:
.globl vector160
vector160:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $160
80106399:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010639e:	e9 17 f5 ff ff       	jmp    801058ba <alltraps>

801063a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $161
801063a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063aa:	e9 0b f5 ff ff       	jmp    801058ba <alltraps>

801063af <vector162>:
.globl vector162
vector162:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $162
801063b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063b6:	e9 ff f4 ff ff       	jmp    801058ba <alltraps>

801063bb <vector163>:
.globl vector163
vector163:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $163
801063bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063c2:	e9 f3 f4 ff ff       	jmp    801058ba <alltraps>

801063c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $164
801063c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ce:	e9 e7 f4 ff ff       	jmp    801058ba <alltraps>

801063d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $165
801063d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063da:	e9 db f4 ff ff       	jmp    801058ba <alltraps>

801063df <vector166>:
.globl vector166
vector166:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $166
801063e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063e6:	e9 cf f4 ff ff       	jmp    801058ba <alltraps>

801063eb <vector167>:
.globl vector167
vector167:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $167
801063ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063f2:	e9 c3 f4 ff ff       	jmp    801058ba <alltraps>

801063f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $168
801063f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063fe:	e9 b7 f4 ff ff       	jmp    801058ba <alltraps>

80106403 <vector169>:
.globl vector169
vector169:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $169
80106405:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010640a:	e9 ab f4 ff ff       	jmp    801058ba <alltraps>

8010640f <vector170>:
.globl vector170
vector170:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $170
80106411:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106416:	e9 9f f4 ff ff       	jmp    801058ba <alltraps>

8010641b <vector171>:
.globl vector171
vector171:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $171
8010641d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106422:	e9 93 f4 ff ff       	jmp    801058ba <alltraps>

80106427 <vector172>:
.globl vector172
vector172:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $172
80106429:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010642e:	e9 87 f4 ff ff       	jmp    801058ba <alltraps>

80106433 <vector173>:
.globl vector173
vector173:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $173
80106435:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010643a:	e9 7b f4 ff ff       	jmp    801058ba <alltraps>

8010643f <vector174>:
.globl vector174
vector174:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $174
80106441:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106446:	e9 6f f4 ff ff       	jmp    801058ba <alltraps>

8010644b <vector175>:
.globl vector175
vector175:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $175
8010644d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106452:	e9 63 f4 ff ff       	jmp    801058ba <alltraps>

80106457 <vector176>:
.globl vector176
vector176:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $176
80106459:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010645e:	e9 57 f4 ff ff       	jmp    801058ba <alltraps>

80106463 <vector177>:
.globl vector177
vector177:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $177
80106465:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010646a:	e9 4b f4 ff ff       	jmp    801058ba <alltraps>

8010646f <vector178>:
.globl vector178
vector178:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $178
80106471:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106476:	e9 3f f4 ff ff       	jmp    801058ba <alltraps>

8010647b <vector179>:
.globl vector179
vector179:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $179
8010647d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106482:	e9 33 f4 ff ff       	jmp    801058ba <alltraps>

80106487 <vector180>:
.globl vector180
vector180:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $180
80106489:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010648e:	e9 27 f4 ff ff       	jmp    801058ba <alltraps>

80106493 <vector181>:
.globl vector181
vector181:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $181
80106495:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010649a:	e9 1b f4 ff ff       	jmp    801058ba <alltraps>

8010649f <vector182>:
.globl vector182
vector182:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $182
801064a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064a6:	e9 0f f4 ff ff       	jmp    801058ba <alltraps>

801064ab <vector183>:
.globl vector183
vector183:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $183
801064ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064b2:	e9 03 f4 ff ff       	jmp    801058ba <alltraps>

801064b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $184
801064b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064be:	e9 f7 f3 ff ff       	jmp    801058ba <alltraps>

801064c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $185
801064c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064ca:	e9 eb f3 ff ff       	jmp    801058ba <alltraps>

801064cf <vector186>:
.globl vector186
vector186:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $186
801064d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064d6:	e9 df f3 ff ff       	jmp    801058ba <alltraps>

801064db <vector187>:
.globl vector187
vector187:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $187
801064dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064e2:	e9 d3 f3 ff ff       	jmp    801058ba <alltraps>

801064e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $188
801064e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064ee:	e9 c7 f3 ff ff       	jmp    801058ba <alltraps>

801064f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $189
801064f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064fa:	e9 bb f3 ff ff       	jmp    801058ba <alltraps>

801064ff <vector190>:
.globl vector190
vector190:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $190
80106501:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106506:	e9 af f3 ff ff       	jmp    801058ba <alltraps>

8010650b <vector191>:
.globl vector191
vector191:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $191
8010650d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106512:	e9 a3 f3 ff ff       	jmp    801058ba <alltraps>

80106517 <vector192>:
.globl vector192
vector192:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $192
80106519:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010651e:	e9 97 f3 ff ff       	jmp    801058ba <alltraps>

80106523 <vector193>:
.globl vector193
vector193:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $193
80106525:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010652a:	e9 8b f3 ff ff       	jmp    801058ba <alltraps>

8010652f <vector194>:
.globl vector194
vector194:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $194
80106531:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106536:	e9 7f f3 ff ff       	jmp    801058ba <alltraps>

8010653b <vector195>:
.globl vector195
vector195:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $195
8010653d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106542:	e9 73 f3 ff ff       	jmp    801058ba <alltraps>

80106547 <vector196>:
.globl vector196
vector196:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $196
80106549:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010654e:	e9 67 f3 ff ff       	jmp    801058ba <alltraps>

80106553 <vector197>:
.globl vector197
vector197:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $197
80106555:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010655a:	e9 5b f3 ff ff       	jmp    801058ba <alltraps>

8010655f <vector198>:
.globl vector198
vector198:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $198
80106561:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106566:	e9 4f f3 ff ff       	jmp    801058ba <alltraps>

8010656b <vector199>:
.globl vector199
vector199:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $199
8010656d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106572:	e9 43 f3 ff ff       	jmp    801058ba <alltraps>

80106577 <vector200>:
.globl vector200
vector200:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $200
80106579:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010657e:	e9 37 f3 ff ff       	jmp    801058ba <alltraps>

80106583 <vector201>:
.globl vector201
vector201:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $201
80106585:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010658a:	e9 2b f3 ff ff       	jmp    801058ba <alltraps>

8010658f <vector202>:
.globl vector202
vector202:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $202
80106591:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106596:	e9 1f f3 ff ff       	jmp    801058ba <alltraps>

8010659b <vector203>:
.globl vector203
vector203:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $203
8010659d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065a2:	e9 13 f3 ff ff       	jmp    801058ba <alltraps>

801065a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $204
801065a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ae:	e9 07 f3 ff ff       	jmp    801058ba <alltraps>

801065b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $205
801065b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ba:	e9 fb f2 ff ff       	jmp    801058ba <alltraps>

801065bf <vector206>:
.globl vector206
vector206:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $206
801065c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065c6:	e9 ef f2 ff ff       	jmp    801058ba <alltraps>

801065cb <vector207>:
.globl vector207
vector207:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $207
801065cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065d2:	e9 e3 f2 ff ff       	jmp    801058ba <alltraps>

801065d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $208
801065d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065de:	e9 d7 f2 ff ff       	jmp    801058ba <alltraps>

801065e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $209
801065e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ea:	e9 cb f2 ff ff       	jmp    801058ba <alltraps>

801065ef <vector210>:
.globl vector210
vector210:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $210
801065f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065f6:	e9 bf f2 ff ff       	jmp    801058ba <alltraps>

801065fb <vector211>:
.globl vector211
vector211:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $211
801065fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106602:	e9 b3 f2 ff ff       	jmp    801058ba <alltraps>

80106607 <vector212>:
.globl vector212
vector212:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $212
80106609:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010660e:	e9 a7 f2 ff ff       	jmp    801058ba <alltraps>

80106613 <vector213>:
.globl vector213
vector213:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $213
80106615:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010661a:	e9 9b f2 ff ff       	jmp    801058ba <alltraps>

8010661f <vector214>:
.globl vector214
vector214:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $214
80106621:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106626:	e9 8f f2 ff ff       	jmp    801058ba <alltraps>

8010662b <vector215>:
.globl vector215
vector215:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $215
8010662d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106632:	e9 83 f2 ff ff       	jmp    801058ba <alltraps>

80106637 <vector216>:
.globl vector216
vector216:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $216
80106639:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010663e:	e9 77 f2 ff ff       	jmp    801058ba <alltraps>

80106643 <vector217>:
.globl vector217
vector217:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $217
80106645:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010664a:	e9 6b f2 ff ff       	jmp    801058ba <alltraps>

8010664f <vector218>:
.globl vector218
vector218:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $218
80106651:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106656:	e9 5f f2 ff ff       	jmp    801058ba <alltraps>

8010665b <vector219>:
.globl vector219
vector219:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $219
8010665d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106662:	e9 53 f2 ff ff       	jmp    801058ba <alltraps>

80106667 <vector220>:
.globl vector220
vector220:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $220
80106669:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010666e:	e9 47 f2 ff ff       	jmp    801058ba <alltraps>

80106673 <vector221>:
.globl vector221
vector221:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $221
80106675:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010667a:	e9 3b f2 ff ff       	jmp    801058ba <alltraps>

8010667f <vector222>:
.globl vector222
vector222:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $222
80106681:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106686:	e9 2f f2 ff ff       	jmp    801058ba <alltraps>

8010668b <vector223>:
.globl vector223
vector223:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $223
8010668d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106692:	e9 23 f2 ff ff       	jmp    801058ba <alltraps>

80106697 <vector224>:
.globl vector224
vector224:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $224
80106699:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010669e:	e9 17 f2 ff ff       	jmp    801058ba <alltraps>

801066a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $225
801066a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066aa:	e9 0b f2 ff ff       	jmp    801058ba <alltraps>

801066af <vector226>:
.globl vector226
vector226:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $226
801066b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066b6:	e9 ff f1 ff ff       	jmp    801058ba <alltraps>

801066bb <vector227>:
.globl vector227
vector227:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $227
801066bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066c2:	e9 f3 f1 ff ff       	jmp    801058ba <alltraps>

801066c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $228
801066c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ce:	e9 e7 f1 ff ff       	jmp    801058ba <alltraps>

801066d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $229
801066d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066da:	e9 db f1 ff ff       	jmp    801058ba <alltraps>

801066df <vector230>:
.globl vector230
vector230:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $230
801066e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066e6:	e9 cf f1 ff ff       	jmp    801058ba <alltraps>

801066eb <vector231>:
.globl vector231
vector231:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $231
801066ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066f2:	e9 c3 f1 ff ff       	jmp    801058ba <alltraps>

801066f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $232
801066f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066fe:	e9 b7 f1 ff ff       	jmp    801058ba <alltraps>

80106703 <vector233>:
.globl vector233
vector233:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $233
80106705:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010670a:	e9 ab f1 ff ff       	jmp    801058ba <alltraps>

8010670f <vector234>:
.globl vector234
vector234:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $234
80106711:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106716:	e9 9f f1 ff ff       	jmp    801058ba <alltraps>

8010671b <vector235>:
.globl vector235
vector235:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $235
8010671d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106722:	e9 93 f1 ff ff       	jmp    801058ba <alltraps>

80106727 <vector236>:
.globl vector236
vector236:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $236
80106729:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010672e:	e9 87 f1 ff ff       	jmp    801058ba <alltraps>

80106733 <vector237>:
.globl vector237
vector237:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $237
80106735:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010673a:	e9 7b f1 ff ff       	jmp    801058ba <alltraps>

8010673f <vector238>:
.globl vector238
vector238:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $238
80106741:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106746:	e9 6f f1 ff ff       	jmp    801058ba <alltraps>

8010674b <vector239>:
.globl vector239
vector239:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $239
8010674d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106752:	e9 63 f1 ff ff       	jmp    801058ba <alltraps>

80106757 <vector240>:
.globl vector240
vector240:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $240
80106759:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010675e:	e9 57 f1 ff ff       	jmp    801058ba <alltraps>

80106763 <vector241>:
.globl vector241
vector241:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $241
80106765:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010676a:	e9 4b f1 ff ff       	jmp    801058ba <alltraps>

8010676f <vector242>:
.globl vector242
vector242:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $242
80106771:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106776:	e9 3f f1 ff ff       	jmp    801058ba <alltraps>

8010677b <vector243>:
.globl vector243
vector243:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $243
8010677d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106782:	e9 33 f1 ff ff       	jmp    801058ba <alltraps>

80106787 <vector244>:
.globl vector244
vector244:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $244
80106789:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010678e:	e9 27 f1 ff ff       	jmp    801058ba <alltraps>

80106793 <vector245>:
.globl vector245
vector245:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $245
80106795:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010679a:	e9 1b f1 ff ff       	jmp    801058ba <alltraps>

8010679f <vector246>:
.globl vector246
vector246:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $246
801067a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067a6:	e9 0f f1 ff ff       	jmp    801058ba <alltraps>

801067ab <vector247>:
.globl vector247
vector247:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $247
801067ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067b2:	e9 03 f1 ff ff       	jmp    801058ba <alltraps>

801067b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $248
801067b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067be:	e9 f7 f0 ff ff       	jmp    801058ba <alltraps>

801067c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $249
801067c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067ca:	e9 eb f0 ff ff       	jmp    801058ba <alltraps>

801067cf <vector250>:
.globl vector250
vector250:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $250
801067d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067d6:	e9 df f0 ff ff       	jmp    801058ba <alltraps>

801067db <vector251>:
.globl vector251
vector251:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $251
801067dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067e2:	e9 d3 f0 ff ff       	jmp    801058ba <alltraps>

801067e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $252
801067e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067ee:	e9 c7 f0 ff ff       	jmp    801058ba <alltraps>

801067f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $253
801067f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067fa:	e9 bb f0 ff ff       	jmp    801058ba <alltraps>

801067ff <vector254>:
.globl vector254
vector254:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $254
80106801:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106806:	e9 af f0 ff ff       	jmp    801058ba <alltraps>

8010680b <vector255>:
.globl vector255
vector255:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $255
8010680d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106812:	e9 a3 f0 ff ff       	jmp    801058ba <alltraps>
80106817:	66 90                	xchg   %ax,%ax
80106819:	66 90                	xchg   %ax,%ax
8010681b:	66 90                	xchg   %ax,%ax
8010681d:	66 90                	xchg   %ax,%ax
8010681f:	90                   	nop

80106820 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106826:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010682c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106832:	83 ec 1c             	sub    $0x1c,%esp
80106835:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106838:	39 d3                	cmp    %edx,%ebx
8010683a:	73 49                	jae    80106885 <deallocuvm.part.0+0x65>
8010683c:	89 c7                	mov    %eax,%edi
8010683e:	eb 0c                	jmp    8010684c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106840:	83 c0 01             	add    $0x1,%eax
80106843:	c1 e0 16             	shl    $0x16,%eax
80106846:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106848:	39 da                	cmp    %ebx,%edx
8010684a:	76 39                	jbe    80106885 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010684c:	89 d8                	mov    %ebx,%eax
8010684e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106851:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106854:	f6 c1 01             	test   $0x1,%cl
80106857:	74 e7                	je     80106840 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106859:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010685b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106861:	c1 ee 0a             	shr    $0xa,%esi
80106864:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010686a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106871:	85 f6                	test   %esi,%esi
80106873:	74 cb                	je     80106840 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106875:	8b 06                	mov    (%esi),%eax
80106877:	a8 01                	test   $0x1,%al
80106879:	75 15                	jne    80106890 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010687b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106881:	39 da                	cmp    %ebx,%edx
80106883:	77 c7                	ja     8010684c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106885:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010688b:	5b                   	pop    %ebx
8010688c:	5e                   	pop    %esi
8010688d:	5f                   	pop    %edi
8010688e:	5d                   	pop    %ebp
8010688f:	c3                   	ret    
      if(pa == 0)
80106890:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106895:	74 25                	je     801068bc <deallocuvm.part.0+0x9c>
      kfree(v);
80106897:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010689a:	05 00 00 00 80       	add    $0x80000000,%eax
8010689f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801068a8:	50                   	push   %eax
801068a9:	e8 32 bc ff ff       	call   801024e0 <kfree>
      *pte = 0;
801068ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801068b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801068b7:	83 c4 10             	add    $0x10,%esp
801068ba:	eb 8c                	jmp    80106848 <deallocuvm.part.0+0x28>
        panic("kfree");
801068bc:	83 ec 0c             	sub    $0xc,%esp
801068bf:	68 46 77 10 80       	push   $0x80107746
801068c4:	e8 b7 9a ff ff       	call   80100380 <panic>
801068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068d0 <seginit>:
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068d6:	e8 95 d0 ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
801068db:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068e0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068e6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068ea:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801068f1:	ff 00 00 
801068f4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801068fb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068fe:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106905:	ff 00 00 
80106908:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
8010690f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106912:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106919:	ff 00 00 
8010691c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106923:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106926:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
8010692d:	ff 00 00 
80106930:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106937:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010693a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
8010693f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106943:	c1 e8 10             	shr    $0x10,%eax
80106946:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010694a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010694d:	0f 01 10             	lgdtl  (%eax)
}
80106950:	c9                   	leave  
80106951:	c3                   	ret    
80106952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106960 <mappages>:
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	57                   	push   %edi
80106964:	56                   	push   %esi
80106965:	53                   	push   %ebx
80106966:	83 ec 1c             	sub    $0x1c,%esp
80106969:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010696c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
8010696f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106971:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106975:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
8010697a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106980:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106983:	8b 45 14             	mov    0x14(%ebp),%eax
80106986:	29 d8                	sub    %ebx,%eax
80106988:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010698b:	eb 3a                	jmp    801069c7 <mappages+0x67>
8010698d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106990:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106992:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106997:	c1 ea 0a             	shr    $0xa,%edx
8010699a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069a7:	85 c0                	test   %eax,%eax
801069a9:	74 75                	je     80106a20 <mappages+0xc0>
    if(*pte & PTE_P)
801069ab:	f6 00 01             	testb  $0x1,(%eax)
801069ae:	0f 85 86 00 00 00    	jne    80106a3a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801069b4:	0b 75 18             	or     0x18(%ebp),%esi
801069b7:	83 ce 01             	or     $0x1,%esi
801069ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801069bc:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801069bf:	74 6f                	je     80106a30 <mappages+0xd0>
    a += PGSIZE;
801069c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801069c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801069ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
801069cd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801069d0:	89 d8                	mov    %ebx,%eax
801069d2:	c1 e8 16             	shr    $0x16,%eax
801069d5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801069d8:	8b 07                	mov    (%edi),%eax
801069da:	a8 01                	test   $0x1,%al
801069dc:	75 b2                	jne    80106990 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069de:	e8 bd bc ff ff       	call   801026a0 <kalloc>
801069e3:	85 c0                	test   %eax,%eax
801069e5:	74 39                	je     80106a20 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801069e7:	83 ec 04             	sub    $0x4,%esp
801069ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069ed:	68 00 10 00 00       	push   $0x1000
801069f2:	6a 00                	push   $0x0
801069f4:	50                   	push   %eax
801069f5:	e8 56 dc ff ff       	call   80104650 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
801069fd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a00:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a06:	83 c8 07             	or     $0x7,%eax
80106a09:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a0b:	89 d8                	mov    %ebx,%eax
80106a0d:	c1 e8 0a             	shr    $0xa,%eax
80106a10:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a15:	01 d0                	add    %edx,%eax
80106a17:	eb 92                	jmp    801069ab <mappages+0x4b>
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a28:	5b                   	pop    %ebx
80106a29:	5e                   	pop    %esi
80106a2a:	5f                   	pop    %edi
80106a2b:	5d                   	pop    %ebp
80106a2c:	c3                   	ret    
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi
80106a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a33:	31 c0                	xor    %eax,%eax
}
80106a35:	5b                   	pop    %ebx
80106a36:	5e                   	pop    %esi
80106a37:	5f                   	pop    %edi
80106a38:	5d                   	pop    %ebp
80106a39:	c3                   	ret    
      panic("remap");
80106a3a:	83 ec 0c             	sub    $0xc,%esp
80106a3d:	68 90 7d 10 80       	push   $0x80107d90
80106a42:	e8 39 99 ff ff       	call   80100380 <panic>
80106a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4e:	66 90                	xchg   %ax,%ax

80106a50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a50:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106a55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a5a:	0f 22 d8             	mov    %eax,%cr3
}
80106a5d:	c3                   	ret    
80106a5e:	66 90                	xchg   %ax,%ax

80106a60 <switchuvm>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 1c             	sub    $0x1c,%esp
80106a69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a6c:	85 f6                	test   %esi,%esi
80106a6e:	0f 84 cb 00 00 00    	je     80106b3f <switchuvm+0xdf>
  if(p->kstack == 0)
80106a74:	8b 46 08             	mov    0x8(%esi),%eax
80106a77:	85 c0                	test   %eax,%eax
80106a79:	0f 84 da 00 00 00    	je     80106b59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a7f:	8b 46 04             	mov    0x4(%esi),%eax
80106a82:	85 c0                	test   %eax,%eax
80106a84:	0f 84 c2 00 00 00    	je     80106b4c <switchuvm+0xec>
  pushcli();
80106a8a:	e8 01 da ff ff       	call   80104490 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a8f:	e8 7c ce ff ff       	call   80103910 <mycpu>
80106a94:	89 c3                	mov    %eax,%ebx
80106a96:	e8 75 ce ff ff       	call   80103910 <mycpu>
80106a9b:	89 c7                	mov    %eax,%edi
80106a9d:	e8 6e ce ff ff       	call   80103910 <mycpu>
80106aa2:	83 c7 08             	add    $0x8,%edi
80106aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aa8:	e8 63 ce ff ff       	call   80103910 <mycpu>
80106aad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ab0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ab5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106abc:	83 c0 08             	add    $0x8,%eax
80106abf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ac6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106acb:	83 c1 08             	add    $0x8,%ecx
80106ace:	c1 e8 18             	shr    $0x18,%eax
80106ad1:	c1 e9 10             	shr    $0x10,%ecx
80106ad4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ada:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ae0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ae5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106aec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106af1:	e8 1a ce ff ff       	call   80103910 <mycpu>
80106af6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106afd:	e8 0e ce ff ff       	call   80103910 <mycpu>
80106b02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b06:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b0f:	e8 fc cd ff ff       	call   80103910 <mycpu>
80106b14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b17:	e8 f4 cd ff ff       	call   80103910 <mycpu>
80106b1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b20:	b8 28 00 00 00       	mov    $0x28,%eax
80106b25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b28:	8b 46 04             	mov    0x4(%esi),%eax
80106b2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b30:	0f 22 d8             	mov    %eax,%cr3
}
80106b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b36:	5b                   	pop    %ebx
80106b37:	5e                   	pop    %esi
80106b38:	5f                   	pop    %edi
80106b39:	5d                   	pop    %ebp
  popcli();
80106b3a:	e9 61 da ff ff       	jmp    801045a0 <popcli>
    panic("switchuvm: no process");
80106b3f:	83 ec 0c             	sub    $0xc,%esp
80106b42:	68 96 7d 10 80       	push   $0x80107d96
80106b47:	e8 34 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	68 c1 7d 10 80       	push   $0x80107dc1
80106b54:	e8 27 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b59:	83 ec 0c             	sub    $0xc,%esp
80106b5c:	68 ac 7d 10 80       	push   $0x80107dac
80106b61:	e8 1a 98 ff ff       	call   80100380 <panic>
80106b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6d:	8d 76 00             	lea    0x0(%esi),%esi

80106b70 <inituvm>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 75 10             	mov    0x10(%ebp),%esi
80106b7c:	8b 55 08             	mov    0x8(%ebp),%edx
80106b7f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106b82:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b88:	77 50                	ja     80106bda <inituvm+0x6a>
80106b8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106b8d:	e8 0e bb ff ff       	call   801026a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b92:	83 ec 04             	sub    $0x4,%esp
80106b95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106b9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b9c:	6a 00                	push   $0x0
80106b9e:	50                   	push   %eax
80106b9f:	e8 ac da ff ff       	call   80104650 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ba4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ba7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bad:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106bb4:	50                   	push   %eax
80106bb5:	68 00 10 00 00       	push   $0x1000
80106bba:	6a 00                	push   $0x0
80106bbc:	52                   	push   %edx
80106bbd:	e8 9e fd ff ff       	call   80106960 <mappages>
  memmove(mem, init, sz);
80106bc2:	89 75 10             	mov    %esi,0x10(%ebp)
80106bc5:	83 c4 20             	add    $0x20,%esp
80106bc8:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106bcb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bd1:	5b                   	pop    %ebx
80106bd2:	5e                   	pop    %esi
80106bd3:	5f                   	pop    %edi
80106bd4:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106bd5:	e9 16 db ff ff       	jmp    801046f0 <memmove>
    panic("inituvm: more than a page");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 d5 7d 10 80       	push   $0x80107dd5
80106be2:	e8 99 97 ff ff       	call   80100380 <panic>
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <loaduvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106bff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c04:	0f 85 bb 00 00 00    	jne    80106cc5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106c0a:	01 f0                	add    %esi,%eax
80106c0c:	89 f3                	mov    %esi,%ebx
80106c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c11:	8b 45 14             	mov    0x14(%ebp),%eax
80106c14:	01 f0                	add    %esi,%eax
80106c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c19:	85 f6                	test   %esi,%esi
80106c1b:	0f 84 87 00 00 00    	je     80106ca8 <loaduvm+0xb8>
80106c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c2e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106c30:	89 c2                	mov    %eax,%edx
80106c32:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c35:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106c38:	f6 c2 01             	test   $0x1,%dl
80106c3b:	75 13                	jne    80106c50 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106c3d:	83 ec 0c             	sub    $0xc,%esp
80106c40:	68 ef 7d 10 80       	push   $0x80107def
80106c45:	e8 36 97 ff ff       	call   80100380 <panic>
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c50:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c53:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106c59:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c5e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c65:	85 c0                	test   %eax,%eax
80106c67:	74 d4                	je     80106c3d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106c69:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c6b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c6e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c78:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106c7e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c81:	29 d9                	sub    %ebx,%ecx
80106c83:	05 00 00 00 80       	add    $0x80000000,%eax
80106c88:	57                   	push   %edi
80106c89:	51                   	push   %ecx
80106c8a:	50                   	push   %eax
80106c8b:	ff 75 10             	push   0x10(%ebp)
80106c8e:	e8 1d ae ff ff       	call   80101ab0 <readi>
80106c93:	83 c4 10             	add    $0x10,%esp
80106c96:	39 f8                	cmp    %edi,%eax
80106c98:	75 1e                	jne    80106cb8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106c9a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ca0:	89 f0                	mov    %esi,%eax
80106ca2:	29 d8                	sub    %ebx,%eax
80106ca4:	39 c6                	cmp    %eax,%esi
80106ca6:	77 80                	ja     80106c28 <loaduvm+0x38>
}
80106ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cab:	31 c0                	xor    %eax,%eax
}
80106cad:	5b                   	pop    %ebx
80106cae:	5e                   	pop    %esi
80106caf:	5f                   	pop    %edi
80106cb0:	5d                   	pop    %ebp
80106cb1:	c3                   	ret    
80106cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc0:	5b                   	pop    %ebx
80106cc1:	5e                   	pop    %esi
80106cc2:	5f                   	pop    %edi
80106cc3:	5d                   	pop    %ebp
80106cc4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106cc5:	83 ec 0c             	sub    $0xc,%esp
80106cc8:	68 90 7e 10 80       	push   $0x80107e90
80106ccd:	e8 ae 96 ff ff       	call   80100380 <panic>
80106cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ce0 <allocuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ce9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106cec:	85 ff                	test   %edi,%edi
80106cee:	0f 88 bc 00 00 00    	js     80106db0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106cf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cf7:	0f 82 a3 00 00 00    	jb     80106da0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d00:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d06:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d0c:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d0f:	0f 86 8e 00 00 00    	jbe    80106da3 <allocuvm+0xc3>
80106d15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d1b:	eb 43                	jmp    80106d60 <allocuvm+0x80>
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106d20:	83 ec 04             	sub    $0x4,%esp
80106d23:	68 00 10 00 00       	push   $0x1000
80106d28:	6a 00                	push   $0x0
80106d2a:	50                   	push   %eax
80106d2b:	e8 20 d9 ff ff       	call   80104650 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d30:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d36:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106d3d:	50                   	push   %eax
80106d3e:	68 00 10 00 00       	push   $0x1000
80106d43:	56                   	push   %esi
80106d44:	57                   	push   %edi
80106d45:	e8 16 fc ff ff       	call   80106960 <mappages>
80106d4a:	83 c4 20             	add    $0x20,%esp
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	78 6f                	js     80106dc0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106d51:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d57:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d5a:	0f 86 a0 00 00 00    	jbe    80106e00 <allocuvm+0x120>
    mem = kalloc();
80106d60:	e8 3b b9 ff ff       	call   801026a0 <kalloc>
80106d65:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d67:	85 c0                	test   %eax,%eax
80106d69:	75 b5                	jne    80106d20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d6b:	83 ec 0c             	sub    $0xc,%esp
80106d6e:	68 0d 7e 10 80       	push   $0x80107e0d
80106d73:	e8 28 99 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d7b:	83 c4 10             	add    $0x10,%esp
80106d7e:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d81:	74 2d                	je     80106db0 <allocuvm+0xd0>
80106d83:	8b 55 10             	mov    0x10(%ebp),%edx
80106d86:	89 c1                	mov    %eax,%ecx
80106d88:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106d8b:	31 ff                	xor    %edi,%edi
80106d8d:	e8 8e fa ff ff       	call   80106820 <deallocuvm.part.0>
}
80106d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d95:	89 f8                	mov    %edi,%eax
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5f                   	pop    %edi
80106d9a:	5d                   	pop    %ebp
80106d9b:	c3                   	ret    
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106da0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da6:	89 f8                	mov    %edi,%eax
80106da8:	5b                   	pop    %ebx
80106da9:	5e                   	pop    %esi
80106daa:	5f                   	pop    %edi
80106dab:	5d                   	pop    %ebp
80106dac:	c3                   	ret    
80106dad:	8d 76 00             	lea    0x0(%esi),%esi
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106db3:	31 ff                	xor    %edi,%edi
}
80106db5:	5b                   	pop    %ebx
80106db6:	89 f8                	mov    %edi,%eax
80106db8:	5e                   	pop    %esi
80106db9:	5f                   	pop    %edi
80106dba:	5d                   	pop    %ebp
80106dbb:	c3                   	ret    
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106dc0:	83 ec 0c             	sub    $0xc,%esp
80106dc3:	68 25 7e 10 80       	push   $0x80107e25
80106dc8:	e8 d3 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd0:	83 c4 10             	add    $0x10,%esp
80106dd3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dd6:	74 0d                	je     80106de5 <allocuvm+0x105>
80106dd8:	89 c1                	mov    %eax,%ecx
80106dda:	8b 55 10             	mov    0x10(%ebp),%edx
80106ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80106de0:	e8 3b fa ff ff       	call   80106820 <deallocuvm.part.0>
      kfree(mem);
80106de5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106de8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106dea:	53                   	push   %ebx
80106deb:	e8 f0 b6 ff ff       	call   801024e0 <kfree>
      return 0;
80106df0:	83 c4 10             	add    $0x10,%esp
}
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	89 f8                	mov    %edi,%eax
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret    
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
80106e00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	89 f8                	mov    %edi,%eax
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret    
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi

80106e10 <deallocuvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e1c:	39 d1                	cmp    %edx,%ecx
80106e1e:	73 10                	jae    80106e30 <deallocuvm+0x20>
}
80106e20:	5d                   	pop    %ebp
80106e21:	e9 fa f9 ff ff       	jmp    80106820 <deallocuvm.part.0>
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi
80106e30:	89 d0                	mov    %edx,%eax
80106e32:	5d                   	pop    %ebp
80106e33:	c3                   	ret    
80106e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop

80106e40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 0c             	sub    $0xc,%esp
80106e49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e4c:	85 f6                	test   %esi,%esi
80106e4e:	74 59                	je     80106ea9 <freevm+0x69>
  if(newsz >= oldsz)
80106e50:	31 c9                	xor    %ecx,%ecx
80106e52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e57:	89 f0                	mov    %esi,%eax
80106e59:	89 f3                	mov    %esi,%ebx
80106e5b:	e8 c0 f9 ff ff       	call   80106820 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e66:	eb 0f                	jmp    80106e77 <freevm+0x37>
80106e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6f:	90                   	nop
80106e70:	83 c3 04             	add    $0x4,%ebx
80106e73:	39 df                	cmp    %ebx,%edi
80106e75:	74 23                	je     80106e9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e77:	8b 03                	mov    (%ebx),%eax
80106e79:	a8 01                	test   $0x1,%al
80106e7b:	74 f3                	je     80106e70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e82:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e8d:	50                   	push   %eax
80106e8e:	e8 4d b6 ff ff       	call   801024e0 <kfree>
80106e93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e96:	39 df                	cmp    %ebx,%edi
80106e98:	75 dd                	jne    80106e77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea0:	5b                   	pop    %ebx
80106ea1:	5e                   	pop    %esi
80106ea2:	5f                   	pop    %edi
80106ea3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ea4:	e9 37 b6 ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80106ea9:	83 ec 0c             	sub    $0xc,%esp
80106eac:	68 41 7e 10 80       	push   $0x80107e41
80106eb1:	e8 ca 94 ff ff       	call   80100380 <panic>
80106eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi

80106ec0 <setupkvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	56                   	push   %esi
80106ec4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ec5:	e8 d6 b7 ff ff       	call   801026a0 <kalloc>
80106eca:	89 c6                	mov    %eax,%esi
80106ecc:	85 c0                	test   %eax,%eax
80106ece:	74 42                	je     80106f12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106ed0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ed3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ed8:	68 00 10 00 00       	push   $0x1000
80106edd:	6a 00                	push   $0x0
80106edf:	50                   	push   %eax
80106ee0:	e8 6b d7 ff ff       	call   80104650 <memset>
80106ee5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ee8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106eeb:	8b 53 08             	mov    0x8(%ebx),%edx
80106eee:	83 ec 0c             	sub    $0xc,%esp
80106ef1:	ff 73 0c             	push   0xc(%ebx)
80106ef4:	29 c2                	sub    %eax,%edx
80106ef6:	50                   	push   %eax
80106ef7:	52                   	push   %edx
80106ef8:	ff 33                	push   (%ebx)
80106efa:	56                   	push   %esi
80106efb:	e8 60 fa ff ff       	call   80106960 <mappages>
80106f00:	83 c4 20             	add    $0x20,%esp
80106f03:	85 c0                	test   %eax,%eax
80106f05:	78 19                	js     80106f20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f07:	83 c3 10             	add    $0x10,%ebx
80106f0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f10:	75 d6                	jne    80106ee8 <setupkvm+0x28>
}
80106f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f15:	89 f0                	mov    %esi,%eax
80106f17:	5b                   	pop    %ebx
80106f18:	5e                   	pop    %esi
80106f19:	5d                   	pop    %ebp
80106f1a:	c3                   	ret    
80106f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
      freevm(pgdir);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	56                   	push   %esi
      return 0;
80106f24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f26:	e8 15 ff ff ff       	call   80106e40 <freevm>
      return 0;
80106f2b:	83 c4 10             	add    $0x10,%esp
}
80106f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f31:	89 f0                	mov    %esi,%eax
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5d                   	pop    %ebp
80106f36:	c3                   	ret    
80106f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <kvmalloc>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f46:	e8 75 ff ff ff       	call   80106ec0 <setupkvm>
80106f4b:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	05 00 00 00 80       	add    $0x80000000,%eax
80106f55:	0f 22 d8             	mov    %eax,%cr3
}
80106f58:	c9                   	leave  
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 08             	sub    $0x8,%esp
80106f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f69:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106f6c:	89 c1                	mov    %eax,%ecx
80106f6e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f71:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f74:	f6 c2 01             	test   $0x1,%dl
80106f77:	75 17                	jne    80106f90 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 52 7e 10 80       	push   $0x80107e52
80106f81:	e8 fa 93 ff ff       	call   80100380 <panic>
80106f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f99:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	74 d0                	je     80106f79 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106fa9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fac:	c9                   	leave  
80106fad:	c3                   	ret    
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fb9:	e8 02 ff ff ff       	call   80106ec0 <setupkvm>
80106fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fc1:	85 c0                	test   %eax,%eax
80106fc3:	0f 84 bd 00 00 00    	je     80107086 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	0f 84 b2 00 00 00    	je     80107086 <copyuvm+0xd6>
80106fd4:	31 f6                	xor    %esi,%esi
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80106fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106fe3:	89 f0                	mov    %esi,%eax
80106fe5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106fe8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106feb:	a8 01                	test   $0x1,%al
80106fed:	75 11                	jne    80107000 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fef:	83 ec 0c             	sub    $0xc,%esp
80106ff2:	68 5c 7e 10 80       	push   $0x80107e5c
80106ff7:	e8 84 93 ff ff       	call   80100380 <panic>
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107000:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107002:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107007:	c1 ea 0a             	shr    $0xa,%edx
8010700a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107010:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107017:	85 c0                	test   %eax,%eax
80107019:	74 d4                	je     80106fef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010701b:	8b 18                	mov    (%eax),%ebx
8010701d:	f6 c3 01             	test   $0x1,%bl
80107020:	0f 84 92 00 00 00    	je     801070b8 <copyuvm+0x108>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107026:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107028:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
8010702e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107034:	e8 67 b6 ff ff       	call   801026a0 <kalloc>
80107039:	85 c0                	test   %eax,%eax
8010703b:	74 5b                	je     80107098 <copyuvm+0xe8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010703d:	83 ec 04             	sub    $0x4,%esp
80107040:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107049:	68 00 10 00 00       	push   $0x1000
8010704e:	57                   	push   %edi
8010704f:	50                   	push   %eax
80107050:	e8 9b d6 ff ff       	call   801046f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107058:	89 1c 24             	mov    %ebx,(%esp)
8010705b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107061:	52                   	push   %edx
80107062:	68 00 10 00 00       	push   $0x1000
80107067:	56                   	push   %esi
80107068:	ff 75 e0             	push   -0x20(%ebp)
8010706b:	e8 f0 f8 ff ff       	call   80106960 <mappages>
80107070:	83 c4 20             	add    $0x20,%esp
80107073:	85 c0                	test   %eax,%eax
80107075:	78 21                	js     80107098 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107077:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010707d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107080:	0f 87 5a ff ff ff    	ja     80106fe0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107086:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107089:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708c:	5b                   	pop    %ebx
8010708d:	5e                   	pop    %esi
8010708e:	5f                   	pop    %edi
8010708f:	5d                   	pop    %ebp
80107090:	c3                   	ret    
80107091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  freevm(d);
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	ff 75 e0             	push   -0x20(%ebp)
8010709e:	e8 9d fd ff ff       	call   80106e40 <freevm>
  return 0;
801070a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070aa:	83 c4 10             	add    $0x10,%esp
}
801070ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5f                   	pop    %edi
801070b6:	5d                   	pop    %ebp
801070b7:	c3                   	ret    
      panic("copyuvm: page not present");
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	68 76 7e 10 80       	push   $0x80107e76
801070c0:	e8 bb 92 ff ff       	call   80100380 <panic>
801070c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070d9:	89 c1                	mov    %eax,%ecx
801070db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070e1:	f6 c2 01             	test   $0x1,%dl
801070e4:	0f 84 00 01 00 00    	je     801071ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801070ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801070f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801070f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107100:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107107:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010710a:	05 00 00 00 80       	add    $0x80000000,%eax
8010710f:	83 fa 05             	cmp    $0x5,%edx
80107112:	ba 00 00 00 00       	mov    $0x0,%edx
80107117:	0f 45 c2             	cmovne %edx,%eax
}
8010711a:	c3                   	ret    
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	8b 75 14             	mov    0x14(%ebp),%esi
8010712c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107132:	85 f6                	test   %esi,%esi
80107134:	75 51                	jne    80107187 <copyout+0x67>
80107136:	e9 a5 00 00 00       	jmp    801071e0 <copyout+0xc0>
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107140:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107146:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010714c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107152:	74 75                	je     801071c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107154:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107156:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107159:	29 c3                	sub    %eax,%ebx
8010715b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107161:	39 f3                	cmp    %esi,%ebx
80107163:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107166:	29 f8                	sub    %edi,%eax
80107168:	83 ec 04             	sub    $0x4,%esp
8010716b:	01 c1                	add    %eax,%ecx
8010716d:	53                   	push   %ebx
8010716e:	52                   	push   %edx
8010716f:	51                   	push   %ecx
80107170:	e8 7b d5 ff ff       	call   801046f0 <memmove>
    len -= n;
    buf += n;
80107175:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107178:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010717e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107181:	01 da                	add    %ebx,%edx
  while(len > 0){
80107183:	29 de                	sub    %ebx,%esi
80107185:	74 59                	je     801071e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010718a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010718c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010718e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107191:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107197:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010719a:	f6 c1 01             	test   $0x1,%cl
8010719d:	0f 84 4e 00 00 00    	je     801071f1 <copyout.cold>
  return &pgtab[PTX(va)];
801071a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071ab:	c1 eb 0c             	shr    $0xc,%ebx
801071ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801071b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801071bb:	89 d9                	mov    %ebx,%ecx
801071bd:	83 e1 05             	and    $0x5,%ecx
801071c0:	83 f9 05             	cmp    $0x5,%ecx
801071c3:	0f 84 77 ff ff ff    	je     80107140 <copyout+0x20>
  }
  return 0;
}
801071c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071d1:	5b                   	pop    %ebx
801071d2:	5e                   	pop    %esi
801071d3:	5f                   	pop    %edi
801071d4:	5d                   	pop    %ebp
801071d5:	c3                   	ret    
801071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    

801071ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801071ea:	a1 00 00 00 00       	mov    0x0,%eax
801071ef:	0f 0b                	ud2    

801071f1 <copyout.cold>:
801071f1:	a1 00 00 00 00       	mov    0x0,%eax
801071f6:	0f 0b                	ud2    
801071f8:	66 90                	xchg   %ax,%ax
801071fa:	66 90                	xchg   %ax,%ax
801071fc:	66 90                	xchg   %ax,%ax
801071fe:	66 90                	xchg   %ax,%ax

80107200 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107206:	68 b3 7e 10 80       	push   $0x80107eb3
8010720b:	68 e0 44 11 80       	push   $0x801144e0
80107210:	e8 bb d1 ff ff       	call   801043d0 <initlock>
  acquire(&(shm_table.lock));
80107215:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
8010721c:	e8 bf d2 ff ff       	call   801044e0 <acquire>
  for (i = 0; i< 64; i++) {
80107221:	b8 14 45 11 80       	mov    $0x80114514,%eax
80107226:	83 c4 10             	add    $0x10,%esp
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    shm_table.shm_pages[i].id =0;
80107230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (i = 0; i< 64; i++) {
80107236:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80107239:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80107240:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80107247:	3d 14 48 11 80       	cmp    $0x80114814,%eax
8010724c:	75 e2                	jne    80107230 <shminit+0x30>
  }
  release(&(shm_table.lock));
8010724e:	83 ec 0c             	sub    $0xc,%esp
80107251:	68 e0 44 11 80       	push   $0x801144e0
80107256:	e8 a5 d3 ff ff       	call   80104600 <release>
}
8010725b:	83 c4 10             	add    $0x10,%esp
8010725e:	c9                   	leave  
8010725f:	c3                   	ret    

80107260 <shm_open>:

int shm_open(int id, char **pointer) {
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 28             	sub    $0x28,%esp
80107269:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&shm_table.lock);
8010726c:	68 e0 44 11 80       	push   $0x801144e0
80107271:	e8 6a d2 ff ff       	call   801044e0 <acquire>

    struct proc *current_proc = myproc();
80107276:	e8 15 c7 ff ff       	call   80103990 <myproc>
8010727b:	ba 14 45 11 80       	mov    $0x80114514,%edx
80107280:	83 c4 10             	add    $0x10,%esp
80107283:	89 c7                	mov    %eax,%edi
    uint va = PGROUNDUP(current_proc->sz);  // Get next aligned virtual address
80107285:	8b 00                	mov    (%eax),%eax
80107287:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi

    // Case 1: Check if the shared memory segment already exists
    for (int i = 0; i < 64; i++) {
8010728d:	31 c0                	xor    %eax,%eax
    uint va = PGROUNDUP(current_proc->sz);  // Get next aligned virtual address
8010728f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (int i = 0; i < 64; i++) {
80107295:	eb 14                	jmp    801072ab <shm_open+0x4b>
80107297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	83 c0 01             	add    $0x1,%eax
801072a3:	83 c2 0c             	add    $0xc,%edx
801072a6:	83 f8 40             	cmp    $0x40,%eax
801072a9:	74 65                	je     80107310 <shm_open+0xb0>
        if (shm_table.shm_pages[i].id == id) {
801072ab:	39 1a                	cmp    %ebx,(%edx)
801072ad:	75 f1                	jne    801072a0 <shm_open+0x40>
            shm_table.shm_pages[i].refcnt++;  // Increment reference count
801072af:	8d 04 40             	lea    (%eax,%eax,2),%eax
            if (mappages(current_proc->pgdir, (char *)va, PGSIZE, 
801072b2:	83 ec 0c             	sub    $0xc,%esp
            shm_table.shm_pages[i].refcnt++;  // Increment reference count
801072b5:	8d 04 85 e0 44 11 80 	lea    -0x7feebb20(,%eax,4),%eax
801072bc:	83 40 3c 01          	addl   $0x1,0x3c(%eax)
            if (mappages(current_proc->pgdir, (char *)va, PGSIZE, 
801072c0:	6a 06                	push   $0x6
801072c2:	8b 40 38             	mov    0x38(%eax),%eax
801072c5:	05 00 00 00 80       	add    $0x80000000,%eax
801072ca:	50                   	push   %eax
801072cb:	68 00 10 00 00       	push   $0x1000
801072d0:	56                   	push   %esi
801072d1:	ff 77 04             	push   0x4(%edi)
801072d4:	e8 87 f6 ff ff       	call   80106960 <mappages>
801072d9:	83 c4 20             	add    $0x20,%esp
801072dc:	85 c0                	test   %eax,%eax
801072de:	0f 88 e5 00 00 00    	js     801073c9 <shm_open+0x169>
                         V2P(shm_table.shm_pages[i].frame), PTE_W | PTE_U) < 0) {
                release(&shm_table.lock);
                return -1;  // Mapping failed
            }
            *pointer = (char *)va;  // Set the pointer to the virtual address
801072e4:	8b 45 0c             	mov    0xc(%ebp),%eax
            current_proc->sz = va + PGSIZE;  // Update process's virtual address size
            release(&shm_table.lock);
801072e7:	83 ec 0c             	sub    $0xc,%esp
            *pointer = (char *)va;  // Set the pointer to the virtual address
801072ea:	89 30                	mov    %esi,(%eax)
            current_proc->sz = va + PGSIZE;  // Update process's virtual address size
801072ec:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072f2:	89 37                	mov    %esi,(%edi)
            release(&shm_table.lock);
801072f4:	68 e0 44 11 80       	push   $0x801144e0
801072f9:	e8 02 d3 ff ff       	call   80104600 <release>
            return 0;
801072fe:	83 c4 10             	add    $0x10,%esp
80107301:	31 d2                	xor    %edx,%edx
        }
    }

    release(&shm_table.lock);
    return -1;  // No available entries in shm_table
}
80107303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107306:	89 d0                	mov    %edx,%eax
80107308:	5b                   	pop    %ebx
80107309:	5e                   	pop    %esi
8010730a:	5f                   	pop    %edi
8010730b:	5d                   	pop    %ebp
8010730c:	c3                   	ret    
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
80107310:	b9 1c 45 11 80       	mov    $0x8011451c,%ecx
    for (int i = 0; i < 64; i++) {
80107315:	31 c0                	xor    %eax,%eax
80107317:	eb 16                	jmp    8010732f <shm_open+0xcf>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107320:	83 c0 01             	add    $0x1,%eax
80107323:	83 c1 0c             	add    $0xc,%ecx
80107326:	83 f8 40             	cmp    $0x40,%eax
80107329:	0f 84 9a 00 00 00    	je     801073c9 <shm_open+0x169>
        if (shm_table.shm_pages[i].refcnt == 0) {  // Find an empty entry
8010732f:	8b 11                	mov    (%ecx),%edx
80107331:	85 d2                	test   %edx,%edx
80107333:	75 eb                	jne    80107320 <shm_open+0xc0>
            shm_table.shm_pages[i].id = id;
80107335:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107338:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010733b:	8d 0c 85 e0 44 11 80 	lea    -0x7feebb20(,%eax,4),%ecx
80107342:	89 59 34             	mov    %ebx,0x34(%ecx)
80107345:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
            shm_table.shm_pages[i].frame = kalloc();  // Allocate physical memory
80107348:	e8 53 b3 ff ff       	call   801026a0 <kalloc>
8010734d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107350:	89 41 38             	mov    %eax,0x38(%ecx)
            if (!shm_table.shm_pages[i].frame) {
80107353:	85 c0                	test   %eax,%eax
80107355:	74 72                	je     801073c9 <shm_open+0x169>
            memset(shm_table.shm_pages[i].frame, 0, PGSIZE);  // Initialize memory
80107357:	83 ec 04             	sub    $0x4,%esp
8010735a:	68 00 10 00 00       	push   $0x1000
8010735f:	6a 00                	push   $0x0
80107361:	50                   	push   %eax
80107362:	e8 e9 d2 ff ff       	call   80104650 <memset>
            shm_table.shm_pages[i].refcnt = 1;
80107367:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010736a:	c7 41 3c 01 00 00 00 	movl   $0x1,0x3c(%ecx)
            if (mappages(current_proc->pgdir, (char *)va, PGSIZE, 
80107371:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80107378:	8b 41 38             	mov    0x38(%ecx),%eax
8010737b:	05 00 00 00 80       	add    $0x80000000,%eax
80107380:	50                   	push   %eax
80107381:	68 00 10 00 00       	push   $0x1000
80107386:	56                   	push   %esi
80107387:	ff 77 04             	push   0x4(%edi)
8010738a:	e8 d1 f5 ff ff       	call   80106960 <mappages>
8010738f:	83 c4 20             	add    $0x20,%esp
80107392:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107395:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107398:	85 c0                	test   %eax,%eax
8010739a:	78 47                	js     801073e3 <shm_open+0x183>
            *pointer = (char *)va;  // Set the pointer to the virtual address
8010739c:	8b 45 0c             	mov    0xc(%ebp),%eax
            release(&shm_table.lock);
8010739f:	83 ec 0c             	sub    $0xc,%esp
801073a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            *pointer = (char *)va;  // Set the pointer to the virtual address
801073a5:	89 30                	mov    %esi,(%eax)
            current_proc->sz = va + PGSIZE;  // Update process's virtual address size
801073a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073ad:	89 37                	mov    %esi,(%edi)
            release(&shm_table.lock);
801073af:	68 e0 44 11 80       	push   $0x801144e0
801073b4:	e8 47 d2 ff ff       	call   80104600 <release>
            return 0;
801073b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073bc:	83 c4 10             	add    $0x10,%esp
}
801073bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c2:	5b                   	pop    %ebx
801073c3:	5e                   	pop    %esi
801073c4:	89 d0                	mov    %edx,%eax
801073c6:	5f                   	pop    %edi
801073c7:	5d                   	pop    %ebp
801073c8:	c3                   	ret    
                release(&shm_table.lock);
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 e0 44 11 80       	push   $0x801144e0
801073d1:	e8 2a d2 ff ff       	call   80104600 <release>
                return -1;  // Mapping failed
801073d6:	83 c4 10             	add    $0x10,%esp
801073d9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801073de:	e9 20 ff ff ff       	jmp    80107303 <shm_open+0xa3>
                kfree(shm_table.shm_pages[i].frame);  // Free memory on failure
801073e3:	83 ec 0c             	sub    $0xc,%esp
801073e6:	ff 71 38             	push   0x38(%ecx)
801073e9:	e8 f2 b0 ff ff       	call   801024e0 <kfree>
                shm_table.shm_pages[i].id = 0;
801073ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073f1:	c7 41 34 00 00 00 00 	movl   $0x0,0x34(%ecx)
                shm_table.shm_pages[i].frame = 0;
801073f8:	c7 41 38 00 00 00 00 	movl   $0x0,0x38(%ecx)
                shm_table.shm_pages[i].refcnt = 0;
801073ff:	c7 41 3c 00 00 00 00 	movl   $0x0,0x3c(%ecx)
                release(&shm_table.lock);
80107406:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
8010740d:	e8 ee d1 ff ff       	call   80104600 <release>
                return -1;  // Mapping failed
80107412:	83 c4 10             	add    $0x10,%esp
80107415:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010741a:	e9 e4 fe ff ff       	jmp    80107303 <shm_open+0xa3>
8010741f:	90                   	nop

80107420 <shm_close>:


int shm_close(int id) {
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	53                   	push   %ebx
80107424:	83 ec 10             	sub    $0x10,%esp
80107427:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&shm_table.lock);
8010742a:	68 e0 44 11 80       	push   $0x801144e0
8010742f:	e8 ac d0 ff ff       	call   801044e0 <acquire>

    for (int i = 0; i < 64; i++) {
80107434:	ba 14 45 11 80       	mov    $0x80114514,%edx
80107439:	83 c4 10             	add    $0x10,%esp
8010743c:	31 c0                	xor    %eax,%eax
8010743e:	eb 0b                	jmp    8010744b <shm_close+0x2b>
80107440:	83 c0 01             	add    $0x1,%eax
80107443:	83 c2 0c             	add    $0xc,%edx
80107446:	83 f8 40             	cmp    $0x40,%eax
80107449:	74 75                	je     801074c0 <shm_close+0xa0>
        if (shm_table.shm_pages[i].id == id) {
8010744b:	39 1a                	cmp    %ebx,(%edx)
8010744d:	75 f1                	jne    80107440 <shm_close+0x20>
            shm_table.shm_pages[i].refcnt--;  // Decrement reference count
8010744f:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107452:	8d 1c 85 e0 44 11 80 	lea    -0x7feebb20(,%eax,4),%ebx
80107459:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010745c:	83 e8 01             	sub    $0x1,%eax
8010745f:	89 43 3c             	mov    %eax,0x3c(%ebx)
            if (shm_table.shm_pages[i].refcnt > 0) {
80107462:	85 c0                	test   %eax,%eax
80107464:	7e 1a                	jle    80107480 <shm_close+0x60>
                release(&shm_table.lock);
80107466:	83 ec 0c             	sub    $0xc,%esp
80107469:	68 e0 44 11 80       	push   $0x801144e0
8010746e:	e8 8d d1 ff ff       	call   80104600 <release>
        }
    }

    release(&shm_table.lock);
    return 1;  // ID not found
}
80107473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
                return 0;  // Shared memory still in use
80107476:	83 c4 10             	add    $0x10,%esp
80107479:	31 c0                	xor    %eax,%eax
}
8010747b:	c9                   	leave  
8010747c:	c3                   	ret    
8010747d:	8d 76 00             	lea    0x0(%esi),%esi
            kfree(shm_table.shm_pages[i].frame);  // Free physical memory
80107480:	83 ec 0c             	sub    $0xc,%esp
80107483:	ff 73 38             	push   0x38(%ebx)
80107486:	e8 55 b0 ff ff       	call   801024e0 <kfree>
            shm_table.shm_pages[i].frame = 0;
8010748b:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
            shm_table.shm_pages[i].id = 0;
80107492:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
            shm_table.shm_pages[i].refcnt = 0;
80107499:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
            release(&shm_table.lock);
801074a0:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
801074a7:	e8 54 d1 ff ff       	call   80104600 <release>
}
801074ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return 0;  // Successfully closed
801074af:	83 c4 10             	add    $0x10,%esp
801074b2:	31 c0                	xor    %eax,%eax
}
801074b4:	c9                   	leave  
801074b5:	c3                   	ret    
801074b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&shm_table.lock);
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	68 e0 44 11 80       	push   $0x801144e0
801074c8:	e8 33 d1 ff ff       	call   80104600 <release>
}
801074cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 1;  // ID not found
801074d0:	83 c4 10             	add    $0x10,%esp
801074d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801074d8:	c9                   	leave  
801074d9:	c3                   	ret    
