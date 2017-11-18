
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 06 38 10 80       	mov    $0x80103806,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 e4 81 10 	movl   $0x801081e4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100049:	e8 bc 4d 00 00       	call   80104e0a <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 eb 81 10 	movl   $0x801081eb,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 35 4c 00 00       	call   80104ccc <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 90 0d 11 80       	mov    0x80110d90,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 90 0d 11 80       	mov    %eax,0x80110d90

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801000c9:	e8 5d 4d 00 00       	call   80104e2b <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100104:	e8 8c 4d 00 00       	call   80104e95 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 ef 4b 00 00       	call   80104d06 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 8c 0d 11 80       	mov    0x80110d8c,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010017d:	e8 13 4d 00 00       	call   80104e95 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 76 4b 00 00       	call   80104d06 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 f2 81 10 80 	movl   $0x801081f2,(%esp)
801001ae:	e8 a1 03 00 00       	call   80100554 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 56 27 00 00       	call   8010293d <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 a3 4b 00 00       	call   80104da3 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 03 82 10 80 	movl   $0x80108203,(%esp)
8010020b:	e8 44 03 00 00       	call   80100554 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 13 27 00 00       	call   8010293d <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 63 4b 00 00       	call   80104da3 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 0a 82 10 80 	movl   $0x8010820a,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 03 4b 00 00       	call   80104d61 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100265:	e8 c1 4b 00 00       	call   80104e2b <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801002d1:	e8 bf 4b 00 00       	call   80104e95 <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801002e8:	89 c2                	mov    %eax,%edx
801002ea:	ec                   	in     (%dx),%al
801002eb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ee:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801002f1:	c9                   	leave  
801002f2:	c3                   	ret    

801002f3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f3:	55                   	push   %ebp
801002f4:	89 e5                	mov    %esp,%ebp
801002f6:	83 ec 08             	sub    $0x8,%esp
801002f9:	8b 45 08             	mov    0x8(%ebp),%eax
801002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801002ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100303:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100306:	8a 45 f8             	mov    -0x8(%ebp),%al
80100309:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	c9                   	leave  
8010030e:	c3                   	ret    

8010030f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030f:	55                   	push   %ebp
80100310:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100312:	fa                   	cli    
}
80100313:	5d                   	pop    %ebp
80100314:	c3                   	ret    

80100315 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100315:	55                   	push   %ebp
80100316:	89 e5                	mov    %esp,%ebp
80100318:	56                   	push   %esi
80100319:	53                   	push   %ebx
8010031a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100321:	74 1c                	je     8010033f <printint+0x2a>
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	c1 e8 1f             	shr    $0x1f,%eax
80100329:	0f b6 c0             	movzbl %al,%eax
8010032c:	89 45 10             	mov    %eax,0x10(%ebp)
8010032f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100333:	74 0a                	je     8010033f <printint+0x2a>
    x = -xx;
80100335:	8b 45 08             	mov    0x8(%ebp),%eax
80100338:	f7 d8                	neg    %eax
8010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033d:	eb 06                	jmp    80100345 <printint+0x30>
  else
    x = xx;
8010033f:	8b 45 08             	mov    0x8(%ebp),%eax
80100342:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034f:	8d 41 01             	lea    0x1(%ecx),%eax
80100352:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 f3                	div    %ebx
80100362:	89 d0                	mov    %edx,%eax
80100364:	8a 80 04 90 10 80    	mov    -0x7fef6ffc(%eax),%al
8010036a:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036e:	8b 75 0c             	mov    0xc(%ebp),%esi
80100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100374:	ba 00 00 00 00       	mov    $0x0,%edx
80100379:	f7 f6                	div    %esi
8010037b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100382:	75 c8                	jne    8010034c <printint+0x37>

  if(sign)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 10                	je     8010039a <printint+0x85>
    buf[i++] = '-';
8010038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038d:	8d 50 01             	lea    0x1(%eax),%edx
80100390:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100393:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100398:	eb 17                	jmp    801003b1 <printint+0x9c>
8010039a:	eb 15                	jmp    801003b1 <printint+0x9c>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	8a 00                	mov    (%eax),%al
801003a6:	0f be c0             	movsbl %al,%eax
801003a9:	89 04 24             	mov    %eax,(%esp)
801003ac:	e8 b7 03 00 00       	call   80100768 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b1:	ff 4d f4             	decl   -0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 e2                	jns    8010039c <printint+0x87>
    consputc(buf[i]);
}
801003ba:	83 c4 30             	add    $0x30,%esp
801003bd:	5b                   	pop    %ebx
801003be:	5e                   	pop    %esi
801003bf:	5d                   	pop    %ebp
801003c0:	c3                   	ret    

801003c1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c1:	55                   	push   %ebp
801003c2:	89 e5                	mov    %esp,%ebp
801003c4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c7:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
801003cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d3:	74 0c                	je     801003e1 <cprintf+0x20>
    acquire(&cons.lock);
801003d5:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801003dc:	e8 4a 4a 00 00       	call   80104e2b <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 11 82 10 80 	movl   $0x80108211,(%esp)
801003ef:	e8 60 01 00 00       	call   80100554 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100401:	e9 1b 01 00 00       	jmp    80100521 <cprintf+0x160>
    if(c != '%'){
80100406:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040a:	74 10                	je     8010041c <cprintf+0x5b>
      consputc(c);
8010040c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010040f:	89 04 24             	mov    %eax,(%esp)
80100412:	e8 51 03 00 00       	call   80100768 <consputc>
      continue;
80100417:	e9 02 01 00 00       	jmp    8010051e <cprintf+0x15d>
    }
    c = fmt[++i] & 0xff;
8010041c:	8b 55 08             	mov    0x8(%ebp),%edx
8010041f:	ff 45 f4             	incl   -0xc(%ebp)
80100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100425:	01 d0                	add    %edx,%eax
80100427:	8a 00                	mov    (%eax),%al
80100429:	0f be c0             	movsbl %al,%eax
8010042c:	25 ff 00 00 00       	and    $0xff,%eax
80100431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100438:	75 05                	jne    8010043f <cprintf+0x7e>
      break;
8010043a:	e9 01 01 00 00       	jmp    80100540 <cprintf+0x17f>
    switch(c){
8010043f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100442:	83 f8 70             	cmp    $0x70,%eax
80100445:	74 4f                	je     80100496 <cprintf+0xd5>
80100447:	83 f8 70             	cmp    $0x70,%eax
8010044a:	7f 13                	jg     8010045f <cprintf+0x9e>
8010044c:	83 f8 25             	cmp    $0x25,%eax
8010044f:	0f 84 a3 00 00 00    	je     801004f8 <cprintf+0x137>
80100455:	83 f8 64             	cmp    $0x64,%eax
80100458:	74 14                	je     8010046e <cprintf+0xad>
8010045a:	e9 a7 00 00 00       	jmp    80100506 <cprintf+0x145>
8010045f:	83 f8 73             	cmp    $0x73,%eax
80100462:	74 57                	je     801004bb <cprintf+0xfa>
80100464:	83 f8 78             	cmp    $0x78,%eax
80100467:	74 2d                	je     80100496 <cprintf+0xd5>
80100469:	e9 98 00 00 00       	jmp    80100506 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
8010046e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100471:	8d 50 04             	lea    0x4(%eax),%edx
80100474:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100477:	8b 00                	mov    (%eax),%eax
80100479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100480:	00 
80100481:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100488:	00 
80100489:	89 04 24             	mov    %eax,(%esp)
8010048c:	e8 84 fe ff ff       	call   80100315 <printint>
      break;
80100491:	e9 88 00 00 00       	jmp    8010051e <cprintf+0x15d>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004a8:	00 
801004a9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b0:	00 
801004b1:	89 04 24             	mov    %eax,(%esp)
801004b4:	e8 5c fe ff ff       	call   80100315 <printint>
      break;
801004b9:	eb 63                	jmp    8010051e <cprintf+0x15d>
    case 's':
      if((s = (char*)*argp++) == 0)
801004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004be:	8d 50 04             	lea    0x4(%eax),%edx
801004c1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c4:	8b 00                	mov    (%eax),%eax
801004c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cd:	75 09                	jne    801004d8 <cprintf+0x117>
        s = "(null)";
801004cf:	c7 45 ec 1a 82 10 80 	movl   $0x8010821a,-0x14(%ebp)
      for(; *s; s++)
801004d6:	eb 15                	jmp    801004ed <cprintf+0x12c>
801004d8:	eb 13                	jmp    801004ed <cprintf+0x12c>
        consputc(*s);
801004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dd:	8a 00                	mov    (%eax),%al
801004df:	0f be c0             	movsbl %al,%eax
801004e2:	89 04 24             	mov    %eax,(%esp)
801004e5:	e8 7e 02 00 00       	call   80100768 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004ea:	ff 45 ec             	incl   -0x14(%ebp)
801004ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f0:	8a 00                	mov    (%eax),%al
801004f2:	84 c0                	test   %al,%al
801004f4:	75 e4                	jne    801004da <cprintf+0x119>
        consputc(*s);
      break;
801004f6:	eb 26                	jmp    8010051e <cprintf+0x15d>
    case '%':
      consputc('%');
801004f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ff:	e8 64 02 00 00       	call   80100768 <consputc>
      break;
80100504:	eb 18                	jmp    8010051e <cprintf+0x15d>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100506:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050d:	e8 56 02 00 00       	call   80100768 <consputc>
      consputc(c);
80100512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100515:	89 04 24             	mov    %eax,(%esp)
80100518:	e8 4b 02 00 00       	call   80100768 <consputc>
      break;
8010051d:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010051e:	ff 45 f4             	incl   -0xc(%ebp)
80100521:	8b 55 08             	mov    0x8(%ebp),%edx
80100524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100527:	01 d0                	add    %edx,%eax
80100529:	8a 00                	mov    (%eax),%al
8010052b:	0f be c0             	movsbl %al,%eax
8010052e:	25 ff 00 00 00       	and    $0xff,%eax
80100533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053a:	0f 85 c6 fe ff ff    	jne    80100406 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100540:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100544:	74 0c                	je     80100552 <cprintf+0x191>
    release(&cons.lock);
80100546:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010054d:	e8 43 49 00 00       	call   80104e95 <release>
}
80100552:	c9                   	leave  
80100553:	c3                   	ret    

80100554 <panic>:

void
panic(char *s)
{
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
8010055a:	e8 b0 fd ff ff       	call   8010030f <cli>
  cons.locking = 0;
8010055f:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
80100566:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100569:	e8 6b 2a 00 00       	call   80102fd9 <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 21 82 10 80 	movl   $0x80108221,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 35 82 10 80 	movl   $0x80108235,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 3b 49 00 00       	call   80104ee2 <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 37 82 10 80 	movl   $0x80108237,(%esp)
801005c2:	e8 fa fd ff ff       	call   801003c1 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c7:	ff 45 f4             	incl   -0xc(%ebp)
801005ca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005ce:	7e e0                	jle    801005b0 <panic+0x5c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005d0:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
801005d7:	00 00 00 
  for(;;)
    ;
801005da:	eb fe                	jmp    801005da <panic+0x86>

801005dc <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005dc:	55                   	push   %ebp
801005dd:	89 e5                	mov    %esp,%ebp
801005df:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005e2:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e9:	00 
801005ea:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005f1:	e8 fd fc ff ff       	call   801002f3 <outb>
  pos = inb(CRTPORT+1) << 8;
801005f6:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005fd:	e8 d6 fc ff ff       	call   801002d8 <inb>
80100602:	0f b6 c0             	movzbl %al,%eax
80100605:	c1 e0 08             	shl    $0x8,%eax
80100608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010060b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100612:	00 
80100613:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010061a:	e8 d4 fc ff ff       	call   801002f3 <outb>
  pos |= inb(CRTPORT+1);
8010061f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100626:	e8 ad fc ff ff       	call   801002d8 <inb>
8010062b:	0f b6 c0             	movzbl %al,%eax
8010062e:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100631:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100635:	75 1b                	jne    80100652 <cgaputc+0x76>
    pos += 80 - pos%80;
80100637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010063a:	b9 50 00 00 00       	mov    $0x50,%ecx
8010063f:	99                   	cltd   
80100640:	f7 f9                	idiv   %ecx
80100642:	89 d0                	mov    %edx,%eax
80100644:	ba 50 00 00 00       	mov    $0x50,%edx
80100649:	29 c2                	sub    %eax,%edx
8010064b:	89 d0                	mov    %edx,%eax
8010064d:	01 45 f4             	add    %eax,-0xc(%ebp)
80100650:	eb 34                	jmp    80100686 <cgaputc+0xaa>
  else if(c == BACKSPACE){
80100652:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100659:	75 0b                	jne    80100666 <cgaputc+0x8a>
    if(pos > 0) --pos;
8010065b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010065f:	7e 25                	jle    80100686 <cgaputc+0xaa>
80100661:	ff 4d f4             	decl   -0xc(%ebp)
80100664:	eb 20                	jmp    80100686 <cgaputc+0xaa>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100666:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010066f:	8d 50 01             	lea    0x1(%eax),%edx
80100672:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100675:	01 c0                	add    %eax,%eax
80100677:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067a:	8b 45 08             	mov    0x8(%ebp),%eax
8010067d:	0f b6 c0             	movzbl %al,%eax
80100680:	80 cc 07             	or     $0x7,%ah
80100683:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	78 09                	js     80100695 <cgaputc+0xb9>
8010068c:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100693:	7e 0c                	jle    801006a1 <cgaputc+0xc5>
    panic("pos under/overflow");
80100695:	c7 04 24 3b 82 10 80 	movl   $0x8010823b,(%esp)
8010069c:	e8 b3 fe ff ff       	call   80100554 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006a1:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a8:	7e 53                	jle    801006fd <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006aa:	a1 00 90 10 80       	mov    0x80109000,%eax
801006af:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b5:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ba:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c1:	00 
801006c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801006c6:	89 04 24             	mov    %eax,(%esp)
801006c9:	e8 89 4a 00 00       	call   80105157 <memmove>
    pos -= 80;
801006ce:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d2:	b8 80 07 00 00       	mov    $0x780,%eax
801006d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006da:	01 c0                	add    %eax,%eax
801006dc:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801006e5:	01 d2                	add    %edx,%edx
801006e7:	01 ca                	add    %ecx,%edx
801006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801006ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f4:	00 
801006f5:	89 14 24             	mov    %edx,(%esp)
801006f8:	e8 91 49 00 00       	call   8010508e <memset>
  }

  outb(CRTPORT, 14);
801006fd:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100704:	00 
80100705:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010070c:	e8 e2 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos>>8);
80100711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100714:	c1 f8 08             	sar    $0x8,%eax
80100717:	0f b6 c0             	movzbl %al,%eax
8010071a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010071e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100725:	e8 c9 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT, 15);
8010072a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100731:	00 
80100732:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100739:	e8 b5 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos);
8010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	89 44 24 04          	mov    %eax,0x4(%esp)
80100748:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074f:	e8 9f fb ff ff       	call   801002f3 <outb>
  crt[pos] = ' ' | 0x0700;
80100754:	8b 15 00 90 10 80    	mov    0x80109000,%edx
8010075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010075d:	01 c0                	add    %eax,%eax
8010075f:	01 d0                	add    %edx,%eax
80100761:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100766:	c9                   	leave  
80100767:	c3                   	ret    

80100768 <consputc>:

void
consputc(int c)
{
80100768:	55                   	push   %ebp
80100769:	89 e5                	mov    %esp,%ebp
8010076b:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010076e:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80100773:	85 c0                	test   %eax,%eax
80100775:	74 07                	je     8010077e <consputc+0x16>
    cli();
80100777:	e8 93 fb ff ff       	call   8010030f <cli>
    for(;;)
      ;
8010077c:	eb fe                	jmp    8010077c <consputc+0x14>
  }

  if(c == BACKSPACE){
8010077e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100785:	75 26                	jne    801007ad <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 d1 61 00 00       	call   80106964 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 c5 61 00 00       	call   80106964 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 b9 61 00 00       	call   80106964 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 ac 61 00 00       	call   80106964 <uartputc>
  cgaputc(c);
801007b8:	8b 45 08             	mov    0x8(%ebp),%eax
801007bb:	89 04 24             	mov    %eax,(%esp)
801007be:	e8 19 fe ff ff       	call   801005dc <cgaputc>
}
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <copy_buf>:

#define C(x)  ((x)-'@')  // Control-x


void copy_buf(char *dst, char *src, int len)
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 10             	sub    $0x10,%esp
  int i;

  for (i = 0; i < len; i++) {
801007cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801007d2:	eb 17                	jmp    801007eb <copy_buf+0x26>
    dst[i] = src[i];
801007d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801007d7:	8b 45 08             	mov    0x8(%ebp),%eax
801007da:	01 c2                	add    %eax,%edx
801007dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
801007df:	8b 45 0c             	mov    0xc(%ebp),%eax
801007e2:	01 c8                	add    %ecx,%eax
801007e4:	8a 00                	mov    (%eax),%al
801007e6:	88 02                	mov    %al,(%edx)

void copy_buf(char *dst, char *src, int len)
{
  int i;

  for (i = 0; i < len; i++) {
801007e8:	ff 45 fc             	incl   -0x4(%ebp)
801007eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801007ee:	3b 45 10             	cmp    0x10(%ebp),%eax
801007f1:	7c e1                	jl     801007d4 <copy_buf+0xf>
    dst[i] = src[i];
  }
}
801007f3:	c9                   	leave  
801007f4:	c3                   	ret    

801007f5 <consoleintr>:

void
consoleintr(int (*getc)(void))
{
801007f5:	55                   	push   %ebp
801007f6:	89 e5                	mov    %esp,%ebp
801007f8:	57                   	push   %edi
801007f9:	56                   	push   %esi
801007fa:	53                   	push   %ebx
801007fb:	83 ec 2c             	sub    $0x2c,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
801007fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100805:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  acquire(&cons.lock);
8010080c:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100813:	e8 13 46 00 00       	call   80104e2b <acquire>
  while((c = getc()) >= 0){
80100818:	e9 ce 01 00 00       	jmp    801009eb <consoleintr+0x1f6>
    switch(c){
8010081d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100820:	83 f8 14             	cmp    $0x14,%eax
80100823:	74 3b                	je     80100860 <consoleintr+0x6b>
80100825:	83 f8 14             	cmp    $0x14,%eax
80100828:	7f 13                	jg     8010083d <consoleintr+0x48>
8010082a:	83 f8 08             	cmp    $0x8,%eax
8010082d:	0f 84 f9 00 00 00    	je     8010092c <consoleintr+0x137>
80100833:	83 f8 10             	cmp    $0x10,%eax
80100836:	74 1c                	je     80100854 <consoleintr+0x5f>
80100838:	e9 1f 01 00 00       	jmp    8010095c <consoleintr+0x167>
8010083d:	83 f8 15             	cmp    $0x15,%eax
80100840:	0f 84 be 00 00 00    	je     80100904 <consoleintr+0x10f>
80100846:	83 f8 7f             	cmp    $0x7f,%eax
80100849:	0f 84 dd 00 00 00    	je     8010092c <consoleintr+0x137>
8010084f:	e9 08 01 00 00       	jmp    8010095c <consoleintr+0x167>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100854:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
8010085b:	e9 8b 01 00 00       	jmp    801009eb <consoleintr+0x1f6>
    case C('T'):  // Process listing.
      inputs[active] = input;
80100860:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
80100866:	89 d0                	mov    %edx,%eax
80100868:	c1 e0 02             	shl    $0x2,%eax
8010086b:	01 d0                	add    %edx,%eax
8010086d:	c1 e0 02             	shl    $0x2,%eax
80100870:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100877:	29 c2                	sub    %eax,%edx
80100879:	8d 82 40 10 11 80    	lea    -0x7feeefc0(%edx),%eax
8010087f:	89 c2                	mov    %eax,%edx
80100881:	bb a0 0f 11 80       	mov    $0x80110fa0,%ebx
80100886:	b8 23 00 00 00       	mov    $0x23,%eax
8010088b:	89 d7                	mov    %edx,%edi
8010088d:	89 de                	mov    %ebx,%esi
8010088f:	89 c1                	mov    %eax,%ecx
80100891:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      active = (active+1) % NUM_VCS;
80100893:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80100898:	40                   	inc    %eax
80100899:	25 03 00 00 80       	and    $0x80000003,%eax
8010089e:	85 c0                	test   %eax,%eax
801008a0:	79 05                	jns    801008a7 <consoleintr+0xb2>
801008a2:	48                   	dec    %eax
801008a3:	83 c8 fc             	or     $0xfffffffc,%eax
801008a6:	40                   	inc    %eax
801008a7:	a3 84 b5 10 80       	mov    %eax,0x8010b584
      input = inputs[active];
801008ac:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
801008b2:	89 d0                	mov    %edx,%eax
801008b4:	c1 e0 02             	shl    $0x2,%eax
801008b7:	01 d0                	add    %edx,%eax
801008b9:	c1 e0 02             	shl    $0x2,%eax
801008bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008c3:	29 c2                	sub    %eax,%edx
801008c5:	8d 82 40 10 11 80    	lea    -0x7feeefc0(%edx),%eax
801008cb:	ba a0 0f 11 80       	mov    $0x80110fa0,%edx
801008d0:	89 c3                	mov    %eax,%ebx
801008d2:	b8 23 00 00 00       	mov    $0x23,%eax
801008d7:	89 d7                	mov    %edx,%edi
801008d9:	89 de                	mov    %ebx,%esi
801008db:	89 c1                	mov    %eax,%ecx
801008dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      doconsoleswitch = 1;
801008df:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      break;
801008e6:	e9 00 01 00 00       	jmp    801009eb <consoleintr+0x1f6>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008eb:	a1 28 10 11 80       	mov    0x80111028,%eax
801008f0:	48                   	dec    %eax
801008f1:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801008f6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008fd:	e8 66 fe ff ff       	call   80100768 <consputc>
80100902:	eb 01                	jmp    80100905 <consoleintr+0x110>
      active = (active+1) % NUM_VCS;
      input = inputs[active];
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100904:	90                   	nop
80100905:	8b 15 28 10 11 80    	mov    0x80111028,%edx
8010090b:	a1 24 10 11 80       	mov    0x80111024,%eax
80100910:	39 c2                	cmp    %eax,%edx
80100912:	74 13                	je     80100927 <consoleintr+0x132>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100914:	a1 28 10 11 80       	mov    0x80111028,%eax
80100919:	48                   	dec    %eax
8010091a:	83 e0 7f             	and    $0x7f,%eax
8010091d:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
      active = (active+1) % NUM_VCS;
      input = inputs[active];
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100923:	3c 0a                	cmp    $0xa,%al
80100925:	75 c4                	jne    801008eb <consoleintr+0xf6>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100927:	e9 bf 00 00 00       	jmp    801009eb <consoleintr+0x1f6>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010092c:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100932:	a1 24 10 11 80       	mov    0x80111024,%eax
80100937:	39 c2                	cmp    %eax,%edx
80100939:	74 1c                	je     80100957 <consoleintr+0x162>
        input.e--;
8010093b:	a1 28 10 11 80       	mov    0x80111028,%eax
80100940:	48                   	dec    %eax
80100941:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100946:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010094d:	e8 16 fe ff ff       	call   80100768 <consputc>
      }
      break;
80100952:	e9 94 00 00 00       	jmp    801009eb <consoleintr+0x1f6>
80100957:	e9 8f 00 00 00       	jmp    801009eb <consoleintr+0x1f6>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100960:	0f 84 84 00 00 00    	je     801009ea <consoleintr+0x1f5>
80100966:	8b 15 28 10 11 80    	mov    0x80111028,%edx
8010096c:	a1 20 10 11 80       	mov    0x80111020,%eax
80100971:	29 c2                	sub    %eax,%edx
80100973:	89 d0                	mov    %edx,%eax
80100975:	83 f8 7f             	cmp    $0x7f,%eax
80100978:	77 70                	ja     801009ea <consoleintr+0x1f5>
        c = (c == '\r') ? '\n' : c;
8010097a:	83 7d dc 0d          	cmpl   $0xd,-0x24(%ebp)
8010097e:	74 05                	je     80100985 <consoleintr+0x190>
80100980:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100983:	eb 05                	jmp    8010098a <consoleintr+0x195>
80100985:	b8 0a 00 00 00       	mov    $0xa,%eax
8010098a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010098d:	a1 28 10 11 80       	mov    0x80111028,%eax
80100992:	8d 50 01             	lea    0x1(%eax),%edx
80100995:	89 15 28 10 11 80    	mov    %edx,0x80111028
8010099b:	83 e0 7f             	and    $0x7f,%eax
8010099e:	89 c2                	mov    %eax,%edx
801009a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801009a3:	88 82 a0 0f 11 80    	mov    %al,-0x7feef060(%edx)
        consputc(c);
801009a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801009ac:	89 04 24             	mov    %eax,(%esp)
801009af:	e8 b4 fd ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009b4:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
801009b8:	74 18                	je     801009d2 <consoleintr+0x1dd>
801009ba:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
801009be:	74 12                	je     801009d2 <consoleintr+0x1dd>
801009c0:	a1 28 10 11 80       	mov    0x80111028,%eax
801009c5:	8b 15 20 10 11 80    	mov    0x80111020,%edx
801009cb:	83 ea 80             	sub    $0xffffff80,%edx
801009ce:	39 d0                	cmp    %edx,%eax
801009d0:	75 18                	jne    801009ea <consoleintr+0x1f5>
          input.w = input.e;
801009d2:	a1 28 10 11 80       	mov    0x80111028,%eax
801009d7:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
801009dc:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
801009e3:	e8 48 41 00 00       	call   80104b30 <wakeup>
        }
      }
      break;
801009e8:	eb 00                	jmp    801009ea <consoleintr+0x1f5>
801009ea:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009eb:	8b 45 08             	mov    0x8(%ebp),%eax
801009ee:	ff d0                	call   *%eax
801009f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
801009f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801009f7:	0f 89 20 fe ff ff    	jns    8010081d <consoleintr+0x28>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009fd:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a04:	e8 8c 44 00 00       	call   80104e95 <release>
  if(doprocdump){
80100a09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a0d:	74 05                	je     80100a14 <consoleintr+0x21f>
    procdump();  // now call procdump() wo. cons.lock held
80100a0f:	e8 bf 41 00 00       	call   80104bd3 <procdump>
  }
  if(doconsoleswitch){
80100a14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100a18:	74 15                	je     80100a2f <consoleintr+0x23a>
    cprintf("\nActive console now: %d\n", active);
80100a1a:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80100a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a23:	c7 04 24 4e 82 10 80 	movl   $0x8010824e,(%esp)
80100a2a:	e8 92 f9 ff ff       	call   801003c1 <cprintf>
  }
}
80100a2f:	83 c4 2c             	add    $0x2c,%esp
80100a32:	5b                   	pop    %ebx
80100a33:	5e                   	pop    %esi
80100a34:	5f                   	pop    %edi
80100a35:	5d                   	pop    %ebp
80100a36:	c3                   	ret    

80100a37 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a37:	55                   	push   %ebp
80100a38:	89 e5                	mov    %esp,%ebp
80100a3a:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a40:	89 04 24             	mov    %eax,(%esp)
80100a43:	e8 ec 10 00 00       	call   80101b34 <iunlock>
  target = n;
80100a48:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4e:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a55:	e8 d1 43 00 00       	call   80104e2b <acquire>
  while(n > 0){
80100a5a:	e9 b8 00 00 00       	jmp    80100b17 <consoleread+0xe0>
    while((input.r == input.w) || (active != ip->minor-1)){
80100a5f:	eb 41                	jmp    80100aa2 <consoleread+0x6b>
      if(myproc()->killed){
80100a61:	e8 b5 37 00 00       	call   8010421b <myproc>
80100a66:	8b 40 24             	mov    0x24(%eax),%eax
80100a69:	85 c0                	test   %eax,%eax
80100a6b:	74 21                	je     80100a8e <consoleread+0x57>
        release(&cons.lock);
80100a6d:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a74:	e8 1c 44 00 00       	call   80104e95 <release>
        ilock(ip);
80100a79:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7c:	89 04 24             	mov    %eax,(%esp)
80100a7f:	e8 a6 0f 00 00       	call   80101a2a <ilock>
        return -1;
80100a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a89:	e9 b4 00 00 00       	jmp    80100b42 <consoleread+0x10b>
      }
      sleep(&input.r, &cons.lock);
80100a8e:	c7 44 24 04 a0 b5 10 	movl   $0x8010b5a0,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
80100a9d:	e8 ba 3f 00 00       	call   80104a5c <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while((input.r == input.w) || (active != ip->minor-1)){
80100aa2:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100aa8:	a1 24 10 11 80       	mov    0x80111024,%eax
80100aad:	39 c2                	cmp    %eax,%edx
80100aaf:	74 b0                	je     80100a61 <consoleread+0x2a>
80100ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80100ab4:	8b 40 54             	mov    0x54(%eax),%eax
80100ab7:	98                   	cwtl   
80100ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
80100abb:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80100ac0:	39 c2                	cmp    %eax,%edx
80100ac2:	75 9d                	jne    80100a61 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac4:	a1 20 10 11 80       	mov    0x80111020,%eax
80100ac9:	8d 50 01             	lea    0x1(%eax),%edx
80100acc:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100ad2:	83 e0 7f             	and    $0x7f,%eax
80100ad5:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
80100adb:	0f be c0             	movsbl %al,%eax
80100ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ae1:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ae5:	75 17                	jne    80100afe <consoleread+0xc7>
      if(n < target){
80100ae7:	8b 45 10             	mov    0x10(%ebp),%eax
80100aea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aed:	73 0d                	jae    80100afc <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aef:	a1 20 10 11 80       	mov    0x80111020,%eax
80100af4:	48                   	dec    %eax
80100af5:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100afa:	eb 25                	jmp    80100b21 <consoleread+0xea>
80100afc:	eb 23                	jmp    80100b21 <consoleread+0xea>
    }
    *dst++ = c;
80100afe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b01:	8d 50 01             	lea    0x1(%eax),%edx
80100b04:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b07:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b0a:	88 10                	mov    %dl,(%eax)
    --n;
80100b0c:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100b0f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b13:	75 02                	jne    80100b17 <consoleread+0xe0>
      break;
80100b15:	eb 0a                	jmp    80100b21 <consoleread+0xea>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b1b:	0f 8f 3e ff ff ff    	jg     80100a5f <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100b21:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b28:	e8 68 43 00 00       	call   80104e95 <release>
  ilock(ip);
80100b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80100b30:	89 04 24             	mov    %eax,(%esp)
80100b33:	e8 f2 0e 00 00       	call   80101a2a <ilock>

  return target - n;
80100b38:	8b 45 10             	mov    0x10(%ebp),%eax
80100b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b3e:	29 c2                	sub    %eax,%edx
80100b40:	89 d0                	mov    %edx,%eax
}
80100b42:	c9                   	leave  
80100b43:	c3                   	ret    

80100b44 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b44:	55                   	push   %ebp
80100b45:	89 e5                	mov    %esp,%ebp
80100b47:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor-1){
80100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80100b4d:	8b 40 54             	mov    0x54(%eax),%eax
80100b50:	98                   	cwtl   
80100b51:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b54:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80100b59:	39 c2                	cmp    %eax,%edx
80100b5b:	75 5a                	jne    80100bb7 <consolewrite+0x73>
    iunlock(ip);
80100b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80100b60:	89 04 24             	mov    %eax,(%esp)
80100b63:	e8 cc 0f 00 00       	call   80101b34 <iunlock>
    acquire(&cons.lock);
80100b68:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b6f:	e8 b7 42 00 00       	call   80104e2b <acquire>
    for(i = 0; i < n; i++)
80100b74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b7b:	eb 1b                	jmp    80100b98 <consolewrite+0x54>
      consputc(buf[i] & 0xff);
80100b7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b80:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b83:	01 d0                	add    %edx,%eax
80100b85:	8a 00                	mov    (%eax),%al
80100b87:	0f be c0             	movsbl %al,%eax
80100b8a:	0f b6 c0             	movzbl %al,%eax
80100b8d:	89 04 24             	mov    %eax,(%esp)
80100b90:	e8 d3 fb ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor-1){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100b95:	ff 45 f4             	incl   -0xc(%ebp)
80100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b9b:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9e:	7c dd                	jl     80100b7d <consolewrite+0x39>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100ba0:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100ba7:	e8 e9 42 00 00       	call   80104e95 <release>
    ilock(ip);
80100bac:	8b 45 08             	mov    0x8(%ebp),%eax
80100baf:	89 04 24             	mov    %eax,(%esp)
80100bb2:	e8 73 0e 00 00       	call   80101a2a <ilock>
  }
  return n;
80100bb7:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bba:	c9                   	leave  
80100bbb:	c3                   	ret    

80100bbc <consoleinit>:

void
consoleinit(void)
{
80100bbc:	55                   	push   %ebp
80100bbd:	89 e5                	mov    %esp,%ebp
80100bbf:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100bc2:	c7 44 24 04 67 82 10 	movl   $0x80108267,0x4(%esp)
80100bc9:	80 
80100bca:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100bd1:	e8 34 42 00 00       	call   80104e0a <initlock>

  devsw[CONSOLE].write = consolewrite;
80100bd6:	c7 05 2c 1c 11 80 44 	movl   $0x80100b44,0x80111c2c
80100bdd:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be0:	c7 05 28 1c 11 80 37 	movl   $0x80100a37,0x80111c28
80100be7:	0a 10 80 
  cons.locking = 1;
80100bea:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100bf1:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100bf4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100bfb:	00 
80100bfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100c03:	e8 e7 1e 00 00       	call   80102aef <ioapicenable>
}
80100c08:	c9                   	leave  
80100c09:	c3                   	ret    
	...

80100c0c <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c0c:	55                   	push   %ebp
80100c0d:	89 e5                	mov    %esp,%ebp
80100c0f:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c15:	e8 01 36 00 00       	call   8010421b <myproc>
80100c1a:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100c1d:	e8 01 29 00 00       	call   80103523 <begin_op>

  if((ip = namei(path)) == 0){
80100c22:	8b 45 08             	mov    0x8(%ebp),%eax
80100c25:	89 04 24             	mov    %eax,(%esp)
80100c28:	e8 22 19 00 00       	call   8010254f <namei>
80100c2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c30:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c34:	75 1b                	jne    80100c51 <exec+0x45>
    end_op();
80100c36:	e8 6a 29 00 00       	call   801035a5 <end_op>
    cprintf("exec: fail\n");
80100c3b:	c7 04 24 6f 82 10 80 	movl   $0x8010826f,(%esp)
80100c42:	e8 7a f7 ff ff       	call   801003c1 <cprintf>
    return -1;
80100c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4c:	e9 f6 03 00 00       	jmp    80101047 <exec+0x43b>
  }
  ilock(ip);
80100c51:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c54:	89 04 24             	mov    %eax,(%esp)
80100c57:	e8 ce 0d 00 00       	call   80101a2a <ilock>
  pgdir = 0;
80100c5c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c63:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100c6a:	00 
80100c6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100c72:	00 
80100c73:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c80:	89 04 24             	mov    %eax,(%esp)
80100c83:	e8 39 12 00 00       	call   80101ec1 <readi>
80100c88:	83 f8 34             	cmp    $0x34,%eax
80100c8b:	74 05                	je     80100c92 <exec+0x86>
    goto bad;
80100c8d:	e9 89 03 00 00       	jmp    8010101b <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100c92:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c98:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c9d:	74 05                	je     80100ca4 <exec+0x98>
    goto bad;
80100c9f:	e9 77 03 00 00       	jmp    8010101b <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100ca4:	e8 9d 6c 00 00       	call   80107946 <setupkvm>
80100ca9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100cac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cb0:	75 05                	jne    80100cb7 <exec+0xab>
    goto bad;
80100cb2:	e9 64 03 00 00       	jmp    8010101b <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100cb7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cbe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cc5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100ccb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cce:	e9 fb 00 00 00       	jmp    80100dce <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cd6:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100cdd:	00 
80100cde:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ce2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cec:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cef:	89 04 24             	mov    %eax,(%esp)
80100cf2:	e8 ca 11 00 00       	call   80101ec1 <readi>
80100cf7:	83 f8 20             	cmp    $0x20,%eax
80100cfa:	74 05                	je     80100d01 <exec+0xf5>
      goto bad;
80100cfc:	e9 1a 03 00 00       	jmp    8010101b <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100d01:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d07:	83 f8 01             	cmp    $0x1,%eax
80100d0a:	74 05                	je     80100d11 <exec+0x105>
      continue;
80100d0c:	e9 b1 00 00 00       	jmp    80100dc2 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100d11:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d17:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d1d:	39 c2                	cmp    %eax,%edx
80100d1f:	73 05                	jae    80100d26 <exec+0x11a>
      goto bad;
80100d21:	e9 f5 02 00 00       	jmp    8010101b <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d26:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d2c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d32:	01 c2                	add    %eax,%edx
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d3a:	39 c2                	cmp    %eax,%edx
80100d3c:	73 05                	jae    80100d43 <exec+0x137>
      goto bad;
80100d3e:	e9 d8 02 00 00       	jmp    8010101b <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d43:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d49:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d4f:	01 d0                	add    %edx,%eax
80100d51:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d58:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d5f:	89 04 24             	mov    %eax,(%esp)
80100d62:	e8 ab 6f 00 00       	call   80107d12 <allocuvm>
80100d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d6e:	75 05                	jne    80100d75 <exec+0x169>
      goto bad;
80100d70:	e9 a6 02 00 00       	jmp    8010101b <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100d75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d7b:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d80:	85 c0                	test   %eax,%eax
80100d82:	74 05                	je     80100d89 <exec+0x17d>
      goto bad;
80100d84:	e9 92 02 00 00       	jmp    8010101b <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d89:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100d8f:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d95:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d9b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100d9f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100da3:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100da6:	89 54 24 08          	mov    %edx,0x8(%esp)
80100daa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100db1:	89 04 24             	mov    %eax,(%esp)
80100db4:	e8 76 6e 00 00       	call   80107c2f <loaduvm>
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	79 05                	jns    80100dc2 <exec+0x1b6>
      goto bad;
80100dbd:	e9 59 02 00 00       	jmp    8010101b <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc2:	ff 45 ec             	incl   -0x14(%ebp)
80100dc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dc8:	83 c0 20             	add    $0x20,%eax
80100dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dce:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100dd4:	0f b7 c0             	movzwl %ax,%eax
80100dd7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dda:	0f 8f f3 fe ff ff    	jg     80100cd3 <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100de0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100de3:	89 04 24             	mov    %eax,(%esp)
80100de6:	e8 3e 0e 00 00       	call   80101c29 <iunlockput>
  end_op();
80100deb:	e8 b5 27 00 00       	call   801035a5 <end_op>
  ip = 0;
80100df0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dfa:	05 ff 0f 00 00       	add    $0xfff,%eax
80100dff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e0a:	05 00 20 00 00       	add    $0x2000,%eax
80100e0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e1d:	89 04 24             	mov    %eax,(%esp)
80100e20:	e8 ed 6e 00 00       	call   80107d12 <allocuvm>
80100e25:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e2c:	75 05                	jne    80100e33 <exec+0x227>
    goto bad;
80100e2e:	e9 e8 01 00 00       	jmp    8010101b <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e36:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e42:	89 04 24             	mov    %eax,(%esp)
80100e45:	e8 38 71 00 00       	call   80107f82 <clearpteu>
  sp = sz;
80100e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e4d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e57:	e9 95 00 00 00       	jmp    80100ef1 <exec+0x2e5>
    if(argc >= MAXARG)
80100e5c:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e60:	76 05                	jbe    80100e67 <exec+0x25b>
      goto bad;
80100e62:	e9 b4 01 00 00       	jmp    8010101b <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e74:	01 d0                	add    %edx,%eax
80100e76:	8b 00                	mov    (%eax),%eax
80100e78:	89 04 24             	mov    %eax,(%esp)
80100e7b:	e8 61 44 00 00       	call   801052e1 <strlen>
80100e80:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e83:	29 c2                	sub    %eax,%edx
80100e85:	89 d0                	mov    %edx,%eax
80100e87:	48                   	dec    %eax
80100e88:	83 e0 fc             	and    $0xfffffffc,%eax
80100e8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e9b:	01 d0                	add    %edx,%eax
80100e9d:	8b 00                	mov    (%eax),%eax
80100e9f:	89 04 24             	mov    %eax,(%esp)
80100ea2:	e8 3a 44 00 00       	call   801052e1 <strlen>
80100ea7:	40                   	inc    %eax
80100ea8:	89 c2                	mov    %eax,%edx
80100eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ead:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb7:	01 c8                	add    %ecx,%eax
80100eb9:	8b 00                	mov    (%eax),%eax
80100ebb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100ebf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100eca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 65 72 00 00       	call   8010813a <copyout>
80100ed5:	85 c0                	test   %eax,%eax
80100ed7:	79 05                	jns    80100ede <exec+0x2d2>
      goto bad;
80100ed9:	e9 3d 01 00 00       	jmp    8010101b <exec+0x40f>
    ustack[3+argc] = sp;
80100ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee1:	8d 50 03             	lea    0x3(%eax),%edx
80100ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee7:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100eee:	ff 45 e4             	incl   -0x1c(%ebp)
80100ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100efb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efe:	01 d0                	add    %edx,%eax
80100f00:	8b 00                	mov    (%eax),%eax
80100f02:	85 c0                	test   %eax,%eax
80100f04:	0f 85 52 ff ff ff    	jne    80100e5c <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f0d:	83 c0 03             	add    $0x3,%eax
80100f10:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f17:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f1b:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f22:	ff ff ff 
  ustack[1] = argc;
80100f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f28:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f31:	40                   	inc    %eax
80100f32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f3c:	29 d0                	sub    %edx,%eax
80100f3e:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f47:	83 c0 04             	add    $0x4,%eax
80100f4a:	c1 e0 02             	shl    $0x2,%eax
80100f4d:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f53:	83 c0 04             	add    $0x4,%eax
80100f56:	c1 e0 02             	shl    $0x2,%eax
80100f59:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100f5d:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 c1 71 00 00       	call   8010813a <copyout>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	79 05                	jns    80100f82 <exec+0x376>
    goto bad;
80100f7d:	e9 99 00 00 00       	jmp    8010101b <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f82:	8b 45 08             	mov    0x8(%ebp),%eax
80100f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f8e:	eb 13                	jmp    80100fa3 <exec+0x397>
    if(*s == '/')
80100f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f93:	8a 00                	mov    (%eax),%al
80100f95:	3c 2f                	cmp    $0x2f,%al
80100f97:	75 07                	jne    80100fa0 <exec+0x394>
      last = s+1;
80100f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9c:	40                   	inc    %eax
80100f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fa0:	ff 45 f4             	incl   -0xc(%ebp)
80100fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa6:	8a 00                	mov    (%eax),%al
80100fa8:	84 c0                	test   %al,%al
80100faa:	75 e4                	jne    80100f90 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fac:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100faf:	8d 50 6c             	lea    0x6c(%eax),%edx
80100fb2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100fb9:	00 
80100fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100fc1:	89 14 24             	mov    %edx,(%esp)
80100fc4:	e8 d1 42 00 00       	call   8010529a <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100fc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fcc:	8b 40 04             	mov    0x4(%eax),%eax
80100fcf:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fd8:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100fdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fde:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fe1:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fe3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fe6:	8b 40 18             	mov    0x18(%eax),%eax
80100fe9:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100fef:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ff5:	8b 40 18             	mov    0x18(%eax),%eax
80100ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ffb:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ffe:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101001:	89 04 24             	mov    %eax,(%esp)
80101004:	e8 17 6a 00 00       	call   80107a20 <switchuvm>
  freevm(oldpgdir);
80101009:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010100c:	89 04 24             	mov    %eax,(%esp)
8010100f:	e8 d8 6e 00 00       	call   80107eec <freevm>
  return 0;
80101014:	b8 00 00 00 00       	mov    $0x0,%eax
80101019:	eb 2c                	jmp    80101047 <exec+0x43b>

 bad:
  if(pgdir)
8010101b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010101f:	74 0b                	je     8010102c <exec+0x420>
    freevm(pgdir);
80101021:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101024:	89 04 24             	mov    %eax,(%esp)
80101027:	e8 c0 6e 00 00       	call   80107eec <freevm>
  if(ip){
8010102c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101030:	74 10                	je     80101042 <exec+0x436>
    iunlockput(ip);
80101032:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101035:	89 04 24             	mov    %eax,(%esp)
80101038:	e8 ec 0b 00 00       	call   80101c29 <iunlockput>
    end_op();
8010103d:	e8 63 25 00 00       	call   801035a5 <end_op>
  }
  return -1;
80101042:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101047:	c9                   	leave  
80101048:	c3                   	ret    
80101049:	00 00                	add    %al,(%eax)
	...

8010104c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010104c:	55                   	push   %ebp
8010104d:	89 e5                	mov    %esp,%ebp
8010104f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101052:	c7 44 24 04 7b 82 10 	movl   $0x8010827b,0x4(%esp)
80101059:	80 
8010105a:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
80101061:	e8 a4 3d 00 00       	call   80104e0a <initlock>
}
80101066:	c9                   	leave  
80101067:	c3                   	ret    

80101068 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101068:	55                   	push   %ebp
80101069:	89 e5                	mov    %esp,%ebp
8010106b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
8010106e:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
80101075:	e8 b1 3d 00 00       	call   80104e2b <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010107a:	c7 45 f4 b4 12 11 80 	movl   $0x801112b4,-0xc(%ebp)
80101081:	eb 29                	jmp    801010ac <filealloc+0x44>
    if(f->ref == 0){
80101083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101086:	8b 40 04             	mov    0x4(%eax),%eax
80101089:	85 c0                	test   %eax,%eax
8010108b:	75 1b                	jne    801010a8 <filealloc+0x40>
      f->ref = 1;
8010108d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101090:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101097:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
8010109e:	e8 f2 3d 00 00       	call   80104e95 <release>
      return f;
801010a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010a6:	eb 1e                	jmp    801010c6 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010a8:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801010ac:	81 7d f4 14 1c 11 80 	cmpl   $0x80111c14,-0xc(%ebp)
801010b3:	72 ce                	jb     80101083 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801010b5:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
801010bc:	e8 d4 3d 00 00       	call   80104e95 <release>
  return 0;
801010c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010c6:	c9                   	leave  
801010c7:	c3                   	ret    

801010c8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010c8:	55                   	push   %ebp
801010c9:	89 e5                	mov    %esp,%ebp
801010cb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801010ce:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
801010d5:	e8 51 3d 00 00       	call   80104e2b <acquire>
  if(f->ref < 1)
801010da:	8b 45 08             	mov    0x8(%ebp),%eax
801010dd:	8b 40 04             	mov    0x4(%eax),%eax
801010e0:	85 c0                	test   %eax,%eax
801010e2:	7f 0c                	jg     801010f0 <filedup+0x28>
    panic("filedup");
801010e4:	c7 04 24 82 82 10 80 	movl   $0x80108282,(%esp)
801010eb:	e8 64 f4 ff ff       	call   80100554 <panic>
  f->ref++;
801010f0:	8b 45 08             	mov    0x8(%ebp),%eax
801010f3:	8b 40 04             	mov    0x4(%eax),%eax
801010f6:	8d 50 01             	lea    0x1(%eax),%edx
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
801010fc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010ff:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
80101106:	e8 8a 3d 00 00       	call   80104e95 <release>
  return f;
8010110b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010110e:	c9                   	leave  
8010110f:	c3                   	ret    

80101110 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101119:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
80101120:	e8 06 3d 00 00       	call   80104e2b <acquire>
  if(f->ref < 1)
80101125:	8b 45 08             	mov    0x8(%ebp),%eax
80101128:	8b 40 04             	mov    0x4(%eax),%eax
8010112b:	85 c0                	test   %eax,%eax
8010112d:	7f 0c                	jg     8010113b <fileclose+0x2b>
    panic("fileclose");
8010112f:	c7 04 24 8a 82 10 80 	movl   $0x8010828a,(%esp)
80101136:	e8 19 f4 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
8010113b:	8b 45 08             	mov    0x8(%ebp),%eax
8010113e:	8b 40 04             	mov    0x4(%eax),%eax
80101141:	8d 50 ff             	lea    -0x1(%eax),%edx
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	89 50 04             	mov    %edx,0x4(%eax)
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 40 04             	mov    0x4(%eax),%eax
80101150:	85 c0                	test   %eax,%eax
80101152:	7e 0e                	jle    80101162 <fileclose+0x52>
    release(&ftable.lock);
80101154:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
8010115b:	e8 35 3d 00 00       	call   80104e95 <release>
80101160:	eb 70                	jmp    801011d2 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101162:	8b 45 08             	mov    0x8(%ebp),%eax
80101165:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101168:	89 c3                	mov    %eax,%ebx
8010116a:	b8 06 00 00 00       	mov    $0x6,%eax
8010116f:	89 d7                	mov    %edx,%edi
80101171:	89 de                	mov    %ebx,%esi
80101173:	89 c1                	mov    %eax,%ecx
80101175:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101181:	8b 45 08             	mov    0x8(%ebp),%eax
80101184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010118a:	c7 04 24 80 12 11 80 	movl   $0x80111280,(%esp)
80101191:	e8 ff 3c 00 00       	call   80104e95 <release>

  if(ff.type == FD_PIPE)
80101196:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101199:	83 f8 01             	cmp    $0x1,%eax
8010119c:	75 17                	jne    801011b5 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
8010119e:	8a 45 d9             	mov    -0x27(%ebp),%al
801011a1:	0f be d0             	movsbl %al,%edx
801011a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801011ab:	89 04 24             	mov    %eax,(%esp)
801011ae:	e8 00 2d 00 00       	call   80103eb3 <pipeclose>
801011b3:	eb 1d                	jmp    801011d2 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
801011b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
801011b8:	83 f8 02             	cmp    $0x2,%eax
801011bb:	75 15                	jne    801011d2 <fileclose+0xc2>
    begin_op();
801011bd:	e8 61 23 00 00       	call   80103523 <begin_op>
    iput(ff.ip);
801011c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c5:	89 04 24             	mov    %eax,(%esp)
801011c8:	e8 ab 09 00 00       	call   80101b78 <iput>
    end_op();
801011cd:	e8 d3 23 00 00       	call   801035a5 <end_op>
  }
}
801011d2:	83 c4 3c             	add    $0x3c,%esp
801011d5:	5b                   	pop    %ebx
801011d6:	5e                   	pop    %esi
801011d7:	5f                   	pop    %edi
801011d8:	5d                   	pop    %ebp
801011d9:	c3                   	ret    

801011da <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011da:	55                   	push   %ebp
801011db:	89 e5                	mov    %esp,%ebp
801011dd:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801011e0:	8b 45 08             	mov    0x8(%ebp),%eax
801011e3:	8b 00                	mov    (%eax),%eax
801011e5:	83 f8 02             	cmp    $0x2,%eax
801011e8:	75 38                	jne    80101222 <filestat+0x48>
    ilock(f->ip);
801011ea:	8b 45 08             	mov    0x8(%ebp),%eax
801011ed:	8b 40 10             	mov    0x10(%eax),%eax
801011f0:	89 04 24             	mov    %eax,(%esp)
801011f3:	e8 32 08 00 00       	call   80101a2a <ilock>
    stati(f->ip, st);
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 40 10             	mov    0x10(%eax),%eax
801011fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80101201:	89 54 24 04          	mov    %edx,0x4(%esp)
80101205:	89 04 24             	mov    %eax,(%esp)
80101208:	e8 70 0c 00 00       	call   80101e7d <stati>
    iunlock(f->ip);
8010120d:	8b 45 08             	mov    0x8(%ebp),%eax
80101210:	8b 40 10             	mov    0x10(%eax),%eax
80101213:	89 04 24             	mov    %eax,(%esp)
80101216:	e8 19 09 00 00       	call   80101b34 <iunlock>
    return 0;
8010121b:	b8 00 00 00 00       	mov    $0x0,%eax
80101220:	eb 05                	jmp    80101227 <filestat+0x4d>
  }
  return -1;
80101222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101227:	c9                   	leave  
80101228:	c3                   	ret    

80101229 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101229:	55                   	push   %ebp
8010122a:	89 e5                	mov    %esp,%ebp
8010122c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8a 40 08             	mov    0x8(%eax),%al
80101235:	84 c0                	test   %al,%al
80101237:	75 0a                	jne    80101243 <fileread+0x1a>
    return -1;
80101239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123e:	e9 9f 00 00 00       	jmp    801012e2 <fileread+0xb9>
  if(f->type == FD_PIPE)
80101243:	8b 45 08             	mov    0x8(%ebp),%eax
80101246:	8b 00                	mov    (%eax),%eax
80101248:	83 f8 01             	cmp    $0x1,%eax
8010124b:	75 1e                	jne    8010126b <fileread+0x42>
    return piperead(f->pipe, addr, n);
8010124d:	8b 45 08             	mov    0x8(%ebp),%eax
80101250:	8b 40 0c             	mov    0xc(%eax),%eax
80101253:	8b 55 10             	mov    0x10(%ebp),%edx
80101256:	89 54 24 08          	mov    %edx,0x8(%esp)
8010125a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010125d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101261:	89 04 24             	mov    %eax,(%esp)
80101264:	e8 c8 2d 00 00       	call   80104031 <piperead>
80101269:	eb 77                	jmp    801012e2 <fileread+0xb9>
  if(f->type == FD_INODE){
8010126b:	8b 45 08             	mov    0x8(%ebp),%eax
8010126e:	8b 00                	mov    (%eax),%eax
80101270:	83 f8 02             	cmp    $0x2,%eax
80101273:	75 61                	jne    801012d6 <fileread+0xad>
    ilock(f->ip);
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 40 10             	mov    0x10(%eax),%eax
8010127b:	89 04 24             	mov    %eax,(%esp)
8010127e:	e8 a7 07 00 00       	call   80101a2a <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101283:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	8b 50 14             	mov    0x14(%eax),%edx
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 40 10             	mov    0x10(%eax),%eax
80101292:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101296:	89 54 24 08          	mov    %edx,0x8(%esp)
8010129a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010129d:	89 54 24 04          	mov    %edx,0x4(%esp)
801012a1:	89 04 24             	mov    %eax,(%esp)
801012a4:	e8 18 0c 00 00       	call   80101ec1 <readi>
801012a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b0:	7e 11                	jle    801012c3 <fileread+0x9a>
      f->off += r;
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 50 14             	mov    0x14(%eax),%edx
801012b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012bb:	01 c2                	add    %eax,%edx
801012bd:	8b 45 08             	mov    0x8(%ebp),%eax
801012c0:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c3:	8b 45 08             	mov    0x8(%ebp),%eax
801012c6:	8b 40 10             	mov    0x10(%eax),%eax
801012c9:	89 04 24             	mov    %eax,(%esp)
801012cc:	e8 63 08 00 00       	call   80101b34 <iunlock>
    return r;
801012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d4:	eb 0c                	jmp    801012e2 <fileread+0xb9>
  }
  panic("fileread");
801012d6:	c7 04 24 94 82 10 80 	movl   $0x80108294,(%esp)
801012dd:	e8 72 f2 ff ff       	call   80100554 <panic>
}
801012e2:	c9                   	leave  
801012e3:	c3                   	ret    

801012e4 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012e4:	55                   	push   %ebp
801012e5:	89 e5                	mov    %esp,%ebp
801012e7:	53                   	push   %ebx
801012e8:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8a 40 09             	mov    0x9(%eax),%al
801012f1:	84 c0                	test   %al,%al
801012f3:	75 0a                	jne    801012ff <filewrite+0x1b>
    return -1;
801012f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012fa:	e9 20 01 00 00       	jmp    8010141f <filewrite+0x13b>
  if(f->type == FD_PIPE)
801012ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101302:	8b 00                	mov    (%eax),%eax
80101304:	83 f8 01             	cmp    $0x1,%eax
80101307:	75 21                	jne    8010132a <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101309:	8b 45 08             	mov    0x8(%ebp),%eax
8010130c:	8b 40 0c             	mov    0xc(%eax),%eax
8010130f:	8b 55 10             	mov    0x10(%ebp),%edx
80101312:	89 54 24 08          	mov    %edx,0x8(%esp)
80101316:	8b 55 0c             	mov    0xc(%ebp),%edx
80101319:	89 54 24 04          	mov    %edx,0x4(%esp)
8010131d:	89 04 24             	mov    %eax,(%esp)
80101320:	e8 20 2c 00 00       	call   80103f45 <pipewrite>
80101325:	e9 f5 00 00 00       	jmp    8010141f <filewrite+0x13b>
  if(f->type == FD_INODE){
8010132a:	8b 45 08             	mov    0x8(%ebp),%eax
8010132d:	8b 00                	mov    (%eax),%eax
8010132f:	83 f8 02             	cmp    $0x2,%eax
80101332:	0f 85 db 00 00 00    	jne    80101413 <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101338:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010133f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101346:	e9 a8 00 00 00       	jmp    801013f3 <filewrite+0x10f>
      int n1 = n - i;
8010134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134e:	8b 55 10             	mov    0x10(%ebp),%edx
80101351:	29 c2                	sub    %eax,%edx
80101353:	89 d0                	mov    %edx,%eax
80101355:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010135b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010135e:	7e 06                	jle    80101366 <filewrite+0x82>
        n1 = max;
80101360:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101363:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101366:	e8 b8 21 00 00       	call   80103523 <begin_op>
      ilock(f->ip);
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	8b 40 10             	mov    0x10(%eax),%eax
80101371:	89 04 24             	mov    %eax,(%esp)
80101374:	e8 b1 06 00 00       	call   80101a2a <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101379:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010137c:	8b 45 08             	mov    0x8(%ebp),%eax
8010137f:	8b 50 14             	mov    0x14(%eax),%edx
80101382:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101385:	8b 45 0c             	mov    0xc(%ebp),%eax
80101388:	01 c3                	add    %eax,%ebx
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	8b 40 10             	mov    0x10(%eax),%eax
80101390:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101394:	89 54 24 08          	mov    %edx,0x8(%esp)
80101398:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010139c:	89 04 24             	mov    %eax,(%esp)
8010139f:	e8 81 0c 00 00       	call   80102025 <writei>
801013a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013ab:	7e 11                	jle    801013be <filewrite+0xda>
        f->off += r;
801013ad:	8b 45 08             	mov    0x8(%ebp),%eax
801013b0:	8b 50 14             	mov    0x14(%eax),%edx
801013b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b6:	01 c2                	add    %eax,%edx
801013b8:	8b 45 08             	mov    0x8(%ebp),%eax
801013bb:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013be:	8b 45 08             	mov    0x8(%ebp),%eax
801013c1:	8b 40 10             	mov    0x10(%eax),%eax
801013c4:	89 04 24             	mov    %eax,(%esp)
801013c7:	e8 68 07 00 00       	call   80101b34 <iunlock>
      end_op();
801013cc:	e8 d4 21 00 00       	call   801035a5 <end_op>

      if(r < 0)
801013d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d5:	79 02                	jns    801013d9 <filewrite+0xf5>
        break;
801013d7:	eb 26                	jmp    801013ff <filewrite+0x11b>
      if(r != n1)
801013d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013df:	74 0c                	je     801013ed <filewrite+0x109>
        panic("short filewrite");
801013e1:	c7 04 24 9d 82 10 80 	movl   $0x8010829d,(%esp)
801013e8:	e8 67 f1 ff ff       	call   80100554 <panic>
      i += r;
801013ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f0:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f9:	0f 8c 4c ff ff ff    	jl     8010134b <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101402:	3b 45 10             	cmp    0x10(%ebp),%eax
80101405:	75 05                	jne    8010140c <filewrite+0x128>
80101407:	8b 45 10             	mov    0x10(%ebp),%eax
8010140a:	eb 05                	jmp    80101411 <filewrite+0x12d>
8010140c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101411:	eb 0c                	jmp    8010141f <filewrite+0x13b>
  }
  panic("filewrite");
80101413:	c7 04 24 ad 82 10 80 	movl   $0x801082ad,(%esp)
8010141a:	e8 35 f1 ff ff       	call   80100554 <panic>
}
8010141f:	83 c4 24             	add    $0x24,%esp
80101422:	5b                   	pop    %ebx
80101423:	5d                   	pop    %ebp
80101424:	c3                   	ret    
80101425:	00 00                	add    %al,(%eax)
	...

80101428 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101428:	55                   	push   %ebp
80101429:	89 e5                	mov    %esp,%ebp
8010142b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010142e:	8b 45 08             	mov    0x8(%ebp),%eax
80101431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101438:	00 
80101439:	89 04 24             	mov    %eax,(%esp)
8010143c:	e8 74 ed ff ff       	call   801001b5 <bread>
80101441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101447:	83 c0 5c             	add    $0x5c,%eax
8010144a:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101451:	00 
80101452:	89 44 24 04          	mov    %eax,0x4(%esp)
80101456:	8b 45 0c             	mov    0xc(%ebp),%eax
80101459:	89 04 24             	mov    %eax,(%esp)
8010145c:	e8 f6 3c 00 00       	call   80105157 <memmove>
  brelse(bp);
80101461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101464:	89 04 24             	mov    %eax,(%esp)
80101467:	e8 c0 ed ff ff       	call   8010022c <brelse>
}
8010146c:	c9                   	leave  
8010146d:	c3                   	ret    

8010146e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010146e:	55                   	push   %ebp
8010146f:	89 e5                	mov    %esp,%ebp
80101471:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101474:	8b 55 0c             	mov    0xc(%ebp),%edx
80101477:	8b 45 08             	mov    0x8(%ebp),%eax
8010147a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010147e:	89 04 24             	mov    %eax,(%esp)
80101481:	e8 2f ed ff ff       	call   801001b5 <bread>
80101486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148c:	83 c0 5c             	add    $0x5c,%eax
8010148f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101496:	00 
80101497:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010149e:	00 
8010149f:	89 04 24             	mov    %eax,(%esp)
801014a2:	e8 e7 3b 00 00       	call   8010508e <memset>
  log_write(bp);
801014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014aa:	89 04 24             	mov    %eax,(%esp)
801014ad:	e8 75 22 00 00       	call   80103727 <log_write>
  brelse(bp);
801014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b5:	89 04 24             	mov    %eax,(%esp)
801014b8:	e8 6f ed ff ff       	call   8010022c <brelse>
}
801014bd:	c9                   	leave  
801014be:	c3                   	ret    

801014bf <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014bf:	55                   	push   %ebp
801014c0:	89 e5                	mov    %esp,%ebp
801014c2:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014d3:	e9 03 01 00 00       	jmp    801015db <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
801014d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014db:	85 c0                	test   %eax,%eax
801014dd:	79 05                	jns    801014e4 <balloc+0x25>
801014df:	05 ff 0f 00 00       	add    $0xfff,%eax
801014e4:	c1 f8 0c             	sar    $0xc,%eax
801014e7:	89 c2                	mov    %eax,%edx
801014e9:	a1 98 1c 11 80       	mov    0x80111c98,%eax
801014ee:	01 d0                	add    %edx,%eax
801014f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f4:	8b 45 08             	mov    0x8(%ebp),%eax
801014f7:	89 04 24             	mov    %eax,(%esp)
801014fa:	e8 b6 ec ff ff       	call   801001b5 <bread>
801014ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101509:	e9 9b 00 00 00       	jmp    801015a9 <balloc+0xea>
      m = 1 << (bi % 8);
8010150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101511:	25 07 00 00 80       	and    $0x80000007,%eax
80101516:	85 c0                	test   %eax,%eax
80101518:	79 05                	jns    8010151f <balloc+0x60>
8010151a:	48                   	dec    %eax
8010151b:	83 c8 f8             	or     $0xfffffff8,%eax
8010151e:	40                   	inc    %eax
8010151f:	ba 01 00 00 00       	mov    $0x1,%edx
80101524:	88 c1                	mov    %al,%cl
80101526:	d3 e2                	shl    %cl,%edx
80101528:	89 d0                	mov    %edx,%eax
8010152a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	85 c0                	test   %eax,%eax
80101532:	79 03                	jns    80101537 <balloc+0x78>
80101534:	83 c0 07             	add    $0x7,%eax
80101537:	c1 f8 03             	sar    $0x3,%eax
8010153a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010153d:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101541:	0f b6 c0             	movzbl %al,%eax
80101544:	23 45 e8             	and    -0x18(%ebp),%eax
80101547:	85 c0                	test   %eax,%eax
80101549:	75 5b                	jne    801015a6 <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
8010154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154e:	85 c0                	test   %eax,%eax
80101550:	79 03                	jns    80101555 <balloc+0x96>
80101552:	83 c0 07             	add    $0x7,%eax
80101555:	c1 f8 03             	sar    $0x3,%eax
80101558:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010155b:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
8010155f:	88 d1                	mov    %dl,%cl
80101561:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101564:	09 ca                	or     %ecx,%edx
80101566:	88 d1                	mov    %dl,%cl
80101568:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010156b:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101572:	89 04 24             	mov    %eax,(%esp)
80101575:	e8 ad 21 00 00       	call   80103727 <log_write>
        brelse(bp);
8010157a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010157d:	89 04 24             	mov    %eax,(%esp)
80101580:	e8 a7 ec ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101585:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101588:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158b:	01 c2                	add    %eax,%edx
8010158d:	8b 45 08             	mov    0x8(%ebp),%eax
80101590:	89 54 24 04          	mov    %edx,0x4(%esp)
80101594:	89 04 24             	mov    %eax,(%esp)
80101597:	e8 d2 fe ff ff       	call   8010146e <bzero>
        return b + bi;
8010159c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a2:	01 d0                	add    %edx,%eax
801015a4:	eb 51                	jmp    801015f7 <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015a6:	ff 45 f0             	incl   -0x10(%ebp)
801015a9:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015b0:	7f 17                	jg     801015c9 <balloc+0x10a>
801015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b8:	01 d0                	add    %edx,%eax
801015ba:	89 c2                	mov    %eax,%edx
801015bc:	a1 80 1c 11 80       	mov    0x80111c80,%eax
801015c1:	39 c2                	cmp    %eax,%edx
801015c3:	0f 82 45 ff ff ff    	jb     8010150e <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015cc:	89 04 24             	mov    %eax,(%esp)
801015cf:	e8 58 ec ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015de:	a1 80 1c 11 80       	mov    0x80111c80,%eax
801015e3:	39 c2                	cmp    %eax,%edx
801015e5:	0f 82 ed fe ff ff    	jb     801014d8 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015eb:	c7 04 24 b8 82 10 80 	movl   $0x801082b8,(%esp)
801015f2:	e8 5d ef ff ff       	call   80100554 <panic>
}
801015f7:	c9                   	leave  
801015f8:	c3                   	ret    

801015f9 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015f9:	55                   	push   %ebp
801015fa:	89 e5                	mov    %esp,%ebp
801015fc:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015ff:	c7 44 24 04 80 1c 11 	movl   $0x80111c80,0x4(%esp)
80101606:	80 
80101607:	8b 45 08             	mov    0x8(%ebp),%eax
8010160a:	89 04 24             	mov    %eax,(%esp)
8010160d:	e8 16 fe ff ff       	call   80101428 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101612:	8b 45 0c             	mov    0xc(%ebp),%eax
80101615:	c1 e8 0c             	shr    $0xc,%eax
80101618:	89 c2                	mov    %eax,%edx
8010161a:	a1 98 1c 11 80       	mov    0x80111c98,%eax
8010161f:	01 c2                	add    %eax,%edx
80101621:	8b 45 08             	mov    0x8(%ebp),%eax
80101624:	89 54 24 04          	mov    %edx,0x4(%esp)
80101628:	89 04 24             	mov    %eax,(%esp)
8010162b:	e8 85 eb ff ff       	call   801001b5 <bread>
80101630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101633:	8b 45 0c             	mov    0xc(%ebp),%eax
80101636:	25 ff 0f 00 00       	and    $0xfff,%eax
8010163b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101641:	25 07 00 00 80       	and    $0x80000007,%eax
80101646:	85 c0                	test   %eax,%eax
80101648:	79 05                	jns    8010164f <bfree+0x56>
8010164a:	48                   	dec    %eax
8010164b:	83 c8 f8             	or     $0xfffffff8,%eax
8010164e:	40                   	inc    %eax
8010164f:	ba 01 00 00 00       	mov    $0x1,%edx
80101654:	88 c1                	mov    %al,%cl
80101656:	d3 e2                	shl    %cl,%edx
80101658:	89 d0                	mov    %edx,%eax
8010165a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101660:	85 c0                	test   %eax,%eax
80101662:	79 03                	jns    80101667 <bfree+0x6e>
80101664:	83 c0 07             	add    $0x7,%eax
80101667:	c1 f8 03             	sar    $0x3,%eax
8010166a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166d:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101671:	0f b6 c0             	movzbl %al,%eax
80101674:	23 45 ec             	and    -0x14(%ebp),%eax
80101677:	85 c0                	test   %eax,%eax
80101679:	75 0c                	jne    80101687 <bfree+0x8e>
    panic("freeing free block");
8010167b:	c7 04 24 ce 82 10 80 	movl   $0x801082ce,(%esp)
80101682:	e8 cd ee ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
80101687:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010168a:	85 c0                	test   %eax,%eax
8010168c:	79 03                	jns    80101691 <bfree+0x98>
8010168e:	83 c0 07             	add    $0x7,%eax
80101691:	c1 f8 03             	sar    $0x3,%eax
80101694:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101697:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
8010169b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010169e:	f7 d1                	not    %ecx
801016a0:	21 ca                	and    %ecx,%edx
801016a2:	88 d1                	mov    %dl,%cl
801016a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a7:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ae:	89 04 24             	mov    %eax,(%esp)
801016b1:	e8 71 20 00 00       	call   80103727 <log_write>
  brelse(bp);
801016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b9:	89 04 24             	mov    %eax,(%esp)
801016bc:	e8 6b eb ff ff       	call   8010022c <brelse>
}
801016c1:	c9                   	leave  
801016c2:	c3                   	ret    

801016c3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016c3:	55                   	push   %ebp
801016c4:	89 e5                	mov    %esp,%ebp
801016c6:	57                   	push   %edi
801016c7:	56                   	push   %esi
801016c8:	53                   	push   %ebx
801016c9:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016d3:	c7 44 24 04 e1 82 10 	movl   $0x801082e1,0x4(%esp)
801016da:	80 
801016db:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
801016e2:	e8 23 37 00 00       	call   80104e0a <initlock>
  for(i = 0; i < NINODE; i++) {
801016e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ee:	eb 2b                	jmp    8010171b <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
801016f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016f3:	89 d0                	mov    %edx,%eax
801016f5:	c1 e0 03             	shl    $0x3,%eax
801016f8:	01 d0                	add    %edx,%eax
801016fa:	c1 e0 04             	shl    $0x4,%eax
801016fd:	83 c0 30             	add    $0x30,%eax
80101700:	05 a0 1c 11 80       	add    $0x80111ca0,%eax
80101705:	83 c0 10             	add    $0x10,%eax
80101708:	c7 44 24 04 e8 82 10 	movl   $0x801082e8,0x4(%esp)
8010170f:	80 
80101710:	89 04 24             	mov    %eax,(%esp)
80101713:	e8 b4 35 00 00       	call   80104ccc <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101718:	ff 45 e4             	incl   -0x1c(%ebp)
8010171b:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010171f:	7e cf                	jle    801016f0 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101721:	c7 44 24 04 80 1c 11 	movl   $0x80111c80,0x4(%esp)
80101728:	80 
80101729:	8b 45 08             	mov    0x8(%ebp),%eax
8010172c:	89 04 24             	mov    %eax,(%esp)
8010172f:	e8 f4 fc ff ff       	call   80101428 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101734:	a1 98 1c 11 80       	mov    0x80111c98,%eax
80101739:	8b 3d 94 1c 11 80    	mov    0x80111c94,%edi
8010173f:	8b 35 90 1c 11 80    	mov    0x80111c90,%esi
80101745:	8b 1d 8c 1c 11 80    	mov    0x80111c8c,%ebx
8010174b:	8b 0d 88 1c 11 80    	mov    0x80111c88,%ecx
80101751:	8b 15 84 1c 11 80    	mov    0x80111c84,%edx
80101757:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010175a:	8b 15 80 1c 11 80    	mov    0x80111c80,%edx
80101760:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101764:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101768:	89 74 24 14          	mov    %esi,0x14(%esp)
8010176c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101770:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101777:	89 44 24 08          	mov    %eax,0x8(%esp)
8010177b:	89 d0                	mov    %edx,%eax
8010177d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101781:	c7 04 24 f0 82 10 80 	movl   $0x801082f0,(%esp)
80101788:	e8 34 ec ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010178d:	83 c4 4c             	add    $0x4c,%esp
80101790:	5b                   	pop    %ebx
80101791:	5e                   	pop    %esi
80101792:	5f                   	pop    %edi
80101793:	5d                   	pop    %ebp
80101794:	c3                   	ret    

80101795 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101795:	55                   	push   %ebp
80101796:	89 e5                	mov    %esp,%ebp
80101798:	83 ec 28             	sub    $0x28,%esp
8010179b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010179e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017a2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801017a9:	e9 9b 00 00 00       	jmp    80101849 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
801017ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b1:	c1 e8 03             	shr    $0x3,%eax
801017b4:	89 c2                	mov    %eax,%edx
801017b6:	a1 94 1c 11 80       	mov    0x80111c94,%eax
801017bb:	01 d0                	add    %edx,%eax
801017bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801017c1:	8b 45 08             	mov    0x8(%ebp),%eax
801017c4:	89 04 24             	mov    %eax,(%esp)
801017c7:	e8 e9 e9 ff ff       	call   801001b5 <bread>
801017cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d2:	8d 50 5c             	lea    0x5c(%eax),%edx
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	83 e0 07             	and    $0x7,%eax
801017db:	c1 e0 06             	shl    $0x6,%eax
801017de:	01 d0                	add    %edx,%eax
801017e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017e6:	8b 00                	mov    (%eax),%eax
801017e8:	66 85 c0             	test   %ax,%ax
801017eb:	75 4e                	jne    8010183b <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
801017ed:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801017f4:	00 
801017f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801017fc:	00 
801017fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101800:	89 04 24             	mov    %eax,(%esp)
80101803:	e8 86 38 00 00       	call   8010508e <memset>
      dip->type = type;
80101808:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010180b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010180e:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101814:	89 04 24             	mov    %eax,(%esp)
80101817:	e8 0b 1f 00 00       	call   80103727 <log_write>
      brelse(bp);
8010181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181f:	89 04 24             	mov    %eax,(%esp)
80101822:	e8 05 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 04 24             	mov    %eax,(%esp)
80101834:	e8 ea 00 00 00       	call   80101923 <iget>
80101839:	eb 2a                	jmp    80101865 <ialloc+0xd0>
    }
    brelse(bp);
8010183b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183e:	89 04 24             	mov    %eax,(%esp)
80101841:	e8 e6 e9 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101846:	ff 45 f4             	incl   -0xc(%ebp)
80101849:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010184c:	a1 88 1c 11 80       	mov    0x80111c88,%eax
80101851:	39 c2                	cmp    %eax,%edx
80101853:	0f 82 55 ff ff ff    	jb     801017ae <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101859:	c7 04 24 43 83 10 80 	movl   $0x80108343,(%esp)
80101860:	e8 ef ec ff ff       	call   80100554 <panic>
}
80101865:	c9                   	leave  
80101866:	c3                   	ret    

80101867 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101867:	55                   	push   %ebp
80101868:	89 e5                	mov    %esp,%ebp
8010186a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010186d:	8b 45 08             	mov    0x8(%ebp),%eax
80101870:	8b 40 04             	mov    0x4(%eax),%eax
80101873:	c1 e8 03             	shr    $0x3,%eax
80101876:	89 c2                	mov    %eax,%edx
80101878:	a1 94 1c 11 80       	mov    0x80111c94,%eax
8010187d:	01 c2                	add    %eax,%edx
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	8b 00                	mov    (%eax),%eax
80101884:	89 54 24 04          	mov    %edx,0x4(%esp)
80101888:	89 04 24             	mov    %eax,(%esp)
8010188b:	e8 25 e9 ff ff       	call   801001b5 <bread>
80101890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101896:	8d 50 5c             	lea    0x5c(%eax),%edx
80101899:	8b 45 08             	mov    0x8(%ebp),%eax
8010189c:	8b 40 04             	mov    0x4(%eax),%eax
8010189f:	83 e0 07             	and    $0x7,%eax
801018a2:	c1 e0 06             	shl    $0x6,%eax
801018a5:	01 d0                	add    %edx,%eax
801018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801018aa:	8b 45 08             	mov    0x8(%ebp),%eax
801018ad:	8b 40 50             	mov    0x50(%eax),%eax
801018b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018b3:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	66 8b 40 52          	mov    0x52(%eax),%ax
801018bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018c0:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801018c4:	8b 45 08             	mov    0x8(%ebp),%eax
801018c7:	8b 40 54             	mov    0x54(%eax),%eax
801018ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018cd:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801018d1:	8b 45 08             	mov    0x8(%ebp),%eax
801018d4:	66 8b 40 56          	mov    0x56(%eax),%ax
801018d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018db:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801018df:	8b 45 08             	mov    0x8(%ebp),%eax
801018e2:	8b 50 58             	mov    0x58(%eax),%edx
801018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e8:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	8d 50 5c             	lea    0x5c(%eax),%edx
801018f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f4:	83 c0 0c             	add    $0xc,%eax
801018f7:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801018fe:	00 
801018ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80101903:	89 04 24             	mov    %eax,(%esp)
80101906:	e8 4c 38 00 00       	call   80105157 <memmove>
  log_write(bp);
8010190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190e:	89 04 24             	mov    %eax,(%esp)
80101911:	e8 11 1e 00 00       	call   80103727 <log_write>
  brelse(bp);
80101916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101919:	89 04 24             	mov    %eax,(%esp)
8010191c:	e8 0b e9 ff ff       	call   8010022c <brelse>
}
80101921:	c9                   	leave  
80101922:	c3                   	ret    

80101923 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101923:	55                   	push   %ebp
80101924:	89 e5                	mov    %esp,%ebp
80101926:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101929:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101930:	e8 f6 34 00 00       	call   80104e2b <acquire>

  // Is the inode already cached?
  empty = 0;
80101935:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010193c:	c7 45 f4 d4 1c 11 80 	movl   $0x80111cd4,-0xc(%ebp)
80101943:	eb 5c                	jmp    801019a1 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	8b 40 08             	mov    0x8(%eax),%eax
8010194b:	85 c0                	test   %eax,%eax
8010194d:	7e 35                	jle    80101984 <iget+0x61>
8010194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101952:	8b 00                	mov    (%eax),%eax
80101954:	3b 45 08             	cmp    0x8(%ebp),%eax
80101957:	75 2b                	jne    80101984 <iget+0x61>
80101959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195c:	8b 40 04             	mov    0x4(%eax),%eax
8010195f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101962:	75 20                	jne    80101984 <iget+0x61>
      ip->ref++;
80101964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101967:	8b 40 08             	mov    0x8(%eax),%eax
8010196a:	8d 50 01             	lea    0x1(%eax),%edx
8010196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101970:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101973:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
8010197a:	e8 16 35 00 00       	call   80104e95 <release>
      return ip;
8010197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101982:	eb 72                	jmp    801019f6 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101984:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101988:	75 10                	jne    8010199a <iget+0x77>
8010198a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198d:	8b 40 08             	mov    0x8(%eax),%eax
80101990:	85 c0                	test   %eax,%eax
80101992:	75 06                	jne    8010199a <iget+0x77>
      empty = ip;
80101994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101997:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010199a:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801019a1:	81 7d f4 f4 38 11 80 	cmpl   $0x801138f4,-0xc(%ebp)
801019a8:	72 9b                	jb     80101945 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019ae:	75 0c                	jne    801019bc <iget+0x99>
    panic("iget: no inodes");
801019b0:	c7 04 24 55 83 10 80 	movl   $0x80108355,(%esp)
801019b7:	e8 98 eb ff ff       	call   80100554 <panic>

  ip = empty;
801019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c5:	8b 55 08             	mov    0x8(%ebp),%edx
801019c8:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801019d0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e0:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019e7:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
801019ee:	e8 a2 34 00 00       	call   80104e95 <release>

  return ip;
801019f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019f6:	c9                   	leave  
801019f7:	c3                   	ret    

801019f8 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019f8:	55                   	push   %ebp
801019f9:	89 e5                	mov    %esp,%ebp
801019fb:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801019fe:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101a05:	e8 21 34 00 00       	call   80104e2b <acquire>
  ip->ref++;
80101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0d:	8b 40 08             	mov    0x8(%eax),%eax
80101a10:	8d 50 01             	lea    0x1(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a19:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101a20:	e8 70 34 00 00       	call   80104e95 <release>
  return ip;
80101a25:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a28:	c9                   	leave  
80101a29:	c3                   	ret    

80101a2a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a2a:	55                   	push   %ebp
80101a2b:	89 e5                	mov    %esp,%ebp
80101a2d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a34:	74 0a                	je     80101a40 <ilock+0x16>
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 08             	mov    0x8(%eax),%eax
80101a3c:	85 c0                	test   %eax,%eax
80101a3e:	7f 0c                	jg     80101a4c <ilock+0x22>
    panic("ilock");
80101a40:	c7 04 24 65 83 10 80 	movl   $0x80108365,(%esp)
80101a47:	e8 08 eb ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	83 c0 0c             	add    $0xc,%eax
80101a52:	89 04 24             	mov    %eax,(%esp)
80101a55:	e8 ac 32 00 00       	call   80104d06 <acquiresleep>

  if(ip->valid == 0){
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a60:	85 c0                	test   %eax,%eax
80101a62:	0f 85 ca 00 00 00    	jne    80101b32 <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	8b 40 04             	mov    0x4(%eax),%eax
80101a6e:	c1 e8 03             	shr    $0x3,%eax
80101a71:	89 c2                	mov    %eax,%edx
80101a73:	a1 94 1c 11 80       	mov    0x80111c94,%eax
80101a78:	01 c2                	add    %eax,%edx
80101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7d:	8b 00                	mov    (%eax),%eax
80101a7f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a83:	89 04 24             	mov    %eax,(%esp)
80101a86:	e8 2a e7 ff ff       	call   801001b5 <bread>
80101a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a91:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	8b 40 04             	mov    0x4(%eax),%eax
80101a9a:	83 e0 07             	and    $0x7,%eax
80101a9d:	c1 e0 06             	shl    $0x6,%eax
80101aa0:	01 d0                	add    %edx,%eax
80101aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa8:	8b 00                	mov    (%eax),%eax
80101aaa:	8b 55 08             	mov    0x8(%ebp),%edx
80101aad:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab4:	66 8b 40 02          	mov    0x2(%eax),%ax
80101ab8:	8b 55 08             	mov    0x8(%ebp),%edx
80101abb:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac2:	8b 40 04             	mov    0x4(%eax),%eax
80101ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac8:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101acf:	66 8b 40 06          	mov    0x6(%eax),%ax
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101add:	8b 50 08             	mov    0x8(%eax),%edx
80101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae3:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae9:	8d 50 0c             	lea    0xc(%eax),%edx
80101aec:	8b 45 08             	mov    0x8(%ebp),%eax
80101aef:	83 c0 5c             	add    $0x5c,%eax
80101af2:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101af9:	00 
80101afa:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afe:	89 04 24             	mov    %eax,(%esp)
80101b01:	e8 51 36 00 00       	call   80105157 <memmove>
    brelse(bp);
80101b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b09:	89 04 24             	mov    %eax,(%esp)
80101b0c:	e8 1b e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	8b 40 50             	mov    0x50(%eax),%eax
80101b21:	66 85 c0             	test   %ax,%ax
80101b24:	75 0c                	jne    80101b32 <ilock+0x108>
      panic("ilock: no type");
80101b26:	c7 04 24 6b 83 10 80 	movl   $0x8010836b,(%esp)
80101b2d:	e8 22 ea ff ff       	call   80100554 <panic>
  }
}
80101b32:	c9                   	leave  
80101b33:	c3                   	ret    

80101b34 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b34:	55                   	push   %ebp
80101b35:	89 e5                	mov    %esp,%ebp
80101b37:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b3e:	74 1c                	je     80101b5c <iunlock+0x28>
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	83 c0 0c             	add    $0xc,%eax
80101b46:	89 04 24             	mov    %eax,(%esp)
80101b49:	e8 55 32 00 00       	call   80104da3 <holdingsleep>
80101b4e:	85 c0                	test   %eax,%eax
80101b50:	74 0a                	je     80101b5c <iunlock+0x28>
80101b52:	8b 45 08             	mov    0x8(%ebp),%eax
80101b55:	8b 40 08             	mov    0x8(%eax),%eax
80101b58:	85 c0                	test   %eax,%eax
80101b5a:	7f 0c                	jg     80101b68 <iunlock+0x34>
    panic("iunlock");
80101b5c:	c7 04 24 7a 83 10 80 	movl   $0x8010837a,(%esp)
80101b63:	e8 ec e9 ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	83 c0 0c             	add    $0xc,%eax
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 eb 31 00 00       	call   80104d61 <releasesleep>
}
80101b76:	c9                   	leave  
80101b77:	c3                   	ret    

80101b78 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b78:	55                   	push   %ebp
80101b79:	89 e5                	mov    %esp,%ebp
80101b7b:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b81:	83 c0 0c             	add    $0xc,%eax
80101b84:	89 04 24             	mov    %eax,(%esp)
80101b87:	e8 7a 31 00 00       	call   80104d06 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b92:	85 c0                	test   %eax,%eax
80101b94:	74 5c                	je     80101bf2 <iput+0x7a>
80101b96:	8b 45 08             	mov    0x8(%ebp),%eax
80101b99:	66 8b 40 56          	mov    0x56(%eax),%ax
80101b9d:	66 85 c0             	test   %ax,%ax
80101ba0:	75 50                	jne    80101bf2 <iput+0x7a>
    acquire(&icache.lock);
80101ba2:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101ba9:	e8 7d 32 00 00       	call   80104e2b <acquire>
    int r = ip->ref;
80101bae:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb1:	8b 40 08             	mov    0x8(%eax),%eax
80101bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bb7:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101bbe:	e8 d2 32 00 00       	call   80104e95 <release>
    if(r == 1){
80101bc3:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bc7:	75 29                	jne    80101bf2 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	89 04 24             	mov    %eax,(%esp)
80101bcf:	e8 86 01 00 00       	call   80101d5a <itrunc>
      ip->type = 0;
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101be0:	89 04 24             	mov    %eax,(%esp)
80101be3:	e8 7f fc ff ff       	call   80101867 <iupdate>
      ip->valid = 0;
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf5:	83 c0 0c             	add    $0xc,%eax
80101bf8:	89 04 24             	mov    %eax,(%esp)
80101bfb:	e8 61 31 00 00       	call   80104d61 <releasesleep>

  acquire(&icache.lock);
80101c00:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101c07:	e8 1f 32 00 00       	call   80104e2b <acquire>
  ip->ref--;
80101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0f:	8b 40 08             	mov    0x8(%eax),%eax
80101c12:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c15:	8b 45 08             	mov    0x8(%ebp),%eax
80101c18:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c1b:	c7 04 24 a0 1c 11 80 	movl   $0x80111ca0,(%esp)
80101c22:	e8 6e 32 00 00       	call   80104e95 <release>
}
80101c27:	c9                   	leave  
80101c28:	c3                   	ret    

80101c29 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c29:	55                   	push   %ebp
80101c2a:	89 e5                	mov    %esp,%ebp
80101c2c:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	89 04 24             	mov    %eax,(%esp)
80101c35:	e8 fa fe ff ff       	call   80101b34 <iunlock>
  iput(ip);
80101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3d:	89 04 24             	mov    %eax,(%esp)
80101c40:	e8 33 ff ff ff       	call   80101b78 <iput>
}
80101c45:	c9                   	leave  
80101c46:	c3                   	ret    

80101c47 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c47:	55                   	push   %ebp
80101c48:	89 e5                	mov    %esp,%ebp
80101c4a:	53                   	push   %ebx
80101c4b:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c4e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c52:	77 3e                	ja     80101c92 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c5a:	83 c2 14             	add    $0x14,%edx
80101c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c68:	75 20                	jne    80101c8a <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	89 04 24             	mov    %eax,(%esp)
80101c72:	e8 48 f8 ff ff       	call   801014bf <balloc>
80101c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c80:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c86:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c8d:	e9 c2 00 00 00       	jmp    80101d54 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101c92:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c96:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c9a:	0f 87 a8 00 00 00    	ja     80101d48 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cb0:	75 1c                	jne    80101cce <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb5:	8b 00                	mov    (%eax),%eax
80101cb7:	89 04 24             	mov    %eax,(%esp)
80101cba:	e8 00 f8 ff ff       	call   801014bf <balloc>
80101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cc8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 00                	mov    (%eax),%eax
80101cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cda:	89 04 24             	mov    %eax,(%esp)
80101cdd:	e8 d3 e4 ff ff       	call   801001b5 <bread>
80101ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce8:	83 c0 5c             	add    $0x5c,%eax
80101ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cf1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cfb:	01 d0                	add    %edx,%eax
80101cfd:	8b 00                	mov    (%eax),%eax
80101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d06:	75 30                	jne    80101d38 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101d08:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d15:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 00                	mov    (%eax),%eax
80101d1d:	89 04 24             	mov    %eax,(%esp)
80101d20:	e8 9a f7 ff ff       	call   801014bf <balloc>
80101d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d2b:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d30:	89 04 24             	mov    %eax,(%esp)
80101d33:	e8 ef 19 00 00       	call   80103727 <log_write>
    }
    brelse(bp);
80101d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d3b:	89 04 24             	mov    %eax,(%esp)
80101d3e:	e8 e9 e4 ff ff       	call   8010022c <brelse>
    return addr;
80101d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d46:	eb 0c                	jmp    80101d54 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101d48:	c7 04 24 82 83 10 80 	movl   $0x80108382,(%esp)
80101d4f:	e8 00 e8 ff ff       	call   80100554 <panic>
}
80101d54:	83 c4 24             	add    $0x24,%esp
80101d57:	5b                   	pop    %ebx
80101d58:	5d                   	pop    %ebp
80101d59:	c3                   	ret    

80101d5a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d5a:	55                   	push   %ebp
80101d5b:	89 e5                	mov    %esp,%ebp
80101d5d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d67:	eb 43                	jmp    80101dac <itrunc+0x52>
    if(ip->addrs[i]){
80101d69:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6f:	83 c2 14             	add    $0x14,%edx
80101d72:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d76:	85 c0                	test   %eax,%eax
80101d78:	74 2f                	je     80101da9 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d80:	83 c2 14             	add    $0x14,%edx
80101d83:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	8b 00                	mov    (%eax),%eax
80101d8c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d90:	89 04 24             	mov    %eax,(%esp)
80101d93:	e8 61 f8 ff ff       	call   801015f9 <bfree>
      ip->addrs[i] = 0;
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9e:	83 c2 14             	add    $0x14,%edx
80101da1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101da8:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101da9:	ff 45 f4             	incl   -0xc(%ebp)
80101dac:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101db0:	7e b7                	jle    80101d69 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	0f 84 a3 00 00 00    	je     80101e66 <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcf:	8b 00                	mov    (%eax),%eax
80101dd1:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dd5:	89 04 24             	mov    %eax,(%esp)
80101dd8:	e8 d8 e3 ff ff       	call   801001b5 <bread>
80101ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101de3:	83 c0 5c             	add    $0x5c,%eax
80101de6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101de9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101df0:	eb 3a                	jmp    80101e2c <itrunc+0xd2>
      if(a[j])
80101df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dff:	01 d0                	add    %edx,%eax
80101e01:	8b 00                	mov    (%eax),%eax
80101e03:	85 c0                	test   %eax,%eax
80101e05:	74 22                	je     80101e29 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e14:	01 d0                	add    %edx,%eax
80101e16:	8b 10                	mov    (%eax),%edx
80101e18:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1b:	8b 00                	mov    (%eax),%eax
80101e1d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e21:	89 04 24             	mov    %eax,(%esp)
80101e24:	e8 d0 f7 ff ff       	call   801015f9 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e29:	ff 45 f0             	incl   -0x10(%ebp)
80101e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e2f:	83 f8 7f             	cmp    $0x7f,%eax
80101e32:	76 be                	jbe    80101df2 <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e37:	89 04 24             	mov    %eax,(%esp)
80101e3a:	e8 ed e3 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e48:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4b:	8b 00                	mov    (%eax),%eax
80101e4d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e51:	89 04 24             	mov    %eax,(%esp)
80101e54:	e8 a0 f7 ff ff       	call   801015f9 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e59:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5c:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e63:	00 00 00 
  }

  ip->size = 0;
80101e66:	8b 45 08             	mov    0x8(%ebp),%eax
80101e69:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	89 04 24             	mov    %eax,(%esp)
80101e76:	e8 ec f9 ff ff       	call   80101867 <iupdate>
}
80101e7b:	c9                   	leave  
80101e7c:	c3                   	ret    

80101e7d <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e7d:	55                   	push   %ebp
80101e7e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e80:	8b 45 08             	mov    0x8(%ebp),%eax
80101e83:	8b 00                	mov    (%eax),%eax
80101e85:	89 c2                	mov    %eax,%edx
80101e87:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e90:	8b 50 04             	mov    0x4(%eax),%edx
80101e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e96:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e99:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9c:	8b 40 50             	mov    0x50(%eax),%eax
80101e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ea2:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea8:	66 8b 40 56          	mov    0x56(%eax),%ax
80101eac:	8b 55 0c             	mov    0xc(%ebp),%edx
80101eaf:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb6:	8b 50 58             	mov    0x58(%eax),%edx
80101eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebc:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ebf:	5d                   	pop    %ebp
80101ec0:	c3                   	ret    

80101ec1 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ec1:	55                   	push   %ebp
80101ec2:	89 e5                	mov    %esp,%ebp
80101ec4:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eca:	8b 40 50             	mov    0x50(%eax),%eax
80101ecd:	66 83 f8 03          	cmp    $0x3,%ax
80101ed1:	75 60                	jne    80101f33 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed6:	66 8b 40 52          	mov    0x52(%eax),%ax
80101eda:	66 85 c0             	test   %ax,%ax
80101edd:	78 20                	js     80101eff <readi+0x3e>
80101edf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee2:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ee6:	66 83 f8 09          	cmp    $0x9,%ax
80101eea:	7f 13                	jg     80101eff <readi+0x3e>
80101eec:	8b 45 08             	mov    0x8(%ebp),%eax
80101eef:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ef3:	98                   	cwtl   
80101ef4:	8b 04 c5 20 1c 11 80 	mov    -0x7feee3e0(,%eax,8),%eax
80101efb:	85 c0                	test   %eax,%eax
80101efd:	75 0a                	jne    80101f09 <readi+0x48>
      return -1;
80101eff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f04:	e9 1a 01 00 00       	jmp    80102023 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101f09:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0c:	66 8b 40 52          	mov    0x52(%eax),%ax
80101f10:	98                   	cwtl   
80101f11:	8b 04 c5 20 1c 11 80 	mov    -0x7feee3e0(,%eax,8),%eax
80101f18:	8b 55 14             	mov    0x14(%ebp),%edx
80101f1b:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f22:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f26:	8b 55 08             	mov    0x8(%ebp),%edx
80101f29:	89 14 24             	mov    %edx,(%esp)
80101f2c:	ff d0                	call   *%eax
80101f2e:	e9 f0 00 00 00       	jmp    80102023 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	8b 40 58             	mov    0x58(%eax),%eax
80101f39:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f3c:	72 0d                	jb     80101f4b <readi+0x8a>
80101f3e:	8b 45 14             	mov    0x14(%ebp),%eax
80101f41:	8b 55 10             	mov    0x10(%ebp),%edx
80101f44:	01 d0                	add    %edx,%eax
80101f46:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f49:	73 0a                	jae    80101f55 <readi+0x94>
    return -1;
80101f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f50:	e9 ce 00 00 00       	jmp    80102023 <readi+0x162>
  if(off + n > ip->size)
80101f55:	8b 45 14             	mov    0x14(%ebp),%eax
80101f58:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5b:	01 c2                	add    %eax,%edx
80101f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f60:	8b 40 58             	mov    0x58(%eax),%eax
80101f63:	39 c2                	cmp    %eax,%edx
80101f65:	76 0c                	jbe    80101f73 <readi+0xb2>
    n = ip->size - off;
80101f67:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6a:	8b 40 58             	mov    0x58(%eax),%eax
80101f6d:	2b 45 10             	sub    0x10(%ebp),%eax
80101f70:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f7a:	e9 95 00 00 00       	jmp    80102014 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f7f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f82:	c1 e8 09             	shr    $0x9,%eax
80101f85:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	89 04 24             	mov    %eax,(%esp)
80101f8f:	e8 b3 fc ff ff       	call   80101c47 <bmap>
80101f94:	8b 55 08             	mov    0x8(%ebp),%edx
80101f97:	8b 12                	mov    (%edx),%edx
80101f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9d:	89 14 24             	mov    %edx,(%esp)
80101fa0:	e8 10 e2 ff ff       	call   801001b5 <bread>
80101fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa8:	8b 45 10             	mov    0x10(%ebp),%eax
80101fab:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fb0:	89 c2                	mov    %eax,%edx
80101fb2:	b8 00 02 00 00       	mov    $0x200,%eax
80101fb7:	29 d0                	sub    %edx,%eax
80101fb9:	89 c1                	mov    %eax,%ecx
80101fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fbe:	8b 55 14             	mov    0x14(%ebp),%edx
80101fc1:	29 c2                	sub    %eax,%edx
80101fc3:	89 c8                	mov    %ecx,%eax
80101fc5:	39 d0                	cmp    %edx,%eax
80101fc7:	76 02                	jbe    80101fcb <readi+0x10a>
80101fc9:	89 d0                	mov    %edx,%eax
80101fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fce:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fd6:	8d 50 50             	lea    0x50(%eax),%edx
80101fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fdc:	01 d0                	add    %edx,%eax
80101fde:	8d 50 0c             	lea    0xc(%eax),%edx
80101fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fe4:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fef:	89 04 24             	mov    %eax,(%esp)
80101ff2:	e8 60 31 00 00       	call   80105157 <memmove>
    brelse(bp);
80101ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffa:	89 04 24             	mov    %eax,(%esp)
80101ffd:	e8 2a e2 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102002:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102005:	01 45 f4             	add    %eax,-0xc(%ebp)
80102008:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200b:	01 45 10             	add    %eax,0x10(%ebp)
8010200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102011:	01 45 0c             	add    %eax,0xc(%ebp)
80102014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102017:	3b 45 14             	cmp    0x14(%ebp),%eax
8010201a:	0f 82 5f ff ff ff    	jb     80101f7f <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102020:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102023:	c9                   	leave  
80102024:	c3                   	ret    

80102025 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102025:	55                   	push   %ebp
80102026:	89 e5                	mov    %esp,%ebp
80102028:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
8010202e:	8b 40 50             	mov    0x50(%eax),%eax
80102031:	66 83 f8 03          	cmp    $0x3,%ax
80102035:	75 60                	jne    80102097 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	66 8b 40 52          	mov    0x52(%eax),%ax
8010203e:	66 85 c0             	test   %ax,%ax
80102041:	78 20                	js     80102063 <writei+0x3e>
80102043:	8b 45 08             	mov    0x8(%ebp),%eax
80102046:	66 8b 40 52          	mov    0x52(%eax),%ax
8010204a:	66 83 f8 09          	cmp    $0x9,%ax
8010204e:	7f 13                	jg     80102063 <writei+0x3e>
80102050:	8b 45 08             	mov    0x8(%ebp),%eax
80102053:	66 8b 40 52          	mov    0x52(%eax),%ax
80102057:	98                   	cwtl   
80102058:	8b 04 c5 24 1c 11 80 	mov    -0x7feee3dc(,%eax,8),%eax
8010205f:	85 c0                	test   %eax,%eax
80102061:	75 0a                	jne    8010206d <writei+0x48>
      return -1;
80102063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102068:	e9 45 01 00 00       	jmp    801021b2 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
8010206d:	8b 45 08             	mov    0x8(%ebp),%eax
80102070:	66 8b 40 52          	mov    0x52(%eax),%ax
80102074:	98                   	cwtl   
80102075:	8b 04 c5 24 1c 11 80 	mov    -0x7feee3dc(,%eax,8),%eax
8010207c:	8b 55 14             	mov    0x14(%ebp),%edx
8010207f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102083:	8b 55 0c             	mov    0xc(%ebp),%edx
80102086:	89 54 24 04          	mov    %edx,0x4(%esp)
8010208a:	8b 55 08             	mov    0x8(%ebp),%edx
8010208d:	89 14 24             	mov    %edx,(%esp)
80102090:	ff d0                	call   *%eax
80102092:	e9 1b 01 00 00       	jmp    801021b2 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80102097:	8b 45 08             	mov    0x8(%ebp),%eax
8010209a:	8b 40 58             	mov    0x58(%eax),%eax
8010209d:	3b 45 10             	cmp    0x10(%ebp),%eax
801020a0:	72 0d                	jb     801020af <writei+0x8a>
801020a2:	8b 45 14             	mov    0x14(%ebp),%eax
801020a5:	8b 55 10             	mov    0x10(%ebp),%edx
801020a8:	01 d0                	add    %edx,%eax
801020aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ad:	73 0a                	jae    801020b9 <writei+0x94>
    return -1;
801020af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b4:	e9 f9 00 00 00       	jmp    801021b2 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
801020b9:	8b 45 14             	mov    0x14(%ebp),%eax
801020bc:	8b 55 10             	mov    0x10(%ebp),%edx
801020bf:	01 d0                	add    %edx,%eax
801020c1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020c6:	76 0a                	jbe    801020d2 <writei+0xad>
    return -1;
801020c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020cd:	e9 e0 00 00 00       	jmp    801021b2 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020d9:	e9 a0 00 00 00       	jmp    8010217e <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020de:	8b 45 10             	mov    0x10(%ebp),%eax
801020e1:	c1 e8 09             	shr    $0x9,%eax
801020e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801020e8:	8b 45 08             	mov    0x8(%ebp),%eax
801020eb:	89 04 24             	mov    %eax,(%esp)
801020ee:	e8 54 fb ff ff       	call   80101c47 <bmap>
801020f3:	8b 55 08             	mov    0x8(%ebp),%edx
801020f6:	8b 12                	mov    (%edx),%edx
801020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fc:	89 14 24             	mov    %edx,(%esp)
801020ff:	e8 b1 e0 ff ff       	call   801001b5 <bread>
80102104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102107:	8b 45 10             	mov    0x10(%ebp),%eax
8010210a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010210f:	89 c2                	mov    %eax,%edx
80102111:	b8 00 02 00 00       	mov    $0x200,%eax
80102116:	29 d0                	sub    %edx,%eax
80102118:	89 c1                	mov    %eax,%ecx
8010211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211d:	8b 55 14             	mov    0x14(%ebp),%edx
80102120:	29 c2                	sub    %eax,%edx
80102122:	89 c8                	mov    %ecx,%eax
80102124:	39 d0                	cmp    %edx,%eax
80102126:	76 02                	jbe    8010212a <writei+0x105>
80102128:	89 d0                	mov    %edx,%eax
8010212a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010212d:	8b 45 10             	mov    0x10(%ebp),%eax
80102130:	25 ff 01 00 00       	and    $0x1ff,%eax
80102135:	8d 50 50             	lea    0x50(%eax),%edx
80102138:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010213b:	01 d0                	add    %edx,%eax
8010213d:	8d 50 0c             	lea    0xc(%eax),%edx
80102140:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102143:	89 44 24 08          	mov    %eax,0x8(%esp)
80102147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010214a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010214e:	89 14 24             	mov    %edx,(%esp)
80102151:	e8 01 30 00 00       	call   80105157 <memmove>
    log_write(bp);
80102156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102159:	89 04 24             	mov    %eax,(%esp)
8010215c:	e8 c6 15 00 00       	call   80103727 <log_write>
    brelse(bp);
80102161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102164:	89 04 24             	mov    %eax,(%esp)
80102167:	e8 c0 e0 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 10             	add    %eax,0x10(%ebp)
80102178:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217b:	01 45 0c             	add    %eax,0xc(%ebp)
8010217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102181:	3b 45 14             	cmp    0x14(%ebp),%eax
80102184:	0f 82 54 ff ff ff    	jb     801020de <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010218a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010218e:	74 1f                	je     801021af <writei+0x18a>
80102190:	8b 45 08             	mov    0x8(%ebp),%eax
80102193:	8b 40 58             	mov    0x58(%eax),%eax
80102196:	3b 45 10             	cmp    0x10(%ebp),%eax
80102199:	73 14                	jae    801021af <writei+0x18a>
    ip->size = off;
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
8010219e:	8b 55 10             	mov    0x10(%ebp),%edx
801021a1:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021a4:	8b 45 08             	mov    0x8(%ebp),%eax
801021a7:	89 04 24             	mov    %eax,(%esp)
801021aa:	e8 b8 f6 ff ff       	call   80101867 <iupdate>
  }
  return n;
801021af:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021b2:	c9                   	leave  
801021b3:	c3                   	ret    

801021b4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b4:	55                   	push   %ebp
801021b5:	89 e5                	mov    %esp,%ebp
801021b7:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801021ba:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021c1:	00 
801021c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c9:	8b 45 08             	mov    0x8(%ebp),%eax
801021cc:	89 04 24             	mov    %eax,(%esp)
801021cf:	e8 22 30 00 00       	call   801051f6 <strncmp>
}
801021d4:	c9                   	leave  
801021d5:	c3                   	ret    

801021d6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d6:	55                   	push   %ebp
801021d7:	89 e5                	mov    %esp,%ebp
801021d9:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021dc:	8b 45 08             	mov    0x8(%ebp),%eax
801021df:	8b 40 50             	mov    0x50(%eax),%eax
801021e2:	66 83 f8 01          	cmp    $0x1,%ax
801021e6:	74 0c                	je     801021f4 <dirlookup+0x1e>
    panic("dirlookup not DIR");
801021e8:	c7 04 24 95 83 10 80 	movl   $0x80108395,(%esp)
801021ef:	e8 60 e3 ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021fb:	e9 86 00 00 00       	jmp    80102286 <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102200:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102207:	00 
80102208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010220f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102212:	89 44 24 04          	mov    %eax,0x4(%esp)
80102216:	8b 45 08             	mov    0x8(%ebp),%eax
80102219:	89 04 24             	mov    %eax,(%esp)
8010221c:	e8 a0 fc ff ff       	call   80101ec1 <readi>
80102221:	83 f8 10             	cmp    $0x10,%eax
80102224:	74 0c                	je     80102232 <dirlookup+0x5c>
      panic("dirlookup read");
80102226:	c7 04 24 a7 83 10 80 	movl   $0x801083a7,(%esp)
8010222d:	e8 22 e3 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
80102232:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102235:	66 85 c0             	test   %ax,%ax
80102238:	75 02                	jne    8010223c <dirlookup+0x66>
      continue;
8010223a:	eb 46                	jmp    80102282 <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
8010223c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223f:	83 c0 02             	add    $0x2,%eax
80102242:	89 44 24 04          	mov    %eax,0x4(%esp)
80102246:	8b 45 0c             	mov    0xc(%ebp),%eax
80102249:	89 04 24             	mov    %eax,(%esp)
8010224c:	e8 63 ff ff ff       	call   801021b4 <namecmp>
80102251:	85 c0                	test   %eax,%eax
80102253:	75 2d                	jne    80102282 <dirlookup+0xac>
      // entry matches path element
      if(poff)
80102255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102259:	74 08                	je     80102263 <dirlookup+0x8d>
        *poff = off;
8010225b:	8b 45 10             	mov    0x10(%ebp),%eax
8010225e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102261:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102263:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102266:	0f b7 c0             	movzwl %ax,%eax
80102269:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010226c:	8b 45 08             	mov    0x8(%ebp),%eax
8010226f:	8b 00                	mov    (%eax),%eax
80102271:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102274:	89 54 24 04          	mov    %edx,0x4(%esp)
80102278:	89 04 24             	mov    %eax,(%esp)
8010227b:	e8 a3 f6 ff ff       	call   80101923 <iget>
80102280:	eb 18                	jmp    8010229a <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102282:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102286:	8b 45 08             	mov    0x8(%ebp),%eax
80102289:	8b 40 58             	mov    0x58(%eax),%eax
8010228c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010228f:	0f 87 6b ff ff ff    	ja     80102200 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102295:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010229a:	c9                   	leave  
8010229b:	c3                   	ret    

8010229c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010229c:	55                   	push   %ebp
8010229d:	89 e5                	mov    %esp,%ebp
8010229f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801022a9:	00 
801022aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b1:	8b 45 08             	mov    0x8(%ebp),%eax
801022b4:	89 04 24             	mov    %eax,(%esp)
801022b7:	e8 1a ff ff ff       	call   801021d6 <dirlookup>
801022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022c3:	74 15                	je     801022da <dirlink+0x3e>
    iput(ip);
801022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022c8:	89 04 24             	mov    %eax,(%esp)
801022cb:	e8 a8 f8 ff ff       	call   80101b78 <iput>
    return -1;
801022d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d5:	e9 b6 00 00 00       	jmp    80102390 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022e1:	eb 45                	jmp    80102328 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022ed:	00 
801022ee:	89 44 24 08          	mov    %eax,0x8(%esp)
801022f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	89 04 24             	mov    %eax,(%esp)
801022ff:	e8 bd fb ff ff       	call   80101ec1 <readi>
80102304:	83 f8 10             	cmp    $0x10,%eax
80102307:	74 0c                	je     80102315 <dirlink+0x79>
      panic("dirlink read");
80102309:	c7 04 24 b6 83 10 80 	movl   $0x801083b6,(%esp)
80102310:	e8 3f e2 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
80102315:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102318:	66 85 c0             	test   %ax,%ax
8010231b:	75 02                	jne    8010231f <dirlink+0x83>
      break;
8010231d:	eb 16                	jmp    80102335 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102322:	83 c0 10             	add    $0x10,%eax
80102325:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102328:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010232b:	8b 45 08             	mov    0x8(%ebp),%eax
8010232e:	8b 40 58             	mov    0x58(%eax),%eax
80102331:	39 c2                	cmp    %eax,%edx
80102333:	72 ae                	jb     801022e3 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102335:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010233c:	00 
8010233d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102340:	89 44 24 04          	mov    %eax,0x4(%esp)
80102344:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102347:	83 c0 02             	add    $0x2,%eax
8010234a:	89 04 24             	mov    %eax,(%esp)
8010234d:	e8 f2 2e 00 00       	call   80105244 <strncpy>
  de.inum = inum;
80102352:	8b 45 10             	mov    0x10(%ebp),%eax
80102355:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102363:	00 
80102364:	89 44 24 08          	mov    %eax,0x8(%esp)
80102368:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010236b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236f:	8b 45 08             	mov    0x8(%ebp),%eax
80102372:	89 04 24             	mov    %eax,(%esp)
80102375:	e8 ab fc ff ff       	call   80102025 <writei>
8010237a:	83 f8 10             	cmp    $0x10,%eax
8010237d:	74 0c                	je     8010238b <dirlink+0xef>
    panic("dirlink");
8010237f:	c7 04 24 c3 83 10 80 	movl   $0x801083c3,(%esp)
80102386:	e8 c9 e1 ff ff       	call   80100554 <panic>

  return 0;
8010238b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102390:	c9                   	leave  
80102391:	c3                   	ret    

80102392 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102392:	55                   	push   %ebp
80102393:	89 e5                	mov    %esp,%ebp
80102395:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102398:	eb 03                	jmp    8010239d <skipelem+0xb>
    path++;
8010239a:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010239d:	8b 45 08             	mov    0x8(%ebp),%eax
801023a0:	8a 00                	mov    (%eax),%al
801023a2:	3c 2f                	cmp    $0x2f,%al
801023a4:	74 f4                	je     8010239a <skipelem+0x8>
    path++;
  if(*path == 0)
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
801023a9:	8a 00                	mov    (%eax),%al
801023ab:	84 c0                	test   %al,%al
801023ad:	75 0a                	jne    801023b9 <skipelem+0x27>
    return 0;
801023af:	b8 00 00 00 00       	mov    $0x0,%eax
801023b4:	e9 81 00 00 00       	jmp    8010243a <skipelem+0xa8>
  s = path;
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
801023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023bf:	eb 03                	jmp    801023c4 <skipelem+0x32>
    path++;
801023c1:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023c4:	8b 45 08             	mov    0x8(%ebp),%eax
801023c7:	8a 00                	mov    (%eax),%al
801023c9:	3c 2f                	cmp    $0x2f,%al
801023cb:	74 09                	je     801023d6 <skipelem+0x44>
801023cd:	8b 45 08             	mov    0x8(%ebp),%eax
801023d0:	8a 00                	mov    (%eax),%al
801023d2:	84 c0                	test   %al,%al
801023d4:	75 eb                	jne    801023c1 <skipelem+0x2f>
    path++;
  len = path - s;
801023d6:	8b 55 08             	mov    0x8(%ebp),%edx
801023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023dc:	29 c2                	sub    %eax,%edx
801023de:	89 d0                	mov    %edx,%eax
801023e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023e3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e7:	7e 1c                	jle    80102405 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
801023e9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801023f0:	00 
801023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801023fb:	89 04 24             	mov    %eax,(%esp)
801023fe:	e8 54 2d 00 00       	call   80105157 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102403:	eb 29                	jmp    8010242e <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102405:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102408:	89 44 24 08          	mov    %eax,0x8(%esp)
8010240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102413:	8b 45 0c             	mov    0xc(%ebp),%eax
80102416:	89 04 24             	mov    %eax,(%esp)
80102419:	e8 39 2d 00 00       	call   80105157 <memmove>
    name[len] = 0;
8010241e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102421:	8b 45 0c             	mov    0xc(%ebp),%eax
80102424:	01 d0                	add    %edx,%eax
80102426:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102429:	eb 03                	jmp    8010242e <skipelem+0x9c>
    path++;
8010242b:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010242e:	8b 45 08             	mov    0x8(%ebp),%eax
80102431:	8a 00                	mov    (%eax),%al
80102433:	3c 2f                	cmp    $0x2f,%al
80102435:	74 f4                	je     8010242b <skipelem+0x99>
    path++;
  return path;
80102437:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010243a:	c9                   	leave  
8010243b:	c3                   	ret    

8010243c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010243c:	55                   	push   %ebp
8010243d:	89 e5                	mov    %esp,%ebp
8010243f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102442:	8b 45 08             	mov    0x8(%ebp),%eax
80102445:	8a 00                	mov    (%eax),%al
80102447:	3c 2f                	cmp    $0x2f,%al
80102449:	75 1c                	jne    80102467 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
8010244b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102452:	00 
80102453:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010245a:	e8 c4 f4 ff ff       	call   80101923 <iget>
8010245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102462:	e9 ac 00 00 00       	jmp    80102513 <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102467:	e8 af 1d 00 00       	call   8010421b <myproc>
8010246c:	8b 40 68             	mov    0x68(%eax),%eax
8010246f:	89 04 24             	mov    %eax,(%esp)
80102472:	e8 81 f5 ff ff       	call   801019f8 <idup>
80102477:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010247a:	e9 94 00 00 00       	jmp    80102513 <namex+0xd7>
    ilock(ip);
8010247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102482:	89 04 24             	mov    %eax,(%esp)
80102485:	e8 a0 f5 ff ff       	call   80101a2a <ilock>
    if(ip->type != T_DIR){
8010248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010248d:	8b 40 50             	mov    0x50(%eax),%eax
80102490:	66 83 f8 01          	cmp    $0x1,%ax
80102494:	74 15                	je     801024ab <namex+0x6f>
      iunlockput(ip);
80102496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102499:	89 04 24             	mov    %eax,(%esp)
8010249c:	e8 88 f7 ff ff       	call   80101c29 <iunlockput>
      return 0;
801024a1:	b8 00 00 00 00       	mov    $0x0,%eax
801024a6:	e9 a2 00 00 00       	jmp    8010254d <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
801024ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024af:	74 1c                	je     801024cd <namex+0x91>
801024b1:	8b 45 08             	mov    0x8(%ebp),%eax
801024b4:	8a 00                	mov    (%eax),%al
801024b6:	84 c0                	test   %al,%al
801024b8:	75 13                	jne    801024cd <namex+0x91>
      // Stop one level early.
      iunlock(ip);
801024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024bd:	89 04 24             	mov    %eax,(%esp)
801024c0:	e8 6f f6 ff ff       	call   80101b34 <iunlock>
      return ip;
801024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c8:	e9 80 00 00 00       	jmp    8010254d <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801024d4:	00 
801024d5:	8b 45 10             	mov    0x10(%ebp),%eax
801024d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024df:	89 04 24             	mov    %eax,(%esp)
801024e2:	e8 ef fc ff ff       	call   801021d6 <dirlookup>
801024e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024ee:	75 12                	jne    80102502 <namex+0xc6>
      iunlockput(ip);
801024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f3:	89 04 24             	mov    %eax,(%esp)
801024f6:	e8 2e f7 ff ff       	call   80101c29 <iunlockput>
      return 0;
801024fb:	b8 00 00 00 00       	mov    $0x0,%eax
80102500:	eb 4b                	jmp    8010254d <namex+0x111>
    }
    iunlockput(ip);
80102502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102505:	89 04 24             	mov    %eax,(%esp)
80102508:	e8 1c f7 ff ff       	call   80101c29 <iunlockput>
    ip = next;
8010250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102513:	8b 45 10             	mov    0x10(%ebp),%eax
80102516:	89 44 24 04          	mov    %eax,0x4(%esp)
8010251a:	8b 45 08             	mov    0x8(%ebp),%eax
8010251d:	89 04 24             	mov    %eax,(%esp)
80102520:	e8 6d fe ff ff       	call   80102392 <skipelem>
80102525:	89 45 08             	mov    %eax,0x8(%ebp)
80102528:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010252c:	0f 85 4d ff ff ff    	jne    8010247f <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102532:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102536:	74 12                	je     8010254a <namex+0x10e>
    iput(ip);
80102538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010253b:	89 04 24             	mov    %eax,(%esp)
8010253e:	e8 35 f6 ff ff       	call   80101b78 <iput>
    return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
80102548:	eb 03                	jmp    8010254d <namex+0x111>
  }
  return ip;
8010254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254d:	c9                   	leave  
8010254e:	c3                   	ret    

8010254f <namei>:

struct inode*
namei(char *path)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102558:	89 44 24 08          	mov    %eax,0x8(%esp)
8010255c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102563:	00 
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
80102567:	89 04 24             	mov    %eax,(%esp)
8010256a:	e8 cd fe ff ff       	call   8010243c <namex>
}
8010256f:	c9                   	leave  
80102570:	c3                   	ret    

80102571 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102571:	55                   	push   %ebp
80102572:	89 e5                	mov    %esp,%ebp
80102574:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102577:	8b 45 0c             	mov    0xc(%ebp),%eax
8010257a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010257e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102585:	00 
80102586:	8b 45 08             	mov    0x8(%ebp),%eax
80102589:	89 04 24             	mov    %eax,(%esp)
8010258c:	e8 ab fe ff ff       	call   8010243c <namex>
}
80102591:	c9                   	leave  
80102592:	c3                   	ret    
	...

80102594 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	83 ec 14             	sub    $0x14,%esp
8010259a:	8b 45 08             	mov    0x8(%ebp),%eax
8010259d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801025a4:	89 c2                	mov    %eax,%edx
801025a6:	ec                   	in     (%dx),%al
801025a7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025aa:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801025ad:	c9                   	leave  
801025ae:	c3                   	ret    

801025af <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025af:	55                   	push   %ebp
801025b0:	89 e5                	mov    %esp,%ebp
801025b2:	57                   	push   %edi
801025b3:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025b4:	8b 55 08             	mov    0x8(%ebp),%edx
801025b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025ba:	8b 45 10             	mov    0x10(%ebp),%eax
801025bd:	89 cb                	mov    %ecx,%ebx
801025bf:	89 df                	mov    %ebx,%edi
801025c1:	89 c1                	mov    %eax,%ecx
801025c3:	fc                   	cld    
801025c4:	f3 6d                	rep insl (%dx),%es:(%edi)
801025c6:	89 c8                	mov    %ecx,%eax
801025c8:	89 fb                	mov    %edi,%ebx
801025ca:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025cd:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025d0:	5b                   	pop    %ebx
801025d1:	5f                   	pop    %edi
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    

801025d4 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	83 ec 08             	sub    $0x8,%esp
801025da:	8b 45 08             	mov    0x8(%ebp),%eax
801025dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801025e0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801025e4:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e7:	8a 45 f8             	mov    -0x8(%ebp),%al
801025ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
801025ed:	ee                   	out    %al,(%dx)
}
801025ee:	c9                   	leave  
801025ef:	c3                   	ret    

801025f0 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025f5:	8b 55 08             	mov    0x8(%ebp),%edx
801025f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025fb:	8b 45 10             	mov    0x10(%ebp),%eax
801025fe:	89 cb                	mov    %ecx,%ebx
80102600:	89 de                	mov    %ebx,%esi
80102602:	89 c1                	mov    %eax,%ecx
80102604:	fc                   	cld    
80102605:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102607:	89 c8                	mov    %ecx,%eax
80102609:	89 f3                	mov    %esi,%ebx
8010260b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010260e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    

80102615 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102615:	55                   	push   %ebp
80102616:	89 e5                	mov    %esp,%ebp
80102618:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010261b:	90                   	nop
8010261c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102623:	e8 6c ff ff ff       	call   80102594 <inb>
80102628:	0f b6 c0             	movzbl %al,%eax
8010262b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010262e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102631:	25 c0 00 00 00       	and    $0xc0,%eax
80102636:	83 f8 40             	cmp    $0x40,%eax
80102639:	75 e1                	jne    8010261c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010263b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010263f:	74 11                	je     80102652 <idewait+0x3d>
80102641:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102644:	83 e0 21             	and    $0x21,%eax
80102647:	85 c0                	test   %eax,%eax
80102649:	74 07                	je     80102652 <idewait+0x3d>
    return -1;
8010264b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102650:	eb 05                	jmp    80102657 <idewait+0x42>
  return 0;
80102652:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102657:	c9                   	leave  
80102658:	c3                   	ret    

80102659 <ideinit>:

void
ideinit(void)
{
80102659:	55                   	push   %ebp
8010265a:	89 e5                	mov    %esp,%ebp
8010265c:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010265f:	c7 44 24 04 cb 83 10 	movl   $0x801083cb,0x4(%esp)
80102666:	80 
80102667:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010266e:	e8 97 27 00 00       	call   80104e0a <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102673:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80102678:	48                   	dec    %eax
80102679:	89 44 24 04          	mov    %eax,0x4(%esp)
8010267d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102684:	e8 66 04 00 00       	call   80102aef <ioapicenable>
  idewait(0);
80102689:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102690:	e8 80 ff ff ff       	call   80102615 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102695:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010269c:	00 
8010269d:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026a4:	e8 2b ff ff ff       	call   801025d4 <outb>
  for(i=0; i<1000; i++){
801026a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026b0:	eb 1f                	jmp    801026d1 <ideinit+0x78>
    if(inb(0x1f7) != 0){
801026b2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b9:	e8 d6 fe ff ff       	call   80102594 <inb>
801026be:	84 c0                	test   %al,%al
801026c0:	74 0c                	je     801026ce <ideinit+0x75>
      havedisk1 = 1;
801026c2:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
801026c9:	00 00 00 
      break;
801026cc:	eb 0c                	jmp    801026da <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801026ce:	ff 45 f4             	incl   -0xc(%ebp)
801026d1:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026d8:	7e d8                	jle    801026b2 <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026da:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801026e1:	00 
801026e2:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026e9:	e8 e6 fe ff ff       	call   801025d4 <outb>
}
801026ee:	c9                   	leave  
801026ef:	c3                   	ret    

801026f0 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801026f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026fa:	75 0c                	jne    80102708 <idestart+0x18>
    panic("idestart");
801026fc:	c7 04 24 cf 83 10 80 	movl   $0x801083cf,(%esp)
80102703:	e8 4c de ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
80102708:	8b 45 08             	mov    0x8(%ebp),%eax
8010270b:	8b 40 08             	mov    0x8(%eax),%eax
8010270e:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102713:	76 0c                	jbe    80102721 <idestart+0x31>
    panic("incorrect blockno");
80102715:	c7 04 24 d8 83 10 80 	movl   $0x801083d8,(%esp)
8010271c:	e8 33 de ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102721:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102728:	8b 45 08             	mov    0x8(%ebp),%eax
8010272b:	8b 50 08             	mov    0x8(%eax),%edx
8010272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102731:	0f af c2             	imul   %edx,%eax
80102734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102737:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010273b:	75 07                	jne    80102744 <idestart+0x54>
8010273d:	b8 20 00 00 00       	mov    $0x20,%eax
80102742:	eb 05                	jmp    80102749 <idestart+0x59>
80102744:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102749:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010274c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102750:	75 07                	jne    80102759 <idestart+0x69>
80102752:	b8 30 00 00 00       	mov    $0x30,%eax
80102757:	eb 05                	jmp    8010275e <idestart+0x6e>
80102759:	b8 c5 00 00 00       	mov    $0xc5,%eax
8010275e:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102761:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102765:	7e 0c                	jle    80102773 <idestart+0x83>
80102767:	c7 04 24 cf 83 10 80 	movl   $0x801083cf,(%esp)
8010276e:	e8 e1 dd ff ff       	call   80100554 <panic>

  idewait(0);
80102773:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010277a:	e8 96 fe ff ff       	call   80102615 <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010277f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102786:	00 
80102787:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010278e:	e8 41 fe ff ff       	call   801025d4 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
80102793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102796:	0f b6 c0             	movzbl %al,%eax
80102799:	89 44 24 04          	mov    %eax,0x4(%esp)
8010279d:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801027a4:	e8 2b fe ff ff       	call   801025d4 <outb>
  outb(0x1f3, sector & 0xff);
801027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ac:	0f b6 c0             	movzbl %al,%eax
801027af:	89 44 24 04          	mov    %eax,0x4(%esp)
801027b3:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801027ba:	e8 15 fe ff ff       	call   801025d4 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027c2:	c1 f8 08             	sar    $0x8,%eax
801027c5:	0f b6 c0             	movzbl %al,%eax
801027c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801027cc:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801027d3:	e8 fc fd ff ff       	call   801025d4 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027db:	c1 f8 10             	sar    $0x10,%eax
801027de:	0f b6 c0             	movzbl %al,%eax
801027e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e5:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801027ec:	e8 e3 fd ff ff       	call   801025d4 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027f1:	8b 45 08             	mov    0x8(%ebp),%eax
801027f4:	8b 40 04             	mov    0x4(%eax),%eax
801027f7:	83 e0 01             	and    $0x1,%eax
801027fa:	c1 e0 04             	shl    $0x4,%eax
801027fd:	88 c2                	mov    %al,%dl
801027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102802:	c1 f8 18             	sar    $0x18,%eax
80102805:	83 e0 0f             	and    $0xf,%eax
80102808:	09 d0                	or     %edx,%eax
8010280a:	83 c8 e0             	or     $0xffffffe0,%eax
8010280d:	0f b6 c0             	movzbl %al,%eax
80102810:	89 44 24 04          	mov    %eax,0x4(%esp)
80102814:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010281b:	e8 b4 fd ff ff       	call   801025d4 <outb>
  if(b->flags & B_DIRTY){
80102820:	8b 45 08             	mov    0x8(%ebp),%eax
80102823:	8b 00                	mov    (%eax),%eax
80102825:	83 e0 04             	and    $0x4,%eax
80102828:	85 c0                	test   %eax,%eax
8010282a:	74 36                	je     80102862 <idestart+0x172>
    outb(0x1f7, write_cmd);
8010282c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010282f:	0f b6 c0             	movzbl %al,%eax
80102832:	89 44 24 04          	mov    %eax,0x4(%esp)
80102836:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010283d:	e8 92 fd ff ff       	call   801025d4 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102842:	8b 45 08             	mov    0x8(%ebp),%eax
80102845:	83 c0 5c             	add    $0x5c,%eax
80102848:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010284f:	00 
80102850:	89 44 24 04          	mov    %eax,0x4(%esp)
80102854:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010285b:	e8 90 fd ff ff       	call   801025f0 <outsl>
80102860:	eb 16                	jmp    80102878 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102862:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102865:	0f b6 c0             	movzbl %al,%eax
80102868:	89 44 24 04          	mov    %eax,0x4(%esp)
8010286c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102873:	e8 5c fd ff ff       	call   801025d4 <outb>
  }
}
80102878:	c9                   	leave  
80102879:	c3                   	ret    

8010287a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010287a:	55                   	push   %ebp
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102880:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102887:	e8 9f 25 00 00       	call   80104e2b <acquire>

  if((b = idequeue) == 0){
8010288c:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102891:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102898:	75 11                	jne    801028ab <ideintr+0x31>
    release(&idelock);
8010289a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801028a1:	e8 ef 25 00 00       	call   80104e95 <release>
    return;
801028a6:	e9 90 00 00 00       	jmp    8010293b <ideintr+0xc1>
  }
  idequeue = b->qnext;
801028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ae:	8b 40 58             	mov    0x58(%eax),%eax
801028b1:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b9:	8b 00                	mov    (%eax),%eax
801028bb:	83 e0 04             	and    $0x4,%eax
801028be:	85 c0                	test   %eax,%eax
801028c0:	75 2e                	jne    801028f0 <ideintr+0x76>
801028c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028c9:	e8 47 fd ff ff       	call   80102615 <idewait>
801028ce:	85 c0                	test   %eax,%eax
801028d0:	78 1e                	js     801028f0 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d5:	83 c0 5c             	add    $0x5c,%eax
801028d8:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801028df:	00 
801028e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801028e4:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801028eb:	e8 bf fc ff ff       	call   801025af <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f3:	8b 00                	mov    (%eax),%eax
801028f5:	83 c8 02             	or     $0x2,%eax
801028f8:	89 c2                	mov    %eax,%edx
801028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fd:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102902:	8b 00                	mov    (%eax),%eax
80102904:	83 e0 fb             	and    $0xfffffffb,%eax
80102907:	89 c2                	mov    %eax,%edx
80102909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290c:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102911:	89 04 24             	mov    %eax,(%esp)
80102914:	e8 17 22 00 00       	call   80104b30 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102919:	a1 14 b6 10 80       	mov    0x8010b614,%eax
8010291e:	85 c0                	test   %eax,%eax
80102920:	74 0d                	je     8010292f <ideintr+0xb5>
    idestart(idequeue);
80102922:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102927:	89 04 24             	mov    %eax,(%esp)
8010292a:	e8 c1 fd ff ff       	call   801026f0 <idestart>

  release(&idelock);
8010292f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102936:	e8 5a 25 00 00       	call   80104e95 <release>
}
8010293b:	c9                   	leave  
8010293c:	c3                   	ret    

8010293d <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010293d:	55                   	push   %ebp
8010293e:	89 e5                	mov    %esp,%ebp
80102940:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102943:	8b 45 08             	mov    0x8(%ebp),%eax
80102946:	83 c0 0c             	add    $0xc,%eax
80102949:	89 04 24             	mov    %eax,(%esp)
8010294c:	e8 52 24 00 00       	call   80104da3 <holdingsleep>
80102951:	85 c0                	test   %eax,%eax
80102953:	75 0c                	jne    80102961 <iderw+0x24>
    panic("iderw: buf not locked");
80102955:	c7 04 24 ea 83 10 80 	movl   $0x801083ea,(%esp)
8010295c:	e8 f3 db ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	8b 00                	mov    (%eax),%eax
80102966:	83 e0 06             	and    $0x6,%eax
80102969:	83 f8 02             	cmp    $0x2,%eax
8010296c:	75 0c                	jne    8010297a <iderw+0x3d>
    panic("iderw: nothing to do");
8010296e:	c7 04 24 00 84 10 80 	movl   $0x80108400,(%esp)
80102975:	e8 da db ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
8010297a:	8b 45 08             	mov    0x8(%ebp),%eax
8010297d:	8b 40 04             	mov    0x4(%eax),%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	74 15                	je     80102999 <iderw+0x5c>
80102984:	a1 18 b6 10 80       	mov    0x8010b618,%eax
80102989:	85 c0                	test   %eax,%eax
8010298b:	75 0c                	jne    80102999 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
8010298d:	c7 04 24 15 84 10 80 	movl   $0x80108415,(%esp)
80102994:	e8 bb db ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102999:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801029a0:	e8 86 24 00 00       	call   80104e2b <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801029a5:	8b 45 08             	mov    0x8(%ebp),%eax
801029a8:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029af:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
801029b6:	eb 0b                	jmp    801029c3 <iderw+0x86>
801029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029bb:	8b 00                	mov    (%eax),%eax
801029bd:	83 c0 58             	add    $0x58,%eax
801029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c6:	8b 00                	mov    (%eax),%eax
801029c8:	85 c0                	test   %eax,%eax
801029ca:	75 ec                	jne    801029b8 <iderw+0x7b>
    ;
  *pp = b;
801029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029cf:	8b 55 08             	mov    0x8(%ebp),%edx
801029d2:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029d4:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801029d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801029dc:	75 0d                	jne    801029eb <iderw+0xae>
    idestart(b);
801029de:	8b 45 08             	mov    0x8(%ebp),%eax
801029e1:	89 04 24             	mov    %eax,(%esp)
801029e4:	e8 07 fd ff ff       	call   801026f0 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029e9:	eb 15                	jmp    80102a00 <iderw+0xc3>
801029eb:	eb 13                	jmp    80102a00 <iderw+0xc3>
    sleep(b, &idelock);
801029ed:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
801029f4:	80 
801029f5:	8b 45 08             	mov    0x8(%ebp),%eax
801029f8:	89 04 24             	mov    %eax,(%esp)
801029fb:	e8 5c 20 00 00       	call   80104a5c <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a00:	8b 45 08             	mov    0x8(%ebp),%eax
80102a03:	8b 00                	mov    (%eax),%eax
80102a05:	83 e0 06             	and    $0x6,%eax
80102a08:	83 f8 02             	cmp    $0x2,%eax
80102a0b:	75 e0                	jne    801029ed <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102a0d:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102a14:	e8 7c 24 00 00       	call   80104e95 <release>
}
80102a19:	c9                   	leave  
80102a1a:	c3                   	ret    
	...

80102a1c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a1c:	55                   	push   %ebp
80102a1d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a1f:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102a24:	8b 55 08             	mov    0x8(%ebp),%edx
80102a27:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a29:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102a2e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a31:	5d                   	pop    %ebp
80102a32:	c3                   	ret    

80102a33 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a33:	55                   	push   %ebp
80102a34:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a36:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102a3b:	8b 55 08             	mov    0x8(%ebp),%edx
80102a3e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a40:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102a45:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a48:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a4b:	5d                   	pop    %ebp
80102a4c:	c3                   	ret    

80102a4d <ioapicinit>:

void
ioapicinit(void)
{
80102a4d:	55                   	push   %ebp
80102a4e:	89 e5                	mov    %esp,%ebp
80102a50:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a53:	c7 05 f4 38 11 80 00 	movl   $0xfec00000,0x801138f4
80102a5a:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a64:	e8 b3 ff ff ff       	call   80102a1c <ioapicread>
80102a69:	c1 e8 10             	shr    $0x10,%eax
80102a6c:	25 ff 00 00 00       	and    $0xff,%eax
80102a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a7b:	e8 9c ff ff ff       	call   80102a1c <ioapicread>
80102a80:	c1 e8 18             	shr    $0x18,%eax
80102a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a86:	a0 20 3a 11 80       	mov    0x80113a20,%al
80102a8b:	0f b6 c0             	movzbl %al,%eax
80102a8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a91:	74 0c                	je     80102a9f <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a93:	c7 04 24 34 84 10 80 	movl   $0x80108434,(%esp)
80102a9a:	e8 22 d9 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102aa6:	eb 3d                	jmp    80102ae5 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aab:	83 c0 20             	add    $0x20,%eax
80102aae:	0d 00 00 01 00       	or     $0x10000,%eax
80102ab3:	89 c2                	mov    %eax,%edx
80102ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab8:	83 c0 08             	add    $0x8,%eax
80102abb:	01 c0                	add    %eax,%eax
80102abd:	89 54 24 04          	mov    %edx,0x4(%esp)
80102ac1:	89 04 24             	mov    %eax,(%esp)
80102ac4:	e8 6a ff ff ff       	call   80102a33 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acc:	83 c0 08             	add    $0x8,%eax
80102acf:	01 c0                	add    %eax,%eax
80102ad1:	40                   	inc    %eax
80102ad2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ad9:	00 
80102ada:	89 04 24             	mov    %eax,(%esp)
80102add:	e8 51 ff ff ff       	call   80102a33 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ae2:	ff 45 f4             	incl   -0xc(%ebp)
80102ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102aeb:	7e bb                	jle    80102aa8 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102aed:	c9                   	leave  
80102aee:	c3                   	ret    

80102aef <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aef:	55                   	push   %ebp
80102af0:	89 e5                	mov    %esp,%ebp
80102af2:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102af5:	8b 45 08             	mov    0x8(%ebp),%eax
80102af8:	83 c0 20             	add    $0x20,%eax
80102afb:	89 c2                	mov    %eax,%edx
80102afd:	8b 45 08             	mov    0x8(%ebp),%eax
80102b00:	83 c0 08             	add    $0x8,%eax
80102b03:	01 c0                	add    %eax,%eax
80102b05:	89 54 24 04          	mov    %edx,0x4(%esp)
80102b09:	89 04 24             	mov    %eax,(%esp)
80102b0c:	e8 22 ff ff ff       	call   80102a33 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b11:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b14:	c1 e0 18             	shl    $0x18,%eax
80102b17:	8b 55 08             	mov    0x8(%ebp),%edx
80102b1a:	83 c2 08             	add    $0x8,%edx
80102b1d:	01 d2                	add    %edx,%edx
80102b1f:	42                   	inc    %edx
80102b20:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b24:	89 14 24             	mov    %edx,(%esp)
80102b27:	e8 07 ff ff ff       	call   80102a33 <ioapicwrite>
}
80102b2c:	c9                   	leave  
80102b2d:	c3                   	ret    
	...

80102b30 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102b36:	c7 44 24 04 66 84 10 	movl   $0x80108466,0x4(%esp)
80102b3d:	80 
80102b3e:	c7 04 24 00 39 11 80 	movl   $0x80113900,(%esp)
80102b45:	e8 c0 22 00 00       	call   80104e0a <initlock>
  kmem.use_lock = 0;
80102b4a:	c7 05 34 39 11 80 00 	movl   $0x0,0x80113934
80102b51:	00 00 00 
  freerange(vstart, vend);
80102b54:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5e:	89 04 24             	mov    %eax,(%esp)
80102b61:	e8 26 00 00 00       	call   80102b8c <freerange>
}
80102b66:	c9                   	leave  
80102b67:	c3                   	ret    

80102b68 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b68:	55                   	push   %ebp
80102b69:	89 e5                	mov    %esp,%ebp
80102b6b:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b75:	8b 45 08             	mov    0x8(%ebp),%eax
80102b78:	89 04 24             	mov    %eax,(%esp)
80102b7b:	e8 0c 00 00 00       	call   80102b8c <freerange>
  kmem.use_lock = 1;
80102b80:	c7 05 34 39 11 80 01 	movl   $0x1,0x80113934
80102b87:	00 00 00 
}
80102b8a:	c9                   	leave  
80102b8b:	c3                   	ret    

80102b8c <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b8c:	55                   	push   %ebp
80102b8d:	89 e5                	mov    %esp,%ebp
80102b8f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b92:	8b 45 08             	mov    0x8(%ebp),%eax
80102b95:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ba2:	eb 12                	jmp    80102bb6 <freerange+0x2a>
    kfree(p);
80102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba7:	89 04 24             	mov    %eax,(%esp)
80102baa:	e8 16 00 00 00       	call   80102bc5 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102baf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb9:	05 00 10 00 00       	add    $0x1000,%eax
80102bbe:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102bc1:	76 e1                	jbe    80102ba4 <freerange+0x18>
    kfree(p);
}
80102bc3:	c9                   	leave  
80102bc4:	c3                   	ret    

80102bc5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bc5:	55                   	push   %ebp
80102bc6:	89 e5                	mov    %esp,%ebp
80102bc8:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bce:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bd3:	85 c0                	test   %eax,%eax
80102bd5:	75 18                	jne    80102bef <kfree+0x2a>
80102bd7:	81 7d 08 68 67 11 80 	cmpl   $0x80116768,0x8(%ebp)
80102bde:	72 0f                	jb     80102bef <kfree+0x2a>
80102be0:	8b 45 08             	mov    0x8(%ebp),%eax
80102be3:	05 00 00 00 80       	add    $0x80000000,%eax
80102be8:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bed:	76 0c                	jbe    80102bfb <kfree+0x36>
    panic("kfree");
80102bef:	c7 04 24 6b 84 10 80 	movl   $0x8010846b,(%esp)
80102bf6:	e8 59 d9 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bfb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102c02:	00 
80102c03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102c0a:	00 
80102c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0e:	89 04 24             	mov    %eax,(%esp)
80102c11:	e8 78 24 00 00       	call   8010508e <memset>

  if(kmem.use_lock)
80102c16:	a1 34 39 11 80       	mov    0x80113934,%eax
80102c1b:	85 c0                	test   %eax,%eax
80102c1d:	74 0c                	je     80102c2b <kfree+0x66>
    acquire(&kmem.lock);
80102c1f:	c7 04 24 00 39 11 80 	movl   $0x80113900,(%esp)
80102c26:	e8 00 22 00 00       	call   80104e2b <acquire>
  r = (struct run*)v;
80102c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c31:	8b 15 38 39 11 80    	mov    0x80113938,%edx
80102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3f:	a3 38 39 11 80       	mov    %eax,0x80113938
  if(kmem.use_lock)
80102c44:	a1 34 39 11 80       	mov    0x80113934,%eax
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	74 0c                	je     80102c59 <kfree+0x94>
    release(&kmem.lock);
80102c4d:	c7 04 24 00 39 11 80 	movl   $0x80113900,(%esp)
80102c54:	e8 3c 22 00 00       	call   80104e95 <release>
}
80102c59:	c9                   	leave  
80102c5a:	c3                   	ret    

80102c5b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c5b:	55                   	push   %ebp
80102c5c:	89 e5                	mov    %esp,%ebp
80102c5e:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102c61:	a1 34 39 11 80       	mov    0x80113934,%eax
80102c66:	85 c0                	test   %eax,%eax
80102c68:	74 0c                	je     80102c76 <kalloc+0x1b>
    acquire(&kmem.lock);
80102c6a:	c7 04 24 00 39 11 80 	movl   $0x80113900,(%esp)
80102c71:	e8 b5 21 00 00       	call   80104e2b <acquire>
  r = kmem.freelist;
80102c76:	a1 38 39 11 80       	mov    0x80113938,%eax
80102c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c82:	74 0a                	je     80102c8e <kalloc+0x33>
    kmem.freelist = r->next;
80102c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c87:	8b 00                	mov    (%eax),%eax
80102c89:	a3 38 39 11 80       	mov    %eax,0x80113938
  if(kmem.use_lock)
80102c8e:	a1 34 39 11 80       	mov    0x80113934,%eax
80102c93:	85 c0                	test   %eax,%eax
80102c95:	74 0c                	je     80102ca3 <kalloc+0x48>
    release(&kmem.lock);
80102c97:	c7 04 24 00 39 11 80 	movl   $0x80113900,(%esp)
80102c9e:	e8 f2 21 00 00       	call   80104e95 <release>
  return (char*)r;
80102ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ca6:	c9                   	leave  
80102ca7:	c3                   	ret    

80102ca8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ca8:	55                   	push   %ebp
80102ca9:	89 e5                	mov    %esp,%ebp
80102cab:	83 ec 14             	sub    $0x14,%esp
80102cae:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102cb8:	89 c2                	mov    %eax,%edx
80102cba:	ec                   	in     (%dx),%al
80102cbb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cbe:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102cc1:	c9                   	leave  
80102cc2:	c3                   	ret    

80102cc3 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cc3:	55                   	push   %ebp
80102cc4:	89 e5                	mov    %esp,%ebp
80102cc6:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cc9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102cd0:	e8 d3 ff ff ff       	call   80102ca8 <inb>
80102cd5:	0f b6 c0             	movzbl %al,%eax
80102cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cde:	83 e0 01             	and    $0x1,%eax
80102ce1:	85 c0                	test   %eax,%eax
80102ce3:	75 0a                	jne    80102cef <kbdgetc+0x2c>
    return -1;
80102ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cea:	e9 21 01 00 00       	jmp    80102e10 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102cef:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102cf6:	e8 ad ff ff ff       	call   80102ca8 <inb>
80102cfb:	0f b6 c0             	movzbl %al,%eax
80102cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d01:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d08:	75 17                	jne    80102d21 <kbdgetc+0x5e>
    shift |= E0ESC;
80102d0a:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d0f:	83 c8 40             	or     $0x40,%eax
80102d12:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102d17:	b8 00 00 00 00       	mov    $0x0,%eax
80102d1c:	e9 ef 00 00 00       	jmp    80102e10 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d24:	25 80 00 00 00       	and    $0x80,%eax
80102d29:	85 c0                	test   %eax,%eax
80102d2b:	74 44                	je     80102d71 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d2d:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d32:	83 e0 40             	and    $0x40,%eax
80102d35:	85 c0                	test   %eax,%eax
80102d37:	75 08                	jne    80102d41 <kbdgetc+0x7e>
80102d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d3c:	83 e0 7f             	and    $0x7f,%eax
80102d3f:	eb 03                	jmp    80102d44 <kbdgetc+0x81>
80102d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d4a:	05 20 90 10 80       	add    $0x80109020,%eax
80102d4f:	8a 00                	mov    (%eax),%al
80102d51:	83 c8 40             	or     $0x40,%eax
80102d54:	0f b6 c0             	movzbl %al,%eax
80102d57:	f7 d0                	not    %eax
80102d59:	89 c2                	mov    %eax,%edx
80102d5b:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d60:	21 d0                	and    %edx,%eax
80102d62:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102d67:	b8 00 00 00 00       	mov    $0x0,%eax
80102d6c:	e9 9f 00 00 00       	jmp    80102e10 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d71:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d76:	83 e0 40             	and    $0x40,%eax
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	74 14                	je     80102d91 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d7d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d84:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d89:	83 e0 bf             	and    $0xffffffbf,%eax
80102d8c:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d94:	05 20 90 10 80       	add    $0x80109020,%eax
80102d99:	8a 00                	mov    (%eax),%al
80102d9b:	0f b6 d0             	movzbl %al,%edx
80102d9e:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102da3:	09 d0                	or     %edx,%eax
80102da5:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dad:	05 20 91 10 80       	add    $0x80109120,%eax
80102db2:	8a 00                	mov    (%eax),%al
80102db4:	0f b6 d0             	movzbl %al,%edx
80102db7:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102dbc:	31 d0                	xor    %edx,%eax
80102dbe:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102dc3:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102dc8:	83 e0 03             	and    $0x3,%eax
80102dcb:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd5:	01 d0                	add    %edx,%eax
80102dd7:	8a 00                	mov    (%eax),%al
80102dd9:	0f b6 c0             	movzbl %al,%eax
80102ddc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ddf:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102de4:	83 e0 08             	and    $0x8,%eax
80102de7:	85 c0                	test   %eax,%eax
80102de9:	74 22                	je     80102e0d <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102deb:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102def:	76 0c                	jbe    80102dfd <kbdgetc+0x13a>
80102df1:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102df5:	77 06                	ja     80102dfd <kbdgetc+0x13a>
      c += 'A' - 'a';
80102df7:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dfb:	eb 10                	jmp    80102e0d <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102dfd:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e01:	76 0a                	jbe    80102e0d <kbdgetc+0x14a>
80102e03:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e07:	77 04                	ja     80102e0d <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e09:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e10:	c9                   	leave  
80102e11:	c3                   	ret    

80102e12 <kbdintr>:

void
kbdintr(void)
{
80102e12:	55                   	push   %ebp
80102e13:	89 e5                	mov    %esp,%ebp
80102e15:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102e18:	c7 04 24 c3 2c 10 80 	movl   $0x80102cc3,(%esp)
80102e1f:	e8 d1 d9 ff ff       	call   801007f5 <consoleintr>
}
80102e24:	c9                   	leave  
80102e25:	c3                   	ret    
	...

80102e28 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e28:	55                   	push   %ebp
80102e29:	89 e5                	mov    %esp,%ebp
80102e2b:	83 ec 14             	sub    $0x14,%esp
80102e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102e31:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e38:	89 c2                	mov    %eax,%edx
80102e3a:	ec                   	in     (%dx),%al
80102e3b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e3e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102e41:	c9                   	leave  
80102e42:	c3                   	ret    

80102e43 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e43:	55                   	push   %ebp
80102e44:	89 e5                	mov    %esp,%ebp
80102e46:	83 ec 08             	sub    $0x8,%esp
80102e49:	8b 45 08             	mov    0x8(%ebp),%eax
80102e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e4f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e53:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e56:	8a 45 f8             	mov    -0x8(%ebp),%al
80102e59:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102e5c:	ee                   	out    %al,(%dx)
}
80102e5d:	c9                   	leave  
80102e5e:	c3                   	ret    

80102e5f <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102e5f:	55                   	push   %ebp
80102e60:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e62:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102e67:	8b 55 08             	mov    0x8(%ebp),%edx
80102e6a:	c1 e2 02             	shl    $0x2,%edx
80102e6d:	01 c2                	add    %eax,%edx
80102e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e72:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e74:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102e79:	83 c0 20             	add    $0x20,%eax
80102e7c:	8b 00                	mov    (%eax),%eax
}
80102e7e:	5d                   	pop    %ebp
80102e7f:	c3                   	ret    

80102e80 <lapicinit>:

void
lapicinit(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102e86:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102e8b:	85 c0                	test   %eax,%eax
80102e8d:	75 05                	jne    80102e94 <lapicinit+0x14>
    return;
80102e8f:	e9 43 01 00 00       	jmp    80102fd7 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e94:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e9b:	00 
80102e9c:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102ea3:	e8 b7 ff ff ff       	call   80102e5f <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ea8:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102eaf:	00 
80102eb0:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102eb7:	e8 a3 ff ff ff       	call   80102e5f <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102ebc:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102ec3:	00 
80102ec4:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ecb:	e8 8f ff ff ff       	call   80102e5f <lapicw>
  lapicw(TICR, 10000000);
80102ed0:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102ed7:	00 
80102ed8:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102edf:	e8 7b ff ff ff       	call   80102e5f <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ee4:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eeb:	00 
80102eec:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102ef3:	e8 67 ff ff ff       	call   80102e5f <lapicw>
  lapicw(LINT1, MASKED);
80102ef8:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eff:	00 
80102f00:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102f07:	e8 53 ff ff ff       	call   80102e5f <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f0c:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102f11:	83 c0 30             	add    $0x30,%eax
80102f14:	8b 00                	mov    (%eax),%eax
80102f16:	c1 e8 10             	shr    $0x10,%eax
80102f19:	0f b6 c0             	movzbl %al,%eax
80102f1c:	83 f8 03             	cmp    $0x3,%eax
80102f1f:	76 14                	jbe    80102f35 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102f21:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f28:	00 
80102f29:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102f30:	e8 2a ff ff ff       	call   80102e5f <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f35:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102f3c:	00 
80102f3d:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102f44:	e8 16 ff ff ff       	call   80102e5f <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f50:	00 
80102f51:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f58:	e8 02 ff ff ff       	call   80102e5f <lapicw>
  lapicw(ESR, 0);
80102f5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f64:	00 
80102f65:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f6c:	e8 ee fe ff ff       	call   80102e5f <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f78:	00 
80102f79:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f80:	e8 da fe ff ff       	call   80102e5f <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f8c:	00 
80102f8d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f94:	e8 c6 fe ff ff       	call   80102e5f <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f99:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102fa0:	00 
80102fa1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa8:	e8 b2 fe ff ff       	call   80102e5f <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102fad:	90                   	nop
80102fae:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102fb3:	05 00 03 00 00       	add    $0x300,%eax
80102fb8:	8b 00                	mov    (%eax),%eax
80102fba:	25 00 10 00 00       	and    $0x1000,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 eb                	jne    80102fae <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fc3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fca:	00 
80102fcb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102fd2:	e8 88 fe ff ff       	call   80102e5f <lapicw>
}
80102fd7:	c9                   	leave  
80102fd8:	c3                   	ret    

80102fd9 <lapicid>:

int
lapicid(void)
{
80102fd9:	55                   	push   %ebp
80102fda:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fdc:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102fe1:	85 c0                	test   %eax,%eax
80102fe3:	75 07                	jne    80102fec <lapicid+0x13>
    return 0;
80102fe5:	b8 00 00 00 00       	mov    $0x0,%eax
80102fea:	eb 0d                	jmp    80102ff9 <lapicid+0x20>
  return lapic[ID] >> 24;
80102fec:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80102ff1:	83 c0 20             	add    $0x20,%eax
80102ff4:	8b 00                	mov    (%eax),%eax
80102ff6:	c1 e8 18             	shr    $0x18,%eax
}
80102ff9:	5d                   	pop    %ebp
80102ffa:	c3                   	ret    

80102ffb <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ffb:	55                   	push   %ebp
80102ffc:	89 e5                	mov    %esp,%ebp
80102ffe:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103001:	a1 3c 39 11 80       	mov    0x8011393c,%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	74 14                	je     8010301e <lapiceoi+0x23>
    lapicw(EOI, 0);
8010300a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103011:	00 
80103012:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103019:	e8 41 fe ff ff       	call   80102e5f <lapicw>
}
8010301e:	c9                   	leave  
8010301f:	c3                   	ret    

80103020 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
}
80103023:	5d                   	pop    %ebp
80103024:	c3                   	ret    

80103025 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103025:	55                   	push   %ebp
80103026:	89 e5                	mov    %esp,%ebp
80103028:	83 ec 1c             	sub    $0x1c,%esp
8010302b:	8b 45 08             	mov    0x8(%ebp),%eax
8010302e:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103031:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103038:	00 
80103039:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103040:	e8 fe fd ff ff       	call   80102e43 <outb>
  outb(CMOS_PORT+1, 0x0A);
80103045:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010304c:	00 
8010304d:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103054:	e8 ea fd ff ff       	call   80102e43 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103059:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103060:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103063:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103068:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010306b:	8d 50 02             	lea    0x2(%eax),%edx
8010306e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103071:	c1 e8 04             	shr    $0x4,%eax
80103074:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103077:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010307b:	c1 e0 18             	shl    $0x18,%eax
8010307e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103082:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103089:	e8 d1 fd ff ff       	call   80102e5f <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010308e:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103095:	00 
80103096:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010309d:	e8 bd fd ff ff       	call   80102e5f <lapicw>
  microdelay(200);
801030a2:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030a9:	e8 72 ff ff ff       	call   80103020 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801030ae:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801030b5:	00 
801030b6:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030bd:	e8 9d fd ff ff       	call   80102e5f <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030c2:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801030c9:	e8 52 ff ff ff       	call   80103020 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030d5:	eb 3f                	jmp    80103116 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
801030d7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030db:	c1 e0 18             	shl    $0x18,%eax
801030de:	89 44 24 04          	mov    %eax,0x4(%esp)
801030e2:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030e9:	e8 71 fd ff ff       	call   80102e5f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801030f1:	c1 e8 0c             	shr    $0xc,%eax
801030f4:	80 cc 06             	or     $0x6,%ah
801030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801030fb:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103102:	e8 58 fd ff ff       	call   80102e5f <lapicw>
    microdelay(200);
80103107:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010310e:	e8 0d ff ff ff       	call   80103020 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103113:	ff 45 fc             	incl   -0x4(%ebp)
80103116:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010311a:	7e bb                	jle    801030d7 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    

8010311e <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010311e:	55                   	push   %ebp
8010311f:	89 e5                	mov    %esp,%ebp
80103121:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103124:	8b 45 08             	mov    0x8(%ebp),%eax
80103127:	0f b6 c0             	movzbl %al,%eax
8010312a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010312e:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103135:	e8 09 fd ff ff       	call   80102e43 <outb>
  microdelay(200);
8010313a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103141:	e8 da fe ff ff       	call   80103020 <microdelay>

  return inb(CMOS_RETURN);
80103146:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010314d:	e8 d6 fc ff ff       	call   80102e28 <inb>
80103152:	0f b6 c0             	movzbl %al,%eax
}
80103155:	c9                   	leave  
80103156:	c3                   	ret    

80103157 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103157:	55                   	push   %ebp
80103158:	89 e5                	mov    %esp,%ebp
8010315a:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
8010315d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103164:	e8 b5 ff ff ff       	call   8010311e <cmos_read>
80103169:	8b 55 08             	mov    0x8(%ebp),%edx
8010316c:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010316e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103175:	e8 a4 ff ff ff       	call   8010311e <cmos_read>
8010317a:	8b 55 08             	mov    0x8(%ebp),%edx
8010317d:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103180:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103187:	e8 92 ff ff ff       	call   8010311e <cmos_read>
8010318c:	8b 55 08             	mov    0x8(%ebp),%edx
8010318f:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103192:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103199:	e8 80 ff ff ff       	call   8010311e <cmos_read>
8010319e:	8b 55 08             	mov    0x8(%ebp),%edx
801031a1:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801031a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801031ab:	e8 6e ff ff ff       	call   8010311e <cmos_read>
801031b0:	8b 55 08             	mov    0x8(%ebp),%edx
801031b3:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801031b6:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801031bd:	e8 5c ff ff ff       	call   8010311e <cmos_read>
801031c2:	8b 55 08             	mov    0x8(%ebp),%edx
801031c5:	89 42 14             	mov    %eax,0x14(%edx)
}
801031c8:	c9                   	leave  
801031c9:	c3                   	ret    

801031ca <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031ca:	55                   	push   %ebp
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	57                   	push   %edi
801031ce:	56                   	push   %esi
801031cf:	53                   	push   %ebx
801031d0:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031d3:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801031da:	e8 3f ff ff ff       	call   8010311e <cmos_read>
801031df:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031e5:	83 e0 04             	and    $0x4,%eax
801031e8:	85 c0                	test   %eax,%eax
801031ea:	0f 94 c0             	sete   %al
801031ed:	0f b6 c0             	movzbl %al,%eax
801031f0:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031f3:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031f6:	89 04 24             	mov    %eax,(%esp)
801031f9:	e8 59 ff ff ff       	call   80103157 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031fe:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103205:	e8 14 ff ff ff       	call   8010311e <cmos_read>
8010320a:	25 80 00 00 00       	and    $0x80,%eax
8010320f:	85 c0                	test   %eax,%eax
80103211:	74 02                	je     80103215 <cmostime+0x4b>
        continue;
80103213:	eb 36                	jmp    8010324b <cmostime+0x81>
    fill_rtcdate(&t2);
80103215:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103218:	89 04 24             	mov    %eax,(%esp)
8010321b:	e8 37 ff ff ff       	call   80103157 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103220:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103227:	00 
80103228:	8d 45 b0             	lea    -0x50(%ebp),%eax
8010322b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010322f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103232:	89 04 24             	mov    %eax,(%esp)
80103235:	e8 cb 1e 00 00       	call   80105105 <memcmp>
8010323a:	85 c0                	test   %eax,%eax
8010323c:	75 0d                	jne    8010324b <cmostime+0x81>
      break;
8010323e:	90                   	nop
  }

  // convert
  if(bcd) {
8010323f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80103243:	0f 84 ac 00 00 00    	je     801032f5 <cmostime+0x12b>
80103249:	eb 02                	jmp    8010324d <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010324b:	eb a6                	jmp    801031f3 <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010324d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103250:	c1 e8 04             	shr    $0x4,%eax
80103253:	89 c2                	mov    %eax,%edx
80103255:	89 d0                	mov    %edx,%eax
80103257:	c1 e0 02             	shl    $0x2,%eax
8010325a:	01 d0                	add    %edx,%eax
8010325c:	01 c0                	add    %eax,%eax
8010325e:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103261:	83 e2 0f             	and    $0xf,%edx
80103264:	01 d0                	add    %edx,%eax
80103266:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103269:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010326c:	c1 e8 04             	shr    $0x4,%eax
8010326f:	89 c2                	mov    %eax,%edx
80103271:	89 d0                	mov    %edx,%eax
80103273:	c1 e0 02             	shl    $0x2,%eax
80103276:	01 d0                	add    %edx,%eax
80103278:	01 c0                	add    %eax,%eax
8010327a:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010327d:	83 e2 0f             	and    $0xf,%edx
80103280:	01 d0                	add    %edx,%eax
80103282:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103285:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103288:	c1 e8 04             	shr    $0x4,%eax
8010328b:	89 c2                	mov    %eax,%edx
8010328d:	89 d0                	mov    %edx,%eax
8010328f:	c1 e0 02             	shl    $0x2,%eax
80103292:	01 d0                	add    %edx,%eax
80103294:	01 c0                	add    %eax,%eax
80103296:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103299:	83 e2 0f             	and    $0xf,%edx
8010329c:	01 d0                	add    %edx,%eax
8010329e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
801032a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801032a4:	c1 e8 04             	shr    $0x4,%eax
801032a7:	89 c2                	mov    %eax,%edx
801032a9:	89 d0                	mov    %edx,%eax
801032ab:	c1 e0 02             	shl    $0x2,%eax
801032ae:	01 d0                	add    %edx,%eax
801032b0:	01 c0                	add    %eax,%eax
801032b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801032b5:	83 e2 0f             	and    $0xf,%edx
801032b8:	01 d0                	add    %edx,%eax
801032ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
801032bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032c0:	c1 e8 04             	shr    $0x4,%eax
801032c3:	89 c2                	mov    %eax,%edx
801032c5:	89 d0                	mov    %edx,%eax
801032c7:	c1 e0 02             	shl    $0x2,%eax
801032ca:	01 d0                	add    %edx,%eax
801032cc:	01 c0                	add    %eax,%eax
801032ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032d1:	83 e2 0f             	and    $0xf,%edx
801032d4:	01 d0                	add    %edx,%eax
801032d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
801032d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032dc:	c1 e8 04             	shr    $0x4,%eax
801032df:	89 c2                	mov    %eax,%edx
801032e1:	89 d0                	mov    %edx,%eax
801032e3:	c1 e0 02             	shl    $0x2,%eax
801032e6:	01 d0                	add    %edx,%eax
801032e8:	01 c0                	add    %eax,%eax
801032ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032ed:	83 e2 0f             	and    $0xf,%edx
801032f0:	01 d0                	add    %edx,%eax
801032f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
801032f5:	8b 45 08             	mov    0x8(%ebp),%eax
801032f8:	89 c2                	mov    %eax,%edx
801032fa:	8d 5d c8             	lea    -0x38(%ebp),%ebx
801032fd:	b8 06 00 00 00       	mov    $0x6,%eax
80103302:	89 d7                	mov    %edx,%edi
80103304:	89 de                	mov    %ebx,%esi
80103306:	89 c1                	mov    %eax,%ecx
80103308:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010330a:	8b 45 08             	mov    0x8(%ebp),%eax
8010330d:	8b 40 14             	mov    0x14(%eax),%eax
80103310:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103316:	8b 45 08             	mov    0x8(%ebp),%eax
80103319:	89 50 14             	mov    %edx,0x14(%eax)
}
8010331c:	83 c4 5c             	add    $0x5c,%esp
8010331f:	5b                   	pop    %ebx
80103320:	5e                   	pop    %esi
80103321:	5f                   	pop    %edi
80103322:	5d                   	pop    %ebp
80103323:	c3                   	ret    

80103324 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103324:	55                   	push   %ebp
80103325:	89 e5                	mov    %esp,%ebp
80103327:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010332a:	c7 44 24 04 71 84 10 	movl   $0x80108471,0x4(%esp)
80103331:	80 
80103332:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103339:	e8 cc 1a 00 00       	call   80104e0a <initlock>
  readsb(dev, &sb);
8010333e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103341:	89 44 24 04          	mov    %eax,0x4(%esp)
80103345:	8b 45 08             	mov    0x8(%ebp),%eax
80103348:	89 04 24             	mov    %eax,(%esp)
8010334b:	e8 d8 e0 ff ff       	call   80101428 <readsb>
  log.start = sb.logstart;
80103350:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103353:	a3 74 39 11 80       	mov    %eax,0x80113974
  log.size = sb.nlog;
80103358:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010335b:	a3 78 39 11 80       	mov    %eax,0x80113978
  log.dev = dev;
80103360:	8b 45 08             	mov    0x8(%ebp),%eax
80103363:	a3 84 39 11 80       	mov    %eax,0x80113984
  recover_from_log();
80103368:	e8 95 01 00 00       	call   80103502 <recover_from_log>
}
8010336d:	c9                   	leave  
8010336e:	c3                   	ret    

8010336f <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010336f:	55                   	push   %ebp
80103370:	89 e5                	mov    %esp,%ebp
80103372:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103375:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010337c:	e9 89 00 00 00       	jmp    8010340a <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103381:	8b 15 74 39 11 80    	mov    0x80113974,%edx
80103387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010338a:	01 d0                	add    %edx,%eax
8010338c:	40                   	inc    %eax
8010338d:	89 c2                	mov    %eax,%edx
8010338f:	a1 84 39 11 80       	mov    0x80113984,%eax
80103394:	89 54 24 04          	mov    %edx,0x4(%esp)
80103398:	89 04 24             	mov    %eax,(%esp)
8010339b:	e8 15 ce ff ff       	call   801001b5 <bread>
801033a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033a6:	83 c0 10             	add    $0x10,%eax
801033a9:	8b 04 85 4c 39 11 80 	mov    -0x7feec6b4(,%eax,4),%eax
801033b0:	89 c2                	mov    %eax,%edx
801033b2:	a1 84 39 11 80       	mov    0x80113984,%eax
801033b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801033bb:	89 04 24             	mov    %eax,(%esp)
801033be:	e8 f2 cd ff ff       	call   801001b5 <bread>
801033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c9:	8d 50 5c             	lea    0x5c(%eax),%edx
801033cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033cf:	83 c0 5c             	add    $0x5c,%eax
801033d2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033d9:	00 
801033da:	89 54 24 04          	mov    %edx,0x4(%esp)
801033de:	89 04 24             	mov    %eax,(%esp)
801033e1:	e8 71 1d 00 00       	call   80105157 <memmove>
    bwrite(dbuf);  // write dst to disk
801033e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e9:	89 04 24             	mov    %eax,(%esp)
801033ec:	e8 fb cd ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801033f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f4:	89 04 24             	mov    %eax,(%esp)
801033f7:	e8 30 ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
801033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033ff:	89 04 24             	mov    %eax,(%esp)
80103402:	e8 25 ce ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103407:	ff 45 f4             	incl   -0xc(%ebp)
8010340a:	a1 88 39 11 80       	mov    0x80113988,%eax
8010340f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103412:	0f 8f 69 ff ff ff    	jg     80103381 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103418:	c9                   	leave  
80103419:	c3                   	ret    

8010341a <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010341a:	55                   	push   %ebp
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103420:	a1 74 39 11 80       	mov    0x80113974,%eax
80103425:	89 c2                	mov    %eax,%edx
80103427:	a1 84 39 11 80       	mov    0x80113984,%eax
8010342c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103430:	89 04 24             	mov    %eax,(%esp)
80103433:	e8 7d cd ff ff       	call   801001b5 <bread>
80103438:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010343b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010343e:	83 c0 5c             	add    $0x5c,%eax
80103441:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103444:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103447:	8b 00                	mov    (%eax),%eax
80103449:	a3 88 39 11 80       	mov    %eax,0x80113988
  for (i = 0; i < log.lh.n; i++) {
8010344e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103455:	eb 1a                	jmp    80103471 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
80103457:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010345d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103461:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103464:	83 c2 10             	add    $0x10,%edx
80103467:	89 04 95 4c 39 11 80 	mov    %eax,-0x7feec6b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010346e:	ff 45 f4             	incl   -0xc(%ebp)
80103471:	a1 88 39 11 80       	mov    0x80113988,%eax
80103476:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103479:	7f dc                	jg     80103457 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010347b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010347e:	89 04 24             	mov    %eax,(%esp)
80103481:	e8 a6 cd ff ff       	call   8010022c <brelse>
}
80103486:	c9                   	leave  
80103487:	c3                   	ret    

80103488 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103488:	55                   	push   %ebp
80103489:	89 e5                	mov    %esp,%ebp
8010348b:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010348e:	a1 74 39 11 80       	mov    0x80113974,%eax
80103493:	89 c2                	mov    %eax,%edx
80103495:	a1 84 39 11 80       	mov    0x80113984,%eax
8010349a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010349e:	89 04 24             	mov    %eax,(%esp)
801034a1:	e8 0f cd ff ff       	call   801001b5 <bread>
801034a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ac:	83 c0 5c             	add    $0x5c,%eax
801034af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034b2:	8b 15 88 39 11 80    	mov    0x80113988,%edx
801034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034bb:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034c4:	eb 1a                	jmp    801034e0 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
801034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c9:	83 c0 10             	add    $0x10,%eax
801034cc:	8b 0c 85 4c 39 11 80 	mov    -0x7feec6b4(,%eax,4),%ecx
801034d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d9:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034dd:	ff 45 f4             	incl   -0xc(%ebp)
801034e0:	a1 88 39 11 80       	mov    0x80113988,%eax
801034e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e8:	7f dc                	jg     801034c6 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ed:	89 04 24             	mov    %eax,(%esp)
801034f0:	e8 f7 cc ff ff       	call   801001ec <bwrite>
  brelse(buf);
801034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f8:	89 04 24             	mov    %eax,(%esp)
801034fb:	e8 2c cd ff ff       	call   8010022c <brelse>
}
80103500:	c9                   	leave  
80103501:	c3                   	ret    

80103502 <recover_from_log>:

static void
recover_from_log(void)
{
80103502:	55                   	push   %ebp
80103503:	89 e5                	mov    %esp,%ebp
80103505:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103508:	e8 0d ff ff ff       	call   8010341a <read_head>
  install_trans(); // if committed, copy from log to disk
8010350d:	e8 5d fe ff ff       	call   8010336f <install_trans>
  log.lh.n = 0;
80103512:	c7 05 88 39 11 80 00 	movl   $0x0,0x80113988
80103519:	00 00 00 
  write_head(); // clear the log
8010351c:	e8 67 ff ff ff       	call   80103488 <write_head>
}
80103521:	c9                   	leave  
80103522:	c3                   	ret    

80103523 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103523:	55                   	push   %ebp
80103524:	89 e5                	mov    %esp,%ebp
80103526:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103529:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103530:	e8 f6 18 00 00       	call   80104e2b <acquire>
  while(1){
    if(log.committing){
80103535:	a1 80 39 11 80       	mov    0x80113980,%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	74 16                	je     80103554 <begin_op+0x31>
      sleep(&log, &log.lock);
8010353e:	c7 44 24 04 40 39 11 	movl   $0x80113940,0x4(%esp)
80103545:	80 
80103546:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
8010354d:	e8 0a 15 00 00       	call   80104a5c <sleep>
80103552:	eb 4d                	jmp    801035a1 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103554:	8b 15 88 39 11 80    	mov    0x80113988,%edx
8010355a:	a1 7c 39 11 80       	mov    0x8011397c,%eax
8010355f:	8d 48 01             	lea    0x1(%eax),%ecx
80103562:	89 c8                	mov    %ecx,%eax
80103564:	c1 e0 02             	shl    $0x2,%eax
80103567:	01 c8                	add    %ecx,%eax
80103569:	01 c0                	add    %eax,%eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	83 f8 1e             	cmp    $0x1e,%eax
80103570:	7e 16                	jle    80103588 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103572:	c7 44 24 04 40 39 11 	movl   $0x80113940,0x4(%esp)
80103579:	80 
8010357a:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103581:	e8 d6 14 00 00       	call   80104a5c <sleep>
80103586:	eb 19                	jmp    801035a1 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
80103588:	a1 7c 39 11 80       	mov    0x8011397c,%eax
8010358d:	40                   	inc    %eax
8010358e:	a3 7c 39 11 80       	mov    %eax,0x8011397c
      release(&log.lock);
80103593:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
8010359a:	e8 f6 18 00 00       	call   80104e95 <release>
      break;
8010359f:	eb 02                	jmp    801035a3 <begin_op+0x80>
    }
  }
801035a1:	eb 92                	jmp    80103535 <begin_op+0x12>
}
801035a3:	c9                   	leave  
801035a4:	c3                   	ret    

801035a5 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035a5:	55                   	push   %ebp
801035a6:	89 e5                	mov    %esp,%ebp
801035a8:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801035ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035b2:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
801035b9:	e8 6d 18 00 00       	call   80104e2b <acquire>
  log.outstanding -= 1;
801035be:	a1 7c 39 11 80       	mov    0x8011397c,%eax
801035c3:	48                   	dec    %eax
801035c4:	a3 7c 39 11 80       	mov    %eax,0x8011397c
  if(log.committing)
801035c9:	a1 80 39 11 80       	mov    0x80113980,%eax
801035ce:	85 c0                	test   %eax,%eax
801035d0:	74 0c                	je     801035de <end_op+0x39>
    panic("log.committing");
801035d2:	c7 04 24 75 84 10 80 	movl   $0x80108475,(%esp)
801035d9:	e8 76 cf ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
801035de:	a1 7c 39 11 80       	mov    0x8011397c,%eax
801035e3:	85 c0                	test   %eax,%eax
801035e5:	75 13                	jne    801035fa <end_op+0x55>
    do_commit = 1;
801035e7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035ee:	c7 05 80 39 11 80 01 	movl   $0x1,0x80113980
801035f5:	00 00 00 
801035f8:	eb 0c                	jmp    80103606 <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801035fa:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103601:	e8 2a 15 00 00       	call   80104b30 <wakeup>
  }
  release(&log.lock);
80103606:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
8010360d:	e8 83 18 00 00       	call   80104e95 <release>

  if(do_commit){
80103612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103616:	74 33                	je     8010364b <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103618:	e8 db 00 00 00       	call   801036f8 <commit>
    acquire(&log.lock);
8010361d:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103624:	e8 02 18 00 00       	call   80104e2b <acquire>
    log.committing = 0;
80103629:	c7 05 80 39 11 80 00 	movl   $0x0,0x80113980
80103630:	00 00 00 
    wakeup(&log);
80103633:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
8010363a:	e8 f1 14 00 00       	call   80104b30 <wakeup>
    release(&log.lock);
8010363f:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
80103646:	e8 4a 18 00 00       	call   80104e95 <release>
  }
}
8010364b:	c9                   	leave  
8010364c:	c3                   	ret    

8010364d <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010364d:	55                   	push   %ebp
8010364e:	89 e5                	mov    %esp,%ebp
80103650:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103653:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010365a:	e9 89 00 00 00       	jmp    801036e8 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010365f:	8b 15 74 39 11 80    	mov    0x80113974,%edx
80103665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103668:	01 d0                	add    %edx,%eax
8010366a:	40                   	inc    %eax
8010366b:	89 c2                	mov    %eax,%edx
8010366d:	a1 84 39 11 80       	mov    0x80113984,%eax
80103672:	89 54 24 04          	mov    %edx,0x4(%esp)
80103676:	89 04 24             	mov    %eax,(%esp)
80103679:	e8 37 cb ff ff       	call   801001b5 <bread>
8010367e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103684:	83 c0 10             	add    $0x10,%eax
80103687:	8b 04 85 4c 39 11 80 	mov    -0x7feec6b4(,%eax,4),%eax
8010368e:	89 c2                	mov    %eax,%edx
80103690:	a1 84 39 11 80       	mov    0x80113984,%eax
80103695:	89 54 24 04          	mov    %edx,0x4(%esp)
80103699:	89 04 24             	mov    %eax,(%esp)
8010369c:	e8 14 cb ff ff       	call   801001b5 <bread>
801036a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036a7:	8d 50 5c             	lea    0x5c(%eax),%edx
801036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ad:	83 c0 5c             	add    $0x5c,%eax
801036b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801036b7:	00 
801036b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801036bc:	89 04 24             	mov    %eax,(%esp)
801036bf:	e8 93 1a 00 00       	call   80105157 <memmove>
    bwrite(to);  // write the log
801036c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036c7:	89 04 24             	mov    %eax,(%esp)
801036ca:	e8 1d cb ff ff       	call   801001ec <bwrite>
    brelse(from);
801036cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d2:	89 04 24             	mov    %eax,(%esp)
801036d5:	e8 52 cb ff ff       	call   8010022c <brelse>
    brelse(to);
801036da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036dd:	89 04 24             	mov    %eax,(%esp)
801036e0:	e8 47 cb ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036e5:	ff 45 f4             	incl   -0xc(%ebp)
801036e8:	a1 88 39 11 80       	mov    0x80113988,%eax
801036ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f0:	0f 8f 69 ff ff ff    	jg     8010365f <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
801036f6:	c9                   	leave  
801036f7:	c3                   	ret    

801036f8 <commit>:

static void
commit()
{
801036f8:	55                   	push   %ebp
801036f9:	89 e5                	mov    %esp,%ebp
801036fb:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036fe:	a1 88 39 11 80       	mov    0x80113988,%eax
80103703:	85 c0                	test   %eax,%eax
80103705:	7e 1e                	jle    80103725 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103707:	e8 41 ff ff ff       	call   8010364d <write_log>
    write_head();    // Write header to disk -- the real commit
8010370c:	e8 77 fd ff ff       	call   80103488 <write_head>
    install_trans(); // Now install writes to home locations
80103711:	e8 59 fc ff ff       	call   8010336f <install_trans>
    log.lh.n = 0;
80103716:	c7 05 88 39 11 80 00 	movl   $0x0,0x80113988
8010371d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103720:	e8 63 fd ff ff       	call   80103488 <write_head>
  }
}
80103725:	c9                   	leave  
80103726:	c3                   	ret    

80103727 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103727:	55                   	push   %ebp
80103728:	89 e5                	mov    %esp,%ebp
8010372a:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010372d:	a1 88 39 11 80       	mov    0x80113988,%eax
80103732:	83 f8 1d             	cmp    $0x1d,%eax
80103735:	7f 10                	jg     80103747 <log_write+0x20>
80103737:	a1 88 39 11 80       	mov    0x80113988,%eax
8010373c:	8b 15 78 39 11 80    	mov    0x80113978,%edx
80103742:	4a                   	dec    %edx
80103743:	39 d0                	cmp    %edx,%eax
80103745:	7c 0c                	jl     80103753 <log_write+0x2c>
    panic("too big a transaction");
80103747:	c7 04 24 84 84 10 80 	movl   $0x80108484,(%esp)
8010374e:	e8 01 ce ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
80103753:	a1 7c 39 11 80       	mov    0x8011397c,%eax
80103758:	85 c0                	test   %eax,%eax
8010375a:	7f 0c                	jg     80103768 <log_write+0x41>
    panic("log_write outside of trans");
8010375c:	c7 04 24 9a 84 10 80 	movl   $0x8010849a,(%esp)
80103763:	e8 ec cd ff ff       	call   80100554 <panic>

  acquire(&log.lock);
80103768:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
8010376f:	e8 b7 16 00 00       	call   80104e2b <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103774:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010377b:	eb 1e                	jmp    8010379b <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103780:	83 c0 10             	add    $0x10,%eax
80103783:	8b 04 85 4c 39 11 80 	mov    -0x7feec6b4(,%eax,4),%eax
8010378a:	89 c2                	mov    %eax,%edx
8010378c:	8b 45 08             	mov    0x8(%ebp),%eax
8010378f:	8b 40 08             	mov    0x8(%eax),%eax
80103792:	39 c2                	cmp    %eax,%edx
80103794:	75 02                	jne    80103798 <log_write+0x71>
      break;
80103796:	eb 0d                	jmp    801037a5 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103798:	ff 45 f4             	incl   -0xc(%ebp)
8010379b:	a1 88 39 11 80       	mov    0x80113988,%eax
801037a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037a3:	7f d8                	jg     8010377d <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	8b 40 08             	mov    0x8(%eax),%eax
801037ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037ae:	83 c2 10             	add    $0x10,%edx
801037b1:	89 04 95 4c 39 11 80 	mov    %eax,-0x7feec6b4(,%edx,4)
  if (i == log.lh.n)
801037b8:	a1 88 39 11 80       	mov    0x80113988,%eax
801037bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037c0:	75 0b                	jne    801037cd <log_write+0xa6>
    log.lh.n++;
801037c2:	a1 88 39 11 80       	mov    0x80113988,%eax
801037c7:	40                   	inc    %eax
801037c8:	a3 88 39 11 80       	mov    %eax,0x80113988
  b->flags |= B_DIRTY; // prevent eviction
801037cd:	8b 45 08             	mov    0x8(%ebp),%eax
801037d0:	8b 00                	mov    (%eax),%eax
801037d2:	83 c8 04             	or     $0x4,%eax
801037d5:	89 c2                	mov    %eax,%edx
801037d7:	8b 45 08             	mov    0x8(%ebp),%eax
801037da:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037dc:	c7 04 24 40 39 11 80 	movl   $0x80113940,(%esp)
801037e3:	e8 ad 16 00 00       	call   80104e95 <release>
}
801037e8:	c9                   	leave  
801037e9:	c3                   	ret    
	...

801037ec <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037ec:	55                   	push   %ebp
801037ed:	89 e5                	mov    %esp,%ebp
801037ef:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037f2:	8b 55 08             	mov    0x8(%ebp),%edx
801037f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801037f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037fb:	f0 87 02             	lock xchg %eax,(%edx)
801037fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103801:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103804:	c9                   	leave  
80103805:	c3                   	ret    

80103806 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103806:	55                   	push   %ebp
80103807:	89 e5                	mov    %esp,%ebp
80103809:	83 e4 f0             	and    $0xfffffff0,%esp
8010380c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010380f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103816:	80 
80103817:	c7 04 24 68 67 11 80 	movl   $0x80116768,(%esp)
8010381e:	e8 0d f3 ff ff       	call   80102b30 <kinit1>
  kvmalloc();      // kernel page table
80103823:	e8 c7 41 00 00       	call   801079ef <kvmalloc>
  mpinit();        // detect other processors
80103828:	e8 c4 03 00 00       	call   80103bf1 <mpinit>
  lapicinit();     // interrupt controller
8010382d:	e8 4e f6 ff ff       	call   80102e80 <lapicinit>
  seginit();       // segment descriptors
80103832:	e8 a0 3c 00 00       	call   801074d7 <seginit>
  picinit();       // disable pic
80103837:	e8 04 05 00 00       	call   80103d40 <picinit>
  ioapicinit();    // another interrupt controller
8010383c:	e8 0c f2 ff ff       	call   80102a4d <ioapicinit>
  consoleinit();   // console hardware
80103841:	e8 76 d3 ff ff       	call   80100bbc <consoleinit>
  uartinit();      // serial port
80103846:	e8 18 30 00 00       	call   80106863 <uartinit>
  pinit();         // process table
8010384b:	e8 e6 08 00 00       	call   80104136 <pinit>
  tvinit();        // trap vectors
80103850:	e8 f7 2b 00 00       	call   8010644c <tvinit>
  binit();         // buffer cache
80103855:	e8 da c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010385a:	e8 ed d7 ff ff       	call   8010104c <fileinit>
  ideinit();       // disk 
8010385f:	e8 f5 ed ff ff       	call   80102659 <ideinit>
  startothers();   // start other processors
80103864:	e8 83 00 00 00       	call   801038ec <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103869:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103870:	8e 
80103871:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103878:	e8 eb f2 ff ff       	call   80102b68 <kinit2>
  userinit();      // first user process
8010387d:	e8 c1 0a 00 00       	call   80104343 <userinit>
  mpmain();        // finish this processor's setup
80103882:	e8 1a 00 00 00       	call   801038a1 <mpmain>

80103887 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103887:	55                   	push   %ebp
80103888:	89 e5                	mov    %esp,%ebp
8010388a:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010388d:	e8 74 41 00 00       	call   80107a06 <switchkvm>
  seginit();
80103892:	e8 40 3c 00 00       	call   801074d7 <seginit>
  lapicinit();
80103897:	e8 e4 f5 ff ff       	call   80102e80 <lapicinit>
  mpmain();
8010389c:	e8 00 00 00 00       	call   801038a1 <mpmain>

801038a1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038a1:	55                   	push   %ebp
801038a2:	89 e5                	mov    %esp,%ebp
801038a4:	53                   	push   %ebx
801038a5:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038a8:	e8 a5 08 00 00       	call   80104152 <cpuid>
801038ad:	89 c3                	mov    %eax,%ebx
801038af:	e8 9e 08 00 00       	call   80104152 <cpuid>
801038b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801038b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801038bc:	c7 04 24 b5 84 10 80 	movl   $0x801084b5,(%esp)
801038c3:	e8 f9 ca ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
801038c8:	e8 dc 2c 00 00       	call   801065a9 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038cd:	e8 c5 08 00 00       	call   80104197 <mycpu>
801038d2:	05 a0 00 00 00       	add    $0xa0,%eax
801038d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038de:	00 
801038df:	89 04 24             	mov    %eax,(%esp)
801038e2:	e8 05 ff ff ff       	call   801037ec <xchg>
  scheduler();     // start running processes
801038e7:	e8 a6 0f 00 00       	call   80104892 <scheduler>

801038ec <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038ec:	55                   	push   %ebp
801038ed:	89 e5                	mov    %esp,%ebp
801038ef:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
801038f2:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038f9:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80103902:	c7 44 24 04 ec b4 10 	movl   $0x8010b4ec,0x4(%esp)
80103909:	80 
8010390a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390d:	89 04 24             	mov    %eax,(%esp)
80103910:	e8 42 18 00 00       	call   80105157 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103915:	c7 45 f4 40 3a 11 80 	movl   $0x80113a40,-0xc(%ebp)
8010391c:	eb 75                	jmp    80103993 <startothers+0xa7>
    if(c == mycpu())  // We've started already.
8010391e:	e8 74 08 00 00       	call   80104197 <mycpu>
80103923:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103926:	75 02                	jne    8010392a <startothers+0x3e>
      continue;
80103928:	eb 62                	jmp    8010398c <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010392a:	e8 2c f3 ff ff       	call   80102c5b <kalloc>
8010392f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103935:	83 e8 04             	sub    $0x4,%eax
80103938:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010393b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103941:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103946:	83 e8 08             	sub    $0x8,%eax
80103949:	c7 00 87 38 10 80    	movl   $0x80103887,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103952:	8d 50 f4             	lea    -0xc(%eax),%edx
80103955:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
8010395a:	05 00 00 00 80       	add    $0x80000000,%eax
8010395f:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103964:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010396a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010396d:	8a 00                	mov    (%eax),%al
8010396f:	0f b6 c0             	movzbl %al,%eax
80103972:	89 54 24 04          	mov    %edx,0x4(%esp)
80103976:	89 04 24             	mov    %eax,(%esp)
80103979:	e8 a7 f6 ff ff       	call   80103025 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010397e:	90                   	nop
8010397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103982:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103988:	85 c0                	test   %eax,%eax
8010398a:	74 f3                	je     8010397f <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010398c:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103993:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80103998:	89 c2                	mov    %eax,%edx
8010399a:	89 d0                	mov    %edx,%eax
8010399c:	c1 e0 02             	shl    $0x2,%eax
8010399f:	01 d0                	add    %edx,%eax
801039a1:	01 c0                	add    %eax,%eax
801039a3:	01 d0                	add    %edx,%eax
801039a5:	c1 e0 04             	shl    $0x4,%eax
801039a8:	05 40 3a 11 80       	add    $0x80113a40,%eax
801039ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039b0:	0f 87 68 ff ff ff    	ja     8010391e <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039b6:	c9                   	leave  
801039b7:	c3                   	ret    

801039b8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 14             	sub    $0x14,%esp
801039be:	8b 45 08             	mov    0x8(%ebp),%eax
801039c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039c8:	89 c2                	mov    %eax,%edx
801039ca:	ec                   	in     (%dx),%al
801039cb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039ce:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801039d1:	c9                   	leave  
801039d2:	c3                   	ret    

801039d3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039d3:	55                   	push   %ebp
801039d4:	89 e5                	mov    %esp,%ebp
801039d6:	83 ec 08             	sub    $0x8,%esp
801039d9:	8b 45 08             	mov    0x8(%ebp),%eax
801039dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801039df:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801039e3:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039e6:	8a 45 f8             	mov    -0x8(%ebp),%al
801039e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039ec:	ee                   	out    %al,(%dx)
}
801039ed:	c9                   	leave  
801039ee:	c3                   	ret    

801039ef <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
801039ef:	55                   	push   %ebp
801039f0:	89 e5                	mov    %esp,%ebp
801039f2:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
801039f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801039fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a03:	eb 13                	jmp    80103a18 <sum+0x29>
    sum += addr[i];
80103a05:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a08:	8b 45 08             	mov    0x8(%ebp),%eax
80103a0b:	01 d0                	add    %edx,%eax
80103a0d:	8a 00                	mov    (%eax),%al
80103a0f:	0f b6 c0             	movzbl %al,%eax
80103a12:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103a15:	ff 45 fc             	incl   -0x4(%ebp)
80103a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a1e:	7c e5                	jl     80103a05 <sum+0x16>
    sum += addr[i];
  return sum;
80103a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a23:	c9                   	leave  
80103a24:	c3                   	ret    

80103a25 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a25:	55                   	push   %ebp
80103a26:	89 e5                	mov    %esp,%ebp
80103a28:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a2e:	05 00 00 00 80       	add    $0x80000000,%eax
80103a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a36:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a3c:	01 d0                	add    %edx,%eax
80103a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a47:	eb 3f                	jmp    80103a88 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a49:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a50:	00 
80103a51:	c7 44 24 04 cc 84 10 	movl   $0x801084cc,0x4(%esp)
80103a58:	80 
80103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5c:	89 04 24             	mov    %eax,(%esp)
80103a5f:	e8 a1 16 00 00       	call   80105105 <memcmp>
80103a64:	85 c0                	test   %eax,%eax
80103a66:	75 1c                	jne    80103a84 <mpsearch1+0x5f>
80103a68:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a6f:	00 
80103a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a73:	89 04 24             	mov    %eax,(%esp)
80103a76:	e8 74 ff ff ff       	call   801039ef <sum>
80103a7b:	84 c0                	test   %al,%al
80103a7d:	75 05                	jne    80103a84 <mpsearch1+0x5f>
      return (struct mp*)p;
80103a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a82:	eb 11                	jmp    80103a95 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a84:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a8e:	72 b9                	jb     80103a49 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a95:	c9                   	leave  
80103a96:	c3                   	ret    

80103a97 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a97:	55                   	push   %ebp
80103a98:	89 e5                	mov    %esp,%ebp
80103a9a:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a9d:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa7:	83 c0 0f             	add    $0xf,%eax
80103aaa:	8a 00                	mov    (%eax),%al
80103aac:	0f b6 c0             	movzbl %al,%eax
80103aaf:	c1 e0 08             	shl    $0x8,%eax
80103ab2:	89 c2                	mov    %eax,%edx
80103ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab7:	83 c0 0e             	add    $0xe,%eax
80103aba:	8a 00                	mov    (%eax),%al
80103abc:	0f b6 c0             	movzbl %al,%eax
80103abf:	09 d0                	or     %edx,%eax
80103ac1:	c1 e0 04             	shl    $0x4,%eax
80103ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ac7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103acb:	74 21                	je     80103aee <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103acd:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ad4:	00 
80103ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 45 ff ff ff       	call   80103a25 <mpsearch1>
80103ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ae7:	74 4e                	je     80103b37 <mpsearch+0xa0>
      return mp;
80103ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aec:	eb 5d                	jmp    80103b4b <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af1:	83 c0 14             	add    $0x14,%eax
80103af4:	8a 00                	mov    (%eax),%al
80103af6:	0f b6 c0             	movzbl %al,%eax
80103af9:	c1 e0 08             	shl    $0x8,%eax
80103afc:	89 c2                	mov    %eax,%edx
80103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b01:	83 c0 13             	add    $0x13,%eax
80103b04:	8a 00                	mov    (%eax),%al
80103b06:	0f b6 c0             	movzbl %al,%eax
80103b09:	09 d0                	or     %edx,%eax
80103b0b:	c1 e0 0a             	shl    $0xa,%eax
80103b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b14:	2d 00 04 00 00       	sub    $0x400,%eax
80103b19:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b20:	00 
80103b21:	89 04 24             	mov    %eax,(%esp)
80103b24:	e8 fc fe ff ff       	call   80103a25 <mpsearch1>
80103b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b30:	74 05                	je     80103b37 <mpsearch+0xa0>
      return mp;
80103b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b35:	eb 14                	jmp    80103b4b <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b37:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b3e:	00 
80103b3f:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b46:	e8 da fe ff ff       	call   80103a25 <mpsearch1>
}
80103b4b:	c9                   	leave  
80103b4c:	c3                   	ret    

80103b4d <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b4d:	55                   	push   %ebp
80103b4e:	89 e5                	mov    %esp,%ebp
80103b50:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b53:	e8 3f ff ff ff       	call   80103a97 <mpsearch>
80103b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b5f:	74 0a                	je     80103b6b <mpconfig+0x1e>
80103b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b64:	8b 40 04             	mov    0x4(%eax),%eax
80103b67:	85 c0                	test   %eax,%eax
80103b69:	75 07                	jne    80103b72 <mpconfig+0x25>
    return 0;
80103b6b:	b8 00 00 00 00       	mov    $0x0,%eax
80103b70:	eb 7d                	jmp    80103bef <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b75:	8b 40 04             	mov    0x4(%eax),%eax
80103b78:	05 00 00 00 80       	add    $0x80000000,%eax
80103b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b80:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b87:	00 
80103b88:	c7 44 24 04 d1 84 10 	movl   $0x801084d1,0x4(%esp)
80103b8f:	80 
80103b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b93:	89 04 24             	mov    %eax,(%esp)
80103b96:	e8 6a 15 00 00       	call   80105105 <memcmp>
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	74 07                	je     80103ba6 <mpconfig+0x59>
    return 0;
80103b9f:	b8 00 00 00 00       	mov    $0x0,%eax
80103ba4:	eb 49                	jmp    80103bef <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba9:	8a 40 06             	mov    0x6(%eax),%al
80103bac:	3c 01                	cmp    $0x1,%al
80103bae:	74 11                	je     80103bc1 <mpconfig+0x74>
80103bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bb3:	8a 40 06             	mov    0x6(%eax),%al
80103bb6:	3c 04                	cmp    $0x4,%al
80103bb8:	74 07                	je     80103bc1 <mpconfig+0x74>
    return 0;
80103bba:	b8 00 00 00 00       	mov    $0x0,%eax
80103bbf:	eb 2e                	jmp    80103bef <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc4:	8b 40 04             	mov    0x4(%eax),%eax
80103bc7:	0f b7 c0             	movzwl %ax,%eax
80103bca:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd1:	89 04 24             	mov    %eax,(%esp)
80103bd4:	e8 16 fe ff ff       	call   801039ef <sum>
80103bd9:	84 c0                	test   %al,%al
80103bdb:	74 07                	je     80103be4 <mpconfig+0x97>
    return 0;
80103bdd:	b8 00 00 00 00       	mov    $0x0,%eax
80103be2:	eb 0b                	jmp    80103bef <mpconfig+0xa2>
  *pmp = mp;
80103be4:	8b 45 08             	mov    0x8(%ebp),%eax
80103be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103bea:	89 10                	mov    %edx,(%eax)
  return conf;
80103bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103bef:	c9                   	leave  
80103bf0:	c3                   	ret    

80103bf1 <mpinit>:

void
mpinit(void)
{
80103bf1:	55                   	push   %ebp
80103bf2:	89 e5                	mov    %esp,%ebp
80103bf4:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103bf7:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103bfa:	89 04 24             	mov    %eax,(%esp)
80103bfd:	e8 4b ff ff ff       	call   80103b4d <mpconfig>
80103c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c09:	75 0c                	jne    80103c17 <mpinit+0x26>
    panic("Expect to run on an SMP");
80103c0b:	c7 04 24 d6 84 10 80 	movl   $0x801084d6,(%esp)
80103c12:	e8 3d c9 ff ff       	call   80100554 <panic>
  ismp = 1;
80103c17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c21:	8b 40 24             	mov    0x24(%eax),%eax
80103c24:	a3 3c 39 11 80       	mov    %eax,0x8011393c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c2c:	83 c0 2c             	add    $0x2c,%eax
80103c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c35:	8b 40 04             	mov    0x4(%eax),%eax
80103c38:	0f b7 d0             	movzwl %ax,%edx
80103c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c3e:	01 d0                	add    %edx,%eax
80103c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103c43:	eb 7d                	jmp    80103cc2 <mpinit+0xd1>
    switch(*p){
80103c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c48:	8a 00                	mov    (%eax),%al
80103c4a:	0f b6 c0             	movzbl %al,%eax
80103c4d:	83 f8 04             	cmp    $0x4,%eax
80103c50:	77 68                	ja     80103cba <mpinit+0xc9>
80103c52:	8b 04 85 10 85 10 80 	mov    -0x7fef7af0(,%eax,4),%eax
80103c59:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103c61:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80103c66:	83 f8 07             	cmp    $0x7,%eax
80103c69:	7f 2c                	jg     80103c97 <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c6b:	8b 15 c0 3f 11 80    	mov    0x80113fc0,%edx
80103c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c74:	8a 48 01             	mov    0x1(%eax),%cl
80103c77:	89 d0                	mov    %edx,%eax
80103c79:	c1 e0 02             	shl    $0x2,%eax
80103c7c:	01 d0                	add    %edx,%eax
80103c7e:	01 c0                	add    %eax,%eax
80103c80:	01 d0                	add    %edx,%eax
80103c82:	c1 e0 04             	shl    $0x4,%eax
80103c85:	05 40 3a 11 80       	add    $0x80113a40,%eax
80103c8a:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103c8c:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80103c91:	40                   	inc    %eax
80103c92:	a3 c0 3f 11 80       	mov    %eax,0x80113fc0
      }
      p += sizeof(struct mpproc);
80103c97:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c9b:	eb 25                	jmp    80103cc2 <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ca6:	8a 40 01             	mov    0x1(%eax),%al
80103ca9:	a2 20 3a 11 80       	mov    %al,0x80113a20
      p += sizeof(struct mpioapic);
80103cae:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cb2:	eb 0e                	jmp    80103cc2 <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cb4:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cb8:	eb 08                	jmp    80103cc2 <mpinit+0xd1>
    default:
      ismp = 0;
80103cba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103cc1:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103cc8:	0f 82 77 ff ff ff    	jb     80103c45 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cd2:	75 0c                	jne    80103ce0 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103cd4:	c7 04 24 f0 84 10 80 	movl   $0x801084f0,(%esp)
80103cdb:	e8 74 c8 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80103ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ce3:	8a 40 0c             	mov    0xc(%eax),%al
80103ce6:	84 c0                	test   %al,%al
80103ce8:	74 36                	je     80103d20 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103cea:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103cf1:	00 
80103cf2:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103cf9:	e8 d5 fc ff ff       	call   801039d3 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103cfe:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d05:	e8 ae fc ff ff       	call   801039b8 <inb>
80103d0a:	83 c8 01             	or     $0x1,%eax
80103d0d:	0f b6 c0             	movzbl %al,%eax
80103d10:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d14:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d1b:	e8 b3 fc ff ff       	call   801039d3 <outb>
  }
}
80103d20:	c9                   	leave  
80103d21:	c3                   	ret    
	...

80103d24 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	83 ec 08             	sub    $0x8,%esp
80103d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d30:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d34:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d37:	8a 45 f8             	mov    -0x8(%ebp),%al
80103d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103d3d:	ee                   	out    %al,(%dx)
}
80103d3e:	c9                   	leave  
80103d3f:	c3                   	ret    

80103d40 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103d46:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103d4d:	00 
80103d4e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103d55:	e8 ca ff ff ff       	call   80103d24 <outb>
  outb(IO_PIC2+1, 0xFF);
80103d5a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103d61:	00 
80103d62:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103d69:	e8 b6 ff ff ff       	call   80103d24 <outb>
}
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    

80103d70 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103d76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d86:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d89:	8b 10                	mov    (%eax),%edx
80103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d90:	e8 d3 d2 ff ff       	call   80101068 <filealloc>
80103d95:	8b 55 08             	mov    0x8(%ebp),%edx
80103d98:	89 02                	mov    %eax,(%edx)
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	8b 00                	mov    (%eax),%eax
80103d9f:	85 c0                	test   %eax,%eax
80103da1:	0f 84 c8 00 00 00    	je     80103e6f <pipealloc+0xff>
80103da7:	e8 bc d2 ff ff       	call   80101068 <filealloc>
80103dac:	8b 55 0c             	mov    0xc(%ebp),%edx
80103daf:	89 02                	mov    %eax,(%edx)
80103db1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db4:	8b 00                	mov    (%eax),%eax
80103db6:	85 c0                	test   %eax,%eax
80103db8:	0f 84 b1 00 00 00    	je     80103e6f <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103dbe:	e8 98 ee ff ff       	call   80102c5b <kalloc>
80103dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dca:	75 05                	jne    80103dd1 <pipealloc+0x61>
    goto bad;
80103dcc:	e9 9e 00 00 00       	jmp    80103e6f <pipealloc+0xff>
  p->readopen = 1;
80103dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ddb:	00 00 00 
  p->writeopen = 1;
80103dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de1:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103de8:	00 00 00 
  p->nwrite = 0;
80103deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dee:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103df5:	00 00 00 
  p->nread = 0;
80103df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dfb:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103e02:	00 00 00 
  initlock(&p->lock, "pipe");
80103e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e08:	c7 44 24 04 24 85 10 	movl   $0x80108524,0x4(%esp)
80103e0f:	80 
80103e10:	89 04 24             	mov    %eax,(%esp)
80103e13:	e8 f2 0f 00 00       	call   80104e0a <initlock>
  (*f0)->type = FD_PIPE;
80103e18:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1b:	8b 00                	mov    (%eax),%eax
80103e1d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	8b 00                	mov    (%eax),%eax
80103e28:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2f:	8b 00                	mov    (%eax),%eax
80103e31:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e35:	8b 45 08             	mov    0x8(%ebp),%eax
80103e38:	8b 00                	mov    (%eax),%eax
80103e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e3d:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e40:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e43:	8b 00                	mov    (%eax),%eax
80103e45:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4e:	8b 00                	mov    (%eax),%eax
80103e50:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e57:	8b 00                	mov    (%eax),%eax
80103e59:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e60:	8b 00                	mov    (%eax),%eax
80103e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e65:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103e68:	b8 00 00 00 00       	mov    $0x0,%eax
80103e6d:	eb 42                	jmp    80103eb1 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e73:	74 0b                	je     80103e80 <pipealloc+0x110>
    kfree((char*)p);
80103e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e78:	89 04 24             	mov    %eax,(%esp)
80103e7b:	e8 45 ed ff ff       	call   80102bc5 <kfree>
  if(*f0)
80103e80:	8b 45 08             	mov    0x8(%ebp),%eax
80103e83:	8b 00                	mov    (%eax),%eax
80103e85:	85 c0                	test   %eax,%eax
80103e87:	74 0d                	je     80103e96 <pipealloc+0x126>
    fileclose(*f0);
80103e89:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8c:	8b 00                	mov    (%eax),%eax
80103e8e:	89 04 24             	mov    %eax,(%esp)
80103e91:	e8 7a d2 ff ff       	call   80101110 <fileclose>
  if(*f1)
80103e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e99:	8b 00                	mov    (%eax),%eax
80103e9b:	85 c0                	test   %eax,%eax
80103e9d:	74 0d                	je     80103eac <pipealloc+0x13c>
    fileclose(*f1);
80103e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ea2:	8b 00                	mov    (%eax),%eax
80103ea4:	89 04 24             	mov    %eax,(%esp)
80103ea7:	e8 64 d2 ff ff       	call   80101110 <fileclose>
  return -1;
80103eac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103eb1:	c9                   	leave  
80103eb2:	c3                   	ret    

80103eb3 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103eb3:	55                   	push   %ebp
80103eb4:	89 e5                	mov    %esp,%ebp
80103eb6:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebc:	89 04 24             	mov    %eax,(%esp)
80103ebf:	e8 67 0f 00 00       	call   80104e2b <acquire>
  if(writable){
80103ec4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103ec8:	74 1f                	je     80103ee9 <pipeclose+0x36>
    p->writeopen = 0;
80103eca:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103ed4:	00 00 00 
    wakeup(&p->nread);
80103ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eda:	05 34 02 00 00       	add    $0x234,%eax
80103edf:	89 04 24             	mov    %eax,(%esp)
80103ee2:	e8 49 0c 00 00       	call   80104b30 <wakeup>
80103ee7:	eb 1d                	jmp    80103f06 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80103eec:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103ef3:	00 00 00 
    wakeup(&p->nwrite);
80103ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef9:	05 38 02 00 00       	add    $0x238,%eax
80103efe:	89 04 24             	mov    %eax,(%esp)
80103f01:	e8 2a 0c 00 00       	call   80104b30 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f06:	8b 45 08             	mov    0x8(%ebp),%eax
80103f09:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	75 25                	jne    80103f38 <pipeclose+0x85>
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f1c:	85 c0                	test   %eax,%eax
80103f1e:	75 18                	jne    80103f38 <pipeclose+0x85>
    release(&p->lock);
80103f20:	8b 45 08             	mov    0x8(%ebp),%eax
80103f23:	89 04 24             	mov    %eax,(%esp)
80103f26:	e8 6a 0f 00 00       	call   80104e95 <release>
    kfree((char*)p);
80103f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2e:	89 04 24             	mov    %eax,(%esp)
80103f31:	e8 8f ec ff ff       	call   80102bc5 <kfree>
80103f36:	eb 0b                	jmp    80103f43 <pipeclose+0x90>
  } else
    release(&p->lock);
80103f38:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3b:	89 04 24             	mov    %eax,(%esp)
80103f3e:	e8 52 0f 00 00       	call   80104e95 <release>
}
80103f43:	c9                   	leave  
80103f44:	c3                   	ret    

80103f45 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103f45:	55                   	push   %ebp
80103f46:	89 e5                	mov    %esp,%ebp
80103f48:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4e:	89 04 24             	mov    %eax,(%esp)
80103f51:	e8 d5 0e 00 00       	call   80104e2b <acquire>
  for(i = 0; i < n; i++){
80103f56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f5d:	e9 a3 00 00 00       	jmp    80104005 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f62:	eb 56                	jmp    80103fba <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103f64:	8b 45 08             	mov    0x8(%ebp),%eax
80103f67:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f6d:	85 c0                	test   %eax,%eax
80103f6f:	74 0c                	je     80103f7d <pipewrite+0x38>
80103f71:	e8 a5 02 00 00       	call   8010421b <myproc>
80103f76:	8b 40 24             	mov    0x24(%eax),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	74 15                	je     80103f92 <pipewrite+0x4d>
        release(&p->lock);
80103f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f80:	89 04 24             	mov    %eax,(%esp)
80103f83:	e8 0d 0f 00 00       	call   80104e95 <release>
        return -1;
80103f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f8d:	e9 9d 00 00 00       	jmp    8010402f <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103f92:	8b 45 08             	mov    0x8(%ebp),%eax
80103f95:	05 34 02 00 00       	add    $0x234,%eax
80103f9a:	89 04 24             	mov    %eax,(%esp)
80103f9d:	e8 8e 0b 00 00       	call   80104b30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa5:	8b 55 08             	mov    0x8(%ebp),%edx
80103fa8:	81 c2 38 02 00 00    	add    $0x238,%edx
80103fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fb2:	89 14 24             	mov    %edx,(%esp)
80103fb5:	e8 a2 0a 00 00       	call   80104a5c <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fba:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbd:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103fc3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc6:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fcc:	05 00 02 00 00       	add    $0x200,%eax
80103fd1:	39 c2                	cmp    %eax,%edx
80103fd3:	74 8f                	je     80103f64 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd8:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fde:	8d 48 01             	lea    0x1(%eax),%ecx
80103fe1:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe4:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103fea:	25 ff 01 00 00       	and    $0x1ff,%eax
80103fef:	89 c1                	mov    %eax,%ecx
80103ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff7:	01 d0                	add    %edx,%eax
80103ff9:	8a 10                	mov    (%eax),%dl
80103ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffe:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104002:	ff 45 f4             	incl   -0xc(%ebp)
80104005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104008:	3b 45 10             	cmp    0x10(%ebp),%eax
8010400b:	0f 8c 51 ff ff ff    	jl     80103f62 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104011:	8b 45 08             	mov    0x8(%ebp),%eax
80104014:	05 34 02 00 00       	add    $0x234,%eax
80104019:	89 04 24             	mov    %eax,(%esp)
8010401c:	e8 0f 0b 00 00       	call   80104b30 <wakeup>
  release(&p->lock);
80104021:	8b 45 08             	mov    0x8(%ebp),%eax
80104024:	89 04 24             	mov    %eax,(%esp)
80104027:	e8 69 0e 00 00       	call   80104e95 <release>
  return n;
8010402c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010402f:	c9                   	leave  
80104030:	c3                   	ret    

80104031 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104031:	55                   	push   %ebp
80104032:	89 e5                	mov    %esp,%ebp
80104034:	53                   	push   %ebx
80104035:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104038:	8b 45 08             	mov    0x8(%ebp),%eax
8010403b:	89 04 24             	mov    %eax,(%esp)
8010403e:	e8 e8 0d 00 00       	call   80104e2b <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104043:	eb 39                	jmp    8010407e <piperead+0x4d>
    if(myproc()->killed){
80104045:	e8 d1 01 00 00       	call   8010421b <myproc>
8010404a:	8b 40 24             	mov    0x24(%eax),%eax
8010404d:	85 c0                	test   %eax,%eax
8010404f:	74 15                	je     80104066 <piperead+0x35>
      release(&p->lock);
80104051:	8b 45 08             	mov    0x8(%ebp),%eax
80104054:	89 04 24             	mov    %eax,(%esp)
80104057:	e8 39 0e 00 00       	call   80104e95 <release>
      return -1;
8010405c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104061:	e9 b3 00 00 00       	jmp    80104119 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104066:	8b 45 08             	mov    0x8(%ebp),%eax
80104069:	8b 55 08             	mov    0x8(%ebp),%edx
8010406c:	81 c2 34 02 00 00    	add    $0x234,%edx
80104072:	89 44 24 04          	mov    %eax,0x4(%esp)
80104076:	89 14 24             	mov    %edx,(%esp)
80104079:	e8 de 09 00 00       	call   80104a5c <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010407e:	8b 45 08             	mov    0x8(%ebp),%eax
80104081:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104087:	8b 45 08             	mov    0x8(%ebp),%eax
8010408a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104090:	39 c2                	cmp    %eax,%edx
80104092:	75 0d                	jne    801040a1 <piperead+0x70>
80104094:	8b 45 08             	mov    0x8(%ebp),%eax
80104097:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010409d:	85 c0                	test   %eax,%eax
8010409f:	75 a4                	jne    80104045 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801040a8:	eb 49                	jmp    801040f3 <piperead+0xc2>
    if(p->nread == p->nwrite)
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040bc:	39 c2                	cmp    %eax,%edx
801040be:	75 02                	jne    801040c2 <piperead+0x91>
      break;
801040c0:	eb 39                	jmp    801040fb <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801040c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801040cb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ce:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801040d4:	8d 48 01             	lea    0x1(%eax),%ecx
801040d7:	8b 55 08             	mov    0x8(%ebp),%edx
801040da:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801040e0:	25 ff 01 00 00       	and    $0x1ff,%eax
801040e5:	89 c2                	mov    %eax,%edx
801040e7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ea:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
801040ee:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040f0:	ff 45 f4             	incl   -0xc(%ebp)
801040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801040f9:	7c af                	jl     801040aa <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	05 38 02 00 00       	add    $0x238,%eax
80104103:	89 04 24             	mov    %eax,(%esp)
80104106:	e8 25 0a 00 00       	call   80104b30 <wakeup>
  release(&p->lock);
8010410b:	8b 45 08             	mov    0x8(%ebp),%eax
8010410e:	89 04 24             	mov    %eax,(%esp)
80104111:	e8 7f 0d 00 00       	call   80104e95 <release>
  return i;
80104116:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104119:	83 c4 24             	add    $0x24,%esp
8010411c:	5b                   	pop    %ebx
8010411d:	5d                   	pop    %ebp
8010411e:	c3                   	ret    
	...

80104120 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104126:	9c                   	pushf  
80104127:	58                   	pop    %eax
80104128:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010412b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010412e:	c9                   	leave  
8010412f:	c3                   	ret    

80104130 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104133:	fb                   	sti    
}
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    

80104136 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104136:	55                   	push   %ebp
80104137:	89 e5                	mov    %esp,%ebp
80104139:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010413c:	c7 44 24 04 2c 85 10 	movl   $0x8010852c,0x4(%esp)
80104143:	80 
80104144:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010414b:	e8 ba 0c 00 00       	call   80104e0a <initlock>
}
80104150:	c9                   	leave  
80104151:	c3                   	ret    

80104152 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104152:	55                   	push   %ebp
80104153:	89 e5                	mov    %esp,%ebp
80104155:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104158:	e8 3a 00 00 00       	call   80104197 <mycpu>
8010415d:	89 c2                	mov    %eax,%edx
8010415f:	b8 40 3a 11 80       	mov    $0x80113a40,%eax
80104164:	29 c2                	sub    %eax,%edx
80104166:	89 d0                	mov    %edx,%eax
80104168:	c1 f8 04             	sar    $0x4,%eax
8010416b:	89 c1                	mov    %eax,%ecx
8010416d:	89 ca                	mov    %ecx,%edx
8010416f:	c1 e2 03             	shl    $0x3,%edx
80104172:	01 ca                	add    %ecx,%edx
80104174:	89 d0                	mov    %edx,%eax
80104176:	c1 e0 05             	shl    $0x5,%eax
80104179:	29 d0                	sub    %edx,%eax
8010417b:	c1 e0 02             	shl    $0x2,%eax
8010417e:	01 c8                	add    %ecx,%eax
80104180:	c1 e0 03             	shl    $0x3,%eax
80104183:	01 c8                	add    %ecx,%eax
80104185:	89 c2                	mov    %eax,%edx
80104187:	c1 e2 0f             	shl    $0xf,%edx
8010418a:	29 c2                	sub    %eax,%edx
8010418c:	c1 e2 02             	shl    $0x2,%edx
8010418f:	01 ca                	add    %ecx,%edx
80104191:	89 d0                	mov    %edx,%eax
80104193:	f7 d8                	neg    %eax
}
80104195:	c9                   	leave  
80104196:	c3                   	ret    

80104197 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104197:	55                   	push   %ebp
80104198:	89 e5                	mov    %esp,%ebp
8010419a:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010419d:	e8 7e ff ff ff       	call   80104120 <readeflags>
801041a2:	25 00 02 00 00       	and    $0x200,%eax
801041a7:	85 c0                	test   %eax,%eax
801041a9:	74 0c                	je     801041b7 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
801041ab:	c7 04 24 34 85 10 80 	movl   $0x80108534,(%esp)
801041b2:	e8 9d c3 ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
801041b7:	e8 1d ee ff ff       	call   80102fd9 <lapicid>
801041bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801041bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041c6:	eb 3b                	jmp    80104203 <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
801041c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041cb:	89 d0                	mov    %edx,%eax
801041cd:	c1 e0 02             	shl    $0x2,%eax
801041d0:	01 d0                	add    %edx,%eax
801041d2:	01 c0                	add    %eax,%eax
801041d4:	01 d0                	add    %edx,%eax
801041d6:	c1 e0 04             	shl    $0x4,%eax
801041d9:	05 40 3a 11 80       	add    $0x80113a40,%eax
801041de:	8a 00                	mov    (%eax),%al
801041e0:	0f b6 c0             	movzbl %al,%eax
801041e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801041e6:	75 18                	jne    80104200 <mycpu+0x69>
      return &cpus[i];
801041e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041eb:	89 d0                	mov    %edx,%eax
801041ed:	c1 e0 02             	shl    $0x2,%eax
801041f0:	01 d0                	add    %edx,%eax
801041f2:	01 c0                	add    %eax,%eax
801041f4:	01 d0                	add    %edx,%eax
801041f6:	c1 e0 04             	shl    $0x4,%eax
801041f9:	05 40 3a 11 80       	add    $0x80113a40,%eax
801041fe:	eb 19                	jmp    80104219 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104200:	ff 45 f4             	incl   -0xc(%ebp)
80104203:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104208:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010420b:	7c bb                	jl     801041c8 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010420d:	c7 04 24 5a 85 10 80 	movl   $0x8010855a,(%esp)
80104214:	e8 3b c3 ff ff       	call   80100554 <panic>
}
80104219:	c9                   	leave  
8010421a:	c3                   	ret    

8010421b <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010421b:	55                   	push   %ebp
8010421c:	89 e5                	mov    %esp,%ebp
8010421e:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104221:	e8 64 0d 00 00       	call   80104f8a <pushcli>
  c = mycpu();
80104226:	e8 6c ff ff ff       	call   80104197 <mycpu>
8010422b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010422e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104231:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
8010423a:	e8 95 0d 00 00       	call   80104fd4 <popcli>
  return p;
8010423f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104242:	c9                   	leave  
80104243:	c3                   	ret    

80104244 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010424a:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104251:	e8 d5 0b 00 00       	call   80104e2b <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104256:	c7 45 f4 14 40 11 80 	movl   $0x80114014,-0xc(%ebp)
8010425d:	eb 50                	jmp    801042af <allocproc+0x6b>
    if(p->state == UNUSED)
8010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104262:	8b 40 0c             	mov    0xc(%eax),%eax
80104265:	85 c0                	test   %eax,%eax
80104267:	75 42                	jne    801042ab <allocproc+0x67>
      goto found;
80104269:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010426a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426d:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104274:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104279:	8d 50 01             	lea    0x1(%eax),%edx
8010427c:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
80104282:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104285:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104288:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010428f:	e8 01 0c 00 00       	call   80104e95 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104294:	e8 c2 e9 ff ff       	call   80102c5b <kalloc>
80104299:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010429c:	89 42 08             	mov    %eax,0x8(%edx)
8010429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a2:	8b 40 08             	mov    0x8(%eax),%eax
801042a5:	85 c0                	test   %eax,%eax
801042a7:	75 33                	jne    801042dc <allocproc+0x98>
801042a9:	eb 20                	jmp    801042cb <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ab:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801042af:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
801042b6:	72 a7                	jb     8010425f <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801042b8:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
801042bf:	e8 d1 0b 00 00       	call   80104e95 <release>
  return 0;
801042c4:	b8 00 00 00 00       	mov    $0x0,%eax
801042c9:	eb 76                	jmp    80104341 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801042cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801042d5:	b8 00 00 00 00       	mov    $0x0,%eax
801042da:	eb 65                	jmp    80104341 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801042dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042df:	8b 40 08             	mov    0x8(%eax),%eax
801042e2:	05 00 10 00 00       	add    $0x1000,%eax
801042e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801042ea:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042f4:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801042f7:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801042fb:	ba 08 64 10 80       	mov    $0x80106408,%edx
80104300:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104303:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104305:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010430f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104315:	8b 40 1c             	mov    0x1c(%eax),%eax
80104318:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010431f:	00 
80104320:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104327:	00 
80104328:	89 04 24             	mov    %eax,(%esp)
8010432b:	e8 5e 0d 00 00       	call   8010508e <memset>
  p->context->eip = (uint)forkret;
80104330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104333:	8b 40 1c             	mov    0x1c(%eax),%eax
80104336:	ba 1d 4a 10 80       	mov    $0x80104a1d,%edx
8010433b:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104341:	c9                   	leave  
80104342:	c3                   	ret    

80104343 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104343:	55                   	push   %ebp
80104344:	89 e5                	mov    %esp,%ebp
80104346:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104349:	e8 f6 fe ff ff       	call   80104244 <allocproc>
8010434e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104354:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
80104359:	e8 e8 35 00 00       	call   80107946 <setupkvm>
8010435e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104361:	89 42 04             	mov    %eax,0x4(%edx)
80104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104367:	8b 40 04             	mov    0x4(%eax),%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	75 0c                	jne    8010437a <userinit+0x37>
    panic("userinit: out of memory?");
8010436e:	c7 04 24 6a 85 10 80 	movl   $0x8010856a,(%esp)
80104375:	e8 da c1 ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010437a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010437f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104382:	8b 40 04             	mov    0x4(%eax),%eax
80104385:	89 54 24 08          	mov    %edx,0x8(%esp)
80104389:	c7 44 24 04 c0 b4 10 	movl   $0x8010b4c0,0x4(%esp)
80104390:	80 
80104391:	89 04 24             	mov    %eax,(%esp)
80104394:	e8 0e 38 00 00       	call   80107ba7 <inituvm>
  p->sz = PGSIZE;
80104399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439c:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801043a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a5:	8b 40 18             	mov    0x18(%eax),%eax
801043a8:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801043af:	00 
801043b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043b7:	00 
801043b8:	89 04 24             	mov    %eax,(%esp)
801043bb:	e8 ce 0c 00 00       	call   8010508e <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c3:	8b 40 18             	mov    0x18(%eax),%eax
801043c6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cf:	8b 40 18             	mov    0x18(%eax),%eax
801043d2:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043db:	8b 50 18             	mov    0x18(%eax),%edx
801043de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e1:	8b 40 18             	mov    0x18(%eax),%eax
801043e4:	8b 40 2c             	mov    0x2c(%eax),%eax
801043e7:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801043eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ee:	8b 50 18             	mov    0x18(%eax),%edx
801043f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f4:	8b 40 18             	mov    0x18(%eax),%eax
801043f7:	8b 40 2c             	mov    0x2c(%eax),%eax
801043fa:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801043fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104401:	8b 40 18             	mov    0x18(%eax),%eax
80104404:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440e:	8b 40 18             	mov    0x18(%eax),%eax
80104411:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441b:	8b 40 18             	mov    0x18(%eax),%eax
8010441e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104428:	83 c0 6c             	add    $0x6c,%eax
8010442b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104432:	00 
80104433:	c7 44 24 04 83 85 10 	movl   $0x80108583,0x4(%esp)
8010443a:	80 
8010443b:	89 04 24             	mov    %eax,(%esp)
8010443e:	e8 57 0e 00 00       	call   8010529a <safestrcpy>
  p->cwd = namei("/");
80104443:	c7 04 24 8c 85 10 80 	movl   $0x8010858c,(%esp)
8010444a:	e8 00 e1 ff ff       	call   8010254f <namei>
8010444f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104452:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104455:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010445c:	e8 ca 09 00 00       	call   80104e2b <acquire>

  p->state = RUNNABLE;
80104461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104464:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010446b:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104472:	e8 1e 0a 00 00       	call   80104e95 <release>
}
80104477:	c9                   	leave  
80104478:	c3                   	ret    

80104479 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104479:	55                   	push   %ebp
8010447a:	89 e5                	mov    %esp,%ebp
8010447c:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
8010447f:	e8 97 fd ff ff       	call   8010421b <myproc>
80104484:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010448a:	8b 00                	mov    (%eax),%eax
8010448c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010448f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104493:	7e 31                	jle    801044c6 <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104495:	8b 55 08             	mov    0x8(%ebp),%edx
80104498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449b:	01 c2                	add    %eax,%edx
8010449d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a0:	8b 40 04             	mov    0x4(%eax),%eax
801044a3:	89 54 24 08          	mov    %edx,0x8(%esp)
801044a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ae:	89 04 24             	mov    %eax,(%esp)
801044b1:	e8 5c 38 00 00       	call   80107d12 <allocuvm>
801044b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801044b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044bd:	75 3e                	jne    801044fd <growproc+0x84>
      return -1;
801044bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044c4:	eb 4f                	jmp    80104515 <growproc+0x9c>
  } else if(n < 0){
801044c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801044ca:	79 31                	jns    801044fd <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801044cc:	8b 55 08             	mov    0x8(%ebp),%edx
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d2:	01 c2                	add    %eax,%edx
801044d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d7:	8b 40 04             	mov    0x4(%eax),%eax
801044da:	89 54 24 08          	mov    %edx,0x8(%esp)
801044de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801044e5:	89 04 24             	mov    %eax,(%esp)
801044e8:	e8 3b 39 00 00       	call   80107e28 <deallocuvm>
801044ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801044f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044f4:	75 07                	jne    801044fd <growproc+0x84>
      return -1;
801044f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044fb:	eb 18                	jmp    80104515 <growproc+0x9c>
  }
  curproc->sz = sz;
801044fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104500:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104503:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104505:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104508:	89 04 24             	mov    %eax,(%esp)
8010450b:	e8 10 35 00 00       	call   80107a20 <switchuvm>
  return 0;
80104510:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104515:	c9                   	leave  
80104516:	c3                   	ret    

80104517 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104517:	55                   	push   %ebp
80104518:	89 e5                	mov    %esp,%ebp
8010451a:	57                   	push   %edi
8010451b:	56                   	push   %esi
8010451c:	53                   	push   %ebx
8010451d:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104520:	e8 f6 fc ff ff       	call   8010421b <myproc>
80104525:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104528:	e8 17 fd ff ff       	call   80104244 <allocproc>
8010452d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104530:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104534:	75 0a                	jne    80104540 <fork+0x29>
    return -1;
80104536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453b:	e9 35 01 00 00       	jmp    80104675 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104540:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104543:	8b 10                	mov    (%eax),%edx
80104545:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104548:	8b 40 04             	mov    0x4(%eax),%eax
8010454b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010454f:	89 04 24             	mov    %eax,(%esp)
80104552:	e8 71 3a 00 00       	call   80107fc8 <copyuvm>
80104557:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010455a:	89 42 04             	mov    %eax,0x4(%edx)
8010455d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104560:	8b 40 04             	mov    0x4(%eax),%eax
80104563:	85 c0                	test   %eax,%eax
80104565:	75 2c                	jne    80104593 <fork+0x7c>
    kfree(np->kstack);
80104567:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010456a:	8b 40 08             	mov    0x8(%eax),%eax
8010456d:	89 04 24             	mov    %eax,(%esp)
80104570:	e8 50 e6 ff ff       	call   80102bc5 <kfree>
    np->kstack = 0;
80104575:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104578:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010457f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104582:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458e:	e9 e2 00 00 00       	jmp    80104675 <fork+0x15e>
  }
  np->sz = curproc->sz;
80104593:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104596:	8b 10                	mov    (%eax),%edx
80104598:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010459b:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010459d:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045a3:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801045a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045a9:	8b 50 18             	mov    0x18(%eax),%edx
801045ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045af:	8b 40 18             	mov    0x18(%eax),%eax
801045b2:	89 c3                	mov    %eax,%ebx
801045b4:	b8 13 00 00 00       	mov    $0x13,%eax
801045b9:	89 d7                	mov    %edx,%edi
801045bb:	89 de                	mov    %ebx,%esi
801045bd:	89 c1                	mov    %eax,%ecx
801045bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801045c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045c4:	8b 40 18             	mov    0x18(%eax),%eax
801045c7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801045ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045d5:	eb 36                	jmp    8010460d <fork+0xf6>
    if(curproc->ofile[i])
801045d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045dd:	83 c2 08             	add    $0x8,%edx
801045e0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045e4:	85 c0                	test   %eax,%eax
801045e6:	74 22                	je     8010460a <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801045e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045ee:	83 c2 08             	add    $0x8,%edx
801045f1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045f5:	89 04 24             	mov    %eax,(%esp)
801045f8:	e8 cb ca ff ff       	call   801010c8 <filedup>
801045fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104600:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104603:	83 c1 08             	add    $0x8,%ecx
80104606:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010460a:	ff 45 e4             	incl   -0x1c(%ebp)
8010460d:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104611:	7e c4                	jle    801045d7 <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80104613:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104616:	8b 40 68             	mov    0x68(%eax),%eax
80104619:	89 04 24             	mov    %eax,(%esp)
8010461c:	e8 d7 d3 ff ff       	call   801019f8 <idup>
80104621:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104624:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104627:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010462a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010462d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104630:	83 c0 6c             	add    $0x6c,%eax
80104633:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010463a:	00 
8010463b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010463f:	89 04 24             	mov    %eax,(%esp)
80104642:	e8 53 0c 00 00       	call   8010529a <safestrcpy>

  pid = np->pid;
80104647:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010464a:	8b 40 10             	mov    0x10(%eax),%eax
8010464d:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104650:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104657:	e8 cf 07 00 00       	call   80104e2b <acquire>

  np->state = RUNNABLE;
8010465c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010465f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104666:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010466d:	e8 23 08 00 00       	call   80104e95 <release>

  return pid;
80104672:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104675:	83 c4 2c             	add    $0x2c,%esp
80104678:	5b                   	pop    %ebx
80104679:	5e                   	pop    %esi
8010467a:	5f                   	pop    %edi
8010467b:	5d                   	pop    %ebp
8010467c:	c3                   	ret    

8010467d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010467d:	55                   	push   %ebp
8010467e:	89 e5                	mov    %esp,%ebp
80104680:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104683:	e8 93 fb ff ff       	call   8010421b <myproc>
80104688:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010468b:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104690:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104693:	75 0c                	jne    801046a1 <exit+0x24>
    panic("init exiting");
80104695:	c7 04 24 8e 85 10 80 	movl   $0x8010858e,(%esp)
8010469c:	e8 b3 be ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801046a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801046a8:	eb 3a                	jmp    801046e4 <exit+0x67>
    if(curproc->ofile[fd]){
801046aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046b0:	83 c2 08             	add    $0x8,%edx
801046b3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046b7:	85 c0                	test   %eax,%eax
801046b9:	74 26                	je     801046e1 <exit+0x64>
      fileclose(curproc->ofile[fd]);
801046bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046c1:	83 c2 08             	add    $0x8,%edx
801046c4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c8:	89 04 24             	mov    %eax,(%esp)
801046cb:	e8 40 ca ff ff       	call   80101110 <fileclose>
      curproc->ofile[fd] = 0;
801046d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046d6:	83 c2 08             	add    $0x8,%edx
801046d9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801046e0:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801046e1:	ff 45 f0             	incl   -0x10(%ebp)
801046e4:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801046e8:	7e c0                	jle    801046aa <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801046ea:	e8 34 ee ff ff       	call   80103523 <begin_op>
  iput(curproc->cwd);
801046ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046f2:	8b 40 68             	mov    0x68(%eax),%eax
801046f5:	89 04 24             	mov    %eax,(%esp)
801046f8:	e8 7b d4 ff ff       	call   80101b78 <iput>
  end_op();
801046fd:	e8 a3 ee ff ff       	call   801035a5 <end_op>
  curproc->cwd = 0;
80104702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104705:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010470c:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104713:	e8 13 07 00 00       	call   80104e2b <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104718:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010471b:	8b 40 14             	mov    0x14(%eax),%eax
8010471e:	89 04 24             	mov    %eax,(%esp)
80104721:	e8 cc 03 00 00       	call   80104af2 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104726:	c7 45 f4 14 40 11 80 	movl   $0x80114014,-0xc(%ebp)
8010472d:	eb 33                	jmp    80104762 <exit+0xe5>
    if(p->parent == curproc){
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	8b 40 14             	mov    0x14(%eax),%eax
80104735:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104738:	75 24                	jne    8010475e <exit+0xe1>
      p->parent = initproc;
8010473a:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
80104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104743:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104749:	8b 40 0c             	mov    0xc(%eax),%eax
8010474c:	83 f8 05             	cmp    $0x5,%eax
8010474f:	75 0d                	jne    8010475e <exit+0xe1>
        wakeup1(initproc);
80104751:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104756:	89 04 24             	mov    %eax,(%esp)
80104759:	e8 94 03 00 00       	call   80104af2 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104762:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104769:	72 c4                	jb     8010472f <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010476b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010476e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104775:	e8 c3 01 00 00       	call   8010493d <sched>
  panic("zombie exit");
8010477a:	c7 04 24 9b 85 10 80 	movl   $0x8010859b,(%esp)
80104781:	e8 ce bd ff ff       	call   80100554 <panic>

80104786 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104786:	55                   	push   %ebp
80104787:	89 e5                	mov    %esp,%ebp
80104789:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010478c:	e8 8a fa ff ff       	call   8010421b <myproc>
80104791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104794:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010479b:	e8 8b 06 00 00       	call   80104e2b <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801047a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a7:	c7 45 f4 14 40 11 80 	movl   $0x80114014,-0xc(%ebp)
801047ae:	e9 95 00 00 00       	jmp    80104848 <wait+0xc2>
      if(p->parent != curproc)
801047b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b6:	8b 40 14             	mov    0x14(%eax),%eax
801047b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801047bc:	74 05                	je     801047c3 <wait+0x3d>
        continue;
801047be:	e9 81 00 00 00       	jmp    80104844 <wait+0xbe>
      havekids = 1;
801047c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801047ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cd:	8b 40 0c             	mov    0xc(%eax),%eax
801047d0:	83 f8 05             	cmp    $0x5,%eax
801047d3:	75 6f                	jne    80104844 <wait+0xbe>
        // Found one.
        pid = p->pid;
801047d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d8:	8b 40 10             	mov    0x10(%eax),%eax
801047db:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e1:	8b 40 08             	mov    0x8(%eax),%eax
801047e4:	89 04 24             	mov    %eax,(%esp)
801047e7:	e8 d9 e3 ff ff       	call   80102bc5 <kfree>
        p->kstack = 0;
801047ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801047f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f9:	8b 40 04             	mov    0x4(%eax),%eax
801047fc:	89 04 24             	mov    %eax,(%esp)
801047ff:	e8 e8 36 00 00       	call   80107eec <freevm>
        p->pid = 0;
80104804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104807:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010480e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104811:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010481f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104822:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104833:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010483a:	e8 56 06 00 00       	call   80104e95 <release>
        return pid;
8010483f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104842:	eb 4c                	jmp    80104890 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104844:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104848:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
8010484f:	0f 82 5e ff ff ff    	jb     801047b3 <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104855:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104859:	74 0a                	je     80104865 <wait+0xdf>
8010485b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010485e:	8b 40 24             	mov    0x24(%eax),%eax
80104861:	85 c0                	test   %eax,%eax
80104863:	74 13                	je     80104878 <wait+0xf2>
      release(&ptable.lock);
80104865:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010486c:	e8 24 06 00 00       	call   80104e95 <release>
      return -1;
80104871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104876:	eb 18                	jmp    80104890 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104878:	c7 44 24 04 e0 3f 11 	movl   $0x80113fe0,0x4(%esp)
8010487f:	80 
80104880:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104883:	89 04 24             	mov    %eax,(%esp)
80104886:	e8 d1 01 00 00       	call   80104a5c <sleep>
  }
8010488b:	e9 10 ff ff ff       	jmp    801047a0 <wait+0x1a>
}
80104890:	c9                   	leave  
80104891:	c3                   	ret    

80104892 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104892:	55                   	push   %ebp
80104893:	89 e5                	mov    %esp,%ebp
80104895:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104898:	e8 fa f8 ff ff       	call   80104197 <mycpu>
8010489d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801048a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048a3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801048aa:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801048ad:	e8 7e f8 ff ff       	call   80104130 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048b2:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
801048b9:	e8 6d 05 00 00       	call   80104e2b <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048be:	c7 45 f4 14 40 11 80 	movl   $0x80114014,-0xc(%ebp)
801048c5:	eb 5c                	jmp    80104923 <scheduler+0x91>
      if(p->state != RUNNABLE)
801048c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ca:	8b 40 0c             	mov    0xc(%eax),%eax
801048cd:	83 f8 03             	cmp    $0x3,%eax
801048d0:	74 02                	je     801048d4 <scheduler+0x42>
        continue;
801048d2:	eb 4b                	jmp    8010491f <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801048d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048da:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801048e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e3:	89 04 24             	mov    %eax,(%esp)
801048e6:	e8 35 31 00 00       	call   80107a20 <switchuvm>
      p->state = RUNNING;
801048eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ee:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801048f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f8:	8b 40 1c             	mov    0x1c(%eax),%eax
801048fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048fe:	83 c2 04             	add    $0x4,%edx
80104901:	89 44 24 04          	mov    %eax,0x4(%esp)
80104905:	89 14 24             	mov    %edx,(%esp)
80104908:	e8 fb 09 00 00       	call   80105308 <swtch>
      switchkvm();
8010490d:	e8 f4 30 00 00       	call   80107a06 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104912:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104915:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010491c:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010491f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104923:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
8010492a:	72 9b                	jb     801048c7 <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
8010492c:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104933:	e8 5d 05 00 00       	call   80104e95 <release>

  }
80104938:	e9 70 ff ff ff       	jmp    801048ad <scheduler+0x1b>

8010493d <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010493d:	55                   	push   %ebp
8010493e:	89 e5                	mov    %esp,%ebp
80104940:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104943:	e8 d3 f8 ff ff       	call   8010421b <myproc>
80104948:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010494b:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104952:	e8 02 06 00 00       	call   80104f59 <holding>
80104957:	85 c0                	test   %eax,%eax
80104959:	75 0c                	jne    80104967 <sched+0x2a>
    panic("sched ptable.lock");
8010495b:	c7 04 24 a7 85 10 80 	movl   $0x801085a7,(%esp)
80104962:	e8 ed bb ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
80104967:	e8 2b f8 ff ff       	call   80104197 <mycpu>
8010496c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104972:	83 f8 01             	cmp    $0x1,%eax
80104975:	74 0c                	je     80104983 <sched+0x46>
    panic("sched locks");
80104977:	c7 04 24 b9 85 10 80 	movl   $0x801085b9,(%esp)
8010497e:	e8 d1 bb ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
80104983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104986:	8b 40 0c             	mov    0xc(%eax),%eax
80104989:	83 f8 04             	cmp    $0x4,%eax
8010498c:	75 0c                	jne    8010499a <sched+0x5d>
    panic("sched running");
8010498e:	c7 04 24 c5 85 10 80 	movl   $0x801085c5,(%esp)
80104995:	e8 ba bb ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
8010499a:	e8 81 f7 ff ff       	call   80104120 <readeflags>
8010499f:	25 00 02 00 00       	and    $0x200,%eax
801049a4:	85 c0                	test   %eax,%eax
801049a6:	74 0c                	je     801049b4 <sched+0x77>
    panic("sched interruptible");
801049a8:	c7 04 24 d3 85 10 80 	movl   $0x801085d3,(%esp)
801049af:	e8 a0 bb ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
801049b4:	e8 de f7 ff ff       	call   80104197 <mycpu>
801049b9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801049c2:	e8 d0 f7 ff ff       	call   80104197 <mycpu>
801049c7:	8b 40 04             	mov    0x4(%eax),%eax
801049ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049cd:	83 c2 1c             	add    $0x1c,%edx
801049d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d4:	89 14 24             	mov    %edx,(%esp)
801049d7:	e8 2c 09 00 00       	call   80105308 <swtch>
  mycpu()->intena = intena;
801049dc:	e8 b6 f7 ff ff       	call   80104197 <mycpu>
801049e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049e4:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801049ea:	c9                   	leave  
801049eb:	c3                   	ret    

801049ec <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801049ec:	55                   	push   %ebp
801049ed:	89 e5                	mov    %esp,%ebp
801049ef:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801049f2:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
801049f9:	e8 2d 04 00 00       	call   80104e2b <acquire>
  myproc()->state = RUNNABLE;
801049fe:	e8 18 f8 ff ff       	call   8010421b <myproc>
80104a03:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104a0a:	e8 2e ff ff ff       	call   8010493d <sched>
  release(&ptable.lock);
80104a0f:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104a16:	e8 7a 04 00 00       	call   80104e95 <release>
}
80104a1b:	c9                   	leave  
80104a1c:	c3                   	ret    

80104a1d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a1d:	55                   	push   %ebp
80104a1e:	89 e5                	mov    %esp,%ebp
80104a20:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104a23:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104a2a:	e8 66 04 00 00       	call   80104e95 <release>

  if (first) {
80104a2f:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104a34:	85 c0                	test   %eax,%eax
80104a36:	74 22                	je     80104a5a <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a38:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104a3f:	00 00 00 
    iinit(ROOTDEV);
80104a42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a49:	e8 75 cc ff ff       	call   801016c3 <iinit>
    initlog(ROOTDEV);
80104a4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a55:	e8 ca e8 ff ff       	call   80103324 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104a5a:	c9                   	leave  
80104a5b:	c3                   	ret    

80104a5c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a5c:	55                   	push   %ebp
80104a5d:	89 e5                	mov    %esp,%ebp
80104a5f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104a62:	e8 b4 f7 ff ff       	call   8010421b <myproc>
80104a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a6e:	75 0c                	jne    80104a7c <sleep+0x20>
    panic("sleep");
80104a70:	c7 04 24 e7 85 10 80 	movl   $0x801085e7,(%esp)
80104a77:	e8 d8 ba ff ff       	call   80100554 <panic>

  if(lk == 0)
80104a7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a80:	75 0c                	jne    80104a8e <sleep+0x32>
    panic("sleep without lk");
80104a82:	c7 04 24 ed 85 10 80 	movl   $0x801085ed,(%esp)
80104a89:	e8 c6 ba ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a8e:	81 7d 0c e0 3f 11 80 	cmpl   $0x80113fe0,0xc(%ebp)
80104a95:	74 17                	je     80104aae <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a97:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104a9e:	e8 88 03 00 00       	call   80104e2b <acquire>
    release(lk);
80104aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa6:	89 04 24             	mov    %eax,(%esp)
80104aa9:	e8 e7 03 00 00       	call   80104e95 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab1:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab4:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aba:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104ac1:	e8 77 fe ff ff       	call   8010493d <sched>

  // Tidy up.
  p->chan = 0;
80104ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ad0:	81 7d 0c e0 3f 11 80 	cmpl   $0x80113fe0,0xc(%ebp)
80104ad7:	74 17                	je     80104af0 <sleep+0x94>
    release(&ptable.lock);
80104ad9:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104ae0:	e8 b0 03 00 00       	call   80104e95 <release>
    acquire(lk);
80104ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae8:	89 04 24             	mov    %eax,(%esp)
80104aeb:	e8 3b 03 00 00       	call   80104e2b <acquire>
  }
}
80104af0:	c9                   	leave  
80104af1:	c3                   	ret    

80104af2 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104af2:	55                   	push   %ebp
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af8:	c7 45 fc 14 40 11 80 	movl   $0x80114014,-0x4(%ebp)
80104aff:	eb 24                	jmp    80104b25 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b04:	8b 40 0c             	mov    0xc(%eax),%eax
80104b07:	83 f8 02             	cmp    $0x2,%eax
80104b0a:	75 15                	jne    80104b21 <wakeup1+0x2f>
80104b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b0f:	8b 40 20             	mov    0x20(%eax),%eax
80104b12:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b15:	75 0a                	jne    80104b21 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b1a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b21:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104b25:	81 7d fc 14 5f 11 80 	cmpl   $0x80115f14,-0x4(%ebp)
80104b2c:	72 d3                	jb     80104b01 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104b2e:	c9                   	leave  
80104b2f:	c3                   	ret    

80104b30 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104b36:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104b3d:	e8 e9 02 00 00       	call   80104e2b <acquire>
  wakeup1(chan);
80104b42:	8b 45 08             	mov    0x8(%ebp),%eax
80104b45:	89 04 24             	mov    %eax,(%esp)
80104b48:	e8 a5 ff ff ff       	call   80104af2 <wakeup1>
  release(&ptable.lock);
80104b4d:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104b54:	e8 3c 03 00 00       	call   80104e95 <release>
}
80104b59:	c9                   	leave  
80104b5a:	c3                   	ret    

80104b5b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b5b:	55                   	push   %ebp
80104b5c:	89 e5                	mov    %esp,%ebp
80104b5e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b61:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104b68:	e8 be 02 00 00       	call   80104e2b <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b6d:	c7 45 f4 14 40 11 80 	movl   $0x80114014,-0xc(%ebp)
80104b74:	eb 41                	jmp    80104bb7 <kill+0x5c>
    if(p->pid == pid){
80104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b79:	8b 40 10             	mov    0x10(%eax),%eax
80104b7c:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b7f:	75 32                	jne    80104bb3 <kill+0x58>
      p->killed = 1;
80104b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b84:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b91:	83 f8 02             	cmp    $0x2,%eax
80104b94:	75 0a                	jne    80104ba0 <kill+0x45>
        p->state = RUNNABLE;
80104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b99:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ba0:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104ba7:	e8 e9 02 00 00       	call   80104e95 <release>
      return 0;
80104bac:	b8 00 00 00 00       	mov    $0x0,%eax
80104bb1:	eb 1e                	jmp    80104bd1 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb3:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104bb7:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104bbe:	72 b6                	jb     80104b76 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104bc0:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104bc7:	e8 c9 02 00 00       	call   80104e95 <release>
  return -1;
80104bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd1:	c9                   	leave  
80104bd2:	c3                   	ret    

80104bd3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bd3:	55                   	push   %ebp
80104bd4:	89 e5                	mov    %esp,%ebp
80104bd6:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd9:	c7 45 f0 14 40 11 80 	movl   $0x80114014,-0x10(%ebp)
80104be0:	e9 d5 00 00 00       	jmp    80104cba <procdump+0xe7>
    if(p->state == UNUSED)
80104be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be8:	8b 40 0c             	mov    0xc(%eax),%eax
80104beb:	85 c0                	test   %eax,%eax
80104bed:	75 05                	jne    80104bf4 <procdump+0x21>
      continue;
80104bef:	e9 c2 00 00 00       	jmp    80104cb6 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf7:	8b 40 0c             	mov    0xc(%eax),%eax
80104bfa:	83 f8 05             	cmp    $0x5,%eax
80104bfd:	77 23                	ja     80104c22 <procdump+0x4f>
80104bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c02:	8b 40 0c             	mov    0xc(%eax),%eax
80104c05:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	74 12                	je     80104c22 <procdump+0x4f>
      state = states[p->state];
80104c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c13:	8b 40 0c             	mov    0xc(%eax),%eax
80104c16:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c20:	eb 07                	jmp    80104c29 <procdump+0x56>
    else
      state = "???";
80104c22:	c7 45 ec fe 85 10 80 	movl   $0x801085fe,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2c:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c32:	8b 40 10             	mov    0x10(%eax),%eax
80104c35:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104c39:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104c3c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c40:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c44:	c7 04 24 02 86 10 80 	movl   $0x80108602,(%esp)
80104c4b:	e8 71 b7 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80104c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c53:	8b 40 0c             	mov    0xc(%eax),%eax
80104c56:	83 f8 02             	cmp    $0x2,%eax
80104c59:	75 4f                	jne    80104caa <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c61:	8b 40 0c             	mov    0xc(%eax),%eax
80104c64:	83 c0 08             	add    $0x8,%eax
80104c67:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c6e:	89 04 24             	mov    %eax,(%esp)
80104c71:	e8 6c 02 00 00       	call   80104ee2 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c7d:	eb 1a                	jmp    80104c99 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c82:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c86:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c8a:	c7 04 24 0b 86 10 80 	movl   $0x8010860b,(%esp)
80104c91:	e8 2b b7 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104c96:	ff 45 f4             	incl   -0xc(%ebp)
80104c99:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104c9d:	7f 0b                	jg     80104caa <procdump+0xd7>
80104c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ca6:	85 c0                	test   %eax,%eax
80104ca8:	75 d5                	jne    80104c7f <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104caa:	c7 04 24 0f 86 10 80 	movl   $0x8010860f,(%esp)
80104cb1:	e8 0b b7 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb6:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104cba:	81 7d f0 14 5f 11 80 	cmpl   $0x80115f14,-0x10(%ebp)
80104cc1:	0f 82 1e ff ff ff    	jb     80104be5 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104cc7:	c9                   	leave  
80104cc8:	c3                   	ret    
80104cc9:	00 00                	add    %al,(%eax)
	...

80104ccc <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ccc:	55                   	push   %ebp
80104ccd:	89 e5                	mov    %esp,%ebp
80104ccf:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd5:	83 c0 04             	add    $0x4,%eax
80104cd8:	c7 44 24 04 3b 86 10 	movl   $0x8010863b,0x4(%esp)
80104cdf:	80 
80104ce0:	89 04 24             	mov    %eax,(%esp)
80104ce3:	e8 22 01 00 00       	call   80104e0a <initlock>
  lk->name = name;
80104ce8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cee:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfd:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104d04:	c9                   	leave  
80104d05:	c3                   	ret    

80104d06 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d06:	55                   	push   %ebp
80104d07:	89 e5                	mov    %esp,%ebp
80104d09:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0f:	83 c0 04             	add    $0x4,%eax
80104d12:	89 04 24             	mov    %eax,(%esp)
80104d15:	e8 11 01 00 00       	call   80104e2b <acquire>
  while (lk->locked) {
80104d1a:	eb 15                	jmp    80104d31 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1f:	83 c0 04             	add    $0x4,%eax
80104d22:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d26:	8b 45 08             	mov    0x8(%ebp),%eax
80104d29:	89 04 24             	mov    %eax,(%esp)
80104d2c:	e8 2b fd ff ff       	call   80104a5c <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104d31:	8b 45 08             	mov    0x8(%ebp),%eax
80104d34:	8b 00                	mov    (%eax),%eax
80104d36:	85 c0                	test   %eax,%eax
80104d38:	75 e2                	jne    80104d1c <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104d43:	e8 d3 f4 ff ff       	call   8010421b <myproc>
80104d48:	8b 50 10             	mov    0x10(%eax),%edx
80104d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4e:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104d51:	8b 45 08             	mov    0x8(%ebp),%eax
80104d54:	83 c0 04             	add    $0x4,%eax
80104d57:	89 04 24             	mov    %eax,(%esp)
80104d5a:	e8 36 01 00 00       	call   80104e95 <release>
}
80104d5f:	c9                   	leave  
80104d60:	c3                   	ret    

80104d61 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d61:	55                   	push   %ebp
80104d62:	89 e5                	mov    %esp,%ebp
80104d64:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104d67:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6a:	83 c0 04             	add    $0x4,%eax
80104d6d:	89 04 24             	mov    %eax,(%esp)
80104d70:	e8 b6 00 00 00       	call   80104e2b <acquire>
  lk->locked = 0;
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d81:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104d88:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8b:	89 04 24             	mov    %eax,(%esp)
80104d8e:	e8 9d fd ff ff       	call   80104b30 <wakeup>
  release(&lk->lk);
80104d93:	8b 45 08             	mov    0x8(%ebp),%eax
80104d96:	83 c0 04             	add    $0x4,%eax
80104d99:	89 04 24             	mov    %eax,(%esp)
80104d9c:	e8 f4 00 00 00       	call   80104e95 <release>
}
80104da1:	c9                   	leave  
80104da2:	c3                   	ret    

80104da3 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104da3:	55                   	push   %ebp
80104da4:	89 e5                	mov    %esp,%ebp
80104da6:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104da9:	8b 45 08             	mov    0x8(%ebp),%eax
80104dac:	83 c0 04             	add    $0x4,%eax
80104daf:	89 04 24             	mov    %eax,(%esp)
80104db2:	e8 74 00 00 00       	call   80104e2b <acquire>
  r = lk->locked;
80104db7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dba:	8b 00                	mov    (%eax),%eax
80104dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc2:	83 c0 04             	add    $0x4,%eax
80104dc5:	89 04 24             	mov    %eax,(%esp)
80104dc8:	e8 c8 00 00 00       	call   80104e95 <release>
  return r;
80104dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104dd0:	c9                   	leave  
80104dd1:	c3                   	ret    
	...

80104dd4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104dda:	9c                   	pushf  
80104ddb:	58                   	pop    %eax
80104ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104de2:	c9                   	leave  
80104de3:	c3                   	ret    

80104de4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104de7:	fa                   	cli    
}
80104de8:	5d                   	pop    %ebp
80104de9:	c3                   	ret    

80104dea <sti>:

static inline void
sti(void)
{
80104dea:	55                   	push   %ebp
80104deb:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104ded:	fb                   	sti    
}
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    

80104df0 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104df6:	8b 55 08             	mov    0x8(%ebp),%edx
80104df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dff:	f0 87 02             	lock xchg %eax,(%edx)
80104e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    

80104e0a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e0a:	55                   	push   %ebp
80104e0b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e10:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e13:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104e16:	8b 45 08             	mov    0x8(%ebp),%eax
80104e19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e29:	5d                   	pop    %ebp
80104e2a:	c3                   	ret    

80104e2b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e2b:	55                   	push   %ebp
80104e2c:	89 e5                	mov    %esp,%ebp
80104e2e:	53                   	push   %ebx
80104e2f:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e32:	e8 53 01 00 00       	call   80104f8a <pushcli>
  if(holding(lk))
80104e37:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3a:	89 04 24             	mov    %eax,(%esp)
80104e3d:	e8 17 01 00 00       	call   80104f59 <holding>
80104e42:	85 c0                	test   %eax,%eax
80104e44:	74 0c                	je     80104e52 <acquire+0x27>
    panic("acquire");
80104e46:	c7 04 24 46 86 10 80 	movl   $0x80108646,(%esp)
80104e4d:	e8 02 b7 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104e52:	90                   	nop
80104e53:	8b 45 08             	mov    0x8(%ebp),%eax
80104e56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104e5d:	00 
80104e5e:	89 04 24             	mov    %eax,(%esp)
80104e61:	e8 8a ff ff ff       	call   80104df0 <xchg>
80104e66:	85 c0                	test   %eax,%eax
80104e68:	75 e9                	jne    80104e53 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104e6a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104e6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e72:	e8 20 f3 ff ff       	call   80104197 <mycpu>
80104e77:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7d:	83 c0 0c             	add    $0xc,%eax
80104e80:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e84:	8d 45 08             	lea    0x8(%ebp),%eax
80104e87:	89 04 24             	mov    %eax,(%esp)
80104e8a:	e8 53 00 00 00       	call   80104ee2 <getcallerpcs>
}
80104e8f:	83 c4 14             	add    $0x14,%esp
80104e92:	5b                   	pop    %ebx
80104e93:	5d                   	pop    %ebp
80104e94:	c3                   	ret    

80104e95 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104e95:	55                   	push   %ebp
80104e96:	89 e5                	mov    %esp,%ebp
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9e:	89 04 24             	mov    %eax,(%esp)
80104ea1:	e8 b3 00 00 00       	call   80104f59 <holding>
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	75 0c                	jne    80104eb6 <release+0x21>
    panic("release");
80104eaa:	c7 04 24 4e 86 10 80 	movl   $0x8010864e,(%esp)
80104eb1:	e8 9e b6 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
80104eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104eca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed2:	8b 55 08             	mov    0x8(%ebp),%edx
80104ed5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104edb:	e8 f4 00 00 00       	call   80104fd4 <popcli>
}
80104ee0:	c9                   	leave  
80104ee1:	c3                   	ret    

80104ee2 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ee2:	55                   	push   %ebp
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eeb:	83 e8 08             	sub    $0x8,%eax
80104eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ef1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104ef8:	eb 37                	jmp    80104f31 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104efa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104efe:	74 37                	je     80104f37 <getcallerpcs+0x55>
80104f00:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104f07:	76 2e                	jbe    80104f37 <getcallerpcs+0x55>
80104f09:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104f0d:	74 28                	je     80104f37 <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f19:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f1c:	01 c2                	add    %eax,%edx
80104f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f21:	8b 40 04             	mov    0x4(%eax),%eax
80104f24:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f29:	8b 00                	mov    (%eax),%eax
80104f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f2e:	ff 45 f8             	incl   -0x8(%ebp)
80104f31:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f35:	7e c3                	jle    80104efa <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f37:	eb 18                	jmp    80104f51 <getcallerpcs+0x6f>
    pcs[i] = 0;
80104f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f43:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f46:	01 d0                	add    %edx,%eax
80104f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f4e:	ff 45 f8             	incl   -0x8(%ebp)
80104f51:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f55:	7e e2                	jle    80104f39 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80104f57:	c9                   	leave  
80104f58:	c3                   	ret    

80104f59 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104f59:	55                   	push   %ebp
80104f5a:	89 e5                	mov    %esp,%ebp
80104f5c:	53                   	push   %ebx
80104f5d:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104f60:	8b 45 08             	mov    0x8(%ebp),%eax
80104f63:	8b 00                	mov    (%eax),%eax
80104f65:	85 c0                	test   %eax,%eax
80104f67:	74 16                	je     80104f7f <holding+0x26>
80104f69:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6c:	8b 58 08             	mov    0x8(%eax),%ebx
80104f6f:	e8 23 f2 ff ff       	call   80104197 <mycpu>
80104f74:	39 c3                	cmp    %eax,%ebx
80104f76:	75 07                	jne    80104f7f <holding+0x26>
80104f78:	b8 01 00 00 00       	mov    $0x1,%eax
80104f7d:	eb 05                	jmp    80104f84 <holding+0x2b>
80104f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f84:	83 c4 04             	add    $0x4,%esp
80104f87:	5b                   	pop    %ebx
80104f88:	5d                   	pop    %ebp
80104f89:	c3                   	ret    

80104f8a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f8a:	55                   	push   %ebp
80104f8b:	89 e5                	mov    %esp,%ebp
80104f8d:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104f90:	e8 3f fe ff ff       	call   80104dd4 <readeflags>
80104f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104f98:	e8 47 fe ff ff       	call   80104de4 <cli>
  if(mycpu()->ncli == 0)
80104f9d:	e8 f5 f1 ff ff       	call   80104197 <mycpu>
80104fa2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	75 14                	jne    80104fc0 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104fac:	e8 e6 f1 ff ff       	call   80104197 <mycpu>
80104fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb4:	81 e2 00 02 00 00    	and    $0x200,%edx
80104fba:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104fc0:	e8 d2 f1 ff ff       	call   80104197 <mycpu>
80104fc5:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fcb:	42                   	inc    %edx
80104fcc:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104fd2:	c9                   	leave  
80104fd3:	c3                   	ret    

80104fd4 <popcli>:

void
popcli(void)
{
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104fda:	e8 f5 fd ff ff       	call   80104dd4 <readeflags>
80104fdf:	25 00 02 00 00       	and    $0x200,%eax
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	74 0c                	je     80104ff4 <popcli+0x20>
    panic("popcli - interruptible");
80104fe8:	c7 04 24 56 86 10 80 	movl   $0x80108656,(%esp)
80104fef:	e8 60 b5 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
80104ff4:	e8 9e f1 ff ff       	call   80104197 <mycpu>
80104ff9:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fff:	4a                   	dec    %edx
80105000:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105006:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010500c:	85 c0                	test   %eax,%eax
8010500e:	79 0c                	jns    8010501c <popcli+0x48>
    panic("popcli");
80105010:	c7 04 24 6d 86 10 80 	movl   $0x8010866d,(%esp)
80105017:	e8 38 b5 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010501c:	e8 76 f1 ff ff       	call   80104197 <mycpu>
80105021:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105027:	85 c0                	test   %eax,%eax
80105029:	75 14                	jne    8010503f <popcli+0x6b>
8010502b:	e8 67 f1 ff ff       	call   80104197 <mycpu>
80105030:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105036:	85 c0                	test   %eax,%eax
80105038:	74 05                	je     8010503f <popcli+0x6b>
    sti();
8010503a:	e8 ab fd ff ff       	call   80104dea <sti>
}
8010503f:	c9                   	leave  
80105040:	c3                   	ret    
80105041:	00 00                	add    %al,(%eax)
	...

80105044 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	57                   	push   %edi
80105048:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105049:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010504c:	8b 55 10             	mov    0x10(%ebp),%edx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105052:	89 cb                	mov    %ecx,%ebx
80105054:	89 df                	mov    %ebx,%edi
80105056:	89 d1                	mov    %edx,%ecx
80105058:	fc                   	cld    
80105059:	f3 aa                	rep stos %al,%es:(%edi)
8010505b:	89 ca                	mov    %ecx,%edx
8010505d:	89 fb                	mov    %edi,%ebx
8010505f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105062:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105065:	5b                   	pop    %ebx
80105066:	5f                   	pop    %edi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    

80105069 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105069:	55                   	push   %ebp
8010506a:	89 e5                	mov    %esp,%ebp
8010506c:	57                   	push   %edi
8010506d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010506e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105071:	8b 55 10             	mov    0x10(%ebp),%edx
80105074:	8b 45 0c             	mov    0xc(%ebp),%eax
80105077:	89 cb                	mov    %ecx,%ebx
80105079:	89 df                	mov    %ebx,%edi
8010507b:	89 d1                	mov    %edx,%ecx
8010507d:	fc                   	cld    
8010507e:	f3 ab                	rep stos %eax,%es:(%edi)
80105080:	89 ca                	mov    %ecx,%edx
80105082:	89 fb                	mov    %edi,%ebx
80105084:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105087:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010508a:	5b                   	pop    %ebx
8010508b:	5f                   	pop    %edi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    

8010508e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010508e:	55                   	push   %ebp
8010508f:	89 e5                	mov    %esp,%ebp
80105091:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105094:	8b 45 08             	mov    0x8(%ebp),%eax
80105097:	83 e0 03             	and    $0x3,%eax
8010509a:	85 c0                	test   %eax,%eax
8010509c:	75 49                	jne    801050e7 <memset+0x59>
8010509e:	8b 45 10             	mov    0x10(%ebp),%eax
801050a1:	83 e0 03             	and    $0x3,%eax
801050a4:	85 c0                	test   %eax,%eax
801050a6:	75 3f                	jne    801050e7 <memset+0x59>
    c &= 0xFF;
801050a8:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801050af:	8b 45 10             	mov    0x10(%ebp),%eax
801050b2:	c1 e8 02             	shr    $0x2,%eax
801050b5:	89 c2                	mov    %eax,%edx
801050b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ba:	c1 e0 18             	shl    $0x18,%eax
801050bd:	89 c1                	mov    %eax,%ecx
801050bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c2:	c1 e0 10             	shl    $0x10,%eax
801050c5:	09 c1                	or     %eax,%ecx
801050c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ca:	c1 e0 08             	shl    $0x8,%eax
801050cd:	09 c8                	or     %ecx,%eax
801050cf:	0b 45 0c             	or     0xc(%ebp),%eax
801050d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050da:	8b 45 08             	mov    0x8(%ebp),%eax
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	e8 84 ff ff ff       	call   80105069 <stosl>
801050e5:	eb 19                	jmp    80105100 <memset+0x72>
  } else
    stosb(dst, c, n);
801050e7:	8b 45 10             	mov    0x10(%ebp),%eax
801050ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801050ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f5:	8b 45 08             	mov    0x8(%ebp),%eax
801050f8:	89 04 24             	mov    %eax,(%esp)
801050fb:	e8 44 ff ff ff       	call   80105044 <stosb>
  return dst;
80105100:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105103:	c9                   	leave  
80105104:	c3                   	ret    

80105105 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105105:	55                   	push   %ebp
80105106:	89 e5                	mov    %esp,%ebp
80105108:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010510b:	8b 45 08             	mov    0x8(%ebp),%eax
8010510e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105111:	8b 45 0c             	mov    0xc(%ebp),%eax
80105114:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105117:	eb 2a                	jmp    80105143 <memcmp+0x3e>
    if(*s1 != *s2)
80105119:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010511c:	8a 10                	mov    (%eax),%dl
8010511e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105121:	8a 00                	mov    (%eax),%al
80105123:	38 c2                	cmp    %al,%dl
80105125:	74 16                	je     8010513d <memcmp+0x38>
      return *s1 - *s2;
80105127:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010512a:	8a 00                	mov    (%eax),%al
8010512c:	0f b6 d0             	movzbl %al,%edx
8010512f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105132:	8a 00                	mov    (%eax),%al
80105134:	0f b6 c0             	movzbl %al,%eax
80105137:	29 c2                	sub    %eax,%edx
80105139:	89 d0                	mov    %edx,%eax
8010513b:	eb 18                	jmp    80105155 <memcmp+0x50>
    s1++, s2++;
8010513d:	ff 45 fc             	incl   -0x4(%ebp)
80105140:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105143:	8b 45 10             	mov    0x10(%ebp),%eax
80105146:	8d 50 ff             	lea    -0x1(%eax),%edx
80105149:	89 55 10             	mov    %edx,0x10(%ebp)
8010514c:	85 c0                	test   %eax,%eax
8010514e:	75 c9                	jne    80105119 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105150:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    

80105157 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105157:	55                   	push   %ebp
80105158:	89 e5                	mov    %esp,%ebp
8010515a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010515d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105160:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105163:	8b 45 08             	mov    0x8(%ebp),%eax
80105166:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105169:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010516c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010516f:	73 3a                	jae    801051ab <memmove+0x54>
80105171:	8b 45 10             	mov    0x10(%ebp),%eax
80105174:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105177:	01 d0                	add    %edx,%eax
80105179:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010517c:	76 2d                	jbe    801051ab <memmove+0x54>
    s += n;
8010517e:	8b 45 10             	mov    0x10(%ebp),%eax
80105181:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105184:	8b 45 10             	mov    0x10(%ebp),%eax
80105187:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010518a:	eb 10                	jmp    8010519c <memmove+0x45>
      *--d = *--s;
8010518c:	ff 4d f8             	decl   -0x8(%ebp)
8010518f:	ff 4d fc             	decl   -0x4(%ebp)
80105192:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105195:	8a 10                	mov    (%eax),%dl
80105197:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010519a:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010519c:	8b 45 10             	mov    0x10(%ebp),%eax
8010519f:	8d 50 ff             	lea    -0x1(%eax),%edx
801051a2:	89 55 10             	mov    %edx,0x10(%ebp)
801051a5:	85 c0                	test   %eax,%eax
801051a7:	75 e3                	jne    8010518c <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051a9:	eb 25                	jmp    801051d0 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801051ab:	eb 16                	jmp    801051c3 <memmove+0x6c>
      *d++ = *s++;
801051ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051b0:	8d 50 01             	lea    0x1(%eax),%edx
801051b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
801051b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051b9:	8d 4a 01             	lea    0x1(%edx),%ecx
801051bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801051bf:	8a 12                	mov    (%edx),%dl
801051c1:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801051c3:	8b 45 10             	mov    0x10(%ebp),%eax
801051c6:	8d 50 ff             	lea    -0x1(%eax),%edx
801051c9:	89 55 10             	mov    %edx,0x10(%ebp)
801051cc:	85 c0                	test   %eax,%eax
801051ce:	75 dd                	jne    801051ad <memmove+0x56>
      *d++ = *s++;

  return dst;
801051d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051d3:	c9                   	leave  
801051d4:	c3                   	ret    

801051d5 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801051d5:	55                   	push   %ebp
801051d6:	89 e5                	mov    %esp,%ebp
801051d8:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801051db:	8b 45 10             	mov    0x10(%ebp),%eax
801051de:	89 44 24 08          	mov    %eax,0x8(%esp)
801051e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e9:	8b 45 08             	mov    0x8(%ebp),%eax
801051ec:	89 04 24             	mov    %eax,(%esp)
801051ef:	e8 63 ff ff ff       	call   80105157 <memmove>
}
801051f4:	c9                   	leave  
801051f5:	c3                   	ret    

801051f6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801051f6:	55                   	push   %ebp
801051f7:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801051f9:	eb 09                	jmp    80105204 <strncmp+0xe>
    n--, p++, q++;
801051fb:	ff 4d 10             	decl   0x10(%ebp)
801051fe:	ff 45 08             	incl   0x8(%ebp)
80105201:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105204:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105208:	74 17                	je     80105221 <strncmp+0x2b>
8010520a:	8b 45 08             	mov    0x8(%ebp),%eax
8010520d:	8a 00                	mov    (%eax),%al
8010520f:	84 c0                	test   %al,%al
80105211:	74 0e                	je     80105221 <strncmp+0x2b>
80105213:	8b 45 08             	mov    0x8(%ebp),%eax
80105216:	8a 10                	mov    (%eax),%dl
80105218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521b:	8a 00                	mov    (%eax),%al
8010521d:	38 c2                	cmp    %al,%dl
8010521f:	74 da                	je     801051fb <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105221:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105225:	75 07                	jne    8010522e <strncmp+0x38>
    return 0;
80105227:	b8 00 00 00 00       	mov    $0x0,%eax
8010522c:	eb 14                	jmp    80105242 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
8010522e:	8b 45 08             	mov    0x8(%ebp),%eax
80105231:	8a 00                	mov    (%eax),%al
80105233:	0f b6 d0             	movzbl %al,%edx
80105236:	8b 45 0c             	mov    0xc(%ebp),%eax
80105239:	8a 00                	mov    (%eax),%al
8010523b:	0f b6 c0             	movzbl %al,%eax
8010523e:	29 c2                	sub    %eax,%edx
80105240:	89 d0                	mov    %edx,%eax
}
80105242:	5d                   	pop    %ebp
80105243:	c3                   	ret    

80105244 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010524a:	8b 45 08             	mov    0x8(%ebp),%eax
8010524d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105250:	90                   	nop
80105251:	8b 45 10             	mov    0x10(%ebp),%eax
80105254:	8d 50 ff             	lea    -0x1(%eax),%edx
80105257:	89 55 10             	mov    %edx,0x10(%ebp)
8010525a:	85 c0                	test   %eax,%eax
8010525c:	7e 1c                	jle    8010527a <strncpy+0x36>
8010525e:	8b 45 08             	mov    0x8(%ebp),%eax
80105261:	8d 50 01             	lea    0x1(%eax),%edx
80105264:	89 55 08             	mov    %edx,0x8(%ebp)
80105267:	8b 55 0c             	mov    0xc(%ebp),%edx
8010526a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010526d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105270:	8a 12                	mov    (%edx),%dl
80105272:	88 10                	mov    %dl,(%eax)
80105274:	8a 00                	mov    (%eax),%al
80105276:	84 c0                	test   %al,%al
80105278:	75 d7                	jne    80105251 <strncpy+0xd>
    ;
  while(n-- > 0)
8010527a:	eb 0c                	jmp    80105288 <strncpy+0x44>
    *s++ = 0;
8010527c:	8b 45 08             	mov    0x8(%ebp),%eax
8010527f:	8d 50 01             	lea    0x1(%eax),%edx
80105282:	89 55 08             	mov    %edx,0x8(%ebp)
80105285:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105288:	8b 45 10             	mov    0x10(%ebp),%eax
8010528b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010528e:	89 55 10             	mov    %edx,0x10(%ebp)
80105291:	85 c0                	test   %eax,%eax
80105293:	7f e7                	jg     8010527c <strncpy+0x38>
    *s++ = 0;
  return os;
80105295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105298:	c9                   	leave  
80105299:	c3                   	ret    

8010529a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010529a:	55                   	push   %ebp
8010529b:	89 e5                	mov    %esp,%ebp
8010529d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801052a0:	8b 45 08             	mov    0x8(%ebp),%eax
801052a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801052a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052aa:	7f 05                	jg     801052b1 <safestrcpy+0x17>
    return os;
801052ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052af:	eb 2e                	jmp    801052df <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
801052b1:	ff 4d 10             	decl   0x10(%ebp)
801052b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052b8:	7e 1c                	jle    801052d6 <safestrcpy+0x3c>
801052ba:	8b 45 08             	mov    0x8(%ebp),%eax
801052bd:	8d 50 01             	lea    0x1(%eax),%edx
801052c0:	89 55 08             	mov    %edx,0x8(%ebp)
801052c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801052c6:	8d 4a 01             	lea    0x1(%edx),%ecx
801052c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801052cc:	8a 12                	mov    (%edx),%dl
801052ce:	88 10                	mov    %dl,(%eax)
801052d0:	8a 00                	mov    (%eax),%al
801052d2:	84 c0                	test   %al,%al
801052d4:	75 db                	jne    801052b1 <safestrcpy+0x17>
    ;
  *s = 0;
801052d6:	8b 45 08             	mov    0x8(%ebp),%eax
801052d9:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801052dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052df:	c9                   	leave  
801052e0:	c3                   	ret    

801052e1 <strlen>:

int
strlen(const char *s)
{
801052e1:	55                   	push   %ebp
801052e2:	89 e5                	mov    %esp,%ebp
801052e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801052e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801052ee:	eb 03                	jmp    801052f3 <strlen+0x12>
801052f0:	ff 45 fc             	incl   -0x4(%ebp)
801052f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052f6:	8b 45 08             	mov    0x8(%ebp),%eax
801052f9:	01 d0                	add    %edx,%eax
801052fb:	8a 00                	mov    (%eax),%al
801052fd:	84 c0                	test   %al,%al
801052ff:	75 ef                	jne    801052f0 <strlen+0xf>
    ;
  return n;
80105301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105304:	c9                   	leave  
80105305:	c3                   	ret    
	...

80105308 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105308:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010530c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105310:	55                   	push   %ebp
  pushl %ebx
80105311:	53                   	push   %ebx
  pushl %esi
80105312:	56                   	push   %esi
  pushl %edi
80105313:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105314:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105316:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105318:	5f                   	pop    %edi
  popl %esi
80105319:	5e                   	pop    %esi
  popl %ebx
8010531a:	5b                   	pop    %ebx
  popl %ebp
8010531b:	5d                   	pop    %ebp
  ret
8010531c:	c3                   	ret    
8010531d:	00 00                	add    %al,(%eax)
	...

80105320 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105326:	e8 f0 ee ff ff       	call   8010421b <myproc>
8010532b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010532e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105331:	8b 00                	mov    (%eax),%eax
80105333:	3b 45 08             	cmp    0x8(%ebp),%eax
80105336:	76 0f                	jbe    80105347 <fetchint+0x27>
80105338:	8b 45 08             	mov    0x8(%ebp),%eax
8010533b:	8d 50 04             	lea    0x4(%eax),%edx
8010533e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105341:	8b 00                	mov    (%eax),%eax
80105343:	39 c2                	cmp    %eax,%edx
80105345:	76 07                	jbe    8010534e <fetchint+0x2e>
    return -1;
80105347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534c:	eb 0f                	jmp    8010535d <fetchint+0x3d>
  *ip = *(int*)(addr);
8010534e:	8b 45 08             	mov    0x8(%ebp),%eax
80105351:	8b 10                	mov    (%eax),%edx
80105353:	8b 45 0c             	mov    0xc(%ebp),%eax
80105356:	89 10                	mov    %edx,(%eax)
  return 0;
80105358:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010535d:	c9                   	leave  
8010535e:	c3                   	ret    

8010535f <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010535f:	55                   	push   %ebp
80105360:	89 e5                	mov    %esp,%ebp
80105362:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105365:	e8 b1 ee ff ff       	call   8010421b <myproc>
8010536a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010536d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105370:	8b 00                	mov    (%eax),%eax
80105372:	3b 45 08             	cmp    0x8(%ebp),%eax
80105375:	77 07                	ja     8010537e <fetchstr+0x1f>
    return -1;
80105377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537c:	eb 41                	jmp    801053bf <fetchstr+0x60>
  *pp = (char*)addr;
8010537e:	8b 55 08             	mov    0x8(%ebp),%edx
80105381:	8b 45 0c             	mov    0xc(%ebp),%eax
80105384:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105389:	8b 00                	mov    (%eax),%eax
8010538b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010538e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105391:	8b 00                	mov    (%eax),%eax
80105393:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105396:	eb 1a                	jmp    801053b2 <fetchstr+0x53>
    if(*s == 0)
80105398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539b:	8a 00                	mov    (%eax),%al
8010539d:	84 c0                	test   %al,%al
8010539f:	75 0e                	jne    801053af <fetchstr+0x50>
      return s - *pp;
801053a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a7:	8b 00                	mov    (%eax),%eax
801053a9:	29 c2                	sub    %eax,%edx
801053ab:	89 d0                	mov    %edx,%eax
801053ad:	eb 10                	jmp    801053bf <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801053af:	ff 45 f4             	incl   -0xc(%ebp)
801053b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801053b8:	72 de                	jb     80105398 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
801053ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053bf:	c9                   	leave  
801053c0:	c3                   	ret    

801053c1 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053c1:	55                   	push   %ebp
801053c2:	89 e5                	mov    %esp,%ebp
801053c4:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053c7:	e8 4f ee ff ff       	call   8010421b <myproc>
801053cc:	8b 40 18             	mov    0x18(%eax),%eax
801053cf:	8b 50 44             	mov    0x44(%eax),%edx
801053d2:	8b 45 08             	mov    0x8(%ebp),%eax
801053d5:	c1 e0 02             	shl    $0x2,%eax
801053d8:	01 d0                	add    %edx,%eax
801053da:	8d 50 04             	lea    0x4(%eax),%edx
801053dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801053e4:	89 14 24             	mov    %edx,(%esp)
801053e7:	e8 34 ff ff ff       	call   80105320 <fetchint>
}
801053ec:	c9                   	leave  
801053ed:	c3                   	ret    

801053ee <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053ee:	55                   	push   %ebp
801053ef:	89 e5                	mov    %esp,%ebp
801053f1:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
801053f4:	e8 22 ee ff ff       	call   8010421b <myproc>
801053f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801053fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105403:	8b 45 08             	mov    0x8(%ebp),%eax
80105406:	89 04 24             	mov    %eax,(%esp)
80105409:	e8 b3 ff ff ff       	call   801053c1 <argint>
8010540e:	85 c0                	test   %eax,%eax
80105410:	79 07                	jns    80105419 <argptr+0x2b>
    return -1;
80105412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105417:	eb 3d                	jmp    80105456 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010541d:	78 21                	js     80105440 <argptr+0x52>
8010541f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105422:	89 c2                	mov    %eax,%edx
80105424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105427:	8b 00                	mov    (%eax),%eax
80105429:	39 c2                	cmp    %eax,%edx
8010542b:	73 13                	jae    80105440 <argptr+0x52>
8010542d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105430:	89 c2                	mov    %eax,%edx
80105432:	8b 45 10             	mov    0x10(%ebp),%eax
80105435:	01 c2                	add    %eax,%edx
80105437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543a:	8b 00                	mov    (%eax),%eax
8010543c:	39 c2                	cmp    %eax,%edx
8010543e:	76 07                	jbe    80105447 <argptr+0x59>
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	eb 0f                	jmp    80105456 <argptr+0x68>
  *pp = (char*)i;
80105447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010544a:	89 c2                	mov    %eax,%edx
8010544c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544f:	89 10                	mov    %edx,(%eax)
  return 0;
80105451:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105456:	c9                   	leave  
80105457:	c3                   	ret    

80105458 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105458:	55                   	push   %ebp
80105459:	89 e5                	mov    %esp,%ebp
8010545b:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010545e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105461:	89 44 24 04          	mov    %eax,0x4(%esp)
80105465:	8b 45 08             	mov    0x8(%ebp),%eax
80105468:	89 04 24             	mov    %eax,(%esp)
8010546b:	e8 51 ff ff ff       	call   801053c1 <argint>
80105470:	85 c0                	test   %eax,%eax
80105472:	79 07                	jns    8010547b <argstr+0x23>
    return -1;
80105474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105479:	eb 12                	jmp    8010548d <argstr+0x35>
  return fetchstr(addr, pp);
8010547b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105481:	89 54 24 04          	mov    %edx,0x4(%esp)
80105485:	89 04 24             	mov    %eax,(%esp)
80105488:	e8 d2 fe ff ff       	call   8010535f <fetchstr>
}
8010548d:	c9                   	leave  
8010548e:	c3                   	ret    

8010548f <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
8010548f:	55                   	push   %ebp
80105490:	89 e5                	mov    %esp,%ebp
80105492:	53                   	push   %ebx
80105493:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105496:	e8 80 ed ff ff       	call   8010421b <myproc>
8010549b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010549e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a1:	8b 40 18             	mov    0x18(%eax),%eax
801054a4:	8b 40 1c             	mov    0x1c(%eax),%eax
801054a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054ae:	7e 2d                	jle    801054dd <syscall+0x4e>
801054b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b3:	83 f8 15             	cmp    $0x15,%eax
801054b6:	77 25                	ja     801054dd <syscall+0x4e>
801054b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054bb:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801054c2:	85 c0                	test   %eax,%eax
801054c4:	74 17                	je     801054dd <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
801054c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c9:	8b 58 18             	mov    0x18(%eax),%ebx
801054cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054cf:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801054d6:	ff d0                	call   *%eax
801054d8:	89 43 1c             	mov    %eax,0x1c(%ebx)
801054db:	eb 34                	jmp    80105511 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801054dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e0:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801054e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e6:	8b 40 10             	mov    0x10(%eax),%eax
801054e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
801054f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f8:	c7 04 24 74 86 10 80 	movl   $0x80108674,(%esp)
801054ff:	e8 bd ae ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105507:	8b 40 18             	mov    0x18(%eax),%eax
8010550a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105511:	83 c4 24             	add    $0x24,%esp
80105514:	5b                   	pop    %ebx
80105515:	5d                   	pop    %ebp
80105516:	c3                   	ret    
	...

80105518 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105518:	55                   	push   %ebp
80105519:	89 e5                	mov    %esp,%ebp
8010551b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010551e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105521:	89 44 24 04          	mov    %eax,0x4(%esp)
80105525:	8b 45 08             	mov    0x8(%ebp),%eax
80105528:	89 04 24             	mov    %eax,(%esp)
8010552b:	e8 91 fe ff ff       	call   801053c1 <argint>
80105530:	85 c0                	test   %eax,%eax
80105532:	79 07                	jns    8010553b <argfd+0x23>
    return -1;
80105534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105539:	eb 4f                	jmp    8010558a <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010553b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010553e:	85 c0                	test   %eax,%eax
80105540:	78 20                	js     80105562 <argfd+0x4a>
80105542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105545:	83 f8 0f             	cmp    $0xf,%eax
80105548:	7f 18                	jg     80105562 <argfd+0x4a>
8010554a:	e8 cc ec ff ff       	call   8010421b <myproc>
8010554f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105552:	83 c2 08             	add    $0x8,%edx
80105555:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010555c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105560:	75 07                	jne    80105569 <argfd+0x51>
    return -1;
80105562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105567:	eb 21                	jmp    8010558a <argfd+0x72>
  if(pfd)
80105569:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010556d:	74 08                	je     80105577 <argfd+0x5f>
    *pfd = fd;
8010556f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105572:	8b 45 0c             	mov    0xc(%ebp),%eax
80105575:	89 10                	mov    %edx,(%eax)
  if(pf)
80105577:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010557b:	74 08                	je     80105585 <argfd+0x6d>
    *pf = f;
8010557d:	8b 45 10             	mov    0x10(%ebp),%eax
80105580:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105583:	89 10                	mov    %edx,(%eax)
  return 0;
80105585:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    

8010558c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010558c:	55                   	push   %ebp
8010558d:	89 e5                	mov    %esp,%ebp
8010558f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105592:	e8 84 ec ff ff       	call   8010421b <myproc>
80105597:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010559a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801055a1:	eb 29                	jmp    801055cc <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
801055a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055a9:	83 c2 08             	add    $0x8,%edx
801055ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801055b0:	85 c0                	test   %eax,%eax
801055b2:	75 15                	jne    801055c9 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801055b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ba:	8d 4a 08             	lea    0x8(%edx),%ecx
801055bd:	8b 55 08             	mov    0x8(%ebp),%edx
801055c0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801055c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c7:	eb 0e                	jmp    801055d7 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055c9:	ff 45 f4             	incl   -0xc(%ebp)
801055cc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055d0:	7e d1                	jle    801055a3 <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801055d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d7:	c9                   	leave  
801055d8:	c3                   	ret    

801055d9 <sys_dup>:

int
sys_dup(void)
{
801055d9:	55                   	push   %ebp
801055da:	89 e5                	mov    %esp,%ebp
801055dc:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801055df:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e2:	89 44 24 08          	mov    %eax,0x8(%esp)
801055e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055ed:	00 
801055ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f5:	e8 1e ff ff ff       	call   80105518 <argfd>
801055fa:	85 c0                	test   %eax,%eax
801055fc:	79 07                	jns    80105605 <sys_dup+0x2c>
    return -1;
801055fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105603:	eb 29                	jmp    8010562e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105605:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105608:	89 04 24             	mov    %eax,(%esp)
8010560b:	e8 7c ff ff ff       	call   8010558c <fdalloc>
80105610:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105617:	79 07                	jns    80105620 <sys_dup+0x47>
    return -1;
80105619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561e:	eb 0e                	jmp    8010562e <sys_dup+0x55>
  filedup(f);
80105620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105623:	89 04 24             	mov    %eax,(%esp)
80105626:	e8 9d ba ff ff       	call   801010c8 <filedup>
  return fd;
8010562b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010562e:	c9                   	leave  
8010562f:	c3                   	ret    

80105630 <sys_read>:

int
sys_read(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105636:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105639:	89 44 24 08          	mov    %eax,0x8(%esp)
8010563d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105644:	00 
80105645:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010564c:	e8 c7 fe ff ff       	call   80105518 <argfd>
80105651:	85 c0                	test   %eax,%eax
80105653:	78 35                	js     8010568a <sys_read+0x5a>
80105655:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105663:	e8 59 fd ff ff       	call   801053c1 <argint>
80105668:	85 c0                	test   %eax,%eax
8010566a:	78 1e                	js     8010568a <sys_read+0x5a>
8010566c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105673:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105676:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105681:	e8 68 fd ff ff       	call   801053ee <argptr>
80105686:	85 c0                	test   %eax,%eax
80105688:	79 07                	jns    80105691 <sys_read+0x61>
    return -1;
8010568a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568f:	eb 19                	jmp    801056aa <sys_read+0x7a>
  return fileread(f, p, n);
80105691:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105694:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010569e:	89 54 24 04          	mov    %edx,0x4(%esp)
801056a2:	89 04 24             	mov    %eax,(%esp)
801056a5:	e8 7f bb ff ff       	call   80101229 <fileread>
}
801056aa:	c9                   	leave  
801056ab:	c3                   	ret    

801056ac <sys_write>:

int
sys_write(void)
{
801056ac:	55                   	push   %ebp
801056ad:	89 e5                	mov    %esp,%ebp
801056af:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801056b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056c0:	00 
801056c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056c8:	e8 4b fe ff ff       	call   80105518 <argfd>
801056cd:	85 c0                	test   %eax,%eax
801056cf:	78 35                	js     80105706 <sys_write+0x5a>
801056d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801056d8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056df:	e8 dd fc ff ff       	call   801053c1 <argint>
801056e4:	85 c0                	test   %eax,%eax
801056e6:	78 1e                	js     80105706 <sys_write+0x5a>
801056e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801056ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056fd:	e8 ec fc ff ff       	call   801053ee <argptr>
80105702:	85 c0                	test   %eax,%eax
80105704:	79 07                	jns    8010570d <sys_write+0x61>
    return -1;
80105706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570b:	eb 19                	jmp    80105726 <sys_write+0x7a>
  return filewrite(f, p, n);
8010570d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105710:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105716:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010571a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010571e:	89 04 24             	mov    %eax,(%esp)
80105721:	e8 be bb ff ff       	call   801012e4 <filewrite>
}
80105726:	c9                   	leave  
80105727:	c3                   	ret    

80105728 <sys_close>:

int
sys_close(void)
{
80105728:	55                   	push   %ebp
80105729:	89 e5                	mov    %esp,%ebp
8010572b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010572e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105731:	89 44 24 08          	mov    %eax,0x8(%esp)
80105735:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105738:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105743:	e8 d0 fd ff ff       	call   80105518 <argfd>
80105748:	85 c0                	test   %eax,%eax
8010574a:	79 07                	jns    80105753 <sys_close+0x2b>
    return -1;
8010574c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105751:	eb 23                	jmp    80105776 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
80105753:	e8 c3 ea ff ff       	call   8010421b <myproc>
80105758:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010575b:	83 c2 08             	add    $0x8,%edx
8010575e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105765:	00 
  fileclose(f);
80105766:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105769:	89 04 24             	mov    %eax,(%esp)
8010576c:	e8 9f b9 ff ff       	call   80101110 <fileclose>
  return 0;
80105771:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105776:	c9                   	leave  
80105777:	c3                   	ret    

80105778 <sys_fstat>:

int
sys_fstat(void)
{
80105778:	55                   	push   %ebp
80105779:	89 e5                	mov    %esp,%ebp
8010577b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010577e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105781:	89 44 24 08          	mov    %eax,0x8(%esp)
80105785:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010578c:	00 
8010578d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105794:	e8 7f fd ff ff       	call   80105518 <argfd>
80105799:	85 c0                	test   %eax,%eax
8010579b:	78 1f                	js     801057bc <sys_fstat+0x44>
8010579d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801057a4:	00 
801057a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057b3:	e8 36 fc ff ff       	call   801053ee <argptr>
801057b8:	85 c0                	test   %eax,%eax
801057ba:	79 07                	jns    801057c3 <sys_fstat+0x4b>
    return -1;
801057bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c1:	eb 12                	jmp    801057d5 <sys_fstat+0x5d>
  return filestat(f, st);
801057c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801057cd:	89 04 24             	mov    %eax,(%esp)
801057d0:	e8 05 ba ff ff       	call   801011da <filestat>
}
801057d5:	c9                   	leave  
801057d6:	c3                   	ret    

801057d7 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801057d7:	55                   	push   %ebp
801057d8:	89 e5                	mov    %esp,%ebp
801057da:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057dd:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057eb:	e8 68 fc ff ff       	call   80105458 <argstr>
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 17                	js     8010580b <sys_link+0x34>
801057f4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801057f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801057fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105802:	e8 51 fc ff ff       	call   80105458 <argstr>
80105807:	85 c0                	test   %eax,%eax
80105809:	79 0a                	jns    80105815 <sys_link+0x3e>
    return -1;
8010580b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105810:	e9 3d 01 00 00       	jmp    80105952 <sys_link+0x17b>

  begin_op();
80105815:	e8 09 dd ff ff       	call   80103523 <begin_op>
  if((ip = namei(old)) == 0){
8010581a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010581d:	89 04 24             	mov    %eax,(%esp)
80105820:	e8 2a cd ff ff       	call   8010254f <namei>
80105825:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010582c:	75 0f                	jne    8010583d <sys_link+0x66>
    end_op();
8010582e:	e8 72 dd ff ff       	call   801035a5 <end_op>
    return -1;
80105833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105838:	e9 15 01 00 00       	jmp    80105952 <sys_link+0x17b>
  }

  ilock(ip);
8010583d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105840:	89 04 24             	mov    %eax,(%esp)
80105843:	e8 e2 c1 ff ff       	call   80101a2a <ilock>
  if(ip->type == T_DIR){
80105848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584b:	8b 40 50             	mov    0x50(%eax),%eax
8010584e:	66 83 f8 01          	cmp    $0x1,%ax
80105852:	75 1a                	jne    8010586e <sys_link+0x97>
    iunlockput(ip);
80105854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105857:	89 04 24             	mov    %eax,(%esp)
8010585a:	e8 ca c3 ff ff       	call   80101c29 <iunlockput>
    end_op();
8010585f:	e8 41 dd ff ff       	call   801035a5 <end_op>
    return -1;
80105864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105869:	e9 e4 00 00 00       	jmp    80105952 <sys_link+0x17b>
  }

  ip->nlink++;
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	66 8b 40 56          	mov    0x56(%eax),%ax
80105875:	40                   	inc    %eax
80105876:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105879:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
8010587d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105880:	89 04 24             	mov    %eax,(%esp)
80105883:	e8 df bf ff ff       	call   80101867 <iupdate>
  iunlock(ip);
80105888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588b:	89 04 24             	mov    %eax,(%esp)
8010588e:	e8 a1 c2 ff ff       	call   80101b34 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105893:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105896:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105899:	89 54 24 04          	mov    %edx,0x4(%esp)
8010589d:	89 04 24             	mov    %eax,(%esp)
801058a0:	e8 cc cc ff ff       	call   80102571 <nameiparent>
801058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058ac:	75 02                	jne    801058b0 <sys_link+0xd9>
    goto bad;
801058ae:	eb 68                	jmp    80105918 <sys_link+0x141>
  ilock(dp);
801058b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b3:	89 04 24             	mov    %eax,(%esp)
801058b6:	e8 6f c1 ff ff       	call   80101a2a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058be:	8b 10                	mov    (%eax),%edx
801058c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c3:	8b 00                	mov    (%eax),%eax
801058c5:	39 c2                	cmp    %eax,%edx
801058c7:	75 20                	jne    801058e9 <sys_link+0x112>
801058c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cc:	8b 40 04             	mov    0x4(%eax),%eax
801058cf:	89 44 24 08          	mov    %eax,0x8(%esp)
801058d3:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801058d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801058da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058dd:	89 04 24             	mov    %eax,(%esp)
801058e0:	e8 b7 c9 ff ff       	call   8010229c <dirlink>
801058e5:	85 c0                	test   %eax,%eax
801058e7:	79 0d                	jns    801058f6 <sys_link+0x11f>
    iunlockput(dp);
801058e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ec:	89 04 24             	mov    %eax,(%esp)
801058ef:	e8 35 c3 ff ff       	call   80101c29 <iunlockput>
    goto bad;
801058f4:	eb 22                	jmp    80105918 <sys_link+0x141>
  }
  iunlockput(dp);
801058f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f9:	89 04 24             	mov    %eax,(%esp)
801058fc:	e8 28 c3 ff ff       	call   80101c29 <iunlockput>
  iput(ip);
80105901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105904:	89 04 24             	mov    %eax,(%esp)
80105907:	e8 6c c2 ff ff       	call   80101b78 <iput>

  end_op();
8010590c:	e8 94 dc ff ff       	call   801035a5 <end_op>

  return 0;
80105911:	b8 00 00 00 00       	mov    $0x0,%eax
80105916:	eb 3a                	jmp    80105952 <sys_link+0x17b>

bad:
  ilock(ip);
80105918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591b:	89 04 24             	mov    %eax,(%esp)
8010591e:	e8 07 c1 ff ff       	call   80101a2a <ilock>
  ip->nlink--;
80105923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105926:	66 8b 40 56          	mov    0x56(%eax),%ax
8010592a:	48                   	dec    %eax
8010592b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010592e:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105935:	89 04 24             	mov    %eax,(%esp)
80105938:	e8 2a bf ff ff       	call   80101867 <iupdate>
  iunlockput(ip);
8010593d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105940:	89 04 24             	mov    %eax,(%esp)
80105943:	e8 e1 c2 ff ff       	call   80101c29 <iunlockput>
  end_op();
80105948:	e8 58 dc ff ff       	call   801035a5 <end_op>
  return -1;
8010594d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105952:	c9                   	leave  
80105953:	c3                   	ret    

80105954 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010595a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105961:	eb 4a                	jmp    801059ad <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105966:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010596d:	00 
8010596e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105972:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105975:	89 44 24 04          	mov    %eax,0x4(%esp)
80105979:	8b 45 08             	mov    0x8(%ebp),%eax
8010597c:	89 04 24             	mov    %eax,(%esp)
8010597f:	e8 3d c5 ff ff       	call   80101ec1 <readi>
80105984:	83 f8 10             	cmp    $0x10,%eax
80105987:	74 0c                	je     80105995 <isdirempty+0x41>
      panic("isdirempty: readi");
80105989:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
80105990:	e8 bf ab ff ff       	call   80100554 <panic>
    if(de.inum != 0)
80105995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105998:	66 85 c0             	test   %ax,%ax
8010599b:	74 07                	je     801059a4 <isdirempty+0x50>
      return 0;
8010599d:	b8 00 00 00 00       	mov    $0x0,%eax
801059a2:	eb 1b                	jmp    801059bf <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a7:	83 c0 10             	add    $0x10,%eax
801059aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059b0:	8b 45 08             	mov    0x8(%ebp),%eax
801059b3:	8b 40 58             	mov    0x58(%eax),%eax
801059b6:	39 c2                	cmp    %eax,%edx
801059b8:	72 a9                	jb     80105963 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801059ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
801059bf:	c9                   	leave  
801059c0:	c3                   	ret    

801059c1 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801059c1:	55                   	push   %ebp
801059c2:	89 e5                	mov    %esp,%ebp
801059c4:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801059c7:	8d 45 cc             	lea    -0x34(%ebp),%eax
801059ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059d5:	e8 7e fa ff ff       	call   80105458 <argstr>
801059da:	85 c0                	test   %eax,%eax
801059dc:	79 0a                	jns    801059e8 <sys_unlink+0x27>
    return -1;
801059de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e3:	e9 a9 01 00 00       	jmp    80105b91 <sys_unlink+0x1d0>

  begin_op();
801059e8:	e8 36 db ff ff       	call   80103523 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
801059f0:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801059f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801059f7:	89 04 24             	mov    %eax,(%esp)
801059fa:	e8 72 cb ff ff       	call   80102571 <nameiparent>
801059ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a06:	75 0f                	jne    80105a17 <sys_unlink+0x56>
    end_op();
80105a08:	e8 98 db ff ff       	call   801035a5 <end_op>
    return -1;
80105a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a12:	e9 7a 01 00 00       	jmp    80105b91 <sys_unlink+0x1d0>
  }

  ilock(dp);
80105a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1a:	89 04 24             	mov    %eax,(%esp)
80105a1d:	e8 08 c0 ff ff       	call   80101a2a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a22:	c7 44 24 04 a2 86 10 	movl   $0x801086a2,0x4(%esp)
80105a29:	80 
80105a2a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a2d:	89 04 24             	mov    %eax,(%esp)
80105a30:	e8 7f c7 ff ff       	call   801021b4 <namecmp>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	0f 84 3f 01 00 00    	je     80105b7c <sys_unlink+0x1bb>
80105a3d:	c7 44 24 04 a4 86 10 	movl   $0x801086a4,0x4(%esp)
80105a44:	80 
80105a45:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a48:	89 04 24             	mov    %eax,(%esp)
80105a4b:	e8 64 c7 ff ff       	call   801021b4 <namecmp>
80105a50:	85 c0                	test   %eax,%eax
80105a52:	0f 84 24 01 00 00    	je     80105b7c <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105a58:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105a5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a5f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a62:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a69:	89 04 24             	mov    %eax,(%esp)
80105a6c:	e8 65 c7 ff ff       	call   801021d6 <dirlookup>
80105a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a78:	75 05                	jne    80105a7f <sys_unlink+0xbe>
    goto bad;
80105a7a:	e9 fd 00 00 00       	jmp    80105b7c <sys_unlink+0x1bb>
  ilock(ip);
80105a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a82:	89 04 24             	mov    %eax,(%esp)
80105a85:	e8 a0 bf ff ff       	call   80101a2a <ilock>

  if(ip->nlink < 1)
80105a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8d:	66 8b 40 56          	mov    0x56(%eax),%ax
80105a91:	66 85 c0             	test   %ax,%ax
80105a94:	7f 0c                	jg     80105aa2 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105a96:	c7 04 24 a7 86 10 80 	movl   $0x801086a7,(%esp)
80105a9d:	e8 b2 aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa5:	8b 40 50             	mov    0x50(%eax),%eax
80105aa8:	66 83 f8 01          	cmp    $0x1,%ax
80105aac:	75 1f                	jne    80105acd <sys_unlink+0x10c>
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	89 04 24             	mov    %eax,(%esp)
80105ab4:	e8 9b fe ff ff       	call   80105954 <isdirempty>
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	75 10                	jne    80105acd <sys_unlink+0x10c>
    iunlockput(ip);
80105abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac0:	89 04 24             	mov    %eax,(%esp)
80105ac3:	e8 61 c1 ff ff       	call   80101c29 <iunlockput>
    goto bad;
80105ac8:	e9 af 00 00 00       	jmp    80105b7c <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105acd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105ad4:	00 
80105ad5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105adc:	00 
80105add:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae0:	89 04 24             	mov    %eax,(%esp)
80105ae3:	e8 a6 f5 ff ff       	call   8010508e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ae8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105aeb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105af2:	00 
80105af3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af7:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105afa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b01:	89 04 24             	mov    %eax,(%esp)
80105b04:	e8 1c c5 ff ff       	call   80102025 <writei>
80105b09:	83 f8 10             	cmp    $0x10,%eax
80105b0c:	74 0c                	je     80105b1a <sys_unlink+0x159>
    panic("unlink: writei");
80105b0e:	c7 04 24 b9 86 10 80 	movl   $0x801086b9,(%esp)
80105b15:	e8 3a aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1d:	8b 40 50             	mov    0x50(%eax),%eax
80105b20:	66 83 f8 01          	cmp    $0x1,%ax
80105b24:	75 1a                	jne    80105b40 <sys_unlink+0x17f>
    dp->nlink--;
80105b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b29:	66 8b 40 56          	mov    0x56(%eax),%ax
80105b2d:	48                   	dec    %eax
80105b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b31:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b38:	89 04 24             	mov    %eax,(%esp)
80105b3b:	e8 27 bd ff ff       	call   80101867 <iupdate>
  }
  iunlockput(dp);
80105b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b43:	89 04 24             	mov    %eax,(%esp)
80105b46:	e8 de c0 ff ff       	call   80101c29 <iunlockput>

  ip->nlink--;
80105b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4e:	66 8b 40 56          	mov    0x56(%eax),%ax
80105b52:	48                   	dec    %eax
80105b53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b56:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5d:	89 04 24             	mov    %eax,(%esp)
80105b60:	e8 02 bd ff ff       	call   80101867 <iupdate>
  iunlockput(ip);
80105b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b68:	89 04 24             	mov    %eax,(%esp)
80105b6b:	e8 b9 c0 ff ff       	call   80101c29 <iunlockput>

  end_op();
80105b70:	e8 30 da ff ff       	call   801035a5 <end_op>

  return 0;
80105b75:	b8 00 00 00 00       	mov    $0x0,%eax
80105b7a:	eb 15                	jmp    80105b91 <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7f:	89 04 24             	mov    %eax,(%esp)
80105b82:	e8 a2 c0 ff ff       	call   80101c29 <iunlockput>
  end_op();
80105b87:	e8 19 da ff ff       	call   801035a5 <end_op>
  return -1;
80105b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b91:	c9                   	leave  
80105b92:	c3                   	ret    

80105b93 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b93:	55                   	push   %ebp
80105b94:	89 e5                	mov    %esp,%ebp
80105b96:	83 ec 48             	sub    $0x48,%esp
80105b99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105b9c:	8b 55 10             	mov    0x10(%ebp),%edx
80105b9f:	8b 45 14             	mov    0x14(%ebp),%eax
80105ba2:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ba6:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105baa:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105bae:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb8:	89 04 24             	mov    %eax,(%esp)
80105bbb:	e8 b1 c9 ff ff       	call   80102571 <nameiparent>
80105bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bc7:	75 0a                	jne    80105bd3 <create+0x40>
    return 0;
80105bc9:	b8 00 00 00 00       	mov    $0x0,%eax
80105bce:	e9 79 01 00 00       	jmp    80105d4c <create+0x1b9>
  ilock(dp);
80105bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd6:	89 04 24             	mov    %eax,(%esp)
80105bd9:	e8 4c be ff ff       	call   80101a2a <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105bde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105be5:	8d 45 de             	lea    -0x22(%ebp),%eax
80105be8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bef:	89 04 24             	mov    %eax,(%esp)
80105bf2:	e8 df c5 ff ff       	call   801021d6 <dirlookup>
80105bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bfe:	74 46                	je     80105c46 <create+0xb3>
    iunlockput(dp);
80105c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c03:	89 04 24             	mov    %eax,(%esp)
80105c06:	e8 1e c0 ff ff       	call   80101c29 <iunlockput>
    ilock(ip);
80105c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0e:	89 04 24             	mov    %eax,(%esp)
80105c11:	e8 14 be ff ff       	call   80101a2a <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c16:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c1b:	75 14                	jne    80105c31 <create+0x9e>
80105c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c20:	8b 40 50             	mov    0x50(%eax),%eax
80105c23:	66 83 f8 02          	cmp    $0x2,%ax
80105c27:	75 08                	jne    80105c31 <create+0x9e>
      return ip;
80105c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2c:	e9 1b 01 00 00       	jmp    80105d4c <create+0x1b9>
    iunlockput(ip);
80105c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c34:	89 04 24             	mov    %eax,(%esp)
80105c37:	e8 ed bf ff ff       	call   80101c29 <iunlockput>
    return 0;
80105c3c:	b8 00 00 00 00       	mov    $0x0,%eax
80105c41:	e9 06 01 00 00       	jmp    80105d4c <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105c46:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4d:	8b 00                	mov    (%eax),%eax
80105c4f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c53:	89 04 24             	mov    %eax,(%esp)
80105c56:	e8 3a bb ff ff       	call   80101795 <ialloc>
80105c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c62:	75 0c                	jne    80105c70 <create+0xdd>
    panic("create: ialloc");
80105c64:	c7 04 24 c8 86 10 80 	movl   $0x801086c8,(%esp)
80105c6b:	e8 e4 a8 ff ff       	call   80100554 <panic>

  ilock(ip);
80105c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c73:	89 04 24             	mov    %eax,(%esp)
80105c76:	e8 af bd ff ff       	call   80101a2a <ilock>
  ip->major = major;
80105c7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c81:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c88:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c8b:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c92:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9b:	89 04 24             	mov    %eax,(%esp)
80105c9e:	e8 c4 bb ff ff       	call   80101867 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105ca3:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105ca8:	75 68                	jne    80105d12 <create+0x17f>
    dp->nlink++;  // for ".."
80105caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cad:	66 8b 40 56          	mov    0x56(%eax),%ax
80105cb1:	40                   	inc    %eax
80105cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cb5:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbc:	89 04 24             	mov    %eax,(%esp)
80105cbf:	e8 a3 bb ff ff       	call   80101867 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc7:	8b 40 04             	mov    0x4(%eax),%eax
80105cca:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cce:	c7 44 24 04 a2 86 10 	movl   $0x801086a2,0x4(%esp)
80105cd5:	80 
80105cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd9:	89 04 24             	mov    %eax,(%esp)
80105cdc:	e8 bb c5 ff ff       	call   8010229c <dirlink>
80105ce1:	85 c0                	test   %eax,%eax
80105ce3:	78 21                	js     80105d06 <create+0x173>
80105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce8:	8b 40 04             	mov    0x4(%eax),%eax
80105ceb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cef:	c7 44 24 04 a4 86 10 	movl   $0x801086a4,0x4(%esp)
80105cf6:	80 
80105cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfa:	89 04 24             	mov    %eax,(%esp)
80105cfd:	e8 9a c5 ff ff       	call   8010229c <dirlink>
80105d02:	85 c0                	test   %eax,%eax
80105d04:	79 0c                	jns    80105d12 <create+0x17f>
      panic("create dots");
80105d06:	c7 04 24 d7 86 10 80 	movl   $0x801086d7,(%esp)
80105d0d:	e8 42 a8 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d15:	8b 40 04             	mov    0x4(%eax),%eax
80105d18:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d1c:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d26:	89 04 24             	mov    %eax,(%esp)
80105d29:	e8 6e c5 ff ff       	call   8010229c <dirlink>
80105d2e:	85 c0                	test   %eax,%eax
80105d30:	79 0c                	jns    80105d3e <create+0x1ab>
    panic("create: dirlink");
80105d32:	c7 04 24 e3 86 10 80 	movl   $0x801086e3,(%esp)
80105d39:	e8 16 a8 ff ff       	call   80100554 <panic>

  iunlockput(dp);
80105d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d41:	89 04 24             	mov    %eax,(%esp)
80105d44:	e8 e0 be ff ff       	call   80101c29 <iunlockput>

  return ip;
80105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105d4c:	c9                   	leave  
80105d4d:	c3                   	ret    

80105d4e <sys_open>:

int
sys_open(void)
{
80105d4e:	55                   	push   %ebp
80105d4f:	89 e5                	mov    %esp,%ebp
80105d51:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d54:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d57:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d62:	e8 f1 f6 ff ff       	call   80105458 <argstr>
80105d67:	85 c0                	test   %eax,%eax
80105d69:	78 17                	js     80105d82 <sys_open+0x34>
80105d6b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d79:	e8 43 f6 ff ff       	call   801053c1 <argint>
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	79 0a                	jns    80105d8c <sys_open+0x3e>
    return -1;
80105d82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d87:	e9 5b 01 00 00       	jmp    80105ee7 <sys_open+0x199>

  begin_op();
80105d8c:	e8 92 d7 ff ff       	call   80103523 <begin_op>

  if(omode & O_CREATE){
80105d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d94:	25 00 02 00 00       	and    $0x200,%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 3b                	je     80105dd8 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105da0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105da7:	00 
80105da8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105daf:	00 
80105db0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105db7:	00 
80105db8:	89 04 24             	mov    %eax,(%esp)
80105dbb:	e8 d3 fd ff ff       	call   80105b93 <create>
80105dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc7:	75 6a                	jne    80105e33 <sys_open+0xe5>
      end_op();
80105dc9:	e8 d7 d7 ff ff       	call   801035a5 <end_op>
      return -1;
80105dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd3:	e9 0f 01 00 00       	jmp    80105ee7 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ddb:	89 04 24             	mov    %eax,(%esp)
80105dde:	e8 6c c7 ff ff       	call   8010254f <namei>
80105de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dea:	75 0f                	jne    80105dfb <sys_open+0xad>
      end_op();
80105dec:	e8 b4 d7 ff ff       	call   801035a5 <end_op>
      return -1;
80105df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df6:	e9 ec 00 00 00       	jmp    80105ee7 <sys_open+0x199>
    }
    ilock(ip);
80105dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfe:	89 04 24             	mov    %eax,(%esp)
80105e01:	e8 24 bc ff ff       	call   80101a2a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e09:	8b 40 50             	mov    0x50(%eax),%eax
80105e0c:	66 83 f8 01          	cmp    $0x1,%ax
80105e10:	75 21                	jne    80105e33 <sys_open+0xe5>
80105e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e15:	85 c0                	test   %eax,%eax
80105e17:	74 1a                	je     80105e33 <sys_open+0xe5>
      iunlockput(ip);
80105e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1c:	89 04 24             	mov    %eax,(%esp)
80105e1f:	e8 05 be ff ff       	call   80101c29 <iunlockput>
      end_op();
80105e24:	e8 7c d7 ff ff       	call   801035a5 <end_op>
      return -1;
80105e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2e:	e9 b4 00 00 00       	jmp    80105ee7 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e33:	e8 30 b2 ff ff       	call   80101068 <filealloc>
80105e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e3f:	74 14                	je     80105e55 <sys_open+0x107>
80105e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e44:	89 04 24             	mov    %eax,(%esp)
80105e47:	e8 40 f7 ff ff       	call   8010558c <fdalloc>
80105e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105e4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105e53:	79 28                	jns    80105e7d <sys_open+0x12f>
    if(f)
80105e55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e59:	74 0b                	je     80105e66 <sys_open+0x118>
      fileclose(f);
80105e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5e:	89 04 24             	mov    %eax,(%esp)
80105e61:	e8 aa b2 ff ff       	call   80101110 <fileclose>
    iunlockput(ip);
80105e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e69:	89 04 24             	mov    %eax,(%esp)
80105e6c:	e8 b8 bd ff ff       	call   80101c29 <iunlockput>
    end_op();
80105e71:	e8 2f d7 ff ff       	call   801035a5 <end_op>
    return -1;
80105e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7b:	eb 6a                	jmp    80105ee7 <sys_open+0x199>
  }
  iunlock(ip);
80105e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e80:	89 04 24             	mov    %eax,(%esp)
80105e83:	e8 ac bc ff ff       	call   80101b34 <iunlock>
  end_op();
80105e88:	e8 18 d7 ff ff       	call   801035a5 <end_op>

  f->type = FD_INODE;
80105e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e90:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e9c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105eac:	83 e0 01             	and    $0x1,%eax
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	0f 94 c0             	sete   %al
80105eb4:	88 c2                	mov    %al,%dl
80105eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb9:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ebf:	83 e0 01             	and    $0x1,%eax
80105ec2:	85 c0                	test   %eax,%eax
80105ec4:	75 0a                	jne    80105ed0 <sys_open+0x182>
80105ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ec9:	83 e0 02             	and    $0x2,%eax
80105ecc:	85 c0                	test   %eax,%eax
80105ece:	74 07                	je     80105ed7 <sys_open+0x189>
80105ed0:	b8 01 00 00 00       	mov    $0x1,%eax
80105ed5:	eb 05                	jmp    80105edc <sys_open+0x18e>
80105ed7:	b8 00 00 00 00       	mov    $0x0,%eax
80105edc:	88 c2                	mov    %al,%dl
80105ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee1:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105ee7:	c9                   	leave  
80105ee8:	c3                   	ret    

80105ee9 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ee9:	55                   	push   %ebp
80105eea:	89 e5                	mov    %esp,%ebp
80105eec:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105eef:	e8 2f d6 ff ff       	call   80103523 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ef4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105efb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f02:	e8 51 f5 ff ff       	call   80105458 <argstr>
80105f07:	85 c0                	test   %eax,%eax
80105f09:	78 2c                	js     80105f37 <sys_mkdir+0x4e>
80105f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f15:	00 
80105f16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f1d:	00 
80105f1e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105f25:	00 
80105f26:	89 04 24             	mov    %eax,(%esp)
80105f29:	e8 65 fc ff ff       	call   80105b93 <create>
80105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f35:	75 0c                	jne    80105f43 <sys_mkdir+0x5a>
    end_op();
80105f37:	e8 69 d6 ff ff       	call   801035a5 <end_op>
    return -1;
80105f3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f41:	eb 15                	jmp    80105f58 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	89 04 24             	mov    %eax,(%esp)
80105f49:	e8 db bc ff ff       	call   80101c29 <iunlockput>
  end_op();
80105f4e:	e8 52 d6 ff ff       	call   801035a5 <end_op>
  return 0;
80105f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f58:	c9                   	leave  
80105f59:	c3                   	ret    

80105f5a <sys_mknod>:

int
sys_mknod(void)
{
80105f5a:	55                   	push   %ebp
80105f5b:	89 e5                	mov    %esp,%ebp
80105f5d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f60:	e8 be d5 ff ff       	call   80103523 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f65:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f68:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f73:	e8 e0 f4 ff ff       	call   80105458 <argstr>
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	78 5e                	js     80105fda <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f7c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f8a:	e8 32 f4 ff ff       	call   801053c1 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105f8f:	85 c0                	test   %eax,%eax
80105f91:	78 47                	js     80105fda <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f93:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f96:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f9a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105fa1:	e8 1b f4 ff ff       	call   801053c1 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	78 30                	js     80105fda <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fad:	0f bf c8             	movswl %ax,%ecx
80105fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fb3:	0f bf d0             	movswl %ax,%edx
80105fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105fb9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105fbd:	89 54 24 08          	mov    %edx,0x8(%esp)
80105fc1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105fc8:	00 
80105fc9:	89 04 24             	mov    %eax,(%esp)
80105fcc:	e8 c2 fb ff ff       	call   80105b93 <create>
80105fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fd8:	75 0c                	jne    80105fe6 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105fda:	e8 c6 d5 ff ff       	call   801035a5 <end_op>
    return -1;
80105fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe4:	eb 15                	jmp    80105ffb <sys_mknod+0xa1>
  }
  iunlockput(ip);
80105fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe9:	89 04 24             	mov    %eax,(%esp)
80105fec:	e8 38 bc ff ff       	call   80101c29 <iunlockput>
  end_op();
80105ff1:	e8 af d5 ff ff       	call   801035a5 <end_op>
  return 0;
80105ff6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ffb:	c9                   	leave  
80105ffc:	c3                   	ret    

80105ffd <sys_chdir>:

int
sys_chdir(void)
{
80105ffd:	55                   	push   %ebp
80105ffe:	89 e5                	mov    %esp,%ebp
80106000:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106003:	e8 13 e2 ff ff       	call   8010421b <myproc>
80106008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
8010600b:	e8 13 d5 ff ff       	call   80103523 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106010:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106013:	89 44 24 04          	mov    %eax,0x4(%esp)
80106017:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010601e:	e8 35 f4 ff ff       	call   80105458 <argstr>
80106023:	85 c0                	test   %eax,%eax
80106025:	78 14                	js     8010603b <sys_chdir+0x3e>
80106027:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010602a:	89 04 24             	mov    %eax,(%esp)
8010602d:	e8 1d c5 ff ff       	call   8010254f <namei>
80106032:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106035:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106039:	75 0c                	jne    80106047 <sys_chdir+0x4a>
    end_op();
8010603b:	e8 65 d5 ff ff       	call   801035a5 <end_op>
    return -1;
80106040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106045:	eb 5a                	jmp    801060a1 <sys_chdir+0xa4>
  }
  ilock(ip);
80106047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604a:	89 04 24             	mov    %eax,(%esp)
8010604d:	e8 d8 b9 ff ff       	call   80101a2a <ilock>
  if(ip->type != T_DIR){
80106052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106055:	8b 40 50             	mov    0x50(%eax),%eax
80106058:	66 83 f8 01          	cmp    $0x1,%ax
8010605c:	74 17                	je     80106075 <sys_chdir+0x78>
    iunlockput(ip);
8010605e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106061:	89 04 24             	mov    %eax,(%esp)
80106064:	e8 c0 bb ff ff       	call   80101c29 <iunlockput>
    end_op();
80106069:	e8 37 d5 ff ff       	call   801035a5 <end_op>
    return -1;
8010606e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106073:	eb 2c                	jmp    801060a1 <sys_chdir+0xa4>
  }
  iunlock(ip);
80106075:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106078:	89 04 24             	mov    %eax,(%esp)
8010607b:	e8 b4 ba ff ff       	call   80101b34 <iunlock>
  iput(curproc->cwd);
80106080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106083:	8b 40 68             	mov    0x68(%eax),%eax
80106086:	89 04 24             	mov    %eax,(%esp)
80106089:	e8 ea ba ff ff       	call   80101b78 <iput>
  end_op();
8010608e:	e8 12 d5 ff ff       	call   801035a5 <end_op>
  curproc->cwd = ip;
80106093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106096:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106099:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010609c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060a1:	c9                   	leave  
801060a2:	c3                   	ret    

801060a3 <sys_exec>:

int
sys_exec(void)
{
801060a3:	55                   	push   %ebp
801060a4:	89 e5                	mov    %esp,%ebp
801060a6:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060af:	89 44 24 04          	mov    %eax,0x4(%esp)
801060b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ba:	e8 99 f3 ff ff       	call   80105458 <argstr>
801060bf:	85 c0                	test   %eax,%eax
801060c1:	78 1a                	js     801060dd <sys_exec+0x3a>
801060c3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801060c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801060cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060d4:	e8 e8 f2 ff ff       	call   801053c1 <argint>
801060d9:	85 c0                	test   %eax,%eax
801060db:	79 0a                	jns    801060e7 <sys_exec+0x44>
    return -1;
801060dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e2:	e9 c7 00 00 00       	jmp    801061ae <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
801060e7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801060ee:	00 
801060ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060f6:	00 
801060f7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801060fd:	89 04 24             	mov    %eax,(%esp)
80106100:	e8 89 ef ff ff       	call   8010508e <memset>
  for(i=0;; i++){
80106105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010610c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010610f:	83 f8 1f             	cmp    $0x1f,%eax
80106112:	76 0a                	jbe    8010611e <sys_exec+0x7b>
      return -1;
80106114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106119:	e9 90 00 00 00       	jmp    801061ae <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010611e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106121:	c1 e0 02             	shl    $0x2,%eax
80106124:	89 c2                	mov    %eax,%edx
80106126:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010612c:	01 c2                	add    %eax,%edx
8010612e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106134:	89 44 24 04          	mov    %eax,0x4(%esp)
80106138:	89 14 24             	mov    %edx,(%esp)
8010613b:	e8 e0 f1 ff ff       	call   80105320 <fetchint>
80106140:	85 c0                	test   %eax,%eax
80106142:	79 07                	jns    8010614b <sys_exec+0xa8>
      return -1;
80106144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106149:	eb 63                	jmp    801061ae <sys_exec+0x10b>
    if(uarg == 0){
8010614b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106151:	85 c0                	test   %eax,%eax
80106153:	75 26                	jne    8010617b <sys_exec+0xd8>
      argv[i] = 0;
80106155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106158:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010615f:	00 00 00 00 
      break;
80106163:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106167:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010616d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106171:	89 04 24             	mov    %eax,(%esp)
80106174:	e8 93 aa ff ff       	call   80100c0c <exec>
80106179:	eb 33                	jmp    801061ae <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010617b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106181:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106184:	c1 e2 02             	shl    $0x2,%edx
80106187:	01 c2                	add    %eax,%edx
80106189:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010618f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106193:	89 04 24             	mov    %eax,(%esp)
80106196:	e8 c4 f1 ff ff       	call   8010535f <fetchstr>
8010619b:	85 c0                	test   %eax,%eax
8010619d:	79 07                	jns    801061a6 <sys_exec+0x103>
      return -1;
8010619f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a4:	eb 08                	jmp    801061ae <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801061a6:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801061a9:	e9 5e ff ff ff       	jmp    8010610c <sys_exec+0x69>
  return exec(path, argv);
}
801061ae:	c9                   	leave  
801061af:	c3                   	ret    

801061b0 <sys_pipe>:

int
sys_pipe(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061b6:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801061bd:	00 
801061be:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061cc:	e8 1d f2 ff ff       	call   801053ee <argptr>
801061d1:	85 c0                	test   %eax,%eax
801061d3:	79 0a                	jns    801061df <sys_pipe+0x2f>
    return -1;
801061d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061da:	e9 9a 00 00 00       	jmp    80106279 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
801061df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801061e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061e9:	89 04 24             	mov    %eax,(%esp)
801061ec:	e8 7f db ff ff       	call   80103d70 <pipealloc>
801061f1:	85 c0                	test   %eax,%eax
801061f3:	79 07                	jns    801061fc <sys_pipe+0x4c>
    return -1;
801061f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fa:	eb 7d                	jmp    80106279 <sys_pipe+0xc9>
  fd0 = -1;
801061fc:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106203:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106206:	89 04 24             	mov    %eax,(%esp)
80106209:	e8 7e f3 ff ff       	call   8010558c <fdalloc>
8010620e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106215:	78 14                	js     8010622b <sys_pipe+0x7b>
80106217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010621a:	89 04 24             	mov    %eax,(%esp)
8010621d:	e8 6a f3 ff ff       	call   8010558c <fdalloc>
80106222:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106229:	79 36                	jns    80106261 <sys_pipe+0xb1>
    if(fd0 >= 0)
8010622b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010622f:	78 13                	js     80106244 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
80106231:	e8 e5 df ff ff       	call   8010421b <myproc>
80106236:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106239:	83 c2 08             	add    $0x8,%edx
8010623c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106243:	00 
    fileclose(rf);
80106244:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106247:	89 04 24             	mov    %eax,(%esp)
8010624a:	e8 c1 ae ff ff       	call   80101110 <fileclose>
    fileclose(wf);
8010624f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106252:	89 04 24             	mov    %eax,(%esp)
80106255:	e8 b6 ae ff ff       	call   80101110 <fileclose>
    return -1;
8010625a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625f:	eb 18                	jmp    80106279 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
80106261:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106264:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106267:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106269:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010626c:	8d 50 04             	lea    0x4(%eax),%edx
8010626f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106272:	89 02                	mov    %eax,(%edx)
  return 0;
80106274:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106279:	c9                   	leave  
8010627a:	c3                   	ret    
	...

8010627c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010627c:	55                   	push   %ebp
8010627d:	89 e5                	mov    %esp,%ebp
8010627f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106282:	e8 90 e2 ff ff       	call   80104517 <fork>
}
80106287:	c9                   	leave  
80106288:	c3                   	ret    

80106289 <sys_exit>:

int
sys_exit(void)
{
80106289:	55                   	push   %ebp
8010628a:	89 e5                	mov    %esp,%ebp
8010628c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010628f:	e8 e9 e3 ff ff       	call   8010467d <exit>
  return 0;  // not reached
80106294:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106299:	c9                   	leave  
8010629a:	c3                   	ret    

8010629b <sys_wait>:

int
sys_wait(void)
{
8010629b:	55                   	push   %ebp
8010629c:	89 e5                	mov    %esp,%ebp
8010629e:	83 ec 08             	sub    $0x8,%esp
  return wait();
801062a1:	e8 e0 e4 ff ff       	call   80104786 <wait>
}
801062a6:	c9                   	leave  
801062a7:	c3                   	ret    

801062a8 <sys_kill>:

int
sys_kill(void)
{
801062a8:	55                   	push   %ebp
801062a9:	89 e5                	mov    %esp,%ebp
801062ab:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801062b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062bc:	e8 00 f1 ff ff       	call   801053c1 <argint>
801062c1:	85 c0                	test   %eax,%eax
801062c3:	79 07                	jns    801062cc <sys_kill+0x24>
    return -1;
801062c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ca:	eb 0b                	jmp    801062d7 <sys_kill+0x2f>
  return kill(pid);
801062cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062cf:	89 04 24             	mov    %eax,(%esp)
801062d2:	e8 84 e8 ff ff       	call   80104b5b <kill>
}
801062d7:	c9                   	leave  
801062d8:	c3                   	ret    

801062d9 <sys_getpid>:

int
sys_getpid(void)
{
801062d9:	55                   	push   %ebp
801062da:	89 e5                	mov    %esp,%ebp
801062dc:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801062df:	e8 37 df ff ff       	call   8010421b <myproc>
801062e4:	8b 40 10             	mov    0x10(%eax),%eax
}
801062e7:	c9                   	leave  
801062e8:	c3                   	ret    

801062e9 <sys_sbrk>:

int
sys_sbrk(void)
{
801062e9:	55                   	push   %ebp
801062ea:	89 e5                	mov    %esp,%ebp
801062ec:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801062ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801062f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062fd:	e8 bf f0 ff ff       	call   801053c1 <argint>
80106302:	85 c0                	test   %eax,%eax
80106304:	79 07                	jns    8010630d <sys_sbrk+0x24>
    return -1;
80106306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630b:	eb 23                	jmp    80106330 <sys_sbrk+0x47>
  addr = myproc()->sz;
8010630d:	e8 09 df ff ff       	call   8010421b <myproc>
80106312:	8b 00                	mov    (%eax),%eax
80106314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106317:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631a:	89 04 24             	mov    %eax,(%esp)
8010631d:	e8 57 e1 ff ff       	call   80104479 <growproc>
80106322:	85 c0                	test   %eax,%eax
80106324:	79 07                	jns    8010632d <sys_sbrk+0x44>
    return -1;
80106326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010632b:	eb 03                	jmp    80106330 <sys_sbrk+0x47>
  return addr;
8010632d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106330:	c9                   	leave  
80106331:	c3                   	ret    

80106332 <sys_sleep>:

int
sys_sleep(void)
{
80106332:	55                   	push   %ebp
80106333:	89 e5                	mov    %esp,%ebp
80106335:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106338:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010633b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010633f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106346:	e8 76 f0 ff ff       	call   801053c1 <argint>
8010634b:	85 c0                	test   %eax,%eax
8010634d:	79 07                	jns    80106356 <sys_sleep+0x24>
    return -1;
8010634f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106354:	eb 6b                	jmp    801063c1 <sys_sleep+0x8f>
  acquire(&tickslock);
80106356:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010635d:	e8 c9 ea ff ff       	call   80104e2b <acquire>
  ticks0 = ticks;
80106362:	a1 60 67 11 80       	mov    0x80116760,%eax
80106367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010636a:	eb 33                	jmp    8010639f <sys_sleep+0x6d>
    if(myproc()->killed){
8010636c:	e8 aa de ff ff       	call   8010421b <myproc>
80106371:	8b 40 24             	mov    0x24(%eax),%eax
80106374:	85 c0                	test   %eax,%eax
80106376:	74 13                	je     8010638b <sys_sleep+0x59>
      release(&tickslock);
80106378:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010637f:	e8 11 eb ff ff       	call   80104e95 <release>
      return -1;
80106384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106389:	eb 36                	jmp    801063c1 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
8010638b:	c7 44 24 04 20 5f 11 	movl   $0x80115f20,0x4(%esp)
80106392:	80 
80106393:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
8010639a:	e8 bd e6 ff ff       	call   80104a5c <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010639f:	a1 60 67 11 80       	mov    0x80116760,%eax
801063a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801063a7:	89 c2                	mov    %eax,%edx
801063a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ac:	39 c2                	cmp    %eax,%edx
801063ae:	72 bc                	jb     8010636c <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801063b0:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801063b7:	e8 d9 ea ff ff       	call   80104e95 <release>
  return 0;
801063bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063c1:	c9                   	leave  
801063c2:	c3                   	ret    

801063c3 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801063c3:	55                   	push   %ebp
801063c4:	89 e5                	mov    %esp,%ebp
801063c6:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
801063c9:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801063d0:	e8 56 ea ff ff       	call   80104e2b <acquire>
  xticks = ticks;
801063d5:	a1 60 67 11 80       	mov    0x80116760,%eax
801063da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801063dd:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801063e4:	e8 ac ea ff ff       	call   80104e95 <release>
  return xticks;
801063e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801063ec:	c9                   	leave  
801063ed:	c3                   	ret    
	...

801063f0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801063f0:	1e                   	push   %ds
  pushl %es
801063f1:	06                   	push   %es
  pushl %fs
801063f2:	0f a0                	push   %fs
  pushl %gs
801063f4:	0f a8                	push   %gs
  pushal
801063f6:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801063f7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801063fb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801063fd:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801063ff:	54                   	push   %esp
  call trap
80106400:	e8 c0 01 00 00       	call   801065c5 <trap>
  addl $4, %esp
80106405:	83 c4 04             	add    $0x4,%esp

80106408 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106408:	61                   	popa   
  popl %gs
80106409:	0f a9                	pop    %gs
  popl %fs
8010640b:	0f a1                	pop    %fs
  popl %es
8010640d:	07                   	pop    %es
  popl %ds
8010640e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010640f:	83 c4 08             	add    $0x8,%esp
  iret
80106412:	cf                   	iret   
	...

80106414 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010641a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010641d:	48                   	dec    %eax
8010641e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106422:	8b 45 08             	mov    0x8(%ebp),%eax
80106425:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106429:	8b 45 08             	mov    0x8(%ebp),%eax
8010642c:	c1 e8 10             	shr    $0x10,%eax
8010642f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106433:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106436:	0f 01 18             	lidtl  (%eax)
}
80106439:	c9                   	leave  
8010643a:	c3                   	ret    

8010643b <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010643b:	55                   	push   %ebp
8010643c:	89 e5                	mov    %esp,%ebp
8010643e:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106441:	0f 20 d0             	mov    %cr2,%eax
80106444:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106447:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010644a:	c9                   	leave  
8010644b:	c3                   	ret    

8010644c <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010644c:	55                   	push   %ebp
8010644d:	89 e5                	mov    %esp,%ebp
8010644f:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106452:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106459:	e9 b8 00 00 00       	jmp    80106516 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010645e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106461:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
80106468:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010646b:	66 89 04 d5 60 5f 11 	mov    %ax,-0x7feea0a0(,%edx,8)
80106472:	80 
80106473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106476:	66 c7 04 c5 62 5f 11 	movw   $0x8,-0x7feea09e(,%eax,8)
8010647d:	80 08 00 
80106480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106483:	8a 14 c5 64 5f 11 80 	mov    -0x7feea09c(,%eax,8),%dl
8010648a:	83 e2 e0             	and    $0xffffffe0,%edx
8010648d:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
80106494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106497:	8a 14 c5 64 5f 11 80 	mov    -0x7feea09c(,%eax,8),%dl
8010649e:	83 e2 1f             	and    $0x1f,%edx
801064a1:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
801064a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ab:	8a 14 c5 65 5f 11 80 	mov    -0x7feea09b(,%eax,8),%dl
801064b2:	83 e2 f0             	and    $0xfffffff0,%edx
801064b5:	83 ca 0e             	or     $0xe,%edx
801064b8:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801064bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c2:	8a 14 c5 65 5f 11 80 	mov    -0x7feea09b(,%eax,8),%dl
801064c9:	83 e2 ef             	and    $0xffffffef,%edx
801064cc:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801064d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d6:	8a 14 c5 65 5f 11 80 	mov    -0x7feea09b(,%eax,8),%dl
801064dd:	83 e2 9f             	and    $0xffffff9f,%edx
801064e0:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801064e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ea:	8a 14 c5 65 5f 11 80 	mov    -0x7feea09b(,%eax,8),%dl
801064f1:	83 ca 80             	or     $0xffffff80,%edx
801064f4:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801064fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064fe:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
80106505:	c1 e8 10             	shr    $0x10,%eax
80106508:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010650b:	66 89 04 d5 66 5f 11 	mov    %ax,-0x7feea09a(,%edx,8)
80106512:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106513:	ff 45 f4             	incl   -0xc(%ebp)
80106516:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010651d:	0f 8e 3b ff ff ff    	jle    8010645e <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106523:	a1 78 b1 10 80       	mov    0x8010b178,%eax
80106528:	66 a3 60 61 11 80    	mov    %ax,0x80116160
8010652e:	66 c7 05 62 61 11 80 	movw   $0x8,0x80116162
80106535:	08 00 
80106537:	a0 64 61 11 80       	mov    0x80116164,%al
8010653c:	83 e0 e0             	and    $0xffffffe0,%eax
8010653f:	a2 64 61 11 80       	mov    %al,0x80116164
80106544:	a0 64 61 11 80       	mov    0x80116164,%al
80106549:	83 e0 1f             	and    $0x1f,%eax
8010654c:	a2 64 61 11 80       	mov    %al,0x80116164
80106551:	a0 65 61 11 80       	mov    0x80116165,%al
80106556:	83 c8 0f             	or     $0xf,%eax
80106559:	a2 65 61 11 80       	mov    %al,0x80116165
8010655e:	a0 65 61 11 80       	mov    0x80116165,%al
80106563:	83 e0 ef             	and    $0xffffffef,%eax
80106566:	a2 65 61 11 80       	mov    %al,0x80116165
8010656b:	a0 65 61 11 80       	mov    0x80116165,%al
80106570:	83 c8 60             	or     $0x60,%eax
80106573:	a2 65 61 11 80       	mov    %al,0x80116165
80106578:	a0 65 61 11 80       	mov    0x80116165,%al
8010657d:	83 c8 80             	or     $0xffffff80,%eax
80106580:	a2 65 61 11 80       	mov    %al,0x80116165
80106585:	a1 78 b1 10 80       	mov    0x8010b178,%eax
8010658a:	c1 e8 10             	shr    $0x10,%eax
8010658d:	66 a3 66 61 11 80    	mov    %ax,0x80116166

  initlock(&tickslock, "time");
80106593:	c7 44 24 04 f4 86 10 	movl   $0x801086f4,0x4(%esp)
8010659a:	80 
8010659b:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801065a2:	e8 63 e8 ff ff       	call   80104e0a <initlock>
}
801065a7:	c9                   	leave  
801065a8:	c3                   	ret    

801065a9 <idtinit>:

void
idtinit(void)
{
801065a9:	55                   	push   %ebp
801065aa:	89 e5                	mov    %esp,%ebp
801065ac:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801065af:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801065b6:	00 
801065b7:	c7 04 24 60 5f 11 80 	movl   $0x80115f60,(%esp)
801065be:	e8 51 fe ff ff       	call   80106414 <lidt>
}
801065c3:	c9                   	leave  
801065c4:	c3                   	ret    

801065c5 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801065c5:	55                   	push   %ebp
801065c6:	89 e5                	mov    %esp,%ebp
801065c8:	57                   	push   %edi
801065c9:	56                   	push   %esi
801065ca:	53                   	push   %ebx
801065cb:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801065ce:	8b 45 08             	mov    0x8(%ebp),%eax
801065d1:	8b 40 30             	mov    0x30(%eax),%eax
801065d4:	83 f8 40             	cmp    $0x40,%eax
801065d7:	75 3c                	jne    80106615 <trap+0x50>
    if(myproc()->killed)
801065d9:	e8 3d dc ff ff       	call   8010421b <myproc>
801065de:	8b 40 24             	mov    0x24(%eax),%eax
801065e1:	85 c0                	test   %eax,%eax
801065e3:	74 05                	je     801065ea <trap+0x25>
      exit();
801065e5:	e8 93 e0 ff ff       	call   8010467d <exit>
    myproc()->tf = tf;
801065ea:	e8 2c dc ff ff       	call   8010421b <myproc>
801065ef:	8b 55 08             	mov    0x8(%ebp),%edx
801065f2:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801065f5:	e8 95 ee ff ff       	call   8010548f <syscall>
    if(myproc()->killed)
801065fa:	e8 1c dc ff ff       	call   8010421b <myproc>
801065ff:	8b 40 24             	mov    0x24(%eax),%eax
80106602:	85 c0                	test   %eax,%eax
80106604:	74 0a                	je     80106610 <trap+0x4b>
      exit();
80106606:	e8 72 e0 ff ff       	call   8010467d <exit>
    return;
8010660b:	e9 13 02 00 00       	jmp    80106823 <trap+0x25e>
80106610:	e9 0e 02 00 00       	jmp    80106823 <trap+0x25e>
  }

  switch(tf->trapno){
80106615:	8b 45 08             	mov    0x8(%ebp),%eax
80106618:	8b 40 30             	mov    0x30(%eax),%eax
8010661b:	83 e8 20             	sub    $0x20,%eax
8010661e:	83 f8 1f             	cmp    $0x1f,%eax
80106621:	0f 87 ae 00 00 00    	ja     801066d5 <trap+0x110>
80106627:	8b 04 85 9c 87 10 80 	mov    -0x7fef7864(,%eax,4),%eax
8010662e:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106630:	e8 1d db ff ff       	call   80104152 <cpuid>
80106635:	85 c0                	test   %eax,%eax
80106637:	75 2f                	jne    80106668 <trap+0xa3>
      acquire(&tickslock);
80106639:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106640:	e8 e6 e7 ff ff       	call   80104e2b <acquire>
      ticks++;
80106645:	a1 60 67 11 80       	mov    0x80116760,%eax
8010664a:	40                   	inc    %eax
8010664b:	a3 60 67 11 80       	mov    %eax,0x80116760
      wakeup(&ticks);
80106650:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
80106657:	e8 d4 e4 ff ff       	call   80104b30 <wakeup>
      release(&tickslock);
8010665c:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106663:	e8 2d e8 ff ff       	call   80104e95 <release>
    }
    lapiceoi();
80106668:	e8 8e c9 ff ff       	call   80102ffb <lapiceoi>
    break;
8010666d:	e9 35 01 00 00       	jmp    801067a7 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106672:	e8 03 c2 ff ff       	call   8010287a <ideintr>
    lapiceoi();
80106677:	e8 7f c9 ff ff       	call   80102ffb <lapiceoi>
    break;
8010667c:	e9 26 01 00 00       	jmp    801067a7 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106681:	e8 8c c7 ff ff       	call   80102e12 <kbdintr>
    lapiceoi();
80106686:	e8 70 c9 ff ff       	call   80102ffb <lapiceoi>
    break;
8010668b:	e9 17 01 00 00       	jmp    801067a7 <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106690:	e8 70 03 00 00       	call   80106a05 <uartintr>
    lapiceoi();
80106695:	e8 61 c9 ff ff       	call   80102ffb <lapiceoi>
    break;
8010669a:	e9 08 01 00 00       	jmp    801067a7 <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010669f:	8b 45 08             	mov    0x8(%ebp),%eax
801066a2:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801066a5:	8b 45 08             	mov    0x8(%ebp),%eax
801066a8:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066ab:	0f b7 d8             	movzwl %ax,%ebx
801066ae:	e8 9f da ff ff       	call   80104152 <cpuid>
801066b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801066b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801066bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801066bf:	c7 04 24 fc 86 10 80 	movl   $0x801086fc,(%esp)
801066c6:	e8 f6 9c ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801066cb:	e8 2b c9 ff ff       	call   80102ffb <lapiceoi>
    break;
801066d0:	e9 d2 00 00 00       	jmp    801067a7 <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801066d5:	e8 41 db ff ff       	call   8010421b <myproc>
801066da:	85 c0                	test   %eax,%eax
801066dc:	74 10                	je     801066ee <trap+0x129>
801066de:	8b 45 08             	mov    0x8(%ebp),%eax
801066e1:	8b 40 3c             	mov    0x3c(%eax),%eax
801066e4:	0f b7 c0             	movzwl %ax,%eax
801066e7:	83 e0 03             	and    $0x3,%eax
801066ea:	85 c0                	test   %eax,%eax
801066ec:	75 40                	jne    8010672e <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066ee:	e8 48 fd ff ff       	call   8010643b <rcr2>
801066f3:	89 c3                	mov    %eax,%ebx
801066f5:	8b 45 08             	mov    0x8(%ebp),%eax
801066f8:	8b 70 38             	mov    0x38(%eax),%esi
801066fb:	e8 52 da ff ff       	call   80104152 <cpuid>
80106700:	8b 55 08             	mov    0x8(%ebp),%edx
80106703:	8b 52 30             	mov    0x30(%edx),%edx
80106706:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010670a:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010670e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106712:	89 54 24 04          	mov    %edx,0x4(%esp)
80106716:	c7 04 24 20 87 10 80 	movl   $0x80108720,(%esp)
8010671d:	e8 9f 9c ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106722:	c7 04 24 52 87 10 80 	movl   $0x80108752,(%esp)
80106729:	e8 26 9e ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010672e:	e8 08 fd ff ff       	call   8010643b <rcr2>
80106733:	89 c6                	mov    %eax,%esi
80106735:	8b 45 08             	mov    0x8(%ebp),%eax
80106738:	8b 40 38             	mov    0x38(%eax),%eax
8010673b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010673e:	e8 0f da ff ff       	call   80104152 <cpuid>
80106743:	89 c3                	mov    %eax,%ebx
80106745:	8b 45 08             	mov    0x8(%ebp),%eax
80106748:	8b 78 34             	mov    0x34(%eax),%edi
8010674b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010674e:	8b 45 08             	mov    0x8(%ebp),%eax
80106751:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106754:	e8 c2 da ff ff       	call   8010421b <myproc>
80106759:	8d 50 6c             	lea    0x6c(%eax),%edx
8010675c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010675f:	e8 b7 da ff ff       	call   8010421b <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106764:	8b 40 10             	mov    0x10(%eax),%eax
80106767:	89 74 24 1c          	mov    %esi,0x1c(%esp)
8010676b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010676e:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106772:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106776:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106779:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010677d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106781:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106784:	89 54 24 08          	mov    %edx,0x8(%esp)
80106788:	89 44 24 04          	mov    %eax,0x4(%esp)
8010678c:	c7 04 24 58 87 10 80 	movl   $0x80108758,(%esp)
80106793:	e8 29 9c ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106798:	e8 7e da ff ff       	call   8010421b <myproc>
8010679d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801067a4:	eb 01                	jmp    801067a7 <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801067a6:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067a7:	e8 6f da ff ff       	call   8010421b <myproc>
801067ac:	85 c0                	test   %eax,%eax
801067ae:	74 22                	je     801067d2 <trap+0x20d>
801067b0:	e8 66 da ff ff       	call   8010421b <myproc>
801067b5:	8b 40 24             	mov    0x24(%eax),%eax
801067b8:	85 c0                	test   %eax,%eax
801067ba:	74 16                	je     801067d2 <trap+0x20d>
801067bc:	8b 45 08             	mov    0x8(%ebp),%eax
801067bf:	8b 40 3c             	mov    0x3c(%eax),%eax
801067c2:	0f b7 c0             	movzwl %ax,%eax
801067c5:	83 e0 03             	and    $0x3,%eax
801067c8:	83 f8 03             	cmp    $0x3,%eax
801067cb:	75 05                	jne    801067d2 <trap+0x20d>
    exit();
801067cd:	e8 ab de ff ff       	call   8010467d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801067d2:	e8 44 da ff ff       	call   8010421b <myproc>
801067d7:	85 c0                	test   %eax,%eax
801067d9:	74 1d                	je     801067f8 <trap+0x233>
801067db:	e8 3b da ff ff       	call   8010421b <myproc>
801067e0:	8b 40 0c             	mov    0xc(%eax),%eax
801067e3:	83 f8 04             	cmp    $0x4,%eax
801067e6:	75 10                	jne    801067f8 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801067e8:	8b 45 08             	mov    0x8(%ebp),%eax
801067eb:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801067ee:	83 f8 20             	cmp    $0x20,%eax
801067f1:	75 05                	jne    801067f8 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801067f3:	e8 f4 e1 ff ff       	call   801049ec <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067f8:	e8 1e da ff ff       	call   8010421b <myproc>
801067fd:	85 c0                	test   %eax,%eax
801067ff:	74 22                	je     80106823 <trap+0x25e>
80106801:	e8 15 da ff ff       	call   8010421b <myproc>
80106806:	8b 40 24             	mov    0x24(%eax),%eax
80106809:	85 c0                	test   %eax,%eax
8010680b:	74 16                	je     80106823 <trap+0x25e>
8010680d:	8b 45 08             	mov    0x8(%ebp),%eax
80106810:	8b 40 3c             	mov    0x3c(%eax),%eax
80106813:	0f b7 c0             	movzwl %ax,%eax
80106816:	83 e0 03             	and    $0x3,%eax
80106819:	83 f8 03             	cmp    $0x3,%eax
8010681c:	75 05                	jne    80106823 <trap+0x25e>
    exit();
8010681e:	e8 5a de ff ff       	call   8010467d <exit>
}
80106823:	83 c4 3c             	add    $0x3c,%esp
80106826:	5b                   	pop    %ebx
80106827:	5e                   	pop    %esi
80106828:	5f                   	pop    %edi
80106829:	5d                   	pop    %ebp
8010682a:	c3                   	ret    
	...

8010682c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010682c:	55                   	push   %ebp
8010682d:	89 e5                	mov    %esp,%ebp
8010682f:	83 ec 14             	sub    $0x14,%esp
80106832:	8b 45 08             	mov    0x8(%ebp),%eax
80106835:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106839:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010683c:	89 c2                	mov    %eax,%edx
8010683e:	ec                   	in     (%dx),%al
8010683f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106842:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80106845:	c9                   	leave  
80106846:	c3                   	ret    

80106847 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106847:	55                   	push   %ebp
80106848:	89 e5                	mov    %esp,%ebp
8010684a:	83 ec 08             	sub    $0x8,%esp
8010684d:	8b 45 08             	mov    0x8(%ebp),%eax
80106850:	8b 55 0c             	mov    0xc(%ebp),%edx
80106853:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106857:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010685a:	8a 45 f8             	mov    -0x8(%ebp),%al
8010685d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106860:	ee                   	out    %al,(%dx)
}
80106861:	c9                   	leave  
80106862:	c3                   	ret    

80106863 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106863:	55                   	push   %ebp
80106864:	89 e5                	mov    %esp,%ebp
80106866:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106869:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106870:	00 
80106871:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106878:	e8 ca ff ff ff       	call   80106847 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010687d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106884:	00 
80106885:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010688c:	e8 b6 ff ff ff       	call   80106847 <outb>
  outb(COM1+0, 115200/9600);
80106891:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106898:	00 
80106899:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068a0:	e8 a2 ff ff ff       	call   80106847 <outb>
  outb(COM1+1, 0);
801068a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068ac:	00 
801068ad:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801068b4:	e8 8e ff ff ff       	call   80106847 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801068b9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801068c0:	00 
801068c1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801068c8:	e8 7a ff ff ff       	call   80106847 <outb>
  outb(COM1+4, 0);
801068cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068d4:	00 
801068d5:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801068dc:	e8 66 ff ff ff       	call   80106847 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801068e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801068e8:	00 
801068e9:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801068f0:	e8 52 ff ff ff       	call   80106847 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801068f5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068fc:	e8 2b ff ff ff       	call   8010682c <inb>
80106901:	3c ff                	cmp    $0xff,%al
80106903:	75 02                	jne    80106907 <uartinit+0xa4>
    return;
80106905:	eb 5b                	jmp    80106962 <uartinit+0xff>
  uart = 1;
80106907:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
8010690e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106911:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106918:	e8 0f ff ff ff       	call   8010682c <inb>
  inb(COM1+0);
8010691d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106924:	e8 03 ff ff ff       	call   8010682c <inb>
  ioapicenable(IRQ_COM1, 0);
80106929:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106930:	00 
80106931:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106938:	e8 b2 c1 ff ff       	call   80102aef <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010693d:	c7 45 f4 1c 88 10 80 	movl   $0x8010881c,-0xc(%ebp)
80106944:	eb 13                	jmp    80106959 <uartinit+0xf6>
    uartputc(*p);
80106946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106949:	8a 00                	mov    (%eax),%al
8010694b:	0f be c0             	movsbl %al,%eax
8010694e:	89 04 24             	mov    %eax,(%esp)
80106951:	e8 0e 00 00 00       	call   80106964 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106956:	ff 45 f4             	incl   -0xc(%ebp)
80106959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695c:	8a 00                	mov    (%eax),%al
8010695e:	84 c0                	test   %al,%al
80106960:	75 e4                	jne    80106946 <uartinit+0xe3>
    uartputc(*p);
}
80106962:	c9                   	leave  
80106963:	c3                   	ret    

80106964 <uartputc>:

void
uartputc(int c)
{
80106964:	55                   	push   %ebp
80106965:	89 e5                	mov    %esp,%ebp
80106967:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010696a:	a1 24 b6 10 80       	mov    0x8010b624,%eax
8010696f:	85 c0                	test   %eax,%eax
80106971:	75 02                	jne    80106975 <uartputc+0x11>
    return;
80106973:	eb 4a                	jmp    801069bf <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106975:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010697c:	eb 0f                	jmp    8010698d <uartputc+0x29>
    microdelay(10);
8010697e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106985:	e8 96 c6 ff ff       	call   80103020 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010698a:	ff 45 f4             	incl   -0xc(%ebp)
8010698d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106991:	7f 16                	jg     801069a9 <uartputc+0x45>
80106993:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010699a:	e8 8d fe ff ff       	call   8010682c <inb>
8010699f:	0f b6 c0             	movzbl %al,%eax
801069a2:	83 e0 20             	and    $0x20,%eax
801069a5:	85 c0                	test   %eax,%eax
801069a7:	74 d5                	je     8010697e <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801069a9:	8b 45 08             	mov    0x8(%ebp),%eax
801069ac:	0f b6 c0             	movzbl %al,%eax
801069af:	89 44 24 04          	mov    %eax,0x4(%esp)
801069b3:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069ba:	e8 88 fe ff ff       	call   80106847 <outb>
}
801069bf:	c9                   	leave  
801069c0:	c3                   	ret    

801069c1 <uartgetc>:

static int
uartgetc(void)
{
801069c1:	55                   	push   %ebp
801069c2:	89 e5                	mov    %esp,%ebp
801069c4:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801069c7:	a1 24 b6 10 80       	mov    0x8010b624,%eax
801069cc:	85 c0                	test   %eax,%eax
801069ce:	75 07                	jne    801069d7 <uartgetc+0x16>
    return -1;
801069d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d5:	eb 2c                	jmp    80106a03 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801069d7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801069de:	e8 49 fe ff ff       	call   8010682c <inb>
801069e3:	0f b6 c0             	movzbl %al,%eax
801069e6:	83 e0 01             	and    $0x1,%eax
801069e9:	85 c0                	test   %eax,%eax
801069eb:	75 07                	jne    801069f4 <uartgetc+0x33>
    return -1;
801069ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f2:	eb 0f                	jmp    80106a03 <uartgetc+0x42>
  return inb(COM1+0);
801069f4:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069fb:	e8 2c fe ff ff       	call   8010682c <inb>
80106a00:	0f b6 c0             	movzbl %al,%eax
}
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <uartintr>:

void
uartintr(void)
{
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
80106a08:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106a0b:	c7 04 24 c1 69 10 80 	movl   $0x801069c1,(%esp)
80106a12:	e8 de 9d ff ff       	call   801007f5 <consoleintr>
}
80106a17:	c9                   	leave  
80106a18:	c3                   	ret    
80106a19:	00 00                	add    %al,(%eax)
	...

80106a1c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $0
80106a1e:	6a 00                	push   $0x0
  jmp alltraps
80106a20:	e9 cb f9 ff ff       	jmp    801063f0 <alltraps>

80106a25 <vector1>:
.globl vector1
vector1:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $1
80106a27:	6a 01                	push   $0x1
  jmp alltraps
80106a29:	e9 c2 f9 ff ff       	jmp    801063f0 <alltraps>

80106a2e <vector2>:
.globl vector2
vector2:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $2
80106a30:	6a 02                	push   $0x2
  jmp alltraps
80106a32:	e9 b9 f9 ff ff       	jmp    801063f0 <alltraps>

80106a37 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $3
80106a39:	6a 03                	push   $0x3
  jmp alltraps
80106a3b:	e9 b0 f9 ff ff       	jmp    801063f0 <alltraps>

80106a40 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $4
80106a42:	6a 04                	push   $0x4
  jmp alltraps
80106a44:	e9 a7 f9 ff ff       	jmp    801063f0 <alltraps>

80106a49 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $5
80106a4b:	6a 05                	push   $0x5
  jmp alltraps
80106a4d:	e9 9e f9 ff ff       	jmp    801063f0 <alltraps>

80106a52 <vector6>:
.globl vector6
vector6:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $6
80106a54:	6a 06                	push   $0x6
  jmp alltraps
80106a56:	e9 95 f9 ff ff       	jmp    801063f0 <alltraps>

80106a5b <vector7>:
.globl vector7
vector7:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $7
80106a5d:	6a 07                	push   $0x7
  jmp alltraps
80106a5f:	e9 8c f9 ff ff       	jmp    801063f0 <alltraps>

80106a64 <vector8>:
.globl vector8
vector8:
  pushl $8
80106a64:	6a 08                	push   $0x8
  jmp alltraps
80106a66:	e9 85 f9 ff ff       	jmp    801063f0 <alltraps>

80106a6b <vector9>:
.globl vector9
vector9:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $9
80106a6d:	6a 09                	push   $0x9
  jmp alltraps
80106a6f:	e9 7c f9 ff ff       	jmp    801063f0 <alltraps>

80106a74 <vector10>:
.globl vector10
vector10:
  pushl $10
80106a74:	6a 0a                	push   $0xa
  jmp alltraps
80106a76:	e9 75 f9 ff ff       	jmp    801063f0 <alltraps>

80106a7b <vector11>:
.globl vector11
vector11:
  pushl $11
80106a7b:	6a 0b                	push   $0xb
  jmp alltraps
80106a7d:	e9 6e f9 ff ff       	jmp    801063f0 <alltraps>

80106a82 <vector12>:
.globl vector12
vector12:
  pushl $12
80106a82:	6a 0c                	push   $0xc
  jmp alltraps
80106a84:	e9 67 f9 ff ff       	jmp    801063f0 <alltraps>

80106a89 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a89:	6a 0d                	push   $0xd
  jmp alltraps
80106a8b:	e9 60 f9 ff ff       	jmp    801063f0 <alltraps>

80106a90 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a90:	6a 0e                	push   $0xe
  jmp alltraps
80106a92:	e9 59 f9 ff ff       	jmp    801063f0 <alltraps>

80106a97 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $15
80106a99:	6a 0f                	push   $0xf
  jmp alltraps
80106a9b:	e9 50 f9 ff ff       	jmp    801063f0 <alltraps>

80106aa0 <vector16>:
.globl vector16
vector16:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $16
80106aa2:	6a 10                	push   $0x10
  jmp alltraps
80106aa4:	e9 47 f9 ff ff       	jmp    801063f0 <alltraps>

80106aa9 <vector17>:
.globl vector17
vector17:
  pushl $17
80106aa9:	6a 11                	push   $0x11
  jmp alltraps
80106aab:	e9 40 f9 ff ff       	jmp    801063f0 <alltraps>

80106ab0 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $18
80106ab2:	6a 12                	push   $0x12
  jmp alltraps
80106ab4:	e9 37 f9 ff ff       	jmp    801063f0 <alltraps>

80106ab9 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $19
80106abb:	6a 13                	push   $0x13
  jmp alltraps
80106abd:	e9 2e f9 ff ff       	jmp    801063f0 <alltraps>

80106ac2 <vector20>:
.globl vector20
vector20:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $20
80106ac4:	6a 14                	push   $0x14
  jmp alltraps
80106ac6:	e9 25 f9 ff ff       	jmp    801063f0 <alltraps>

80106acb <vector21>:
.globl vector21
vector21:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $21
80106acd:	6a 15                	push   $0x15
  jmp alltraps
80106acf:	e9 1c f9 ff ff       	jmp    801063f0 <alltraps>

80106ad4 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $22
80106ad6:	6a 16                	push   $0x16
  jmp alltraps
80106ad8:	e9 13 f9 ff ff       	jmp    801063f0 <alltraps>

80106add <vector23>:
.globl vector23
vector23:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $23
80106adf:	6a 17                	push   $0x17
  jmp alltraps
80106ae1:	e9 0a f9 ff ff       	jmp    801063f0 <alltraps>

80106ae6 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $24
80106ae8:	6a 18                	push   $0x18
  jmp alltraps
80106aea:	e9 01 f9 ff ff       	jmp    801063f0 <alltraps>

80106aef <vector25>:
.globl vector25
vector25:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $25
80106af1:	6a 19                	push   $0x19
  jmp alltraps
80106af3:	e9 f8 f8 ff ff       	jmp    801063f0 <alltraps>

80106af8 <vector26>:
.globl vector26
vector26:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $26
80106afa:	6a 1a                	push   $0x1a
  jmp alltraps
80106afc:	e9 ef f8 ff ff       	jmp    801063f0 <alltraps>

80106b01 <vector27>:
.globl vector27
vector27:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $27
80106b03:	6a 1b                	push   $0x1b
  jmp alltraps
80106b05:	e9 e6 f8 ff ff       	jmp    801063f0 <alltraps>

80106b0a <vector28>:
.globl vector28
vector28:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $28
80106b0c:	6a 1c                	push   $0x1c
  jmp alltraps
80106b0e:	e9 dd f8 ff ff       	jmp    801063f0 <alltraps>

80106b13 <vector29>:
.globl vector29
vector29:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $29
80106b15:	6a 1d                	push   $0x1d
  jmp alltraps
80106b17:	e9 d4 f8 ff ff       	jmp    801063f0 <alltraps>

80106b1c <vector30>:
.globl vector30
vector30:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $30
80106b1e:	6a 1e                	push   $0x1e
  jmp alltraps
80106b20:	e9 cb f8 ff ff       	jmp    801063f0 <alltraps>

80106b25 <vector31>:
.globl vector31
vector31:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $31
80106b27:	6a 1f                	push   $0x1f
  jmp alltraps
80106b29:	e9 c2 f8 ff ff       	jmp    801063f0 <alltraps>

80106b2e <vector32>:
.globl vector32
vector32:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $32
80106b30:	6a 20                	push   $0x20
  jmp alltraps
80106b32:	e9 b9 f8 ff ff       	jmp    801063f0 <alltraps>

80106b37 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $33
80106b39:	6a 21                	push   $0x21
  jmp alltraps
80106b3b:	e9 b0 f8 ff ff       	jmp    801063f0 <alltraps>

80106b40 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $34
80106b42:	6a 22                	push   $0x22
  jmp alltraps
80106b44:	e9 a7 f8 ff ff       	jmp    801063f0 <alltraps>

80106b49 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $35
80106b4b:	6a 23                	push   $0x23
  jmp alltraps
80106b4d:	e9 9e f8 ff ff       	jmp    801063f0 <alltraps>

80106b52 <vector36>:
.globl vector36
vector36:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $36
80106b54:	6a 24                	push   $0x24
  jmp alltraps
80106b56:	e9 95 f8 ff ff       	jmp    801063f0 <alltraps>

80106b5b <vector37>:
.globl vector37
vector37:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $37
80106b5d:	6a 25                	push   $0x25
  jmp alltraps
80106b5f:	e9 8c f8 ff ff       	jmp    801063f0 <alltraps>

80106b64 <vector38>:
.globl vector38
vector38:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $38
80106b66:	6a 26                	push   $0x26
  jmp alltraps
80106b68:	e9 83 f8 ff ff       	jmp    801063f0 <alltraps>

80106b6d <vector39>:
.globl vector39
vector39:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $39
80106b6f:	6a 27                	push   $0x27
  jmp alltraps
80106b71:	e9 7a f8 ff ff       	jmp    801063f0 <alltraps>

80106b76 <vector40>:
.globl vector40
vector40:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $40
80106b78:	6a 28                	push   $0x28
  jmp alltraps
80106b7a:	e9 71 f8 ff ff       	jmp    801063f0 <alltraps>

80106b7f <vector41>:
.globl vector41
vector41:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $41
80106b81:	6a 29                	push   $0x29
  jmp alltraps
80106b83:	e9 68 f8 ff ff       	jmp    801063f0 <alltraps>

80106b88 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $42
80106b8a:	6a 2a                	push   $0x2a
  jmp alltraps
80106b8c:	e9 5f f8 ff ff       	jmp    801063f0 <alltraps>

80106b91 <vector43>:
.globl vector43
vector43:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $43
80106b93:	6a 2b                	push   $0x2b
  jmp alltraps
80106b95:	e9 56 f8 ff ff       	jmp    801063f0 <alltraps>

80106b9a <vector44>:
.globl vector44
vector44:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $44
80106b9c:	6a 2c                	push   $0x2c
  jmp alltraps
80106b9e:	e9 4d f8 ff ff       	jmp    801063f0 <alltraps>

80106ba3 <vector45>:
.globl vector45
vector45:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $45
80106ba5:	6a 2d                	push   $0x2d
  jmp alltraps
80106ba7:	e9 44 f8 ff ff       	jmp    801063f0 <alltraps>

80106bac <vector46>:
.globl vector46
vector46:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $46
80106bae:	6a 2e                	push   $0x2e
  jmp alltraps
80106bb0:	e9 3b f8 ff ff       	jmp    801063f0 <alltraps>

80106bb5 <vector47>:
.globl vector47
vector47:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $47
80106bb7:	6a 2f                	push   $0x2f
  jmp alltraps
80106bb9:	e9 32 f8 ff ff       	jmp    801063f0 <alltraps>

80106bbe <vector48>:
.globl vector48
vector48:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $48
80106bc0:	6a 30                	push   $0x30
  jmp alltraps
80106bc2:	e9 29 f8 ff ff       	jmp    801063f0 <alltraps>

80106bc7 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $49
80106bc9:	6a 31                	push   $0x31
  jmp alltraps
80106bcb:	e9 20 f8 ff ff       	jmp    801063f0 <alltraps>

80106bd0 <vector50>:
.globl vector50
vector50:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $50
80106bd2:	6a 32                	push   $0x32
  jmp alltraps
80106bd4:	e9 17 f8 ff ff       	jmp    801063f0 <alltraps>

80106bd9 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $51
80106bdb:	6a 33                	push   $0x33
  jmp alltraps
80106bdd:	e9 0e f8 ff ff       	jmp    801063f0 <alltraps>

80106be2 <vector52>:
.globl vector52
vector52:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $52
80106be4:	6a 34                	push   $0x34
  jmp alltraps
80106be6:	e9 05 f8 ff ff       	jmp    801063f0 <alltraps>

80106beb <vector53>:
.globl vector53
vector53:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $53
80106bed:	6a 35                	push   $0x35
  jmp alltraps
80106bef:	e9 fc f7 ff ff       	jmp    801063f0 <alltraps>

80106bf4 <vector54>:
.globl vector54
vector54:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $54
80106bf6:	6a 36                	push   $0x36
  jmp alltraps
80106bf8:	e9 f3 f7 ff ff       	jmp    801063f0 <alltraps>

80106bfd <vector55>:
.globl vector55
vector55:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $55
80106bff:	6a 37                	push   $0x37
  jmp alltraps
80106c01:	e9 ea f7 ff ff       	jmp    801063f0 <alltraps>

80106c06 <vector56>:
.globl vector56
vector56:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $56
80106c08:	6a 38                	push   $0x38
  jmp alltraps
80106c0a:	e9 e1 f7 ff ff       	jmp    801063f0 <alltraps>

80106c0f <vector57>:
.globl vector57
vector57:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $57
80106c11:	6a 39                	push   $0x39
  jmp alltraps
80106c13:	e9 d8 f7 ff ff       	jmp    801063f0 <alltraps>

80106c18 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $58
80106c1a:	6a 3a                	push   $0x3a
  jmp alltraps
80106c1c:	e9 cf f7 ff ff       	jmp    801063f0 <alltraps>

80106c21 <vector59>:
.globl vector59
vector59:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $59
80106c23:	6a 3b                	push   $0x3b
  jmp alltraps
80106c25:	e9 c6 f7 ff ff       	jmp    801063f0 <alltraps>

80106c2a <vector60>:
.globl vector60
vector60:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $60
80106c2c:	6a 3c                	push   $0x3c
  jmp alltraps
80106c2e:	e9 bd f7 ff ff       	jmp    801063f0 <alltraps>

80106c33 <vector61>:
.globl vector61
vector61:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $61
80106c35:	6a 3d                	push   $0x3d
  jmp alltraps
80106c37:	e9 b4 f7 ff ff       	jmp    801063f0 <alltraps>

80106c3c <vector62>:
.globl vector62
vector62:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $62
80106c3e:	6a 3e                	push   $0x3e
  jmp alltraps
80106c40:	e9 ab f7 ff ff       	jmp    801063f0 <alltraps>

80106c45 <vector63>:
.globl vector63
vector63:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $63
80106c47:	6a 3f                	push   $0x3f
  jmp alltraps
80106c49:	e9 a2 f7 ff ff       	jmp    801063f0 <alltraps>

80106c4e <vector64>:
.globl vector64
vector64:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $64
80106c50:	6a 40                	push   $0x40
  jmp alltraps
80106c52:	e9 99 f7 ff ff       	jmp    801063f0 <alltraps>

80106c57 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $65
80106c59:	6a 41                	push   $0x41
  jmp alltraps
80106c5b:	e9 90 f7 ff ff       	jmp    801063f0 <alltraps>

80106c60 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $66
80106c62:	6a 42                	push   $0x42
  jmp alltraps
80106c64:	e9 87 f7 ff ff       	jmp    801063f0 <alltraps>

80106c69 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $67
80106c6b:	6a 43                	push   $0x43
  jmp alltraps
80106c6d:	e9 7e f7 ff ff       	jmp    801063f0 <alltraps>

80106c72 <vector68>:
.globl vector68
vector68:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $68
80106c74:	6a 44                	push   $0x44
  jmp alltraps
80106c76:	e9 75 f7 ff ff       	jmp    801063f0 <alltraps>

80106c7b <vector69>:
.globl vector69
vector69:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $69
80106c7d:	6a 45                	push   $0x45
  jmp alltraps
80106c7f:	e9 6c f7 ff ff       	jmp    801063f0 <alltraps>

80106c84 <vector70>:
.globl vector70
vector70:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $70
80106c86:	6a 46                	push   $0x46
  jmp alltraps
80106c88:	e9 63 f7 ff ff       	jmp    801063f0 <alltraps>

80106c8d <vector71>:
.globl vector71
vector71:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $71
80106c8f:	6a 47                	push   $0x47
  jmp alltraps
80106c91:	e9 5a f7 ff ff       	jmp    801063f0 <alltraps>

80106c96 <vector72>:
.globl vector72
vector72:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $72
80106c98:	6a 48                	push   $0x48
  jmp alltraps
80106c9a:	e9 51 f7 ff ff       	jmp    801063f0 <alltraps>

80106c9f <vector73>:
.globl vector73
vector73:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $73
80106ca1:	6a 49                	push   $0x49
  jmp alltraps
80106ca3:	e9 48 f7 ff ff       	jmp    801063f0 <alltraps>

80106ca8 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $74
80106caa:	6a 4a                	push   $0x4a
  jmp alltraps
80106cac:	e9 3f f7 ff ff       	jmp    801063f0 <alltraps>

80106cb1 <vector75>:
.globl vector75
vector75:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $75
80106cb3:	6a 4b                	push   $0x4b
  jmp alltraps
80106cb5:	e9 36 f7 ff ff       	jmp    801063f0 <alltraps>

80106cba <vector76>:
.globl vector76
vector76:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $76
80106cbc:	6a 4c                	push   $0x4c
  jmp alltraps
80106cbe:	e9 2d f7 ff ff       	jmp    801063f0 <alltraps>

80106cc3 <vector77>:
.globl vector77
vector77:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $77
80106cc5:	6a 4d                	push   $0x4d
  jmp alltraps
80106cc7:	e9 24 f7 ff ff       	jmp    801063f0 <alltraps>

80106ccc <vector78>:
.globl vector78
vector78:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $78
80106cce:	6a 4e                	push   $0x4e
  jmp alltraps
80106cd0:	e9 1b f7 ff ff       	jmp    801063f0 <alltraps>

80106cd5 <vector79>:
.globl vector79
vector79:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $79
80106cd7:	6a 4f                	push   $0x4f
  jmp alltraps
80106cd9:	e9 12 f7 ff ff       	jmp    801063f0 <alltraps>

80106cde <vector80>:
.globl vector80
vector80:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $80
80106ce0:	6a 50                	push   $0x50
  jmp alltraps
80106ce2:	e9 09 f7 ff ff       	jmp    801063f0 <alltraps>

80106ce7 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $81
80106ce9:	6a 51                	push   $0x51
  jmp alltraps
80106ceb:	e9 00 f7 ff ff       	jmp    801063f0 <alltraps>

80106cf0 <vector82>:
.globl vector82
vector82:
  pushl $0
80106cf0:	6a 00                	push   $0x0
  pushl $82
80106cf2:	6a 52                	push   $0x52
  jmp alltraps
80106cf4:	e9 f7 f6 ff ff       	jmp    801063f0 <alltraps>

80106cf9 <vector83>:
.globl vector83
vector83:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $83
80106cfb:	6a 53                	push   $0x53
  jmp alltraps
80106cfd:	e9 ee f6 ff ff       	jmp    801063f0 <alltraps>

80106d02 <vector84>:
.globl vector84
vector84:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $84
80106d04:	6a 54                	push   $0x54
  jmp alltraps
80106d06:	e9 e5 f6 ff ff       	jmp    801063f0 <alltraps>

80106d0b <vector85>:
.globl vector85
vector85:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $85
80106d0d:	6a 55                	push   $0x55
  jmp alltraps
80106d0f:	e9 dc f6 ff ff       	jmp    801063f0 <alltraps>

80106d14 <vector86>:
.globl vector86
vector86:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $86
80106d16:	6a 56                	push   $0x56
  jmp alltraps
80106d18:	e9 d3 f6 ff ff       	jmp    801063f0 <alltraps>

80106d1d <vector87>:
.globl vector87
vector87:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $87
80106d1f:	6a 57                	push   $0x57
  jmp alltraps
80106d21:	e9 ca f6 ff ff       	jmp    801063f0 <alltraps>

80106d26 <vector88>:
.globl vector88
vector88:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $88
80106d28:	6a 58                	push   $0x58
  jmp alltraps
80106d2a:	e9 c1 f6 ff ff       	jmp    801063f0 <alltraps>

80106d2f <vector89>:
.globl vector89
vector89:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $89
80106d31:	6a 59                	push   $0x59
  jmp alltraps
80106d33:	e9 b8 f6 ff ff       	jmp    801063f0 <alltraps>

80106d38 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $90
80106d3a:	6a 5a                	push   $0x5a
  jmp alltraps
80106d3c:	e9 af f6 ff ff       	jmp    801063f0 <alltraps>

80106d41 <vector91>:
.globl vector91
vector91:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $91
80106d43:	6a 5b                	push   $0x5b
  jmp alltraps
80106d45:	e9 a6 f6 ff ff       	jmp    801063f0 <alltraps>

80106d4a <vector92>:
.globl vector92
vector92:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $92
80106d4c:	6a 5c                	push   $0x5c
  jmp alltraps
80106d4e:	e9 9d f6 ff ff       	jmp    801063f0 <alltraps>

80106d53 <vector93>:
.globl vector93
vector93:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $93
80106d55:	6a 5d                	push   $0x5d
  jmp alltraps
80106d57:	e9 94 f6 ff ff       	jmp    801063f0 <alltraps>

80106d5c <vector94>:
.globl vector94
vector94:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $94
80106d5e:	6a 5e                	push   $0x5e
  jmp alltraps
80106d60:	e9 8b f6 ff ff       	jmp    801063f0 <alltraps>

80106d65 <vector95>:
.globl vector95
vector95:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $95
80106d67:	6a 5f                	push   $0x5f
  jmp alltraps
80106d69:	e9 82 f6 ff ff       	jmp    801063f0 <alltraps>

80106d6e <vector96>:
.globl vector96
vector96:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $96
80106d70:	6a 60                	push   $0x60
  jmp alltraps
80106d72:	e9 79 f6 ff ff       	jmp    801063f0 <alltraps>

80106d77 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $97
80106d79:	6a 61                	push   $0x61
  jmp alltraps
80106d7b:	e9 70 f6 ff ff       	jmp    801063f0 <alltraps>

80106d80 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $98
80106d82:	6a 62                	push   $0x62
  jmp alltraps
80106d84:	e9 67 f6 ff ff       	jmp    801063f0 <alltraps>

80106d89 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $99
80106d8b:	6a 63                	push   $0x63
  jmp alltraps
80106d8d:	e9 5e f6 ff ff       	jmp    801063f0 <alltraps>

80106d92 <vector100>:
.globl vector100
vector100:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $100
80106d94:	6a 64                	push   $0x64
  jmp alltraps
80106d96:	e9 55 f6 ff ff       	jmp    801063f0 <alltraps>

80106d9b <vector101>:
.globl vector101
vector101:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $101
80106d9d:	6a 65                	push   $0x65
  jmp alltraps
80106d9f:	e9 4c f6 ff ff       	jmp    801063f0 <alltraps>

80106da4 <vector102>:
.globl vector102
vector102:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $102
80106da6:	6a 66                	push   $0x66
  jmp alltraps
80106da8:	e9 43 f6 ff ff       	jmp    801063f0 <alltraps>

80106dad <vector103>:
.globl vector103
vector103:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $103
80106daf:	6a 67                	push   $0x67
  jmp alltraps
80106db1:	e9 3a f6 ff ff       	jmp    801063f0 <alltraps>

80106db6 <vector104>:
.globl vector104
vector104:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $104
80106db8:	6a 68                	push   $0x68
  jmp alltraps
80106dba:	e9 31 f6 ff ff       	jmp    801063f0 <alltraps>

80106dbf <vector105>:
.globl vector105
vector105:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $105
80106dc1:	6a 69                	push   $0x69
  jmp alltraps
80106dc3:	e9 28 f6 ff ff       	jmp    801063f0 <alltraps>

80106dc8 <vector106>:
.globl vector106
vector106:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $106
80106dca:	6a 6a                	push   $0x6a
  jmp alltraps
80106dcc:	e9 1f f6 ff ff       	jmp    801063f0 <alltraps>

80106dd1 <vector107>:
.globl vector107
vector107:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $107
80106dd3:	6a 6b                	push   $0x6b
  jmp alltraps
80106dd5:	e9 16 f6 ff ff       	jmp    801063f0 <alltraps>

80106dda <vector108>:
.globl vector108
vector108:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $108
80106ddc:	6a 6c                	push   $0x6c
  jmp alltraps
80106dde:	e9 0d f6 ff ff       	jmp    801063f0 <alltraps>

80106de3 <vector109>:
.globl vector109
vector109:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $109
80106de5:	6a 6d                	push   $0x6d
  jmp alltraps
80106de7:	e9 04 f6 ff ff       	jmp    801063f0 <alltraps>

80106dec <vector110>:
.globl vector110
vector110:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $110
80106dee:	6a 6e                	push   $0x6e
  jmp alltraps
80106df0:	e9 fb f5 ff ff       	jmp    801063f0 <alltraps>

80106df5 <vector111>:
.globl vector111
vector111:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $111
80106df7:	6a 6f                	push   $0x6f
  jmp alltraps
80106df9:	e9 f2 f5 ff ff       	jmp    801063f0 <alltraps>

80106dfe <vector112>:
.globl vector112
vector112:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $112
80106e00:	6a 70                	push   $0x70
  jmp alltraps
80106e02:	e9 e9 f5 ff ff       	jmp    801063f0 <alltraps>

80106e07 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $113
80106e09:	6a 71                	push   $0x71
  jmp alltraps
80106e0b:	e9 e0 f5 ff ff       	jmp    801063f0 <alltraps>

80106e10 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $114
80106e12:	6a 72                	push   $0x72
  jmp alltraps
80106e14:	e9 d7 f5 ff ff       	jmp    801063f0 <alltraps>

80106e19 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $115
80106e1b:	6a 73                	push   $0x73
  jmp alltraps
80106e1d:	e9 ce f5 ff ff       	jmp    801063f0 <alltraps>

80106e22 <vector116>:
.globl vector116
vector116:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $116
80106e24:	6a 74                	push   $0x74
  jmp alltraps
80106e26:	e9 c5 f5 ff ff       	jmp    801063f0 <alltraps>

80106e2b <vector117>:
.globl vector117
vector117:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $117
80106e2d:	6a 75                	push   $0x75
  jmp alltraps
80106e2f:	e9 bc f5 ff ff       	jmp    801063f0 <alltraps>

80106e34 <vector118>:
.globl vector118
vector118:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $118
80106e36:	6a 76                	push   $0x76
  jmp alltraps
80106e38:	e9 b3 f5 ff ff       	jmp    801063f0 <alltraps>

80106e3d <vector119>:
.globl vector119
vector119:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $119
80106e3f:	6a 77                	push   $0x77
  jmp alltraps
80106e41:	e9 aa f5 ff ff       	jmp    801063f0 <alltraps>

80106e46 <vector120>:
.globl vector120
vector120:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $120
80106e48:	6a 78                	push   $0x78
  jmp alltraps
80106e4a:	e9 a1 f5 ff ff       	jmp    801063f0 <alltraps>

80106e4f <vector121>:
.globl vector121
vector121:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $121
80106e51:	6a 79                	push   $0x79
  jmp alltraps
80106e53:	e9 98 f5 ff ff       	jmp    801063f0 <alltraps>

80106e58 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $122
80106e5a:	6a 7a                	push   $0x7a
  jmp alltraps
80106e5c:	e9 8f f5 ff ff       	jmp    801063f0 <alltraps>

80106e61 <vector123>:
.globl vector123
vector123:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $123
80106e63:	6a 7b                	push   $0x7b
  jmp alltraps
80106e65:	e9 86 f5 ff ff       	jmp    801063f0 <alltraps>

80106e6a <vector124>:
.globl vector124
vector124:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $124
80106e6c:	6a 7c                	push   $0x7c
  jmp alltraps
80106e6e:	e9 7d f5 ff ff       	jmp    801063f0 <alltraps>

80106e73 <vector125>:
.globl vector125
vector125:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $125
80106e75:	6a 7d                	push   $0x7d
  jmp alltraps
80106e77:	e9 74 f5 ff ff       	jmp    801063f0 <alltraps>

80106e7c <vector126>:
.globl vector126
vector126:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $126
80106e7e:	6a 7e                	push   $0x7e
  jmp alltraps
80106e80:	e9 6b f5 ff ff       	jmp    801063f0 <alltraps>

80106e85 <vector127>:
.globl vector127
vector127:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $127
80106e87:	6a 7f                	push   $0x7f
  jmp alltraps
80106e89:	e9 62 f5 ff ff       	jmp    801063f0 <alltraps>

80106e8e <vector128>:
.globl vector128
vector128:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $128
80106e90:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e95:	e9 56 f5 ff ff       	jmp    801063f0 <alltraps>

80106e9a <vector129>:
.globl vector129
vector129:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $129
80106e9c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106ea1:	e9 4a f5 ff ff       	jmp    801063f0 <alltraps>

80106ea6 <vector130>:
.globl vector130
vector130:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $130
80106ea8:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ead:	e9 3e f5 ff ff       	jmp    801063f0 <alltraps>

80106eb2 <vector131>:
.globl vector131
vector131:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $131
80106eb4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106eb9:	e9 32 f5 ff ff       	jmp    801063f0 <alltraps>

80106ebe <vector132>:
.globl vector132
vector132:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $132
80106ec0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ec5:	e9 26 f5 ff ff       	jmp    801063f0 <alltraps>

80106eca <vector133>:
.globl vector133
vector133:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $133
80106ecc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ed1:	e9 1a f5 ff ff       	jmp    801063f0 <alltraps>

80106ed6 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $134
80106ed8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106edd:	e9 0e f5 ff ff       	jmp    801063f0 <alltraps>

80106ee2 <vector135>:
.globl vector135
vector135:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $135
80106ee4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ee9:	e9 02 f5 ff ff       	jmp    801063f0 <alltraps>

80106eee <vector136>:
.globl vector136
vector136:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $136
80106ef0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ef5:	e9 f6 f4 ff ff       	jmp    801063f0 <alltraps>

80106efa <vector137>:
.globl vector137
vector137:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $137
80106efc:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f01:	e9 ea f4 ff ff       	jmp    801063f0 <alltraps>

80106f06 <vector138>:
.globl vector138
vector138:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $138
80106f08:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f0d:	e9 de f4 ff ff       	jmp    801063f0 <alltraps>

80106f12 <vector139>:
.globl vector139
vector139:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $139
80106f14:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f19:	e9 d2 f4 ff ff       	jmp    801063f0 <alltraps>

80106f1e <vector140>:
.globl vector140
vector140:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $140
80106f20:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f25:	e9 c6 f4 ff ff       	jmp    801063f0 <alltraps>

80106f2a <vector141>:
.globl vector141
vector141:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $141
80106f2c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f31:	e9 ba f4 ff ff       	jmp    801063f0 <alltraps>

80106f36 <vector142>:
.globl vector142
vector142:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $142
80106f38:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f3d:	e9 ae f4 ff ff       	jmp    801063f0 <alltraps>

80106f42 <vector143>:
.globl vector143
vector143:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $143
80106f44:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f49:	e9 a2 f4 ff ff       	jmp    801063f0 <alltraps>

80106f4e <vector144>:
.globl vector144
vector144:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $144
80106f50:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f55:	e9 96 f4 ff ff       	jmp    801063f0 <alltraps>

80106f5a <vector145>:
.globl vector145
vector145:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $145
80106f5c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f61:	e9 8a f4 ff ff       	jmp    801063f0 <alltraps>

80106f66 <vector146>:
.globl vector146
vector146:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $146
80106f68:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f6d:	e9 7e f4 ff ff       	jmp    801063f0 <alltraps>

80106f72 <vector147>:
.globl vector147
vector147:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $147
80106f74:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f79:	e9 72 f4 ff ff       	jmp    801063f0 <alltraps>

80106f7e <vector148>:
.globl vector148
vector148:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $148
80106f80:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f85:	e9 66 f4 ff ff       	jmp    801063f0 <alltraps>

80106f8a <vector149>:
.globl vector149
vector149:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $149
80106f8c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f91:	e9 5a f4 ff ff       	jmp    801063f0 <alltraps>

80106f96 <vector150>:
.globl vector150
vector150:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $150
80106f98:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f9d:	e9 4e f4 ff ff       	jmp    801063f0 <alltraps>

80106fa2 <vector151>:
.globl vector151
vector151:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $151
80106fa4:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fa9:	e9 42 f4 ff ff       	jmp    801063f0 <alltraps>

80106fae <vector152>:
.globl vector152
vector152:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $152
80106fb0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fb5:	e9 36 f4 ff ff       	jmp    801063f0 <alltraps>

80106fba <vector153>:
.globl vector153
vector153:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $153
80106fbc:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fc1:	e9 2a f4 ff ff       	jmp    801063f0 <alltraps>

80106fc6 <vector154>:
.globl vector154
vector154:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $154
80106fc8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fcd:	e9 1e f4 ff ff       	jmp    801063f0 <alltraps>

80106fd2 <vector155>:
.globl vector155
vector155:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $155
80106fd4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fd9:	e9 12 f4 ff ff       	jmp    801063f0 <alltraps>

80106fde <vector156>:
.globl vector156
vector156:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $156
80106fe0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fe5:	e9 06 f4 ff ff       	jmp    801063f0 <alltraps>

80106fea <vector157>:
.globl vector157
vector157:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $157
80106fec:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ff1:	e9 fa f3 ff ff       	jmp    801063f0 <alltraps>

80106ff6 <vector158>:
.globl vector158
vector158:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $158
80106ff8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ffd:	e9 ee f3 ff ff       	jmp    801063f0 <alltraps>

80107002 <vector159>:
.globl vector159
vector159:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $159
80107004:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107009:	e9 e2 f3 ff ff       	jmp    801063f0 <alltraps>

8010700e <vector160>:
.globl vector160
vector160:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $160
80107010:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107015:	e9 d6 f3 ff ff       	jmp    801063f0 <alltraps>

8010701a <vector161>:
.globl vector161
vector161:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $161
8010701c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107021:	e9 ca f3 ff ff       	jmp    801063f0 <alltraps>

80107026 <vector162>:
.globl vector162
vector162:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $162
80107028:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010702d:	e9 be f3 ff ff       	jmp    801063f0 <alltraps>

80107032 <vector163>:
.globl vector163
vector163:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $163
80107034:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107039:	e9 b2 f3 ff ff       	jmp    801063f0 <alltraps>

8010703e <vector164>:
.globl vector164
vector164:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $164
80107040:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107045:	e9 a6 f3 ff ff       	jmp    801063f0 <alltraps>

8010704a <vector165>:
.globl vector165
vector165:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $165
8010704c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107051:	e9 9a f3 ff ff       	jmp    801063f0 <alltraps>

80107056 <vector166>:
.globl vector166
vector166:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $166
80107058:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010705d:	e9 8e f3 ff ff       	jmp    801063f0 <alltraps>

80107062 <vector167>:
.globl vector167
vector167:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $167
80107064:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107069:	e9 82 f3 ff ff       	jmp    801063f0 <alltraps>

8010706e <vector168>:
.globl vector168
vector168:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $168
80107070:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107075:	e9 76 f3 ff ff       	jmp    801063f0 <alltraps>

8010707a <vector169>:
.globl vector169
vector169:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $169
8010707c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107081:	e9 6a f3 ff ff       	jmp    801063f0 <alltraps>

80107086 <vector170>:
.globl vector170
vector170:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $170
80107088:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010708d:	e9 5e f3 ff ff       	jmp    801063f0 <alltraps>

80107092 <vector171>:
.globl vector171
vector171:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $171
80107094:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107099:	e9 52 f3 ff ff       	jmp    801063f0 <alltraps>

8010709e <vector172>:
.globl vector172
vector172:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $172
801070a0:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070a5:	e9 46 f3 ff ff       	jmp    801063f0 <alltraps>

801070aa <vector173>:
.globl vector173
vector173:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $173
801070ac:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070b1:	e9 3a f3 ff ff       	jmp    801063f0 <alltraps>

801070b6 <vector174>:
.globl vector174
vector174:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $174
801070b8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070bd:	e9 2e f3 ff ff       	jmp    801063f0 <alltraps>

801070c2 <vector175>:
.globl vector175
vector175:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $175
801070c4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070c9:	e9 22 f3 ff ff       	jmp    801063f0 <alltraps>

801070ce <vector176>:
.globl vector176
vector176:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $176
801070d0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070d5:	e9 16 f3 ff ff       	jmp    801063f0 <alltraps>

801070da <vector177>:
.globl vector177
vector177:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $177
801070dc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070e1:	e9 0a f3 ff ff       	jmp    801063f0 <alltraps>

801070e6 <vector178>:
.globl vector178
vector178:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $178
801070e8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070ed:	e9 fe f2 ff ff       	jmp    801063f0 <alltraps>

801070f2 <vector179>:
.globl vector179
vector179:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $179
801070f4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070f9:	e9 f2 f2 ff ff       	jmp    801063f0 <alltraps>

801070fe <vector180>:
.globl vector180
vector180:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $180
80107100:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107105:	e9 e6 f2 ff ff       	jmp    801063f0 <alltraps>

8010710a <vector181>:
.globl vector181
vector181:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $181
8010710c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107111:	e9 da f2 ff ff       	jmp    801063f0 <alltraps>

80107116 <vector182>:
.globl vector182
vector182:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $182
80107118:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010711d:	e9 ce f2 ff ff       	jmp    801063f0 <alltraps>

80107122 <vector183>:
.globl vector183
vector183:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $183
80107124:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107129:	e9 c2 f2 ff ff       	jmp    801063f0 <alltraps>

8010712e <vector184>:
.globl vector184
vector184:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $184
80107130:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107135:	e9 b6 f2 ff ff       	jmp    801063f0 <alltraps>

8010713a <vector185>:
.globl vector185
vector185:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $185
8010713c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107141:	e9 aa f2 ff ff       	jmp    801063f0 <alltraps>

80107146 <vector186>:
.globl vector186
vector186:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $186
80107148:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010714d:	e9 9e f2 ff ff       	jmp    801063f0 <alltraps>

80107152 <vector187>:
.globl vector187
vector187:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $187
80107154:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107159:	e9 92 f2 ff ff       	jmp    801063f0 <alltraps>

8010715e <vector188>:
.globl vector188
vector188:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $188
80107160:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107165:	e9 86 f2 ff ff       	jmp    801063f0 <alltraps>

8010716a <vector189>:
.globl vector189
vector189:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $189
8010716c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107171:	e9 7a f2 ff ff       	jmp    801063f0 <alltraps>

80107176 <vector190>:
.globl vector190
vector190:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $190
80107178:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010717d:	e9 6e f2 ff ff       	jmp    801063f0 <alltraps>

80107182 <vector191>:
.globl vector191
vector191:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $191
80107184:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107189:	e9 62 f2 ff ff       	jmp    801063f0 <alltraps>

8010718e <vector192>:
.globl vector192
vector192:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $192
80107190:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107195:	e9 56 f2 ff ff       	jmp    801063f0 <alltraps>

8010719a <vector193>:
.globl vector193
vector193:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $193
8010719c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071a1:	e9 4a f2 ff ff       	jmp    801063f0 <alltraps>

801071a6 <vector194>:
.globl vector194
vector194:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $194
801071a8:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071ad:	e9 3e f2 ff ff       	jmp    801063f0 <alltraps>

801071b2 <vector195>:
.globl vector195
vector195:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $195
801071b4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071b9:	e9 32 f2 ff ff       	jmp    801063f0 <alltraps>

801071be <vector196>:
.globl vector196
vector196:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $196
801071c0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071c5:	e9 26 f2 ff ff       	jmp    801063f0 <alltraps>

801071ca <vector197>:
.globl vector197
vector197:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $197
801071cc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071d1:	e9 1a f2 ff ff       	jmp    801063f0 <alltraps>

801071d6 <vector198>:
.globl vector198
vector198:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $198
801071d8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071dd:	e9 0e f2 ff ff       	jmp    801063f0 <alltraps>

801071e2 <vector199>:
.globl vector199
vector199:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $199
801071e4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071e9:	e9 02 f2 ff ff       	jmp    801063f0 <alltraps>

801071ee <vector200>:
.globl vector200
vector200:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $200
801071f0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071f5:	e9 f6 f1 ff ff       	jmp    801063f0 <alltraps>

801071fa <vector201>:
.globl vector201
vector201:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $201
801071fc:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107201:	e9 ea f1 ff ff       	jmp    801063f0 <alltraps>

80107206 <vector202>:
.globl vector202
vector202:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $202
80107208:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010720d:	e9 de f1 ff ff       	jmp    801063f0 <alltraps>

80107212 <vector203>:
.globl vector203
vector203:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $203
80107214:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107219:	e9 d2 f1 ff ff       	jmp    801063f0 <alltraps>

8010721e <vector204>:
.globl vector204
vector204:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $204
80107220:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107225:	e9 c6 f1 ff ff       	jmp    801063f0 <alltraps>

8010722a <vector205>:
.globl vector205
vector205:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $205
8010722c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107231:	e9 ba f1 ff ff       	jmp    801063f0 <alltraps>

80107236 <vector206>:
.globl vector206
vector206:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $206
80107238:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010723d:	e9 ae f1 ff ff       	jmp    801063f0 <alltraps>

80107242 <vector207>:
.globl vector207
vector207:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $207
80107244:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107249:	e9 a2 f1 ff ff       	jmp    801063f0 <alltraps>

8010724e <vector208>:
.globl vector208
vector208:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $208
80107250:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107255:	e9 96 f1 ff ff       	jmp    801063f0 <alltraps>

8010725a <vector209>:
.globl vector209
vector209:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $209
8010725c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107261:	e9 8a f1 ff ff       	jmp    801063f0 <alltraps>

80107266 <vector210>:
.globl vector210
vector210:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $210
80107268:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010726d:	e9 7e f1 ff ff       	jmp    801063f0 <alltraps>

80107272 <vector211>:
.globl vector211
vector211:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $211
80107274:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107279:	e9 72 f1 ff ff       	jmp    801063f0 <alltraps>

8010727e <vector212>:
.globl vector212
vector212:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $212
80107280:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107285:	e9 66 f1 ff ff       	jmp    801063f0 <alltraps>

8010728a <vector213>:
.globl vector213
vector213:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $213
8010728c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107291:	e9 5a f1 ff ff       	jmp    801063f0 <alltraps>

80107296 <vector214>:
.globl vector214
vector214:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $214
80107298:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010729d:	e9 4e f1 ff ff       	jmp    801063f0 <alltraps>

801072a2 <vector215>:
.globl vector215
vector215:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $215
801072a4:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072a9:	e9 42 f1 ff ff       	jmp    801063f0 <alltraps>

801072ae <vector216>:
.globl vector216
vector216:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $216
801072b0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072b5:	e9 36 f1 ff ff       	jmp    801063f0 <alltraps>

801072ba <vector217>:
.globl vector217
vector217:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $217
801072bc:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072c1:	e9 2a f1 ff ff       	jmp    801063f0 <alltraps>

801072c6 <vector218>:
.globl vector218
vector218:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $218
801072c8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072cd:	e9 1e f1 ff ff       	jmp    801063f0 <alltraps>

801072d2 <vector219>:
.globl vector219
vector219:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $219
801072d4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072d9:	e9 12 f1 ff ff       	jmp    801063f0 <alltraps>

801072de <vector220>:
.globl vector220
vector220:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $220
801072e0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072e5:	e9 06 f1 ff ff       	jmp    801063f0 <alltraps>

801072ea <vector221>:
.globl vector221
vector221:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $221
801072ec:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072f1:	e9 fa f0 ff ff       	jmp    801063f0 <alltraps>

801072f6 <vector222>:
.globl vector222
vector222:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $222
801072f8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072fd:	e9 ee f0 ff ff       	jmp    801063f0 <alltraps>

80107302 <vector223>:
.globl vector223
vector223:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $223
80107304:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107309:	e9 e2 f0 ff ff       	jmp    801063f0 <alltraps>

8010730e <vector224>:
.globl vector224
vector224:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $224
80107310:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107315:	e9 d6 f0 ff ff       	jmp    801063f0 <alltraps>

8010731a <vector225>:
.globl vector225
vector225:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $225
8010731c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107321:	e9 ca f0 ff ff       	jmp    801063f0 <alltraps>

80107326 <vector226>:
.globl vector226
vector226:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $226
80107328:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010732d:	e9 be f0 ff ff       	jmp    801063f0 <alltraps>

80107332 <vector227>:
.globl vector227
vector227:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $227
80107334:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107339:	e9 b2 f0 ff ff       	jmp    801063f0 <alltraps>

8010733e <vector228>:
.globl vector228
vector228:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $228
80107340:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107345:	e9 a6 f0 ff ff       	jmp    801063f0 <alltraps>

8010734a <vector229>:
.globl vector229
vector229:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $229
8010734c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107351:	e9 9a f0 ff ff       	jmp    801063f0 <alltraps>

80107356 <vector230>:
.globl vector230
vector230:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $230
80107358:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010735d:	e9 8e f0 ff ff       	jmp    801063f0 <alltraps>

80107362 <vector231>:
.globl vector231
vector231:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $231
80107364:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107369:	e9 82 f0 ff ff       	jmp    801063f0 <alltraps>

8010736e <vector232>:
.globl vector232
vector232:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $232
80107370:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107375:	e9 76 f0 ff ff       	jmp    801063f0 <alltraps>

8010737a <vector233>:
.globl vector233
vector233:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $233
8010737c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107381:	e9 6a f0 ff ff       	jmp    801063f0 <alltraps>

80107386 <vector234>:
.globl vector234
vector234:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $234
80107388:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010738d:	e9 5e f0 ff ff       	jmp    801063f0 <alltraps>

80107392 <vector235>:
.globl vector235
vector235:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $235
80107394:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107399:	e9 52 f0 ff ff       	jmp    801063f0 <alltraps>

8010739e <vector236>:
.globl vector236
vector236:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $236
801073a0:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073a5:	e9 46 f0 ff ff       	jmp    801063f0 <alltraps>

801073aa <vector237>:
.globl vector237
vector237:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $237
801073ac:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073b1:	e9 3a f0 ff ff       	jmp    801063f0 <alltraps>

801073b6 <vector238>:
.globl vector238
vector238:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $238
801073b8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073bd:	e9 2e f0 ff ff       	jmp    801063f0 <alltraps>

801073c2 <vector239>:
.globl vector239
vector239:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $239
801073c4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073c9:	e9 22 f0 ff ff       	jmp    801063f0 <alltraps>

801073ce <vector240>:
.globl vector240
vector240:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $240
801073d0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073d5:	e9 16 f0 ff ff       	jmp    801063f0 <alltraps>

801073da <vector241>:
.globl vector241
vector241:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $241
801073dc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073e1:	e9 0a f0 ff ff       	jmp    801063f0 <alltraps>

801073e6 <vector242>:
.globl vector242
vector242:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $242
801073e8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073ed:	e9 fe ef ff ff       	jmp    801063f0 <alltraps>

801073f2 <vector243>:
.globl vector243
vector243:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $243
801073f4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073f9:	e9 f2 ef ff ff       	jmp    801063f0 <alltraps>

801073fe <vector244>:
.globl vector244
vector244:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $244
80107400:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107405:	e9 e6 ef ff ff       	jmp    801063f0 <alltraps>

8010740a <vector245>:
.globl vector245
vector245:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $245
8010740c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107411:	e9 da ef ff ff       	jmp    801063f0 <alltraps>

80107416 <vector246>:
.globl vector246
vector246:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $246
80107418:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010741d:	e9 ce ef ff ff       	jmp    801063f0 <alltraps>

80107422 <vector247>:
.globl vector247
vector247:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $247
80107424:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107429:	e9 c2 ef ff ff       	jmp    801063f0 <alltraps>

8010742e <vector248>:
.globl vector248
vector248:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $248
80107430:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107435:	e9 b6 ef ff ff       	jmp    801063f0 <alltraps>

8010743a <vector249>:
.globl vector249
vector249:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $249
8010743c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107441:	e9 aa ef ff ff       	jmp    801063f0 <alltraps>

80107446 <vector250>:
.globl vector250
vector250:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $250
80107448:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010744d:	e9 9e ef ff ff       	jmp    801063f0 <alltraps>

80107452 <vector251>:
.globl vector251
vector251:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $251
80107454:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107459:	e9 92 ef ff ff       	jmp    801063f0 <alltraps>

8010745e <vector252>:
.globl vector252
vector252:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $252
80107460:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107465:	e9 86 ef ff ff       	jmp    801063f0 <alltraps>

8010746a <vector253>:
.globl vector253
vector253:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $253
8010746c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107471:	e9 7a ef ff ff       	jmp    801063f0 <alltraps>

80107476 <vector254>:
.globl vector254
vector254:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $254
80107478:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010747d:	e9 6e ef ff ff       	jmp    801063f0 <alltraps>

80107482 <vector255>:
.globl vector255
vector255:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $255
80107484:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107489:	e9 62 ef ff ff       	jmp    801063f0 <alltraps>
	...

80107490 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107496:	8b 45 0c             	mov    0xc(%ebp),%eax
80107499:	48                   	dec    %eax
8010749a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010749e:	8b 45 08             	mov    0x8(%ebp),%eax
801074a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801074a5:	8b 45 08             	mov    0x8(%ebp),%eax
801074a8:	c1 e8 10             	shr    $0x10,%eax
801074ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801074af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801074b2:	0f 01 10             	lgdtl  (%eax)
}
801074b5:	c9                   	leave  
801074b6:	c3                   	ret    

801074b7 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801074b7:	55                   	push   %ebp
801074b8:	89 e5                	mov    %esp,%ebp
801074ba:	83 ec 04             	sub    $0x4,%esp
801074bd:	8b 45 08             	mov    0x8(%ebp),%eax
801074c0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801074c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074c7:	0f 00 d8             	ltr    %ax
}
801074ca:	c9                   	leave  
801074cb:	c3                   	ret    

801074cc <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
801074cc:	55                   	push   %ebp
801074cd:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074cf:	8b 45 08             	mov    0x8(%ebp),%eax
801074d2:	0f 22 d8             	mov    %eax,%cr3
}
801074d5:	5d                   	pop    %ebp
801074d6:	c3                   	ret    

801074d7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801074d7:	55                   	push   %ebp
801074d8:	89 e5                	mov    %esp,%ebp
801074da:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801074dd:	e8 70 cc ff ff       	call   80104152 <cpuid>
801074e2:	89 c2                	mov    %eax,%edx
801074e4:	89 d0                	mov    %edx,%eax
801074e6:	c1 e0 02             	shl    $0x2,%eax
801074e9:	01 d0                	add    %edx,%eax
801074eb:	01 c0                	add    %eax,%eax
801074ed:	01 d0                	add    %edx,%eax
801074ef:	c1 e0 04             	shl    $0x4,%eax
801074f2:	05 40 3a 11 80       	add    $0x80113a40,%eax
801074f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801074fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fd:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107506:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010750c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750f:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107516:	8a 50 7d             	mov    0x7d(%eax),%dl
80107519:	83 e2 f0             	and    $0xfffffff0,%edx
8010751c:	83 ca 0a             	or     $0xa,%edx
8010751f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107525:	8a 50 7d             	mov    0x7d(%eax),%dl
80107528:	83 ca 10             	or     $0x10,%edx
8010752b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010752e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107531:	8a 50 7d             	mov    0x7d(%eax),%dl
80107534:	83 e2 9f             	and    $0xffffff9f,%edx
80107537:	88 50 7d             	mov    %dl,0x7d(%eax)
8010753a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753d:	8a 50 7d             	mov    0x7d(%eax),%dl
80107540:	83 ca 80             	or     $0xffffff80,%edx
80107543:	88 50 7d             	mov    %dl,0x7d(%eax)
80107546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107549:	8a 50 7e             	mov    0x7e(%eax),%dl
8010754c:	83 ca 0f             	or     $0xf,%edx
8010754f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107552:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107555:	8a 50 7e             	mov    0x7e(%eax),%dl
80107558:	83 e2 ef             	and    $0xffffffef,%edx
8010755b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010755e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107561:	8a 50 7e             	mov    0x7e(%eax),%dl
80107564:	83 e2 df             	and    $0xffffffdf,%edx
80107567:	88 50 7e             	mov    %dl,0x7e(%eax)
8010756a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107570:	83 ca 40             	or     $0x40,%edx
80107573:	88 50 7e             	mov    %dl,0x7e(%eax)
80107576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107579:	8a 50 7e             	mov    0x7e(%eax),%dl
8010757c:	83 ca 80             	or     $0xffffff80,%edx
8010757f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107585:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107593:	ff ff 
80107595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107598:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010759f:	00 00 
801075a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801075ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ae:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801075b4:	83 e2 f0             	and    $0xfffffff0,%edx
801075b7:	83 ca 02             	or     $0x2,%edx
801075ba:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c3:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801075c9:	83 ca 10             	or     $0x10,%edx
801075cc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d5:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801075db:	83 e2 9f             	and    $0xffffff9f,%edx
801075de:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e7:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801075ed:	83 ca 80             	or     $0xffffff80,%edx
801075f0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f9:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075ff:	83 ca 0f             	or     $0xf,%edx
80107602:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760b:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107611:	83 e2 ef             	and    $0xffffffef,%edx
80107614:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010761a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761d:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107623:	83 e2 df             	and    $0xffffffdf,%edx
80107626:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010762c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762f:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107635:	83 ca 40             	or     $0x40,%edx
80107638:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010763e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107641:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107647:	83 ca 80             	or     $0xffffff80,%edx
8010764a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107653:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010765a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765d:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107664:	ff ff 
80107666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107669:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107670:	00 00 
80107672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107675:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010767c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767f:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107685:	83 e2 f0             	and    $0xfffffff0,%edx
80107688:	83 ca 0a             	or     $0xa,%edx
8010768b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107694:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010769a:	83 ca 10             	or     $0x10,%edx
8010769d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801076a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a6:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801076ac:	83 ca 60             	or     $0x60,%edx
801076af:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801076b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b8:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801076be:	83 ca 80             	or     $0xffffff80,%edx
801076c1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801076c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ca:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801076d0:	83 ca 0f             	or     $0xf,%edx
801076d3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076dc:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801076e2:	83 e2 ef             	and    $0xffffffef,%edx
801076e5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801076f4:	83 e2 df             	and    $0xffffffdf,%edx
801076f7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107700:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107706:	83 ca 40             	or     $0x40,%edx
80107709:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010770f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107712:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107718:	83 ca 80             	or     $0xffffff80,%edx
8010771b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107724:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010772b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107735:	ff ff 
80107737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107741:	00 00 
80107743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107746:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010774d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107750:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107756:	83 e2 f0             	and    $0xfffffff0,%edx
80107759:	83 ca 02             	or     $0x2,%edx
8010775c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010776b:	83 ca 10             	or     $0x10,%edx
8010776e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107777:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010777d:	83 ca 60             	or     $0x60,%edx
80107780:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107789:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010778f:	83 ca 80             	or     $0xffffff80,%edx
80107792:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801077a1:	83 ca 0f             	or     $0xf,%edx
801077a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ad:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801077b3:	83 e2 ef             	and    $0xffffffef,%edx
801077b6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bf:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801077c5:	83 e2 df             	and    $0xffffffdf,%edx
801077c8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801077d7:	83 ca 40             	or     $0x40,%edx
801077da:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801077e9:	83 ca 80             	or     $0xffffff80,%edx
801077ec:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801077fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ff:	83 c0 70             	add    $0x70,%eax
80107802:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107809:	00 
8010780a:	89 04 24             	mov    %eax,(%esp)
8010780d:	e8 7e fc ff ff       	call   80107490 <lgdt>
}
80107812:	c9                   	leave  
80107813:	c3                   	ret    

80107814 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107814:	55                   	push   %ebp
80107815:	89 e5                	mov    %esp,%ebp
80107817:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010781a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010781d:	c1 e8 16             	shr    $0x16,%eax
80107820:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107827:	8b 45 08             	mov    0x8(%ebp),%eax
8010782a:	01 d0                	add    %edx,%eax
8010782c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010782f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107832:	8b 00                	mov    (%eax),%eax
80107834:	83 e0 01             	and    $0x1,%eax
80107837:	85 c0                	test   %eax,%eax
80107839:	74 14                	je     8010784f <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010783b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010783e:	8b 00                	mov    (%eax),%eax
80107840:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107845:	05 00 00 00 80       	add    $0x80000000,%eax
8010784a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010784d:	eb 48                	jmp    80107897 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010784f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107853:	74 0e                	je     80107863 <walkpgdir+0x4f>
80107855:	e8 01 b4 ff ff       	call   80102c5b <kalloc>
8010785a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010785d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107861:	75 07                	jne    8010786a <walkpgdir+0x56>
      return 0;
80107863:	b8 00 00 00 00       	mov    $0x0,%eax
80107868:	eb 44                	jmp    801078ae <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010786a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107871:	00 
80107872:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107879:	00 
8010787a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787d:	89 04 24             	mov    %eax,(%esp)
80107880:	e8 09 d8 ff ff       	call   8010508e <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107888:	05 00 00 00 80       	add    $0x80000000,%eax
8010788d:	83 c8 07             	or     $0x7,%eax
80107890:	89 c2                	mov    %eax,%edx
80107892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107895:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107897:	8b 45 0c             	mov    0xc(%ebp),%eax
8010789a:	c1 e8 0c             	shr    $0xc,%eax
8010789d:	25 ff 03 00 00       	and    $0x3ff,%eax
801078a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801078a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ac:	01 d0                	add    %edx,%eax
}
801078ae:	c9                   	leave  
801078af:	c3                   	ret    

801078b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801078b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801078b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801078c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801078c4:	8b 45 10             	mov    0x10(%ebp),%eax
801078c7:	01 d0                	add    %edx,%eax
801078c9:	48                   	dec    %eax
801078ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801078d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801078d9:	00 
801078da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801078e1:	8b 45 08             	mov    0x8(%ebp),%eax
801078e4:	89 04 24             	mov    %eax,(%esp)
801078e7:	e8 28 ff ff ff       	call   80107814 <walkpgdir>
801078ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078f3:	75 07                	jne    801078fc <mappages+0x4c>
      return -1;
801078f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078fa:	eb 48                	jmp    80107944 <mappages+0x94>
    if(*pte & PTE_P)
801078fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078ff:	8b 00                	mov    (%eax),%eax
80107901:	83 e0 01             	and    $0x1,%eax
80107904:	85 c0                	test   %eax,%eax
80107906:	74 0c                	je     80107914 <mappages+0x64>
      panic("remap");
80107908:	c7 04 24 24 88 10 80 	movl   $0x80108824,(%esp)
8010790f:	e8 40 8c ff ff       	call   80100554 <panic>
    *pte = pa | perm | PTE_P;
80107914:	8b 45 18             	mov    0x18(%ebp),%eax
80107917:	0b 45 14             	or     0x14(%ebp),%eax
8010791a:	83 c8 01             	or     $0x1,%eax
8010791d:	89 c2                	mov    %eax,%edx
8010791f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107922:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107927:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010792a:	75 08                	jne    80107934 <mappages+0x84>
      break;
8010792c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010792d:	b8 00 00 00 00       	mov    $0x0,%eax
80107932:	eb 10                	jmp    80107944 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107934:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010793b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107942:	eb 8e                	jmp    801078d2 <mappages+0x22>
  return 0;
}
80107944:	c9                   	leave  
80107945:	c3                   	ret    

80107946 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107946:	55                   	push   %ebp
80107947:	89 e5                	mov    %esp,%ebp
80107949:	53                   	push   %ebx
8010794a:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010794d:	e8 09 b3 ff ff       	call   80102c5b <kalloc>
80107952:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107955:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107959:	75 0a                	jne    80107965 <setupkvm+0x1f>
    return 0;
8010795b:	b8 00 00 00 00       	mov    $0x0,%eax
80107960:	e9 84 00 00 00       	jmp    801079e9 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107965:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010796c:	00 
8010796d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107974:	00 
80107975:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107978:	89 04 24             	mov    %eax,(%esp)
8010797b:	e8 0e d7 ff ff       	call   8010508e <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107980:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107987:	eb 54                	jmp    801079dd <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798c:	8b 48 0c             	mov    0xc(%eax),%ecx
8010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107992:	8b 50 04             	mov    0x4(%eax),%edx
80107995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107998:	8b 58 08             	mov    0x8(%eax),%ebx
8010799b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799e:	8b 40 04             	mov    0x4(%eax),%eax
801079a1:	29 c3                	sub    %eax,%ebx
801079a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a6:	8b 00                	mov    (%eax),%eax
801079a8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801079ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
801079b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801079b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801079b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079bb:	89 04 24             	mov    %eax,(%esp)
801079be:	e8 ed fe ff ff       	call   801078b0 <mappages>
801079c3:	85 c0                	test   %eax,%eax
801079c5:	79 12                	jns    801079d9 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801079c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ca:	89 04 24             	mov    %eax,(%esp)
801079cd:	e8 1a 05 00 00       	call   80107eec <freevm>
      return 0;
801079d2:	b8 00 00 00 00       	mov    $0x0,%eax
801079d7:	eb 10                	jmp    801079e9 <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079d9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801079dd:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
801079e4:	72 a3                	jb     80107989 <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
801079e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801079e9:	83 c4 34             	add    $0x34,%esp
801079ec:	5b                   	pop    %ebx
801079ed:	5d                   	pop    %ebp
801079ee:	c3                   	ret    

801079ef <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801079ef:	55                   	push   %ebp
801079f0:	89 e5                	mov    %esp,%ebp
801079f2:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801079f5:	e8 4c ff ff ff       	call   80107946 <setupkvm>
801079fa:	a3 64 67 11 80       	mov    %eax,0x80116764
  switchkvm();
801079ff:	e8 02 00 00 00       	call   80107a06 <switchkvm>
}
80107a04:	c9                   	leave  
80107a05:	c3                   	ret    

80107a06 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107a06:	55                   	push   %ebp
80107a07:	89 e5                	mov    %esp,%ebp
80107a09:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a0c:	a1 64 67 11 80       	mov    0x80116764,%eax
80107a11:	05 00 00 00 80       	add    $0x80000000,%eax
80107a16:	89 04 24             	mov    %eax,(%esp)
80107a19:	e8 ae fa ff ff       	call   801074cc <lcr3>
}
80107a1e:	c9                   	leave  
80107a1f:	c3                   	ret    

80107a20 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107a29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107a2d:	75 0c                	jne    80107a3b <switchuvm+0x1b>
    panic("switchuvm: no process");
80107a2f:	c7 04 24 2a 88 10 80 	movl   $0x8010882a,(%esp)
80107a36:	e8 19 8b ff ff       	call   80100554 <panic>
  if(p->kstack == 0)
80107a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a3e:	8b 40 08             	mov    0x8(%eax),%eax
80107a41:	85 c0                	test   %eax,%eax
80107a43:	75 0c                	jne    80107a51 <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107a45:	c7 04 24 40 88 10 80 	movl   $0x80108840,(%esp)
80107a4c:	e8 03 8b ff ff       	call   80100554 <panic>
  if(p->pgdir == 0)
80107a51:	8b 45 08             	mov    0x8(%ebp),%eax
80107a54:	8b 40 04             	mov    0x4(%eax),%eax
80107a57:	85 c0                	test   %eax,%eax
80107a59:	75 0c                	jne    80107a67 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107a5b:	c7 04 24 55 88 10 80 	movl   $0x80108855,(%esp)
80107a62:	e8 ed 8a ff ff       	call   80100554 <panic>

  pushcli();
80107a67:	e8 1e d5 ff ff       	call   80104f8a <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a6c:	e8 26 c7 ff ff       	call   80104197 <mycpu>
80107a71:	89 c3                	mov    %eax,%ebx
80107a73:	e8 1f c7 ff ff       	call   80104197 <mycpu>
80107a78:	83 c0 08             	add    $0x8,%eax
80107a7b:	89 c6                	mov    %eax,%esi
80107a7d:	e8 15 c7 ff ff       	call   80104197 <mycpu>
80107a82:	83 c0 08             	add    $0x8,%eax
80107a85:	c1 e8 10             	shr    $0x10,%eax
80107a88:	89 c7                	mov    %eax,%edi
80107a8a:	e8 08 c7 ff ff       	call   80104197 <mycpu>
80107a8f:	83 c0 08             	add    $0x8,%eax
80107a92:	c1 e8 18             	shr    $0x18,%eax
80107a95:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107a9c:	67 00 
80107a9e:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107aa5:	89 f9                	mov    %edi,%ecx
80107aa7:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107aad:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107ab3:	83 e2 f0             	and    $0xfffffff0,%edx
80107ab6:	83 ca 09             	or     $0x9,%edx
80107ab9:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107abf:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107ac5:	83 ca 10             	or     $0x10,%edx
80107ac8:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107ace:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107ad4:	83 e2 9f             	and    $0xffffff9f,%edx
80107ad7:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107add:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107ae3:	83 ca 80             	or     $0xffffff80,%edx
80107ae6:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107aec:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107af2:	83 e2 f0             	and    $0xfffffff0,%edx
80107af5:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107afb:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107b01:	83 e2 ef             	and    $0xffffffef,%edx
80107b04:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107b0a:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107b10:	83 e2 df             	and    $0xffffffdf,%edx
80107b13:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107b19:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107b1f:	83 ca 40             	or     $0x40,%edx
80107b22:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107b28:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107b2e:	83 e2 7f             	and    $0x7f,%edx
80107b31:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107b37:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107b3d:	e8 55 c6 ff ff       	call   80104197 <mycpu>
80107b42:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107b48:	83 e2 ef             	and    $0xffffffef,%edx
80107b4b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b51:	e8 41 c6 ff ff       	call   80104197 <mycpu>
80107b56:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107b5c:	e8 36 c6 ff ff       	call   80104197 <mycpu>
80107b61:	8b 55 08             	mov    0x8(%ebp),%edx
80107b64:	8b 52 08             	mov    0x8(%edx),%edx
80107b67:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107b6d:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b70:	e8 22 c6 ff ff       	call   80104197 <mycpu>
80107b75:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107b7b:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107b82:	e8 30 f9 ff ff       	call   801074b7 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107b87:	8b 45 08             	mov    0x8(%ebp),%eax
80107b8a:	8b 40 04             	mov    0x4(%eax),%eax
80107b8d:	05 00 00 00 80       	add    $0x80000000,%eax
80107b92:	89 04 24             	mov    %eax,(%esp)
80107b95:	e8 32 f9 ff ff       	call   801074cc <lcr3>
  popcli();
80107b9a:	e8 35 d4 ff ff       	call   80104fd4 <popcli>
}
80107b9f:	83 c4 1c             	add    $0x1c,%esp
80107ba2:	5b                   	pop    %ebx
80107ba3:	5e                   	pop    %esi
80107ba4:	5f                   	pop    %edi
80107ba5:	5d                   	pop    %ebp
80107ba6:	c3                   	ret    

80107ba7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ba7:	55                   	push   %ebp
80107ba8:	89 e5                	mov    %esp,%ebp
80107baa:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107bad:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107bb4:	76 0c                	jbe    80107bc2 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107bb6:	c7 04 24 69 88 10 80 	movl   $0x80108869,(%esp)
80107bbd:	e8 92 89 ff ff       	call   80100554 <panic>
  mem = kalloc();
80107bc2:	e8 94 b0 ff ff       	call   80102c5b <kalloc>
80107bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107bca:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bd1:	00 
80107bd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107bd9:	00 
80107bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdd:	89 04 24             	mov    %eax,(%esp)
80107be0:	e8 a9 d4 ff ff       	call   8010508e <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be8:	05 00 00 00 80       	add    $0x80000000,%eax
80107bed:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107bf4:	00 
80107bf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107bf9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c00:	00 
80107c01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c08:	00 
80107c09:	8b 45 08             	mov    0x8(%ebp),%eax
80107c0c:	89 04 24             	mov    %eax,(%esp)
80107c0f:	e8 9c fc ff ff       	call   801078b0 <mappages>
  memmove(mem, init, sz);
80107c14:	8b 45 10             	mov    0x10(%ebp),%eax
80107c17:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c25:	89 04 24             	mov    %eax,(%esp)
80107c28:	e8 2a d5 ff ff       	call   80105157 <memmove>
}
80107c2d:	c9                   	leave  
80107c2e:	c3                   	ret    

80107c2f <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c2f:	55                   	push   %ebp
80107c30:	89 e5                	mov    %esp,%ebp
80107c32:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c35:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c38:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c3d:	85 c0                	test   %eax,%eax
80107c3f:	74 0c                	je     80107c4d <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107c41:	c7 04 24 84 88 10 80 	movl   $0x80108884,(%esp)
80107c48:	e8 07 89 ff ff       	call   80100554 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c54:	e9 a6 00 00 00       	jmp    80107cff <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c5f:	01 d0                	add    %edx,%eax
80107c61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107c68:	00 
80107c69:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107c70:	89 04 24             	mov    %eax,(%esp)
80107c73:	e8 9c fb ff ff       	call   80107814 <walkpgdir>
80107c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c7f:	75 0c                	jne    80107c8d <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107c81:	c7 04 24 a7 88 10 80 	movl   $0x801088a7,(%esp)
80107c88:	e8 c7 88 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80107c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c90:	8b 00                	mov    (%eax),%eax
80107c92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c97:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9d:	8b 55 18             	mov    0x18(%ebp),%edx
80107ca0:	29 c2                	sub    %eax,%edx
80107ca2:	89 d0                	mov    %edx,%eax
80107ca4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107ca9:	77 0f                	ja     80107cba <loaduvm+0x8b>
      n = sz - i;
80107cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cae:	8b 55 18             	mov    0x18(%ebp),%edx
80107cb1:	29 c2                	sub    %eax,%edx
80107cb3:	89 d0                	mov    %edx,%eax
80107cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cb8:	eb 07                	jmp    80107cc1 <loaduvm+0x92>
    else
      n = PGSIZE;
80107cba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc4:	8b 55 14             	mov    0x14(%ebp),%edx
80107cc7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ccd:	05 00 00 00 80       	add    $0x80000000,%eax
80107cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107cd5:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107cd9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ce1:	8b 45 10             	mov    0x10(%ebp),%eax
80107ce4:	89 04 24             	mov    %eax,(%esp)
80107ce7:	e8 d5 a1 ff ff       	call   80101ec1 <readi>
80107cec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107cef:	74 07                	je     80107cf8 <loaduvm+0xc9>
      return -1;
80107cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cf6:	eb 18                	jmp    80107d10 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107cf8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d02:	3b 45 18             	cmp    0x18(%ebp),%eax
80107d05:	0f 82 4e ff ff ff    	jb     80107c59 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d10:	c9                   	leave  
80107d11:	c3                   	ret    

80107d12 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d12:	55                   	push   %ebp
80107d13:	89 e5                	mov    %esp,%ebp
80107d15:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107d18:	8b 45 10             	mov    0x10(%ebp),%eax
80107d1b:	85 c0                	test   %eax,%eax
80107d1d:	79 0a                	jns    80107d29 <allocuvm+0x17>
    return 0;
80107d1f:	b8 00 00 00 00       	mov    $0x0,%eax
80107d24:	e9 fd 00 00 00       	jmp    80107e26 <allocuvm+0x114>
  if(newsz < oldsz)
80107d29:	8b 45 10             	mov    0x10(%ebp),%eax
80107d2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d2f:	73 08                	jae    80107d39 <allocuvm+0x27>
    return oldsz;
80107d31:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d34:	e9 ed 00 00 00       	jmp    80107e26 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80107d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d3c:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107d49:	e9 c9 00 00 00       	jmp    80107e17 <allocuvm+0x105>
    mem = kalloc();
80107d4e:	e8 08 af ff ff       	call   80102c5b <kalloc>
80107d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d5a:	75 2f                	jne    80107d8b <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80107d5c:	c7 04 24 c5 88 10 80 	movl   $0x801088c5,(%esp)
80107d63:	e8 59 86 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107d68:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d6f:	8b 45 10             	mov    0x10(%ebp),%eax
80107d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d76:	8b 45 08             	mov    0x8(%ebp),%eax
80107d79:	89 04 24             	mov    %eax,(%esp)
80107d7c:	e8 a7 00 00 00       	call   80107e28 <deallocuvm>
      return 0;
80107d81:	b8 00 00 00 00       	mov    $0x0,%eax
80107d86:	e9 9b 00 00 00       	jmp    80107e26 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
80107d8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d92:	00 
80107d93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d9a:	00 
80107d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9e:	89 04 24             	mov    %eax,(%esp)
80107da1:	e8 e8 d2 ff ff       	call   8010508e <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db2:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107db9:	00 
80107dba:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107dbe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107dc5:	00 
80107dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dca:	8b 45 08             	mov    0x8(%ebp),%eax
80107dcd:	89 04 24             	mov    %eax,(%esp)
80107dd0:	e8 db fa ff ff       	call   801078b0 <mappages>
80107dd5:	85 c0                	test   %eax,%eax
80107dd7:	79 37                	jns    80107e10 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80107dd9:	c7 04 24 dd 88 10 80 	movl   $0x801088dd,(%esp)
80107de0:	e8 dc 85 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107de5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107de8:	89 44 24 08          	mov    %eax,0x8(%esp)
80107dec:	8b 45 10             	mov    0x10(%ebp),%eax
80107def:	89 44 24 04          	mov    %eax,0x4(%esp)
80107df3:	8b 45 08             	mov    0x8(%ebp),%eax
80107df6:	89 04 24             	mov    %eax,(%esp)
80107df9:	e8 2a 00 00 00       	call   80107e28 <deallocuvm>
      kfree(mem);
80107dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e01:	89 04 24             	mov    %eax,(%esp)
80107e04:	e8 bc ad ff ff       	call   80102bc5 <kfree>
      return 0;
80107e09:	b8 00 00 00 00       	mov    $0x0,%eax
80107e0e:	eb 16                	jmp    80107e26 <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107e10:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1a:	3b 45 10             	cmp    0x10(%ebp),%eax
80107e1d:	0f 82 2b ff ff ff    	jb     80107d4e <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80107e23:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e26:	c9                   	leave  
80107e27:	c3                   	ret    

80107e28 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e28:	55                   	push   %ebp
80107e29:	89 e5                	mov    %esp,%ebp
80107e2b:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e2e:	8b 45 10             	mov    0x10(%ebp),%eax
80107e31:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e34:	72 08                	jb     80107e3e <deallocuvm+0x16>
    return oldsz;
80107e36:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e39:	e9 ac 00 00 00       	jmp    80107eea <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107e3e:	8b 45 10             	mov    0x10(%ebp),%eax
80107e41:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e4e:	e9 88 00 00 00       	jmp    80107edb <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e56:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e5d:	00 
80107e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e62:	8b 45 08             	mov    0x8(%ebp),%eax
80107e65:	89 04 24             	mov    %eax,(%esp)
80107e68:	e8 a7 f9 ff ff       	call   80107814 <walkpgdir>
80107e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e74:	75 14                	jne    80107e8a <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e79:	c1 e8 16             	shr    $0x16,%eax
80107e7c:	40                   	inc    %eax
80107e7d:	c1 e0 16             	shl    $0x16,%eax
80107e80:	2d 00 10 00 00       	sub    $0x1000,%eax
80107e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e88:	eb 4a                	jmp    80107ed4 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e8d:	8b 00                	mov    (%eax),%eax
80107e8f:	83 e0 01             	and    $0x1,%eax
80107e92:	85 c0                	test   %eax,%eax
80107e94:	74 3e                	je     80107ed4 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e99:	8b 00                	mov    (%eax),%eax
80107e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ea3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ea7:	75 0c                	jne    80107eb5 <deallocuvm+0x8d>
        panic("kfree");
80107ea9:	c7 04 24 f9 88 10 80 	movl   $0x801088f9,(%esp)
80107eb0:	e8 9f 86 ff ff       	call   80100554 <panic>
      char *v = P2V(pa);
80107eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eb8:	05 00 00 00 80       	add    $0x80000000,%eax
80107ebd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ec3:	89 04 24             	mov    %eax,(%esp)
80107ec6:	e8 fa ac ff ff       	call   80102bc5 <kfree>
      *pte = 0;
80107ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107ed4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ede:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ee1:	0f 82 6c ff ff ff    	jb     80107e53 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107ee7:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107eea:	c9                   	leave  
80107eeb:	c3                   	ret    

80107eec <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107eec:	55                   	push   %ebp
80107eed:	89 e5                	mov    %esp,%ebp
80107eef:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107ef2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ef6:	75 0c                	jne    80107f04 <freevm+0x18>
    panic("freevm: no pgdir");
80107ef8:	c7 04 24 ff 88 10 80 	movl   $0x801088ff,(%esp)
80107eff:	e8 50 86 ff ff       	call   80100554 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107f04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f0b:	00 
80107f0c:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107f13:	80 
80107f14:	8b 45 08             	mov    0x8(%ebp),%eax
80107f17:	89 04 24             	mov    %eax,(%esp)
80107f1a:	e8 09 ff ff ff       	call   80107e28 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107f1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f26:	eb 44                	jmp    80107f6c <freevm+0x80>
    if(pgdir[i] & PTE_P){
80107f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f32:	8b 45 08             	mov    0x8(%ebp),%eax
80107f35:	01 d0                	add    %edx,%eax
80107f37:	8b 00                	mov    (%eax),%eax
80107f39:	83 e0 01             	and    $0x1,%eax
80107f3c:	85 c0                	test   %eax,%eax
80107f3e:	74 29                	je     80107f69 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f4d:	01 d0                	add    %edx,%eax
80107f4f:	8b 00                	mov    (%eax),%eax
80107f51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f56:	05 00 00 00 80       	add    $0x80000000,%eax
80107f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f61:	89 04 24             	mov    %eax,(%esp)
80107f64:	e8 5c ac ff ff       	call   80102bc5 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f69:	ff 45 f4             	incl   -0xc(%ebp)
80107f6c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107f73:	76 b3                	jbe    80107f28 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107f75:	8b 45 08             	mov    0x8(%ebp),%eax
80107f78:	89 04 24             	mov    %eax,(%esp)
80107f7b:	e8 45 ac ff ff       	call   80102bc5 <kfree>
}
80107f80:	c9                   	leave  
80107f81:	c3                   	ret    

80107f82 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f82:	55                   	push   %ebp
80107f83:	89 e5                	mov    %esp,%ebp
80107f85:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f88:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f8f:	00 
80107f90:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f93:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f97:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9a:	89 04 24             	mov    %eax,(%esp)
80107f9d:	e8 72 f8 ff ff       	call   80107814 <walkpgdir>
80107fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fa9:	75 0c                	jne    80107fb7 <clearpteu+0x35>
    panic("clearpteu");
80107fab:	c7 04 24 10 89 10 80 	movl   $0x80108910,(%esp)
80107fb2:	e8 9d 85 ff ff       	call   80100554 <panic>
  *pte &= ~PTE_U;
80107fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fba:	8b 00                	mov    (%eax),%eax
80107fbc:	83 e0 fb             	and    $0xfffffffb,%eax
80107fbf:	89 c2                	mov    %eax,%edx
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	89 10                	mov    %edx,(%eax)
}
80107fc6:	c9                   	leave  
80107fc7:	c3                   	ret    

80107fc8 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fc8:	55                   	push   %ebp
80107fc9:	89 e5                	mov    %esp,%ebp
80107fcb:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fce:	e8 73 f9 ff ff       	call   80107946 <setupkvm>
80107fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fda:	75 0a                	jne    80107fe6 <copyuvm+0x1e>
    return 0;
80107fdc:	b8 00 00 00 00       	mov    $0x0,%eax
80107fe1:	e9 f8 00 00 00       	jmp    801080de <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80107fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107fed:	e9 cb 00 00 00       	jmp    801080bd <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ffc:	00 
80107ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108001:	8b 45 08             	mov    0x8(%ebp),%eax
80108004:	89 04 24             	mov    %eax,(%esp)
80108007:	e8 08 f8 ff ff       	call   80107814 <walkpgdir>
8010800c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010800f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108013:	75 0c                	jne    80108021 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108015:	c7 04 24 1a 89 10 80 	movl   $0x8010891a,(%esp)
8010801c:	e8 33 85 ff ff       	call   80100554 <panic>
    if(!(*pte & PTE_P))
80108021:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108024:	8b 00                	mov    (%eax),%eax
80108026:	83 e0 01             	and    $0x1,%eax
80108029:	85 c0                	test   %eax,%eax
8010802b:	75 0c                	jne    80108039 <copyuvm+0x71>
      panic("copyuvm: page not present");
8010802d:	c7 04 24 34 89 10 80 	movl   $0x80108934,(%esp)
80108034:	e8 1b 85 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80108039:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010803c:	8b 00                	mov    (%eax),%eax
8010803e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108043:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108046:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108049:	8b 00                	mov    (%eax),%eax
8010804b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108050:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108053:	e8 03 ac ff ff       	call   80102c5b <kalloc>
80108058:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010805b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010805f:	75 02                	jne    80108063 <copyuvm+0x9b>
      goto bad;
80108061:	eb 6b                	jmp    801080ce <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108063:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108066:	05 00 00 00 80       	add    $0x80000000,%eax
8010806b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108072:	00 
80108073:	89 44 24 04          	mov    %eax,0x4(%esp)
80108077:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010807a:	89 04 24             	mov    %eax,(%esp)
8010807d:	e8 d5 d0 ff ff       	call   80105157 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108082:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108085:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108088:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010808e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108091:	89 54 24 10          	mov    %edx,0x10(%esp)
80108095:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108099:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080a0:	00 
801080a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801080a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080a8:	89 04 24             	mov    %eax,(%esp)
801080ab:	e8 00 f8 ff ff       	call   801078b0 <mappages>
801080b0:	85 c0                	test   %eax,%eax
801080b2:	79 02                	jns    801080b6 <copyuvm+0xee>
      goto bad;
801080b4:	eb 18                	jmp    801080ce <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801080b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080c3:	0f 82 29 ff ff ff    	jb     80107ff2 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
801080c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080cc:	eb 10                	jmp    801080de <copyuvm+0x116>

bad:
  freevm(d);
801080ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d1:	89 04 24             	mov    %eax,(%esp)
801080d4:	e8 13 fe ff ff       	call   80107eec <freevm>
  return 0;
801080d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080de:	c9                   	leave  
801080df:	c3                   	ret    

801080e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080ed:	00 
801080ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801080f5:	8b 45 08             	mov    0x8(%ebp),%eax
801080f8:	89 04 24             	mov    %eax,(%esp)
801080fb:	e8 14 f7 ff ff       	call   80107814 <walkpgdir>
80108100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108106:	8b 00                	mov    (%eax),%eax
80108108:	83 e0 01             	and    $0x1,%eax
8010810b:	85 c0                	test   %eax,%eax
8010810d:	75 07                	jne    80108116 <uva2ka+0x36>
    return 0;
8010810f:	b8 00 00 00 00       	mov    $0x0,%eax
80108114:	eb 22                	jmp    80108138 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108119:	8b 00                	mov    (%eax),%eax
8010811b:	83 e0 04             	and    $0x4,%eax
8010811e:	85 c0                	test   %eax,%eax
80108120:	75 07                	jne    80108129 <uva2ka+0x49>
    return 0;
80108122:	b8 00 00 00 00       	mov    $0x0,%eax
80108127:	eb 0f                	jmp    80108138 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812c:	8b 00                	mov    (%eax),%eax
8010812e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108133:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108138:	c9                   	leave  
80108139:	c3                   	ret    

8010813a <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010813a:	55                   	push   %ebp
8010813b:	89 e5                	mov    %esp,%ebp
8010813d:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108140:	8b 45 10             	mov    0x10(%ebp),%eax
80108143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108146:	e9 87 00 00 00       	jmp    801081d2 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010814b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010814e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108153:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108156:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108159:	89 44 24 04          	mov    %eax,0x4(%esp)
8010815d:	8b 45 08             	mov    0x8(%ebp),%eax
80108160:	89 04 24             	mov    %eax,(%esp)
80108163:	e8 78 ff ff ff       	call   801080e0 <uva2ka>
80108168:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010816b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010816f:	75 07                	jne    80108178 <copyout+0x3e>
      return -1;
80108171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108176:	eb 69                	jmp    801081e1 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010817e:	29 c2                	sub    %eax,%edx
80108180:	89 d0                	mov    %edx,%eax
80108182:	05 00 10 00 00       	add    $0x1000,%eax
80108187:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010818a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108190:	76 06                	jbe    80108198 <copyout+0x5e>
      n = len;
80108192:	8b 45 14             	mov    0x14(%ebp),%eax
80108195:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108198:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010819b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010819e:	29 c2                	sub    %eax,%edx
801081a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081a3:	01 c2                	add    %eax,%edx
801081a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801081ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081af:	89 44 24 04          	mov    %eax,0x4(%esp)
801081b3:	89 14 24             	mov    %edx,(%esp)
801081b6:	e8 9c cf ff ff       	call   80105157 <memmove>
    len -= n;
801081bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081be:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801081c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081c4:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801081c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081ca:	05 00 10 00 00       	add    $0x1000,%eax
801081cf:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081d2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801081d6:	0f 85 6f ff ff ff    	jne    8010814b <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801081dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081e1:	c9                   	leave  
801081e2:	c3                   	ret    
