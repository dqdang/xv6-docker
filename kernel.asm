
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp
8010002d:	b8 a6 37 10 80       	mov    $0x801037a6,%eax
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
8010003a:	c7 44 24 04 84 81 10 	movl   $0x80108184,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100049:	e8 5c 4d 00 00       	call   80104daa <initlock>

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
80100087:	c7 44 24 04 8b 81 10 	movl   $0x8010818b,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 d5 4b 00 00       	call   80104c6c <initsleeplock>
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
801000c9:	e8 fd 4c 00 00       	call   80104dcb <acquire>

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
80100104:	e8 2c 4d 00 00       	call   80104e35 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 8f 4b 00 00       	call   80104ca6 <acquiresleep>
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
8010017d:	e8 b3 4c 00 00       	call   80104e35 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 16 4b 00 00       	call   80104ca6 <acquiresleep>
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
801001a7:	c7 04 24 92 81 10 80 	movl   $0x80108192,(%esp)
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
801001e2:	e8 f6 26 00 00       	call   801028dd <iderw>
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
801001fb:	e8 43 4b 00 00       	call   80104d43 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 a3 81 10 80 	movl   $0x801081a3,(%esp)
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
80100225:	e8 b3 26 00 00       	call   801028dd <iderw>
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
8010023b:	e8 03 4b 00 00       	call   80104d43 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 aa 81 10 80 	movl   $0x801081aa,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 a3 4a 00 00       	call   80104d01 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100265:	e8 61 4b 00 00       	call   80104dcb <acquire>
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
801002d1:	e8 5f 4b 00 00       	call   80104e35 <release>
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
80100364:	8a 80 08 90 10 80    	mov    -0x7fef6ff8(%eax),%al
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
801003dc:	e8 ea 49 00 00       	call   80104dcb <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 b1 81 10 80 	movl   $0x801081b1,(%esp)
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
801004cf:	c7 45 ec ba 81 10 80 	movl   $0x801081ba,-0x14(%ebp)
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
8010054d:	e8 e3 48 00 00       	call   80104e35 <release>
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
80100569:	e8 0b 2a 00 00       	call   80102f79 <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 c1 81 10 80 	movl   $0x801081c1,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 d5 81 10 80 	movl   $0x801081d5,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 db 48 00 00       	call   80104e82 <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 d7 81 10 80 	movl   $0x801081d7,(%esp)
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
80100666:	8b 0d 04 90 10 80    	mov    0x80109004,%ecx
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
80100695:	c7 04 24 db 81 10 80 	movl   $0x801081db,(%esp)
8010069c:	e8 b3 fe ff ff       	call   80100554 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006a1:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a8:	7e 53                	jle    801006fd <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006aa:	a1 04 90 10 80       	mov    0x80109004,%eax
801006af:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b5:	a1 04 90 10 80       	mov    0x80109004,%eax
801006ba:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c1:	00 
801006c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801006c6:	89 04 24             	mov    %eax,(%esp)
801006c9:	e8 29 4a 00 00       	call   801050f7 <memmove>
    pos -= 80;
801006ce:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d2:	b8 80 07 00 00       	mov    $0x780,%eax
801006d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006da:	01 c0                	add    %eax,%eax
801006dc:	8b 0d 04 90 10 80    	mov    0x80109004,%ecx
801006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801006e5:	01 d2                	add    %edx,%edx
801006e7:	01 ca                	add    %ecx,%edx
801006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801006ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f4:	00 
801006f5:	89 14 24             	mov    %edx,(%esp)
801006f8:	e8 31 49 00 00       	call   8010502e <memset>
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
80100754:	8b 15 04 90 10 80    	mov    0x80109004,%edx
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
8010078e:	e8 71 61 00 00       	call   80106904 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 65 61 00 00       	call   80106904 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 59 61 00 00       	call   80106904 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 4c 61 00 00       	call   80106904 <uartputc>
  cgaputc(c);
801007b8:	8b 45 08             	mov    0x8(%ebp),%eax
801007bb:	89 04 24             	mov    %eax,(%esp)
801007be:	e8 19 fe ff ff       	call   801005dc <cgaputc>
}
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
801007cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801007d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&cons.lock);
801007d9:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801007e0:	e8 e6 45 00 00       	call   80104dcb <acquire>
  while((c = getc()) >= 0){
801007e5:	e9 aa 01 00 00       	jmp    80100994 <consoleintr+0x1cf>
    switch(c){
801007ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801007ed:	83 f8 14             	cmp    $0x14,%eax
801007f0:	74 3b                	je     8010082d <consoleintr+0x68>
801007f2:	83 f8 14             	cmp    $0x14,%eax
801007f5:	7f 13                	jg     8010080a <consoleintr+0x45>
801007f7:	83 f8 08             	cmp    $0x8,%eax
801007fa:	0f 84 d5 00 00 00    	je     801008d5 <consoleintr+0x110>
80100800:	83 f8 10             	cmp    $0x10,%eax
80100803:	74 1c                	je     80100821 <consoleintr+0x5c>
80100805:	e9 fb 00 00 00       	jmp    80100905 <consoleintr+0x140>
8010080a:	83 f8 15             	cmp    $0x15,%eax
8010080d:	0f 84 9a 00 00 00    	je     801008ad <consoleintr+0xe8>
80100813:	83 f8 7f             	cmp    $0x7f,%eax
80100816:	0f 84 b9 00 00 00    	je     801008d5 <consoleintr+0x110>
8010081c:	e9 e4 00 00 00       	jmp    80100905 <consoleintr+0x140>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100821:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100828:	e9 67 01 00 00       	jmp    80100994 <consoleintr+0x1cf>
    case C('T'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      if (active == 1){
8010082d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100832:	83 f8 01             	cmp    $0x1,%eax
80100835:	75 0c                	jne    80100843 <consoleintr+0x7e>
        active = 2;
80100837:	c7 05 00 90 10 80 02 	movl   $0x2,0x80109000
8010083e:	00 00 00 
      }else{
        active = 1;
      }
      while(input.e != input.w &&
80100841:	eb 23                	jmp    80100866 <consoleintr+0xa1>
    case C('T'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      if (active == 1){
        active = 2;
      }else{
        active = 1;
80100843:	c7 05 00 90 10 80 01 	movl   $0x1,0x80109000
8010084a:	00 00 00 
      }
      while(input.e != input.w &&
8010084d:	eb 17                	jmp    80100866 <consoleintr+0xa1>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084f:	a1 28 10 11 80       	mov    0x80111028,%eax
80100854:	48                   	dec    %eax
80100855:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
8010085a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100861:	e8 02 ff ff ff       	call   80100768 <consputc>
      if (active == 1){
        active = 2;
      }else{
        active = 1;
      }
      while(input.e != input.w &&
80100866:	8b 15 28 10 11 80    	mov    0x80111028,%edx
8010086c:	a1 24 10 11 80       	mov    0x80111024,%eax
80100871:	39 c2                	cmp    %eax,%edx
80100873:	74 13                	je     80100888 <consoleintr+0xc3>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100875:	a1 28 10 11 80       	mov    0x80111028,%eax
8010087a:	48                   	dec    %eax
8010087b:	83 e0 7f             	and    $0x7f,%eax
8010087e:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
      if (active == 1){
        active = 2;
      }else{
        active = 1;
      }
      while(input.e != input.w &&
80100884:	3c 0a                	cmp    $0xa,%al
80100886:	75 c7                	jne    8010084f <consoleintr+0x8a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
80100888:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
8010088f:	e9 00 01 00 00       	jmp    80100994 <consoleintr+0x1cf>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100894:	a1 28 10 11 80       	mov    0x80111028,%eax
80100899:	48                   	dec    %eax
8010089a:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
8010089f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a6:	e8 bd fe ff ff       	call   80100768 <consputc>
801008ab:	eb 01                	jmp    801008ae <consoleintr+0xe9>
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008ad:	90                   	nop
801008ae:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008b4:	a1 24 10 11 80       	mov    0x80111024,%eax
801008b9:	39 c2                	cmp    %eax,%edx
801008bb:	74 13                	je     801008d0 <consoleintr+0x10b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008bd:	a1 28 10 11 80       	mov    0x80111028,%eax
801008c2:	48                   	dec    %eax
801008c3:	83 e0 7f             	and    $0x7f,%eax
801008c6:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008cc:	3c 0a                	cmp    $0xa,%al
801008ce:	75 c4                	jne    80100894 <consoleintr+0xcf>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d0:	e9 bf 00 00 00       	jmp    80100994 <consoleintr+0x1cf>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008d5:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008db:	a1 24 10 11 80       	mov    0x80111024,%eax
801008e0:	39 c2                	cmp    %eax,%edx
801008e2:	74 1c                	je     80100900 <consoleintr+0x13b>
        input.e--;
801008e4:	a1 28 10 11 80       	mov    0x80111028,%eax
801008e9:	48                   	dec    %eax
801008ea:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801008ef:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008f6:	e8 6d fe ff ff       	call   80100768 <consputc>
      }
      break;
801008fb:	e9 94 00 00 00       	jmp    80100994 <consoleintr+0x1cf>
80100900:	e9 8f 00 00 00       	jmp    80100994 <consoleintr+0x1cf>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100905:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100909:	0f 84 84 00 00 00    	je     80100993 <consoleintr+0x1ce>
8010090f:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100915:	a1 20 10 11 80       	mov    0x80111020,%eax
8010091a:	29 c2                	sub    %eax,%edx
8010091c:	89 d0                	mov    %edx,%eax
8010091e:	83 f8 7f             	cmp    $0x7f,%eax
80100921:	77 70                	ja     80100993 <consoleintr+0x1ce>
        c = (c == '\r') ? '\n' : c;
80100923:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80100927:	74 05                	je     8010092e <consoleintr+0x169>
80100929:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010092c:	eb 05                	jmp    80100933 <consoleintr+0x16e>
8010092e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100933:	89 45 ec             	mov    %eax,-0x14(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100936:	a1 28 10 11 80       	mov    0x80111028,%eax
8010093b:	8d 50 01             	lea    0x1(%eax),%edx
8010093e:	89 15 28 10 11 80    	mov    %edx,0x80111028
80100944:	83 e0 7f             	and    $0x7f,%eax
80100947:	89 c2                	mov    %eax,%edx
80100949:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010094c:	88 82 a0 0f 11 80    	mov    %al,-0x7feef060(%edx)
        consputc(c);
80100952:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100955:	89 04 24             	mov    %eax,(%esp)
80100958:	e8 0b fe ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010095d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100961:	74 18                	je     8010097b <consoleintr+0x1b6>
80100963:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100967:	74 12                	je     8010097b <consoleintr+0x1b6>
80100969:	a1 28 10 11 80       	mov    0x80111028,%eax
8010096e:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100974:	83 ea 80             	sub    $0xffffff80,%edx
80100977:	39 d0                	cmp    %edx,%eax
80100979:	75 18                	jne    80100993 <consoleintr+0x1ce>
          input.w = input.e;
8010097b:	a1 28 10 11 80       	mov    0x80111028,%eax
80100980:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
80100985:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
8010098c:	e8 3f 41 00 00       	call   80104ad0 <wakeup>
        }
      }
      break;
80100991:	eb 00                	jmp    80100993 <consoleintr+0x1ce>
80100993:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100994:	8b 45 08             	mov    0x8(%ebp),%eax
80100997:	ff d0                	call   *%eax
80100999:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010099c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801009a0:	0f 89 44 fe ff ff    	jns    801007ea <consoleintr+0x25>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009a6:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801009ad:	e8 83 44 00 00       	call   80104e35 <release>
  if(doprocdump){
801009b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009b6:	74 05                	je     801009bd <consoleintr+0x1f8>
    procdump();  // now call procdump() wo. cons.lock held
801009b8:	e8 b6 41 00 00       	call   80104b73 <procdump>
  }
  if(doconsoleswitch){
801009bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009c1:	74 15                	je     801009d8 <consoleintr+0x213>
    cprintf("\nActive console now: %d\n", active);
801009c3:	a1 00 90 10 80       	mov    0x80109000,%eax
801009c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801009cc:	c7 04 24 ee 81 10 80 	movl   $0x801081ee,(%esp)
801009d3:	e8 e9 f9 ff ff       	call   801003c1 <cprintf>
  }
}
801009d8:	c9                   	leave  
801009d9:	c3                   	ret    

801009da <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009da:	55                   	push   %ebp
801009db:	89 e5                	mov    %esp,%ebp
801009dd:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
801009e0:	8b 45 08             	mov    0x8(%ebp),%eax
801009e3:	89 04 24             	mov    %eax,(%esp)
801009e6:	e8 e9 10 00 00       	call   80101ad4 <iunlock>
  target = n;
801009eb:	8b 45 10             	mov    0x10(%ebp),%eax
801009ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009f1:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801009f8:	e8 ce 43 00 00       	call   80104dcb <acquire>
  while(n > 0){
801009fd:	e9 b7 00 00 00       	jmp    80100ab9 <consoleread+0xdf>
    while(input.r == input.w || active != ip->minor){
80100a02:	eb 41                	jmp    80100a45 <consoleread+0x6b>
      if(myproc()->killed){
80100a04:	e8 b2 37 00 00       	call   801041bb <myproc>
80100a09:	8b 40 24             	mov    0x24(%eax),%eax
80100a0c:	85 c0                	test   %eax,%eax
80100a0e:	74 21                	je     80100a31 <consoleread+0x57>
        release(&cons.lock);
80100a10:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a17:	e8 19 44 00 00       	call   80104e35 <release>
        ilock(ip);
80100a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a1f:	89 04 24             	mov    %eax,(%esp)
80100a22:	e8 a3 0f 00 00       	call   801019ca <ilock>
        return -1;
80100a27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a2c:	e9 b3 00 00 00       	jmp    80100ae4 <consoleread+0x10a>
      }
      sleep(&input.r, &cons.lock);
80100a31:	c7 44 24 04 a0 b5 10 	movl   $0x8010b5a0,0x4(%esp)
80100a38:	80 
80100a39:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
80100a40:	e8 b7 3f 00 00       	call   801049fc <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w || active != ip->minor){
80100a45:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100a4b:	a1 24 10 11 80       	mov    0x80111024,%eax
80100a50:	39 c2                	cmp    %eax,%edx
80100a52:	74 b0                	je     80100a04 <consoleread+0x2a>
80100a54:	8b 45 08             	mov    0x8(%ebp),%eax
80100a57:	8b 40 54             	mov    0x54(%eax),%eax
80100a5a:	0f bf d0             	movswl %ax,%edx
80100a5d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100a62:	39 c2                	cmp    %eax,%edx
80100a64:	75 9e                	jne    80100a04 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a66:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a6b:	8d 50 01             	lea    0x1(%eax),%edx
80100a6e:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100a74:	83 e0 7f             	and    $0x7f,%eax
80100a77:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
80100a7d:	0f be c0             	movsbl %al,%eax
80100a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a83:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a87:	75 17                	jne    80100aa0 <consoleread+0xc6>
      if(n < target){
80100a89:	8b 45 10             	mov    0x10(%ebp),%eax
80100a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a8f:	73 0d                	jae    80100a9e <consoleread+0xc4>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a91:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a96:	48                   	dec    %eax
80100a97:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100a9c:	eb 25                	jmp    80100ac3 <consoleread+0xe9>
80100a9e:	eb 23                	jmp    80100ac3 <consoleread+0xe9>
    }
    *dst++ = c;
80100aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa3:	8d 50 01             	lea    0x1(%eax),%edx
80100aa6:	89 55 0c             	mov    %edx,0xc(%ebp)
80100aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100aac:	88 10                	mov    %dl,(%eax)
    --n;
80100aae:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100ab1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ab5:	75 02                	jne    80100ab9 <consoleread+0xdf>
      break;
80100ab7:	eb 0a                	jmp    80100ac3 <consoleread+0xe9>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100ab9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100abd:	0f 8f 3f ff ff ff    	jg     80100a02 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100ac3:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100aca:	e8 66 43 00 00       	call   80104e35 <release>
  ilock(ip);
80100acf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ad2:	89 04 24             	mov    %eax,(%esp)
80100ad5:	e8 f0 0e 00 00       	call   801019ca <ilock>

  return target - n;
80100ada:	8b 45 10             	mov    0x10(%ebp),%eax
80100add:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ae0:	29 c2                	sub    %eax,%edx
80100ae2:	89 d0                	mov    %edx,%eax
}
80100ae4:	c9                   	leave  
80100ae5:	c3                   	ret    

80100ae6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ae6:	55                   	push   %ebp
80100ae7:	89 e5                	mov    %esp,%ebp
80100ae9:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor){
80100aec:	8b 45 08             	mov    0x8(%ebp),%eax
80100aef:	8b 40 54             	mov    0x54(%eax),%eax
80100af2:	0f bf d0             	movswl %ax,%edx
80100af5:	a1 00 90 10 80       	mov    0x80109000,%eax
80100afa:	39 c2                	cmp    %eax,%edx
80100afc:	75 5a                	jne    80100b58 <consolewrite+0x72>
    iunlock(ip);
80100afe:	8b 45 08             	mov    0x8(%ebp),%eax
80100b01:	89 04 24             	mov    %eax,(%esp)
80100b04:	e8 cb 0f 00 00       	call   80101ad4 <iunlock>
    acquire(&cons.lock);
80100b09:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b10:	e8 b6 42 00 00       	call   80104dcb <acquire>
    for(i = 0; i < n; i++)
80100b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b1c:	eb 1b                	jmp    80100b39 <consolewrite+0x53>
      consputc(buf[i] & 0xff);
80100b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b21:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b24:	01 d0                	add    %edx,%eax
80100b26:	8a 00                	mov    (%eax),%al
80100b28:	0f be c0             	movsbl %al,%eax
80100b2b:	0f b6 c0             	movzbl %al,%eax
80100b2e:	89 04 24             	mov    %eax,(%esp)
80100b31:	e8 32 fc ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100b36:	ff 45 f4             	incl   -0xc(%ebp)
80100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b3c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b3f:	7c dd                	jl     80100b1e <consolewrite+0x38>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100b41:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b48:	e8 e8 42 00 00       	call   80104e35 <release>
    ilock(ip);
80100b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80100b50:	89 04 24             	mov    %eax,(%esp)
80100b53:	e8 72 0e 00 00       	call   801019ca <ilock>
  }
  return n;
80100b58:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b5b:	c9                   	leave  
80100b5c:	c3                   	ret    

80100b5d <consoleinit>:

void
consoleinit(void)
{
80100b5d:	55                   	push   %ebp
80100b5e:	89 e5                	mov    %esp,%ebp
80100b60:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100b63:	c7 44 24 04 07 82 10 	movl   $0x80108207,0x4(%esp)
80100b6a:	80 
80100b6b:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b72:	e8 33 42 00 00       	call   80104daa <initlock>

  devsw[CONSOLE].write = consolewrite;
80100b77:	c7 05 ec 19 11 80 e6 	movl   $0x80100ae6,0x801119ec
80100b7e:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b81:	c7 05 e8 19 11 80 da 	movl   $0x801009da,0x801119e8
80100b88:	09 10 80 
  cons.locking = 1;
80100b8b:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100b92:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b9c:	00 
80100b9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ba4:	e8 e6 1e 00 00       	call   80102a8f <ioapicenable>
}
80100ba9:	c9                   	leave  
80100baa:	c3                   	ret    
	...

80100bac <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bac:	55                   	push   %ebp
80100bad:	89 e5                	mov    %esp,%ebp
80100baf:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bb5:	e8 01 36 00 00       	call   801041bb <myproc>
80100bba:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bbd:	e8 01 29 00 00       	call   801034c3 <begin_op>

  if((ip = namei(path)) == 0){
80100bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 22 19 00 00       	call   801024ef <namei>
80100bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bd0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bd4:	75 1b                	jne    80100bf1 <exec+0x45>
    end_op();
80100bd6:	e8 6a 29 00 00       	call   80103545 <end_op>
    cprintf("exec: fail\n");
80100bdb:	c7 04 24 0f 82 10 80 	movl   $0x8010820f,(%esp)
80100be2:	e8 da f7 ff ff       	call   801003c1 <cprintf>
    return -1;
80100be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bec:	e9 f6 03 00 00       	jmp    80100fe7 <exec+0x43b>
  }
  ilock(ip);
80100bf1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bf4:	89 04 24             	mov    %eax,(%esp)
80100bf7:	e8 ce 0d 00 00       	call   801019ca <ilock>
  pgdir = 0;
80100bfc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c03:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100c0a:	00 
80100c0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100c12:	00 
80100c13:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c19:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c20:	89 04 24             	mov    %eax,(%esp)
80100c23:	e8 39 12 00 00       	call   80101e61 <readi>
80100c28:	83 f8 34             	cmp    $0x34,%eax
80100c2b:	74 05                	je     80100c32 <exec+0x86>
    goto bad;
80100c2d:	e9 89 03 00 00       	jmp    80100fbb <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100c32:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c38:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c3d:	74 05                	je     80100c44 <exec+0x98>
    goto bad;
80100c3f:	e9 77 03 00 00       	jmp    80100fbb <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100c44:	e8 9d 6c 00 00       	call   801078e6 <setupkvm>
80100c49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c4c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c50:	75 05                	jne    80100c57 <exec+0xab>
    goto bad;
80100c52:	e9 64 03 00 00       	jmp    80100fbb <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100c57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c5e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6e:	e9 fb 00 00 00       	jmp    80100d6e <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c76:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100c7d:	00 
80100c7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c82:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c8f:	89 04 24             	mov    %eax,(%esp)
80100c92:	e8 ca 11 00 00       	call   80101e61 <readi>
80100c97:	83 f8 20             	cmp    $0x20,%eax
80100c9a:	74 05                	je     80100ca1 <exec+0xf5>
      goto bad;
80100c9c:	e9 1a 03 00 00       	jmp    80100fbb <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100ca1:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100ca7:	83 f8 01             	cmp    $0x1,%eax
80100caa:	74 05                	je     80100cb1 <exec+0x105>
      continue;
80100cac:	e9 b1 00 00 00       	jmp    80100d62 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100cb1:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cb7:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cbd:	39 c2                	cmp    %eax,%edx
80100cbf:	73 05                	jae    80100cc6 <exec+0x11a>
      goto bad;
80100cc1:	e9 f5 02 00 00       	jmp    80100fbb <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cc6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ccc:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cd2:	01 c2                	add    %eax,%edx
80100cd4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cda:	39 c2                	cmp    %eax,%edx
80100cdc:	73 05                	jae    80100ce3 <exec+0x137>
      goto bad;
80100cde:	e9 d8 02 00 00       	jmp    80100fbb <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ce3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ce9:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cef:	01 d0                	add    %edx,%eax
80100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cff:	89 04 24             	mov    %eax,(%esp)
80100d02:	e8 ab 6f 00 00       	call   80107cb2 <allocuvm>
80100d07:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d0e:	75 05                	jne    80100d15 <exec+0x169>
      goto bad;
80100d10:	e9 a6 02 00 00       	jmp    80100fbb <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100d15:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d1b:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d20:	85 c0                	test   %eax,%eax
80100d22:	74 05                	je     80100d29 <exec+0x17d>
      goto bad;
80100d24:	e9 92 02 00 00       	jmp    80100fbb <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d29:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100d2f:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d35:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d3b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100d3f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d43:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100d46:	89 54 24 08          	mov    %edx,0x8(%esp)
80100d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d51:	89 04 24             	mov    %eax,(%esp)
80100d54:	e8 76 6e 00 00       	call   80107bcf <loaduvm>
80100d59:	85 c0                	test   %eax,%eax
80100d5b:	79 05                	jns    80100d62 <exec+0x1b6>
      goto bad;
80100d5d:	e9 59 02 00 00       	jmp    80100fbb <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d62:	ff 45 ec             	incl   -0x14(%ebp)
80100d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d68:	83 c0 20             	add    $0x20,%eax
80100d6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d6e:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100d74:	0f b7 c0             	movzwl %ax,%eax
80100d77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d7a:	0f 8f f3 fe ff ff    	jg     80100c73 <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d80:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d83:	89 04 24             	mov    %eax,(%esp)
80100d86:	e8 3e 0e 00 00       	call   80101bc9 <iunlockput>
  end_op();
80100d8b:	e8 b5 27 00 00       	call   80103545 <end_op>
  ip = 0;
80100d90:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100da4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100daa:	05 00 20 00 00       	add    $0x2000,%eax
80100daf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100dbd:	89 04 24             	mov    %eax,(%esp)
80100dc0:	e8 ed 6e 00 00       	call   80107cb2 <allocuvm>
80100dc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dcc:	75 05                	jne    80100dd3 <exec+0x227>
    goto bad;
80100dce:	e9 e8 01 00 00       	jmp    80100fbb <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ddf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de2:	89 04 24             	mov    %eax,(%esp)
80100de5:	e8 38 71 00 00       	call   80107f22 <clearpteu>
  sp = sz;
80100dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ded:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100df0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100df7:	e9 95 00 00 00       	jmp    80100e91 <exec+0x2e5>
    if(argc >= MAXARG)
80100dfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e00:	76 05                	jbe    80100e07 <exec+0x25b>
      goto bad;
80100e02:	e9 b4 01 00 00       	jmp    80100fbb <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e11:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e14:	01 d0                	add    %edx,%eax
80100e16:	8b 00                	mov    (%eax),%eax
80100e18:	89 04 24             	mov    %eax,(%esp)
80100e1b:	e8 61 44 00 00       	call   80105281 <strlen>
80100e20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e23:	29 c2                	sub    %eax,%edx
80100e25:	89 d0                	mov    %edx,%eax
80100e27:	48                   	dec    %eax
80100e28:	83 e0 fc             	and    $0xfffffffc,%eax
80100e2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e3b:	01 d0                	add    %edx,%eax
80100e3d:	8b 00                	mov    (%eax),%eax
80100e3f:	89 04 24             	mov    %eax,(%esp)
80100e42:	e8 3a 44 00 00       	call   80105281 <strlen>
80100e47:	40                   	inc    %eax
80100e48:	89 c2                	mov    %eax,%edx
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e57:	01 c8                	add    %ecx,%eax
80100e59:	8b 00                	mov    (%eax),%eax
80100e5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100e5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e6d:	89 04 24             	mov    %eax,(%esp)
80100e70:	e8 65 72 00 00       	call   801080da <copyout>
80100e75:	85 c0                	test   %eax,%eax
80100e77:	79 05                	jns    80100e7e <exec+0x2d2>
      goto bad;
80100e79:	e9 3d 01 00 00       	jmp    80100fbb <exec+0x40f>
    ustack[3+argc] = sp;
80100e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e81:	8d 50 03             	lea    0x3(%eax),%edx
80100e84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e87:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e8e:	ff 45 e4             	incl   -0x1c(%ebp)
80100e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e9e:	01 d0                	add    %edx,%eax
80100ea0:	8b 00                	mov    (%eax),%eax
80100ea2:	85 c0                	test   %eax,%eax
80100ea4:	0f 85 52 ff ff ff    	jne    80100dfc <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ead:	83 c0 03             	add    $0x3,%eax
80100eb0:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100eb7:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ebb:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100ec2:	ff ff ff 
  ustack[1] = argc;
80100ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec8:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed1:	40                   	inc    %eax
80100ed2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100edc:	29 d0                	sub    %edx,%eax
80100ede:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee7:	83 c0 04             	add    $0x4,%eax
80100eea:	c1 e0 02             	shl    $0x2,%eax
80100eed:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef3:	83 c0 04             	add    $0x4,%eax
80100ef6:	c1 e0 02             	shl    $0x2,%eax
80100ef9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100efd:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f11:	89 04 24             	mov    %eax,(%esp)
80100f14:	e8 c1 71 00 00       	call   801080da <copyout>
80100f19:	85 c0                	test   %eax,%eax
80100f1b:	79 05                	jns    80100f22 <exec+0x376>
    goto bad;
80100f1d:	e9 99 00 00 00       	jmp    80100fbb <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f22:	8b 45 08             	mov    0x8(%ebp),%eax
80100f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f2e:	eb 13                	jmp    80100f43 <exec+0x397>
    if(*s == '/')
80100f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f33:	8a 00                	mov    (%eax),%al
80100f35:	3c 2f                	cmp    $0x2f,%al
80100f37:	75 07                	jne    80100f40 <exec+0x394>
      last = s+1;
80100f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3c:	40                   	inc    %eax
80100f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f40:	ff 45 f4             	incl   -0xc(%ebp)
80100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f46:	8a 00                	mov    (%eax),%al
80100f48:	84 c0                	test   %al,%al
80100f4a:	75 e4                	jne    80100f30 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f4f:	8d 50 6c             	lea    0x6c(%eax),%edx
80100f52:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100f59:	00 
80100f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f61:	89 14 24             	mov    %edx,(%esp)
80100f64:	e8 d1 42 00 00       	call   8010523a <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f69:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f6c:	8b 40 04             	mov    0x4(%eax),%eax
80100f6f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f72:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f78:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f81:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f83:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f86:	8b 40 18             	mov    0x18(%eax),%eax
80100f89:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f8f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f92:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f95:	8b 40 18             	mov    0x18(%eax),%eax
80100f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f9b:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f9e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fa1:	89 04 24             	mov    %eax,(%esp)
80100fa4:	e8 17 6a 00 00       	call   801079c0 <switchuvm>
  freevm(oldpgdir);
80100fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fac:	89 04 24             	mov    %eax,(%esp)
80100faf:	e8 d8 6e 00 00       	call   80107e8c <freevm>
  return 0;
80100fb4:	b8 00 00 00 00       	mov    $0x0,%eax
80100fb9:	eb 2c                	jmp    80100fe7 <exec+0x43b>

 bad:
  if(pgdir)
80100fbb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fbf:	74 0b                	je     80100fcc <exec+0x420>
    freevm(pgdir);
80100fc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100fc4:	89 04 24             	mov    %eax,(%esp)
80100fc7:	e8 c0 6e 00 00       	call   80107e8c <freevm>
  if(ip){
80100fcc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fd0:	74 10                	je     80100fe2 <exec+0x436>
    iunlockput(ip);
80100fd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100fd5:	89 04 24             	mov    %eax,(%esp)
80100fd8:	e8 ec 0b 00 00       	call   80101bc9 <iunlockput>
    end_op();
80100fdd:	e8 63 25 00 00       	call   80103545 <end_op>
  }
  return -1;
80100fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe7:	c9                   	leave  
80100fe8:	c3                   	ret    
80100fe9:	00 00                	add    %al,(%eax)
	...

80100fec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fec:	55                   	push   %ebp
80100fed:	89 e5                	mov    %esp,%ebp
80100fef:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100ff2:	c7 44 24 04 1b 82 10 	movl   $0x8010821b,0x4(%esp)
80100ff9:	80 
80100ffa:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101001:	e8 a4 3d 00 00       	call   80104daa <initlock>
}
80101006:	c9                   	leave  
80101007:	c3                   	ret    

80101008 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101008:	55                   	push   %ebp
80101009:	89 e5                	mov    %esp,%ebp
8010100b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
8010100e:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101015:	e8 b1 3d 00 00       	call   80104dcb <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010101a:	c7 45 f4 74 10 11 80 	movl   $0x80111074,-0xc(%ebp)
80101021:	eb 29                	jmp    8010104c <filealloc+0x44>
    if(f->ref == 0){
80101023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101026:	8b 40 04             	mov    0x4(%eax),%eax
80101029:	85 c0                	test   %eax,%eax
8010102b:	75 1b                	jne    80101048 <filealloc+0x40>
      f->ref = 1;
8010102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101030:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101037:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
8010103e:	e8 f2 3d 00 00       	call   80104e35 <release>
      return f;
80101043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101046:	eb 1e                	jmp    80101066 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101048:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010104c:	81 7d f4 d4 19 11 80 	cmpl   $0x801119d4,-0xc(%ebp)
80101053:	72 ce                	jb     80101023 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101055:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
8010105c:	e8 d4 3d 00 00       	call   80104e35 <release>
  return 0;
80101061:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101066:	c9                   	leave  
80101067:	c3                   	ret    

80101068 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101068:	55                   	push   %ebp
80101069:	89 e5                	mov    %esp,%ebp
8010106b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
8010106e:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101075:	e8 51 3d 00 00       	call   80104dcb <acquire>
  if(f->ref < 1)
8010107a:	8b 45 08             	mov    0x8(%ebp),%eax
8010107d:	8b 40 04             	mov    0x4(%eax),%eax
80101080:	85 c0                	test   %eax,%eax
80101082:	7f 0c                	jg     80101090 <filedup+0x28>
    panic("filedup");
80101084:	c7 04 24 22 82 10 80 	movl   $0x80108222,(%esp)
8010108b:	e8 c4 f4 ff ff       	call   80100554 <panic>
  f->ref++;
80101090:	8b 45 08             	mov    0x8(%ebp),%eax
80101093:	8b 40 04             	mov    0x4(%eax),%eax
80101096:	8d 50 01             	lea    0x1(%eax),%edx
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010109f:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801010a6:	e8 8a 3d 00 00       	call   80104e35 <release>
  return f;
801010ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010ae:	c9                   	leave  
801010af:	c3                   	ret    

801010b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
801010b9:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801010c0:	e8 06 3d 00 00       	call   80104dcb <acquire>
  if(f->ref < 1)
801010c5:	8b 45 08             	mov    0x8(%ebp),%eax
801010c8:	8b 40 04             	mov    0x4(%eax),%eax
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 0c                	jg     801010db <fileclose+0x2b>
    panic("fileclose");
801010cf:	c7 04 24 2a 82 10 80 	movl   $0x8010822a,(%esp)
801010d6:	e8 79 f4 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	8b 40 04             	mov    0x4(%eax),%eax
801010e1:	8d 50 ff             	lea    -0x1(%eax),%edx
801010e4:	8b 45 08             	mov    0x8(%ebp),%eax
801010e7:	89 50 04             	mov    %edx,0x4(%eax)
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	8b 40 04             	mov    0x4(%eax),%eax
801010f0:	85 c0                	test   %eax,%eax
801010f2:	7e 0e                	jle    80101102 <fileclose+0x52>
    release(&ftable.lock);
801010f4:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801010fb:	e8 35 3d 00 00       	call   80104e35 <release>
80101100:	eb 70                	jmp    80101172 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101102:	8b 45 08             	mov    0x8(%ebp),%eax
80101105:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101108:	89 c3                	mov    %eax,%ebx
8010110a:	b8 06 00 00 00       	mov    $0x6,%eax
8010110f:	89 d7                	mov    %edx,%edi
80101111:	89 de                	mov    %ebx,%esi
80101113:	89 c1                	mov    %eax,%ecx
80101115:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101117:	8b 45 08             	mov    0x8(%ebp),%eax
8010111a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010112a:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101131:	e8 ff 3c 00 00       	call   80104e35 <release>

  if(ff.type == FD_PIPE)
80101136:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101139:	83 f8 01             	cmp    $0x1,%eax
8010113c:	75 17                	jne    80101155 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
8010113e:	8a 45 d9             	mov    -0x27(%ebp),%al
80101141:	0f be d0             	movsbl %al,%edx
80101144:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101147:	89 54 24 04          	mov    %edx,0x4(%esp)
8010114b:	89 04 24             	mov    %eax,(%esp)
8010114e:	e8 00 2d 00 00       	call   80103e53 <pipeclose>
80101153:	eb 1d                	jmp    80101172 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101155:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101158:	83 f8 02             	cmp    $0x2,%eax
8010115b:	75 15                	jne    80101172 <fileclose+0xc2>
    begin_op();
8010115d:	e8 61 23 00 00       	call   801034c3 <begin_op>
    iput(ff.ip);
80101162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101165:	89 04 24             	mov    %eax,(%esp)
80101168:	e8 ab 09 00 00       	call   80101b18 <iput>
    end_op();
8010116d:	e8 d3 23 00 00       	call   80103545 <end_op>
  }
}
80101172:	83 c4 3c             	add    $0x3c,%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
80101179:	c3                   	ret    

8010117a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010117a:	55                   	push   %ebp
8010117b:	89 e5                	mov    %esp,%ebp
8010117d:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101180:	8b 45 08             	mov    0x8(%ebp),%eax
80101183:	8b 00                	mov    (%eax),%eax
80101185:	83 f8 02             	cmp    $0x2,%eax
80101188:	75 38                	jne    801011c2 <filestat+0x48>
    ilock(f->ip);
8010118a:	8b 45 08             	mov    0x8(%ebp),%eax
8010118d:	8b 40 10             	mov    0x10(%eax),%eax
80101190:	89 04 24             	mov    %eax,(%esp)
80101193:	e8 32 08 00 00       	call   801019ca <ilock>
    stati(f->ip, st);
80101198:	8b 45 08             	mov    0x8(%ebp),%eax
8010119b:	8b 40 10             	mov    0x10(%eax),%eax
8010119e:	8b 55 0c             	mov    0xc(%ebp),%edx
801011a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a5:	89 04 24             	mov    %eax,(%esp)
801011a8:	e8 70 0c 00 00       	call   80101e1d <stati>
    iunlock(f->ip);
801011ad:	8b 45 08             	mov    0x8(%ebp),%eax
801011b0:	8b 40 10             	mov    0x10(%eax),%eax
801011b3:	89 04 24             	mov    %eax,(%esp)
801011b6:	e8 19 09 00 00       	call   80101ad4 <iunlock>
    return 0;
801011bb:	b8 00 00 00 00       	mov    $0x0,%eax
801011c0:	eb 05                	jmp    801011c7 <filestat+0x4d>
  }
  return -1;
801011c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011c7:	c9                   	leave  
801011c8:	c3                   	ret    

801011c9 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011c9:	55                   	push   %ebp
801011ca:	89 e5                	mov    %esp,%ebp
801011cc:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801011cf:	8b 45 08             	mov    0x8(%ebp),%eax
801011d2:	8a 40 08             	mov    0x8(%eax),%al
801011d5:	84 c0                	test   %al,%al
801011d7:	75 0a                	jne    801011e3 <fileread+0x1a>
    return -1;
801011d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011de:	e9 9f 00 00 00       	jmp    80101282 <fileread+0xb9>
  if(f->type == FD_PIPE)
801011e3:	8b 45 08             	mov    0x8(%ebp),%eax
801011e6:	8b 00                	mov    (%eax),%eax
801011e8:	83 f8 01             	cmp    $0x1,%eax
801011eb:	75 1e                	jne    8010120b <fileread+0x42>
    return piperead(f->pipe, addr, n);
801011ed:	8b 45 08             	mov    0x8(%ebp),%eax
801011f0:	8b 40 0c             	mov    0xc(%eax),%eax
801011f3:	8b 55 10             	mov    0x10(%ebp),%edx
801011f6:	89 54 24 08          	mov    %edx,0x8(%esp)
801011fa:	8b 55 0c             	mov    0xc(%ebp),%edx
801011fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101201:	89 04 24             	mov    %eax,(%esp)
80101204:	e8 c8 2d 00 00       	call   80103fd1 <piperead>
80101209:	eb 77                	jmp    80101282 <fileread+0xb9>
  if(f->type == FD_INODE){
8010120b:	8b 45 08             	mov    0x8(%ebp),%eax
8010120e:	8b 00                	mov    (%eax),%eax
80101210:	83 f8 02             	cmp    $0x2,%eax
80101213:	75 61                	jne    80101276 <fileread+0xad>
    ilock(f->ip);
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	8b 40 10             	mov    0x10(%eax),%eax
8010121b:	89 04 24             	mov    %eax,(%esp)
8010121e:	e8 a7 07 00 00       	call   801019ca <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101223:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101226:	8b 45 08             	mov    0x8(%ebp),%eax
80101229:	8b 50 14             	mov    0x14(%eax),%edx
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	8b 40 10             	mov    0x10(%eax),%eax
80101232:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101236:	89 54 24 08          	mov    %edx,0x8(%esp)
8010123a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010123d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101241:	89 04 24             	mov    %eax,(%esp)
80101244:	e8 18 0c 00 00       	call   80101e61 <readi>
80101249:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010124c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101250:	7e 11                	jle    80101263 <fileread+0x9a>
      f->off += r;
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 50 14             	mov    0x14(%eax),%edx
80101258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010125b:	01 c2                	add    %eax,%edx
8010125d:	8b 45 08             	mov    0x8(%ebp),%eax
80101260:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101263:	8b 45 08             	mov    0x8(%ebp),%eax
80101266:	8b 40 10             	mov    0x10(%eax),%eax
80101269:	89 04 24             	mov    %eax,(%esp)
8010126c:	e8 63 08 00 00       	call   80101ad4 <iunlock>
    return r;
80101271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101274:	eb 0c                	jmp    80101282 <fileread+0xb9>
  }
  panic("fileread");
80101276:	c7 04 24 34 82 10 80 	movl   $0x80108234,(%esp)
8010127d:	e8 d2 f2 ff ff       	call   80100554 <panic>
}
80101282:	c9                   	leave  
80101283:	c3                   	ret    

80101284 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101284:	55                   	push   %ebp
80101285:	89 e5                	mov    %esp,%ebp
80101287:	53                   	push   %ebx
80101288:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8a 40 09             	mov    0x9(%eax),%al
80101291:	84 c0                	test   %al,%al
80101293:	75 0a                	jne    8010129f <filewrite+0x1b>
    return -1;
80101295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010129a:	e9 20 01 00 00       	jmp    801013bf <filewrite+0x13b>
  if(f->type == FD_PIPE)
8010129f:	8b 45 08             	mov    0x8(%ebp),%eax
801012a2:	8b 00                	mov    (%eax),%eax
801012a4:	83 f8 01             	cmp    $0x1,%eax
801012a7:	75 21                	jne    801012ca <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801012a9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ac:	8b 40 0c             	mov    0xc(%eax),%eax
801012af:	8b 55 10             	mov    0x10(%ebp),%edx
801012b2:	89 54 24 08          	mov    %edx,0x8(%esp)
801012b6:	8b 55 0c             	mov    0xc(%ebp),%edx
801012b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801012bd:	89 04 24             	mov    %eax,(%esp)
801012c0:	e8 20 2c 00 00       	call   80103ee5 <pipewrite>
801012c5:	e9 f5 00 00 00       	jmp    801013bf <filewrite+0x13b>
  if(f->type == FD_INODE){
801012ca:	8b 45 08             	mov    0x8(%ebp),%eax
801012cd:	8b 00                	mov    (%eax),%eax
801012cf:	83 f8 02             	cmp    $0x2,%eax
801012d2:	0f 85 db 00 00 00    	jne    801013b3 <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012d8:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012e6:	e9 a8 00 00 00       	jmp    80101393 <filewrite+0x10f>
      int n1 = n - i;
801012eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ee:	8b 55 10             	mov    0x10(%ebp),%edx
801012f1:	29 c2                	sub    %eax,%edx
801012f3:	89 d0                	mov    %edx,%eax
801012f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012fe:	7e 06                	jle    80101306 <filewrite+0x82>
        n1 = max;
80101300:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101303:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101306:	e8 b8 21 00 00       	call   801034c3 <begin_op>
      ilock(f->ip);
8010130b:	8b 45 08             	mov    0x8(%ebp),%eax
8010130e:	8b 40 10             	mov    0x10(%eax),%eax
80101311:	89 04 24             	mov    %eax,(%esp)
80101314:	e8 b1 06 00 00       	call   801019ca <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101319:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 50 14             	mov    0x14(%eax),%edx
80101322:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101325:	8b 45 0c             	mov    0xc(%ebp),%eax
80101328:	01 c3                	add    %eax,%ebx
8010132a:	8b 45 08             	mov    0x8(%ebp),%eax
8010132d:	8b 40 10             	mov    0x10(%eax),%eax
80101330:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101334:	89 54 24 08          	mov    %edx,0x8(%esp)
80101338:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010133c:	89 04 24             	mov    %eax,(%esp)
8010133f:	e8 81 0c 00 00       	call   80101fc5 <writei>
80101344:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101347:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010134b:	7e 11                	jle    8010135e <filewrite+0xda>
        f->off += r;
8010134d:	8b 45 08             	mov    0x8(%ebp),%eax
80101350:	8b 50 14             	mov    0x14(%eax),%edx
80101353:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101356:	01 c2                	add    %eax,%edx
80101358:	8b 45 08             	mov    0x8(%ebp),%eax
8010135b:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010135e:	8b 45 08             	mov    0x8(%ebp),%eax
80101361:	8b 40 10             	mov    0x10(%eax),%eax
80101364:	89 04 24             	mov    %eax,(%esp)
80101367:	e8 68 07 00 00       	call   80101ad4 <iunlock>
      end_op();
8010136c:	e8 d4 21 00 00       	call   80103545 <end_op>

      if(r < 0)
80101371:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101375:	79 02                	jns    80101379 <filewrite+0xf5>
        break;
80101377:	eb 26                	jmp    8010139f <filewrite+0x11b>
      if(r != n1)
80101379:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010137f:	74 0c                	je     8010138d <filewrite+0x109>
        panic("short filewrite");
80101381:	c7 04 24 3d 82 10 80 	movl   $0x8010823d,(%esp)
80101388:	e8 c7 f1 ff ff       	call   80100554 <panic>
      i += r;
8010138d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101390:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101396:	3b 45 10             	cmp    0x10(%ebp),%eax
80101399:	0f 8c 4c ff ff ff    	jl     801012eb <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a5:	75 05                	jne    801013ac <filewrite+0x128>
801013a7:	8b 45 10             	mov    0x10(%ebp),%eax
801013aa:	eb 05                	jmp    801013b1 <filewrite+0x12d>
801013ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013b1:	eb 0c                	jmp    801013bf <filewrite+0x13b>
  }
  panic("filewrite");
801013b3:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
801013ba:	e8 95 f1 ff ff       	call   80100554 <panic>
}
801013bf:	83 c4 24             	add    $0x24,%esp
801013c2:	5b                   	pop    %ebx
801013c3:	5d                   	pop    %ebp
801013c4:	c3                   	ret    
801013c5:	00 00                	add    %al,(%eax)
	...

801013c8 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013c8:	55                   	push   %ebp
801013c9:	89 e5                	mov    %esp,%ebp
801013cb:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013ce:	8b 45 08             	mov    0x8(%ebp),%eax
801013d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013d8:	00 
801013d9:	89 04 24             	mov    %eax,(%esp)
801013dc:	e8 d4 ed ff ff       	call   801001b5 <bread>
801013e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e7:	83 c0 5c             	add    $0x5c,%eax
801013ea:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013f1:	00 
801013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801013f9:	89 04 24             	mov    %eax,(%esp)
801013fc:	e8 f6 3c 00 00       	call   801050f7 <memmove>
  brelse(bp);
80101401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101404:	89 04 24             	mov    %eax,(%esp)
80101407:	e8 20 ee ff ff       	call   8010022c <brelse>
}
8010140c:	c9                   	leave  
8010140d:	c3                   	ret    

8010140e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010140e:	55                   	push   %ebp
8010140f:	89 e5                	mov    %esp,%ebp
80101411:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101414:	8b 55 0c             	mov    0xc(%ebp),%edx
80101417:	8b 45 08             	mov    0x8(%ebp),%eax
8010141a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010141e:	89 04 24             	mov    %eax,(%esp)
80101421:	e8 8f ed ff ff       	call   801001b5 <bread>
80101426:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010142c:	83 c0 5c             	add    $0x5c,%eax
8010142f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101436:	00 
80101437:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010143e:	00 
8010143f:	89 04 24             	mov    %eax,(%esp)
80101442:	e8 e7 3b 00 00       	call   8010502e <memset>
  log_write(bp);
80101447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144a:	89 04 24             	mov    %eax,(%esp)
8010144d:	e8 75 22 00 00       	call   801036c7 <log_write>
  brelse(bp);
80101452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 cf ed ff ff       	call   8010022c <brelse>
}
8010145d:	c9                   	leave  
8010145e:	c3                   	ret    

8010145f <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010145f:	55                   	push   %ebp
80101460:	89 e5                	mov    %esp,%ebp
80101462:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101465:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101473:	e9 03 01 00 00       	jmp    8010157b <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
80101478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147b:	85 c0                	test   %eax,%eax
8010147d:	79 05                	jns    80101484 <balloc+0x25>
8010147f:	05 ff 0f 00 00       	add    $0xfff,%eax
80101484:	c1 f8 0c             	sar    $0xc,%eax
80101487:	89 c2                	mov    %eax,%edx
80101489:	a1 58 1a 11 80       	mov    0x80111a58,%eax
8010148e:	01 d0                	add    %edx,%eax
80101490:	89 44 24 04          	mov    %eax,0x4(%esp)
80101494:	8b 45 08             	mov    0x8(%ebp),%eax
80101497:	89 04 24             	mov    %eax,(%esp)
8010149a:	e8 16 ed ff ff       	call   801001b5 <bread>
8010149f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014a9:	e9 9b 00 00 00       	jmp    80101549 <balloc+0xea>
      m = 1 << (bi % 8);
801014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b1:	25 07 00 00 80       	and    $0x80000007,%eax
801014b6:	85 c0                	test   %eax,%eax
801014b8:	79 05                	jns    801014bf <balloc+0x60>
801014ba:	48                   	dec    %eax
801014bb:	83 c8 f8             	or     $0xfffffff8,%eax
801014be:	40                   	inc    %eax
801014bf:	ba 01 00 00 00       	mov    $0x1,%edx
801014c4:	88 c1                	mov    %al,%cl
801014c6:	d3 e2                	shl    %cl,%edx
801014c8:	89 d0                	mov    %edx,%eax
801014ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d0:	85 c0                	test   %eax,%eax
801014d2:	79 03                	jns    801014d7 <balloc+0x78>
801014d4:	83 c0 07             	add    $0x7,%eax
801014d7:	c1 f8 03             	sar    $0x3,%eax
801014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014dd:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
801014e1:	0f b6 c0             	movzbl %al,%eax
801014e4:	23 45 e8             	and    -0x18(%ebp),%eax
801014e7:	85 c0                	test   %eax,%eax
801014e9:	75 5b                	jne    80101546 <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
801014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ee:	85 c0                	test   %eax,%eax
801014f0:	79 03                	jns    801014f5 <balloc+0x96>
801014f2:	83 c0 07             	add    $0x7,%eax
801014f5:	c1 f8 03             	sar    $0x3,%eax
801014f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014fb:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
801014ff:	88 d1                	mov    %dl,%cl
80101501:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101504:	09 ca                	or     %ecx,%edx
80101506:	88 d1                	mov    %dl,%cl
80101508:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010150b:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010150f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101512:	89 04 24             	mov    %eax,(%esp)
80101515:	e8 ad 21 00 00       	call   801036c7 <log_write>
        brelse(bp);
8010151a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010151d:	89 04 24             	mov    %eax,(%esp)
80101520:	e8 07 ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101528:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152b:	01 c2                	add    %eax,%edx
8010152d:	8b 45 08             	mov    0x8(%ebp),%eax
80101530:	89 54 24 04          	mov    %edx,0x4(%esp)
80101534:	89 04 24             	mov    %eax,(%esp)
80101537:	e8 d2 fe ff ff       	call   8010140e <bzero>
        return b + bi;
8010153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101542:	01 d0                	add    %edx,%eax
80101544:	eb 51                	jmp    80101597 <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101546:	ff 45 f0             	incl   -0x10(%ebp)
80101549:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101550:	7f 17                	jg     80101569 <balloc+0x10a>
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101558:	01 d0                	add    %edx,%eax
8010155a:	89 c2                	mov    %eax,%edx
8010155c:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101561:	39 c2                	cmp    %eax,%edx
80101563:	0f 82 45 ff ff ff    	jb     801014ae <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101569:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010156c:	89 04 24             	mov    %eax,(%esp)
8010156f:	e8 b8 ec ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101574:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010157b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157e:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101583:	39 c2                	cmp    %eax,%edx
80101585:	0f 82 ed fe ff ff    	jb     80101478 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010158b:	c7 04 24 58 82 10 80 	movl   $0x80108258,(%esp)
80101592:	e8 bd ef ff ff       	call   80100554 <panic>
}
80101597:	c9                   	leave  
80101598:	c3                   	ret    

80101599 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101599:	55                   	push   %ebp
8010159a:	89 e5                	mov    %esp,%ebp
8010159c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010159f:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
801015a6:	80 
801015a7:	8b 45 08             	mov    0x8(%ebp),%eax
801015aa:	89 04 24             	mov    %eax,(%esp)
801015ad:	e8 16 fe ff ff       	call   801013c8 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801015b5:	c1 e8 0c             	shr    $0xc,%eax
801015b8:	89 c2                	mov    %eax,%edx
801015ba:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801015bf:	01 c2                	add    %eax,%edx
801015c1:	8b 45 08             	mov    0x8(%ebp),%eax
801015c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801015c8:	89 04 24             	mov    %eax,(%esp)
801015cb:	e8 e5 eb ff ff       	call   801001b5 <bread>
801015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d6:	25 ff 0f 00 00       	and    $0xfff,%eax
801015db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e1:	25 07 00 00 80       	and    $0x80000007,%eax
801015e6:	85 c0                	test   %eax,%eax
801015e8:	79 05                	jns    801015ef <bfree+0x56>
801015ea:	48                   	dec    %eax
801015eb:	83 c8 f8             	or     $0xfffffff8,%eax
801015ee:	40                   	inc    %eax
801015ef:	ba 01 00 00 00       	mov    $0x1,%edx
801015f4:	88 c1                	mov    %al,%cl
801015f6:	d3 e2                	shl    %cl,%edx
801015f8:	89 d0                	mov    %edx,%eax
801015fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101600:	85 c0                	test   %eax,%eax
80101602:	79 03                	jns    80101607 <bfree+0x6e>
80101604:	83 c0 07             	add    $0x7,%eax
80101607:	c1 f8 03             	sar    $0x3,%eax
8010160a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010160d:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101611:	0f b6 c0             	movzbl %al,%eax
80101614:	23 45 ec             	and    -0x14(%ebp),%eax
80101617:	85 c0                	test   %eax,%eax
80101619:	75 0c                	jne    80101627 <bfree+0x8e>
    panic("freeing free block");
8010161b:	c7 04 24 6e 82 10 80 	movl   $0x8010826e,(%esp)
80101622:	e8 2d ef ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
80101627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162a:	85 c0                	test   %eax,%eax
8010162c:	79 03                	jns    80101631 <bfree+0x98>
8010162e:	83 c0 07             	add    $0x7,%eax
80101631:	c1 f8 03             	sar    $0x3,%eax
80101634:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101637:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
8010163b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010163e:	f7 d1                	not    %ecx
80101640:	21 ca                	and    %ecx,%edx
80101642:	88 d1                	mov    %dl,%cl
80101644:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101647:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010164e:	89 04 24             	mov    %eax,(%esp)
80101651:	e8 71 20 00 00       	call   801036c7 <log_write>
  brelse(bp);
80101656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101659:	89 04 24             	mov    %eax,(%esp)
8010165c:	e8 cb eb ff ff       	call   8010022c <brelse>
}
80101661:	c9                   	leave  
80101662:	c3                   	ret    

80101663 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101663:	55                   	push   %ebp
80101664:	89 e5                	mov    %esp,%ebp
80101666:	57                   	push   %edi
80101667:	56                   	push   %esi
80101668:	53                   	push   %ebx
80101669:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
8010166c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101673:	c7 44 24 04 81 82 10 	movl   $0x80108281,0x4(%esp)
8010167a:	80 
8010167b:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101682:	e8 23 37 00 00       	call   80104daa <initlock>
  for(i = 0; i < NINODE; i++) {
80101687:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010168e:	eb 2b                	jmp    801016bb <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101693:	89 d0                	mov    %edx,%eax
80101695:	c1 e0 03             	shl    $0x3,%eax
80101698:	01 d0                	add    %edx,%eax
8010169a:	c1 e0 04             	shl    $0x4,%eax
8010169d:	83 c0 30             	add    $0x30,%eax
801016a0:	05 60 1a 11 80       	add    $0x80111a60,%eax
801016a5:	83 c0 10             	add    $0x10,%eax
801016a8:	c7 44 24 04 88 82 10 	movl   $0x80108288,0x4(%esp)
801016af:	80 
801016b0:	89 04 24             	mov    %eax,(%esp)
801016b3:	e8 b4 35 00 00       	call   80104c6c <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801016b8:	ff 45 e4             	incl   -0x1c(%ebp)
801016bb:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016bf:	7e cf                	jle    80101690 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801016c1:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
801016c8:	80 
801016c9:	8b 45 08             	mov    0x8(%ebp),%eax
801016cc:	89 04 24             	mov    %eax,(%esp)
801016cf:	e8 f4 fc ff ff       	call   801013c8 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d4:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801016d9:	8b 3d 54 1a 11 80    	mov    0x80111a54,%edi
801016df:	8b 35 50 1a 11 80    	mov    0x80111a50,%esi
801016e5:	8b 1d 4c 1a 11 80    	mov    0x80111a4c,%ebx
801016eb:	8b 0d 48 1a 11 80    	mov    0x80111a48,%ecx
801016f1:	8b 15 44 1a 11 80    	mov    0x80111a44,%edx
801016f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801016fa:	8b 15 40 1a 11 80    	mov    0x80111a40,%edx
80101700:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101704:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101708:	89 74 24 14          	mov    %esi,0x14(%esp)
8010170c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101710:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101714:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101717:	89 44 24 08          	mov    %eax,0x8(%esp)
8010171b:	89 d0                	mov    %edx,%eax
8010171d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101721:	c7 04 24 90 82 10 80 	movl   $0x80108290,(%esp)
80101728:	e8 94 ec ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010172d:	83 c4 4c             	add    $0x4c,%esp
80101730:	5b                   	pop    %ebx
80101731:	5e                   	pop    %esi
80101732:	5f                   	pop    %edi
80101733:	5d                   	pop    %ebp
80101734:	c3                   	ret    

80101735 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101735:	55                   	push   %ebp
80101736:	89 e5                	mov    %esp,%ebp
80101738:	83 ec 28             	sub    $0x28,%esp
8010173b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010173e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101742:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101749:	e9 9b 00 00 00       	jmp    801017e9 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
8010174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	89 c2                	mov    %eax,%edx
80101756:	a1 54 1a 11 80       	mov    0x80111a54,%eax
8010175b:	01 d0                	add    %edx,%eax
8010175d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101761:	8b 45 08             	mov    0x8(%ebp),%eax
80101764:	89 04 24             	mov    %eax,(%esp)
80101767:	e8 49 ea ff ff       	call   801001b5 <bread>
8010176c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101772:	8d 50 5c             	lea    0x5c(%eax),%edx
80101775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101778:	83 e0 07             	and    $0x7,%eax
8010177b:	c1 e0 06             	shl    $0x6,%eax
8010177e:	01 d0                	add    %edx,%eax
80101780:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101783:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101786:	8b 00                	mov    (%eax),%eax
80101788:	66 85 c0             	test   %ax,%ax
8010178b:	75 4e                	jne    801017db <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
8010178d:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101794:	00 
80101795:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010179c:	00 
8010179d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a0:	89 04 24             	mov    %eax,(%esp)
801017a3:	e8 86 38 00 00       	call   8010502e <memset>
      dip->type = type;
801017a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801017ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017ae:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b4:	89 04 24             	mov    %eax,(%esp)
801017b7:	e8 0b 1f 00 00       	call   801036c7 <log_write>
      brelse(bp);
801017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bf:	89 04 24             	mov    %eax,(%esp)
801017c2:	e8 65 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
801017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801017ce:	8b 45 08             	mov    0x8(%ebp),%eax
801017d1:	89 04 24             	mov    %eax,(%esp)
801017d4:	e8 ea 00 00 00       	call   801018c3 <iget>
801017d9:	eb 2a                	jmp    80101805 <ialloc+0xd0>
    }
    brelse(bp);
801017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017de:	89 04 24             	mov    %eax,(%esp)
801017e1:	e8 46 ea ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017e6:	ff 45 f4             	incl   -0xc(%ebp)
801017e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017ec:	a1 48 1a 11 80       	mov    0x80111a48,%eax
801017f1:	39 c2                	cmp    %eax,%edx
801017f3:	0f 82 55 ff ff ff    	jb     8010174e <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801017f9:	c7 04 24 e3 82 10 80 	movl   $0x801082e3,(%esp)
80101800:	e8 4f ed ff ff       	call   80100554 <panic>
}
80101805:	c9                   	leave  
80101806:	c3                   	ret    

80101807 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101807:	55                   	push   %ebp
80101808:	89 e5                	mov    %esp,%ebp
8010180a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180d:	8b 45 08             	mov    0x8(%ebp),%eax
80101810:	8b 40 04             	mov    0x4(%eax),%eax
80101813:	c1 e8 03             	shr    $0x3,%eax
80101816:	89 c2                	mov    %eax,%edx
80101818:	a1 54 1a 11 80       	mov    0x80111a54,%eax
8010181d:	01 c2                	add    %eax,%edx
8010181f:	8b 45 08             	mov    0x8(%ebp),%eax
80101822:	8b 00                	mov    (%eax),%eax
80101824:	89 54 24 04          	mov    %edx,0x4(%esp)
80101828:	89 04 24             	mov    %eax,(%esp)
8010182b:	e8 85 e9 ff ff       	call   801001b5 <bread>
80101830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101836:	8d 50 5c             	lea    0x5c(%eax),%edx
80101839:	8b 45 08             	mov    0x8(%ebp),%eax
8010183c:	8b 40 04             	mov    0x4(%eax),%eax
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	01 d0                	add    %edx,%eax
80101847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010184a:	8b 45 08             	mov    0x8(%ebp),%eax
8010184d:	8b 40 50             	mov    0x50(%eax),%eax
80101850:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101853:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101856:	8b 45 08             	mov    0x8(%ebp),%eax
80101859:	66 8b 40 52          	mov    0x52(%eax),%ax
8010185d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101860:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
80101867:	8b 40 54             	mov    0x54(%eax),%eax
8010186a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010186d:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
80101871:	8b 45 08             	mov    0x8(%ebp),%eax
80101874:	66 8b 40 56          	mov    0x56(%eax),%ax
80101878:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010187b:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	8b 50 58             	mov    0x58(%eax),%edx
80101885:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101888:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010188b:	8b 45 08             	mov    0x8(%ebp),%eax
8010188e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101894:	83 c0 0c             	add    $0xc,%eax
80101897:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010189e:	00 
8010189f:	89 54 24 04          	mov    %edx,0x4(%esp)
801018a3:	89 04 24             	mov    %eax,(%esp)
801018a6:	e8 4c 38 00 00       	call   801050f7 <memmove>
  log_write(bp);
801018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ae:	89 04 24             	mov    %eax,(%esp)
801018b1:	e8 11 1e 00 00       	call   801036c7 <log_write>
  brelse(bp);
801018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b9:	89 04 24             	mov    %eax,(%esp)
801018bc:	e8 6b e9 ff ff       	call   8010022c <brelse>
}
801018c1:	c9                   	leave  
801018c2:	c3                   	ret    

801018c3 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018c3:	55                   	push   %ebp
801018c4:	89 e5                	mov    %esp,%ebp
801018c6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018c9:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801018d0:	e8 f6 34 00 00       	call   80104dcb <acquire>

  // Is the inode already cached?
  empty = 0;
801018d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018dc:	c7 45 f4 94 1a 11 80 	movl   $0x80111a94,-0xc(%ebp)
801018e3:	eb 5c                	jmp    80101941 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e8:	8b 40 08             	mov    0x8(%eax),%eax
801018eb:	85 c0                	test   %eax,%eax
801018ed:	7e 35                	jle    80101924 <iget+0x61>
801018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f2:	8b 00                	mov    (%eax),%eax
801018f4:	3b 45 08             	cmp    0x8(%ebp),%eax
801018f7:	75 2b                	jne    80101924 <iget+0x61>
801018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fc:	8b 40 04             	mov    0x4(%eax),%eax
801018ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101902:	75 20                	jne    80101924 <iget+0x61>
      ip->ref++;
80101904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101907:	8b 40 08             	mov    0x8(%eax),%eax
8010190a:	8d 50 01             	lea    0x1(%eax),%edx
8010190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101910:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101913:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010191a:	e8 16 35 00 00       	call   80104e35 <release>
      return ip;
8010191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101922:	eb 72                	jmp    80101996 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101924:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101928:	75 10                	jne    8010193a <iget+0x77>
8010192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192d:	8b 40 08             	mov    0x8(%eax),%eax
80101930:	85 c0                	test   %eax,%eax
80101932:	75 06                	jne    8010193a <iget+0x77>
      empty = ip;
80101934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101937:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010193a:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101941:	81 7d f4 b4 36 11 80 	cmpl   $0x801136b4,-0xc(%ebp)
80101948:	72 9b                	jb     801018e5 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010194a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010194e:	75 0c                	jne    8010195c <iget+0x99>
    panic("iget: no inodes");
80101950:	c7 04 24 f5 82 10 80 	movl   $0x801082f5,(%esp)
80101957:	e8 f8 eb ff ff       	call   80100554 <panic>

  ip = empty;
8010195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101965:	8b 55 08             	mov    0x8(%ebp),%edx
80101968:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101970:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101976:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
8010197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101980:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101987:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010198e:	e8 a2 34 00 00       	call   80104e35 <release>

  return ip;
80101993:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101996:	c9                   	leave  
80101997:	c3                   	ret    

80101998 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101998:	55                   	push   %ebp
80101999:	89 e5                	mov    %esp,%ebp
8010199b:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010199e:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801019a5:	e8 21 34 00 00       	call   80104dcb <acquire>
  ip->ref++;
801019aa:	8b 45 08             	mov    0x8(%ebp),%eax
801019ad:	8b 40 08             	mov    0x8(%eax),%eax
801019b0:	8d 50 01             	lea    0x1(%eax),%edx
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
801019b6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019b9:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801019c0:	e8 70 34 00 00       	call   80104e35 <release>
  return ip;
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019c8:	c9                   	leave  
801019c9:	c3                   	ret    

801019ca <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019ca:	55                   	push   %ebp
801019cb:	89 e5                	mov    %esp,%ebp
801019cd:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019d4:	74 0a                	je     801019e0 <ilock+0x16>
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	8b 40 08             	mov    0x8(%eax),%eax
801019dc:	85 c0                	test   %eax,%eax
801019de:	7f 0c                	jg     801019ec <ilock+0x22>
    panic("ilock");
801019e0:	c7 04 24 05 83 10 80 	movl   $0x80108305,(%esp)
801019e7:	e8 68 eb ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	83 c0 0c             	add    $0xc,%eax
801019f2:	89 04 24             	mov    %eax,(%esp)
801019f5:	e8 ac 32 00 00       	call   80104ca6 <acquiresleep>

  if(ip->valid == 0){
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a00:	85 c0                	test   %eax,%eax
80101a02:	0f 85 ca 00 00 00    	jne    80101ad2 <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	8b 40 04             	mov    0x4(%eax),%eax
80101a0e:	c1 e8 03             	shr    $0x3,%eax
80101a11:	89 c2                	mov    %eax,%edx
80101a13:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101a18:	01 c2                	add    %eax,%edx
80101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1d:	8b 00                	mov    (%eax),%eax
80101a1f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a23:	89 04 24             	mov    %eax,(%esp)
80101a26:	e8 8a e7 ff ff       	call   801001b5 <bread>
80101a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a31:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a34:	8b 45 08             	mov    0x8(%ebp),%eax
80101a37:	8b 40 04             	mov    0x4(%eax),%eax
80101a3a:	83 e0 07             	and    $0x7,%eax
80101a3d:	c1 e0 06             	shl    $0x6,%eax
80101a40:	01 d0                	add    %edx,%eax
80101a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a48:	8b 00                	mov    (%eax),%eax
80101a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4d:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a54:	66 8b 40 02          	mov    0x2(%eax),%ax
80101a58:	8b 55 08             	mov    0x8(%ebp),%edx
80101a5b:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a62:	8b 40 04             	mov    0x4(%eax),%eax
80101a65:	8b 55 08             	mov    0x8(%ebp),%edx
80101a68:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6f:	66 8b 40 06          	mov    0x6(%eax),%ax
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7d:	8b 50 08             	mov    0x8(%eax),%edx
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a89:	8d 50 0c             	lea    0xc(%eax),%edx
80101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8f:	83 c0 5c             	add    $0x5c,%eax
80101a92:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a99:	00 
80101a9a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a9e:	89 04 24             	mov    %eax,(%esp)
80101aa1:	e8 51 36 00 00       	call   801050f7 <memmove>
    brelse(bp);
80101aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa9:	89 04 24             	mov    %eax,(%esp)
80101aac:	e8 7b e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	8b 40 50             	mov    0x50(%eax),%eax
80101ac1:	66 85 c0             	test   %ax,%ax
80101ac4:	75 0c                	jne    80101ad2 <ilock+0x108>
      panic("ilock: no type");
80101ac6:	c7 04 24 0b 83 10 80 	movl   $0x8010830b,(%esp)
80101acd:	e8 82 ea ff ff       	call   80100554 <panic>
  }
}
80101ad2:	c9                   	leave  
80101ad3:	c3                   	ret    

80101ad4 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ada:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ade:	74 1c                	je     80101afc <iunlock+0x28>
80101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae3:	83 c0 0c             	add    $0xc,%eax
80101ae6:	89 04 24             	mov    %eax,(%esp)
80101ae9:	e8 55 32 00 00       	call   80104d43 <holdingsleep>
80101aee:	85 c0                	test   %eax,%eax
80101af0:	74 0a                	je     80101afc <iunlock+0x28>
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	8b 40 08             	mov    0x8(%eax),%eax
80101af8:	85 c0                	test   %eax,%eax
80101afa:	7f 0c                	jg     80101b08 <iunlock+0x34>
    panic("iunlock");
80101afc:	c7 04 24 1a 83 10 80 	movl   $0x8010831a,(%esp)
80101b03:	e8 4c ea ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101b08:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0b:	83 c0 0c             	add    $0xc,%eax
80101b0e:	89 04 24             	mov    %eax,(%esp)
80101b11:	e8 eb 31 00 00       	call   80104d01 <releasesleep>
}
80101b16:	c9                   	leave  
80101b17:	c3                   	ret    

80101b18 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b18:	55                   	push   %ebp
80101b19:	89 e5                	mov    %esp,%ebp
80101b1b:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	83 c0 0c             	add    $0xc,%eax
80101b24:	89 04 24             	mov    %eax,(%esp)
80101b27:	e8 7a 31 00 00       	call   80104ca6 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2f:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b32:	85 c0                	test   %eax,%eax
80101b34:	74 5c                	je     80101b92 <iput+0x7a>
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	66 8b 40 56          	mov    0x56(%eax),%ax
80101b3d:	66 85 c0             	test   %ax,%ax
80101b40:	75 50                	jne    80101b92 <iput+0x7a>
    acquire(&icache.lock);
80101b42:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b49:	e8 7d 32 00 00       	call   80104dcb <acquire>
    int r = ip->ref;
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	8b 40 08             	mov    0x8(%eax),%eax
80101b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b57:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b5e:	e8 d2 32 00 00       	call   80104e35 <release>
    if(r == 1){
80101b63:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101b67:	75 29                	jne    80101b92 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	89 04 24             	mov    %eax,(%esp)
80101b6f:	e8 86 01 00 00       	call   80101cfa <itrunc>
      ip->type = 0;
80101b74:	8b 45 08             	mov    0x8(%ebp),%eax
80101b77:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	89 04 24             	mov    %eax,(%esp)
80101b83:	e8 7f fc ff ff       	call   80101807 <iupdate>
      ip->valid = 0;
80101b88:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101b92:	8b 45 08             	mov    0x8(%ebp),%eax
80101b95:	83 c0 0c             	add    $0xc,%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 61 31 00 00       	call   80104d01 <releasesleep>

  acquire(&icache.lock);
80101ba0:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101ba7:	e8 1f 32 00 00       	call   80104dcb <acquire>
  ip->ref--;
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	8b 40 08             	mov    0x8(%eax),%eax
80101bb2:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bbb:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101bc2:	e8 6e 32 00 00       	call   80104e35 <release>
}
80101bc7:	c9                   	leave  
80101bc8:	c3                   	ret    

80101bc9 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bc9:	55                   	push   %ebp
80101bca:	89 e5                	mov    %esp,%ebp
80101bcc:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd2:	89 04 24             	mov    %eax,(%esp)
80101bd5:	e8 fa fe ff ff       	call   80101ad4 <iunlock>
  iput(ip);
80101bda:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdd:	89 04 24             	mov    %eax,(%esp)
80101be0:	e8 33 ff ff ff       	call   80101b18 <iput>
}
80101be5:	c9                   	leave  
80101be6:	c3                   	ret    

80101be7 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101be7:	55                   	push   %ebp
80101be8:	89 e5                	mov    %esp,%ebp
80101bea:	53                   	push   %ebx
80101beb:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bee:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf2:	77 3e                	ja     80101c32 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bfa:	83 c2 14             	add    $0x14,%edx
80101bfd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c08:	75 20                	jne    80101c2a <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	8b 00                	mov    (%eax),%eax
80101c0f:	89 04 24             	mov    %eax,(%esp)
80101c12:	e8 48 f8 ff ff       	call   8010145f <balloc>
80101c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c20:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c26:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2d:	e9 c2 00 00 00       	jmp    80101cf4 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101c32:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c36:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c3a:	0f 87 a8 00 00 00    	ja     80101ce8 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c50:	75 1c                	jne    80101c6e <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c52:	8b 45 08             	mov    0x8(%ebp),%eax
80101c55:	8b 00                	mov    (%eax),%eax
80101c57:	89 04 24             	mov    %eax,(%esp)
80101c5a:	e8 00 f8 ff ff       	call   8010145f <balloc>
80101c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c68:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c71:	8b 00                	mov    (%eax),%eax
80101c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c76:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c7a:	89 04 24             	mov    %eax,(%esp)
80101c7d:	e8 33 e5 ff ff       	call   801001b5 <bread>
80101c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c88:	83 c0 5c             	add    $0x5c,%eax
80101c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9b:	01 d0                	add    %edx,%eax
80101c9d:	8b 00                	mov    (%eax),%eax
80101c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ca6:	75 30                	jne    80101cd8 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	8b 00                	mov    (%eax),%eax
80101cbd:	89 04 24             	mov    %eax,(%esp)
80101cc0:	e8 9a f7 ff ff       	call   8010145f <balloc>
80101cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ccb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd0:	89 04 24             	mov    %eax,(%esp)
80101cd3:	e8 ef 19 00 00       	call   801036c7 <log_write>
    }
    brelse(bp);
80101cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cdb:	89 04 24             	mov    %eax,(%esp)
80101cde:	e8 49 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ce6:	eb 0c                	jmp    80101cf4 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101ce8:	c7 04 24 22 83 10 80 	movl   $0x80108322,(%esp)
80101cef:	e8 60 e8 ff ff       	call   80100554 <panic>
}
80101cf4:	83 c4 24             	add    $0x24,%esp
80101cf7:	5b                   	pop    %ebx
80101cf8:	5d                   	pop    %ebp
80101cf9:	c3                   	ret    

80101cfa <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cfa:	55                   	push   %ebp
80101cfb:	89 e5                	mov    %esp,%ebp
80101cfd:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d07:	eb 43                	jmp    80101d4c <itrunc+0x52>
    if(ip->addrs[i]){
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d0f:	83 c2 14             	add    $0x14,%edx
80101d12:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d16:	85 c0                	test   %eax,%eax
80101d18:	74 2f                	je     80101d49 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d20:	83 c2 14             	add    $0x14,%edx
80101d23:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	8b 00                	mov    (%eax),%eax
80101d2c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d30:	89 04 24             	mov    %eax,(%esp)
80101d33:	e8 61 f8 ff ff       	call   80101599 <bfree>
      ip->addrs[i] = 0;
80101d38:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d3e:	83 c2 14             	add    $0x14,%edx
80101d41:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d48:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d49:	ff 45 f4             	incl   -0xc(%ebp)
80101d4c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d50:	7e b7                	jle    80101d09 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d5b:	85 c0                	test   %eax,%eax
80101d5d:	0f 84 a3 00 00 00    	je     80101e06 <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 00                	mov    (%eax),%eax
80101d71:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d75:	89 04 24             	mov    %eax,(%esp)
80101d78:	e8 38 e4 ff ff       	call   801001b5 <bread>
80101d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d83:	83 c0 5c             	add    $0x5c,%eax
80101d86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d90:	eb 3a                	jmp    80101dcc <itrunc+0xd2>
      if(a[j])
80101d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d9f:	01 d0                	add    %edx,%eax
80101da1:	8b 00                	mov    (%eax),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	74 22                	je     80101dc9 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101daa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101db4:	01 d0                	add    %edx,%eax
80101db6:	8b 10                	mov    (%eax),%edx
80101db8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbb:	8b 00                	mov    (%eax),%eax
80101dbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dc1:	89 04 24             	mov    %eax,(%esp)
80101dc4:	e8 d0 f7 ff ff       	call   80101599 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dc9:	ff 45 f0             	incl   -0x10(%ebp)
80101dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dcf:	83 f8 7f             	cmp    $0x7f,%eax
80101dd2:	76 be                	jbe    80101d92 <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dd7:	89 04 24             	mov    %eax,(%esp)
80101dda:	e8 4d e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80101de2:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101de8:	8b 45 08             	mov    0x8(%ebp),%eax
80101deb:	8b 00                	mov    (%eax),%eax
80101ded:	89 54 24 04          	mov    %edx,0x4(%esp)
80101df1:	89 04 24             	mov    %eax,(%esp)
80101df4:	e8 a0 f7 ff ff       	call   80101599 <bfree>
    ip->addrs[NDIRECT] = 0;
80101df9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfc:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e03:	00 00 00 
  }

  ip->size = 0;
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e10:	8b 45 08             	mov    0x8(%ebp),%eax
80101e13:	89 04 24             	mov    %eax,(%esp)
80101e16:	e8 ec f9 ff ff       	call   80101807 <iupdate>
}
80101e1b:	c9                   	leave  
80101e1c:	c3                   	ret    

80101e1d <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e1d:	55                   	push   %ebp
80101e1e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	8b 00                	mov    (%eax),%eax
80101e25:	89 c2                	mov    %eax,%edx
80101e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e30:	8b 50 04             	mov    0x4(%eax),%edx
80101e33:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e36:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e39:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3c:	8b 40 50             	mov    0x50(%eax),%eax
80101e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e42:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101e45:	8b 45 08             	mov    0x8(%ebp),%eax
80101e48:	66 8b 40 56          	mov    0x56(%eax),%ax
80101e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e4f:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101e53:	8b 45 08             	mov    0x8(%ebp),%eax
80101e56:	8b 50 58             	mov    0x58(%eax),%edx
80101e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5c:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e5f:	5d                   	pop    %ebp
80101e60:	c3                   	ret    

80101e61 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e61:	55                   	push   %ebp
80101e62:	89 e5                	mov    %esp,%ebp
80101e64:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	8b 40 50             	mov    0x50(%eax),%eax
80101e6d:	66 83 f8 03          	cmp    $0x3,%ax
80101e71:	75 60                	jne    80101ed3 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e73:	8b 45 08             	mov    0x8(%ebp),%eax
80101e76:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e7a:	66 85 c0             	test   %ax,%ax
80101e7d:	78 20                	js     80101e9f <readi+0x3e>
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e86:	66 83 f8 09          	cmp    $0x9,%ax
80101e8a:	7f 13                	jg     80101e9f <readi+0x3e>
80101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8f:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e93:	98                   	cwtl   
80101e94:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101e9b:	85 c0                	test   %eax,%eax
80101e9d:	75 0a                	jne    80101ea9 <readi+0x48>
      return -1;
80101e9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea4:	e9 1a 01 00 00       	jmp    80101fc3 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eac:	66 8b 40 52          	mov    0x52(%eax),%ax
80101eb0:	98                   	cwtl   
80101eb1:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101eb8:	8b 55 14             	mov    0x14(%ebp),%edx
80101ebb:	89 54 24 08          	mov    %edx,0x8(%esp)
80101ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ec6:	8b 55 08             	mov    0x8(%ebp),%edx
80101ec9:	89 14 24             	mov    %edx,(%esp)
80101ecc:	ff d0                	call   *%eax
80101ece:	e9 f0 00 00 00       	jmp    80101fc3 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed6:	8b 40 58             	mov    0x58(%eax),%eax
80101ed9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101edc:	72 0d                	jb     80101eeb <readi+0x8a>
80101ede:	8b 45 14             	mov    0x14(%ebp),%eax
80101ee1:	8b 55 10             	mov    0x10(%ebp),%edx
80101ee4:	01 d0                	add    %edx,%eax
80101ee6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ee9:	73 0a                	jae    80101ef5 <readi+0x94>
    return -1;
80101eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef0:	e9 ce 00 00 00       	jmp    80101fc3 <readi+0x162>
  if(off + n > ip->size)
80101ef5:	8b 45 14             	mov    0x14(%ebp),%eax
80101ef8:	8b 55 10             	mov    0x10(%ebp),%edx
80101efb:	01 c2                	add    %eax,%edx
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	8b 40 58             	mov    0x58(%eax),%eax
80101f03:	39 c2                	cmp    %eax,%edx
80101f05:	76 0c                	jbe    80101f13 <readi+0xb2>
    n = ip->size - off;
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	8b 40 58             	mov    0x58(%eax),%eax
80101f0d:	2b 45 10             	sub    0x10(%ebp),%eax
80101f10:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f1a:	e9 95 00 00 00       	jmp    80101fb4 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f1f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f22:	c1 e8 09             	shr    $0x9,%eax
80101f25:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f29:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2c:	89 04 24             	mov    %eax,(%esp)
80101f2f:	e8 b3 fc ff ff       	call   80101be7 <bmap>
80101f34:	8b 55 08             	mov    0x8(%ebp),%edx
80101f37:	8b 12                	mov    (%edx),%edx
80101f39:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f3d:	89 14 24             	mov    %edx,(%esp)
80101f40:	e8 70 e2 ff ff       	call   801001b5 <bread>
80101f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f48:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f50:	89 c2                	mov    %eax,%edx
80101f52:	b8 00 02 00 00       	mov    $0x200,%eax
80101f57:	29 d0                	sub    %edx,%eax
80101f59:	89 c1                	mov    %eax,%ecx
80101f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f5e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f61:	29 c2                	sub    %eax,%edx
80101f63:	89 c8                	mov    %ecx,%eax
80101f65:	39 d0                	cmp    %edx,%eax
80101f67:	76 02                	jbe    80101f6b <readi+0x10a>
80101f69:	89 d0                	mov    %edx,%eax
80101f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f6e:	8b 45 10             	mov    0x10(%ebp),%eax
80101f71:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f76:	8d 50 50             	lea    0x50(%eax),%edx
80101f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f7c:	01 d0                	add    %edx,%eax
80101f7e:	8d 50 0c             	lea    0xc(%eax),%edx
80101f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f84:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f88:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f8f:	89 04 24             	mov    %eax,(%esp)
80101f92:	e8 60 31 00 00       	call   801050f7 <memmove>
    brelse(bp);
80101f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f9a:	89 04 24             	mov    %eax,(%esp)
80101f9d:	e8 8a e2 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fa5:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fab:	01 45 10             	add    %eax,0x10(%ebp)
80101fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb1:	01 45 0c             	add    %eax,0xc(%ebp)
80101fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fb7:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fba:	0f 82 5f ff ff ff    	jb     80101f1f <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fc0:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    

80101fc5 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fc5:	55                   	push   %ebp
80101fc6:	89 e5                	mov    %esp,%ebp
80101fc8:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	8b 40 50             	mov    0x50(%eax),%eax
80101fd1:	66 83 f8 03          	cmp    $0x3,%ax
80101fd5:	75 60                	jne    80102037 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fda:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fde:	66 85 c0             	test   %ax,%ax
80101fe1:	78 20                	js     80102003 <writei+0x3e>
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe6:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fea:	66 83 f8 09          	cmp    $0x9,%ax
80101fee:	7f 13                	jg     80102003 <writei+0x3e>
80101ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff3:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ff7:	98                   	cwtl   
80101ff8:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101fff:	85 c0                	test   %eax,%eax
80102001:	75 0a                	jne    8010200d <writei+0x48>
      return -1;
80102003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102008:	e9 45 01 00 00       	jmp    80102152 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
8010200d:	8b 45 08             	mov    0x8(%ebp),%eax
80102010:	66 8b 40 52          	mov    0x52(%eax),%ax
80102014:	98                   	cwtl   
80102015:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
8010201c:	8b 55 14             	mov    0x14(%ebp),%edx
8010201f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102023:	8b 55 0c             	mov    0xc(%ebp),%edx
80102026:	89 54 24 04          	mov    %edx,0x4(%esp)
8010202a:	8b 55 08             	mov    0x8(%ebp),%edx
8010202d:	89 14 24             	mov    %edx,(%esp)
80102030:	ff d0                	call   *%eax
80102032:	e9 1b 01 00 00       	jmp    80102152 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	8b 40 58             	mov    0x58(%eax),%eax
8010203d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102040:	72 0d                	jb     8010204f <writei+0x8a>
80102042:	8b 45 14             	mov    0x14(%ebp),%eax
80102045:	8b 55 10             	mov    0x10(%ebp),%edx
80102048:	01 d0                	add    %edx,%eax
8010204a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204d:	73 0a                	jae    80102059 <writei+0x94>
    return -1;
8010204f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102054:	e9 f9 00 00 00       	jmp    80102152 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80102059:	8b 45 14             	mov    0x14(%ebp),%eax
8010205c:	8b 55 10             	mov    0x10(%ebp),%edx
8010205f:	01 d0                	add    %edx,%eax
80102061:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102066:	76 0a                	jbe    80102072 <writei+0xad>
    return -1;
80102068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206d:	e9 e0 00 00 00       	jmp    80102152 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102079:	e9 a0 00 00 00       	jmp    8010211e <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010207e:	8b 45 10             	mov    0x10(%ebp),%eax
80102081:	c1 e8 09             	shr    $0x9,%eax
80102084:	89 44 24 04          	mov    %eax,0x4(%esp)
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	89 04 24             	mov    %eax,(%esp)
8010208e:	e8 54 fb ff ff       	call   80101be7 <bmap>
80102093:	8b 55 08             	mov    0x8(%ebp),%edx
80102096:	8b 12                	mov    (%edx),%edx
80102098:	89 44 24 04          	mov    %eax,0x4(%esp)
8010209c:	89 14 24             	mov    %edx,(%esp)
8010209f:	e8 11 e1 ff ff       	call   801001b5 <bread>
801020a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020a7:	8b 45 10             	mov    0x10(%ebp),%eax
801020aa:	25 ff 01 00 00       	and    $0x1ff,%eax
801020af:	89 c2                	mov    %eax,%edx
801020b1:	b8 00 02 00 00       	mov    $0x200,%eax
801020b6:	29 d0                	sub    %edx,%eax
801020b8:	89 c1                	mov    %eax,%ecx
801020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020bd:	8b 55 14             	mov    0x14(%ebp),%edx
801020c0:	29 c2                	sub    %eax,%edx
801020c2:	89 c8                	mov    %ecx,%eax
801020c4:	39 d0                	cmp    %edx,%eax
801020c6:	76 02                	jbe    801020ca <writei+0x105>
801020c8:	89 d0                	mov    %edx,%eax
801020ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020cd:	8b 45 10             	mov    0x10(%ebp),%eax
801020d0:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d5:	8d 50 50             	lea    0x50(%eax),%edx
801020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020db:	01 d0                	add    %edx,%eax
801020dd:	8d 50 0c             	lea    0xc(%eax),%edx
801020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801020e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801020ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ee:	89 14 24             	mov    %edx,(%esp)
801020f1:	e8 01 30 00 00       	call   801050f7 <memmove>
    log_write(bp);
801020f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020f9:	89 04 24             	mov    %eax,(%esp)
801020fc:	e8 c6 15 00 00       	call   801036c7 <log_write>
    brelse(bp);
80102101:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102104:	89 04 24             	mov    %eax,(%esp)
80102107:	e8 20 e1 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010210c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010210f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102115:	01 45 10             	add    %eax,0x10(%ebp)
80102118:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010211b:	01 45 0c             	add    %eax,0xc(%ebp)
8010211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102121:	3b 45 14             	cmp    0x14(%ebp),%eax
80102124:	0f 82 54 ff ff ff    	jb     8010207e <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010212a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010212e:	74 1f                	je     8010214f <writei+0x18a>
80102130:	8b 45 08             	mov    0x8(%ebp),%eax
80102133:	8b 40 58             	mov    0x58(%eax),%eax
80102136:	3b 45 10             	cmp    0x10(%ebp),%eax
80102139:	73 14                	jae    8010214f <writei+0x18a>
    ip->size = off;
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
8010213e:	8b 55 10             	mov    0x10(%ebp),%edx
80102141:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102144:	8b 45 08             	mov    0x8(%ebp),%eax
80102147:	89 04 24             	mov    %eax,(%esp)
8010214a:	e8 b8 f6 ff ff       	call   80101807 <iupdate>
  }
  return n;
8010214f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102152:	c9                   	leave  
80102153:	c3                   	ret    

80102154 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010215a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102161:	00 
80102162:	8b 45 0c             	mov    0xc(%ebp),%eax
80102165:	89 44 24 04          	mov    %eax,0x4(%esp)
80102169:	8b 45 08             	mov    0x8(%ebp),%eax
8010216c:	89 04 24             	mov    %eax,(%esp)
8010216f:	e8 22 30 00 00       	call   80105196 <strncmp>
}
80102174:	c9                   	leave  
80102175:	c3                   	ret    

80102176 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102176:	55                   	push   %ebp
80102177:	89 e5                	mov    %esp,%ebp
80102179:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010217c:	8b 45 08             	mov    0x8(%ebp),%eax
8010217f:	8b 40 50             	mov    0x50(%eax),%eax
80102182:	66 83 f8 01          	cmp    $0x1,%ax
80102186:	74 0c                	je     80102194 <dirlookup+0x1e>
    panic("dirlookup not DIR");
80102188:	c7 04 24 35 83 10 80 	movl   $0x80108335,(%esp)
8010218f:	e8 c0 e3 ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010219b:	e9 86 00 00 00       	jmp    80102226 <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021a7:	00 
801021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801021af:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b6:	8b 45 08             	mov    0x8(%ebp),%eax
801021b9:	89 04 24             	mov    %eax,(%esp)
801021bc:	e8 a0 fc ff ff       	call   80101e61 <readi>
801021c1:	83 f8 10             	cmp    $0x10,%eax
801021c4:	74 0c                	je     801021d2 <dirlookup+0x5c>
      panic("dirlookup read");
801021c6:	c7 04 24 47 83 10 80 	movl   $0x80108347,(%esp)
801021cd:	e8 82 e3 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
801021d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021d5:	66 85 c0             	test   %ax,%ax
801021d8:	75 02                	jne    801021dc <dirlookup+0x66>
      continue;
801021da:	eb 46                	jmp    80102222 <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
801021dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021df:	83 c0 02             	add    $0x2,%eax
801021e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e9:	89 04 24             	mov    %eax,(%esp)
801021ec:	e8 63 ff ff ff       	call   80102154 <namecmp>
801021f1:	85 c0                	test   %eax,%eax
801021f3:	75 2d                	jne    80102222 <dirlookup+0xac>
      // entry matches path element
      if(poff)
801021f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021f9:	74 08                	je     80102203 <dirlookup+0x8d>
        *poff = off;
801021fb:	8b 45 10             	mov    0x10(%ebp),%eax
801021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102201:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102203:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102206:	0f b7 c0             	movzwl %ax,%eax
80102209:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010220c:	8b 45 08             	mov    0x8(%ebp),%eax
8010220f:	8b 00                	mov    (%eax),%eax
80102211:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102214:	89 54 24 04          	mov    %edx,0x4(%esp)
80102218:	89 04 24             	mov    %eax,(%esp)
8010221b:	e8 a3 f6 ff ff       	call   801018c3 <iget>
80102220:	eb 18                	jmp    8010223a <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102222:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102226:	8b 45 08             	mov    0x8(%ebp),%eax
80102229:	8b 40 58             	mov    0x58(%eax),%eax
8010222c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010222f:	0f 87 6b ff ff ff    	ja     801021a0 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102235:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223a:	c9                   	leave  
8010223b:	c3                   	ret    

8010223c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010223c:	55                   	push   %ebp
8010223d:	89 e5                	mov    %esp,%ebp
8010223f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102242:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102249:	00 
8010224a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010224d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102251:	8b 45 08             	mov    0x8(%ebp),%eax
80102254:	89 04 24             	mov    %eax,(%esp)
80102257:	e8 1a ff ff ff       	call   80102176 <dirlookup>
8010225c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010225f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102263:	74 15                	je     8010227a <dirlink+0x3e>
    iput(ip);
80102265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102268:	89 04 24             	mov    %eax,(%esp)
8010226b:	e8 a8 f8 ff ff       	call   80101b18 <iput>
    return -1;
80102270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102275:	e9 b6 00 00 00       	jmp    80102330 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102281:	eb 45                	jmp    801022c8 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102286:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010228d:	00 
8010228e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102292:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102295:	89 44 24 04          	mov    %eax,0x4(%esp)
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
8010229c:	89 04 24             	mov    %eax,(%esp)
8010229f:	e8 bd fb ff ff       	call   80101e61 <readi>
801022a4:	83 f8 10             	cmp    $0x10,%eax
801022a7:	74 0c                	je     801022b5 <dirlink+0x79>
      panic("dirlink read");
801022a9:	c7 04 24 56 83 10 80 	movl   $0x80108356,(%esp)
801022b0:	e8 9f e2 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
801022b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022b8:	66 85 c0             	test   %ax,%ax
801022bb:	75 02                	jne    801022bf <dirlink+0x83>
      break;
801022bd:	eb 16                	jmp    801022d5 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c2:	83 c0 10             	add    $0x10,%eax
801022c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
801022ce:	8b 40 58             	mov    0x58(%eax),%eax
801022d1:	39 c2                	cmp    %eax,%edx
801022d3:	72 ae                	jb     80102283 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801022d5:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022dc:	00 
801022dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e7:	83 c0 02             	add    $0x2,%eax
801022ea:	89 04 24             	mov    %eax,(%esp)
801022ed:	e8 f2 2e 00 00       	call   801051e4 <strncpy>
  de.inum = inum;
801022f2:	8b 45 10             	mov    0x10(%ebp),%eax
801022f5:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fc:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102303:	00 
80102304:	89 44 24 08          	mov    %eax,0x8(%esp)
80102308:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010230b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010230f:	8b 45 08             	mov    0x8(%ebp),%eax
80102312:	89 04 24             	mov    %eax,(%esp)
80102315:	e8 ab fc ff ff       	call   80101fc5 <writei>
8010231a:	83 f8 10             	cmp    $0x10,%eax
8010231d:	74 0c                	je     8010232b <dirlink+0xef>
    panic("dirlink");
8010231f:	c7 04 24 63 83 10 80 	movl   $0x80108363,(%esp)
80102326:	e8 29 e2 ff ff       	call   80100554 <panic>

  return 0;
8010232b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102330:	c9                   	leave  
80102331:	c3                   	ret    

80102332 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102332:	55                   	push   %ebp
80102333:	89 e5                	mov    %esp,%ebp
80102335:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102338:	eb 03                	jmp    8010233d <skipelem+0xb>
    path++;
8010233a:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010233d:	8b 45 08             	mov    0x8(%ebp),%eax
80102340:	8a 00                	mov    (%eax),%al
80102342:	3c 2f                	cmp    $0x2f,%al
80102344:	74 f4                	je     8010233a <skipelem+0x8>
    path++;
  if(*path == 0)
80102346:	8b 45 08             	mov    0x8(%ebp),%eax
80102349:	8a 00                	mov    (%eax),%al
8010234b:	84 c0                	test   %al,%al
8010234d:	75 0a                	jne    80102359 <skipelem+0x27>
    return 0;
8010234f:	b8 00 00 00 00       	mov    $0x0,%eax
80102354:	e9 81 00 00 00       	jmp    801023da <skipelem+0xa8>
  s = path;
80102359:	8b 45 08             	mov    0x8(%ebp),%eax
8010235c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010235f:	eb 03                	jmp    80102364 <skipelem+0x32>
    path++;
80102361:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102364:	8b 45 08             	mov    0x8(%ebp),%eax
80102367:	8a 00                	mov    (%eax),%al
80102369:	3c 2f                	cmp    $0x2f,%al
8010236b:	74 09                	je     80102376 <skipelem+0x44>
8010236d:	8b 45 08             	mov    0x8(%ebp),%eax
80102370:	8a 00                	mov    (%eax),%al
80102372:	84 c0                	test   %al,%al
80102374:	75 eb                	jne    80102361 <skipelem+0x2f>
    path++;
  len = path - s;
80102376:	8b 55 08             	mov    0x8(%ebp),%edx
80102379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237c:	29 c2                	sub    %eax,%edx
8010237e:	89 d0                	mov    %edx,%eax
80102380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102383:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102387:	7e 1c                	jle    801023a5 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
80102389:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102390:	00 
80102391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102394:	89 44 24 04          	mov    %eax,0x4(%esp)
80102398:	8b 45 0c             	mov    0xc(%ebp),%eax
8010239b:	89 04 24             	mov    %eax,(%esp)
8010239e:	e8 54 2d 00 00       	call   801050f7 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023a3:	eb 29                	jmp    801023ce <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801023a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	89 44 24 04          	mov    %eax,0x4(%esp)
801023b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801023b6:	89 04 24             	mov    %eax,(%esp)
801023b9:	e8 39 2d 00 00       	call   801050f7 <memmove>
    name[len] = 0;
801023be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801023c4:	01 d0                	add    %edx,%eax
801023c6:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023c9:	eb 03                	jmp    801023ce <skipelem+0x9c>
    path++;
801023cb:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023ce:	8b 45 08             	mov    0x8(%ebp),%eax
801023d1:	8a 00                	mov    (%eax),%al
801023d3:	3c 2f                	cmp    $0x2f,%al
801023d5:	74 f4                	je     801023cb <skipelem+0x99>
    path++;
  return path;
801023d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023da:	c9                   	leave  
801023db:	c3                   	ret    

801023dc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023dc:	55                   	push   %ebp
801023dd:	89 e5                	mov    %esp,%ebp
801023df:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023e2:	8b 45 08             	mov    0x8(%ebp),%eax
801023e5:	8a 00                	mov    (%eax),%al
801023e7:	3c 2f                	cmp    $0x2f,%al
801023e9:	75 1c                	jne    80102407 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801023eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023f2:	00 
801023f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023fa:	e8 c4 f4 ff ff       	call   801018c3 <iget>
801023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102402:	e9 ac 00 00 00       	jmp    801024b3 <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102407:	e8 af 1d 00 00       	call   801041bb <myproc>
8010240c:	8b 40 68             	mov    0x68(%eax),%eax
8010240f:	89 04 24             	mov    %eax,(%esp)
80102412:	e8 81 f5 ff ff       	call   80101998 <idup>
80102417:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010241a:	e9 94 00 00 00       	jmp    801024b3 <namex+0xd7>
    ilock(ip);
8010241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102422:	89 04 24             	mov    %eax,(%esp)
80102425:	e8 a0 f5 ff ff       	call   801019ca <ilock>
    if(ip->type != T_DIR){
8010242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242d:	8b 40 50             	mov    0x50(%eax),%eax
80102430:	66 83 f8 01          	cmp    $0x1,%ax
80102434:	74 15                	je     8010244b <namex+0x6f>
      iunlockput(ip);
80102436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102439:	89 04 24             	mov    %eax,(%esp)
8010243c:	e8 88 f7 ff ff       	call   80101bc9 <iunlockput>
      return 0;
80102441:	b8 00 00 00 00       	mov    $0x0,%eax
80102446:	e9 a2 00 00 00       	jmp    801024ed <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
8010244b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010244f:	74 1c                	je     8010246d <namex+0x91>
80102451:	8b 45 08             	mov    0x8(%ebp),%eax
80102454:	8a 00                	mov    (%eax),%al
80102456:	84 c0                	test   %al,%al
80102458:	75 13                	jne    8010246d <namex+0x91>
      // Stop one level early.
      iunlock(ip);
8010245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245d:	89 04 24             	mov    %eax,(%esp)
80102460:	e8 6f f6 ff ff       	call   80101ad4 <iunlock>
      return ip;
80102465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102468:	e9 80 00 00 00       	jmp    801024ed <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010246d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102474:	00 
80102475:	8b 45 10             	mov    0x10(%ebp),%eax
80102478:	89 44 24 04          	mov    %eax,0x4(%esp)
8010247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247f:	89 04 24             	mov    %eax,(%esp)
80102482:	e8 ef fc ff ff       	call   80102176 <dirlookup>
80102487:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010248a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010248e:	75 12                	jne    801024a2 <namex+0xc6>
      iunlockput(ip);
80102490:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102493:	89 04 24             	mov    %eax,(%esp)
80102496:	e8 2e f7 ff ff       	call   80101bc9 <iunlockput>
      return 0;
8010249b:	b8 00 00 00 00       	mov    $0x0,%eax
801024a0:	eb 4b                	jmp    801024ed <namex+0x111>
    }
    iunlockput(ip);
801024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024a5:	89 04 24             	mov    %eax,(%esp)
801024a8:	e8 1c f7 ff ff       	call   80101bc9 <iunlockput>
    ip = next;
801024ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801024b3:	8b 45 10             	mov    0x10(%ebp),%eax
801024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801024ba:	8b 45 08             	mov    0x8(%ebp),%eax
801024bd:	89 04 24             	mov    %eax,(%esp)
801024c0:	e8 6d fe ff ff       	call   80102332 <skipelem>
801024c5:	89 45 08             	mov    %eax,0x8(%ebp)
801024c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024cc:	0f 85 4d ff ff ff    	jne    8010241f <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024d6:	74 12                	je     801024ea <namex+0x10e>
    iput(ip);
801024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024db:	89 04 24             	mov    %eax,(%esp)
801024de:	e8 35 f6 ff ff       	call   80101b18 <iput>
    return 0;
801024e3:	b8 00 00 00 00       	mov    $0x0,%eax
801024e8:	eb 03                	jmp    801024ed <namex+0x111>
  }
  return ip;
801024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024ed:	c9                   	leave  
801024ee:	c3                   	ret    

801024ef <namei>:

struct inode*
namei(char *path)
{
801024ef:	55                   	push   %ebp
801024f0:	89 e5                	mov    %esp,%ebp
801024f2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024f5:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801024fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102503:	00 
80102504:	8b 45 08             	mov    0x8(%ebp),%eax
80102507:	89 04 24             	mov    %eax,(%esp)
8010250a:	e8 cd fe ff ff       	call   801023dc <namex>
}
8010250f:	c9                   	leave  
80102510:	c3                   	ret    

80102511 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102511:	55                   	push   %ebp
80102512:	89 e5                	mov    %esp,%ebp
80102514:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102517:	8b 45 0c             	mov    0xc(%ebp),%eax
8010251a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010251e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102525:	00 
80102526:	8b 45 08             	mov    0x8(%ebp),%eax
80102529:	89 04 24             	mov    %eax,(%esp)
8010252c:	e8 ab fe ff ff       	call   801023dc <namex>
}
80102531:	c9                   	leave  
80102532:	c3                   	ret    
	...

80102534 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	83 ec 14             	sub    $0x14,%esp
8010253a:	8b 45 08             	mov    0x8(%ebp),%eax
8010253d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102541:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102544:	89 c2                	mov    %eax,%edx
80102546:	ec                   	in     (%dx),%al
80102547:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010254a:	8a 45 ff             	mov    -0x1(%ebp),%al
}
8010254d:	c9                   	leave  
8010254e:	c3                   	ret    

8010254f <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	57                   	push   %edi
80102553:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102554:	8b 55 08             	mov    0x8(%ebp),%edx
80102557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010255a:	8b 45 10             	mov    0x10(%ebp),%eax
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	89 df                	mov    %ebx,%edi
80102561:	89 c1                	mov    %eax,%ecx
80102563:	fc                   	cld    
80102564:	f3 6d                	rep insl (%dx),%es:(%edi)
80102566:	89 c8                	mov    %ecx,%eax
80102568:	89 fb                	mov    %edi,%ebx
8010256a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010256d:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102570:	5b                   	pop    %ebx
80102571:	5f                   	pop    %edi
80102572:	5d                   	pop    %ebp
80102573:	c3                   	ret    

80102574 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	83 ec 08             	sub    $0x8,%esp
8010257a:	8b 45 08             	mov    0x8(%ebp),%eax
8010257d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102580:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102584:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102587:	8a 45 f8             	mov    -0x8(%ebp),%al
8010258a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010258d:	ee                   	out    %al,(%dx)
}
8010258e:	c9                   	leave  
8010258f:	c3                   	ret    

80102590 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102595:	8b 55 08             	mov    0x8(%ebp),%edx
80102598:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010259b:	8b 45 10             	mov    0x10(%ebp),%eax
8010259e:	89 cb                	mov    %ecx,%ebx
801025a0:	89 de                	mov    %ebx,%esi
801025a2:	89 c1                	mov    %eax,%ecx
801025a4:	fc                   	cld    
801025a5:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025a7:	89 c8                	mov    %ecx,%eax
801025a9:	89 f3                	mov    %esi,%ebx
801025ab:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025ae:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801025b1:	5b                   	pop    %ebx
801025b2:	5e                   	pop    %esi
801025b3:	5d                   	pop    %ebp
801025b4:	c3                   	ret    

801025b5 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025b5:	55                   	push   %ebp
801025b6:	89 e5                	mov    %esp,%ebp
801025b8:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025bb:	90                   	nop
801025bc:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025c3:	e8 6c ff ff ff       	call   80102534 <inb>
801025c8:	0f b6 c0             	movzbl %al,%eax
801025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025d1:	25 c0 00 00 00       	and    $0xc0,%eax
801025d6:	83 f8 40             	cmp    $0x40,%eax
801025d9:	75 e1                	jne    801025bc <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025df:	74 11                	je     801025f2 <idewait+0x3d>
801025e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025e4:	83 e0 21             	and    $0x21,%eax
801025e7:	85 c0                	test   %eax,%eax
801025e9:	74 07                	je     801025f2 <idewait+0x3d>
    return -1;
801025eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025f0:	eb 05                	jmp    801025f7 <idewait+0x42>
  return 0;
801025f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025f7:	c9                   	leave  
801025f8:	c3                   	ret    

801025f9 <ideinit>:

void
ideinit(void)
{
801025f9:	55                   	push   %ebp
801025fa:	89 e5                	mov    %esp,%ebp
801025fc:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025ff:	c7 44 24 04 6b 83 10 	movl   $0x8010836b,0x4(%esp)
80102606:	80 
80102607:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010260e:	e8 97 27 00 00       	call   80104daa <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102613:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80102618:	48                   	dec    %eax
80102619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010261d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102624:	e8 66 04 00 00       	call   80102a8f <ioapicenable>
  idewait(0);
80102629:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102630:	e8 80 ff ff ff       	call   801025b5 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102635:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010263c:	00 
8010263d:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102644:	e8 2b ff ff ff       	call   80102574 <outb>
  for(i=0; i<1000; i++){
80102649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102650:	eb 1f                	jmp    80102671 <ideinit+0x78>
    if(inb(0x1f7) != 0){
80102652:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102659:	e8 d6 fe ff ff       	call   80102534 <inb>
8010265e:	84 c0                	test   %al,%al
80102660:	74 0c                	je     8010266e <ideinit+0x75>
      havedisk1 = 1;
80102662:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
80102669:	00 00 00 
      break;
8010266c:	eb 0c                	jmp    8010267a <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010266e:	ff 45 f4             	incl   -0xc(%ebp)
80102671:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102678:	7e d8                	jle    80102652 <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010267a:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102681:	00 
80102682:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102689:	e8 e6 fe ff ff       	call   80102574 <outb>
}
8010268e:	c9                   	leave  
8010268f:	c3                   	ret    

80102690 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102696:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010269a:	75 0c                	jne    801026a8 <idestart+0x18>
    panic("idestart");
8010269c:	c7 04 24 6f 83 10 80 	movl   $0x8010836f,(%esp)
801026a3:	e8 ac de ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
801026a8:	8b 45 08             	mov    0x8(%ebp),%eax
801026ab:	8b 40 08             	mov    0x8(%eax),%eax
801026ae:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026b3:	76 0c                	jbe    801026c1 <idestart+0x31>
    panic("incorrect blockno");
801026b5:	c7 04 24 78 83 10 80 	movl   $0x80108378,(%esp)
801026bc:	e8 93 de ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026c8:	8b 45 08             	mov    0x8(%ebp),%eax
801026cb:	8b 50 08             	mov    0x8(%eax),%edx
801026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d1:	0f af c2             	imul   %edx,%eax
801026d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
801026d7:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801026db:	75 07                	jne    801026e4 <idestart+0x54>
801026dd:	b8 20 00 00 00       	mov    $0x20,%eax
801026e2:	eb 05                	jmp    801026e9 <idestart+0x59>
801026e4:	b8 c4 00 00 00       	mov    $0xc4,%eax
801026e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
801026ec:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801026f0:	75 07                	jne    801026f9 <idestart+0x69>
801026f2:	b8 30 00 00 00       	mov    $0x30,%eax
801026f7:	eb 05                	jmp    801026fe <idestart+0x6e>
801026f9:	b8 c5 00 00 00       	mov    $0xc5,%eax
801026fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102701:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102705:	7e 0c                	jle    80102713 <idestart+0x83>
80102707:	c7 04 24 6f 83 10 80 	movl   $0x8010836f,(%esp)
8010270e:	e8 41 de ff ff       	call   80100554 <panic>

  idewait(0);
80102713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010271a:	e8 96 fe ff ff       	call   801025b5 <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010271f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102726:	00 
80102727:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010272e:	e8 41 fe ff ff       	call   80102574 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
80102733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102736:	0f b6 c0             	movzbl %al,%eax
80102739:	89 44 24 04          	mov    %eax,0x4(%esp)
8010273d:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102744:	e8 2b fe ff ff       	call   80102574 <outb>
  outb(0x1f3, sector & 0xff);
80102749:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010274c:	0f b6 c0             	movzbl %al,%eax
8010274f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102753:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010275a:	e8 15 fe ff ff       	call   80102574 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102762:	c1 f8 08             	sar    $0x8,%eax
80102765:	0f b6 c0             	movzbl %al,%eax
80102768:	89 44 24 04          	mov    %eax,0x4(%esp)
8010276c:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102773:	e8 fc fd ff ff       	call   80102574 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102778:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010277b:	c1 f8 10             	sar    $0x10,%eax
8010277e:	0f b6 c0             	movzbl %al,%eax
80102781:	89 44 24 04          	mov    %eax,0x4(%esp)
80102785:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010278c:	e8 e3 fd ff ff       	call   80102574 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102791:	8b 45 08             	mov    0x8(%ebp),%eax
80102794:	8b 40 04             	mov    0x4(%eax),%eax
80102797:	83 e0 01             	and    $0x1,%eax
8010279a:	c1 e0 04             	shl    $0x4,%eax
8010279d:	88 c2                	mov    %al,%dl
8010279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a2:	c1 f8 18             	sar    $0x18,%eax
801027a5:	83 e0 0f             	and    $0xf,%eax
801027a8:	09 d0                	or     %edx,%eax
801027aa:	83 c8 e0             	or     $0xffffffe0,%eax
801027ad:	0f b6 c0             	movzbl %al,%eax
801027b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801027b4:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027bb:	e8 b4 fd ff ff       	call   80102574 <outb>
  if(b->flags & B_DIRTY){
801027c0:	8b 45 08             	mov    0x8(%ebp),%eax
801027c3:	8b 00                	mov    (%eax),%eax
801027c5:	83 e0 04             	and    $0x4,%eax
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 36                	je     80102802 <idestart+0x172>
    outb(0x1f7, write_cmd);
801027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027cf:	0f b6 c0             	movzbl %al,%eax
801027d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801027d6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027dd:	e8 92 fd ff ff       	call   80102574 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	83 c0 5c             	add    $0x5c,%eax
801027e8:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027ef:	00 
801027f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801027f4:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027fb:	e8 90 fd ff ff       	call   80102590 <outsl>
80102800:	eb 16                	jmp    80102818 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102802:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102805:	0f b6 c0             	movzbl %al,%eax
80102808:	89 44 24 04          	mov    %eax,0x4(%esp)
8010280c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102813:	e8 5c fd ff ff       	call   80102574 <outb>
  }
}
80102818:	c9                   	leave  
80102819:	c3                   	ret    

8010281a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010281a:	55                   	push   %ebp
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102820:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102827:	e8 9f 25 00 00       	call   80104dcb <acquire>

  if((b = idequeue) == 0){
8010282c:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102831:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102838:	75 11                	jne    8010284b <ideintr+0x31>
    release(&idelock);
8010283a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102841:	e8 ef 25 00 00       	call   80104e35 <release>
    return;
80102846:	e9 90 00 00 00       	jmp    801028db <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284e:	8b 40 58             	mov    0x58(%eax),%eax
80102851:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102859:	8b 00                	mov    (%eax),%eax
8010285b:	83 e0 04             	and    $0x4,%eax
8010285e:	85 c0                	test   %eax,%eax
80102860:	75 2e                	jne    80102890 <ideintr+0x76>
80102862:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102869:	e8 47 fd ff ff       	call   801025b5 <idewait>
8010286e:	85 c0                	test   %eax,%eax
80102870:	78 1e                	js     80102890 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102875:	83 c0 5c             	add    $0x5c,%eax
80102878:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010287f:	00 
80102880:	89 44 24 04          	mov    %eax,0x4(%esp)
80102884:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010288b:	e8 bf fc ff ff       	call   8010254f <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102893:	8b 00                	mov    (%eax),%eax
80102895:	83 c8 02             	or     $0x2,%eax
80102898:	89 c2                	mov    %eax,%edx
8010289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289d:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a2:	8b 00                	mov    (%eax),%eax
801028a4:	83 e0 fb             	and    $0xfffffffb,%eax
801028a7:	89 c2                	mov    %eax,%edx
801028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ac:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b1:	89 04 24             	mov    %eax,(%esp)
801028b4:	e8 17 22 00 00       	call   80104ad0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028b9:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801028be:	85 c0                	test   %eax,%eax
801028c0:	74 0d                	je     801028cf <ideintr+0xb5>
    idestart(idequeue);
801028c2:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801028c7:	89 04 24             	mov    %eax,(%esp)
801028ca:	e8 c1 fd ff ff       	call   80102690 <idestart>

  release(&idelock);
801028cf:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801028d6:	e8 5a 25 00 00       	call   80104e35 <release>
}
801028db:	c9                   	leave  
801028dc:	c3                   	ret    

801028dd <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028dd:	55                   	push   %ebp
801028de:	89 e5                	mov    %esp,%ebp
801028e0:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801028e3:	8b 45 08             	mov    0x8(%ebp),%eax
801028e6:	83 c0 0c             	add    $0xc,%eax
801028e9:	89 04 24             	mov    %eax,(%esp)
801028ec:	e8 52 24 00 00       	call   80104d43 <holdingsleep>
801028f1:	85 c0                	test   %eax,%eax
801028f3:	75 0c                	jne    80102901 <iderw+0x24>
    panic("iderw: buf not locked");
801028f5:	c7 04 24 8a 83 10 80 	movl   $0x8010838a,(%esp)
801028fc:	e8 53 dc ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102901:	8b 45 08             	mov    0x8(%ebp),%eax
80102904:	8b 00                	mov    (%eax),%eax
80102906:	83 e0 06             	and    $0x6,%eax
80102909:	83 f8 02             	cmp    $0x2,%eax
8010290c:	75 0c                	jne    8010291a <iderw+0x3d>
    panic("iderw: nothing to do");
8010290e:	c7 04 24 a0 83 10 80 	movl   $0x801083a0,(%esp)
80102915:	e8 3a dc ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
8010291d:	8b 40 04             	mov    0x4(%eax),%eax
80102920:	85 c0                	test   %eax,%eax
80102922:	74 15                	je     80102939 <iderw+0x5c>
80102924:	a1 18 b6 10 80       	mov    0x8010b618,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	75 0c                	jne    80102939 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
8010292d:	c7 04 24 b5 83 10 80 	movl   $0x801083b5,(%esp)
80102934:	e8 1b dc ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102939:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102940:	e8 86 24 00 00       	call   80104dcb <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102945:	8b 45 08             	mov    0x8(%ebp),%eax
80102948:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010294f:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
80102956:	eb 0b                	jmp    80102963 <iderw+0x86>
80102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295b:	8b 00                	mov    (%eax),%eax
8010295d:	83 c0 58             	add    $0x58,%eax
80102960:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102966:	8b 00                	mov    (%eax),%eax
80102968:	85 c0                	test   %eax,%eax
8010296a:	75 ec                	jne    80102958 <iderw+0x7b>
    ;
  *pp = b;
8010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296f:	8b 55 08             	mov    0x8(%ebp),%edx
80102972:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102974:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102979:	3b 45 08             	cmp    0x8(%ebp),%eax
8010297c:	75 0d                	jne    8010298b <iderw+0xae>
    idestart(b);
8010297e:	8b 45 08             	mov    0x8(%ebp),%eax
80102981:	89 04 24             	mov    %eax,(%esp)
80102984:	e8 07 fd ff ff       	call   80102690 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102989:	eb 15                	jmp    801029a0 <iderw+0xc3>
8010298b:	eb 13                	jmp    801029a0 <iderw+0xc3>
    sleep(b, &idelock);
8010298d:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80102994:	80 
80102995:	8b 45 08             	mov    0x8(%ebp),%eax
80102998:	89 04 24             	mov    %eax,(%esp)
8010299b:	e8 5c 20 00 00       	call   801049fc <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029a0:	8b 45 08             	mov    0x8(%ebp),%eax
801029a3:	8b 00                	mov    (%eax),%eax
801029a5:	83 e0 06             	and    $0x6,%eax
801029a8:	83 f8 02             	cmp    $0x2,%eax
801029ab:	75 e0                	jne    8010298d <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
801029ad:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801029b4:	e8 7c 24 00 00       	call   80104e35 <release>
}
801029b9:	c9                   	leave  
801029ba:	c3                   	ret    
	...

801029bc <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029bc:	55                   	push   %ebp
801029bd:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029bf:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029c4:	8b 55 08             	mov    0x8(%ebp),%edx
801029c7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029c9:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029ce:	8b 40 10             	mov    0x10(%eax),%eax
}
801029d1:	5d                   	pop    %ebp
801029d2:	c3                   	ret    

801029d3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029d3:	55                   	push   %ebp
801029d4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029d6:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029db:	8b 55 08             	mov    0x8(%ebp),%edx
801029de:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029e0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801029e8:	89 50 10             	mov    %edx,0x10(%eax)
}
801029eb:	5d                   	pop    %ebp
801029ec:	c3                   	ret    

801029ed <ioapicinit>:

void
ioapicinit(void)
{
801029ed:	55                   	push   %ebp
801029ee:	89 e5                	mov    %esp,%ebp
801029f0:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029f3:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
801029fa:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a04:	e8 b3 ff ff ff       	call   801029bc <ioapicread>
80102a09:	c1 e8 10             	shr    $0x10,%eax
80102a0c:	25 ff 00 00 00       	and    $0xff,%eax
80102a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a1b:	e8 9c ff ff ff       	call   801029bc <ioapicread>
80102a20:	c1 e8 18             	shr    $0x18,%eax
80102a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a26:	a0 e0 37 11 80       	mov    0x801137e0,%al
80102a2b:	0f b6 c0             	movzbl %al,%eax
80102a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a31:	74 0c                	je     80102a3f <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a33:	c7 04 24 d4 83 10 80 	movl   $0x801083d4,(%esp)
80102a3a:	e8 82 d9 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a46:	eb 3d                	jmp    80102a85 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4b:	83 c0 20             	add    $0x20,%eax
80102a4e:	0d 00 00 01 00       	or     $0x10000,%eax
80102a53:	89 c2                	mov    %eax,%edx
80102a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a58:	83 c0 08             	add    $0x8,%eax
80102a5b:	01 c0                	add    %eax,%eax
80102a5d:	89 54 24 04          	mov    %edx,0x4(%esp)
80102a61:	89 04 24             	mov    %eax,(%esp)
80102a64:	e8 6a ff ff ff       	call   801029d3 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a6c:	83 c0 08             	add    $0x8,%eax
80102a6f:	01 c0                	add    %eax,%eax
80102a71:	40                   	inc    %eax
80102a72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a79:	00 
80102a7a:	89 04 24             	mov    %eax,(%esp)
80102a7d:	e8 51 ff ff ff       	call   801029d3 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a82:	ff 45 f4             	incl   -0xc(%ebp)
80102a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a8b:	7e bb                	jle    80102a48 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a8d:	c9                   	leave  
80102a8e:	c3                   	ret    

80102a8f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a8f:	55                   	push   %ebp
80102a90:	89 e5                	mov    %esp,%ebp
80102a92:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a95:	8b 45 08             	mov    0x8(%ebp),%eax
80102a98:	83 c0 20             	add    $0x20,%eax
80102a9b:	89 c2                	mov    %eax,%edx
80102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa0:	83 c0 08             	add    $0x8,%eax
80102aa3:	01 c0                	add    %eax,%eax
80102aa5:	89 54 24 04          	mov    %edx,0x4(%esp)
80102aa9:	89 04 24             	mov    %eax,(%esp)
80102aac:	e8 22 ff ff ff       	call   801029d3 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab4:	c1 e0 18             	shl    $0x18,%eax
80102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80102aba:	83 c2 08             	add    $0x8,%edx
80102abd:	01 d2                	add    %edx,%edx
80102abf:	42                   	inc    %edx
80102ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac4:	89 14 24             	mov    %edx,(%esp)
80102ac7:	e8 07 ff ff ff       	call   801029d3 <ioapicwrite>
}
80102acc:	c9                   	leave  
80102acd:	c3                   	ret    
	...

80102ad0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102ad6:	c7 44 24 04 06 84 10 	movl   $0x80108406,0x4(%esp)
80102add:	80 
80102ade:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102ae5:	e8 c0 22 00 00       	call   80104daa <initlock>
  kmem.use_lock = 0;
80102aea:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102af1:	00 00 00 
  freerange(vstart, vend);
80102af4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102afb:	8b 45 08             	mov    0x8(%ebp),%eax
80102afe:	89 04 24             	mov    %eax,(%esp)
80102b01:	e8 26 00 00 00       	call   80102b2c <freerange>
}
80102b06:	c9                   	leave  
80102b07:	c3                   	ret    

80102b08 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b08:	55                   	push   %ebp
80102b09:	89 e5                	mov    %esp,%ebp
80102b0b:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b11:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b15:	8b 45 08             	mov    0x8(%ebp),%eax
80102b18:	89 04 24             	mov    %eax,(%esp)
80102b1b:	e8 0c 00 00 00       	call   80102b2c <freerange>
  kmem.use_lock = 1;
80102b20:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102b27:	00 00 00 
}
80102b2a:	c9                   	leave  
80102b2b:	c3                   	ret    

80102b2c <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b2c:	55                   	push   %ebp
80102b2d:	89 e5                	mov    %esp,%ebp
80102b2f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b32:	8b 45 08             	mov    0x8(%ebp),%eax
80102b35:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b42:	eb 12                	jmp    80102b56 <freerange+0x2a>
    kfree(p);
80102b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b47:	89 04 24             	mov    %eax,(%esp)
80102b4a:	e8 16 00 00 00       	call   80102b65 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b4f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b59:	05 00 10 00 00       	add    $0x1000,%eax
80102b5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b61:	76 e1                	jbe    80102b44 <freerange+0x18>
    kfree(p);
}
80102b63:	c9                   	leave  
80102b64:	c3                   	ret    

80102b65 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b65:	55                   	push   %ebp
80102b66:	89 e5                	mov    %esp,%ebp
80102b68:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b73:	85 c0                	test   %eax,%eax
80102b75:	75 18                	jne    80102b8f <kfree+0x2a>
80102b77:	81 7d 08 28 65 11 80 	cmpl   $0x80116528,0x8(%ebp)
80102b7e:	72 0f                	jb     80102b8f <kfree+0x2a>
80102b80:	8b 45 08             	mov    0x8(%ebp),%eax
80102b83:	05 00 00 00 80       	add    $0x80000000,%eax
80102b88:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b8d:	76 0c                	jbe    80102b9b <kfree+0x36>
    panic("kfree");
80102b8f:	c7 04 24 0b 84 10 80 	movl   $0x8010840b,(%esp)
80102b96:	e8 b9 d9 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b9b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ba2:	00 
80102ba3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102baa:	00 
80102bab:	8b 45 08             	mov    0x8(%ebp),%eax
80102bae:	89 04 24             	mov    %eax,(%esp)
80102bb1:	e8 78 24 00 00       	call   8010502e <memset>

  if(kmem.use_lock)
80102bb6:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102bbb:	85 c0                	test   %eax,%eax
80102bbd:	74 0c                	je     80102bcb <kfree+0x66>
    acquire(&kmem.lock);
80102bbf:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bc6:	e8 00 22 00 00       	call   80104dcb <acquire>
  r = (struct run*)v;
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bd1:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bda:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdf:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102be4:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	74 0c                	je     80102bf9 <kfree+0x94>
    release(&kmem.lock);
80102bed:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bf4:	e8 3c 22 00 00       	call   80104e35 <release>
}
80102bf9:	c9                   	leave  
80102bfa:	c3                   	ret    

80102bfb <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bfb:	55                   	push   %ebp
80102bfc:	89 e5                	mov    %esp,%ebp
80102bfe:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102c01:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c06:	85 c0                	test   %eax,%eax
80102c08:	74 0c                	je     80102c16 <kalloc+0x1b>
    acquire(&kmem.lock);
80102c0a:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102c11:	e8 b5 21 00 00       	call   80104dcb <acquire>
  r = kmem.freelist;
80102c16:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c22:	74 0a                	je     80102c2e <kalloc+0x33>
    kmem.freelist = r->next;
80102c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c27:	8b 00                	mov    (%eax),%eax
80102c29:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102c2e:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c33:	85 c0                	test   %eax,%eax
80102c35:	74 0c                	je     80102c43 <kalloc+0x48>
    release(&kmem.lock);
80102c37:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102c3e:	e8 f2 21 00 00       	call   80104e35 <release>
  return (char*)r;
80102c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c46:	c9                   	leave  
80102c47:	c3                   	ret    

80102c48 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c48:	55                   	push   %ebp
80102c49:	89 e5                	mov    %esp,%ebp
80102c4b:	83 ec 14             	sub    $0x14,%esp
80102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c51:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	ec                   	in     (%dx),%al
80102c5b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c5e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102c61:	c9                   	leave  
80102c62:	c3                   	ret    

80102c63 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c63:	55                   	push   %ebp
80102c64:	89 e5                	mov    %esp,%ebp
80102c66:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c69:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c70:	e8 d3 ff ff ff       	call   80102c48 <inb>
80102c75:	0f b6 c0             	movzbl %al,%eax
80102c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c7e:	83 e0 01             	and    $0x1,%eax
80102c81:	85 c0                	test   %eax,%eax
80102c83:	75 0a                	jne    80102c8f <kbdgetc+0x2c>
    return -1;
80102c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c8a:	e9 21 01 00 00       	jmp    80102db0 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c8f:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c96:	e8 ad ff ff ff       	call   80102c48 <inb>
80102c9b:	0f b6 c0             	movzbl %al,%eax
80102c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ca1:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ca8:	75 17                	jne    80102cc1 <kbdgetc+0x5e>
    shift |= E0ESC;
80102caa:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102caf:	83 c8 40             	or     $0x40,%eax
80102cb2:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102cb7:	b8 00 00 00 00       	mov    $0x0,%eax
80102cbc:	e9 ef 00 00 00       	jmp    80102db0 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc4:	25 80 00 00 00       	and    $0x80,%eax
80102cc9:	85 c0                	test   %eax,%eax
80102ccb:	74 44                	je     80102d11 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ccd:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cd2:	83 e0 40             	and    $0x40,%eax
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	75 08                	jne    80102ce1 <kbdgetc+0x7e>
80102cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cdc:	83 e0 7f             	and    $0x7f,%eax
80102cdf:	eb 03                	jmp    80102ce4 <kbdgetc+0x81>
80102ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cea:	05 20 90 10 80       	add    $0x80109020,%eax
80102cef:	8a 00                	mov    (%eax),%al
80102cf1:	83 c8 40             	or     $0x40,%eax
80102cf4:	0f b6 c0             	movzbl %al,%eax
80102cf7:	f7 d0                	not    %eax
80102cf9:	89 c2                	mov    %eax,%edx
80102cfb:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d00:	21 d0                	and    %edx,%eax
80102d02:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102d07:	b8 00 00 00 00       	mov    $0x0,%eax
80102d0c:	e9 9f 00 00 00       	jmp    80102db0 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d11:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d16:	83 e0 40             	and    $0x40,%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 14                	je     80102d31 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d1d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d24:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d29:	83 e0 bf             	and    $0xffffffbf,%eax
80102d2c:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d34:	05 20 90 10 80       	add    $0x80109020,%eax
80102d39:	8a 00                	mov    (%eax),%al
80102d3b:	0f b6 d0             	movzbl %al,%edx
80102d3e:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d43:	09 d0                	or     %edx,%eax
80102d45:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d4d:	05 20 91 10 80       	add    $0x80109120,%eax
80102d52:	8a 00                	mov    (%eax),%al
80102d54:	0f b6 d0             	movzbl %al,%edx
80102d57:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d5c:	31 d0                	xor    %edx,%eax
80102d5e:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d63:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d68:	83 e0 03             	and    $0x3,%eax
80102d6b:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d75:	01 d0                	add    %edx,%eax
80102d77:	8a 00                	mov    (%eax),%al
80102d79:	0f b6 c0             	movzbl %al,%eax
80102d7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d7f:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d84:	83 e0 08             	and    $0x8,%eax
80102d87:	85 c0                	test   %eax,%eax
80102d89:	74 22                	je     80102dad <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d8b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d8f:	76 0c                	jbe    80102d9d <kbdgetc+0x13a>
80102d91:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d95:	77 06                	ja     80102d9d <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d97:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d9b:	eb 10                	jmp    80102dad <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d9d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102da1:	76 0a                	jbe    80102dad <kbdgetc+0x14a>
80102da3:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102da7:	77 04                	ja     80102dad <kbdgetc+0x14a>
      c += 'a' - 'A';
80102da9:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102db0:	c9                   	leave  
80102db1:	c3                   	ret    

80102db2 <kbdintr>:

void
kbdintr(void)
{
80102db2:	55                   	push   %ebp
80102db3:	89 e5                	mov    %esp,%ebp
80102db5:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102db8:	c7 04 24 63 2c 10 80 	movl   $0x80102c63,(%esp)
80102dbf:	e8 01 da ff ff       	call   801007c5 <consoleintr>
}
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
	...

80102dc8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102dc8:	55                   	push   %ebp
80102dc9:	89 e5                	mov    %esp,%ebp
80102dcb:	83 ec 14             	sub    $0x14,%esp
80102dce:	8b 45 08             	mov    0x8(%ebp),%eax
80102dd1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dd8:	89 c2                	mov    %eax,%edx
80102dda:	ec                   	in     (%dx),%al
80102ddb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102dde:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102de1:	c9                   	leave  
80102de2:	c3                   	ret    

80102de3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102de3:	55                   	push   %ebp
80102de4:	89 e5                	mov    %esp,%ebp
80102de6:	83 ec 08             	sub    $0x8,%esp
80102de9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dec:	8b 55 0c             	mov    0xc(%ebp),%edx
80102def:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102df3:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df6:	8a 45 f8             	mov    -0x8(%ebp),%al
80102df9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102dfc:	ee                   	out    %al,(%dx)
}
80102dfd:	c9                   	leave  
80102dfe:	c3                   	ret    

80102dff <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102dff:	55                   	push   %ebp
80102e00:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e02:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e07:	8b 55 08             	mov    0x8(%ebp),%edx
80102e0a:	c1 e2 02             	shl    $0x2,%edx
80102e0d:	01 c2                	add    %eax,%edx
80102e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e12:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e14:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e19:	83 c0 20             	add    $0x20,%eax
80102e1c:	8b 00                	mov    (%eax),%eax
}
80102e1e:	5d                   	pop    %ebp
80102e1f:	c3                   	ret    

80102e20 <lapicinit>:

void
lapicinit(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102e26:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e2b:	85 c0                	test   %eax,%eax
80102e2d:	75 05                	jne    80102e34 <lapicinit+0x14>
    return;
80102e2f:	e9 43 01 00 00       	jmp    80102f77 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e34:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e3b:	00 
80102e3c:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e43:	e8 b7 ff ff ff       	call   80102dff <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e48:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e4f:	00 
80102e50:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e57:	e8 a3 ff ff ff       	call   80102dff <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e5c:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e63:	00 
80102e64:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e6b:	e8 8f ff ff ff       	call   80102dff <lapicw>
  lapicw(TICR, 10000000);
80102e70:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e77:	00 
80102e78:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e7f:	e8 7b ff ff ff       	call   80102dff <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e84:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e8b:	00 
80102e8c:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e93:	e8 67 ff ff ff       	call   80102dff <lapicw>
  lapicw(LINT1, MASKED);
80102e98:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e9f:	00 
80102ea0:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102ea7:	e8 53 ff ff ff       	call   80102dff <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102eac:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102eb1:	83 c0 30             	add    $0x30,%eax
80102eb4:	8b 00                	mov    (%eax),%eax
80102eb6:	c1 e8 10             	shr    $0x10,%eax
80102eb9:	0f b6 c0             	movzbl %al,%eax
80102ebc:	83 f8 03             	cmp    $0x3,%eax
80102ebf:	76 14                	jbe    80102ed5 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102ec1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102ec8:	00 
80102ec9:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102ed0:	e8 2a ff ff ff       	call   80102dff <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ed5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102edc:	00 
80102edd:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ee4:	e8 16 ff ff ff       	call   80102dff <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ee9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef0:	00 
80102ef1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ef8:	e8 02 ff ff ff       	call   80102dff <lapicw>
  lapicw(ESR, 0);
80102efd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f04:	00 
80102f05:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f0c:	e8 ee fe ff ff       	call   80102dff <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f18:	00 
80102f19:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f20:	e8 da fe ff ff       	call   80102dff <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f2c:	00 
80102f2d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f34:	e8 c6 fe ff ff       	call   80102dff <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f39:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f40:	00 
80102f41:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f48:	e8 b2 fe ff ff       	call   80102dff <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f4d:	90                   	nop
80102f4e:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f53:	05 00 03 00 00       	add    $0x300,%eax
80102f58:	8b 00                	mov    (%eax),%eax
80102f5a:	25 00 10 00 00       	and    $0x1000,%eax
80102f5f:	85 c0                	test   %eax,%eax
80102f61:	75 eb                	jne    80102f4e <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f6a:	00 
80102f6b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f72:	e8 88 fe ff ff       	call   80102dff <lapicw>
}
80102f77:	c9                   	leave  
80102f78:	c3                   	ret    

80102f79 <lapicid>:

int
lapicid(void)
{
80102f79:	55                   	push   %ebp
80102f7a:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f7c:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f81:	85 c0                	test   %eax,%eax
80102f83:	75 07                	jne    80102f8c <lapicid+0x13>
    return 0;
80102f85:	b8 00 00 00 00       	mov    $0x0,%eax
80102f8a:	eb 0d                	jmp    80102f99 <lapicid+0x20>
  return lapic[ID] >> 24;
80102f8c:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f91:	83 c0 20             	add    $0x20,%eax
80102f94:	8b 00                	mov    (%eax),%eax
80102f96:	c1 e8 18             	shr    $0x18,%eax
}
80102f99:	5d                   	pop    %ebp
80102f9a:	c3                   	ret    

80102f9b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f9b:	55                   	push   %ebp
80102f9c:	89 e5                	mov    %esp,%ebp
80102f9e:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102fa1:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 14                	je     80102fbe <lapiceoi+0x23>
    lapicw(EOI, 0);
80102faa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fb1:	00 
80102fb2:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fb9:	e8 41 fe ff ff       	call   80102dff <lapicw>
}
80102fbe:	c9                   	leave  
80102fbf:	c3                   	ret    

80102fc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
}
80102fc3:	5d                   	pop    %ebp
80102fc4:	c3                   	ret    

80102fc5 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fc5:	55                   	push   %ebp
80102fc6:	89 e5                	mov    %esp,%ebp
80102fc8:	83 ec 1c             	sub    $0x1c,%esp
80102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102fce:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fd1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102fd8:	00 
80102fd9:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fe0:	e8 fe fd ff ff       	call   80102de3 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fe5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fec:	00 
80102fed:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102ff4:	e8 ea fd ff ff       	call   80102de3 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102ff9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103000:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103003:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103008:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010300b:	8d 50 02             	lea    0x2(%eax),%edx
8010300e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103011:	c1 e8 04             	shr    $0x4,%eax
80103014:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103017:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010301b:	c1 e0 18             	shl    $0x18,%eax
8010301e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103022:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103029:	e8 d1 fd ff ff       	call   80102dff <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010302e:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103035:	00 
80103036:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010303d:	e8 bd fd ff ff       	call   80102dff <lapicw>
  microdelay(200);
80103042:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103049:	e8 72 ff ff ff       	call   80102fc0 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010304e:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103055:	00 
80103056:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010305d:	e8 9d fd ff ff       	call   80102dff <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103062:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103069:	e8 52 ff ff ff       	call   80102fc0 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010306e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103075:	eb 3f                	jmp    801030b6 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
80103077:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010307b:	c1 e0 18             	shl    $0x18,%eax
8010307e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103082:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103089:	e8 71 fd ff ff       	call   80102dff <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010308e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103091:	c1 e8 0c             	shr    $0xc,%eax
80103094:	80 cc 06             	or     $0x6,%ah
80103097:	89 44 24 04          	mov    %eax,0x4(%esp)
8010309b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030a2:	e8 58 fd ff ff       	call   80102dff <lapicw>
    microdelay(200);
801030a7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030ae:	e8 0d ff ff ff       	call   80102fc0 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030b3:	ff 45 fc             	incl   -0x4(%ebp)
801030b6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030ba:	7e bb                	jle    80103077 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030bc:	c9                   	leave  
801030bd:	c3                   	ret    

801030be <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030be:	55                   	push   %ebp
801030bf:	89 e5                	mov    %esp,%ebp
801030c1:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801030c4:	8b 45 08             	mov    0x8(%ebp),%eax
801030c7:	0f b6 c0             	movzbl %al,%eax
801030ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801030ce:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030d5:	e8 09 fd ff ff       	call   80102de3 <outb>
  microdelay(200);
801030da:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030e1:	e8 da fe ff ff       	call   80102fc0 <microdelay>

  return inb(CMOS_RETURN);
801030e6:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030ed:	e8 d6 fc ff ff       	call   80102dc8 <inb>
801030f2:	0f b6 c0             	movzbl %al,%eax
}
801030f5:	c9                   	leave  
801030f6:	c3                   	ret    

801030f7 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030f7:	55                   	push   %ebp
801030f8:	89 e5                	mov    %esp,%ebp
801030fa:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103104:	e8 b5 ff ff ff       	call   801030be <cmos_read>
80103109:	8b 55 08             	mov    0x8(%ebp),%edx
8010310c:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010310e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103115:	e8 a4 ff ff ff       	call   801030be <cmos_read>
8010311a:	8b 55 08             	mov    0x8(%ebp),%edx
8010311d:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103120:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103127:	e8 92 ff ff ff       	call   801030be <cmos_read>
8010312c:	8b 55 08             	mov    0x8(%ebp),%edx
8010312f:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103132:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103139:	e8 80 ff ff ff       	call   801030be <cmos_read>
8010313e:	8b 55 08             	mov    0x8(%ebp),%edx
80103141:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103144:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010314b:	e8 6e ff ff ff       	call   801030be <cmos_read>
80103150:	8b 55 08             	mov    0x8(%ebp),%edx
80103153:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103156:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
8010315d:	e8 5c ff ff ff       	call   801030be <cmos_read>
80103162:	8b 55 08             	mov    0x8(%ebp),%edx
80103165:	89 42 14             	mov    %eax,0x14(%edx)
}
80103168:	c9                   	leave  
80103169:	c3                   	ret    

8010316a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010316a:	55                   	push   %ebp
8010316b:	89 e5                	mov    %esp,%ebp
8010316d:	57                   	push   %edi
8010316e:	56                   	push   %esi
8010316f:	53                   	push   %ebx
80103170:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103173:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010317a:	e8 3f ff ff ff       	call   801030be <cmos_read>
8010317f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103185:	83 e0 04             	and    $0x4,%eax
80103188:	85 c0                	test   %eax,%eax
8010318a:	0f 94 c0             	sete   %al
8010318d:	0f b6 c0             	movzbl %al,%eax
80103190:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103193:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103196:	89 04 24             	mov    %eax,(%esp)
80103199:	e8 59 ff ff ff       	call   801030f7 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010319e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801031a5:	e8 14 ff ff ff       	call   801030be <cmos_read>
801031aa:	25 80 00 00 00       	and    $0x80,%eax
801031af:	85 c0                	test   %eax,%eax
801031b1:	74 02                	je     801031b5 <cmostime+0x4b>
        continue;
801031b3:	eb 36                	jmp    801031eb <cmostime+0x81>
    fill_rtcdate(&t2);
801031b5:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031b8:	89 04 24             	mov    %eax,(%esp)
801031bb:	e8 37 ff ff ff       	call   801030f7 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031c0:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801031c7:	00 
801031c8:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801031cf:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031d2:	89 04 24             	mov    %eax,(%esp)
801031d5:	e8 cb 1e 00 00       	call   801050a5 <memcmp>
801031da:	85 c0                	test   %eax,%eax
801031dc:	75 0d                	jne    801031eb <cmostime+0x81>
      break;
801031de:	90                   	nop
  }

  // convert
  if(bcd) {
801031df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801031e3:	0f 84 ac 00 00 00    	je     80103295 <cmostime+0x12b>
801031e9:	eb 02                	jmp    801031ed <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031eb:	eb a6                	jmp    80103193 <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031f0:	c1 e8 04             	shr    $0x4,%eax
801031f3:	89 c2                	mov    %eax,%edx
801031f5:	89 d0                	mov    %edx,%eax
801031f7:	c1 e0 02             	shl    $0x2,%eax
801031fa:	01 d0                	add    %edx,%eax
801031fc:	01 c0                	add    %eax,%eax
801031fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103201:	83 e2 0f             	and    $0xf,%edx
80103204:	01 d0                	add    %edx,%eax
80103206:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103209:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010320c:	c1 e8 04             	shr    $0x4,%eax
8010320f:	89 c2                	mov    %eax,%edx
80103211:	89 d0                	mov    %edx,%eax
80103213:	c1 e0 02             	shl    $0x2,%eax
80103216:	01 d0                	add    %edx,%eax
80103218:	01 c0                	add    %eax,%eax
8010321a:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010321d:	83 e2 0f             	and    $0xf,%edx
80103220:	01 d0                	add    %edx,%eax
80103222:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103225:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103228:	c1 e8 04             	shr    $0x4,%eax
8010322b:	89 c2                	mov    %eax,%edx
8010322d:	89 d0                	mov    %edx,%eax
8010322f:	c1 e0 02             	shl    $0x2,%eax
80103232:	01 d0                	add    %edx,%eax
80103234:	01 c0                	add    %eax,%eax
80103236:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103239:	83 e2 0f             	and    $0xf,%edx
8010323c:	01 d0                	add    %edx,%eax
8010323e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103241:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103244:	c1 e8 04             	shr    $0x4,%eax
80103247:	89 c2                	mov    %eax,%edx
80103249:	89 d0                	mov    %edx,%eax
8010324b:	c1 e0 02             	shl    $0x2,%eax
8010324e:	01 d0                	add    %edx,%eax
80103250:	01 c0                	add    %eax,%eax
80103252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103255:	83 e2 0f             	and    $0xf,%edx
80103258:	01 d0                	add    %edx,%eax
8010325a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
8010325d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103260:	c1 e8 04             	shr    $0x4,%eax
80103263:	89 c2                	mov    %eax,%edx
80103265:	89 d0                	mov    %edx,%eax
80103267:	c1 e0 02             	shl    $0x2,%eax
8010326a:	01 d0                	add    %edx,%eax
8010326c:	01 c0                	add    %eax,%eax
8010326e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103271:	83 e2 0f             	and    $0xf,%edx
80103274:	01 d0                	add    %edx,%eax
80103276:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
80103279:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010327c:	c1 e8 04             	shr    $0x4,%eax
8010327f:	89 c2                	mov    %eax,%edx
80103281:	89 d0                	mov    %edx,%eax
80103283:	c1 e0 02             	shl    $0x2,%eax
80103286:	01 d0                	add    %edx,%eax
80103288:	01 c0                	add    %eax,%eax
8010328a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010328d:	83 e2 0f             	and    $0xf,%edx
80103290:	01 d0                	add    %edx,%eax
80103292:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
80103295:	8b 45 08             	mov    0x8(%ebp),%eax
80103298:	89 c2                	mov    %eax,%edx
8010329a:	8d 5d c8             	lea    -0x38(%ebp),%ebx
8010329d:	b8 06 00 00 00       	mov    $0x6,%eax
801032a2:	89 d7                	mov    %edx,%edi
801032a4:	89 de                	mov    %ebx,%esi
801032a6:	89 c1                	mov    %eax,%ecx
801032a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801032aa:	8b 45 08             	mov    0x8(%ebp),%eax
801032ad:	8b 40 14             	mov    0x14(%eax),%eax
801032b0:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032b6:	8b 45 08             	mov    0x8(%ebp),%eax
801032b9:	89 50 14             	mov    %edx,0x14(%eax)
}
801032bc:	83 c4 5c             	add    $0x5c,%esp
801032bf:	5b                   	pop    %ebx
801032c0:	5e                   	pop    %esi
801032c1:	5f                   	pop    %edi
801032c2:	5d                   	pop    %ebp
801032c3:	c3                   	ret    

801032c4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032c4:	55                   	push   %ebp
801032c5:	89 e5                	mov    %esp,%ebp
801032c7:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032ca:	c7 44 24 04 11 84 10 	movl   $0x80108411,0x4(%esp)
801032d1:	80 
801032d2:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801032d9:	e8 cc 1a 00 00       	call   80104daa <initlock>
  readsb(dev, &sb);
801032de:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801032e5:	8b 45 08             	mov    0x8(%ebp),%eax
801032e8:	89 04 24             	mov    %eax,(%esp)
801032eb:	e8 d8 e0 ff ff       	call   801013c8 <readsb>
  log.start = sb.logstart;
801032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f3:	a3 34 37 11 80       	mov    %eax,0x80113734
  log.size = sb.nlog;
801032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032fb:	a3 38 37 11 80       	mov    %eax,0x80113738
  log.dev = dev;
80103300:	8b 45 08             	mov    0x8(%ebp),%eax
80103303:	a3 44 37 11 80       	mov    %eax,0x80113744
  recover_from_log();
80103308:	e8 95 01 00 00       	call   801034a2 <recover_from_log>
}
8010330d:	c9                   	leave  
8010330e:	c3                   	ret    

8010330f <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010330f:	55                   	push   %ebp
80103310:	89 e5                	mov    %esp,%ebp
80103312:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010331c:	e9 89 00 00 00       	jmp    801033aa <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103321:	8b 15 34 37 11 80    	mov    0x80113734,%edx
80103327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010332a:	01 d0                	add    %edx,%eax
8010332c:	40                   	inc    %eax
8010332d:	89 c2                	mov    %eax,%edx
8010332f:	a1 44 37 11 80       	mov    0x80113744,%eax
80103334:	89 54 24 04          	mov    %edx,0x4(%esp)
80103338:	89 04 24             	mov    %eax,(%esp)
8010333b:	e8 75 ce ff ff       	call   801001b5 <bread>
80103340:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103346:	83 c0 10             	add    $0x10,%eax
80103349:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
80103350:	89 c2                	mov    %eax,%edx
80103352:	a1 44 37 11 80       	mov    0x80113744,%eax
80103357:	89 54 24 04          	mov    %edx,0x4(%esp)
8010335b:	89 04 24             	mov    %eax,(%esp)
8010335e:	e8 52 ce ff ff       	call   801001b5 <bread>
80103363:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103366:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103369:	8d 50 5c             	lea    0x5c(%eax),%edx
8010336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336f:	83 c0 5c             	add    $0x5c,%eax
80103372:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103379:	00 
8010337a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010337e:	89 04 24             	mov    %eax,(%esp)
80103381:	e8 71 1d 00 00       	call   801050f7 <memmove>
    bwrite(dbuf);  // write dst to disk
80103386:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103389:	89 04 24             	mov    %eax,(%esp)
8010338c:	e8 5b ce ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103394:	89 04 24             	mov    %eax,(%esp)
80103397:	e8 90 ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
8010339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010339f:	89 04 24             	mov    %eax,(%esp)
801033a2:	e8 85 ce ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033a7:	ff 45 f4             	incl   -0xc(%ebp)
801033aa:	a1 48 37 11 80       	mov    0x80113748,%eax
801033af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033b2:	0f 8f 69 ff ff ff    	jg     80103321 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801033b8:	c9                   	leave  
801033b9:	c3                   	ret    

801033ba <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033ba:	55                   	push   %ebp
801033bb:	89 e5                	mov    %esp,%ebp
801033bd:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c0:	a1 34 37 11 80       	mov    0x80113734,%eax
801033c5:	89 c2                	mov    %eax,%edx
801033c7:	a1 44 37 11 80       	mov    0x80113744,%eax
801033cc:	89 54 24 04          	mov    %edx,0x4(%esp)
801033d0:	89 04 24             	mov    %eax,(%esp)
801033d3:	e8 dd cd ff ff       	call   801001b5 <bread>
801033d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033de:	83 c0 5c             	add    $0x5c,%eax
801033e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e7:	8b 00                	mov    (%eax),%eax
801033e9:	a3 48 37 11 80       	mov    %eax,0x80113748
  for (i = 0; i < log.lh.n; i++) {
801033ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033f5:	eb 1a                	jmp    80103411 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
801033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033fd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103401:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103404:	83 c2 10             	add    $0x10,%edx
80103407:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010340e:	ff 45 f4             	incl   -0xc(%ebp)
80103411:	a1 48 37 11 80       	mov    0x80113748,%eax
80103416:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103419:	7f dc                	jg     801033f7 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010341e:	89 04 24             	mov    %eax,(%esp)
80103421:	e8 06 ce ff ff       	call   8010022c <brelse>
}
80103426:	c9                   	leave  
80103427:	c3                   	ret    

80103428 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103428:	55                   	push   %ebp
80103429:	89 e5                	mov    %esp,%ebp
8010342b:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010342e:	a1 34 37 11 80       	mov    0x80113734,%eax
80103433:	89 c2                	mov    %eax,%edx
80103435:	a1 44 37 11 80       	mov    0x80113744,%eax
8010343a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010343e:	89 04 24             	mov    %eax,(%esp)
80103441:	e8 6f cd ff ff       	call   801001b5 <bread>
80103446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010344c:	83 c0 5c             	add    $0x5c,%eax
8010344f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103452:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80103458:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345b:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010345d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103464:	eb 1a                	jmp    80103480 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
80103466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103469:	83 c0 10             	add    $0x10,%eax
8010346c:	8b 0c 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%ecx
80103473:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103476:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103479:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010347d:	ff 45 f4             	incl   -0xc(%ebp)
80103480:	a1 48 37 11 80       	mov    0x80113748,%eax
80103485:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103488:	7f dc                	jg     80103466 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348d:	89 04 24             	mov    %eax,(%esp)
80103490:	e8 57 cd ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103498:	89 04 24             	mov    %eax,(%esp)
8010349b:	e8 8c cd ff ff       	call   8010022c <brelse>
}
801034a0:	c9                   	leave  
801034a1:	c3                   	ret    

801034a2 <recover_from_log>:

static void
recover_from_log(void)
{
801034a2:	55                   	push   %ebp
801034a3:	89 e5                	mov    %esp,%ebp
801034a5:	83 ec 08             	sub    $0x8,%esp
  read_head();
801034a8:	e8 0d ff ff ff       	call   801033ba <read_head>
  install_trans(); // if committed, copy from log to disk
801034ad:	e8 5d fe ff ff       	call   8010330f <install_trans>
  log.lh.n = 0;
801034b2:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
801034b9:	00 00 00 
  write_head(); // clear the log
801034bc:	e8 67 ff ff ff       	call   80103428 <write_head>
}
801034c1:	c9                   	leave  
801034c2:	c3                   	ret    

801034c3 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034c3:	55                   	push   %ebp
801034c4:	89 e5                	mov    %esp,%ebp
801034c6:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034c9:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034d0:	e8 f6 18 00 00       	call   80104dcb <acquire>
  while(1){
    if(log.committing){
801034d5:	a1 40 37 11 80       	mov    0x80113740,%eax
801034da:	85 c0                	test   %eax,%eax
801034dc:	74 16                	je     801034f4 <begin_op+0x31>
      sleep(&log, &log.lock);
801034de:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
801034e5:	80 
801034e6:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034ed:	e8 0a 15 00 00       	call   801049fc <sleep>
801034f2:	eb 4d                	jmp    80103541 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034f4:	8b 15 48 37 11 80    	mov    0x80113748,%edx
801034fa:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801034ff:	8d 48 01             	lea    0x1(%eax),%ecx
80103502:	89 c8                	mov    %ecx,%eax
80103504:	c1 e0 02             	shl    $0x2,%eax
80103507:	01 c8                	add    %ecx,%eax
80103509:	01 c0                	add    %eax,%eax
8010350b:	01 d0                	add    %edx,%eax
8010350d:	83 f8 1e             	cmp    $0x1e,%eax
80103510:	7e 16                	jle    80103528 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103512:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
80103519:	80 
8010351a:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103521:	e8 d6 14 00 00       	call   801049fc <sleep>
80103526:	eb 19                	jmp    80103541 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
80103528:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010352d:	40                   	inc    %eax
8010352e:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
80103533:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010353a:	e8 f6 18 00 00       	call   80104e35 <release>
      break;
8010353f:	eb 02                	jmp    80103543 <begin_op+0x80>
    }
  }
80103541:	eb 92                	jmp    801034d5 <begin_op+0x12>
}
80103543:	c9                   	leave  
80103544:	c3                   	ret    

80103545 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103545:	55                   	push   %ebp
80103546:	89 e5                	mov    %esp,%ebp
80103548:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010354b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103552:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103559:	e8 6d 18 00 00       	call   80104dcb <acquire>
  log.outstanding -= 1;
8010355e:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103563:	48                   	dec    %eax
80103564:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
80103569:	a1 40 37 11 80       	mov    0x80113740,%eax
8010356e:	85 c0                	test   %eax,%eax
80103570:	74 0c                	je     8010357e <end_op+0x39>
    panic("log.committing");
80103572:	c7 04 24 15 84 10 80 	movl   $0x80108415,(%esp)
80103579:	e8 d6 cf ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
8010357e:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103583:	85 c0                	test   %eax,%eax
80103585:	75 13                	jne    8010359a <end_op+0x55>
    do_commit = 1;
80103587:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010358e:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80103595:	00 00 00 
80103598:	eb 0c                	jmp    801035a6 <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010359a:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035a1:	e8 2a 15 00 00       	call   80104ad0 <wakeup>
  }
  release(&log.lock);
801035a6:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035ad:	e8 83 18 00 00       	call   80104e35 <release>

  if(do_commit){
801035b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035b6:	74 33                	je     801035eb <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035b8:	e8 db 00 00 00       	call   80103698 <commit>
    acquire(&log.lock);
801035bd:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035c4:	e8 02 18 00 00       	call   80104dcb <acquire>
    log.committing = 0;
801035c9:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
801035d0:	00 00 00 
    wakeup(&log);
801035d3:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035da:	e8 f1 14 00 00       	call   80104ad0 <wakeup>
    release(&log.lock);
801035df:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035e6:	e8 4a 18 00 00       	call   80104e35 <release>
  }
}
801035eb:	c9                   	leave  
801035ec:	c3                   	ret    

801035ed <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801035ed:	55                   	push   %ebp
801035ee:	89 e5                	mov    %esp,%ebp
801035f0:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035fa:	e9 89 00 00 00       	jmp    80103688 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035ff:	8b 15 34 37 11 80    	mov    0x80113734,%edx
80103605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103608:	01 d0                	add    %edx,%eax
8010360a:	40                   	inc    %eax
8010360b:	89 c2                	mov    %eax,%edx
8010360d:	a1 44 37 11 80       	mov    0x80113744,%eax
80103612:	89 54 24 04          	mov    %edx,0x4(%esp)
80103616:	89 04 24             	mov    %eax,(%esp)
80103619:	e8 97 cb ff ff       	call   801001b5 <bread>
8010361e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103624:	83 c0 10             	add    $0x10,%eax
80103627:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
8010362e:	89 c2                	mov    %eax,%edx
80103630:	a1 44 37 11 80       	mov    0x80113744,%eax
80103635:	89 54 24 04          	mov    %edx,0x4(%esp)
80103639:	89 04 24             	mov    %eax,(%esp)
8010363c:	e8 74 cb ff ff       	call   801001b5 <bread>
80103641:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103644:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103647:	8d 50 5c             	lea    0x5c(%eax),%edx
8010364a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010364d:	83 c0 5c             	add    $0x5c,%eax
80103650:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103657:	00 
80103658:	89 54 24 04          	mov    %edx,0x4(%esp)
8010365c:	89 04 24             	mov    %eax,(%esp)
8010365f:	e8 93 1a 00 00       	call   801050f7 <memmove>
    bwrite(to);  // write the log
80103664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103667:	89 04 24             	mov    %eax,(%esp)
8010366a:	e8 7d cb ff ff       	call   801001ec <bwrite>
    brelse(from);
8010366f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103672:	89 04 24             	mov    %eax,(%esp)
80103675:	e8 b2 cb ff ff       	call   8010022c <brelse>
    brelse(to);
8010367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367d:	89 04 24             	mov    %eax,(%esp)
80103680:	e8 a7 cb ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103685:	ff 45 f4             	incl   -0xc(%ebp)
80103688:	a1 48 37 11 80       	mov    0x80113748,%eax
8010368d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103690:	0f 8f 69 ff ff ff    	jg     801035ff <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103696:	c9                   	leave  
80103697:	c3                   	ret    

80103698 <commit>:

static void
commit()
{
80103698:	55                   	push   %ebp
80103699:	89 e5                	mov    %esp,%ebp
8010369b:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010369e:	a1 48 37 11 80       	mov    0x80113748,%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	7e 1e                	jle    801036c5 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036a7:	e8 41 ff ff ff       	call   801035ed <write_log>
    write_head();    // Write header to disk -- the real commit
801036ac:	e8 77 fd ff ff       	call   80103428 <write_head>
    install_trans(); // Now install writes to home locations
801036b1:	e8 59 fc ff ff       	call   8010330f <install_trans>
    log.lh.n = 0;
801036b6:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
801036bd:	00 00 00 
    write_head();    // Erase the transaction from the log
801036c0:	e8 63 fd ff ff       	call   80103428 <write_head>
  }
}
801036c5:	c9                   	leave  
801036c6:	c3                   	ret    

801036c7 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036c7:	55                   	push   %ebp
801036c8:	89 e5                	mov    %esp,%ebp
801036ca:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036cd:	a1 48 37 11 80       	mov    0x80113748,%eax
801036d2:	83 f8 1d             	cmp    $0x1d,%eax
801036d5:	7f 10                	jg     801036e7 <log_write+0x20>
801036d7:	a1 48 37 11 80       	mov    0x80113748,%eax
801036dc:	8b 15 38 37 11 80    	mov    0x80113738,%edx
801036e2:	4a                   	dec    %edx
801036e3:	39 d0                	cmp    %edx,%eax
801036e5:	7c 0c                	jl     801036f3 <log_write+0x2c>
    panic("too big a transaction");
801036e7:	c7 04 24 24 84 10 80 	movl   $0x80108424,(%esp)
801036ee:	e8 61 ce ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
801036f3:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801036f8:	85 c0                	test   %eax,%eax
801036fa:	7f 0c                	jg     80103708 <log_write+0x41>
    panic("log_write outside of trans");
801036fc:	c7 04 24 3a 84 10 80 	movl   $0x8010843a,(%esp)
80103703:	e8 4c ce ff ff       	call   80100554 <panic>

  acquire(&log.lock);
80103708:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010370f:	e8 b7 16 00 00       	call   80104dcb <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010371b:	eb 1e                	jmp    8010373b <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103720:	83 c0 10             	add    $0x10,%eax
80103723:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
8010372a:	89 c2                	mov    %eax,%edx
8010372c:	8b 45 08             	mov    0x8(%ebp),%eax
8010372f:	8b 40 08             	mov    0x8(%eax),%eax
80103732:	39 c2                	cmp    %eax,%edx
80103734:	75 02                	jne    80103738 <log_write+0x71>
      break;
80103736:	eb 0d                	jmp    80103745 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103738:	ff 45 f4             	incl   -0xc(%ebp)
8010373b:	a1 48 37 11 80       	mov    0x80113748,%eax
80103740:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103743:	7f d8                	jg     8010371d <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103745:	8b 45 08             	mov    0x8(%ebp),%eax
80103748:	8b 40 08             	mov    0x8(%eax),%eax
8010374b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010374e:	83 c2 10             	add    $0x10,%edx
80103751:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  if (i == log.lh.n)
80103758:	a1 48 37 11 80       	mov    0x80113748,%eax
8010375d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103760:	75 0b                	jne    8010376d <log_write+0xa6>
    log.lh.n++;
80103762:	a1 48 37 11 80       	mov    0x80113748,%eax
80103767:	40                   	inc    %eax
80103768:	a3 48 37 11 80       	mov    %eax,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
8010376d:	8b 45 08             	mov    0x8(%ebp),%eax
80103770:	8b 00                	mov    (%eax),%eax
80103772:	83 c8 04             	or     $0x4,%eax
80103775:	89 c2                	mov    %eax,%edx
80103777:	8b 45 08             	mov    0x8(%ebp),%eax
8010377a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010377c:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103783:	e8 ad 16 00 00       	call   80104e35 <release>
}
80103788:	c9                   	leave  
80103789:	c3                   	ret    
	...

8010378c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010378c:	55                   	push   %ebp
8010378d:	89 e5                	mov    %esp,%ebp
8010378f:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103792:	8b 55 08             	mov    0x8(%ebp),%edx
80103795:	8b 45 0c             	mov    0xc(%ebp),%eax
80103798:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010379b:	f0 87 02             	lock xchg %eax,(%edx)
8010379e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037a4:	c9                   	leave  
801037a5:	c3                   	ret    

801037a6 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037a6:	55                   	push   %ebp
801037a7:	89 e5                	mov    %esp,%ebp
801037a9:	83 e4 f0             	and    $0xfffffff0,%esp
801037ac:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037af:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801037b6:	80 
801037b7:	c7 04 24 28 65 11 80 	movl   $0x80116528,(%esp)
801037be:	e8 0d f3 ff ff       	call   80102ad0 <kinit1>
  kvmalloc();      // kernel page table
801037c3:	e8 c7 41 00 00       	call   8010798f <kvmalloc>
  mpinit();        // detect other processors
801037c8:	e8 c4 03 00 00       	call   80103b91 <mpinit>
  lapicinit();     // interrupt controller
801037cd:	e8 4e f6 ff ff       	call   80102e20 <lapicinit>
  seginit();       // segment descriptors
801037d2:	e8 a0 3c 00 00       	call   80107477 <seginit>
  picinit();       // disable pic
801037d7:	e8 04 05 00 00       	call   80103ce0 <picinit>
  ioapicinit();    // another interrupt controller
801037dc:	e8 0c f2 ff ff       	call   801029ed <ioapicinit>
  consoleinit();   // console hardware
801037e1:	e8 77 d3 ff ff       	call   80100b5d <consoleinit>
  uartinit();      // serial port
801037e6:	e8 18 30 00 00       	call   80106803 <uartinit>
  pinit();         // process table
801037eb:	e8 e6 08 00 00       	call   801040d6 <pinit>
  tvinit();        // trap vectors
801037f0:	e8 f7 2b 00 00       	call   801063ec <tvinit>
  binit();         // buffer cache
801037f5:	e8 3a c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037fa:	e8 ed d7 ff ff       	call   80100fec <fileinit>
  ideinit();       // disk 
801037ff:	e8 f5 ed ff ff       	call   801025f9 <ideinit>
  startothers();   // start other processors
80103804:	e8 83 00 00 00       	call   8010388c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103809:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103810:	8e 
80103811:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103818:	e8 eb f2 ff ff       	call   80102b08 <kinit2>
  userinit();      // first user process
8010381d:	e8 c1 0a 00 00       	call   801042e3 <userinit>
  mpmain();        // finish this processor's setup
80103822:	e8 1a 00 00 00       	call   80103841 <mpmain>

80103827 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103827:	55                   	push   %ebp
80103828:	89 e5                	mov    %esp,%ebp
8010382a:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010382d:	e8 74 41 00 00       	call   801079a6 <switchkvm>
  seginit();
80103832:	e8 40 3c 00 00       	call   80107477 <seginit>
  lapicinit();
80103837:	e8 e4 f5 ff ff       	call   80102e20 <lapicinit>
  mpmain();
8010383c:	e8 00 00 00 00       	call   80103841 <mpmain>

80103841 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103841:	55                   	push   %ebp
80103842:	89 e5                	mov    %esp,%ebp
80103844:	53                   	push   %ebx
80103845:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103848:	e8 a5 08 00 00       	call   801040f2 <cpuid>
8010384d:	89 c3                	mov    %eax,%ebx
8010384f:	e8 9e 08 00 00       	call   801040f2 <cpuid>
80103854:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103858:	89 44 24 04          	mov    %eax,0x4(%esp)
8010385c:	c7 04 24 55 84 10 80 	movl   $0x80108455,(%esp)
80103863:	e8 59 cb ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
80103868:	e8 dc 2c 00 00       	call   80106549 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010386d:	e8 c5 08 00 00       	call   80104137 <mycpu>
80103872:	05 a0 00 00 00       	add    $0xa0,%eax
80103877:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010387e:	00 
8010387f:	89 04 24             	mov    %eax,(%esp)
80103882:	e8 05 ff ff ff       	call   8010378c <xchg>
  scheduler();     // start running processes
80103887:	e8 a6 0f 00 00       	call   80104832 <scheduler>

8010388c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010388c:	55                   	push   %ebp
8010388d:	89 e5                	mov    %esp,%ebp
8010388f:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103892:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103899:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010389e:	89 44 24 08          	mov    %eax,0x8(%esp)
801038a2:	c7 44 24 04 ec b4 10 	movl   $0x8010b4ec,0x4(%esp)
801038a9:	80 
801038aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ad:	89 04 24             	mov    %eax,(%esp)
801038b0:	e8 42 18 00 00       	call   801050f7 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038b5:	c7 45 f4 00 38 11 80 	movl   $0x80113800,-0xc(%ebp)
801038bc:	eb 75                	jmp    80103933 <startothers+0xa7>
    if(c == mycpu())  // We've started already.
801038be:	e8 74 08 00 00       	call   80104137 <mycpu>
801038c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038c6:	75 02                	jne    801038ca <startothers+0x3e>
      continue;
801038c8:	eb 62                	jmp    8010392c <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038ca:	e8 2c f3 ff ff       	call   80102bfb <kalloc>
801038cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d5:	83 e8 04             	sub    $0x4,%eax
801038d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038db:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038e1:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e6:	83 e8 08             	sub    $0x8,%eax
801038e9:	c7 00 27 38 10 80    	movl   $0x80103827,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f2:	8d 50 f4             	lea    -0xc(%eax),%edx
801038f5:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801038fa:	05 00 00 00 80       	add    $0x80000000,%eax
801038ff:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103901:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103904:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010390d:	8a 00                	mov    (%eax),%al
8010390f:	0f b6 c0             	movzbl %al,%eax
80103912:	89 54 24 04          	mov    %edx,0x4(%esp)
80103916:	89 04 24             	mov    %eax,(%esp)
80103919:	e8 a7 f6 ff ff       	call   80102fc5 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010391e:	90                   	nop
8010391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103922:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103928:	85 c0                	test   %eax,%eax
8010392a:	74 f3                	je     8010391f <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010392c:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103933:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103938:	89 c2                	mov    %eax,%edx
8010393a:	89 d0                	mov    %edx,%eax
8010393c:	c1 e0 02             	shl    $0x2,%eax
8010393f:	01 d0                	add    %edx,%eax
80103941:	01 c0                	add    %eax,%eax
80103943:	01 d0                	add    %edx,%eax
80103945:	c1 e0 04             	shl    $0x4,%eax
80103948:	05 00 38 11 80       	add    $0x80113800,%eax
8010394d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103950:	0f 87 68 ff ff ff    	ja     801038be <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103956:	c9                   	leave  
80103957:	c3                   	ret    

80103958 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103958:	55                   	push   %ebp
80103959:	89 e5                	mov    %esp,%ebp
8010395b:	83 ec 14             	sub    $0x14,%esp
8010395e:	8b 45 08             	mov    0x8(%ebp),%eax
80103961:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103968:	89 c2                	mov    %eax,%edx
8010396a:	ec                   	in     (%dx),%al
8010396b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010396e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103971:	c9                   	leave  
80103972:	c3                   	ret    

80103973 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103973:	55                   	push   %ebp
80103974:	89 e5                	mov    %esp,%ebp
80103976:	83 ec 08             	sub    $0x8,%esp
80103979:	8b 45 08             	mov    0x8(%ebp),%eax
8010397c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010397f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103983:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103986:	8a 45 f8             	mov    -0x8(%ebp),%al
80103989:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010398c:	ee                   	out    %al,(%dx)
}
8010398d:	c9                   	leave  
8010398e:	c3                   	ret    

8010398f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
8010398f:	55                   	push   %ebp
80103990:	89 e5                	mov    %esp,%ebp
80103992:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103995:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010399c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801039a3:	eb 13                	jmp    801039b8 <sum+0x29>
    sum += addr[i];
801039a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039a8:	8b 45 08             	mov    0x8(%ebp),%eax
801039ab:	01 d0                	add    %edx,%eax
801039ad:	8a 00                	mov    (%eax),%al
801039af:	0f b6 c0             	movzbl %al,%eax
801039b2:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801039b5:	ff 45 fc             	incl   -0x4(%ebp)
801039b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039be:	7c e5                	jl     801039a5 <sum+0x16>
    sum += addr[i];
  return sum;
801039c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039c3:	c9                   	leave  
801039c4:	c3                   	ret    

801039c5 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039c5:	55                   	push   %ebp
801039c6:	89 e5                	mov    %esp,%ebp
801039c8:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
801039cb:	8b 45 08             	mov    0x8(%ebp),%eax
801039ce:	05 00 00 00 80       	add    $0x80000000,%eax
801039d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801039d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039dc:	01 d0                	add    %edx,%eax
801039de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039e7:	eb 3f                	jmp    80103a28 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039e9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039f0:	00 
801039f1:	c7 44 24 04 6c 84 10 	movl   $0x8010846c,0x4(%esp)
801039f8:	80 
801039f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039fc:	89 04 24             	mov    %eax,(%esp)
801039ff:	e8 a1 16 00 00       	call   801050a5 <memcmp>
80103a04:	85 c0                	test   %eax,%eax
80103a06:	75 1c                	jne    80103a24 <mpsearch1+0x5f>
80103a08:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a0f:	00 
80103a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a13:	89 04 24             	mov    %eax,(%esp)
80103a16:	e8 74 ff ff ff       	call   8010398f <sum>
80103a1b:	84 c0                	test   %al,%al
80103a1d:	75 05                	jne    80103a24 <mpsearch1+0x5f>
      return (struct mp*)p;
80103a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a22:	eb 11                	jmp    80103a35 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a24:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a2e:	72 b9                	jb     801039e9 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a35:	c9                   	leave  
80103a36:	c3                   	ret    

80103a37 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a37:	55                   	push   %ebp
80103a38:	89 e5                	mov    %esp,%ebp
80103a3a:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a3d:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a47:	83 c0 0f             	add    $0xf,%eax
80103a4a:	8a 00                	mov    (%eax),%al
80103a4c:	0f b6 c0             	movzbl %al,%eax
80103a4f:	c1 e0 08             	shl    $0x8,%eax
80103a52:	89 c2                	mov    %eax,%edx
80103a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a57:	83 c0 0e             	add    $0xe,%eax
80103a5a:	8a 00                	mov    (%eax),%al
80103a5c:	0f b6 c0             	movzbl %al,%eax
80103a5f:	09 d0                	or     %edx,%eax
80103a61:	c1 e0 04             	shl    $0x4,%eax
80103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a6b:	74 21                	je     80103a8e <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103a6d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a74:	00 
80103a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a78:	89 04 24             	mov    %eax,(%esp)
80103a7b:	e8 45 ff ff ff       	call   801039c5 <mpsearch1>
80103a80:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a87:	74 4e                	je     80103ad7 <mpsearch+0xa0>
      return mp;
80103a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a8c:	eb 5d                	jmp    80103aeb <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a91:	83 c0 14             	add    $0x14,%eax
80103a94:	8a 00                	mov    (%eax),%al
80103a96:	0f b6 c0             	movzbl %al,%eax
80103a99:	c1 e0 08             	shl    $0x8,%eax
80103a9c:	89 c2                	mov    %eax,%edx
80103a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa1:	83 c0 13             	add    $0x13,%eax
80103aa4:	8a 00                	mov    (%eax),%al
80103aa6:	0f b6 c0             	movzbl %al,%eax
80103aa9:	09 d0                	or     %edx,%eax
80103aab:	c1 e0 0a             	shl    $0xa,%eax
80103aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab4:	2d 00 04 00 00       	sub    $0x400,%eax
80103ab9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ac0:	00 
80103ac1:	89 04 24             	mov    %eax,(%esp)
80103ac4:	e8 fc fe ff ff       	call   801039c5 <mpsearch1>
80103ac9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103acc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ad0:	74 05                	je     80103ad7 <mpsearch+0xa0>
      return mp;
80103ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ad5:	eb 14                	jmp    80103aeb <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ad7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ade:	00 
80103adf:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ae6:	e8 da fe ff ff       	call   801039c5 <mpsearch1>
}
80103aeb:	c9                   	leave  
80103aec:	c3                   	ret    

80103aed <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103aed:	55                   	push   %ebp
80103aee:	89 e5                	mov    %esp,%ebp
80103af0:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103af3:	e8 3f ff ff ff       	call   80103a37 <mpsearch>
80103af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103aff:	74 0a                	je     80103b0b <mpconfig+0x1e>
80103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b04:	8b 40 04             	mov    0x4(%eax),%eax
80103b07:	85 c0                	test   %eax,%eax
80103b09:	75 07                	jne    80103b12 <mpconfig+0x25>
    return 0;
80103b0b:	b8 00 00 00 00       	mov    $0x0,%eax
80103b10:	eb 7d                	jmp    80103b8f <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b15:	8b 40 04             	mov    0x4(%eax),%eax
80103b18:	05 00 00 00 80       	add    $0x80000000,%eax
80103b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b20:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b27:	00 
80103b28:	c7 44 24 04 71 84 10 	movl   $0x80108471,0x4(%esp)
80103b2f:	80 
80103b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b33:	89 04 24             	mov    %eax,(%esp)
80103b36:	e8 6a 15 00 00       	call   801050a5 <memcmp>
80103b3b:	85 c0                	test   %eax,%eax
80103b3d:	74 07                	je     80103b46 <mpconfig+0x59>
    return 0;
80103b3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103b44:	eb 49                	jmp    80103b8f <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b49:	8a 40 06             	mov    0x6(%eax),%al
80103b4c:	3c 01                	cmp    $0x1,%al
80103b4e:	74 11                	je     80103b61 <mpconfig+0x74>
80103b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b53:	8a 40 06             	mov    0x6(%eax),%al
80103b56:	3c 04                	cmp    $0x4,%al
80103b58:	74 07                	je     80103b61 <mpconfig+0x74>
    return 0;
80103b5a:	b8 00 00 00 00       	mov    $0x0,%eax
80103b5f:	eb 2e                	jmp    80103b8f <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b64:	8b 40 04             	mov    0x4(%eax),%eax
80103b67:	0f b7 c0             	movzwl %ax,%eax
80103b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b71:	89 04 24             	mov    %eax,(%esp)
80103b74:	e8 16 fe ff ff       	call   8010398f <sum>
80103b79:	84 c0                	test   %al,%al
80103b7b:	74 07                	je     80103b84 <mpconfig+0x97>
    return 0;
80103b7d:	b8 00 00 00 00       	mov    $0x0,%eax
80103b82:	eb 0b                	jmp    80103b8f <mpconfig+0xa2>
  *pmp = mp;
80103b84:	8b 45 08             	mov    0x8(%ebp),%eax
80103b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b8a:	89 10                	mov    %edx,(%eax)
  return conf;
80103b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b8f:	c9                   	leave  
80103b90:	c3                   	ret    

80103b91 <mpinit>:

void
mpinit(void)
{
80103b91:	55                   	push   %ebp
80103b92:	89 e5                	mov    %esp,%ebp
80103b94:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b97:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103b9a:	89 04 24             	mov    %eax,(%esp)
80103b9d:	e8 4b ff ff ff       	call   80103aed <mpconfig>
80103ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ba5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ba9:	75 0c                	jne    80103bb7 <mpinit+0x26>
    panic("Expect to run on an SMP");
80103bab:	c7 04 24 76 84 10 80 	movl   $0x80108476,(%esp)
80103bb2:	e8 9d c9 ff ff       	call   80100554 <panic>
  ismp = 1;
80103bb7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bc1:	8b 40 24             	mov    0x24(%eax),%eax
80103bc4:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bcc:	83 c0 2c             	add    $0x2c,%eax
80103bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bd5:	8b 40 04             	mov    0x4(%eax),%eax
80103bd8:	0f b7 d0             	movzwl %ax,%edx
80103bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bde:	01 d0                	add    %edx,%eax
80103be0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103be3:	eb 7d                	jmp    80103c62 <mpinit+0xd1>
    switch(*p){
80103be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be8:	8a 00                	mov    (%eax),%al
80103bea:	0f b6 c0             	movzbl %al,%eax
80103bed:	83 f8 04             	cmp    $0x4,%eax
80103bf0:	77 68                	ja     80103c5a <mpinit+0xc9>
80103bf2:	8b 04 85 b0 84 10 80 	mov    -0x7fef7b50(,%eax,4),%eax
80103bf9:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103c01:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103c06:	83 f8 07             	cmp    $0x7,%eax
80103c09:	7f 2c                	jg     80103c37 <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c0b:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
80103c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c14:	8a 48 01             	mov    0x1(%eax),%cl
80103c17:	89 d0                	mov    %edx,%eax
80103c19:	c1 e0 02             	shl    $0x2,%eax
80103c1c:	01 d0                	add    %edx,%eax
80103c1e:	01 c0                	add    %eax,%eax
80103c20:	01 d0                	add    %edx,%eax
80103c22:	c1 e0 04             	shl    $0x4,%eax
80103c25:	05 00 38 11 80       	add    $0x80113800,%eax
80103c2a:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103c2c:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103c31:	40                   	inc    %eax
80103c32:	a3 80 3d 11 80       	mov    %eax,0x80113d80
      }
      p += sizeof(struct mpproc);
80103c37:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c3b:	eb 25                	jmp    80103c62 <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c46:	8a 40 01             	mov    0x1(%eax),%al
80103c49:	a2 e0 37 11 80       	mov    %al,0x801137e0
      p += sizeof(struct mpioapic);
80103c4e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c52:	eb 0e                	jmp    80103c62 <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c54:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c58:	eb 08                	jmp    80103c62 <mpinit+0xd1>
    default:
      ismp = 0;
80103c5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103c61:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c65:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103c68:	0f 82 77 ff ff ff    	jb     80103be5 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103c6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c72:	75 0c                	jne    80103c80 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103c74:	c7 04 24 90 84 10 80 	movl   $0x80108490,(%esp)
80103c7b:	e8 d4 c8 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80103c80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103c83:	8a 40 0c             	mov    0xc(%eax),%al
80103c86:	84 c0                	test   %al,%al
80103c88:	74 36                	je     80103cc0 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103c8a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103c91:	00 
80103c92:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103c99:	e8 d5 fc ff ff       	call   80103973 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c9e:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ca5:	e8 ae fc ff ff       	call   80103958 <inb>
80103caa:	83 c8 01             	or     $0x1,%eax
80103cad:	0f b6 c0             	movzbl %al,%eax
80103cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cb4:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103cbb:	e8 b3 fc ff ff       	call   80103973 <outb>
  }
}
80103cc0:	c9                   	leave  
80103cc1:	c3                   	ret    
	...

80103cc4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	83 ec 08             	sub    $0x8,%esp
80103cca:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cd0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103cd4:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cd7:	8a 45 f8             	mov    -0x8(%ebp),%al
80103cda:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103cdd:	ee                   	out    %al,(%dx)
}
80103cde:	c9                   	leave  
80103cdf:	c3                   	ret    

80103ce0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ce6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ced:	00 
80103cee:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103cf5:	e8 ca ff ff ff       	call   80103cc4 <outb>
  outb(IO_PIC2+1, 0xFF);
80103cfa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103d01:	00 
80103d02:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103d09:	e8 b6 ff ff ff       	call   80103cc4 <outb>
}
80103d0e:	c9                   	leave  
80103d0f:	c3                   	ret    

80103d10 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103d16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d29:	8b 10                	mov    (%eax),%edx
80103d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d30:	e8 d3 d2 ff ff       	call   80101008 <filealloc>
80103d35:	8b 55 08             	mov    0x8(%ebp),%edx
80103d38:	89 02                	mov    %eax,(%edx)
80103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3d:	8b 00                	mov    (%eax),%eax
80103d3f:	85 c0                	test   %eax,%eax
80103d41:	0f 84 c8 00 00 00    	je     80103e0f <pipealloc+0xff>
80103d47:	e8 bc d2 ff ff       	call   80101008 <filealloc>
80103d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d4f:	89 02                	mov    %eax,(%edx)
80103d51:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d54:	8b 00                	mov    (%eax),%eax
80103d56:	85 c0                	test   %eax,%eax
80103d58:	0f 84 b1 00 00 00    	je     80103e0f <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d5e:	e8 98 ee ff ff       	call   80102bfb <kalloc>
80103d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d6a:	75 05                	jne    80103d71 <pipealloc+0x61>
    goto bad;
80103d6c:	e9 9e 00 00 00       	jmp    80103e0f <pipealloc+0xff>
  p->readopen = 1;
80103d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d74:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d7b:	00 00 00 
  p->writeopen = 1;
80103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d81:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d88:	00 00 00 
  p->nwrite = 0;
80103d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d95:	00 00 00 
  p->nread = 0;
80103d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103da2:	00 00 00 
  initlock(&p->lock, "pipe");
80103da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da8:	c7 44 24 04 c4 84 10 	movl   $0x801084c4,0x4(%esp)
80103daf:	80 
80103db0:	89 04 24             	mov    %eax,(%esp)
80103db3:	e8 f2 0f 00 00       	call   80104daa <initlock>
  (*f0)->type = FD_PIPE;
80103db8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbb:	8b 00                	mov    (%eax),%eax
80103dbd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc6:	8b 00                	mov    (%eax),%eax
80103dc8:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcf:	8b 00                	mov    (%eax),%eax
80103dd1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd8:	8b 00                	mov    (%eax),%eax
80103dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ddd:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de3:	8b 00                	mov    (%eax),%eax
80103de5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dee:	8b 00                	mov    (%eax),%eax
80103df0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df7:	8b 00                	mov    (%eax),%eax
80103df9:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e00:	8b 00                	mov    (%eax),%eax
80103e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e05:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103e08:	b8 00 00 00 00       	mov    $0x0,%eax
80103e0d:	eb 42                	jmp    80103e51 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e13:	74 0b                	je     80103e20 <pipealloc+0x110>
    kfree((char*)p);
80103e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e18:	89 04 24             	mov    %eax,(%esp)
80103e1b:	e8 45 ed ff ff       	call   80102b65 <kfree>
  if(*f0)
80103e20:	8b 45 08             	mov    0x8(%ebp),%eax
80103e23:	8b 00                	mov    (%eax),%eax
80103e25:	85 c0                	test   %eax,%eax
80103e27:	74 0d                	je     80103e36 <pipealloc+0x126>
    fileclose(*f0);
80103e29:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2c:	8b 00                	mov    (%eax),%eax
80103e2e:	89 04 24             	mov    %eax,(%esp)
80103e31:	e8 7a d2 ff ff       	call   801010b0 <fileclose>
  if(*f1)
80103e36:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e39:	8b 00                	mov    (%eax),%eax
80103e3b:	85 c0                	test   %eax,%eax
80103e3d:	74 0d                	je     80103e4c <pipealloc+0x13c>
    fileclose(*f1);
80103e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e42:	8b 00                	mov    (%eax),%eax
80103e44:	89 04 24             	mov    %eax,(%esp)
80103e47:	e8 64 d2 ff ff       	call   801010b0 <fileclose>
  return -1;
80103e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e51:	c9                   	leave  
80103e52:	c3                   	ret    

80103e53 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e53:	55                   	push   %ebp
80103e54:	89 e5                	mov    %esp,%ebp
80103e56:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e59:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5c:	89 04 24             	mov    %eax,(%esp)
80103e5f:	e8 67 0f 00 00       	call   80104dcb <acquire>
  if(writable){
80103e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e68:	74 1f                	je     80103e89 <pipeclose+0x36>
    p->writeopen = 0;
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e74:	00 00 00 
    wakeup(&p->nread);
80103e77:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7a:	05 34 02 00 00       	add    $0x234,%eax
80103e7f:	89 04 24             	mov    %eax,(%esp)
80103e82:	e8 49 0c 00 00       	call   80104ad0 <wakeup>
80103e87:	eb 1d                	jmp    80103ea6 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e89:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8c:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e93:	00 00 00 
    wakeup(&p->nwrite);
80103e96:	8b 45 08             	mov    0x8(%ebp),%eax
80103e99:	05 38 02 00 00       	add    $0x238,%eax
80103e9e:	89 04 24             	mov    %eax,(%esp)
80103ea1:	e8 2a 0c 00 00       	call   80104ad0 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea9:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103eaf:	85 c0                	test   %eax,%eax
80103eb1:	75 25                	jne    80103ed8 <pipeclose+0x85>
80103eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ebc:	85 c0                	test   %eax,%eax
80103ebe:	75 18                	jne    80103ed8 <pipeclose+0x85>
    release(&p->lock);
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	89 04 24             	mov    %eax,(%esp)
80103ec6:	e8 6a 0f 00 00       	call   80104e35 <release>
    kfree((char*)p);
80103ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ece:	89 04 24             	mov    %eax,(%esp)
80103ed1:	e8 8f ec ff ff       	call   80102b65 <kfree>
80103ed6:	eb 0b                	jmp    80103ee3 <pipeclose+0x90>
  } else
    release(&p->lock);
80103ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80103edb:	89 04 24             	mov    %eax,(%esp)
80103ede:	e8 52 0f 00 00       	call   80104e35 <release>
}
80103ee3:	c9                   	leave  
80103ee4:	c3                   	ret    

80103ee5 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ee5:	55                   	push   %ebp
80103ee6:	89 e5                	mov    %esp,%ebp
80103ee8:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80103eee:	89 04 24             	mov    %eax,(%esp)
80103ef1:	e8 d5 0e 00 00       	call   80104dcb <acquire>
  for(i = 0; i < n; i++){
80103ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103efd:	e9 a3 00 00 00       	jmp    80103fa5 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f02:	eb 56                	jmp    80103f5a <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f0d:	85 c0                	test   %eax,%eax
80103f0f:	74 0c                	je     80103f1d <pipewrite+0x38>
80103f11:	e8 a5 02 00 00       	call   801041bb <myproc>
80103f16:	8b 40 24             	mov    0x24(%eax),%eax
80103f19:	85 c0                	test   %eax,%eax
80103f1b:	74 15                	je     80103f32 <pipewrite+0x4d>
        release(&p->lock);
80103f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f20:	89 04 24             	mov    %eax,(%esp)
80103f23:	e8 0d 0f 00 00       	call   80104e35 <release>
        return -1;
80103f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2d:	e9 9d 00 00 00       	jmp    80103fcf <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103f32:	8b 45 08             	mov    0x8(%ebp),%eax
80103f35:	05 34 02 00 00       	add    $0x234,%eax
80103f3a:	89 04 24             	mov    %eax,(%esp)
80103f3d:	e8 8e 0b 00 00       	call   80104ad0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f42:	8b 45 08             	mov    0x8(%ebp),%eax
80103f45:	8b 55 08             	mov    0x8(%ebp),%edx
80103f48:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f52:	89 14 24             	mov    %edx,(%esp)
80103f55:	e8 a2 0a 00 00       	call   801049fc <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5d:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f63:	8b 45 08             	mov    0x8(%ebp),%eax
80103f66:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f6c:	05 00 02 00 00       	add    $0x200,%eax
80103f71:	39 c2                	cmp    %eax,%edx
80103f73:	74 8f                	je     80103f04 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f7e:	8d 48 01             	lea    0x1(%eax),%ecx
80103f81:	8b 55 08             	mov    0x8(%ebp),%edx
80103f84:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f8a:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f8f:	89 c1                	mov    %eax,%ecx
80103f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f97:	01 d0                	add    %edx,%eax
80103f99:	8a 10                	mov    (%eax),%dl
80103f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103fa2:	ff 45 f4             	incl   -0xc(%ebp)
80103fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa8:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fab:	0f 8c 51 ff ff ff    	jl     80103f02 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb4:	05 34 02 00 00       	add    $0x234,%eax
80103fb9:	89 04 24             	mov    %eax,(%esp)
80103fbc:	e8 0f 0b 00 00       	call   80104ad0 <wakeup>
  release(&p->lock);
80103fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc4:	89 04 24             	mov    %eax,(%esp)
80103fc7:	e8 69 0e 00 00       	call   80104e35 <release>
  return n;
80103fcc:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103fcf:	c9                   	leave  
80103fd0:	c3                   	ret    

80103fd1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fd1:	55                   	push   %ebp
80103fd2:	89 e5                	mov    %esp,%ebp
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdb:	89 04 24             	mov    %eax,(%esp)
80103fde:	e8 e8 0d 00 00       	call   80104dcb <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fe3:	eb 39                	jmp    8010401e <piperead+0x4d>
    if(myproc()->killed){
80103fe5:	e8 d1 01 00 00       	call   801041bb <myproc>
80103fea:	8b 40 24             	mov    0x24(%eax),%eax
80103fed:	85 c0                	test   %eax,%eax
80103fef:	74 15                	je     80104006 <piperead+0x35>
      release(&p->lock);
80103ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff4:	89 04 24             	mov    %eax,(%esp)
80103ff7:	e8 39 0e 00 00       	call   80104e35 <release>
      return -1;
80103ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104001:	e9 b3 00 00 00       	jmp    801040b9 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104006:	8b 45 08             	mov    0x8(%ebp),%eax
80104009:	8b 55 08             	mov    0x8(%ebp),%edx
8010400c:	81 c2 34 02 00 00    	add    $0x234,%edx
80104012:	89 44 24 04          	mov    %eax,0x4(%esp)
80104016:	89 14 24             	mov    %edx,(%esp)
80104019:	e8 de 09 00 00       	call   801049fc <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010401e:	8b 45 08             	mov    0x8(%ebp),%eax
80104021:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104030:	39 c2                	cmp    %eax,%edx
80104032:	75 0d                	jne    80104041 <piperead+0x70>
80104034:	8b 45 08             	mov    0x8(%ebp),%eax
80104037:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010403d:	85 c0                	test   %eax,%eax
8010403f:	75 a4                	jne    80103fe5 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104048:	eb 49                	jmp    80104093 <piperead+0xc2>
    if(p->nread == p->nwrite)
8010404a:	8b 45 08             	mov    0x8(%ebp),%eax
8010404d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104053:	8b 45 08             	mov    0x8(%ebp),%eax
80104056:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010405c:	39 c2                	cmp    %eax,%edx
8010405e:	75 02                	jne    80104062 <piperead+0x91>
      break;
80104060:	eb 39                	jmp    8010409b <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104062:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104065:	8b 45 0c             	mov    0xc(%ebp),%eax
80104068:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010406b:	8b 45 08             	mov    0x8(%ebp),%eax
8010406e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104074:	8d 48 01             	lea    0x1(%eax),%ecx
80104077:	8b 55 08             	mov    0x8(%ebp),%edx
8010407a:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104080:	25 ff 01 00 00       	and    $0x1ff,%eax
80104085:	89 c2                	mov    %eax,%edx
80104087:	8b 45 08             	mov    0x8(%ebp),%eax
8010408a:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
8010408e:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104090:	ff 45 f4             	incl   -0xc(%ebp)
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	3b 45 10             	cmp    0x10(%ebp),%eax
80104099:	7c af                	jl     8010404a <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010409b:	8b 45 08             	mov    0x8(%ebp),%eax
8010409e:	05 38 02 00 00       	add    $0x238,%eax
801040a3:	89 04 24             	mov    %eax,(%esp)
801040a6:	e8 25 0a 00 00       	call   80104ad0 <wakeup>
  release(&p->lock);
801040ab:	8b 45 08             	mov    0x8(%ebp),%eax
801040ae:	89 04 24             	mov    %eax,(%esp)
801040b1:	e8 7f 0d 00 00       	call   80104e35 <release>
  return i;
801040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040b9:	83 c4 24             	add    $0x24,%esp
801040bc:	5b                   	pop    %ebx
801040bd:	5d                   	pop    %ebp
801040be:	c3                   	ret    
	...

801040c0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c6:	9c                   	pushf  
801040c7:	58                   	pop    %eax
801040c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801040cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040ce:	c9                   	leave  
801040cf:	c3                   	ret    

801040d0 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040d3:	fb                   	sti    
}
801040d4:	5d                   	pop    %ebp
801040d5:	c3                   	ret    

801040d6 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801040d6:	55                   	push   %ebp
801040d7:	89 e5                	mov    %esp,%ebp
801040d9:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801040dc:	c7 44 24 04 cc 84 10 	movl   $0x801084cc,0x4(%esp)
801040e3:	80 
801040e4:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801040eb:	e8 ba 0c 00 00       	call   80104daa <initlock>
}
801040f0:	c9                   	leave  
801040f1:	c3                   	ret    

801040f2 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801040f2:	55                   	push   %ebp
801040f3:	89 e5                	mov    %esp,%ebp
801040f5:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040f8:	e8 3a 00 00 00       	call   80104137 <mycpu>
801040fd:	89 c2                	mov    %eax,%edx
801040ff:	b8 00 38 11 80       	mov    $0x80113800,%eax
80104104:	29 c2                	sub    %eax,%edx
80104106:	89 d0                	mov    %edx,%eax
80104108:	c1 f8 04             	sar    $0x4,%eax
8010410b:	89 c1                	mov    %eax,%ecx
8010410d:	89 ca                	mov    %ecx,%edx
8010410f:	c1 e2 03             	shl    $0x3,%edx
80104112:	01 ca                	add    %ecx,%edx
80104114:	89 d0                	mov    %edx,%eax
80104116:	c1 e0 05             	shl    $0x5,%eax
80104119:	29 d0                	sub    %edx,%eax
8010411b:	c1 e0 02             	shl    $0x2,%eax
8010411e:	01 c8                	add    %ecx,%eax
80104120:	c1 e0 03             	shl    $0x3,%eax
80104123:	01 c8                	add    %ecx,%eax
80104125:	89 c2                	mov    %eax,%edx
80104127:	c1 e2 0f             	shl    $0xf,%edx
8010412a:	29 c2                	sub    %eax,%edx
8010412c:	c1 e2 02             	shl    $0x2,%edx
8010412f:	01 ca                	add    %ecx,%edx
80104131:	89 d0                	mov    %edx,%eax
80104133:	f7 d8                	neg    %eax
}
80104135:	c9                   	leave  
80104136:	c3                   	ret    

80104137 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104137:	55                   	push   %ebp
80104138:	89 e5                	mov    %esp,%ebp
8010413a:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010413d:	e8 7e ff ff ff       	call   801040c0 <readeflags>
80104142:	25 00 02 00 00       	and    $0x200,%eax
80104147:	85 c0                	test   %eax,%eax
80104149:	74 0c                	je     80104157 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
8010414b:	c7 04 24 d4 84 10 80 	movl   $0x801084d4,(%esp)
80104152:	e8 fd c3 ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
80104157:	e8 1d ee ff ff       	call   80102f79 <lapicid>
8010415c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010415f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104166:	eb 3b                	jmp    801041a3 <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
80104168:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010416b:	89 d0                	mov    %edx,%eax
8010416d:	c1 e0 02             	shl    $0x2,%eax
80104170:	01 d0                	add    %edx,%eax
80104172:	01 c0                	add    %eax,%eax
80104174:	01 d0                	add    %edx,%eax
80104176:	c1 e0 04             	shl    $0x4,%eax
80104179:	05 00 38 11 80       	add    $0x80113800,%eax
8010417e:	8a 00                	mov    (%eax),%al
80104180:	0f b6 c0             	movzbl %al,%eax
80104183:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104186:	75 18                	jne    801041a0 <mycpu+0x69>
      return &cpus[i];
80104188:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010418b:	89 d0                	mov    %edx,%eax
8010418d:	c1 e0 02             	shl    $0x2,%eax
80104190:	01 d0                	add    %edx,%eax
80104192:	01 c0                	add    %eax,%eax
80104194:	01 d0                	add    %edx,%eax
80104196:	c1 e0 04             	shl    $0x4,%eax
80104199:	05 00 38 11 80       	add    $0x80113800,%eax
8010419e:	eb 19                	jmp    801041b9 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801041a0:	ff 45 f4             	incl   -0xc(%ebp)
801041a3:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801041a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801041ab:	7c bb                	jl     80104168 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801041ad:	c7 04 24 fa 84 10 80 	movl   $0x801084fa,(%esp)
801041b4:	e8 9b c3 ff ff       	call   80100554 <panic>
}
801041b9:	c9                   	leave  
801041ba:	c3                   	ret    

801041bb <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801041bb:	55                   	push   %ebp
801041bc:	89 e5                	mov    %esp,%ebp
801041be:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801041c1:	e8 64 0d 00 00       	call   80104f2a <pushcli>
  c = mycpu();
801041c6:	e8 6c ff ff ff       	call   80104137 <mycpu>
801041cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801041d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801041da:	e8 95 0d 00 00       	call   80104f74 <popcli>
  return p;
801041df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801041e2:	c9                   	leave  
801041e3:	c3                   	ret    

801041e4 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041ea:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801041f1:	e8 d5 0b 00 00       	call   80104dcb <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f6:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801041fd:	eb 50                	jmp    8010424f <allocproc+0x6b>
    if(p->state == UNUSED)
801041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104202:	8b 40 0c             	mov    0xc(%eax),%eax
80104205:	85 c0                	test   %eax,%eax
80104207:	75 42                	jne    8010424b <allocproc+0x67>
      goto found;
80104209:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010420a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420d:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104214:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104219:	8d 50 01             	lea    0x1(%eax),%edx
8010421c:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
80104222:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104225:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104228:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010422f:	e8 01 0c 00 00       	call   80104e35 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104234:	e8 c2 e9 ff ff       	call   80102bfb <kalloc>
80104239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423c:	89 42 08             	mov    %eax,0x8(%edx)
8010423f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104242:	8b 40 08             	mov    0x8(%eax),%eax
80104245:	85 c0                	test   %eax,%eax
80104247:	75 33                	jne    8010427c <allocproc+0x98>
80104249:	eb 20                	jmp    8010426b <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010424b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010424f:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104256:	72 a7                	jb     801041ff <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80104258:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010425f:	e8 d1 0b 00 00       	call   80104e35 <release>
  return 0;
80104264:	b8 00 00 00 00       	mov    $0x0,%eax
80104269:	eb 76                	jmp    801042e1 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010426b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104275:	b8 00 00 00 00       	mov    $0x0,%eax
8010427a:	eb 65                	jmp    801042e1 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
8010427c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427f:	8b 40 08             	mov    0x8(%eax),%eax
80104282:	05 00 10 00 00       	add    $0x1000,%eax
80104287:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010428a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010428e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104291:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104294:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104297:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010429b:	ba a8 63 10 80       	mov    $0x801063a8,%edx
801042a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042a3:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801042a5:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801042a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042af:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801042b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b5:	8b 40 1c             	mov    0x1c(%eax),%eax
801042b8:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801042bf:	00 
801042c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042c7:	00 
801042c8:	89 04 24             	mov    %eax,(%esp)
801042cb:	e8 5e 0d 00 00       	call   8010502e <memset>
  p->context->eip = (uint)forkret;
801042d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d3:	8b 40 1c             	mov    0x1c(%eax),%eax
801042d6:	ba bd 49 10 80       	mov    $0x801049bd,%edx
801042db:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801042de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e1:	c9                   	leave  
801042e2:	c3                   	ret    

801042e3 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801042e3:	55                   	push   %ebp
801042e4:	89 e5                	mov    %esp,%ebp
801042e6:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801042e9:	e8 f6 fe ff ff       	call   801041e4 <allocproc>
801042ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801042f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f4:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
801042f9:	e8 e8 35 00 00       	call   801078e6 <setupkvm>
801042fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104301:	89 42 04             	mov    %eax,0x4(%edx)
80104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104307:	8b 40 04             	mov    0x4(%eax),%eax
8010430a:	85 c0                	test   %eax,%eax
8010430c:	75 0c                	jne    8010431a <userinit+0x37>
    panic("userinit: out of memory?");
8010430e:	c7 04 24 0a 85 10 80 	movl   $0x8010850a,(%esp)
80104315:	e8 3a c2 ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010431a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010431f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104322:	8b 40 04             	mov    0x4(%eax),%eax
80104325:	89 54 24 08          	mov    %edx,0x8(%esp)
80104329:	c7 44 24 04 c0 b4 10 	movl   $0x8010b4c0,0x4(%esp)
80104330:	80 
80104331:	89 04 24             	mov    %eax,(%esp)
80104334:	e8 0e 38 00 00       	call   80107b47 <inituvm>
  p->sz = PGSIZE;
80104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433c:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104345:	8b 40 18             	mov    0x18(%eax),%eax
80104348:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010434f:	00 
80104350:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104357:	00 
80104358:	89 04 24             	mov    %eax,(%esp)
8010435b:	e8 ce 0c 00 00       	call   8010502e <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104363:	8b 40 18             	mov    0x18(%eax),%eax
80104366:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010436c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436f:	8b 40 18             	mov    0x18(%eax),%eax
80104372:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437b:	8b 50 18             	mov    0x18(%eax),%edx
8010437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104381:	8b 40 18             	mov    0x18(%eax),%eax
80104384:	8b 40 2c             	mov    0x2c(%eax),%eax
80104387:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
8010438b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438e:	8b 50 18             	mov    0x18(%eax),%edx
80104391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104394:	8b 40 18             	mov    0x18(%eax),%eax
80104397:	8b 40 2c             	mov    0x2c(%eax),%eax
8010439a:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
8010439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a1:	8b 40 18             	mov    0x18(%eax),%eax
801043a4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ae:	8b 40 18             	mov    0x18(%eax),%eax
801043b1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bb:	8b 40 18             	mov    0x18(%eax),%eax
801043be:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801043c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c8:	83 c0 6c             	add    $0x6c,%eax
801043cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043d2:	00 
801043d3:	c7 44 24 04 23 85 10 	movl   $0x80108523,0x4(%esp)
801043da:	80 
801043db:	89 04 24             	mov    %eax,(%esp)
801043de:	e8 57 0e 00 00       	call   8010523a <safestrcpy>
  p->cwd = namei("/");
801043e3:	c7 04 24 2c 85 10 80 	movl   $0x8010852c,(%esp)
801043ea:	e8 00 e1 ff ff       	call   801024ef <namei>
801043ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043f2:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801043f5:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801043fc:	e8 ca 09 00 00       	call   80104dcb <acquire>

  p->state = RUNNABLE;
80104401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104404:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010440b:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104412:	e8 1e 0a 00 00       	call   80104e35 <release>
}
80104417:	c9                   	leave  
80104418:	c3                   	ret    

80104419 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104419:	55                   	push   %ebp
8010441a:	89 e5                	mov    %esp,%ebp
8010441c:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
8010441f:	e8 97 fd ff ff       	call   801041bb <myproc>
80104424:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442a:	8b 00                	mov    (%eax),%eax
8010442c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010442f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104433:	7e 31                	jle    80104466 <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104435:	8b 55 08             	mov    0x8(%ebp),%edx
80104438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443b:	01 c2                	add    %eax,%edx
8010443d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104440:	8b 40 04             	mov    0x4(%eax),%eax
80104443:	89 54 24 08          	mov    %edx,0x8(%esp)
80104447:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010444a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010444e:	89 04 24             	mov    %eax,(%esp)
80104451:	e8 5c 38 00 00       	call   80107cb2 <allocuvm>
80104456:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010445d:	75 3e                	jne    8010449d <growproc+0x84>
      return -1;
8010445f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104464:	eb 4f                	jmp    801044b5 <growproc+0x9c>
  } else if(n < 0){
80104466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010446a:	79 31                	jns    8010449d <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010446c:	8b 55 08             	mov    0x8(%ebp),%edx
8010446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104472:	01 c2                	add    %eax,%edx
80104474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104477:	8b 40 04             	mov    0x4(%eax),%eax
8010447a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010447e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104481:	89 54 24 04          	mov    %edx,0x4(%esp)
80104485:	89 04 24             	mov    %eax,(%esp)
80104488:	e8 3b 39 00 00       	call   80107dc8 <deallocuvm>
8010448d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104494:	75 07                	jne    8010449d <growproc+0x84>
      return -1;
80104496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449b:	eb 18                	jmp    801044b5 <growproc+0x9c>
  }
  curproc->sz = sz;
8010449d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a3:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801044a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a8:	89 04 24             	mov    %eax,(%esp)
801044ab:	e8 10 35 00 00       	call   801079c0 <switchuvm>
  return 0;
801044b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044b5:	c9                   	leave  
801044b6:	c3                   	ret    

801044b7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801044b7:	55                   	push   %ebp
801044b8:	89 e5                	mov    %esp,%ebp
801044ba:	57                   	push   %edi
801044bb:	56                   	push   %esi
801044bc:	53                   	push   %ebx
801044bd:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801044c0:	e8 f6 fc ff ff       	call   801041bb <myproc>
801044c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801044c8:	e8 17 fd ff ff       	call   801041e4 <allocproc>
801044cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801044d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801044d4:	75 0a                	jne    801044e0 <fork+0x29>
    return -1;
801044d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044db:	e9 35 01 00 00       	jmp    80104615 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801044e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e3:	8b 10                	mov    (%eax),%edx
801044e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e8:	8b 40 04             	mov    0x4(%eax),%eax
801044eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ef:	89 04 24             	mov    %eax,(%esp)
801044f2:	e8 71 3a 00 00       	call   80107f68 <copyuvm>
801044f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
801044fa:	89 42 04             	mov    %eax,0x4(%edx)
801044fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104500:	8b 40 04             	mov    0x4(%eax),%eax
80104503:	85 c0                	test   %eax,%eax
80104505:	75 2c                	jne    80104533 <fork+0x7c>
    kfree(np->kstack);
80104507:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010450a:	8b 40 08             	mov    0x8(%eax),%eax
8010450d:	89 04 24             	mov    %eax,(%esp)
80104510:	e8 50 e6 ff ff       	call   80102b65 <kfree>
    np->kstack = 0;
80104515:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104518:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010451f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104522:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010452e:	e9 e2 00 00 00       	jmp    80104615 <fork+0x15e>
  }
  np->sz = curproc->sz;
80104533:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104536:	8b 10                	mov    (%eax),%edx
80104538:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010453b:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104540:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104543:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104546:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104549:	8b 50 18             	mov    0x18(%eax),%edx
8010454c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010454f:	8b 40 18             	mov    0x18(%eax),%eax
80104552:	89 c3                	mov    %eax,%ebx
80104554:	b8 13 00 00 00       	mov    $0x13,%eax
80104559:	89 d7                	mov    %edx,%edi
8010455b:	89 de                	mov    %ebx,%esi
8010455d:	89 c1                	mov    %eax,%ecx
8010455f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104561:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104564:	8b 40 18             	mov    0x18(%eax),%eax
80104567:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010456e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104575:	eb 36                	jmp    801045ad <fork+0xf6>
    if(curproc->ofile[i])
80104577:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010457a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010457d:	83 c2 08             	add    $0x8,%edx
80104580:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104584:	85 c0                	test   %eax,%eax
80104586:	74 22                	je     801045aa <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010458b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010458e:	83 c2 08             	add    $0x8,%edx
80104591:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104595:	89 04 24             	mov    %eax,(%esp)
80104598:	e8 cb ca ff ff       	call   80101068 <filedup>
8010459d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801045a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801045a3:	83 c1 08             	add    $0x8,%ecx
801045a6:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801045aa:	ff 45 e4             	incl   -0x1c(%ebp)
801045ad:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801045b1:	7e c4                	jle    80104577 <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801045b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b6:	8b 40 68             	mov    0x68(%eax),%eax
801045b9:	89 04 24             	mov    %eax,(%esp)
801045bc:	e8 d7 d3 ff ff       	call   80101998 <idup>
801045c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801045c4:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801045c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045ca:	8d 50 6c             	lea    0x6c(%eax),%edx
801045cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045d0:	83 c0 6c             	add    $0x6c,%eax
801045d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045da:	00 
801045db:	89 54 24 04          	mov    %edx,0x4(%esp)
801045df:	89 04 24             	mov    %eax,(%esp)
801045e2:	e8 53 0c 00 00       	call   8010523a <safestrcpy>

  pid = np->pid;
801045e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ea:	8b 40 10             	mov    0x10(%eax),%eax
801045ed:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
801045f0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801045f7:	e8 cf 07 00 00       	call   80104dcb <acquire>

  np->state = RUNNABLE;
801045fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104606:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010460d:	e8 23 08 00 00       	call   80104e35 <release>

  return pid;
80104612:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104615:	83 c4 2c             	add    $0x2c,%esp
80104618:	5b                   	pop    %ebx
80104619:	5e                   	pop    %esi
8010461a:	5f                   	pop    %edi
8010461b:	5d                   	pop    %ebp
8010461c:	c3                   	ret    

8010461d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010461d:	55                   	push   %ebp
8010461e:	89 e5                	mov    %esp,%ebp
80104620:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104623:	e8 93 fb ff ff       	call   801041bb <myproc>
80104628:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010462b:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104630:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104633:	75 0c                	jne    80104641 <exit+0x24>
    panic("init exiting");
80104635:	c7 04 24 2e 85 10 80 	movl   $0x8010852e,(%esp)
8010463c:	e8 13 bf ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104641:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104648:	eb 3a                	jmp    80104684 <exit+0x67>
    if(curproc->ofile[fd]){
8010464a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010464d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104650:	83 c2 08             	add    $0x8,%edx
80104653:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104657:	85 c0                	test   %eax,%eax
80104659:	74 26                	je     80104681 <exit+0x64>
      fileclose(curproc->ofile[fd]);
8010465b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010465e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104661:	83 c2 08             	add    $0x8,%edx
80104664:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104668:	89 04 24             	mov    %eax,(%esp)
8010466b:	e8 40 ca ff ff       	call   801010b0 <fileclose>
      curproc->ofile[fd] = 0;
80104670:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104673:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104676:	83 c2 08             	add    $0x8,%edx
80104679:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104680:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104681:	ff 45 f0             	incl   -0x10(%ebp)
80104684:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104688:	7e c0                	jle    8010464a <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010468a:	e8 34 ee ff ff       	call   801034c3 <begin_op>
  iput(curproc->cwd);
8010468f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104692:	8b 40 68             	mov    0x68(%eax),%eax
80104695:	89 04 24             	mov    %eax,(%esp)
80104698:	e8 7b d4 ff ff       	call   80101b18 <iput>
  end_op();
8010469d:	e8 a3 ee ff ff       	call   80103545 <end_op>
  curproc->cwd = 0;
801046a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046a5:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801046ac:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801046b3:	e8 13 07 00 00       	call   80104dcb <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801046b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046bb:	8b 40 14             	mov    0x14(%eax),%eax
801046be:	89 04 24             	mov    %eax,(%esp)
801046c1:	e8 cc 03 00 00       	call   80104a92 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c6:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801046cd:	eb 33                	jmp    80104702 <exit+0xe5>
    if(p->parent == curproc){
801046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d2:	8b 40 14             	mov    0x14(%eax),%eax
801046d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801046d8:	75 24                	jne    801046fe <exit+0xe1>
      p->parent = initproc;
801046da:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e9:	8b 40 0c             	mov    0xc(%eax),%eax
801046ec:	83 f8 05             	cmp    $0x5,%eax
801046ef:	75 0d                	jne    801046fe <exit+0xe1>
        wakeup1(initproc);
801046f1:	a1 20 b6 10 80       	mov    0x8010b620,%eax
801046f6:	89 04 24             	mov    %eax,(%esp)
801046f9:	e8 94 03 00 00       	call   80104a92 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fe:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104702:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104709:	72 c4                	jb     801046cf <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010470b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010470e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104715:	e8 c3 01 00 00       	call   801048dd <sched>
  panic("zombie exit");
8010471a:	c7 04 24 3b 85 10 80 	movl   $0x8010853b,(%esp)
80104721:	e8 2e be ff ff       	call   80100554 <panic>

80104726 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104726:	55                   	push   %ebp
80104727:	89 e5                	mov    %esp,%ebp
80104729:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010472c:	e8 8a fa ff ff       	call   801041bb <myproc>
80104731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104734:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010473b:	e8 8b 06 00 00       	call   80104dcb <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104740:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104747:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
8010474e:	e9 95 00 00 00       	jmp    801047e8 <wait+0xc2>
      if(p->parent != curproc)
80104753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104756:	8b 40 14             	mov    0x14(%eax),%eax
80104759:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010475c:	74 05                	je     80104763 <wait+0x3d>
        continue;
8010475e:	e9 81 00 00 00       	jmp    801047e4 <wait+0xbe>
      havekids = 1;
80104763:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476d:	8b 40 0c             	mov    0xc(%eax),%eax
80104770:	83 f8 05             	cmp    $0x5,%eax
80104773:	75 6f                	jne    801047e4 <wait+0xbe>
        // Found one.
        pid = p->pid;
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	8b 40 10             	mov    0x10(%eax),%eax
8010477b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104781:	8b 40 08             	mov    0x8(%eax),%eax
80104784:	89 04 24             	mov    %eax,(%esp)
80104787:	e8 d9 e3 ff ff       	call   80102b65 <kfree>
        p->kstack = 0;
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104799:	8b 40 04             	mov    0x4(%eax),%eax
8010479c:	89 04 24             	mov    %eax,(%esp)
8010479f:	e8 e8 36 00 00       	call   80107e8c <freevm>
        p->pid = 0;
801047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801047ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bb:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c2:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801047c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801047d3:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801047da:	e8 56 06 00 00       	call   80104e35 <release>
        return pid;
801047df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801047e2:	eb 4c                	jmp    80104830 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e4:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801047e8:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801047ef:	0f 82 5e ff ff ff    	jb     80104753 <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801047f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047f9:	74 0a                	je     80104805 <wait+0xdf>
801047fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047fe:	8b 40 24             	mov    0x24(%eax),%eax
80104801:	85 c0                	test   %eax,%eax
80104803:	74 13                	je     80104818 <wait+0xf2>
      release(&ptable.lock);
80104805:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010480c:	e8 24 06 00 00       	call   80104e35 <release>
      return -1;
80104811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104816:	eb 18                	jmp    80104830 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104818:	c7 44 24 04 a0 3d 11 	movl   $0x80113da0,0x4(%esp)
8010481f:	80 
80104820:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104823:	89 04 24             	mov    %eax,(%esp)
80104826:	e8 d1 01 00 00       	call   801049fc <sleep>
  }
8010482b:	e9 10 ff ff ff       	jmp    80104740 <wait+0x1a>
}
80104830:	c9                   	leave  
80104831:	c3                   	ret    

80104832 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104832:	55                   	push   %ebp
80104833:	89 e5                	mov    %esp,%ebp
80104835:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104838:	e8 fa f8 ff ff       	call   80104137 <mycpu>
8010483d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104840:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104843:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010484a:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
8010484d:	e8 7e f8 ff ff       	call   801040d0 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104852:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104859:	e8 6d 05 00 00       	call   80104dcb <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010485e:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104865:	eb 5c                	jmp    801048c3 <scheduler+0x91>
      if(p->state != RUNNABLE)
80104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486a:	8b 40 0c             	mov    0xc(%eax),%eax
8010486d:	83 f8 03             	cmp    $0x3,%eax
80104870:	74 02                	je     80104874 <scheduler+0x42>
        continue;
80104872:	eb 4b                	jmp    801048bf <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104877:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010487a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104883:	89 04 24             	mov    %eax,(%esp)
80104886:	e8 35 31 00 00       	call   801079c0 <switchuvm>
      p->state = RUNNING;
8010488b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488e:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104898:	8b 40 1c             	mov    0x1c(%eax),%eax
8010489b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010489e:	83 c2 04             	add    $0x4,%edx
801048a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801048a5:	89 14 24             	mov    %edx,(%esp)
801048a8:	e8 fb 09 00 00       	call   801052a8 <swtch>
      switchkvm();
801048ad:	e8 f4 30 00 00       	call   801079a6 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801048b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048b5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801048bc:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048bf:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801048c3:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801048ca:	72 9b                	jb     80104867 <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
801048cc:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801048d3:	e8 5d 05 00 00       	call   80104e35 <release>

  }
801048d8:	e9 70 ff ff ff       	jmp    8010484d <scheduler+0x1b>

801048dd <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801048dd:	55                   	push   %ebp
801048de:	89 e5                	mov    %esp,%ebp
801048e0:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
801048e3:	e8 d3 f8 ff ff       	call   801041bb <myproc>
801048e8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
801048eb:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801048f2:	e8 02 06 00 00       	call   80104ef9 <holding>
801048f7:	85 c0                	test   %eax,%eax
801048f9:	75 0c                	jne    80104907 <sched+0x2a>
    panic("sched ptable.lock");
801048fb:	c7 04 24 47 85 10 80 	movl   $0x80108547,(%esp)
80104902:	e8 4d bc ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
80104907:	e8 2b f8 ff ff       	call   80104137 <mycpu>
8010490c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104912:	83 f8 01             	cmp    $0x1,%eax
80104915:	74 0c                	je     80104923 <sched+0x46>
    panic("sched locks");
80104917:	c7 04 24 59 85 10 80 	movl   $0x80108559,(%esp)
8010491e:	e8 31 bc ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
80104923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104926:	8b 40 0c             	mov    0xc(%eax),%eax
80104929:	83 f8 04             	cmp    $0x4,%eax
8010492c:	75 0c                	jne    8010493a <sched+0x5d>
    panic("sched running");
8010492e:	c7 04 24 65 85 10 80 	movl   $0x80108565,(%esp)
80104935:	e8 1a bc ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
8010493a:	e8 81 f7 ff ff       	call   801040c0 <readeflags>
8010493f:	25 00 02 00 00       	and    $0x200,%eax
80104944:	85 c0                	test   %eax,%eax
80104946:	74 0c                	je     80104954 <sched+0x77>
    panic("sched interruptible");
80104948:	c7 04 24 73 85 10 80 	movl   $0x80108573,(%esp)
8010494f:	e8 00 bc ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
80104954:	e8 de f7 ff ff       	call   80104137 <mycpu>
80104959:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010495f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104962:	e8 d0 f7 ff ff       	call   80104137 <mycpu>
80104967:	8b 40 04             	mov    0x4(%eax),%eax
8010496a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010496d:	83 c2 1c             	add    $0x1c,%edx
80104970:	89 44 24 04          	mov    %eax,0x4(%esp)
80104974:	89 14 24             	mov    %edx,(%esp)
80104977:	e8 2c 09 00 00       	call   801052a8 <swtch>
  mycpu()->intena = intena;
8010497c:	e8 b6 f7 ff ff       	call   80104137 <mycpu>
80104981:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104984:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    

8010498c <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010498c:	55                   	push   %ebp
8010498d:	89 e5                	mov    %esp,%ebp
8010498f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104992:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104999:	e8 2d 04 00 00       	call   80104dcb <acquire>
  myproc()->state = RUNNABLE;
8010499e:	e8 18 f8 ff ff       	call   801041bb <myproc>
801049a3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801049aa:	e8 2e ff ff ff       	call   801048dd <sched>
  release(&ptable.lock);
801049af:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801049b6:	e8 7a 04 00 00       	call   80104e35 <release>
}
801049bb:	c9                   	leave  
801049bc:	c3                   	ret    

801049bd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801049bd:	55                   	push   %ebp
801049be:	89 e5                	mov    %esp,%ebp
801049c0:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801049c3:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801049ca:	e8 66 04 00 00       	call   80104e35 <release>

  if (first) {
801049cf:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801049d4:	85 c0                	test   %eax,%eax
801049d6:	74 22                	je     801049fa <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801049d8:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
801049df:	00 00 00 
    iinit(ROOTDEV);
801049e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049e9:	e8 75 cc ff ff       	call   80101663 <iinit>
    initlog(ROOTDEV);
801049ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049f5:	e8 ca e8 ff ff       	call   801032c4 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801049fa:	c9                   	leave  
801049fb:	c3                   	ret    

801049fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801049fc:	55                   	push   %ebp
801049fd:	89 e5                	mov    %esp,%ebp
801049ff:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104a02:	e8 b4 f7 ff ff       	call   801041bb <myproc>
80104a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a0e:	75 0c                	jne    80104a1c <sleep+0x20>
    panic("sleep");
80104a10:	c7 04 24 87 85 10 80 	movl   $0x80108587,(%esp)
80104a17:	e8 38 bb ff ff       	call   80100554 <panic>

  if(lk == 0)
80104a1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a20:	75 0c                	jne    80104a2e <sleep+0x32>
    panic("sleep without lk");
80104a22:	c7 04 24 8d 85 10 80 	movl   $0x8010858d,(%esp)
80104a29:	e8 26 bb ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a2e:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104a35:	74 17                	je     80104a4e <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a37:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a3e:	e8 88 03 00 00       	call   80104dcb <acquire>
    release(lk);
80104a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a46:	89 04 24             	mov    %eax,(%esp)
80104a49:	e8 e7 03 00 00       	call   80104e35 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a51:	8b 55 08             	mov    0x8(%ebp),%edx
80104a54:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5a:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104a61:	e8 77 fe ff ff       	call   801048dd <sched>

  // Tidy up.
  p->chan = 0;
80104a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a69:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a70:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104a77:	74 17                	je     80104a90 <sleep+0x94>
    release(&ptable.lock);
80104a79:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a80:	e8 b0 03 00 00       	call   80104e35 <release>
    acquire(lk);
80104a85:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a88:	89 04 24             	mov    %eax,(%esp)
80104a8b:	e8 3b 03 00 00       	call   80104dcb <acquire>
  }
}
80104a90:	c9                   	leave  
80104a91:	c3                   	ret    

80104a92 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a92:	55                   	push   %ebp
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a98:	c7 45 fc d4 3d 11 80 	movl   $0x80113dd4,-0x4(%ebp)
80104a9f:	eb 24                	jmp    80104ac5 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aa4:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa7:	83 f8 02             	cmp    $0x2,%eax
80104aaa:	75 15                	jne    80104ac1 <wakeup1+0x2f>
80104aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aaf:	8b 40 20             	mov    0x20(%eax),%eax
80104ab2:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ab5:	75 0a                	jne    80104ac1 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ac1:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104ac5:	81 7d fc d4 5c 11 80 	cmpl   $0x80115cd4,-0x4(%ebp)
80104acc:	72 d3                	jb     80104aa1 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104ace:	c9                   	leave  
80104acf:	c3                   	ret    

80104ad0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104ad6:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104add:	e8 e9 02 00 00       	call   80104dcb <acquire>
  wakeup1(chan);
80104ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae5:	89 04 24             	mov    %eax,(%esp)
80104ae8:	e8 a5 ff ff ff       	call   80104a92 <wakeup1>
  release(&ptable.lock);
80104aed:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104af4:	e8 3c 03 00 00       	call   80104e35 <release>
}
80104af9:	c9                   	leave  
80104afa:	c3                   	ret    

80104afb <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104afb:	55                   	push   %ebp
80104afc:	89 e5                	mov    %esp,%ebp
80104afe:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b01:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104b08:	e8 be 02 00 00       	call   80104dcb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0d:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104b14:	eb 41                	jmp    80104b57 <kill+0x5c>
    if(p->pid == pid){
80104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b19:	8b 40 10             	mov    0x10(%eax),%eax
80104b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b1f:	75 32                	jne    80104b53 <kill+0x58>
      p->killed = 1;
80104b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b24:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b31:	83 f8 02             	cmp    $0x2,%eax
80104b34:	75 0a                	jne    80104b40 <kill+0x45>
        p->state = RUNNABLE;
80104b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b39:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b40:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104b47:	e8 e9 02 00 00       	call   80104e35 <release>
      return 0;
80104b4c:	b8 00 00 00 00       	mov    $0x0,%eax
80104b51:	eb 1e                	jmp    80104b71 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b53:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b57:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104b5e:	72 b6                	jb     80104b16 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104b60:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104b67:	e8 c9 02 00 00       	call   80104e35 <release>
  return -1;
80104b6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b71:	c9                   	leave  
80104b72:	c3                   	ret    

80104b73 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b73:	55                   	push   %ebp
80104b74:	89 e5                	mov    %esp,%ebp
80104b76:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b79:	c7 45 f0 d4 3d 11 80 	movl   $0x80113dd4,-0x10(%ebp)
80104b80:	e9 d5 00 00 00       	jmp    80104c5a <procdump+0xe7>
    if(p->state == UNUSED)
80104b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b88:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	75 05                	jne    80104b94 <procdump+0x21>
      continue;
80104b8f:	e9 c2 00 00 00       	jmp    80104c56 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b97:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9a:	83 f8 05             	cmp    $0x5,%eax
80104b9d:	77 23                	ja     80104bc2 <procdump+0x4f>
80104b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ba2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ba5:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104bac:	85 c0                	test   %eax,%eax
80104bae:	74 12                	je     80104bc2 <procdump+0x4f>
      state = states[p->state];
80104bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bb3:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb6:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104bc0:	eb 07                	jmp    80104bc9 <procdump+0x56>
    else
      state = "???";
80104bc2:	c7 45 ec 9e 85 10 80 	movl   $0x8010859e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bcc:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bd2:	8b 40 10             	mov    0x10(%eax),%eax
80104bd5:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104bd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104bdc:	89 54 24 08          	mov    %edx,0x8(%esp)
80104be0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be4:	c7 04 24 a2 85 10 80 	movl   $0x801085a2,(%esp)
80104beb:	e8 d1 b7 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80104bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf3:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf6:	83 f8 02             	cmp    $0x2,%eax
80104bf9:	75 4f                	jne    80104c4a <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfe:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c01:	8b 40 0c             	mov    0xc(%eax),%eax
80104c04:	83 c0 08             	add    $0x8,%eax
80104c07:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c0a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c0e:	89 04 24             	mov    %eax,(%esp)
80104c11:	e8 6c 02 00 00       	call   80104e82 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c1d:	eb 1a                	jmp    80104c39 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c22:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c26:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c2a:	c7 04 24 ab 85 10 80 	movl   $0x801085ab,(%esp)
80104c31:	e8 8b b7 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104c36:	ff 45 f4             	incl   -0xc(%ebp)
80104c39:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104c3d:	7f 0b                	jg     80104c4a <procdump+0xd7>
80104c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c42:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c46:	85 c0                	test   %eax,%eax
80104c48:	75 d5                	jne    80104c1f <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c4a:	c7 04 24 af 85 10 80 	movl   $0x801085af,(%esp)
80104c51:	e8 6b b7 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c56:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104c5a:	81 7d f0 d4 5c 11 80 	cmpl   $0x80115cd4,-0x10(%ebp)
80104c61:	0f 82 1e ff ff ff    	jb     80104b85 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104c67:	c9                   	leave  
80104c68:	c3                   	ret    
80104c69:	00 00                	add    %al,(%eax)
	...

80104c6c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c6c:	55                   	push   %ebp
80104c6d:	89 e5                	mov    %esp,%ebp
80104c6f:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104c72:	8b 45 08             	mov    0x8(%ebp),%eax
80104c75:	83 c0 04             	add    $0x4,%eax
80104c78:	c7 44 24 04 db 85 10 	movl   $0x801085db,0x4(%esp)
80104c7f:	80 
80104c80:	89 04 24             	mov    %eax,(%esp)
80104c83:	e8 22 01 00 00       	call   80104daa <initlock>
  lk->name = name;
80104c88:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c8e:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104c91:	8b 45 08             	mov    0x8(%ebp),%eax
80104c94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104ca4:	c9                   	leave  
80104ca5:	c3                   	ret    

80104ca6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ca6:	55                   	push   %ebp
80104ca7:	89 e5                	mov    %esp,%ebp
80104ca9:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104cac:	8b 45 08             	mov    0x8(%ebp),%eax
80104caf:	83 c0 04             	add    $0x4,%eax
80104cb2:	89 04 24             	mov    %eax,(%esp)
80104cb5:	e8 11 01 00 00       	call   80104dcb <acquire>
  while (lk->locked) {
80104cba:	eb 15                	jmp    80104cd1 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80104cbf:	83 c0 04             	add    $0x4,%eax
80104cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc9:	89 04 24             	mov    %eax,(%esp)
80104ccc:	e8 2b fd ff ff       	call   801049fc <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd4:	8b 00                	mov    (%eax),%eax
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	75 e2                	jne    80104cbc <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104cda:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104ce3:	e8 d3 f4 ff ff       	call   801041bb <myproc>
80104ce8:	8b 50 10             	mov    0x10(%eax),%edx
80104ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80104cee:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf4:	83 c0 04             	add    $0x4,%eax
80104cf7:	89 04 24             	mov    %eax,(%esp)
80104cfa:	e8 36 01 00 00       	call   80104e35 <release>
}
80104cff:	c9                   	leave  
80104d00:	c3                   	ret    

80104d01 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d01:	55                   	push   %ebp
80104d02:	89 e5                	mov    %esp,%ebp
80104d04:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104d07:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0a:	83 c0 04             	add    $0x4,%eax
80104d0d:	89 04 24             	mov    %eax,(%esp)
80104d10:	e8 b6 00 00 00       	call   80104dcb <acquire>
  lk->locked = 0;
80104d15:	8b 45 08             	mov    0x8(%ebp),%eax
80104d18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104d1e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d21:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104d28:	8b 45 08             	mov    0x8(%ebp),%eax
80104d2b:	89 04 24             	mov    %eax,(%esp)
80104d2e:	e8 9d fd ff ff       	call   80104ad0 <wakeup>
  release(&lk->lk);
80104d33:	8b 45 08             	mov    0x8(%ebp),%eax
80104d36:	83 c0 04             	add    $0x4,%eax
80104d39:	89 04 24             	mov    %eax,(%esp)
80104d3c:	e8 f4 00 00 00       	call   80104e35 <release>
}
80104d41:	c9                   	leave  
80104d42:	c3                   	ret    

80104d43 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d43:	55                   	push   %ebp
80104d44:	89 e5                	mov    %esp,%ebp
80104d46:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104d49:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4c:	83 c0 04             	add    $0x4,%eax
80104d4f:	89 04 24             	mov    %eax,(%esp)
80104d52:	e8 74 00 00 00       	call   80104dcb <acquire>
  r = lk->locked;
80104d57:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5a:	8b 00                	mov    (%eax),%eax
80104d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d62:	83 c0 04             	add    $0x4,%eax
80104d65:	89 04 24             	mov    %eax,(%esp)
80104d68:	e8 c8 00 00 00       	call   80104e35 <release>
  return r;
80104d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104d70:	c9                   	leave  
80104d71:	c3                   	ret    
	...

80104d74 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d7a:	9c                   	pushf  
80104d7b:	58                   	pop    %eax
80104d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    

80104d84 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104d87:	fa                   	cli    
}
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret    

80104d8a <sti>:

static inline void
sti(void)
{
80104d8a:	55                   	push   %ebp
80104d8b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104d8d:	fb                   	sti    
}
80104d8e:	5d                   	pop    %ebp
80104d8f:	c3                   	ret    

80104d90 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104d96:	8b 55 08             	mov    0x8(%ebp),%edx
80104d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d9f:	f0 87 02             	lock xchg %eax,(%edx)
80104da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104da8:	c9                   	leave  
80104da9:	c3                   	ret    

80104daa <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104daa:	55                   	push   %ebp
80104dab:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104dad:	8b 45 08             	mov    0x8(%ebp),%eax
80104db0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104db3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104db6:	8b 45 08             	mov    0x8(%ebp),%eax
80104db9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104dc9:	5d                   	pop    %ebp
80104dca:	c3                   	ret    

80104dcb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104dcb:	55                   	push   %ebp
80104dcc:	89 e5                	mov    %esp,%ebp
80104dce:	53                   	push   %ebx
80104dcf:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104dd2:	e8 53 01 00 00       	call   80104f2a <pushcli>
  if(holding(lk))
80104dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dda:	89 04 24             	mov    %eax,(%esp)
80104ddd:	e8 17 01 00 00       	call   80104ef9 <holding>
80104de2:	85 c0                	test   %eax,%eax
80104de4:	74 0c                	je     80104df2 <acquire+0x27>
    panic("acquire");
80104de6:	c7 04 24 e6 85 10 80 	movl   $0x801085e6,(%esp)
80104ded:	e8 62 b7 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104df2:	90                   	nop
80104df3:	8b 45 08             	mov    0x8(%ebp),%eax
80104df6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104dfd:	00 
80104dfe:	89 04 24             	mov    %eax,(%esp)
80104e01:	e8 8a ff ff ff       	call   80104d90 <xchg>
80104e06:	85 c0                	test   %eax,%eax
80104e08:	75 e9                	jne    80104df3 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104e0a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e12:	e8 20 f3 ff ff       	call   80104137 <mycpu>
80104e17:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1d:	83 c0 0c             	add    $0xc,%eax
80104e20:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e24:	8d 45 08             	lea    0x8(%ebp),%eax
80104e27:	89 04 24             	mov    %eax,(%esp)
80104e2a:	e8 53 00 00 00       	call   80104e82 <getcallerpcs>
}
80104e2f:	83 c4 14             	add    $0x14,%esp
80104e32:	5b                   	pop    %ebx
80104e33:	5d                   	pop    %ebp
80104e34:	c3                   	ret    

80104e35 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104e35:	55                   	push   %ebp
80104e36:	89 e5                	mov    %esp,%ebp
80104e38:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3e:	89 04 24             	mov    %eax,(%esp)
80104e41:	e8 b3 00 00 00       	call   80104ef9 <holding>
80104e46:	85 c0                	test   %eax,%eax
80104e48:	75 0c                	jne    80104e56 <release+0x21>
    panic("release");
80104e4a:	c7 04 24 ee 85 10 80 	movl   $0x801085ee,(%esp)
80104e51:	e8 fe b6 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
80104e56:	8b 45 08             	mov    0x8(%ebp),%eax
80104e59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104e60:	8b 45 08             	mov    0x8(%ebp),%eax
80104e63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104e6a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e72:	8b 55 08             	mov    0x8(%ebp),%edx
80104e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104e7b:	e8 f4 00 00 00       	call   80104f74 <popcli>
}
80104e80:	c9                   	leave  
80104e81:	c3                   	ret    

80104e82 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e82:	55                   	push   %ebp
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104e88:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8b:	83 e8 08             	sub    $0x8,%eax
80104e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104e98:	eb 37                	jmp    80104ed1 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104e9e:	74 37                	je     80104ed7 <getcallerpcs+0x55>
80104ea0:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104ea7:	76 2e                	jbe    80104ed7 <getcallerpcs+0x55>
80104ea9:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104ead:	74 28                	je     80104ed7 <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104eb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebc:	01 c2                	add    %eax,%edx
80104ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec1:	8b 40 04             	mov    0x4(%eax),%eax
80104ec4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec9:	8b 00                	mov    (%eax),%eax
80104ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ece:	ff 45 f8             	incl   -0x8(%ebp)
80104ed1:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ed5:	7e c3                	jle    80104e9a <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ed7:	eb 18                	jmp    80104ef1 <getcallerpcs+0x6f>
    pcs[i] = 0;
80104ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104edc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee6:	01 d0                	add    %edx,%eax
80104ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104eee:	ff 45 f8             	incl   -0x8(%ebp)
80104ef1:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ef5:	7e e2                	jle    80104ed9 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80104ef7:	c9                   	leave  
80104ef8:	c3                   	ret    

80104ef9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ef9:	55                   	push   %ebp
80104efa:	89 e5                	mov    %esp,%ebp
80104efc:	53                   	push   %ebx
80104efd:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104f00:	8b 45 08             	mov    0x8(%ebp),%eax
80104f03:	8b 00                	mov    (%eax),%eax
80104f05:	85 c0                	test   %eax,%eax
80104f07:	74 16                	je     80104f1f <holding+0x26>
80104f09:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0c:	8b 58 08             	mov    0x8(%eax),%ebx
80104f0f:	e8 23 f2 ff ff       	call   80104137 <mycpu>
80104f14:	39 c3                	cmp    %eax,%ebx
80104f16:	75 07                	jne    80104f1f <holding+0x26>
80104f18:	b8 01 00 00 00       	mov    $0x1,%eax
80104f1d:	eb 05                	jmp    80104f24 <holding+0x2b>
80104f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f24:	83 c4 04             	add    $0x4,%esp
80104f27:	5b                   	pop    %ebx
80104f28:	5d                   	pop    %ebp
80104f29:	c3                   	ret    

80104f2a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f2a:	55                   	push   %ebp
80104f2b:	89 e5                	mov    %esp,%ebp
80104f2d:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104f30:	e8 3f fe ff ff       	call   80104d74 <readeflags>
80104f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104f38:	e8 47 fe ff ff       	call   80104d84 <cli>
  if(mycpu()->ncli == 0)
80104f3d:	e8 f5 f1 ff ff       	call   80104137 <mycpu>
80104f42:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	75 14                	jne    80104f60 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104f4c:	e8 e6 f1 ff ff       	call   80104137 <mycpu>
80104f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f54:	81 e2 00 02 00 00    	and    $0x200,%edx
80104f5a:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104f60:	e8 d2 f1 ff ff       	call   80104137 <mycpu>
80104f65:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f6b:	42                   	inc    %edx
80104f6c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104f72:	c9                   	leave  
80104f73:	c3                   	ret    

80104f74 <popcli>:

void
popcli(void)
{
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104f7a:	e8 f5 fd ff ff       	call   80104d74 <readeflags>
80104f7f:	25 00 02 00 00       	and    $0x200,%eax
80104f84:	85 c0                	test   %eax,%eax
80104f86:	74 0c                	je     80104f94 <popcli+0x20>
    panic("popcli - interruptible");
80104f88:	c7 04 24 f6 85 10 80 	movl   $0x801085f6,(%esp)
80104f8f:	e8 c0 b5 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
80104f94:	e8 9e f1 ff ff       	call   80104137 <mycpu>
80104f99:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f9f:	4a                   	dec    %edx
80104fa0:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104fa6:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fac:	85 c0                	test   %eax,%eax
80104fae:	79 0c                	jns    80104fbc <popcli+0x48>
    panic("popcli");
80104fb0:	c7 04 24 0d 86 10 80 	movl   $0x8010860d,(%esp)
80104fb7:	e8 98 b5 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fbc:	e8 76 f1 ff ff       	call   80104137 <mycpu>
80104fc1:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	75 14                	jne    80104fdf <popcli+0x6b>
80104fcb:	e8 67 f1 ff ff       	call   80104137 <mycpu>
80104fd0:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	74 05                	je     80104fdf <popcli+0x6b>
    sti();
80104fda:	e8 ab fd ff ff       	call   80104d8a <sti>
}
80104fdf:	c9                   	leave  
80104fe0:	c3                   	ret    
80104fe1:	00 00                	add    %al,(%eax)
	...

80104fe4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	57                   	push   %edi
80104fe8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fec:	8b 55 10             	mov    0x10(%ebp),%edx
80104fef:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff2:	89 cb                	mov    %ecx,%ebx
80104ff4:	89 df                	mov    %ebx,%edi
80104ff6:	89 d1                	mov    %edx,%ecx
80104ff8:	fc                   	cld    
80104ff9:	f3 aa                	rep stos %al,%es:(%edi)
80104ffb:	89 ca                	mov    %ecx,%edx
80104ffd:	89 fb                	mov    %edi,%ebx
80104fff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105002:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105005:	5b                   	pop    %ebx
80105006:	5f                   	pop    %edi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    

80105009 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105009:	55                   	push   %ebp
8010500a:	89 e5                	mov    %esp,%ebp
8010500c:	57                   	push   %edi
8010500d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010500e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105011:	8b 55 10             	mov    0x10(%ebp),%edx
80105014:	8b 45 0c             	mov    0xc(%ebp),%eax
80105017:	89 cb                	mov    %ecx,%ebx
80105019:	89 df                	mov    %ebx,%edi
8010501b:	89 d1                	mov    %edx,%ecx
8010501d:	fc                   	cld    
8010501e:	f3 ab                	rep stos %eax,%es:(%edi)
80105020:	89 ca                	mov    %ecx,%edx
80105022:	89 fb                	mov    %edi,%ebx
80105024:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105027:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010502a:	5b                   	pop    %ebx
8010502b:	5f                   	pop    %edi
8010502c:	5d                   	pop    %ebp
8010502d:	c3                   	ret    

8010502e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010502e:	55                   	push   %ebp
8010502f:	89 e5                	mov    %esp,%ebp
80105031:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105034:	8b 45 08             	mov    0x8(%ebp),%eax
80105037:	83 e0 03             	and    $0x3,%eax
8010503a:	85 c0                	test   %eax,%eax
8010503c:	75 49                	jne    80105087 <memset+0x59>
8010503e:	8b 45 10             	mov    0x10(%ebp),%eax
80105041:	83 e0 03             	and    $0x3,%eax
80105044:	85 c0                	test   %eax,%eax
80105046:	75 3f                	jne    80105087 <memset+0x59>
    c &= 0xFF;
80105048:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010504f:	8b 45 10             	mov    0x10(%ebp),%eax
80105052:	c1 e8 02             	shr    $0x2,%eax
80105055:	89 c2                	mov    %eax,%edx
80105057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505a:	c1 e0 18             	shl    $0x18,%eax
8010505d:	89 c1                	mov    %eax,%ecx
8010505f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105062:	c1 e0 10             	shl    $0x10,%eax
80105065:	09 c1                	or     %eax,%ecx
80105067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506a:	c1 e0 08             	shl    $0x8,%eax
8010506d:	09 c8                	or     %ecx,%eax
8010506f:	0b 45 0c             	or     0xc(%ebp),%eax
80105072:	89 54 24 08          	mov    %edx,0x8(%esp)
80105076:	89 44 24 04          	mov    %eax,0x4(%esp)
8010507a:	8b 45 08             	mov    0x8(%ebp),%eax
8010507d:	89 04 24             	mov    %eax,(%esp)
80105080:	e8 84 ff ff ff       	call   80105009 <stosl>
80105085:	eb 19                	jmp    801050a0 <memset+0x72>
  } else
    stosb(dst, c, n);
80105087:	8b 45 10             	mov    0x10(%ebp),%eax
8010508a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010508e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105091:	89 44 24 04          	mov    %eax,0x4(%esp)
80105095:	8b 45 08             	mov    0x8(%ebp),%eax
80105098:	89 04 24             	mov    %eax,(%esp)
8010509b:	e8 44 ff ff ff       	call   80104fe4 <stosb>
  return dst;
801050a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801050a3:	c9                   	leave  
801050a4:	c3                   	ret    

801050a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050a5:	55                   	push   %ebp
801050a6:	89 e5                	mov    %esp,%ebp
801050a8:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801050ab:	8b 45 08             	mov    0x8(%ebp),%eax
801050ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801050b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801050b7:	eb 2a                	jmp    801050e3 <memcmp+0x3e>
    if(*s1 != *s2)
801050b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050bc:	8a 10                	mov    (%eax),%dl
801050be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050c1:	8a 00                	mov    (%eax),%al
801050c3:	38 c2                	cmp    %al,%dl
801050c5:	74 16                	je     801050dd <memcmp+0x38>
      return *s1 - *s2;
801050c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050ca:	8a 00                	mov    (%eax),%al
801050cc:	0f b6 d0             	movzbl %al,%edx
801050cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050d2:	8a 00                	mov    (%eax),%al
801050d4:	0f b6 c0             	movzbl %al,%eax
801050d7:	29 c2                	sub    %eax,%edx
801050d9:	89 d0                	mov    %edx,%eax
801050db:	eb 18                	jmp    801050f5 <memcmp+0x50>
    s1++, s2++;
801050dd:	ff 45 fc             	incl   -0x4(%ebp)
801050e0:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050e3:	8b 45 10             	mov    0x10(%ebp),%eax
801050e6:	8d 50 ff             	lea    -0x1(%eax),%edx
801050e9:	89 55 10             	mov    %edx,0x10(%ebp)
801050ec:	85 c0                	test   %eax,%eax
801050ee:	75 c9                	jne    801050b9 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801050f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    

801050f7 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050f7:	55                   	push   %ebp
801050f8:	89 e5                	mov    %esp,%ebp
801050fa:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801050fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105100:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
80105106:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105109:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010510c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010510f:	73 3a                	jae    8010514b <memmove+0x54>
80105111:	8b 45 10             	mov    0x10(%ebp),%eax
80105114:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105117:	01 d0                	add    %edx,%eax
80105119:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010511c:	76 2d                	jbe    8010514b <memmove+0x54>
    s += n;
8010511e:	8b 45 10             	mov    0x10(%ebp),%eax
80105121:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105124:	8b 45 10             	mov    0x10(%ebp),%eax
80105127:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010512a:	eb 10                	jmp    8010513c <memmove+0x45>
      *--d = *--s;
8010512c:	ff 4d f8             	decl   -0x8(%ebp)
8010512f:	ff 4d fc             	decl   -0x4(%ebp)
80105132:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105135:	8a 10                	mov    (%eax),%dl
80105137:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010513a:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010513c:	8b 45 10             	mov    0x10(%ebp),%eax
8010513f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105142:	89 55 10             	mov    %edx,0x10(%ebp)
80105145:	85 c0                	test   %eax,%eax
80105147:	75 e3                	jne    8010512c <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105149:	eb 25                	jmp    80105170 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010514b:	eb 16                	jmp    80105163 <memmove+0x6c>
      *d++ = *s++;
8010514d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105150:	8d 50 01             	lea    0x1(%eax),%edx
80105153:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105156:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105159:	8d 4a 01             	lea    0x1(%edx),%ecx
8010515c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010515f:	8a 12                	mov    (%edx),%dl
80105161:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105163:	8b 45 10             	mov    0x10(%ebp),%eax
80105166:	8d 50 ff             	lea    -0x1(%eax),%edx
80105169:	89 55 10             	mov    %edx,0x10(%ebp)
8010516c:	85 c0                	test   %eax,%eax
8010516e:	75 dd                	jne    8010514d <memmove+0x56>
      *d++ = *s++;

  return dst;
80105170:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105173:	c9                   	leave  
80105174:	c3                   	ret    

80105175 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105175:	55                   	push   %ebp
80105176:	89 e5                	mov    %esp,%ebp
80105178:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010517b:	8b 45 10             	mov    0x10(%ebp),%eax
8010517e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105182:	8b 45 0c             	mov    0xc(%ebp),%eax
80105185:	89 44 24 04          	mov    %eax,0x4(%esp)
80105189:	8b 45 08             	mov    0x8(%ebp),%eax
8010518c:	89 04 24             	mov    %eax,(%esp)
8010518f:	e8 63 ff ff ff       	call   801050f7 <memmove>
}
80105194:	c9                   	leave  
80105195:	c3                   	ret    

80105196 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105196:	55                   	push   %ebp
80105197:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105199:	eb 09                	jmp    801051a4 <strncmp+0xe>
    n--, p++, q++;
8010519b:	ff 4d 10             	decl   0x10(%ebp)
8010519e:	ff 45 08             	incl   0x8(%ebp)
801051a1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801051a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051a8:	74 17                	je     801051c1 <strncmp+0x2b>
801051aa:	8b 45 08             	mov    0x8(%ebp),%eax
801051ad:	8a 00                	mov    (%eax),%al
801051af:	84 c0                	test   %al,%al
801051b1:	74 0e                	je     801051c1 <strncmp+0x2b>
801051b3:	8b 45 08             	mov    0x8(%ebp),%eax
801051b6:	8a 10                	mov    (%eax),%dl
801051b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bb:	8a 00                	mov    (%eax),%al
801051bd:	38 c2                	cmp    %al,%dl
801051bf:	74 da                	je     8010519b <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801051c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051c5:	75 07                	jne    801051ce <strncmp+0x38>
    return 0;
801051c7:	b8 00 00 00 00       	mov    $0x0,%eax
801051cc:	eb 14                	jmp    801051e2 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
801051ce:	8b 45 08             	mov    0x8(%ebp),%eax
801051d1:	8a 00                	mov    (%eax),%al
801051d3:	0f b6 d0             	movzbl %al,%edx
801051d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d9:	8a 00                	mov    (%eax),%al
801051db:	0f b6 c0             	movzbl %al,%eax
801051de:	29 c2                	sub    %eax,%edx
801051e0:	89 d0                	mov    %edx,%eax
}
801051e2:	5d                   	pop    %ebp
801051e3:	c3                   	ret    

801051e4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801051ea:	8b 45 08             	mov    0x8(%ebp),%eax
801051ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801051f0:	90                   	nop
801051f1:	8b 45 10             	mov    0x10(%ebp),%eax
801051f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801051f7:	89 55 10             	mov    %edx,0x10(%ebp)
801051fa:	85 c0                	test   %eax,%eax
801051fc:	7e 1c                	jle    8010521a <strncpy+0x36>
801051fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105201:	8d 50 01             	lea    0x1(%eax),%edx
80105204:	89 55 08             	mov    %edx,0x8(%ebp)
80105207:	8b 55 0c             	mov    0xc(%ebp),%edx
8010520a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010520d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105210:	8a 12                	mov    (%edx),%dl
80105212:	88 10                	mov    %dl,(%eax)
80105214:	8a 00                	mov    (%eax),%al
80105216:	84 c0                	test   %al,%al
80105218:	75 d7                	jne    801051f1 <strncpy+0xd>
    ;
  while(n-- > 0)
8010521a:	eb 0c                	jmp    80105228 <strncpy+0x44>
    *s++ = 0;
8010521c:	8b 45 08             	mov    0x8(%ebp),%eax
8010521f:	8d 50 01             	lea    0x1(%eax),%edx
80105222:	89 55 08             	mov    %edx,0x8(%ebp)
80105225:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105228:	8b 45 10             	mov    0x10(%ebp),%eax
8010522b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010522e:	89 55 10             	mov    %edx,0x10(%ebp)
80105231:	85 c0                	test   %eax,%eax
80105233:	7f e7                	jg     8010521c <strncpy+0x38>
    *s++ = 0;
  return os;
80105235:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105238:	c9                   	leave  
80105239:	c3                   	ret    

8010523a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010523a:	55                   	push   %ebp
8010523b:	89 e5                	mov    %esp,%ebp
8010523d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105240:	8b 45 08             	mov    0x8(%ebp),%eax
80105243:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010524a:	7f 05                	jg     80105251 <safestrcpy+0x17>
    return os;
8010524c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010524f:	eb 2e                	jmp    8010527f <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
80105251:	ff 4d 10             	decl   0x10(%ebp)
80105254:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105258:	7e 1c                	jle    80105276 <safestrcpy+0x3c>
8010525a:	8b 45 08             	mov    0x8(%ebp),%eax
8010525d:	8d 50 01             	lea    0x1(%eax),%edx
80105260:	89 55 08             	mov    %edx,0x8(%ebp)
80105263:	8b 55 0c             	mov    0xc(%ebp),%edx
80105266:	8d 4a 01             	lea    0x1(%edx),%ecx
80105269:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010526c:	8a 12                	mov    (%edx),%dl
8010526e:	88 10                	mov    %dl,(%eax)
80105270:	8a 00                	mov    (%eax),%al
80105272:	84 c0                	test   %al,%al
80105274:	75 db                	jne    80105251 <safestrcpy+0x17>
    ;
  *s = 0;
80105276:	8b 45 08             	mov    0x8(%ebp),%eax
80105279:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010527c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010527f:	c9                   	leave  
80105280:	c3                   	ret    

80105281 <strlen>:

int
strlen(const char *s)
{
80105281:	55                   	push   %ebp
80105282:	89 e5                	mov    %esp,%ebp
80105284:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010528e:	eb 03                	jmp    80105293 <strlen+0x12>
80105290:	ff 45 fc             	incl   -0x4(%ebp)
80105293:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105296:	8b 45 08             	mov    0x8(%ebp),%eax
80105299:	01 d0                	add    %edx,%eax
8010529b:	8a 00                	mov    (%eax),%al
8010529d:	84 c0                	test   %al,%al
8010529f:	75 ef                	jne    80105290 <strlen+0xf>
    ;
  return n;
801052a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052a4:	c9                   	leave  
801052a5:	c3                   	ret    
	...

801052a8 <swtch>:
801052a8:	8b 44 24 04          	mov    0x4(%esp),%eax
801052ac:	8b 54 24 08          	mov    0x8(%esp),%edx
801052b0:	55                   	push   %ebp
801052b1:	53                   	push   %ebx
801052b2:	56                   	push   %esi
801052b3:	57                   	push   %edi
801052b4:	89 20                	mov    %esp,(%eax)
801052b6:	89 d4                	mov    %edx,%esp
801052b8:	5f                   	pop    %edi
801052b9:	5e                   	pop    %esi
801052ba:	5b                   	pop    %ebx
801052bb:	5d                   	pop    %ebp
801052bc:	c3                   	ret    
801052bd:	00 00                	add    %al,(%eax)
	...

801052c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801052c6:	e8 f0 ee ff ff       	call   801041bb <myproc>
801052cb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d1:	8b 00                	mov    (%eax),%eax
801052d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801052d6:	76 0f                	jbe    801052e7 <fetchint+0x27>
801052d8:	8b 45 08             	mov    0x8(%ebp),%eax
801052db:	8d 50 04             	lea    0x4(%eax),%edx
801052de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e1:	8b 00                	mov    (%eax),%eax
801052e3:	39 c2                	cmp    %eax,%edx
801052e5:	76 07                	jbe    801052ee <fetchint+0x2e>
    return -1;
801052e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ec:	eb 0f                	jmp    801052fd <fetchint+0x3d>
  *ip = *(int*)(addr);
801052ee:	8b 45 08             	mov    0x8(%ebp),%eax
801052f1:	8b 10                	mov    (%eax),%edx
801052f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f6:	89 10                	mov    %edx,(%eax)
  return 0;
801052f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052fd:	c9                   	leave  
801052fe:	c3                   	ret    

801052ff <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801052ff:	55                   	push   %ebp
80105300:	89 e5                	mov    %esp,%ebp
80105302:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105305:	e8 b1 ee ff ff       	call   801041bb <myproc>
8010530a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010530d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105310:	8b 00                	mov    (%eax),%eax
80105312:	3b 45 08             	cmp    0x8(%ebp),%eax
80105315:	77 07                	ja     8010531e <fetchstr+0x1f>
    return -1;
80105317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531c:	eb 41                	jmp    8010535f <fetchstr+0x60>
  *pp = (char*)addr;
8010531e:	8b 55 08             	mov    0x8(%ebp),%edx
80105321:	8b 45 0c             	mov    0xc(%ebp),%eax
80105324:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105326:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105329:	8b 00                	mov    (%eax),%eax
8010532b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010532e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105331:	8b 00                	mov    (%eax),%eax
80105333:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105336:	eb 1a                	jmp    80105352 <fetchstr+0x53>
    if(*s == 0)
80105338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010533b:	8a 00                	mov    (%eax),%al
8010533d:	84 c0                	test   %al,%al
8010533f:	75 0e                	jne    8010534f <fetchstr+0x50>
      return s - *pp;
80105341:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105344:	8b 45 0c             	mov    0xc(%ebp),%eax
80105347:	8b 00                	mov    (%eax),%eax
80105349:	29 c2                	sub    %eax,%edx
8010534b:	89 d0                	mov    %edx,%eax
8010534d:	eb 10                	jmp    8010535f <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010534f:	ff 45 f4             	incl   -0xc(%ebp)
80105352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105355:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105358:	72 de                	jb     80105338 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
8010535a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010535f:	c9                   	leave  
80105360:	c3                   	ret    

80105361 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105361:	55                   	push   %ebp
80105362:	89 e5                	mov    %esp,%ebp
80105364:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105367:	e8 4f ee ff ff       	call   801041bb <myproc>
8010536c:	8b 40 18             	mov    0x18(%eax),%eax
8010536f:	8b 50 44             	mov    0x44(%eax),%edx
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
80105375:	c1 e0 02             	shl    $0x2,%eax
80105378:	01 d0                	add    %edx,%eax
8010537a:	8d 50 04             	lea    0x4(%eax),%edx
8010537d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105380:	89 44 24 04          	mov    %eax,0x4(%esp)
80105384:	89 14 24             	mov    %edx,(%esp)
80105387:	e8 34 ff ff ff       	call   801052c0 <fetchint>
}
8010538c:	c9                   	leave  
8010538d:	c3                   	ret    

8010538e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010538e:	55                   	push   %ebp
8010538f:	89 e5                	mov    %esp,%ebp
80105391:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
80105394:	e8 22 ee ff ff       	call   801041bb <myproc>
80105399:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010539c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010539f:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a3:	8b 45 08             	mov    0x8(%ebp),%eax
801053a6:	89 04 24             	mov    %eax,(%esp)
801053a9:	e8 b3 ff ff ff       	call   80105361 <argint>
801053ae:	85 c0                	test   %eax,%eax
801053b0:	79 07                	jns    801053b9 <argptr+0x2b>
    return -1;
801053b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b7:	eb 3d                	jmp    801053f6 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053bd:	78 21                	js     801053e0 <argptr+0x52>
801053bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c2:	89 c2                	mov    %eax,%edx
801053c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c7:	8b 00                	mov    (%eax),%eax
801053c9:	39 c2                	cmp    %eax,%edx
801053cb:	73 13                	jae    801053e0 <argptr+0x52>
801053cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d0:	89 c2                	mov    %eax,%edx
801053d2:	8b 45 10             	mov    0x10(%ebp),%eax
801053d5:	01 c2                	add    %eax,%edx
801053d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053da:	8b 00                	mov    (%eax),%eax
801053dc:	39 c2                	cmp    %eax,%edx
801053de:	76 07                	jbe    801053e7 <argptr+0x59>
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e5:	eb 0f                	jmp    801053f6 <argptr+0x68>
  *pp = (char*)i;
801053e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ea:	89 c2                	mov    %eax,%edx
801053ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ef:	89 10                	mov    %edx,(%eax)
  return 0;
801053f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053f6:	c9                   	leave  
801053f7:	c3                   	ret    

801053f8 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053f8:	55                   	push   %ebp
801053f9:	89 e5                	mov    %esp,%ebp
801053fb:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105401:	89 44 24 04          	mov    %eax,0x4(%esp)
80105405:	8b 45 08             	mov    0x8(%ebp),%eax
80105408:	89 04 24             	mov    %eax,(%esp)
8010540b:	e8 51 ff ff ff       	call   80105361 <argint>
80105410:	85 c0                	test   %eax,%eax
80105412:	79 07                	jns    8010541b <argstr+0x23>
    return -1;
80105414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105419:	eb 12                	jmp    8010542d <argstr+0x35>
  return fetchstr(addr, pp);
8010541b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105421:	89 54 24 04          	mov    %edx,0x4(%esp)
80105425:	89 04 24             	mov    %eax,(%esp)
80105428:	e8 d2 fe ff ff       	call   801052ff <fetchstr>
}
8010542d:	c9                   	leave  
8010542e:	c3                   	ret    

8010542f <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
8010542f:	55                   	push   %ebp
80105430:	89 e5                	mov    %esp,%ebp
80105432:	53                   	push   %ebx
80105433:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105436:	e8 80 ed ff ff       	call   801041bb <myproc>
8010543b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010543e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105441:	8b 40 18             	mov    0x18(%eax),%eax
80105444:	8b 40 1c             	mov    0x1c(%eax),%eax
80105447:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010544a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010544e:	7e 2d                	jle    8010547d <syscall+0x4e>
80105450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105453:	83 f8 15             	cmp    $0x15,%eax
80105456:	77 25                	ja     8010547d <syscall+0x4e>
80105458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010545b:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105462:	85 c0                	test   %eax,%eax
80105464:	74 17                	je     8010547d <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105469:	8b 58 18             	mov    0x18(%eax),%ebx
8010546c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546f:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105476:	ff d0                	call   *%eax
80105478:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010547b:	eb 34                	jmp    801054b1 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010547d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105480:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105486:	8b 40 10             	mov    0x10(%eax),%eax
80105489:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010548c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105490:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105494:	89 44 24 04          	mov    %eax,0x4(%esp)
80105498:	c7 04 24 14 86 10 80 	movl   $0x80108614,(%esp)
8010549f:	e8 1d af ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801054a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a7:	8b 40 18             	mov    0x18(%eax),%eax
801054aa:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801054b1:	83 c4 24             	add    $0x24,%esp
801054b4:	5b                   	pop    %ebx
801054b5:	5d                   	pop    %ebp
801054b6:	c3                   	ret    
	...

801054b8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801054b8:	55                   	push   %ebp
801054b9:	89 e5                	mov    %esp,%ebp
801054bb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801054be:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801054c5:	8b 45 08             	mov    0x8(%ebp),%eax
801054c8:	89 04 24             	mov    %eax,(%esp)
801054cb:	e8 91 fe ff ff       	call   80105361 <argint>
801054d0:	85 c0                	test   %eax,%eax
801054d2:	79 07                	jns    801054db <argfd+0x23>
    return -1;
801054d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d9:	eb 4f                	jmp    8010552a <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054de:	85 c0                	test   %eax,%eax
801054e0:	78 20                	js     80105502 <argfd+0x4a>
801054e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e5:	83 f8 0f             	cmp    $0xf,%eax
801054e8:	7f 18                	jg     80105502 <argfd+0x4a>
801054ea:	e8 cc ec ff ff       	call   801041bb <myproc>
801054ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054f2:	83 c2 08             	add    $0x8,%edx
801054f5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801054f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105500:	75 07                	jne    80105509 <argfd+0x51>
    return -1;
80105502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105507:	eb 21                	jmp    8010552a <argfd+0x72>
  if(pfd)
80105509:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010550d:	74 08                	je     80105517 <argfd+0x5f>
    *pfd = fd;
8010550f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105512:	8b 45 0c             	mov    0xc(%ebp),%eax
80105515:	89 10                	mov    %edx,(%eax)
  if(pf)
80105517:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010551b:	74 08                	je     80105525 <argfd+0x6d>
    *pf = f;
8010551d:	8b 45 10             	mov    0x10(%ebp),%eax
80105520:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105523:	89 10                	mov    %edx,(%eax)
  return 0;
80105525:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    

8010552c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010552c:	55                   	push   %ebp
8010552d:	89 e5                	mov    %esp,%ebp
8010552f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105532:	e8 84 ec ff ff       	call   801041bb <myproc>
80105537:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010553a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105541:	eb 29                	jmp    8010556c <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
80105543:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105546:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105549:	83 c2 08             	add    $0x8,%edx
8010554c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105550:	85 c0                	test   %eax,%eax
80105552:	75 15                	jne    80105569 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105557:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010555d:	8b 55 08             	mov    0x8(%ebp),%edx
80105560:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105567:	eb 0e                	jmp    80105577 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105569:	ff 45 f4             	incl   -0xc(%ebp)
8010556c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105570:	7e d1                	jle    80105543 <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105572:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105577:	c9                   	leave  
80105578:	c3                   	ret    

80105579 <sys_dup>:

int
sys_dup(void)
{
80105579:	55                   	push   %ebp
8010557a:	89 e5                	mov    %esp,%ebp
8010557c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010557f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105582:	89 44 24 08          	mov    %eax,0x8(%esp)
80105586:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010558d:	00 
8010558e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105595:	e8 1e ff ff ff       	call   801054b8 <argfd>
8010559a:	85 c0                	test   %eax,%eax
8010559c:	79 07                	jns    801055a5 <sys_dup+0x2c>
    return -1;
8010559e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a3:	eb 29                	jmp    801055ce <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801055a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a8:	89 04 24             	mov    %eax,(%esp)
801055ab:	e8 7c ff ff ff       	call   8010552c <fdalloc>
801055b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055b7:	79 07                	jns    801055c0 <sys_dup+0x47>
    return -1;
801055b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055be:	eb 0e                	jmp    801055ce <sys_dup+0x55>
  filedup(f);
801055c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055c3:	89 04 24             	mov    %eax,(%esp)
801055c6:	e8 9d ba ff ff       	call   80101068 <filedup>
  return fd;
801055cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801055ce:	c9                   	leave  
801055cf:	c3                   	ret    

801055d0 <sys_read>:

int
sys_read(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801055dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055e4:	00 
801055e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055ec:	e8 c7 fe ff ff       	call   801054b8 <argfd>
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 35                	js     8010562a <sys_read+0x5a>
801055f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801055fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105603:	e8 59 fd ff ff       	call   80105361 <argint>
80105608:	85 c0                	test   %eax,%eax
8010560a:	78 1e                	js     8010562a <sys_read+0x5a>
8010560c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010560f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105613:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105616:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105621:	e8 68 fd ff ff       	call   8010538e <argptr>
80105626:	85 c0                	test   %eax,%eax
80105628:	79 07                	jns    80105631 <sys_read+0x61>
    return -1;
8010562a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562f:	eb 19                	jmp    8010564a <sys_read+0x7a>
  return fileread(f, p, n);
80105631:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105634:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010563e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105642:	89 04 24             	mov    %eax,(%esp)
80105645:	e8 7f bb ff ff       	call   801011c9 <fileread>
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    

8010564c <sys_write>:

int
sys_write(void)
{
8010564c:	55                   	push   %ebp
8010564d:	89 e5                	mov    %esp,%ebp
8010564f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105652:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105655:	89 44 24 08          	mov    %eax,0x8(%esp)
80105659:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105660:	00 
80105661:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105668:	e8 4b fe ff ff       	call   801054b8 <argfd>
8010566d:	85 c0                	test   %eax,%eax
8010566f:	78 35                	js     801056a6 <sys_write+0x5a>
80105671:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105674:	89 44 24 04          	mov    %eax,0x4(%esp)
80105678:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010567f:	e8 dd fc ff ff       	call   80105361 <argint>
80105684:	85 c0                	test   %eax,%eax
80105686:	78 1e                	js     801056a6 <sys_write+0x5a>
80105688:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010568f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105692:	89 44 24 04          	mov    %eax,0x4(%esp)
80105696:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010569d:	e8 ec fc ff ff       	call   8010538e <argptr>
801056a2:	85 c0                	test   %eax,%eax
801056a4:	79 07                	jns    801056ad <sys_write+0x61>
    return -1;
801056a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ab:	eb 19                	jmp    801056c6 <sys_write+0x7a>
  return filewrite(f, p, n);
801056ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801056b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056ba:	89 54 24 04          	mov    %edx,0x4(%esp)
801056be:	89 04 24             	mov    %eax,(%esp)
801056c1:	e8 be bb ff ff       	call   80101284 <filewrite>
}
801056c6:	c9                   	leave  
801056c7:	c3                   	ret    

801056c8 <sys_close>:

int
sys_close(void)
{
801056c8:	55                   	push   %ebp
801056c9:	89 e5                	mov    %esp,%ebp
801056cb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801056ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801056d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801056dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056e3:	e8 d0 fd ff ff       	call   801054b8 <argfd>
801056e8:	85 c0                	test   %eax,%eax
801056ea:	79 07                	jns    801056f3 <sys_close+0x2b>
    return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f1:	eb 23                	jmp    80105716 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
801056f3:	e8 c3 ea ff ff       	call   801041bb <myproc>
801056f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056fb:	83 c2 08             	add    $0x8,%edx
801056fe:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105705:	00 
  fileclose(f);
80105706:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105709:	89 04 24             	mov    %eax,(%esp)
8010570c:	e8 9f b9 ff ff       	call   801010b0 <fileclose>
  return 0;
80105711:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105716:	c9                   	leave  
80105717:	c3                   	ret    

80105718 <sys_fstat>:

int
sys_fstat(void)
{
80105718:	55                   	push   %ebp
80105719:	89 e5                	mov    %esp,%ebp
8010571b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010571e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105721:	89 44 24 08          	mov    %eax,0x8(%esp)
80105725:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010572c:	00 
8010572d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105734:	e8 7f fd ff ff       	call   801054b8 <argfd>
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 1f                	js     8010575c <sys_fstat+0x44>
8010573d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105744:	00 
80105745:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105748:	89 44 24 04          	mov    %eax,0x4(%esp)
8010574c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105753:	e8 36 fc ff ff       	call   8010538e <argptr>
80105758:	85 c0                	test   %eax,%eax
8010575a:	79 07                	jns    80105763 <sys_fstat+0x4b>
    return -1;
8010575c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105761:	eb 12                	jmp    80105775 <sys_fstat+0x5d>
  return filestat(f, st);
80105763:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105769:	89 54 24 04          	mov    %edx,0x4(%esp)
8010576d:	89 04 24             	mov    %eax,(%esp)
80105770:	e8 05 ba ff ff       	call   8010117a <filestat>
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    

80105777 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105777:	55                   	push   %ebp
80105778:	89 e5                	mov    %esp,%ebp
8010577a:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010577d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105780:	89 44 24 04          	mov    %eax,0x4(%esp)
80105784:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010578b:	e8 68 fc ff ff       	call   801053f8 <argstr>
80105790:	85 c0                	test   %eax,%eax
80105792:	78 17                	js     801057ab <sys_link+0x34>
80105794:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105797:	89 44 24 04          	mov    %eax,0x4(%esp)
8010579b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057a2:	e8 51 fc ff ff       	call   801053f8 <argstr>
801057a7:	85 c0                	test   %eax,%eax
801057a9:	79 0a                	jns    801057b5 <sys_link+0x3e>
    return -1;
801057ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b0:	e9 3d 01 00 00       	jmp    801058f2 <sys_link+0x17b>

  begin_op();
801057b5:	e8 09 dd ff ff       	call   801034c3 <begin_op>
  if((ip = namei(old)) == 0){
801057ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
801057bd:	89 04 24             	mov    %eax,(%esp)
801057c0:	e8 2a cd ff ff       	call   801024ef <namei>
801057c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057cc:	75 0f                	jne    801057dd <sys_link+0x66>
    end_op();
801057ce:	e8 72 dd ff ff       	call   80103545 <end_op>
    return -1;
801057d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d8:	e9 15 01 00 00       	jmp    801058f2 <sys_link+0x17b>
  }

  ilock(ip);
801057dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e0:	89 04 24             	mov    %eax,(%esp)
801057e3:	e8 e2 c1 ff ff       	call   801019ca <ilock>
  if(ip->type == T_DIR){
801057e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057eb:	8b 40 50             	mov    0x50(%eax),%eax
801057ee:	66 83 f8 01          	cmp    $0x1,%ax
801057f2:	75 1a                	jne    8010580e <sys_link+0x97>
    iunlockput(ip);
801057f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f7:	89 04 24             	mov    %eax,(%esp)
801057fa:	e8 ca c3 ff ff       	call   80101bc9 <iunlockput>
    end_op();
801057ff:	e8 41 dd ff ff       	call   80103545 <end_op>
    return -1;
80105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105809:	e9 e4 00 00 00       	jmp    801058f2 <sys_link+0x17b>
  }

  ip->nlink++;
8010580e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105811:	66 8b 40 56          	mov    0x56(%eax),%ax
80105815:	40                   	inc    %eax
80105816:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105819:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
8010581d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105820:	89 04 24             	mov    %eax,(%esp)
80105823:	e8 df bf ff ff       	call   80101807 <iupdate>
  iunlock(ip);
80105828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582b:	89 04 24             	mov    %eax,(%esp)
8010582e:	e8 a1 c2 ff ff       	call   80101ad4 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105833:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105836:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105839:	89 54 24 04          	mov    %edx,0x4(%esp)
8010583d:	89 04 24             	mov    %eax,(%esp)
80105840:	e8 cc cc ff ff       	call   80102511 <nameiparent>
80105845:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010584c:	75 02                	jne    80105850 <sys_link+0xd9>
    goto bad;
8010584e:	eb 68                	jmp    801058b8 <sys_link+0x141>
  ilock(dp);
80105850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105853:	89 04 24             	mov    %eax,(%esp)
80105856:	e8 6f c1 ff ff       	call   801019ca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010585b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585e:	8b 10                	mov    (%eax),%edx
80105860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105863:	8b 00                	mov    (%eax),%eax
80105865:	39 c2                	cmp    %eax,%edx
80105867:	75 20                	jne    80105889 <sys_link+0x112>
80105869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586c:	8b 40 04             	mov    0x4(%eax),%eax
8010586f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105873:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105876:	89 44 24 04          	mov    %eax,0x4(%esp)
8010587a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010587d:	89 04 24             	mov    %eax,(%esp)
80105880:	e8 b7 c9 ff ff       	call   8010223c <dirlink>
80105885:	85 c0                	test   %eax,%eax
80105887:	79 0d                	jns    80105896 <sys_link+0x11f>
    iunlockput(dp);
80105889:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588c:	89 04 24             	mov    %eax,(%esp)
8010588f:	e8 35 c3 ff ff       	call   80101bc9 <iunlockput>
    goto bad;
80105894:	eb 22                	jmp    801058b8 <sys_link+0x141>
  }
  iunlockput(dp);
80105896:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105899:	89 04 24             	mov    %eax,(%esp)
8010589c:	e8 28 c3 ff ff       	call   80101bc9 <iunlockput>
  iput(ip);
801058a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a4:	89 04 24             	mov    %eax,(%esp)
801058a7:	e8 6c c2 ff ff       	call   80101b18 <iput>

  end_op();
801058ac:	e8 94 dc ff ff       	call   80103545 <end_op>

  return 0;
801058b1:	b8 00 00 00 00       	mov    $0x0,%eax
801058b6:	eb 3a                	jmp    801058f2 <sys_link+0x17b>

bad:
  ilock(ip);
801058b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058bb:	89 04 24             	mov    %eax,(%esp)
801058be:	e8 07 c1 ff ff       	call   801019ca <ilock>
  ip->nlink--;
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	66 8b 40 56          	mov    0x56(%eax),%ax
801058ca:	48                   	dec    %eax
801058cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ce:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
801058d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d5:	89 04 24             	mov    %eax,(%esp)
801058d8:	e8 2a bf ff ff       	call   80101807 <iupdate>
  iunlockput(ip);
801058dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e0:	89 04 24             	mov    %eax,(%esp)
801058e3:	e8 e1 c2 ff ff       	call   80101bc9 <iunlockput>
  end_op();
801058e8:	e8 58 dc ff ff       	call   80103545 <end_op>
  return -1;
801058ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    

801058f4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058fa:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105901:	eb 4a                	jmp    8010594d <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105906:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010590d:	00 
8010590e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105912:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105915:	89 44 24 04          	mov    %eax,0x4(%esp)
80105919:	8b 45 08             	mov    0x8(%ebp),%eax
8010591c:	89 04 24             	mov    %eax,(%esp)
8010591f:	e8 3d c5 ff ff       	call   80101e61 <readi>
80105924:	83 f8 10             	cmp    $0x10,%eax
80105927:	74 0c                	je     80105935 <isdirempty+0x41>
      panic("isdirempty: readi");
80105929:	c7 04 24 30 86 10 80 	movl   $0x80108630,(%esp)
80105930:	e8 1f ac ff ff       	call   80100554 <panic>
    if(de.inum != 0)
80105935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105938:	66 85 c0             	test   %ax,%ax
8010593b:	74 07                	je     80105944 <isdirempty+0x50>
      return 0;
8010593d:	b8 00 00 00 00       	mov    $0x0,%eax
80105942:	eb 1b                	jmp    8010595f <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105947:	83 c0 10             	add    $0x10,%eax
8010594a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010594d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105950:	8b 45 08             	mov    0x8(%ebp),%eax
80105953:	8b 40 58             	mov    0x58(%eax),%eax
80105956:	39 c2                	cmp    %eax,%edx
80105958:	72 a9                	jb     80105903 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010595a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010595f:	c9                   	leave  
80105960:	c3                   	ret    

80105961 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105961:	55                   	push   %ebp
80105962:	89 e5                	mov    %esp,%ebp
80105964:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105967:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010596a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010596e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105975:	e8 7e fa ff ff       	call   801053f8 <argstr>
8010597a:	85 c0                	test   %eax,%eax
8010597c:	79 0a                	jns    80105988 <sys_unlink+0x27>
    return -1;
8010597e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105983:	e9 a9 01 00 00       	jmp    80105b31 <sys_unlink+0x1d0>

  begin_op();
80105988:	e8 36 db ff ff       	call   801034c3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010598d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105990:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105993:	89 54 24 04          	mov    %edx,0x4(%esp)
80105997:	89 04 24             	mov    %eax,(%esp)
8010599a:	e8 72 cb ff ff       	call   80102511 <nameiparent>
8010599f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059a6:	75 0f                	jne    801059b7 <sys_unlink+0x56>
    end_op();
801059a8:	e8 98 db ff ff       	call   80103545 <end_op>
    return -1;
801059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b2:	e9 7a 01 00 00       	jmp    80105b31 <sys_unlink+0x1d0>
  }

  ilock(dp);
801059b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ba:	89 04 24             	mov    %eax,(%esp)
801059bd:	e8 08 c0 ff ff       	call   801019ca <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801059c2:	c7 44 24 04 42 86 10 	movl   $0x80108642,0x4(%esp)
801059c9:	80 
801059ca:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801059cd:	89 04 24             	mov    %eax,(%esp)
801059d0:	e8 7f c7 ff ff       	call   80102154 <namecmp>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	0f 84 3f 01 00 00    	je     80105b1c <sys_unlink+0x1bb>
801059dd:	c7 44 24 04 44 86 10 	movl   $0x80108644,0x4(%esp)
801059e4:	80 
801059e5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801059e8:	89 04 24             	mov    %eax,(%esp)
801059eb:	e8 64 c7 ff ff       	call   80102154 <namecmp>
801059f0:	85 c0                	test   %eax,%eax
801059f2:	0f 84 24 01 00 00    	je     80105b1c <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801059f8:	8d 45 c8             	lea    -0x38(%ebp),%eax
801059fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801059ff:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a09:	89 04 24             	mov    %eax,(%esp)
80105a0c:	e8 65 c7 ff ff       	call   80102176 <dirlookup>
80105a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a18:	75 05                	jne    80105a1f <sys_unlink+0xbe>
    goto bad;
80105a1a:	e9 fd 00 00 00       	jmp    80105b1c <sys_unlink+0x1bb>
  ilock(ip);
80105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a22:	89 04 24             	mov    %eax,(%esp)
80105a25:	e8 a0 bf ff ff       	call   801019ca <ilock>

  if(ip->nlink < 1)
80105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2d:	66 8b 40 56          	mov    0x56(%eax),%ax
80105a31:	66 85 c0             	test   %ax,%ax
80105a34:	7f 0c                	jg     80105a42 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105a36:	c7 04 24 47 86 10 80 	movl   $0x80108647,(%esp)
80105a3d:	e8 12 ab ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a45:	8b 40 50             	mov    0x50(%eax),%eax
80105a48:	66 83 f8 01          	cmp    $0x1,%ax
80105a4c:	75 1f                	jne    80105a6d <sys_unlink+0x10c>
80105a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a51:	89 04 24             	mov    %eax,(%esp)
80105a54:	e8 9b fe ff ff       	call   801058f4 <isdirempty>
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	75 10                	jne    80105a6d <sys_unlink+0x10c>
    iunlockput(ip);
80105a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a60:	89 04 24             	mov    %eax,(%esp)
80105a63:	e8 61 c1 ff ff       	call   80101bc9 <iunlockput>
    goto bad;
80105a68:	e9 af 00 00 00       	jmp    80105b1c <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105a6d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105a74:	00 
80105a75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a7c:	00 
80105a7d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a80:	89 04 24             	mov    %eax,(%esp)
80105a83:	e8 a6 f5 ff ff       	call   8010502e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a88:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105a8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105a92:	00 
80105a93:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a97:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa1:	89 04 24             	mov    %eax,(%esp)
80105aa4:	e8 1c c5 ff ff       	call   80101fc5 <writei>
80105aa9:	83 f8 10             	cmp    $0x10,%eax
80105aac:	74 0c                	je     80105aba <sys_unlink+0x159>
    panic("unlink: writei");
80105aae:	c7 04 24 59 86 10 80 	movl   $0x80108659,(%esp)
80105ab5:	e8 9a aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abd:	8b 40 50             	mov    0x50(%eax),%eax
80105ac0:	66 83 f8 01          	cmp    $0x1,%ax
80105ac4:	75 1a                	jne    80105ae0 <sys_unlink+0x17f>
    dp->nlink--;
80105ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac9:	66 8b 40 56          	mov    0x56(%eax),%ax
80105acd:	48                   	dec    %eax
80105ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ad1:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad8:	89 04 24             	mov    %eax,(%esp)
80105adb:	e8 27 bd ff ff       	call   80101807 <iupdate>
  }
  iunlockput(dp);
80105ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae3:	89 04 24             	mov    %eax,(%esp)
80105ae6:	e8 de c0 ff ff       	call   80101bc9 <iunlockput>

  ip->nlink--;
80105aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aee:	66 8b 40 56          	mov    0x56(%eax),%ax
80105af2:	48                   	dec    %eax
80105af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105af6:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afd:	89 04 24             	mov    %eax,(%esp)
80105b00:	e8 02 bd ff ff       	call   80101807 <iupdate>
  iunlockput(ip);
80105b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b08:	89 04 24             	mov    %eax,(%esp)
80105b0b:	e8 b9 c0 ff ff       	call   80101bc9 <iunlockput>

  end_op();
80105b10:	e8 30 da ff ff       	call   80103545 <end_op>

  return 0;
80105b15:	b8 00 00 00 00       	mov    $0x0,%eax
80105b1a:	eb 15                	jmp    80105b31 <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1f:	89 04 24             	mov    %eax,(%esp)
80105b22:	e8 a2 c0 ff ff       	call   80101bc9 <iunlockput>
  end_op();
80105b27:	e8 19 da ff ff       	call   80103545 <end_op>
  return -1;
80105b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b31:	c9                   	leave  
80105b32:	c3                   	ret    

80105b33 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b33:	55                   	push   %ebp
80105b34:	89 e5                	mov    %esp,%ebp
80105b36:	83 ec 48             	sub    $0x48,%esp
80105b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105b3c:	8b 55 10             	mov    0x10(%ebp),%edx
80105b3f:	8b 45 14             	mov    0x14(%ebp),%eax
80105b42:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105b46:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105b4a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b4e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b55:	8b 45 08             	mov    0x8(%ebp),%eax
80105b58:	89 04 24             	mov    %eax,(%esp)
80105b5b:	e8 b1 c9 ff ff       	call   80102511 <nameiparent>
80105b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b67:	75 0a                	jne    80105b73 <create+0x40>
    return 0;
80105b69:	b8 00 00 00 00       	mov    $0x0,%eax
80105b6e:	e9 79 01 00 00       	jmp    80105cec <create+0x1b9>
  ilock(dp);
80105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b76:	89 04 24             	mov    %eax,(%esp)
80105b79:	e8 4c be ff ff       	call   801019ca <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b81:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b85:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b88:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	89 04 24             	mov    %eax,(%esp)
80105b92:	e8 df c5 ff ff       	call   80102176 <dirlookup>
80105b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b9e:	74 46                	je     80105be6 <create+0xb3>
    iunlockput(dp);
80105ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba3:	89 04 24             	mov    %eax,(%esp)
80105ba6:	e8 1e c0 ff ff       	call   80101bc9 <iunlockput>
    ilock(ip);
80105bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bae:	89 04 24             	mov    %eax,(%esp)
80105bb1:	e8 14 be ff ff       	call   801019ca <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105bb6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105bbb:	75 14                	jne    80105bd1 <create+0x9e>
80105bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc0:	8b 40 50             	mov    0x50(%eax),%eax
80105bc3:	66 83 f8 02          	cmp    $0x2,%ax
80105bc7:	75 08                	jne    80105bd1 <create+0x9e>
      return ip;
80105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcc:	e9 1b 01 00 00       	jmp    80105cec <create+0x1b9>
    iunlockput(ip);
80105bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd4:	89 04 24             	mov    %eax,(%esp)
80105bd7:	e8 ed bf ff ff       	call   80101bc9 <iunlockput>
    return 0;
80105bdc:	b8 00 00 00 00       	mov    $0x0,%eax
80105be1:	e9 06 01 00 00       	jmp    80105cec <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105be6:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bed:	8b 00                	mov    (%eax),%eax
80105bef:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bf3:	89 04 24             	mov    %eax,(%esp)
80105bf6:	e8 3a bb ff ff       	call   80101735 <ialloc>
80105bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c02:	75 0c                	jne    80105c10 <create+0xdd>
    panic("create: ialloc");
80105c04:	c7 04 24 68 86 10 80 	movl   $0x80108668,(%esp)
80105c0b:	e8 44 a9 ff ff       	call   80100554 <panic>

  ilock(ip);
80105c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c13:	89 04 24             	mov    %eax,(%esp)
80105c16:	e8 af bd ff ff       	call   801019ca <ilock>
  ip->major = major;
80105c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c21:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105c25:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c28:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c2b:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c32:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3b:	89 04 24             	mov    %eax,(%esp)
80105c3e:	e8 c4 bb ff ff       	call   80101807 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105c43:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105c48:	75 68                	jne    80105cb2 <create+0x17f>
    dp->nlink++;  // for ".."
80105c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4d:	66 8b 40 56          	mov    0x56(%eax),%ax
80105c51:	40                   	inc    %eax
80105c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c55:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5c:	89 04 24             	mov    %eax,(%esp)
80105c5f:	e8 a3 bb ff ff       	call   80101807 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c67:	8b 40 04             	mov    0x4(%eax),%eax
80105c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c6e:	c7 44 24 04 42 86 10 	movl   $0x80108642,0x4(%esp)
80105c75:	80 
80105c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c79:	89 04 24             	mov    %eax,(%esp)
80105c7c:	e8 bb c5 ff ff       	call   8010223c <dirlink>
80105c81:	85 c0                	test   %eax,%eax
80105c83:	78 21                	js     80105ca6 <create+0x173>
80105c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c88:	8b 40 04             	mov    0x4(%eax),%eax
80105c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c8f:	c7 44 24 04 44 86 10 	movl   $0x80108644,0x4(%esp)
80105c96:	80 
80105c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9a:	89 04 24             	mov    %eax,(%esp)
80105c9d:	e8 9a c5 ff ff       	call   8010223c <dirlink>
80105ca2:	85 c0                	test   %eax,%eax
80105ca4:	79 0c                	jns    80105cb2 <create+0x17f>
      panic("create dots");
80105ca6:	c7 04 24 77 86 10 80 	movl   $0x80108677,(%esp)
80105cad:	e8 a2 a8 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb5:	8b 40 04             	mov    0x4(%eax),%eax
80105cb8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cbc:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc6:	89 04 24             	mov    %eax,(%esp)
80105cc9:	e8 6e c5 ff ff       	call   8010223c <dirlink>
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	79 0c                	jns    80105cde <create+0x1ab>
    panic("create: dirlink");
80105cd2:	c7 04 24 83 86 10 80 	movl   $0x80108683,(%esp)
80105cd9:	e8 76 a8 ff ff       	call   80100554 <panic>

  iunlockput(dp);
80105cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce1:	89 04 24             	mov    %eax,(%esp)
80105ce4:	e8 e0 be ff ff       	call   80101bc9 <iunlockput>

  return ip;
80105ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105cec:	c9                   	leave  
80105ced:	c3                   	ret    

80105cee <sys_open>:

int
sys_open(void)
{
80105cee:	55                   	push   %ebp
80105cef:	89 e5                	mov    %esp,%ebp
80105cf1:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cf4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d02:	e8 f1 f6 ff ff       	call   801053f8 <argstr>
80105d07:	85 c0                	test   %eax,%eax
80105d09:	78 17                	js     80105d22 <sys_open+0x34>
80105d0b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d19:	e8 43 f6 ff ff       	call   80105361 <argint>
80105d1e:	85 c0                	test   %eax,%eax
80105d20:	79 0a                	jns    80105d2c <sys_open+0x3e>
    return -1;
80105d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d27:	e9 5b 01 00 00       	jmp    80105e87 <sys_open+0x199>

  begin_op();
80105d2c:	e8 92 d7 ff ff       	call   801034c3 <begin_op>

  if(omode & O_CREATE){
80105d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d34:	25 00 02 00 00       	and    $0x200,%eax
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 3b                	je     80105d78 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d40:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d47:	00 
80105d48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d4f:	00 
80105d50:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105d57:	00 
80105d58:	89 04 24             	mov    %eax,(%esp)
80105d5b:	e8 d3 fd ff ff       	call   80105b33 <create>
80105d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d67:	75 6a                	jne    80105dd3 <sys_open+0xe5>
      end_op();
80105d69:	e8 d7 d7 ff ff       	call   80103545 <end_op>
      return -1;
80105d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d73:	e9 0f 01 00 00       	jmp    80105e87 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d7b:	89 04 24             	mov    %eax,(%esp)
80105d7e:	e8 6c c7 ff ff       	call   801024ef <namei>
80105d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d8a:	75 0f                	jne    80105d9b <sys_open+0xad>
      end_op();
80105d8c:	e8 b4 d7 ff ff       	call   80103545 <end_op>
      return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d96:	e9 ec 00 00 00       	jmp    80105e87 <sys_open+0x199>
    }
    ilock(ip);
80105d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9e:	89 04 24             	mov    %eax,(%esp)
80105da1:	e8 24 bc ff ff       	call   801019ca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da9:	8b 40 50             	mov    0x50(%eax),%eax
80105dac:	66 83 f8 01          	cmp    $0x1,%ax
80105db0:	75 21                	jne    80105dd3 <sys_open+0xe5>
80105db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	74 1a                	je     80105dd3 <sys_open+0xe5>
      iunlockput(ip);
80105db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbc:	89 04 24             	mov    %eax,(%esp)
80105dbf:	e8 05 be ff ff       	call   80101bc9 <iunlockput>
      end_op();
80105dc4:	e8 7c d7 ff ff       	call   80103545 <end_op>
      return -1;
80105dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dce:	e9 b4 00 00 00       	jmp    80105e87 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105dd3:	e8 30 b2 ff ff       	call   80101008 <filealloc>
80105dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ddb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ddf:	74 14                	je     80105df5 <sys_open+0x107>
80105de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de4:	89 04 24             	mov    %eax,(%esp)
80105de7:	e8 40 f7 ff ff       	call   8010552c <fdalloc>
80105dec:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105def:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105df3:	79 28                	jns    80105e1d <sys_open+0x12f>
    if(f)
80105df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105df9:	74 0b                	je     80105e06 <sys_open+0x118>
      fileclose(f);
80105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfe:	89 04 24             	mov    %eax,(%esp)
80105e01:	e8 aa b2 ff ff       	call   801010b0 <fileclose>
    iunlockput(ip);
80105e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e09:	89 04 24             	mov    %eax,(%esp)
80105e0c:	e8 b8 bd ff ff       	call   80101bc9 <iunlockput>
    end_op();
80105e11:	e8 2f d7 ff ff       	call   80103545 <end_op>
    return -1;
80105e16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1b:	eb 6a                	jmp    80105e87 <sys_open+0x199>
  }
  iunlock(ip);
80105e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e20:	89 04 24             	mov    %eax,(%esp)
80105e23:	e8 ac bc ff ff       	call   80101ad4 <iunlock>
  end_op();
80105e28:	e8 18 d7 ff ff       	call   80103545 <end_op>

  f->type = FD_INODE;
80105e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e30:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e42:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e4c:	83 e0 01             	and    $0x1,%eax
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	0f 94 c0             	sete   %al
80105e54:	88 c2                	mov    %al,%dl
80105e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e59:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e5f:	83 e0 01             	and    $0x1,%eax
80105e62:	85 c0                	test   %eax,%eax
80105e64:	75 0a                	jne    80105e70 <sys_open+0x182>
80105e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e69:	83 e0 02             	and    $0x2,%eax
80105e6c:	85 c0                	test   %eax,%eax
80105e6e:	74 07                	je     80105e77 <sys_open+0x189>
80105e70:	b8 01 00 00 00       	mov    $0x1,%eax
80105e75:	eb 05                	jmp    80105e7c <sys_open+0x18e>
80105e77:	b8 00 00 00 00       	mov    $0x0,%eax
80105e7c:	88 c2                	mov    %al,%dl
80105e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e81:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105e87:	c9                   	leave  
80105e88:	c3                   	ret    

80105e89 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e89:	55                   	push   %ebp
80105e8a:	89 e5                	mov    %esp,%ebp
80105e8c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e8f:	e8 2f d6 ff ff       	call   801034c3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e97:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ea2:	e8 51 f5 ff ff       	call   801053f8 <argstr>
80105ea7:	85 c0                	test   %eax,%eax
80105ea9:	78 2c                	js     80105ed7 <sys_mkdir+0x4e>
80105eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105eb5:	00 
80105eb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105ebd:	00 
80105ebe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105ec5:	00 
80105ec6:	89 04 24             	mov    %eax,(%esp)
80105ec9:	e8 65 fc ff ff       	call   80105b33 <create>
80105ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ed5:	75 0c                	jne    80105ee3 <sys_mkdir+0x5a>
    end_op();
80105ed7:	e8 69 d6 ff ff       	call   80103545 <end_op>
    return -1;
80105edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee1:	eb 15                	jmp    80105ef8 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee6:	89 04 24             	mov    %eax,(%esp)
80105ee9:	e8 db bc ff ff       	call   80101bc9 <iunlockput>
  end_op();
80105eee:	e8 52 d6 ff ff       	call   80103545 <end_op>
  return 0;
80105ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ef8:	c9                   	leave  
80105ef9:	c3                   	ret    

80105efa <sys_mknod>:

int
sys_mknod(void)
{
80105efa:	55                   	push   %ebp
80105efb:	89 e5                	mov    %esp,%ebp
80105efd:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f00:	e8 be d5 ff ff       	call   801034c3 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f05:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f08:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f13:	e8 e0 f4 ff ff       	call   801053f8 <argstr>
80105f18:	85 c0                	test   %eax,%eax
80105f1a:	78 5e                	js     80105f7a <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f2a:	e8 32 f4 ff ff       	call   80105361 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	78 47                	js     80105f7a <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f33:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f41:	e8 1b f4 ff ff       	call   80105361 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105f46:	85 c0                	test   %eax,%eax
80105f48:	78 30                	js     80105f7a <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f4d:	0f bf c8             	movswl %ax,%ecx
80105f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f53:	0f bf d0             	movswl %ax,%edx
80105f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f59:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105f5d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105f61:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105f68:	00 
80105f69:	89 04 24             	mov    %eax,(%esp)
80105f6c:	e8 c2 fb ff ff       	call   80105b33 <create>
80105f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f78:	75 0c                	jne    80105f86 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105f7a:	e8 c6 d5 ff ff       	call   80103545 <end_op>
    return -1;
80105f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f84:	eb 15                	jmp    80105f9b <sys_mknod+0xa1>
  }
  iunlockput(ip);
80105f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f89:	89 04 24             	mov    %eax,(%esp)
80105f8c:	e8 38 bc ff ff       	call   80101bc9 <iunlockput>
  end_op();
80105f91:	e8 af d5 ff ff       	call   80103545 <end_op>
  return 0;
80105f96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f9b:	c9                   	leave  
80105f9c:	c3                   	ret    

80105f9d <sys_chdir>:

int
sys_chdir(void)
{
80105f9d:	55                   	push   %ebp
80105f9e:	89 e5                	mov    %esp,%ebp
80105fa0:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fa3:	e8 13 e2 ff ff       	call   801041bb <myproc>
80105fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105fab:	e8 13 d5 ff ff       	call   801034c3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fbe:	e8 35 f4 ff ff       	call   801053f8 <argstr>
80105fc3:	85 c0                	test   %eax,%eax
80105fc5:	78 14                	js     80105fdb <sys_chdir+0x3e>
80105fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fca:	89 04 24             	mov    %eax,(%esp)
80105fcd:	e8 1d c5 ff ff       	call   801024ef <namei>
80105fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd9:	75 0c                	jne    80105fe7 <sys_chdir+0x4a>
    end_op();
80105fdb:	e8 65 d5 ff ff       	call   80103545 <end_op>
    return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe5:	eb 5a                	jmp    80106041 <sys_chdir+0xa4>
  }
  ilock(ip);
80105fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fea:	89 04 24             	mov    %eax,(%esp)
80105fed:	e8 d8 b9 ff ff       	call   801019ca <ilock>
  if(ip->type != T_DIR){
80105ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff5:	8b 40 50             	mov    0x50(%eax),%eax
80105ff8:	66 83 f8 01          	cmp    $0x1,%ax
80105ffc:	74 17                	je     80106015 <sys_chdir+0x78>
    iunlockput(ip);
80105ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106001:	89 04 24             	mov    %eax,(%esp)
80106004:	e8 c0 bb ff ff       	call   80101bc9 <iunlockput>
    end_op();
80106009:	e8 37 d5 ff ff       	call   80103545 <end_op>
    return -1;
8010600e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106013:	eb 2c                	jmp    80106041 <sys_chdir+0xa4>
  }
  iunlock(ip);
80106015:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106018:	89 04 24             	mov    %eax,(%esp)
8010601b:	e8 b4 ba ff ff       	call   80101ad4 <iunlock>
  iput(curproc->cwd);
80106020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106023:	8b 40 68             	mov    0x68(%eax),%eax
80106026:	89 04 24             	mov    %eax,(%esp)
80106029:	e8 ea ba ff ff       	call   80101b18 <iput>
  end_op();
8010602e:	e8 12 d5 ff ff       	call   80103545 <end_op>
  curproc->cwd = ip;
80106033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106036:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106039:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010603c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106041:	c9                   	leave  
80106042:	c3                   	ret    

80106043 <sys_exec>:

int
sys_exec(void)
{
80106043:	55                   	push   %ebp
80106044:	89 e5                	mov    %esp,%ebp
80106046:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010604c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010604f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010605a:	e8 99 f3 ff ff       	call   801053f8 <argstr>
8010605f:	85 c0                	test   %eax,%eax
80106061:	78 1a                	js     8010607d <sys_exec+0x3a>
80106063:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106069:	89 44 24 04          	mov    %eax,0x4(%esp)
8010606d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106074:	e8 e8 f2 ff ff       	call   80105361 <argint>
80106079:	85 c0                	test   %eax,%eax
8010607b:	79 0a                	jns    80106087 <sys_exec+0x44>
    return -1;
8010607d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106082:	e9 c7 00 00 00       	jmp    8010614e <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106087:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010608e:	00 
8010608f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106096:	00 
80106097:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010609d:	89 04 24             	mov    %eax,(%esp)
801060a0:	e8 89 ef ff ff       	call   8010502e <memset>
  for(i=0;; i++){
801060a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801060ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060af:	83 f8 1f             	cmp    $0x1f,%eax
801060b2:	76 0a                	jbe    801060be <sys_exec+0x7b>
      return -1;
801060b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b9:	e9 90 00 00 00       	jmp    8010614e <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c1:	c1 e0 02             	shl    $0x2,%eax
801060c4:	89 c2                	mov    %eax,%edx
801060c6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801060cc:	01 c2                	add    %eax,%edx
801060ce:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801060d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d8:	89 14 24             	mov    %edx,(%esp)
801060db:	e8 e0 f1 ff ff       	call   801052c0 <fetchint>
801060e0:	85 c0                	test   %eax,%eax
801060e2:	79 07                	jns    801060eb <sys_exec+0xa8>
      return -1;
801060e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e9:	eb 63                	jmp    8010614e <sys_exec+0x10b>
    if(uarg == 0){
801060eb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801060f1:	85 c0                	test   %eax,%eax
801060f3:	75 26                	jne    8010611b <sys_exec+0xd8>
      argv[i] = 0;
801060f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f8:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801060ff:	00 00 00 00 
      break;
80106103:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106104:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106107:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010610d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106111:	89 04 24             	mov    %eax,(%esp)
80106114:	e8 93 aa ff ff       	call   80100bac <exec>
80106119:	eb 33                	jmp    8010614e <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010611b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106121:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106124:	c1 e2 02             	shl    $0x2,%edx
80106127:	01 c2                	add    %eax,%edx
80106129:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010612f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106133:	89 04 24             	mov    %eax,(%esp)
80106136:	e8 c4 f1 ff ff       	call   801052ff <fetchstr>
8010613b:	85 c0                	test   %eax,%eax
8010613d:	79 07                	jns    80106146 <sys_exec+0x103>
      return -1;
8010613f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106144:	eb 08                	jmp    8010614e <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106146:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106149:	e9 5e ff ff ff       	jmp    801060ac <sys_exec+0x69>
  return exec(path, argv);
}
8010614e:	c9                   	leave  
8010614f:	c3                   	ret    

80106150 <sys_pipe>:

int
sys_pipe(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106156:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010615d:	00 
8010615e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106161:	89 44 24 04          	mov    %eax,0x4(%esp)
80106165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010616c:	e8 1d f2 ff ff       	call   8010538e <argptr>
80106171:	85 c0                	test   %eax,%eax
80106173:	79 0a                	jns    8010617f <sys_pipe+0x2f>
    return -1;
80106175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617a:	e9 9a 00 00 00       	jmp    80106219 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
8010617f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106182:	89 44 24 04          	mov    %eax,0x4(%esp)
80106186:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106189:	89 04 24             	mov    %eax,(%esp)
8010618c:	e8 7f db ff ff       	call   80103d10 <pipealloc>
80106191:	85 c0                	test   %eax,%eax
80106193:	79 07                	jns    8010619c <sys_pipe+0x4c>
    return -1;
80106195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619a:	eb 7d                	jmp    80106219 <sys_pipe+0xc9>
  fd0 = -1;
8010619c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061a6:	89 04 24             	mov    %eax,(%esp)
801061a9:	e8 7e f3 ff ff       	call   8010552c <fdalloc>
801061ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061b5:	78 14                	js     801061cb <sys_pipe+0x7b>
801061b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061ba:	89 04 24             	mov    %eax,(%esp)
801061bd:	e8 6a f3 ff ff       	call   8010552c <fdalloc>
801061c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c9:	79 36                	jns    80106201 <sys_pipe+0xb1>
    if(fd0 >= 0)
801061cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061cf:	78 13                	js     801061e4 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801061d1:	e8 e5 df ff ff       	call   801041bb <myproc>
801061d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061d9:	83 c2 08             	add    $0x8,%edx
801061dc:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801061e3:	00 
    fileclose(rf);
801061e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061e7:	89 04 24             	mov    %eax,(%esp)
801061ea:	e8 c1 ae ff ff       	call   801010b0 <fileclose>
    fileclose(wf);
801061ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061f2:	89 04 24             	mov    %eax,(%esp)
801061f5:	e8 b6 ae ff ff       	call   801010b0 <fileclose>
    return -1;
801061fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ff:	eb 18                	jmp    80106219 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
80106201:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106204:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106207:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106209:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010620c:	8d 50 04             	lea    0x4(%eax),%edx
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	89 02                	mov    %eax,(%edx)
  return 0;
80106214:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106219:	c9                   	leave  
8010621a:	c3                   	ret    
	...

8010621c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010621c:	55                   	push   %ebp
8010621d:	89 e5                	mov    %esp,%ebp
8010621f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106222:	e8 90 e2 ff ff       	call   801044b7 <fork>
}
80106227:	c9                   	leave  
80106228:	c3                   	ret    

80106229 <sys_exit>:

int
sys_exit(void)
{
80106229:	55                   	push   %ebp
8010622a:	89 e5                	mov    %esp,%ebp
8010622c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010622f:	e8 e9 e3 ff ff       	call   8010461d <exit>
  return 0;  // not reached
80106234:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106239:	c9                   	leave  
8010623a:	c3                   	ret    

8010623b <sys_wait>:

int
sys_wait(void)
{
8010623b:	55                   	push   %ebp
8010623c:	89 e5                	mov    %esp,%ebp
8010623e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106241:	e8 e0 e4 ff ff       	call   80104726 <wait>
}
80106246:	c9                   	leave  
80106247:	c3                   	ret    

80106248 <sys_kill>:

int
sys_kill(void)
{
80106248:	55                   	push   %ebp
80106249:	89 e5                	mov    %esp,%ebp
8010624b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010624e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106251:	89 44 24 04          	mov    %eax,0x4(%esp)
80106255:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010625c:	e8 00 f1 ff ff       	call   80105361 <argint>
80106261:	85 c0                	test   %eax,%eax
80106263:	79 07                	jns    8010626c <sys_kill+0x24>
    return -1;
80106265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626a:	eb 0b                	jmp    80106277 <sys_kill+0x2f>
  return kill(pid);
8010626c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010626f:	89 04 24             	mov    %eax,(%esp)
80106272:	e8 84 e8 ff ff       	call   80104afb <kill>
}
80106277:	c9                   	leave  
80106278:	c3                   	ret    

80106279 <sys_getpid>:

int
sys_getpid(void)
{
80106279:	55                   	push   %ebp
8010627a:	89 e5                	mov    %esp,%ebp
8010627c:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010627f:	e8 37 df ff ff       	call   801041bb <myproc>
80106284:	8b 40 10             	mov    0x10(%eax),%eax
}
80106287:	c9                   	leave  
80106288:	c3                   	ret    

80106289 <sys_sbrk>:

int
sys_sbrk(void)
{
80106289:	55                   	push   %ebp
8010628a:	89 e5                	mov    %esp,%ebp
8010628c:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010628f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106292:	89 44 24 04          	mov    %eax,0x4(%esp)
80106296:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010629d:	e8 bf f0 ff ff       	call   80105361 <argint>
801062a2:	85 c0                	test   %eax,%eax
801062a4:	79 07                	jns    801062ad <sys_sbrk+0x24>
    return -1;
801062a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ab:	eb 23                	jmp    801062d0 <sys_sbrk+0x47>
  addr = myproc()->sz;
801062ad:	e8 09 df ff ff       	call   801041bb <myproc>
801062b2:	8b 00                	mov    (%eax),%eax
801062b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801062b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ba:	89 04 24             	mov    %eax,(%esp)
801062bd:	e8 57 e1 ff ff       	call   80104419 <growproc>
801062c2:	85 c0                	test   %eax,%eax
801062c4:	79 07                	jns    801062cd <sys_sbrk+0x44>
    return -1;
801062c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cb:	eb 03                	jmp    801062d0 <sys_sbrk+0x47>
  return addr;
801062cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801062d0:	c9                   	leave  
801062d1:	c3                   	ret    

801062d2 <sys_sleep>:

int
sys_sleep(void)
{
801062d2:	55                   	push   %ebp
801062d3:	89 e5                	mov    %esp,%ebp
801062d5:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062db:	89 44 24 04          	mov    %eax,0x4(%esp)
801062df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062e6:	e8 76 f0 ff ff       	call   80105361 <argint>
801062eb:	85 c0                	test   %eax,%eax
801062ed:	79 07                	jns    801062f6 <sys_sleep+0x24>
    return -1;
801062ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f4:	eb 6b                	jmp    80106361 <sys_sleep+0x8f>
  acquire(&tickslock);
801062f6:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801062fd:	e8 c9 ea ff ff       	call   80104dcb <acquire>
  ticks0 = ticks;
80106302:	a1 20 65 11 80       	mov    0x80116520,%eax
80106307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010630a:	eb 33                	jmp    8010633f <sys_sleep+0x6d>
    if(myproc()->killed){
8010630c:	e8 aa de ff ff       	call   801041bb <myproc>
80106311:	8b 40 24             	mov    0x24(%eax),%eax
80106314:	85 c0                	test   %eax,%eax
80106316:	74 13                	je     8010632b <sys_sleep+0x59>
      release(&tickslock);
80106318:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
8010631f:	e8 11 eb ff ff       	call   80104e35 <release>
      return -1;
80106324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106329:	eb 36                	jmp    80106361 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
8010632b:	c7 44 24 04 e0 5c 11 	movl   $0x80115ce0,0x4(%esp)
80106332:	80 
80106333:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
8010633a:	e8 bd e6 ff ff       	call   801049fc <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010633f:	a1 20 65 11 80       	mov    0x80116520,%eax
80106344:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106347:	89 c2                	mov    %eax,%edx
80106349:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634c:	39 c2                	cmp    %eax,%edx
8010634e:	72 bc                	jb     8010630c <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106350:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106357:	e8 d9 ea ff ff       	call   80104e35 <release>
  return 0;
8010635c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106361:	c9                   	leave  
80106362:	c3                   	ret    

80106363 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106363:	55                   	push   %ebp
80106364:	89 e5                	mov    %esp,%ebp
80106366:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106369:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106370:	e8 56 ea ff ff       	call   80104dcb <acquire>
  xticks = ticks;
80106375:	a1 20 65 11 80       	mov    0x80116520,%eax
8010637a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010637d:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106384:	e8 ac ea ff ff       	call   80104e35 <release>
  return xticks;
80106389:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010638c:	c9                   	leave  
8010638d:	c3                   	ret    
	...

80106390 <alltraps>:
80106390:	1e                   	push   %ds
80106391:	06                   	push   %es
80106392:	0f a0                	push   %fs
80106394:	0f a8                	push   %gs
80106396:	60                   	pusha  
80106397:	66 b8 10 00          	mov    $0x10,%ax
8010639b:	8e d8                	mov    %eax,%ds
8010639d:	8e c0                	mov    %eax,%es
8010639f:	54                   	push   %esp
801063a0:	e8 c0 01 00 00       	call   80106565 <trap>
801063a5:	83 c4 04             	add    $0x4,%esp

801063a8 <trapret>:
801063a8:	61                   	popa   
801063a9:	0f a9                	pop    %gs
801063ab:	0f a1                	pop    %fs
801063ad:	07                   	pop    %es
801063ae:	1f                   	pop    %ds
801063af:	83 c4 08             	add    $0x8,%esp
801063b2:	cf                   	iret   
	...

801063b4 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801063ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801063bd:	48                   	dec    %eax
801063be:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063c2:	8b 45 08             	mov    0x8(%ebp),%eax
801063c5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063c9:	8b 45 08             	mov    0x8(%ebp),%eax
801063cc:	c1 e8 10             	shr    $0x10,%eax
801063cf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801063d3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063d6:	0f 01 18             	lidtl  (%eax)
}
801063d9:	c9                   	leave  
801063da:	c3                   	ret    

801063db <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801063db:	55                   	push   %ebp
801063dc:	89 e5                	mov    %esp,%ebp
801063de:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063e1:	0f 20 d0             	mov    %cr2,%eax
801063e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801063e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063ea:	c9                   	leave  
801063eb:	c3                   	ret    

801063ec <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801063ec:	55                   	push   %ebp
801063ed:	89 e5                	mov    %esp,%ebp
801063ef:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801063f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063f9:	e9 b8 00 00 00       	jmp    801064b6 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106401:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
80106408:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640b:	66 89 04 d5 20 5d 11 	mov    %ax,-0x7feea2e0(,%edx,8)
80106412:	80 
80106413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106416:	66 c7 04 c5 22 5d 11 	movw   $0x8,-0x7feea2de(,%eax,8)
8010641d:	80 08 00 
80106420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106423:	8a 14 c5 24 5d 11 80 	mov    -0x7feea2dc(,%eax,8),%dl
8010642a:	83 e2 e0             	and    $0xffffffe0,%edx
8010642d:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
80106434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106437:	8a 14 c5 24 5d 11 80 	mov    -0x7feea2dc(,%eax,8),%dl
8010643e:	83 e2 1f             	and    $0x1f,%edx
80106441:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
80106448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644b:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
80106452:	83 e2 f0             	and    $0xfffffff0,%edx
80106455:	83 ca 0e             	or     $0xe,%edx
80106458:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010645f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106462:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
80106469:	83 e2 ef             	and    $0xffffffef,%edx
8010646c:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106476:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
8010647d:	83 e2 9f             	and    $0xffffff9f,%edx
80106480:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648a:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
80106491:	83 ca 80             	or     $0xffffff80,%edx
80106494:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010649b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010649e:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
801064a5:	c1 e8 10             	shr    $0x10,%eax
801064a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064ab:	66 89 04 d5 26 5d 11 	mov    %ax,-0x7feea2da(,%edx,8)
801064b2:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801064b3:	ff 45 f4             	incl   -0xc(%ebp)
801064b6:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801064bd:	0f 8e 3b ff ff ff    	jle    801063fe <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064c3:	a1 78 b1 10 80       	mov    0x8010b178,%eax
801064c8:	66 a3 20 5f 11 80    	mov    %ax,0x80115f20
801064ce:	66 c7 05 22 5f 11 80 	movw   $0x8,0x80115f22
801064d5:	08 00 
801064d7:	a0 24 5f 11 80       	mov    0x80115f24,%al
801064dc:	83 e0 e0             	and    $0xffffffe0,%eax
801064df:	a2 24 5f 11 80       	mov    %al,0x80115f24
801064e4:	a0 24 5f 11 80       	mov    0x80115f24,%al
801064e9:	83 e0 1f             	and    $0x1f,%eax
801064ec:	a2 24 5f 11 80       	mov    %al,0x80115f24
801064f1:	a0 25 5f 11 80       	mov    0x80115f25,%al
801064f6:	83 c8 0f             	or     $0xf,%eax
801064f9:	a2 25 5f 11 80       	mov    %al,0x80115f25
801064fe:	a0 25 5f 11 80       	mov    0x80115f25,%al
80106503:	83 e0 ef             	and    $0xffffffef,%eax
80106506:	a2 25 5f 11 80       	mov    %al,0x80115f25
8010650b:	a0 25 5f 11 80       	mov    0x80115f25,%al
80106510:	83 c8 60             	or     $0x60,%eax
80106513:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106518:	a0 25 5f 11 80       	mov    0x80115f25,%al
8010651d:	83 c8 80             	or     $0xffffff80,%eax
80106520:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106525:	a1 78 b1 10 80       	mov    0x8010b178,%eax
8010652a:	c1 e8 10             	shr    $0x10,%eax
8010652d:	66 a3 26 5f 11 80    	mov    %ax,0x80115f26

  initlock(&tickslock, "time");
80106533:	c7 44 24 04 94 86 10 	movl   $0x80108694,0x4(%esp)
8010653a:	80 
8010653b:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106542:	e8 63 e8 ff ff       	call   80104daa <initlock>
}
80106547:	c9                   	leave  
80106548:	c3                   	ret    

80106549 <idtinit>:

void
idtinit(void)
{
80106549:	55                   	push   %ebp
8010654a:	89 e5                	mov    %esp,%ebp
8010654c:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010654f:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106556:	00 
80106557:	c7 04 24 20 5d 11 80 	movl   $0x80115d20,(%esp)
8010655e:	e8 51 fe ff ff       	call   801063b4 <lidt>
}
80106563:	c9                   	leave  
80106564:	c3                   	ret    

80106565 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106565:	55                   	push   %ebp
80106566:	89 e5                	mov    %esp,%ebp
80106568:	57                   	push   %edi
80106569:	56                   	push   %esi
8010656a:	53                   	push   %ebx
8010656b:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010656e:	8b 45 08             	mov    0x8(%ebp),%eax
80106571:	8b 40 30             	mov    0x30(%eax),%eax
80106574:	83 f8 40             	cmp    $0x40,%eax
80106577:	75 3c                	jne    801065b5 <trap+0x50>
    if(myproc()->killed)
80106579:	e8 3d dc ff ff       	call   801041bb <myproc>
8010657e:	8b 40 24             	mov    0x24(%eax),%eax
80106581:	85 c0                	test   %eax,%eax
80106583:	74 05                	je     8010658a <trap+0x25>
      exit();
80106585:	e8 93 e0 ff ff       	call   8010461d <exit>
    myproc()->tf = tf;
8010658a:	e8 2c dc ff ff       	call   801041bb <myproc>
8010658f:	8b 55 08             	mov    0x8(%ebp),%edx
80106592:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106595:	e8 95 ee ff ff       	call   8010542f <syscall>
    if(myproc()->killed)
8010659a:	e8 1c dc ff ff       	call   801041bb <myproc>
8010659f:	8b 40 24             	mov    0x24(%eax),%eax
801065a2:	85 c0                	test   %eax,%eax
801065a4:	74 0a                	je     801065b0 <trap+0x4b>
      exit();
801065a6:	e8 72 e0 ff ff       	call   8010461d <exit>
    return;
801065ab:	e9 13 02 00 00       	jmp    801067c3 <trap+0x25e>
801065b0:	e9 0e 02 00 00       	jmp    801067c3 <trap+0x25e>
  }

  switch(tf->trapno){
801065b5:	8b 45 08             	mov    0x8(%ebp),%eax
801065b8:	8b 40 30             	mov    0x30(%eax),%eax
801065bb:	83 e8 20             	sub    $0x20,%eax
801065be:	83 f8 1f             	cmp    $0x1f,%eax
801065c1:	0f 87 ae 00 00 00    	ja     80106675 <trap+0x110>
801065c7:	8b 04 85 3c 87 10 80 	mov    -0x7fef78c4(,%eax,4),%eax
801065ce:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801065d0:	e8 1d db ff ff       	call   801040f2 <cpuid>
801065d5:	85 c0                	test   %eax,%eax
801065d7:	75 2f                	jne    80106608 <trap+0xa3>
      acquire(&tickslock);
801065d9:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801065e0:	e8 e6 e7 ff ff       	call   80104dcb <acquire>
      ticks++;
801065e5:	a1 20 65 11 80       	mov    0x80116520,%eax
801065ea:	40                   	inc    %eax
801065eb:	a3 20 65 11 80       	mov    %eax,0x80116520
      wakeup(&ticks);
801065f0:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
801065f7:	e8 d4 e4 ff ff       	call   80104ad0 <wakeup>
      release(&tickslock);
801065fc:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106603:	e8 2d e8 ff ff       	call   80104e35 <release>
    }
    lapiceoi();
80106608:	e8 8e c9 ff ff       	call   80102f9b <lapiceoi>
    break;
8010660d:	e9 35 01 00 00       	jmp    80106747 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106612:	e8 03 c2 ff ff       	call   8010281a <ideintr>
    lapiceoi();
80106617:	e8 7f c9 ff ff       	call   80102f9b <lapiceoi>
    break;
8010661c:	e9 26 01 00 00       	jmp    80106747 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106621:	e8 8c c7 ff ff       	call   80102db2 <kbdintr>
    lapiceoi();
80106626:	e8 70 c9 ff ff       	call   80102f9b <lapiceoi>
    break;
8010662b:	e9 17 01 00 00       	jmp    80106747 <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106630:	e8 70 03 00 00       	call   801069a5 <uartintr>
    lapiceoi();
80106635:	e8 61 c9 ff ff       	call   80102f9b <lapiceoi>
    break;
8010663a:	e9 08 01 00 00       	jmp    80106747 <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010663f:	8b 45 08             	mov    0x8(%ebp),%eax
80106642:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106645:	8b 45 08             	mov    0x8(%ebp),%eax
80106648:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010664b:	0f b7 d8             	movzwl %ax,%ebx
8010664e:	e8 9f da ff ff       	call   801040f2 <cpuid>
80106653:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106657:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010665b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010665f:	c7 04 24 9c 86 10 80 	movl   $0x8010869c,(%esp)
80106666:	e8 56 9d ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
8010666b:	e8 2b c9 ff ff       	call   80102f9b <lapiceoi>
    break;
80106670:	e9 d2 00 00 00       	jmp    80106747 <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106675:	e8 41 db ff ff       	call   801041bb <myproc>
8010667a:	85 c0                	test   %eax,%eax
8010667c:	74 10                	je     8010668e <trap+0x129>
8010667e:	8b 45 08             	mov    0x8(%ebp),%eax
80106681:	8b 40 3c             	mov    0x3c(%eax),%eax
80106684:	0f b7 c0             	movzwl %ax,%eax
80106687:	83 e0 03             	and    $0x3,%eax
8010668a:	85 c0                	test   %eax,%eax
8010668c:	75 40                	jne    801066ce <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010668e:	e8 48 fd ff ff       	call   801063db <rcr2>
80106693:	89 c3                	mov    %eax,%ebx
80106695:	8b 45 08             	mov    0x8(%ebp),%eax
80106698:	8b 70 38             	mov    0x38(%eax),%esi
8010669b:	e8 52 da ff ff       	call   801040f2 <cpuid>
801066a0:	8b 55 08             	mov    0x8(%ebp),%edx
801066a3:	8b 52 30             	mov    0x30(%edx),%edx
801066a6:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801066aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
801066ae:	89 44 24 08          	mov    %eax,0x8(%esp)
801066b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801066b6:	c7 04 24 c0 86 10 80 	movl   $0x801086c0,(%esp)
801066bd:	e8 ff 9c ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801066c2:	c7 04 24 f2 86 10 80 	movl   $0x801086f2,(%esp)
801066c9:	e8 86 9e ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ce:	e8 08 fd ff ff       	call   801063db <rcr2>
801066d3:	89 c6                	mov    %eax,%esi
801066d5:	8b 45 08             	mov    0x8(%ebp),%eax
801066d8:	8b 40 38             	mov    0x38(%eax),%eax
801066db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066de:	e8 0f da ff ff       	call   801040f2 <cpuid>
801066e3:	89 c3                	mov    %eax,%ebx
801066e5:	8b 45 08             	mov    0x8(%ebp),%eax
801066e8:	8b 78 34             	mov    0x34(%eax),%edi
801066eb:	89 7d e0             	mov    %edi,-0x20(%ebp)
801066ee:	8b 45 08             	mov    0x8(%ebp),%eax
801066f1:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066f4:	e8 c2 da ff ff       	call   801041bb <myproc>
801066f9:	8d 50 6c             	lea    0x6c(%eax),%edx
801066fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066ff:	e8 b7 da ff ff       	call   801041bb <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106704:	8b 40 10             	mov    0x10(%eax),%eax
80106707:	89 74 24 1c          	mov    %esi,0x1c(%esp)
8010670b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010670e:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106712:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106716:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106719:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010671d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106721:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106724:	89 54 24 08          	mov    %edx,0x8(%esp)
80106728:	89 44 24 04          	mov    %eax,0x4(%esp)
8010672c:	c7 04 24 f8 86 10 80 	movl   $0x801086f8,(%esp)
80106733:	e8 89 9c ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106738:	e8 7e da ff ff       	call   801041bb <myproc>
8010673d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106744:	eb 01                	jmp    80106747 <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106746:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106747:	e8 6f da ff ff       	call   801041bb <myproc>
8010674c:	85 c0                	test   %eax,%eax
8010674e:	74 22                	je     80106772 <trap+0x20d>
80106750:	e8 66 da ff ff       	call   801041bb <myproc>
80106755:	8b 40 24             	mov    0x24(%eax),%eax
80106758:	85 c0                	test   %eax,%eax
8010675a:	74 16                	je     80106772 <trap+0x20d>
8010675c:	8b 45 08             	mov    0x8(%ebp),%eax
8010675f:	8b 40 3c             	mov    0x3c(%eax),%eax
80106762:	0f b7 c0             	movzwl %ax,%eax
80106765:	83 e0 03             	and    $0x3,%eax
80106768:	83 f8 03             	cmp    $0x3,%eax
8010676b:	75 05                	jne    80106772 <trap+0x20d>
    exit();
8010676d:	e8 ab de ff ff       	call   8010461d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106772:	e8 44 da ff ff       	call   801041bb <myproc>
80106777:	85 c0                	test   %eax,%eax
80106779:	74 1d                	je     80106798 <trap+0x233>
8010677b:	e8 3b da ff ff       	call   801041bb <myproc>
80106780:	8b 40 0c             	mov    0xc(%eax),%eax
80106783:	83 f8 04             	cmp    $0x4,%eax
80106786:	75 10                	jne    80106798 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106788:	8b 45 08             	mov    0x8(%ebp),%eax
8010678b:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010678e:	83 f8 20             	cmp    $0x20,%eax
80106791:	75 05                	jne    80106798 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80106793:	e8 f4 e1 ff ff       	call   8010498c <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106798:	e8 1e da ff ff       	call   801041bb <myproc>
8010679d:	85 c0                	test   %eax,%eax
8010679f:	74 22                	je     801067c3 <trap+0x25e>
801067a1:	e8 15 da ff ff       	call   801041bb <myproc>
801067a6:	8b 40 24             	mov    0x24(%eax),%eax
801067a9:	85 c0                	test   %eax,%eax
801067ab:	74 16                	je     801067c3 <trap+0x25e>
801067ad:	8b 45 08             	mov    0x8(%ebp),%eax
801067b0:	8b 40 3c             	mov    0x3c(%eax),%eax
801067b3:	0f b7 c0             	movzwl %ax,%eax
801067b6:	83 e0 03             	and    $0x3,%eax
801067b9:	83 f8 03             	cmp    $0x3,%eax
801067bc:	75 05                	jne    801067c3 <trap+0x25e>
    exit();
801067be:	e8 5a de ff ff       	call   8010461d <exit>
}
801067c3:	83 c4 3c             	add    $0x3c,%esp
801067c6:	5b                   	pop    %ebx
801067c7:	5e                   	pop    %esi
801067c8:	5f                   	pop    %edi
801067c9:	5d                   	pop    %ebp
801067ca:	c3                   	ret    
	...

801067cc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801067cc:	55                   	push   %ebp
801067cd:	89 e5                	mov    %esp,%ebp
801067cf:	83 ec 14             	sub    $0x14,%esp
801067d2:	8b 45 08             	mov    0x8(%ebp),%eax
801067d5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067dc:	89 c2                	mov    %eax,%edx
801067de:	ec                   	in     (%dx),%al
801067df:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801067e2:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801067e5:	c9                   	leave  
801067e6:	c3                   	ret    

801067e7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067e7:	55                   	push   %ebp
801067e8:	89 e5                	mov    %esp,%ebp
801067ea:	83 ec 08             	sub    $0x8,%esp
801067ed:	8b 45 08             	mov    0x8(%ebp),%eax
801067f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801067f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801067f7:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067fa:	8a 45 f8             	mov    -0x8(%ebp),%al
801067fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106800:	ee                   	out    %al,(%dx)
}
80106801:	c9                   	leave  
80106802:	c3                   	ret    

80106803 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106803:	55                   	push   %ebp
80106804:	89 e5                	mov    %esp,%ebp
80106806:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106809:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106810:	00 
80106811:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106818:	e8 ca ff ff ff       	call   801067e7 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010681d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106824:	00 
80106825:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010682c:	e8 b6 ff ff ff       	call   801067e7 <outb>
  outb(COM1+0, 115200/9600);
80106831:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106838:	00 
80106839:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106840:	e8 a2 ff ff ff       	call   801067e7 <outb>
  outb(COM1+1, 0);
80106845:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010684c:	00 
8010684d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106854:	e8 8e ff ff ff       	call   801067e7 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106859:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106860:	00 
80106861:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106868:	e8 7a ff ff ff       	call   801067e7 <outb>
  outb(COM1+4, 0);
8010686d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106874:	00 
80106875:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010687c:	e8 66 ff ff ff       	call   801067e7 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106881:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106888:	00 
80106889:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106890:	e8 52 ff ff ff       	call   801067e7 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106895:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010689c:	e8 2b ff ff ff       	call   801067cc <inb>
801068a1:	3c ff                	cmp    $0xff,%al
801068a3:	75 02                	jne    801068a7 <uartinit+0xa4>
    return;
801068a5:	eb 5b                	jmp    80106902 <uartinit+0xff>
  uart = 1;
801068a7:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
801068ae:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801068b1:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801068b8:	e8 0f ff ff ff       	call   801067cc <inb>
  inb(COM1+0);
801068bd:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068c4:	e8 03 ff ff ff       	call   801067cc <inb>
  ioapicenable(IRQ_COM1, 0);
801068c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068d0:	00 
801068d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068d8:	e8 b2 c1 ff ff       	call   80102a8f <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068dd:	c7 45 f4 bc 87 10 80 	movl   $0x801087bc,-0xc(%ebp)
801068e4:	eb 13                	jmp    801068f9 <uartinit+0xf6>
    uartputc(*p);
801068e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e9:	8a 00                	mov    (%eax),%al
801068eb:	0f be c0             	movsbl %al,%eax
801068ee:	89 04 24             	mov    %eax,(%esp)
801068f1:	e8 0e 00 00 00       	call   80106904 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068f6:	ff 45 f4             	incl   -0xc(%ebp)
801068f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068fc:	8a 00                	mov    (%eax),%al
801068fe:	84 c0                	test   %al,%al
80106900:	75 e4                	jne    801068e6 <uartinit+0xe3>
    uartputc(*p);
}
80106902:	c9                   	leave  
80106903:	c3                   	ret    

80106904 <uartputc>:

void
uartputc(int c)
{
80106904:	55                   	push   %ebp
80106905:	89 e5                	mov    %esp,%ebp
80106907:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010690a:	a1 24 b6 10 80       	mov    0x8010b624,%eax
8010690f:	85 c0                	test   %eax,%eax
80106911:	75 02                	jne    80106915 <uartputc+0x11>
    return;
80106913:	eb 4a                	jmp    8010695f <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010691c:	eb 0f                	jmp    8010692d <uartputc+0x29>
    microdelay(10);
8010691e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106925:	e8 96 c6 ff ff       	call   80102fc0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010692a:	ff 45 f4             	incl   -0xc(%ebp)
8010692d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106931:	7f 16                	jg     80106949 <uartputc+0x45>
80106933:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010693a:	e8 8d fe ff ff       	call   801067cc <inb>
8010693f:	0f b6 c0             	movzbl %al,%eax
80106942:	83 e0 20             	and    $0x20,%eax
80106945:	85 c0                	test   %eax,%eax
80106947:	74 d5                	je     8010691e <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106949:	8b 45 08             	mov    0x8(%ebp),%eax
8010694c:	0f b6 c0             	movzbl %al,%eax
8010694f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106953:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010695a:	e8 88 fe ff ff       	call   801067e7 <outb>
}
8010695f:	c9                   	leave  
80106960:	c3                   	ret    

80106961 <uartgetc>:

static int
uartgetc(void)
{
80106961:	55                   	push   %ebp
80106962:	89 e5                	mov    %esp,%ebp
80106964:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106967:	a1 24 b6 10 80       	mov    0x8010b624,%eax
8010696c:	85 c0                	test   %eax,%eax
8010696e:	75 07                	jne    80106977 <uartgetc+0x16>
    return -1;
80106970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106975:	eb 2c                	jmp    801069a3 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106977:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010697e:	e8 49 fe ff ff       	call   801067cc <inb>
80106983:	0f b6 c0             	movzbl %al,%eax
80106986:	83 e0 01             	and    $0x1,%eax
80106989:	85 c0                	test   %eax,%eax
8010698b:	75 07                	jne    80106994 <uartgetc+0x33>
    return -1;
8010698d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106992:	eb 0f                	jmp    801069a3 <uartgetc+0x42>
  return inb(COM1+0);
80106994:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010699b:	e8 2c fe ff ff       	call   801067cc <inb>
801069a0:	0f b6 c0             	movzbl %al,%eax
}
801069a3:	c9                   	leave  
801069a4:	c3                   	ret    

801069a5 <uartintr>:

void
uartintr(void)
{
801069a5:	55                   	push   %ebp
801069a6:	89 e5                	mov    %esp,%ebp
801069a8:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801069ab:	c7 04 24 61 69 10 80 	movl   $0x80106961,(%esp)
801069b2:	e8 0e 9e ff ff       	call   801007c5 <consoleintr>
}
801069b7:	c9                   	leave  
801069b8:	c3                   	ret    
801069b9:	00 00                	add    %al,(%eax)
	...

801069bc <vector0>:
801069bc:	6a 00                	push   $0x0
801069be:	6a 00                	push   $0x0
801069c0:	e9 cb f9 ff ff       	jmp    80106390 <alltraps>

801069c5 <vector1>:
801069c5:	6a 00                	push   $0x0
801069c7:	6a 01                	push   $0x1
801069c9:	e9 c2 f9 ff ff       	jmp    80106390 <alltraps>

801069ce <vector2>:
801069ce:	6a 00                	push   $0x0
801069d0:	6a 02                	push   $0x2
801069d2:	e9 b9 f9 ff ff       	jmp    80106390 <alltraps>

801069d7 <vector3>:
801069d7:	6a 00                	push   $0x0
801069d9:	6a 03                	push   $0x3
801069db:	e9 b0 f9 ff ff       	jmp    80106390 <alltraps>

801069e0 <vector4>:
801069e0:	6a 00                	push   $0x0
801069e2:	6a 04                	push   $0x4
801069e4:	e9 a7 f9 ff ff       	jmp    80106390 <alltraps>

801069e9 <vector5>:
801069e9:	6a 00                	push   $0x0
801069eb:	6a 05                	push   $0x5
801069ed:	e9 9e f9 ff ff       	jmp    80106390 <alltraps>

801069f2 <vector6>:
801069f2:	6a 00                	push   $0x0
801069f4:	6a 06                	push   $0x6
801069f6:	e9 95 f9 ff ff       	jmp    80106390 <alltraps>

801069fb <vector7>:
801069fb:	6a 00                	push   $0x0
801069fd:	6a 07                	push   $0x7
801069ff:	e9 8c f9 ff ff       	jmp    80106390 <alltraps>

80106a04 <vector8>:
80106a04:	6a 08                	push   $0x8
80106a06:	e9 85 f9 ff ff       	jmp    80106390 <alltraps>

80106a0b <vector9>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	6a 09                	push   $0x9
80106a0f:	e9 7c f9 ff ff       	jmp    80106390 <alltraps>

80106a14 <vector10>:
80106a14:	6a 0a                	push   $0xa
80106a16:	e9 75 f9 ff ff       	jmp    80106390 <alltraps>

80106a1b <vector11>:
80106a1b:	6a 0b                	push   $0xb
80106a1d:	e9 6e f9 ff ff       	jmp    80106390 <alltraps>

80106a22 <vector12>:
80106a22:	6a 0c                	push   $0xc
80106a24:	e9 67 f9 ff ff       	jmp    80106390 <alltraps>

80106a29 <vector13>:
80106a29:	6a 0d                	push   $0xd
80106a2b:	e9 60 f9 ff ff       	jmp    80106390 <alltraps>

80106a30 <vector14>:
80106a30:	6a 0e                	push   $0xe
80106a32:	e9 59 f9 ff ff       	jmp    80106390 <alltraps>

80106a37 <vector15>:
80106a37:	6a 00                	push   $0x0
80106a39:	6a 0f                	push   $0xf
80106a3b:	e9 50 f9 ff ff       	jmp    80106390 <alltraps>

80106a40 <vector16>:
80106a40:	6a 00                	push   $0x0
80106a42:	6a 10                	push   $0x10
80106a44:	e9 47 f9 ff ff       	jmp    80106390 <alltraps>

80106a49 <vector17>:
80106a49:	6a 11                	push   $0x11
80106a4b:	e9 40 f9 ff ff       	jmp    80106390 <alltraps>

80106a50 <vector18>:
80106a50:	6a 00                	push   $0x0
80106a52:	6a 12                	push   $0x12
80106a54:	e9 37 f9 ff ff       	jmp    80106390 <alltraps>

80106a59 <vector19>:
80106a59:	6a 00                	push   $0x0
80106a5b:	6a 13                	push   $0x13
80106a5d:	e9 2e f9 ff ff       	jmp    80106390 <alltraps>

80106a62 <vector20>:
80106a62:	6a 00                	push   $0x0
80106a64:	6a 14                	push   $0x14
80106a66:	e9 25 f9 ff ff       	jmp    80106390 <alltraps>

80106a6b <vector21>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	6a 15                	push   $0x15
80106a6f:	e9 1c f9 ff ff       	jmp    80106390 <alltraps>

80106a74 <vector22>:
80106a74:	6a 00                	push   $0x0
80106a76:	6a 16                	push   $0x16
80106a78:	e9 13 f9 ff ff       	jmp    80106390 <alltraps>

80106a7d <vector23>:
80106a7d:	6a 00                	push   $0x0
80106a7f:	6a 17                	push   $0x17
80106a81:	e9 0a f9 ff ff       	jmp    80106390 <alltraps>

80106a86 <vector24>:
80106a86:	6a 00                	push   $0x0
80106a88:	6a 18                	push   $0x18
80106a8a:	e9 01 f9 ff ff       	jmp    80106390 <alltraps>

80106a8f <vector25>:
80106a8f:	6a 00                	push   $0x0
80106a91:	6a 19                	push   $0x19
80106a93:	e9 f8 f8 ff ff       	jmp    80106390 <alltraps>

80106a98 <vector26>:
80106a98:	6a 00                	push   $0x0
80106a9a:	6a 1a                	push   $0x1a
80106a9c:	e9 ef f8 ff ff       	jmp    80106390 <alltraps>

80106aa1 <vector27>:
80106aa1:	6a 00                	push   $0x0
80106aa3:	6a 1b                	push   $0x1b
80106aa5:	e9 e6 f8 ff ff       	jmp    80106390 <alltraps>

80106aaa <vector28>:
80106aaa:	6a 00                	push   $0x0
80106aac:	6a 1c                	push   $0x1c
80106aae:	e9 dd f8 ff ff       	jmp    80106390 <alltraps>

80106ab3 <vector29>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	6a 1d                	push   $0x1d
80106ab7:	e9 d4 f8 ff ff       	jmp    80106390 <alltraps>

80106abc <vector30>:
80106abc:	6a 00                	push   $0x0
80106abe:	6a 1e                	push   $0x1e
80106ac0:	e9 cb f8 ff ff       	jmp    80106390 <alltraps>

80106ac5 <vector31>:
80106ac5:	6a 00                	push   $0x0
80106ac7:	6a 1f                	push   $0x1f
80106ac9:	e9 c2 f8 ff ff       	jmp    80106390 <alltraps>

80106ace <vector32>:
80106ace:	6a 00                	push   $0x0
80106ad0:	6a 20                	push   $0x20
80106ad2:	e9 b9 f8 ff ff       	jmp    80106390 <alltraps>

80106ad7 <vector33>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	6a 21                	push   $0x21
80106adb:	e9 b0 f8 ff ff       	jmp    80106390 <alltraps>

80106ae0 <vector34>:
80106ae0:	6a 00                	push   $0x0
80106ae2:	6a 22                	push   $0x22
80106ae4:	e9 a7 f8 ff ff       	jmp    80106390 <alltraps>

80106ae9 <vector35>:
80106ae9:	6a 00                	push   $0x0
80106aeb:	6a 23                	push   $0x23
80106aed:	e9 9e f8 ff ff       	jmp    80106390 <alltraps>

80106af2 <vector36>:
80106af2:	6a 00                	push   $0x0
80106af4:	6a 24                	push   $0x24
80106af6:	e9 95 f8 ff ff       	jmp    80106390 <alltraps>

80106afb <vector37>:
80106afb:	6a 00                	push   $0x0
80106afd:	6a 25                	push   $0x25
80106aff:	e9 8c f8 ff ff       	jmp    80106390 <alltraps>

80106b04 <vector38>:
80106b04:	6a 00                	push   $0x0
80106b06:	6a 26                	push   $0x26
80106b08:	e9 83 f8 ff ff       	jmp    80106390 <alltraps>

80106b0d <vector39>:
80106b0d:	6a 00                	push   $0x0
80106b0f:	6a 27                	push   $0x27
80106b11:	e9 7a f8 ff ff       	jmp    80106390 <alltraps>

80106b16 <vector40>:
80106b16:	6a 00                	push   $0x0
80106b18:	6a 28                	push   $0x28
80106b1a:	e9 71 f8 ff ff       	jmp    80106390 <alltraps>

80106b1f <vector41>:
80106b1f:	6a 00                	push   $0x0
80106b21:	6a 29                	push   $0x29
80106b23:	e9 68 f8 ff ff       	jmp    80106390 <alltraps>

80106b28 <vector42>:
80106b28:	6a 00                	push   $0x0
80106b2a:	6a 2a                	push   $0x2a
80106b2c:	e9 5f f8 ff ff       	jmp    80106390 <alltraps>

80106b31 <vector43>:
80106b31:	6a 00                	push   $0x0
80106b33:	6a 2b                	push   $0x2b
80106b35:	e9 56 f8 ff ff       	jmp    80106390 <alltraps>

80106b3a <vector44>:
80106b3a:	6a 00                	push   $0x0
80106b3c:	6a 2c                	push   $0x2c
80106b3e:	e9 4d f8 ff ff       	jmp    80106390 <alltraps>

80106b43 <vector45>:
80106b43:	6a 00                	push   $0x0
80106b45:	6a 2d                	push   $0x2d
80106b47:	e9 44 f8 ff ff       	jmp    80106390 <alltraps>

80106b4c <vector46>:
80106b4c:	6a 00                	push   $0x0
80106b4e:	6a 2e                	push   $0x2e
80106b50:	e9 3b f8 ff ff       	jmp    80106390 <alltraps>

80106b55 <vector47>:
80106b55:	6a 00                	push   $0x0
80106b57:	6a 2f                	push   $0x2f
80106b59:	e9 32 f8 ff ff       	jmp    80106390 <alltraps>

80106b5e <vector48>:
80106b5e:	6a 00                	push   $0x0
80106b60:	6a 30                	push   $0x30
80106b62:	e9 29 f8 ff ff       	jmp    80106390 <alltraps>

80106b67 <vector49>:
80106b67:	6a 00                	push   $0x0
80106b69:	6a 31                	push   $0x31
80106b6b:	e9 20 f8 ff ff       	jmp    80106390 <alltraps>

80106b70 <vector50>:
80106b70:	6a 00                	push   $0x0
80106b72:	6a 32                	push   $0x32
80106b74:	e9 17 f8 ff ff       	jmp    80106390 <alltraps>

80106b79 <vector51>:
80106b79:	6a 00                	push   $0x0
80106b7b:	6a 33                	push   $0x33
80106b7d:	e9 0e f8 ff ff       	jmp    80106390 <alltraps>

80106b82 <vector52>:
80106b82:	6a 00                	push   $0x0
80106b84:	6a 34                	push   $0x34
80106b86:	e9 05 f8 ff ff       	jmp    80106390 <alltraps>

80106b8b <vector53>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	6a 35                	push   $0x35
80106b8f:	e9 fc f7 ff ff       	jmp    80106390 <alltraps>

80106b94 <vector54>:
80106b94:	6a 00                	push   $0x0
80106b96:	6a 36                	push   $0x36
80106b98:	e9 f3 f7 ff ff       	jmp    80106390 <alltraps>

80106b9d <vector55>:
80106b9d:	6a 00                	push   $0x0
80106b9f:	6a 37                	push   $0x37
80106ba1:	e9 ea f7 ff ff       	jmp    80106390 <alltraps>

80106ba6 <vector56>:
80106ba6:	6a 00                	push   $0x0
80106ba8:	6a 38                	push   $0x38
80106baa:	e9 e1 f7 ff ff       	jmp    80106390 <alltraps>

80106baf <vector57>:
80106baf:	6a 00                	push   $0x0
80106bb1:	6a 39                	push   $0x39
80106bb3:	e9 d8 f7 ff ff       	jmp    80106390 <alltraps>

80106bb8 <vector58>:
80106bb8:	6a 00                	push   $0x0
80106bba:	6a 3a                	push   $0x3a
80106bbc:	e9 cf f7 ff ff       	jmp    80106390 <alltraps>

80106bc1 <vector59>:
80106bc1:	6a 00                	push   $0x0
80106bc3:	6a 3b                	push   $0x3b
80106bc5:	e9 c6 f7 ff ff       	jmp    80106390 <alltraps>

80106bca <vector60>:
80106bca:	6a 00                	push   $0x0
80106bcc:	6a 3c                	push   $0x3c
80106bce:	e9 bd f7 ff ff       	jmp    80106390 <alltraps>

80106bd3 <vector61>:
80106bd3:	6a 00                	push   $0x0
80106bd5:	6a 3d                	push   $0x3d
80106bd7:	e9 b4 f7 ff ff       	jmp    80106390 <alltraps>

80106bdc <vector62>:
80106bdc:	6a 00                	push   $0x0
80106bde:	6a 3e                	push   $0x3e
80106be0:	e9 ab f7 ff ff       	jmp    80106390 <alltraps>

80106be5 <vector63>:
80106be5:	6a 00                	push   $0x0
80106be7:	6a 3f                	push   $0x3f
80106be9:	e9 a2 f7 ff ff       	jmp    80106390 <alltraps>

80106bee <vector64>:
80106bee:	6a 00                	push   $0x0
80106bf0:	6a 40                	push   $0x40
80106bf2:	e9 99 f7 ff ff       	jmp    80106390 <alltraps>

80106bf7 <vector65>:
80106bf7:	6a 00                	push   $0x0
80106bf9:	6a 41                	push   $0x41
80106bfb:	e9 90 f7 ff ff       	jmp    80106390 <alltraps>

80106c00 <vector66>:
80106c00:	6a 00                	push   $0x0
80106c02:	6a 42                	push   $0x42
80106c04:	e9 87 f7 ff ff       	jmp    80106390 <alltraps>

80106c09 <vector67>:
80106c09:	6a 00                	push   $0x0
80106c0b:	6a 43                	push   $0x43
80106c0d:	e9 7e f7 ff ff       	jmp    80106390 <alltraps>

80106c12 <vector68>:
80106c12:	6a 00                	push   $0x0
80106c14:	6a 44                	push   $0x44
80106c16:	e9 75 f7 ff ff       	jmp    80106390 <alltraps>

80106c1b <vector69>:
80106c1b:	6a 00                	push   $0x0
80106c1d:	6a 45                	push   $0x45
80106c1f:	e9 6c f7 ff ff       	jmp    80106390 <alltraps>

80106c24 <vector70>:
80106c24:	6a 00                	push   $0x0
80106c26:	6a 46                	push   $0x46
80106c28:	e9 63 f7 ff ff       	jmp    80106390 <alltraps>

80106c2d <vector71>:
80106c2d:	6a 00                	push   $0x0
80106c2f:	6a 47                	push   $0x47
80106c31:	e9 5a f7 ff ff       	jmp    80106390 <alltraps>

80106c36 <vector72>:
80106c36:	6a 00                	push   $0x0
80106c38:	6a 48                	push   $0x48
80106c3a:	e9 51 f7 ff ff       	jmp    80106390 <alltraps>

80106c3f <vector73>:
80106c3f:	6a 00                	push   $0x0
80106c41:	6a 49                	push   $0x49
80106c43:	e9 48 f7 ff ff       	jmp    80106390 <alltraps>

80106c48 <vector74>:
80106c48:	6a 00                	push   $0x0
80106c4a:	6a 4a                	push   $0x4a
80106c4c:	e9 3f f7 ff ff       	jmp    80106390 <alltraps>

80106c51 <vector75>:
80106c51:	6a 00                	push   $0x0
80106c53:	6a 4b                	push   $0x4b
80106c55:	e9 36 f7 ff ff       	jmp    80106390 <alltraps>

80106c5a <vector76>:
80106c5a:	6a 00                	push   $0x0
80106c5c:	6a 4c                	push   $0x4c
80106c5e:	e9 2d f7 ff ff       	jmp    80106390 <alltraps>

80106c63 <vector77>:
80106c63:	6a 00                	push   $0x0
80106c65:	6a 4d                	push   $0x4d
80106c67:	e9 24 f7 ff ff       	jmp    80106390 <alltraps>

80106c6c <vector78>:
80106c6c:	6a 00                	push   $0x0
80106c6e:	6a 4e                	push   $0x4e
80106c70:	e9 1b f7 ff ff       	jmp    80106390 <alltraps>

80106c75 <vector79>:
80106c75:	6a 00                	push   $0x0
80106c77:	6a 4f                	push   $0x4f
80106c79:	e9 12 f7 ff ff       	jmp    80106390 <alltraps>

80106c7e <vector80>:
80106c7e:	6a 00                	push   $0x0
80106c80:	6a 50                	push   $0x50
80106c82:	e9 09 f7 ff ff       	jmp    80106390 <alltraps>

80106c87 <vector81>:
80106c87:	6a 00                	push   $0x0
80106c89:	6a 51                	push   $0x51
80106c8b:	e9 00 f7 ff ff       	jmp    80106390 <alltraps>

80106c90 <vector82>:
80106c90:	6a 00                	push   $0x0
80106c92:	6a 52                	push   $0x52
80106c94:	e9 f7 f6 ff ff       	jmp    80106390 <alltraps>

80106c99 <vector83>:
80106c99:	6a 00                	push   $0x0
80106c9b:	6a 53                	push   $0x53
80106c9d:	e9 ee f6 ff ff       	jmp    80106390 <alltraps>

80106ca2 <vector84>:
80106ca2:	6a 00                	push   $0x0
80106ca4:	6a 54                	push   $0x54
80106ca6:	e9 e5 f6 ff ff       	jmp    80106390 <alltraps>

80106cab <vector85>:
80106cab:	6a 00                	push   $0x0
80106cad:	6a 55                	push   $0x55
80106caf:	e9 dc f6 ff ff       	jmp    80106390 <alltraps>

80106cb4 <vector86>:
80106cb4:	6a 00                	push   $0x0
80106cb6:	6a 56                	push   $0x56
80106cb8:	e9 d3 f6 ff ff       	jmp    80106390 <alltraps>

80106cbd <vector87>:
80106cbd:	6a 00                	push   $0x0
80106cbf:	6a 57                	push   $0x57
80106cc1:	e9 ca f6 ff ff       	jmp    80106390 <alltraps>

80106cc6 <vector88>:
80106cc6:	6a 00                	push   $0x0
80106cc8:	6a 58                	push   $0x58
80106cca:	e9 c1 f6 ff ff       	jmp    80106390 <alltraps>

80106ccf <vector89>:
80106ccf:	6a 00                	push   $0x0
80106cd1:	6a 59                	push   $0x59
80106cd3:	e9 b8 f6 ff ff       	jmp    80106390 <alltraps>

80106cd8 <vector90>:
80106cd8:	6a 00                	push   $0x0
80106cda:	6a 5a                	push   $0x5a
80106cdc:	e9 af f6 ff ff       	jmp    80106390 <alltraps>

80106ce1 <vector91>:
80106ce1:	6a 00                	push   $0x0
80106ce3:	6a 5b                	push   $0x5b
80106ce5:	e9 a6 f6 ff ff       	jmp    80106390 <alltraps>

80106cea <vector92>:
80106cea:	6a 00                	push   $0x0
80106cec:	6a 5c                	push   $0x5c
80106cee:	e9 9d f6 ff ff       	jmp    80106390 <alltraps>

80106cf3 <vector93>:
80106cf3:	6a 00                	push   $0x0
80106cf5:	6a 5d                	push   $0x5d
80106cf7:	e9 94 f6 ff ff       	jmp    80106390 <alltraps>

80106cfc <vector94>:
80106cfc:	6a 00                	push   $0x0
80106cfe:	6a 5e                	push   $0x5e
80106d00:	e9 8b f6 ff ff       	jmp    80106390 <alltraps>

80106d05 <vector95>:
80106d05:	6a 00                	push   $0x0
80106d07:	6a 5f                	push   $0x5f
80106d09:	e9 82 f6 ff ff       	jmp    80106390 <alltraps>

80106d0e <vector96>:
80106d0e:	6a 00                	push   $0x0
80106d10:	6a 60                	push   $0x60
80106d12:	e9 79 f6 ff ff       	jmp    80106390 <alltraps>

80106d17 <vector97>:
80106d17:	6a 00                	push   $0x0
80106d19:	6a 61                	push   $0x61
80106d1b:	e9 70 f6 ff ff       	jmp    80106390 <alltraps>

80106d20 <vector98>:
80106d20:	6a 00                	push   $0x0
80106d22:	6a 62                	push   $0x62
80106d24:	e9 67 f6 ff ff       	jmp    80106390 <alltraps>

80106d29 <vector99>:
80106d29:	6a 00                	push   $0x0
80106d2b:	6a 63                	push   $0x63
80106d2d:	e9 5e f6 ff ff       	jmp    80106390 <alltraps>

80106d32 <vector100>:
80106d32:	6a 00                	push   $0x0
80106d34:	6a 64                	push   $0x64
80106d36:	e9 55 f6 ff ff       	jmp    80106390 <alltraps>

80106d3b <vector101>:
80106d3b:	6a 00                	push   $0x0
80106d3d:	6a 65                	push   $0x65
80106d3f:	e9 4c f6 ff ff       	jmp    80106390 <alltraps>

80106d44 <vector102>:
80106d44:	6a 00                	push   $0x0
80106d46:	6a 66                	push   $0x66
80106d48:	e9 43 f6 ff ff       	jmp    80106390 <alltraps>

80106d4d <vector103>:
80106d4d:	6a 00                	push   $0x0
80106d4f:	6a 67                	push   $0x67
80106d51:	e9 3a f6 ff ff       	jmp    80106390 <alltraps>

80106d56 <vector104>:
80106d56:	6a 00                	push   $0x0
80106d58:	6a 68                	push   $0x68
80106d5a:	e9 31 f6 ff ff       	jmp    80106390 <alltraps>

80106d5f <vector105>:
80106d5f:	6a 00                	push   $0x0
80106d61:	6a 69                	push   $0x69
80106d63:	e9 28 f6 ff ff       	jmp    80106390 <alltraps>

80106d68 <vector106>:
80106d68:	6a 00                	push   $0x0
80106d6a:	6a 6a                	push   $0x6a
80106d6c:	e9 1f f6 ff ff       	jmp    80106390 <alltraps>

80106d71 <vector107>:
80106d71:	6a 00                	push   $0x0
80106d73:	6a 6b                	push   $0x6b
80106d75:	e9 16 f6 ff ff       	jmp    80106390 <alltraps>

80106d7a <vector108>:
80106d7a:	6a 00                	push   $0x0
80106d7c:	6a 6c                	push   $0x6c
80106d7e:	e9 0d f6 ff ff       	jmp    80106390 <alltraps>

80106d83 <vector109>:
80106d83:	6a 00                	push   $0x0
80106d85:	6a 6d                	push   $0x6d
80106d87:	e9 04 f6 ff ff       	jmp    80106390 <alltraps>

80106d8c <vector110>:
80106d8c:	6a 00                	push   $0x0
80106d8e:	6a 6e                	push   $0x6e
80106d90:	e9 fb f5 ff ff       	jmp    80106390 <alltraps>

80106d95 <vector111>:
80106d95:	6a 00                	push   $0x0
80106d97:	6a 6f                	push   $0x6f
80106d99:	e9 f2 f5 ff ff       	jmp    80106390 <alltraps>

80106d9e <vector112>:
80106d9e:	6a 00                	push   $0x0
80106da0:	6a 70                	push   $0x70
80106da2:	e9 e9 f5 ff ff       	jmp    80106390 <alltraps>

80106da7 <vector113>:
80106da7:	6a 00                	push   $0x0
80106da9:	6a 71                	push   $0x71
80106dab:	e9 e0 f5 ff ff       	jmp    80106390 <alltraps>

80106db0 <vector114>:
80106db0:	6a 00                	push   $0x0
80106db2:	6a 72                	push   $0x72
80106db4:	e9 d7 f5 ff ff       	jmp    80106390 <alltraps>

80106db9 <vector115>:
80106db9:	6a 00                	push   $0x0
80106dbb:	6a 73                	push   $0x73
80106dbd:	e9 ce f5 ff ff       	jmp    80106390 <alltraps>

80106dc2 <vector116>:
80106dc2:	6a 00                	push   $0x0
80106dc4:	6a 74                	push   $0x74
80106dc6:	e9 c5 f5 ff ff       	jmp    80106390 <alltraps>

80106dcb <vector117>:
80106dcb:	6a 00                	push   $0x0
80106dcd:	6a 75                	push   $0x75
80106dcf:	e9 bc f5 ff ff       	jmp    80106390 <alltraps>

80106dd4 <vector118>:
80106dd4:	6a 00                	push   $0x0
80106dd6:	6a 76                	push   $0x76
80106dd8:	e9 b3 f5 ff ff       	jmp    80106390 <alltraps>

80106ddd <vector119>:
80106ddd:	6a 00                	push   $0x0
80106ddf:	6a 77                	push   $0x77
80106de1:	e9 aa f5 ff ff       	jmp    80106390 <alltraps>

80106de6 <vector120>:
80106de6:	6a 00                	push   $0x0
80106de8:	6a 78                	push   $0x78
80106dea:	e9 a1 f5 ff ff       	jmp    80106390 <alltraps>

80106def <vector121>:
80106def:	6a 00                	push   $0x0
80106df1:	6a 79                	push   $0x79
80106df3:	e9 98 f5 ff ff       	jmp    80106390 <alltraps>

80106df8 <vector122>:
80106df8:	6a 00                	push   $0x0
80106dfa:	6a 7a                	push   $0x7a
80106dfc:	e9 8f f5 ff ff       	jmp    80106390 <alltraps>

80106e01 <vector123>:
80106e01:	6a 00                	push   $0x0
80106e03:	6a 7b                	push   $0x7b
80106e05:	e9 86 f5 ff ff       	jmp    80106390 <alltraps>

80106e0a <vector124>:
80106e0a:	6a 00                	push   $0x0
80106e0c:	6a 7c                	push   $0x7c
80106e0e:	e9 7d f5 ff ff       	jmp    80106390 <alltraps>

80106e13 <vector125>:
80106e13:	6a 00                	push   $0x0
80106e15:	6a 7d                	push   $0x7d
80106e17:	e9 74 f5 ff ff       	jmp    80106390 <alltraps>

80106e1c <vector126>:
80106e1c:	6a 00                	push   $0x0
80106e1e:	6a 7e                	push   $0x7e
80106e20:	e9 6b f5 ff ff       	jmp    80106390 <alltraps>

80106e25 <vector127>:
80106e25:	6a 00                	push   $0x0
80106e27:	6a 7f                	push   $0x7f
80106e29:	e9 62 f5 ff ff       	jmp    80106390 <alltraps>

80106e2e <vector128>:
80106e2e:	6a 00                	push   $0x0
80106e30:	68 80 00 00 00       	push   $0x80
80106e35:	e9 56 f5 ff ff       	jmp    80106390 <alltraps>

80106e3a <vector129>:
80106e3a:	6a 00                	push   $0x0
80106e3c:	68 81 00 00 00       	push   $0x81
80106e41:	e9 4a f5 ff ff       	jmp    80106390 <alltraps>

80106e46 <vector130>:
80106e46:	6a 00                	push   $0x0
80106e48:	68 82 00 00 00       	push   $0x82
80106e4d:	e9 3e f5 ff ff       	jmp    80106390 <alltraps>

80106e52 <vector131>:
80106e52:	6a 00                	push   $0x0
80106e54:	68 83 00 00 00       	push   $0x83
80106e59:	e9 32 f5 ff ff       	jmp    80106390 <alltraps>

80106e5e <vector132>:
80106e5e:	6a 00                	push   $0x0
80106e60:	68 84 00 00 00       	push   $0x84
80106e65:	e9 26 f5 ff ff       	jmp    80106390 <alltraps>

80106e6a <vector133>:
80106e6a:	6a 00                	push   $0x0
80106e6c:	68 85 00 00 00       	push   $0x85
80106e71:	e9 1a f5 ff ff       	jmp    80106390 <alltraps>

80106e76 <vector134>:
80106e76:	6a 00                	push   $0x0
80106e78:	68 86 00 00 00       	push   $0x86
80106e7d:	e9 0e f5 ff ff       	jmp    80106390 <alltraps>

80106e82 <vector135>:
80106e82:	6a 00                	push   $0x0
80106e84:	68 87 00 00 00       	push   $0x87
80106e89:	e9 02 f5 ff ff       	jmp    80106390 <alltraps>

80106e8e <vector136>:
80106e8e:	6a 00                	push   $0x0
80106e90:	68 88 00 00 00       	push   $0x88
80106e95:	e9 f6 f4 ff ff       	jmp    80106390 <alltraps>

80106e9a <vector137>:
80106e9a:	6a 00                	push   $0x0
80106e9c:	68 89 00 00 00       	push   $0x89
80106ea1:	e9 ea f4 ff ff       	jmp    80106390 <alltraps>

80106ea6 <vector138>:
80106ea6:	6a 00                	push   $0x0
80106ea8:	68 8a 00 00 00       	push   $0x8a
80106ead:	e9 de f4 ff ff       	jmp    80106390 <alltraps>

80106eb2 <vector139>:
80106eb2:	6a 00                	push   $0x0
80106eb4:	68 8b 00 00 00       	push   $0x8b
80106eb9:	e9 d2 f4 ff ff       	jmp    80106390 <alltraps>

80106ebe <vector140>:
80106ebe:	6a 00                	push   $0x0
80106ec0:	68 8c 00 00 00       	push   $0x8c
80106ec5:	e9 c6 f4 ff ff       	jmp    80106390 <alltraps>

80106eca <vector141>:
80106eca:	6a 00                	push   $0x0
80106ecc:	68 8d 00 00 00       	push   $0x8d
80106ed1:	e9 ba f4 ff ff       	jmp    80106390 <alltraps>

80106ed6 <vector142>:
80106ed6:	6a 00                	push   $0x0
80106ed8:	68 8e 00 00 00       	push   $0x8e
80106edd:	e9 ae f4 ff ff       	jmp    80106390 <alltraps>

80106ee2 <vector143>:
80106ee2:	6a 00                	push   $0x0
80106ee4:	68 8f 00 00 00       	push   $0x8f
80106ee9:	e9 a2 f4 ff ff       	jmp    80106390 <alltraps>

80106eee <vector144>:
80106eee:	6a 00                	push   $0x0
80106ef0:	68 90 00 00 00       	push   $0x90
80106ef5:	e9 96 f4 ff ff       	jmp    80106390 <alltraps>

80106efa <vector145>:
80106efa:	6a 00                	push   $0x0
80106efc:	68 91 00 00 00       	push   $0x91
80106f01:	e9 8a f4 ff ff       	jmp    80106390 <alltraps>

80106f06 <vector146>:
80106f06:	6a 00                	push   $0x0
80106f08:	68 92 00 00 00       	push   $0x92
80106f0d:	e9 7e f4 ff ff       	jmp    80106390 <alltraps>

80106f12 <vector147>:
80106f12:	6a 00                	push   $0x0
80106f14:	68 93 00 00 00       	push   $0x93
80106f19:	e9 72 f4 ff ff       	jmp    80106390 <alltraps>

80106f1e <vector148>:
80106f1e:	6a 00                	push   $0x0
80106f20:	68 94 00 00 00       	push   $0x94
80106f25:	e9 66 f4 ff ff       	jmp    80106390 <alltraps>

80106f2a <vector149>:
80106f2a:	6a 00                	push   $0x0
80106f2c:	68 95 00 00 00       	push   $0x95
80106f31:	e9 5a f4 ff ff       	jmp    80106390 <alltraps>

80106f36 <vector150>:
80106f36:	6a 00                	push   $0x0
80106f38:	68 96 00 00 00       	push   $0x96
80106f3d:	e9 4e f4 ff ff       	jmp    80106390 <alltraps>

80106f42 <vector151>:
80106f42:	6a 00                	push   $0x0
80106f44:	68 97 00 00 00       	push   $0x97
80106f49:	e9 42 f4 ff ff       	jmp    80106390 <alltraps>

80106f4e <vector152>:
80106f4e:	6a 00                	push   $0x0
80106f50:	68 98 00 00 00       	push   $0x98
80106f55:	e9 36 f4 ff ff       	jmp    80106390 <alltraps>

80106f5a <vector153>:
80106f5a:	6a 00                	push   $0x0
80106f5c:	68 99 00 00 00       	push   $0x99
80106f61:	e9 2a f4 ff ff       	jmp    80106390 <alltraps>

80106f66 <vector154>:
80106f66:	6a 00                	push   $0x0
80106f68:	68 9a 00 00 00       	push   $0x9a
80106f6d:	e9 1e f4 ff ff       	jmp    80106390 <alltraps>

80106f72 <vector155>:
80106f72:	6a 00                	push   $0x0
80106f74:	68 9b 00 00 00       	push   $0x9b
80106f79:	e9 12 f4 ff ff       	jmp    80106390 <alltraps>

80106f7e <vector156>:
80106f7e:	6a 00                	push   $0x0
80106f80:	68 9c 00 00 00       	push   $0x9c
80106f85:	e9 06 f4 ff ff       	jmp    80106390 <alltraps>

80106f8a <vector157>:
80106f8a:	6a 00                	push   $0x0
80106f8c:	68 9d 00 00 00       	push   $0x9d
80106f91:	e9 fa f3 ff ff       	jmp    80106390 <alltraps>

80106f96 <vector158>:
80106f96:	6a 00                	push   $0x0
80106f98:	68 9e 00 00 00       	push   $0x9e
80106f9d:	e9 ee f3 ff ff       	jmp    80106390 <alltraps>

80106fa2 <vector159>:
80106fa2:	6a 00                	push   $0x0
80106fa4:	68 9f 00 00 00       	push   $0x9f
80106fa9:	e9 e2 f3 ff ff       	jmp    80106390 <alltraps>

80106fae <vector160>:
80106fae:	6a 00                	push   $0x0
80106fb0:	68 a0 00 00 00       	push   $0xa0
80106fb5:	e9 d6 f3 ff ff       	jmp    80106390 <alltraps>

80106fba <vector161>:
80106fba:	6a 00                	push   $0x0
80106fbc:	68 a1 00 00 00       	push   $0xa1
80106fc1:	e9 ca f3 ff ff       	jmp    80106390 <alltraps>

80106fc6 <vector162>:
80106fc6:	6a 00                	push   $0x0
80106fc8:	68 a2 00 00 00       	push   $0xa2
80106fcd:	e9 be f3 ff ff       	jmp    80106390 <alltraps>

80106fd2 <vector163>:
80106fd2:	6a 00                	push   $0x0
80106fd4:	68 a3 00 00 00       	push   $0xa3
80106fd9:	e9 b2 f3 ff ff       	jmp    80106390 <alltraps>

80106fde <vector164>:
80106fde:	6a 00                	push   $0x0
80106fe0:	68 a4 00 00 00       	push   $0xa4
80106fe5:	e9 a6 f3 ff ff       	jmp    80106390 <alltraps>

80106fea <vector165>:
80106fea:	6a 00                	push   $0x0
80106fec:	68 a5 00 00 00       	push   $0xa5
80106ff1:	e9 9a f3 ff ff       	jmp    80106390 <alltraps>

80106ff6 <vector166>:
80106ff6:	6a 00                	push   $0x0
80106ff8:	68 a6 00 00 00       	push   $0xa6
80106ffd:	e9 8e f3 ff ff       	jmp    80106390 <alltraps>

80107002 <vector167>:
80107002:	6a 00                	push   $0x0
80107004:	68 a7 00 00 00       	push   $0xa7
80107009:	e9 82 f3 ff ff       	jmp    80106390 <alltraps>

8010700e <vector168>:
8010700e:	6a 00                	push   $0x0
80107010:	68 a8 00 00 00       	push   $0xa8
80107015:	e9 76 f3 ff ff       	jmp    80106390 <alltraps>

8010701a <vector169>:
8010701a:	6a 00                	push   $0x0
8010701c:	68 a9 00 00 00       	push   $0xa9
80107021:	e9 6a f3 ff ff       	jmp    80106390 <alltraps>

80107026 <vector170>:
80107026:	6a 00                	push   $0x0
80107028:	68 aa 00 00 00       	push   $0xaa
8010702d:	e9 5e f3 ff ff       	jmp    80106390 <alltraps>

80107032 <vector171>:
80107032:	6a 00                	push   $0x0
80107034:	68 ab 00 00 00       	push   $0xab
80107039:	e9 52 f3 ff ff       	jmp    80106390 <alltraps>

8010703e <vector172>:
8010703e:	6a 00                	push   $0x0
80107040:	68 ac 00 00 00       	push   $0xac
80107045:	e9 46 f3 ff ff       	jmp    80106390 <alltraps>

8010704a <vector173>:
8010704a:	6a 00                	push   $0x0
8010704c:	68 ad 00 00 00       	push   $0xad
80107051:	e9 3a f3 ff ff       	jmp    80106390 <alltraps>

80107056 <vector174>:
80107056:	6a 00                	push   $0x0
80107058:	68 ae 00 00 00       	push   $0xae
8010705d:	e9 2e f3 ff ff       	jmp    80106390 <alltraps>

80107062 <vector175>:
80107062:	6a 00                	push   $0x0
80107064:	68 af 00 00 00       	push   $0xaf
80107069:	e9 22 f3 ff ff       	jmp    80106390 <alltraps>

8010706e <vector176>:
8010706e:	6a 00                	push   $0x0
80107070:	68 b0 00 00 00       	push   $0xb0
80107075:	e9 16 f3 ff ff       	jmp    80106390 <alltraps>

8010707a <vector177>:
8010707a:	6a 00                	push   $0x0
8010707c:	68 b1 00 00 00       	push   $0xb1
80107081:	e9 0a f3 ff ff       	jmp    80106390 <alltraps>

80107086 <vector178>:
80107086:	6a 00                	push   $0x0
80107088:	68 b2 00 00 00       	push   $0xb2
8010708d:	e9 fe f2 ff ff       	jmp    80106390 <alltraps>

80107092 <vector179>:
80107092:	6a 00                	push   $0x0
80107094:	68 b3 00 00 00       	push   $0xb3
80107099:	e9 f2 f2 ff ff       	jmp    80106390 <alltraps>

8010709e <vector180>:
8010709e:	6a 00                	push   $0x0
801070a0:	68 b4 00 00 00       	push   $0xb4
801070a5:	e9 e6 f2 ff ff       	jmp    80106390 <alltraps>

801070aa <vector181>:
801070aa:	6a 00                	push   $0x0
801070ac:	68 b5 00 00 00       	push   $0xb5
801070b1:	e9 da f2 ff ff       	jmp    80106390 <alltraps>

801070b6 <vector182>:
801070b6:	6a 00                	push   $0x0
801070b8:	68 b6 00 00 00       	push   $0xb6
801070bd:	e9 ce f2 ff ff       	jmp    80106390 <alltraps>

801070c2 <vector183>:
801070c2:	6a 00                	push   $0x0
801070c4:	68 b7 00 00 00       	push   $0xb7
801070c9:	e9 c2 f2 ff ff       	jmp    80106390 <alltraps>

801070ce <vector184>:
801070ce:	6a 00                	push   $0x0
801070d0:	68 b8 00 00 00       	push   $0xb8
801070d5:	e9 b6 f2 ff ff       	jmp    80106390 <alltraps>

801070da <vector185>:
801070da:	6a 00                	push   $0x0
801070dc:	68 b9 00 00 00       	push   $0xb9
801070e1:	e9 aa f2 ff ff       	jmp    80106390 <alltraps>

801070e6 <vector186>:
801070e6:	6a 00                	push   $0x0
801070e8:	68 ba 00 00 00       	push   $0xba
801070ed:	e9 9e f2 ff ff       	jmp    80106390 <alltraps>

801070f2 <vector187>:
801070f2:	6a 00                	push   $0x0
801070f4:	68 bb 00 00 00       	push   $0xbb
801070f9:	e9 92 f2 ff ff       	jmp    80106390 <alltraps>

801070fe <vector188>:
801070fe:	6a 00                	push   $0x0
80107100:	68 bc 00 00 00       	push   $0xbc
80107105:	e9 86 f2 ff ff       	jmp    80106390 <alltraps>

8010710a <vector189>:
8010710a:	6a 00                	push   $0x0
8010710c:	68 bd 00 00 00       	push   $0xbd
80107111:	e9 7a f2 ff ff       	jmp    80106390 <alltraps>

80107116 <vector190>:
80107116:	6a 00                	push   $0x0
80107118:	68 be 00 00 00       	push   $0xbe
8010711d:	e9 6e f2 ff ff       	jmp    80106390 <alltraps>

80107122 <vector191>:
80107122:	6a 00                	push   $0x0
80107124:	68 bf 00 00 00       	push   $0xbf
80107129:	e9 62 f2 ff ff       	jmp    80106390 <alltraps>

8010712e <vector192>:
8010712e:	6a 00                	push   $0x0
80107130:	68 c0 00 00 00       	push   $0xc0
80107135:	e9 56 f2 ff ff       	jmp    80106390 <alltraps>

8010713a <vector193>:
8010713a:	6a 00                	push   $0x0
8010713c:	68 c1 00 00 00       	push   $0xc1
80107141:	e9 4a f2 ff ff       	jmp    80106390 <alltraps>

80107146 <vector194>:
80107146:	6a 00                	push   $0x0
80107148:	68 c2 00 00 00       	push   $0xc2
8010714d:	e9 3e f2 ff ff       	jmp    80106390 <alltraps>

80107152 <vector195>:
80107152:	6a 00                	push   $0x0
80107154:	68 c3 00 00 00       	push   $0xc3
80107159:	e9 32 f2 ff ff       	jmp    80106390 <alltraps>

8010715e <vector196>:
8010715e:	6a 00                	push   $0x0
80107160:	68 c4 00 00 00       	push   $0xc4
80107165:	e9 26 f2 ff ff       	jmp    80106390 <alltraps>

8010716a <vector197>:
8010716a:	6a 00                	push   $0x0
8010716c:	68 c5 00 00 00       	push   $0xc5
80107171:	e9 1a f2 ff ff       	jmp    80106390 <alltraps>

80107176 <vector198>:
80107176:	6a 00                	push   $0x0
80107178:	68 c6 00 00 00       	push   $0xc6
8010717d:	e9 0e f2 ff ff       	jmp    80106390 <alltraps>

80107182 <vector199>:
80107182:	6a 00                	push   $0x0
80107184:	68 c7 00 00 00       	push   $0xc7
80107189:	e9 02 f2 ff ff       	jmp    80106390 <alltraps>

8010718e <vector200>:
8010718e:	6a 00                	push   $0x0
80107190:	68 c8 00 00 00       	push   $0xc8
80107195:	e9 f6 f1 ff ff       	jmp    80106390 <alltraps>

8010719a <vector201>:
8010719a:	6a 00                	push   $0x0
8010719c:	68 c9 00 00 00       	push   $0xc9
801071a1:	e9 ea f1 ff ff       	jmp    80106390 <alltraps>

801071a6 <vector202>:
801071a6:	6a 00                	push   $0x0
801071a8:	68 ca 00 00 00       	push   $0xca
801071ad:	e9 de f1 ff ff       	jmp    80106390 <alltraps>

801071b2 <vector203>:
801071b2:	6a 00                	push   $0x0
801071b4:	68 cb 00 00 00       	push   $0xcb
801071b9:	e9 d2 f1 ff ff       	jmp    80106390 <alltraps>

801071be <vector204>:
801071be:	6a 00                	push   $0x0
801071c0:	68 cc 00 00 00       	push   $0xcc
801071c5:	e9 c6 f1 ff ff       	jmp    80106390 <alltraps>

801071ca <vector205>:
801071ca:	6a 00                	push   $0x0
801071cc:	68 cd 00 00 00       	push   $0xcd
801071d1:	e9 ba f1 ff ff       	jmp    80106390 <alltraps>

801071d6 <vector206>:
801071d6:	6a 00                	push   $0x0
801071d8:	68 ce 00 00 00       	push   $0xce
801071dd:	e9 ae f1 ff ff       	jmp    80106390 <alltraps>

801071e2 <vector207>:
801071e2:	6a 00                	push   $0x0
801071e4:	68 cf 00 00 00       	push   $0xcf
801071e9:	e9 a2 f1 ff ff       	jmp    80106390 <alltraps>

801071ee <vector208>:
801071ee:	6a 00                	push   $0x0
801071f0:	68 d0 00 00 00       	push   $0xd0
801071f5:	e9 96 f1 ff ff       	jmp    80106390 <alltraps>

801071fa <vector209>:
801071fa:	6a 00                	push   $0x0
801071fc:	68 d1 00 00 00       	push   $0xd1
80107201:	e9 8a f1 ff ff       	jmp    80106390 <alltraps>

80107206 <vector210>:
80107206:	6a 00                	push   $0x0
80107208:	68 d2 00 00 00       	push   $0xd2
8010720d:	e9 7e f1 ff ff       	jmp    80106390 <alltraps>

80107212 <vector211>:
80107212:	6a 00                	push   $0x0
80107214:	68 d3 00 00 00       	push   $0xd3
80107219:	e9 72 f1 ff ff       	jmp    80106390 <alltraps>

8010721e <vector212>:
8010721e:	6a 00                	push   $0x0
80107220:	68 d4 00 00 00       	push   $0xd4
80107225:	e9 66 f1 ff ff       	jmp    80106390 <alltraps>

8010722a <vector213>:
8010722a:	6a 00                	push   $0x0
8010722c:	68 d5 00 00 00       	push   $0xd5
80107231:	e9 5a f1 ff ff       	jmp    80106390 <alltraps>

80107236 <vector214>:
80107236:	6a 00                	push   $0x0
80107238:	68 d6 00 00 00       	push   $0xd6
8010723d:	e9 4e f1 ff ff       	jmp    80106390 <alltraps>

80107242 <vector215>:
80107242:	6a 00                	push   $0x0
80107244:	68 d7 00 00 00       	push   $0xd7
80107249:	e9 42 f1 ff ff       	jmp    80106390 <alltraps>

8010724e <vector216>:
8010724e:	6a 00                	push   $0x0
80107250:	68 d8 00 00 00       	push   $0xd8
80107255:	e9 36 f1 ff ff       	jmp    80106390 <alltraps>

8010725a <vector217>:
8010725a:	6a 00                	push   $0x0
8010725c:	68 d9 00 00 00       	push   $0xd9
80107261:	e9 2a f1 ff ff       	jmp    80106390 <alltraps>

80107266 <vector218>:
80107266:	6a 00                	push   $0x0
80107268:	68 da 00 00 00       	push   $0xda
8010726d:	e9 1e f1 ff ff       	jmp    80106390 <alltraps>

80107272 <vector219>:
80107272:	6a 00                	push   $0x0
80107274:	68 db 00 00 00       	push   $0xdb
80107279:	e9 12 f1 ff ff       	jmp    80106390 <alltraps>

8010727e <vector220>:
8010727e:	6a 00                	push   $0x0
80107280:	68 dc 00 00 00       	push   $0xdc
80107285:	e9 06 f1 ff ff       	jmp    80106390 <alltraps>

8010728a <vector221>:
8010728a:	6a 00                	push   $0x0
8010728c:	68 dd 00 00 00       	push   $0xdd
80107291:	e9 fa f0 ff ff       	jmp    80106390 <alltraps>

80107296 <vector222>:
80107296:	6a 00                	push   $0x0
80107298:	68 de 00 00 00       	push   $0xde
8010729d:	e9 ee f0 ff ff       	jmp    80106390 <alltraps>

801072a2 <vector223>:
801072a2:	6a 00                	push   $0x0
801072a4:	68 df 00 00 00       	push   $0xdf
801072a9:	e9 e2 f0 ff ff       	jmp    80106390 <alltraps>

801072ae <vector224>:
801072ae:	6a 00                	push   $0x0
801072b0:	68 e0 00 00 00       	push   $0xe0
801072b5:	e9 d6 f0 ff ff       	jmp    80106390 <alltraps>

801072ba <vector225>:
801072ba:	6a 00                	push   $0x0
801072bc:	68 e1 00 00 00       	push   $0xe1
801072c1:	e9 ca f0 ff ff       	jmp    80106390 <alltraps>

801072c6 <vector226>:
801072c6:	6a 00                	push   $0x0
801072c8:	68 e2 00 00 00       	push   $0xe2
801072cd:	e9 be f0 ff ff       	jmp    80106390 <alltraps>

801072d2 <vector227>:
801072d2:	6a 00                	push   $0x0
801072d4:	68 e3 00 00 00       	push   $0xe3
801072d9:	e9 b2 f0 ff ff       	jmp    80106390 <alltraps>

801072de <vector228>:
801072de:	6a 00                	push   $0x0
801072e0:	68 e4 00 00 00       	push   $0xe4
801072e5:	e9 a6 f0 ff ff       	jmp    80106390 <alltraps>

801072ea <vector229>:
801072ea:	6a 00                	push   $0x0
801072ec:	68 e5 00 00 00       	push   $0xe5
801072f1:	e9 9a f0 ff ff       	jmp    80106390 <alltraps>

801072f6 <vector230>:
801072f6:	6a 00                	push   $0x0
801072f8:	68 e6 00 00 00       	push   $0xe6
801072fd:	e9 8e f0 ff ff       	jmp    80106390 <alltraps>

80107302 <vector231>:
80107302:	6a 00                	push   $0x0
80107304:	68 e7 00 00 00       	push   $0xe7
80107309:	e9 82 f0 ff ff       	jmp    80106390 <alltraps>

8010730e <vector232>:
8010730e:	6a 00                	push   $0x0
80107310:	68 e8 00 00 00       	push   $0xe8
80107315:	e9 76 f0 ff ff       	jmp    80106390 <alltraps>

8010731a <vector233>:
8010731a:	6a 00                	push   $0x0
8010731c:	68 e9 00 00 00       	push   $0xe9
80107321:	e9 6a f0 ff ff       	jmp    80106390 <alltraps>

80107326 <vector234>:
80107326:	6a 00                	push   $0x0
80107328:	68 ea 00 00 00       	push   $0xea
8010732d:	e9 5e f0 ff ff       	jmp    80106390 <alltraps>

80107332 <vector235>:
80107332:	6a 00                	push   $0x0
80107334:	68 eb 00 00 00       	push   $0xeb
80107339:	e9 52 f0 ff ff       	jmp    80106390 <alltraps>

8010733e <vector236>:
8010733e:	6a 00                	push   $0x0
80107340:	68 ec 00 00 00       	push   $0xec
80107345:	e9 46 f0 ff ff       	jmp    80106390 <alltraps>

8010734a <vector237>:
8010734a:	6a 00                	push   $0x0
8010734c:	68 ed 00 00 00       	push   $0xed
80107351:	e9 3a f0 ff ff       	jmp    80106390 <alltraps>

80107356 <vector238>:
80107356:	6a 00                	push   $0x0
80107358:	68 ee 00 00 00       	push   $0xee
8010735d:	e9 2e f0 ff ff       	jmp    80106390 <alltraps>

80107362 <vector239>:
80107362:	6a 00                	push   $0x0
80107364:	68 ef 00 00 00       	push   $0xef
80107369:	e9 22 f0 ff ff       	jmp    80106390 <alltraps>

8010736e <vector240>:
8010736e:	6a 00                	push   $0x0
80107370:	68 f0 00 00 00       	push   $0xf0
80107375:	e9 16 f0 ff ff       	jmp    80106390 <alltraps>

8010737a <vector241>:
8010737a:	6a 00                	push   $0x0
8010737c:	68 f1 00 00 00       	push   $0xf1
80107381:	e9 0a f0 ff ff       	jmp    80106390 <alltraps>

80107386 <vector242>:
80107386:	6a 00                	push   $0x0
80107388:	68 f2 00 00 00       	push   $0xf2
8010738d:	e9 fe ef ff ff       	jmp    80106390 <alltraps>

80107392 <vector243>:
80107392:	6a 00                	push   $0x0
80107394:	68 f3 00 00 00       	push   $0xf3
80107399:	e9 f2 ef ff ff       	jmp    80106390 <alltraps>

8010739e <vector244>:
8010739e:	6a 00                	push   $0x0
801073a0:	68 f4 00 00 00       	push   $0xf4
801073a5:	e9 e6 ef ff ff       	jmp    80106390 <alltraps>

801073aa <vector245>:
801073aa:	6a 00                	push   $0x0
801073ac:	68 f5 00 00 00       	push   $0xf5
801073b1:	e9 da ef ff ff       	jmp    80106390 <alltraps>

801073b6 <vector246>:
801073b6:	6a 00                	push   $0x0
801073b8:	68 f6 00 00 00       	push   $0xf6
801073bd:	e9 ce ef ff ff       	jmp    80106390 <alltraps>

801073c2 <vector247>:
801073c2:	6a 00                	push   $0x0
801073c4:	68 f7 00 00 00       	push   $0xf7
801073c9:	e9 c2 ef ff ff       	jmp    80106390 <alltraps>

801073ce <vector248>:
801073ce:	6a 00                	push   $0x0
801073d0:	68 f8 00 00 00       	push   $0xf8
801073d5:	e9 b6 ef ff ff       	jmp    80106390 <alltraps>

801073da <vector249>:
801073da:	6a 00                	push   $0x0
801073dc:	68 f9 00 00 00       	push   $0xf9
801073e1:	e9 aa ef ff ff       	jmp    80106390 <alltraps>

801073e6 <vector250>:
801073e6:	6a 00                	push   $0x0
801073e8:	68 fa 00 00 00       	push   $0xfa
801073ed:	e9 9e ef ff ff       	jmp    80106390 <alltraps>

801073f2 <vector251>:
801073f2:	6a 00                	push   $0x0
801073f4:	68 fb 00 00 00       	push   $0xfb
801073f9:	e9 92 ef ff ff       	jmp    80106390 <alltraps>

801073fe <vector252>:
801073fe:	6a 00                	push   $0x0
80107400:	68 fc 00 00 00       	push   $0xfc
80107405:	e9 86 ef ff ff       	jmp    80106390 <alltraps>

8010740a <vector253>:
8010740a:	6a 00                	push   $0x0
8010740c:	68 fd 00 00 00       	push   $0xfd
80107411:	e9 7a ef ff ff       	jmp    80106390 <alltraps>

80107416 <vector254>:
80107416:	6a 00                	push   $0x0
80107418:	68 fe 00 00 00       	push   $0xfe
8010741d:	e9 6e ef ff ff       	jmp    80106390 <alltraps>

80107422 <vector255>:
80107422:	6a 00                	push   $0x0
80107424:	68 ff 00 00 00       	push   $0xff
80107429:	e9 62 ef ff ff       	jmp    80106390 <alltraps>
	...

80107430 <lgdt>:
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	83 ec 10             	sub    $0x10,%esp
80107436:	8b 45 0c             	mov    0xc(%ebp),%eax
80107439:	48                   	dec    %eax
8010743a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
8010743e:	8b 45 08             	mov    0x8(%ebp),%eax
80107441:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107445:	8b 45 08             	mov    0x8(%ebp),%eax
80107448:	c1 e8 10             	shr    $0x10,%eax
8010744b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
8010744f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107452:	0f 01 10             	lgdtl  (%eax)
80107455:	c9                   	leave  
80107456:	c3                   	ret    

80107457 <ltr>:
80107457:	55                   	push   %ebp
80107458:	89 e5                	mov    %esp,%ebp
8010745a:	83 ec 04             	sub    $0x4,%esp
8010745d:	8b 45 08             	mov    0x8(%ebp),%eax
80107460:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107464:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107467:	0f 00 d8             	ltr    %ax
8010746a:	c9                   	leave  
8010746b:	c3                   	ret    

8010746c <lcr3>:
8010746c:	55                   	push   %ebp
8010746d:	89 e5                	mov    %esp,%ebp
8010746f:	8b 45 08             	mov    0x8(%ebp),%eax
80107472:	0f 22 d8             	mov    %eax,%cr3
80107475:	5d                   	pop    %ebp
80107476:	c3                   	ret    

80107477 <seginit>:
80107477:	55                   	push   %ebp
80107478:	89 e5                	mov    %esp,%ebp
8010747a:	83 ec 28             	sub    $0x28,%esp
8010747d:	e8 70 cc ff ff       	call   801040f2 <cpuid>
80107482:	89 c2                	mov    %eax,%edx
80107484:	89 d0                	mov    %edx,%eax
80107486:	c1 e0 02             	shl    $0x2,%eax
80107489:	01 d0                	add    %edx,%eax
8010748b:	01 c0                	add    %eax,%eax
8010748d:	01 d0                	add    %edx,%eax
8010748f:	c1 e0 04             	shl    $0x4,%eax
80107492:	05 00 38 11 80       	add    $0x80113800,%eax
80107497:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010749a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749d:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801074a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a6:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801074ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074af:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801074b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b6:	8a 50 7d             	mov    0x7d(%eax),%dl
801074b9:	83 e2 f0             	and    $0xfffffff0,%edx
801074bc:	83 ca 0a             	or     $0xa,%edx
801074bf:	88 50 7d             	mov    %dl,0x7d(%eax)
801074c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c5:	8a 50 7d             	mov    0x7d(%eax),%dl
801074c8:	83 ca 10             	or     $0x10,%edx
801074cb:	88 50 7d             	mov    %dl,0x7d(%eax)
801074ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d1:	8a 50 7d             	mov    0x7d(%eax),%dl
801074d4:	83 e2 9f             	and    $0xffffff9f,%edx
801074d7:	88 50 7d             	mov    %dl,0x7d(%eax)
801074da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074dd:	8a 50 7d             	mov    0x7d(%eax),%dl
801074e0:	83 ca 80             	or     $0xffffff80,%edx
801074e3:	88 50 7d             	mov    %dl,0x7d(%eax)
801074e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e9:	8a 50 7e             	mov    0x7e(%eax),%dl
801074ec:	83 ca 0f             	or     $0xf,%edx
801074ef:	88 50 7e             	mov    %dl,0x7e(%eax)
801074f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f5:	8a 50 7e             	mov    0x7e(%eax),%dl
801074f8:	83 e2 ef             	and    $0xffffffef,%edx
801074fb:	88 50 7e             	mov    %dl,0x7e(%eax)
801074fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107501:	8a 50 7e             	mov    0x7e(%eax),%dl
80107504:	83 e2 df             	and    $0xffffffdf,%edx
80107507:	88 50 7e             	mov    %dl,0x7e(%eax)
8010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107510:	83 ca 40             	or     $0x40,%edx
80107513:	88 50 7e             	mov    %dl,0x7e(%eax)
80107516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107519:	8a 50 7e             	mov    0x7e(%eax),%dl
8010751c:	83 ca 80             	or     $0xffffff80,%edx
8010751f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107525:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
80107529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107533:	ff ff 
80107535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107538:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010753f:	00 00 
80107541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107544:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010754b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754e:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107554:	83 e2 f0             	and    $0xfffffff0,%edx
80107557:	83 ca 02             	or     $0x2,%edx
8010755a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107563:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107569:	83 ca 10             	or     $0x10,%edx
8010756c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107575:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010757b:	83 e2 9f             	and    $0xffffff9f,%edx
8010757e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107587:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010758d:	83 ca 80             	or     $0xffffff80,%edx
80107590:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107599:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010759f:	83 ca 0f             	or     $0xf,%edx
801075a2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ab:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075b1:	83 e2 ef             	and    $0xffffffef,%edx
801075b4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bd:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075c3:	83 e2 df             	and    $0xffffffdf,%edx
801075c6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cf:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075d5:	83 ca 40             	or     $0x40,%edx
801075d8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e1:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075e7:	83 ca 80             	or     $0xffffff80,%edx
801075ea:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
801075fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fd:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107604:	ff ff 
80107606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107609:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107610:	00 00 
80107612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107615:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010761c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761f:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107625:	83 e2 f0             	and    $0xfffffff0,%edx
80107628:	83 ca 0a             	or     $0xa,%edx
8010762b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107634:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010763a:	83 ca 10             	or     $0x10,%edx
8010763d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107646:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010764c:	83 ca 60             	or     $0x60,%edx
8010764f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010765e:	83 ca 80             	or     $0xffffff80,%edx
80107661:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766a:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107670:	83 ca 0f             	or     $0xf,%edx
80107673:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767c:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107682:	83 e2 ef             	and    $0xffffffef,%edx
80107685:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010768b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768e:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107694:	83 e2 df             	and    $0xffffffdf,%edx
80107697:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010769d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a0:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801076a6:	83 ca 40             	or     $0x40,%edx
801076a9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801076b8:	83 ca 80             	or     $0xffffff80,%edx
801076bb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c4:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
801076cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ce:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801076d5:	ff ff 
801076d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076da:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801076e1:	00 00 
801076e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e6:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801076ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f0:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801076f6:	83 e2 f0             	and    $0xfffffff0,%edx
801076f9:	83 ca 02             	or     $0x2,%edx
801076fc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107705:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010770b:	83 ca 10             	or     $0x10,%edx
8010770e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107717:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010771d:	83 ca 60             	or     $0x60,%edx
80107720:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107729:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010772f:	83 ca 80             	or     $0xffffff80,%edx
80107732:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107741:	83 ca 0f             	or     $0xf,%edx
80107744:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010774a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107753:	83 e2 ef             	and    $0xffffffef,%edx
80107756:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010775c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107765:	83 e2 df             	and    $0xffffffdf,%edx
80107768:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010776e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107771:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107777:	83 ca 40             	or     $0x40,%edx
8010777a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107783:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107789:	83 ca 80             	or     $0xffffff80,%edx
8010778c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107795:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
8010779c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779f:	83 c0 70             	add    $0x70,%eax
801077a2:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801077a9:	00 
801077aa:	89 04 24             	mov    %eax,(%esp)
801077ad:	e8 7e fc ff ff       	call   80107430 <lgdt>
801077b2:	c9                   	leave  
801077b3:	c3                   	ret    

801077b4 <walkpgdir>:
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	83 ec 28             	sub    $0x28,%esp
801077ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801077bd:	c1 e8 16             	shr    $0x16,%eax
801077c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801077c7:	8b 45 08             	mov    0x8(%ebp),%eax
801077ca:	01 d0                	add    %edx,%eax
801077cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801077cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077d2:	8b 00                	mov    (%eax),%eax
801077d4:	83 e0 01             	and    $0x1,%eax
801077d7:	85 c0                	test   %eax,%eax
801077d9:	74 14                	je     801077ef <walkpgdir+0x3b>
801077db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077de:	8b 00                	mov    (%eax),%eax
801077e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077e5:	05 00 00 00 80       	add    $0x80000000,%eax
801077ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077ed:	eb 48                	jmp    80107837 <walkpgdir+0x83>
801077ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801077f3:	74 0e                	je     80107803 <walkpgdir+0x4f>
801077f5:	e8 01 b4 ff ff       	call   80102bfb <kalloc>
801077fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107801:	75 07                	jne    8010780a <walkpgdir+0x56>
80107803:	b8 00 00 00 00       	mov    $0x0,%eax
80107808:	eb 44                	jmp    8010784e <walkpgdir+0x9a>
8010780a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107811:	00 
80107812:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107819:	00 
8010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781d:	89 04 24             	mov    %eax,(%esp)
80107820:	e8 09 d8 ff ff       	call   8010502e <memset>
80107825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107828:	05 00 00 00 80       	add    $0x80000000,%eax
8010782d:	83 c8 07             	or     $0x7,%eax
80107830:	89 c2                	mov    %eax,%edx
80107832:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107835:	89 10                	mov    %edx,(%eax)
80107837:	8b 45 0c             	mov    0xc(%ebp),%eax
8010783a:	c1 e8 0c             	shr    $0xc,%eax
8010783d:	25 ff 03 00 00       	and    $0x3ff,%eax
80107842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784c:	01 d0                	add    %edx,%eax
8010784e:	c9                   	leave  
8010784f:	c3                   	ret    

80107850 <mappages>:
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	83 ec 28             	sub    $0x28,%esp
80107856:	8b 45 0c             	mov    0xc(%ebp),%eax
80107859:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010785e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107861:	8b 55 0c             	mov    0xc(%ebp),%edx
80107864:	8b 45 10             	mov    0x10(%ebp),%eax
80107867:	01 d0                	add    %edx,%eax
80107869:	48                   	dec    %eax
8010786a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010786f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107872:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107879:	00 
8010787a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107881:	8b 45 08             	mov    0x8(%ebp),%eax
80107884:	89 04 24             	mov    %eax,(%esp)
80107887:	e8 28 ff ff ff       	call   801077b4 <walkpgdir>
8010788c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010788f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107893:	75 07                	jne    8010789c <mappages+0x4c>
80107895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010789a:	eb 48                	jmp    801078e4 <mappages+0x94>
8010789c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010789f:	8b 00                	mov    (%eax),%eax
801078a1:	83 e0 01             	and    $0x1,%eax
801078a4:	85 c0                	test   %eax,%eax
801078a6:	74 0c                	je     801078b4 <mappages+0x64>
801078a8:	c7 04 24 c4 87 10 80 	movl   $0x801087c4,(%esp)
801078af:	e8 a0 8c ff ff       	call   80100554 <panic>
801078b4:	8b 45 18             	mov    0x18(%ebp),%eax
801078b7:	0b 45 14             	or     0x14(%ebp),%eax
801078ba:	83 c8 01             	or     $0x1,%eax
801078bd:	89 c2                	mov    %eax,%edx
801078bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078c2:	89 10                	mov    %edx,(%eax)
801078c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801078ca:	75 08                	jne    801078d4 <mappages+0x84>
801078cc:	90                   	nop
801078cd:	b8 00 00 00 00       	mov    $0x0,%eax
801078d2:	eb 10                	jmp    801078e4 <mappages+0x94>
801078d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801078db:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
801078e2:	eb 8e                	jmp    80107872 <mappages+0x22>
801078e4:	c9                   	leave  
801078e5:	c3                   	ret    

801078e6 <setupkvm>:
801078e6:	55                   	push   %ebp
801078e7:	89 e5                	mov    %esp,%ebp
801078e9:	53                   	push   %ebx
801078ea:	83 ec 34             	sub    $0x34,%esp
801078ed:	e8 09 b3 ff ff       	call   80102bfb <kalloc>
801078f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078f9:	75 0a                	jne    80107905 <setupkvm+0x1f>
801078fb:	b8 00 00 00 00       	mov    $0x0,%eax
80107900:	e9 84 00 00 00       	jmp    80107989 <setupkvm+0xa3>
80107905:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010790c:	00 
8010790d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107914:	00 
80107915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107918:	89 04 24             	mov    %eax,(%esp)
8010791b:	e8 0e d7 ff ff       	call   8010502e <memset>
80107920:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107927:	eb 54                	jmp    8010797d <setupkvm+0x97>
80107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792c:	8b 48 0c             	mov    0xc(%eax),%ecx
8010792f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107932:	8b 50 04             	mov    0x4(%eax),%edx
80107935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107938:	8b 58 08             	mov    0x8(%eax),%ebx
8010793b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793e:	8b 40 04             	mov    0x4(%eax),%eax
80107941:	29 c3                	sub    %eax,%ebx
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	8b 00                	mov    (%eax),%eax
80107948:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010794c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107950:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107954:	89 44 24 04          	mov    %eax,0x4(%esp)
80107958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010795b:	89 04 24             	mov    %eax,(%esp)
8010795e:	e8 ed fe ff ff       	call   80107850 <mappages>
80107963:	85 c0                	test   %eax,%eax
80107965:	79 12                	jns    80107979 <setupkvm+0x93>
80107967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010796a:	89 04 24             	mov    %eax,(%esp)
8010796d:	e8 1a 05 00 00       	call   80107e8c <freevm>
80107972:	b8 00 00 00 00       	mov    $0x0,%eax
80107977:	eb 10                	jmp    80107989 <setupkvm+0xa3>
80107979:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010797d:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107984:	72 a3                	jb     80107929 <setupkvm+0x43>
80107986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107989:	83 c4 34             	add    $0x34,%esp
8010798c:	5b                   	pop    %ebx
8010798d:	5d                   	pop    %ebp
8010798e:	c3                   	ret    

8010798f <kvmalloc>:
8010798f:	55                   	push   %ebp
80107990:	89 e5                	mov    %esp,%ebp
80107992:	83 ec 08             	sub    $0x8,%esp
80107995:	e8 4c ff ff ff       	call   801078e6 <setupkvm>
8010799a:	a3 24 65 11 80       	mov    %eax,0x80116524
8010799f:	e8 02 00 00 00       	call   801079a6 <switchkvm>
801079a4:	c9                   	leave  
801079a5:	c3                   	ret    

801079a6 <switchkvm>:
801079a6:	55                   	push   %ebp
801079a7:	89 e5                	mov    %esp,%ebp
801079a9:	83 ec 04             	sub    $0x4,%esp
801079ac:	a1 24 65 11 80       	mov    0x80116524,%eax
801079b1:	05 00 00 00 80       	add    $0x80000000,%eax
801079b6:	89 04 24             	mov    %eax,(%esp)
801079b9:	e8 ae fa ff ff       	call   8010746c <lcr3>
801079be:	c9                   	leave  
801079bf:	c3                   	ret    

801079c0 <switchuvm>:
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 1c             	sub    $0x1c,%esp
801079c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801079cd:	75 0c                	jne    801079db <switchuvm+0x1b>
801079cf:	c7 04 24 ca 87 10 80 	movl   $0x801087ca,(%esp)
801079d6:	e8 79 8b ff ff       	call   80100554 <panic>
801079db:	8b 45 08             	mov    0x8(%ebp),%eax
801079de:	8b 40 08             	mov    0x8(%eax),%eax
801079e1:	85 c0                	test   %eax,%eax
801079e3:	75 0c                	jne    801079f1 <switchuvm+0x31>
801079e5:	c7 04 24 e0 87 10 80 	movl   $0x801087e0,(%esp)
801079ec:	e8 63 8b ff ff       	call   80100554 <panic>
801079f1:	8b 45 08             	mov    0x8(%ebp),%eax
801079f4:	8b 40 04             	mov    0x4(%eax),%eax
801079f7:	85 c0                	test   %eax,%eax
801079f9:	75 0c                	jne    80107a07 <switchuvm+0x47>
801079fb:	c7 04 24 f5 87 10 80 	movl   $0x801087f5,(%esp)
80107a02:	e8 4d 8b ff ff       	call   80100554 <panic>
80107a07:	e8 1e d5 ff ff       	call   80104f2a <pushcli>
80107a0c:	e8 26 c7 ff ff       	call   80104137 <mycpu>
80107a11:	89 c3                	mov    %eax,%ebx
80107a13:	e8 1f c7 ff ff       	call   80104137 <mycpu>
80107a18:	83 c0 08             	add    $0x8,%eax
80107a1b:	89 c6                	mov    %eax,%esi
80107a1d:	e8 15 c7 ff ff       	call   80104137 <mycpu>
80107a22:	83 c0 08             	add    $0x8,%eax
80107a25:	c1 e8 10             	shr    $0x10,%eax
80107a28:	89 c7                	mov    %eax,%edi
80107a2a:	e8 08 c7 ff ff       	call   80104137 <mycpu>
80107a2f:	83 c0 08             	add    $0x8,%eax
80107a32:	c1 e8 18             	shr    $0x18,%eax
80107a35:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107a3c:	67 00 
80107a3e:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107a45:	89 f9                	mov    %edi,%ecx
80107a47:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a4d:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a53:	83 e2 f0             	and    $0xfffffff0,%edx
80107a56:	83 ca 09             	or     $0x9,%edx
80107a59:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a5f:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a65:	83 ca 10             	or     $0x10,%edx
80107a68:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a6e:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a74:	83 e2 9f             	and    $0xffffff9f,%edx
80107a77:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a7d:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a83:	83 ca 80             	or     $0xffffff80,%edx
80107a86:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a8c:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a92:	83 e2 f0             	and    $0xfffffff0,%edx
80107a95:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a9b:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107aa1:	83 e2 ef             	and    $0xffffffef,%edx
80107aa4:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107aaa:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ab0:	83 e2 df             	and    $0xffffffdf,%edx
80107ab3:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ab9:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107abf:	83 ca 40             	or     $0x40,%edx
80107ac2:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ac8:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ace:	83 e2 7f             	and    $0x7f,%edx
80107ad1:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ad7:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107add:	e8 55 c6 ff ff       	call   80104137 <mycpu>
80107ae2:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107ae8:	83 e2 ef             	and    $0xffffffef,%edx
80107aeb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107af1:	e8 41 c6 ff ff       	call   80104137 <mycpu>
80107af6:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
80107afc:	e8 36 c6 ff ff       	call   80104137 <mycpu>
80107b01:	8b 55 08             	mov    0x8(%ebp),%edx
80107b04:	8b 52 08             	mov    0x8(%edx),%edx
80107b07:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107b0d:	89 50 0c             	mov    %edx,0xc(%eax)
80107b10:	e8 22 c6 ff ff       	call   80104137 <mycpu>
80107b15:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
80107b1b:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107b22:	e8 30 f9 ff ff       	call   80107457 <ltr>
80107b27:	8b 45 08             	mov    0x8(%ebp),%eax
80107b2a:	8b 40 04             	mov    0x4(%eax),%eax
80107b2d:	05 00 00 00 80       	add    $0x80000000,%eax
80107b32:	89 04 24             	mov    %eax,(%esp)
80107b35:	e8 32 f9 ff ff       	call   8010746c <lcr3>
80107b3a:	e8 35 d4 ff ff       	call   80104f74 <popcli>
80107b3f:	83 c4 1c             	add    $0x1c,%esp
80107b42:	5b                   	pop    %ebx
80107b43:	5e                   	pop    %esi
80107b44:	5f                   	pop    %edi
80107b45:	5d                   	pop    %ebp
80107b46:	c3                   	ret    

80107b47 <inituvm>:
80107b47:	55                   	push   %ebp
80107b48:	89 e5                	mov    %esp,%ebp
80107b4a:	83 ec 38             	sub    $0x38,%esp
80107b4d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b54:	76 0c                	jbe    80107b62 <inituvm+0x1b>
80107b56:	c7 04 24 09 88 10 80 	movl   $0x80108809,(%esp)
80107b5d:	e8 f2 89 ff ff       	call   80100554 <panic>
80107b62:	e8 94 b0 ff ff       	call   80102bfb <kalloc>
80107b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b6a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b71:	00 
80107b72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b79:	00 
80107b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7d:	89 04 24             	mov    %eax,(%esp)
80107b80:	e8 a9 d4 ff ff       	call   8010502e <memset>
80107b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b88:	05 00 00 00 80       	add    $0x80000000,%eax
80107b8d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107b94:	00 
80107b95:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107b99:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ba0:	00 
80107ba1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ba8:	00 
80107ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80107bac:	89 04 24             	mov    %eax,(%esp)
80107baf:	e8 9c fc ff ff       	call   80107850 <mappages>
80107bb4:	8b 45 10             	mov    0x10(%ebp),%eax
80107bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
80107bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc5:	89 04 24             	mov    %eax,(%esp)
80107bc8:	e8 2a d5 ff ff       	call   801050f7 <memmove>
80107bcd:	c9                   	leave  
80107bce:	c3                   	ret    

80107bcf <loaduvm>:
80107bcf:	55                   	push   %ebp
80107bd0:	89 e5                	mov    %esp,%ebp
80107bd2:	83 ec 28             	sub    $0x28,%esp
80107bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd8:	25 ff 0f 00 00       	and    $0xfff,%eax
80107bdd:	85 c0                	test   %eax,%eax
80107bdf:	74 0c                	je     80107bed <loaduvm+0x1e>
80107be1:	c7 04 24 24 88 10 80 	movl   $0x80108824,(%esp)
80107be8:	e8 67 89 ff ff       	call   80100554 <panic>
80107bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bf4:	e9 a6 00 00 00       	jmp    80107c9f <loaduvm+0xd0>
80107bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bff:	01 d0                	add    %edx,%eax
80107c01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107c08:	00 
80107c09:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107c10:	89 04 24             	mov    %eax,(%esp)
80107c13:	e8 9c fb ff ff       	call   801077b4 <walkpgdir>
80107c18:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c1f:	75 0c                	jne    80107c2d <loaduvm+0x5e>
80107c21:	c7 04 24 47 88 10 80 	movl   $0x80108847,(%esp)
80107c28:	e8 27 89 ff ff       	call   80100554 <panic>
80107c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c30:	8b 00                	mov    (%eax),%eax
80107c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3d:	8b 55 18             	mov    0x18(%ebp),%edx
80107c40:	29 c2                	sub    %eax,%edx
80107c42:	89 d0                	mov    %edx,%eax
80107c44:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107c49:	77 0f                	ja     80107c5a <loaduvm+0x8b>
80107c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4e:	8b 55 18             	mov    0x18(%ebp),%edx
80107c51:	29 c2                	sub    %eax,%edx
80107c53:	89 d0                	mov    %edx,%eax
80107c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c58:	eb 07                	jmp    80107c61 <loaduvm+0x92>
80107c5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
80107c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c64:	8b 55 14             	mov    0x14(%ebp),%edx
80107c67:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c6d:	05 00 00 00 80       	add    $0x80000000,%eax
80107c72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107c75:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c81:	8b 45 10             	mov    0x10(%ebp),%eax
80107c84:	89 04 24             	mov    %eax,(%esp)
80107c87:	e8 d5 a1 ff ff       	call   80101e61 <readi>
80107c8c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c8f:	74 07                	je     80107c98 <loaduvm+0xc9>
80107c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c96:	eb 18                	jmp    80107cb0 <loaduvm+0xe1>
80107c98:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca2:	3b 45 18             	cmp    0x18(%ebp),%eax
80107ca5:	0f 82 4e ff ff ff    	jb     80107bf9 <loaduvm+0x2a>
80107cab:	b8 00 00 00 00       	mov    $0x0,%eax
80107cb0:	c9                   	leave  
80107cb1:	c3                   	ret    

80107cb2 <allocuvm>:
80107cb2:	55                   	push   %ebp
80107cb3:	89 e5                	mov    %esp,%ebp
80107cb5:	83 ec 38             	sub    $0x38,%esp
80107cb8:	8b 45 10             	mov    0x10(%ebp),%eax
80107cbb:	85 c0                	test   %eax,%eax
80107cbd:	79 0a                	jns    80107cc9 <allocuvm+0x17>
80107cbf:	b8 00 00 00 00       	mov    $0x0,%eax
80107cc4:	e9 fd 00 00 00       	jmp    80107dc6 <allocuvm+0x114>
80107cc9:	8b 45 10             	mov    0x10(%ebp),%eax
80107ccc:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ccf:	73 08                	jae    80107cd9 <allocuvm+0x27>
80107cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd4:	e9 ed 00 00 00       	jmp    80107dc6 <allocuvm+0x114>
80107cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cdc:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ce1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ce9:	e9 c9 00 00 00       	jmp    80107db7 <allocuvm+0x105>
80107cee:	e8 08 af ff ff       	call   80102bfb <kalloc>
80107cf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cfa:	75 2f                	jne    80107d2b <allocuvm+0x79>
80107cfc:	c7 04 24 65 88 10 80 	movl   $0x80108865,(%esp)
80107d03:	e8 b9 86 ff ff       	call   801003c1 <cprintf>
80107d08:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d0f:	8b 45 10             	mov    0x10(%ebp),%eax
80107d12:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d16:	8b 45 08             	mov    0x8(%ebp),%eax
80107d19:	89 04 24             	mov    %eax,(%esp)
80107d1c:	e8 a7 00 00 00       	call   80107dc8 <deallocuvm>
80107d21:	b8 00 00 00 00       	mov    $0x0,%eax
80107d26:	e9 9b 00 00 00       	jmp    80107dc6 <allocuvm+0x114>
80107d2b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d32:	00 
80107d33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d3a:	00 
80107d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d3e:	89 04 24             	mov    %eax,(%esp)
80107d41:	e8 e8 d2 ff ff       	call   8010502e <memset>
80107d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d49:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d52:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107d59:	00 
80107d5a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d65:	00 
80107d66:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6d:	89 04 24             	mov    %eax,(%esp)
80107d70:	e8 db fa ff ff       	call   80107850 <mappages>
80107d75:	85 c0                	test   %eax,%eax
80107d77:	79 37                	jns    80107db0 <allocuvm+0xfe>
80107d79:	c7 04 24 7d 88 10 80 	movl   $0x8010887d,(%esp)
80107d80:	e8 3c 86 ff ff       	call   801003c1 <cprintf>
80107d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d88:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d8c:	8b 45 10             	mov    0x10(%ebp),%eax
80107d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d93:	8b 45 08             	mov    0x8(%ebp),%eax
80107d96:	89 04 24             	mov    %eax,(%esp)
80107d99:	e8 2a 00 00 00       	call   80107dc8 <deallocuvm>
80107d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da1:	89 04 24             	mov    %eax,(%esp)
80107da4:	e8 bc ad ff ff       	call   80102b65 <kfree>
80107da9:	b8 00 00 00 00       	mov    $0x0,%eax
80107dae:	eb 16                	jmp    80107dc6 <allocuvm+0x114>
80107db0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dba:	3b 45 10             	cmp    0x10(%ebp),%eax
80107dbd:	0f 82 2b ff ff ff    	jb     80107cee <allocuvm+0x3c>
80107dc3:	8b 45 10             	mov    0x10(%ebp),%eax
80107dc6:	c9                   	leave  
80107dc7:	c3                   	ret    

80107dc8 <deallocuvm>:
80107dc8:	55                   	push   %ebp
80107dc9:	89 e5                	mov    %esp,%ebp
80107dcb:	83 ec 28             	sub    $0x28,%esp
80107dce:	8b 45 10             	mov    0x10(%ebp),%eax
80107dd1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107dd4:	72 08                	jb     80107dde <deallocuvm+0x16>
80107dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dd9:	e9 ac 00 00 00       	jmp    80107e8a <deallocuvm+0xc2>
80107dde:	8b 45 10             	mov    0x10(%ebp),%eax
80107de1:	05 ff 0f 00 00       	add    $0xfff,%eax
80107de6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107dee:	e9 88 00 00 00       	jmp    80107e7b <deallocuvm+0xb3>
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107dfd:	00 
80107dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e02:	8b 45 08             	mov    0x8(%ebp),%eax
80107e05:	89 04 24             	mov    %eax,(%esp)
80107e08:	e8 a7 f9 ff ff       	call   801077b4 <walkpgdir>
80107e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e14:	75 14                	jne    80107e2a <deallocuvm+0x62>
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	c1 e8 16             	shr    $0x16,%eax
80107e1c:	40                   	inc    %eax
80107e1d:	c1 e0 16             	shl    $0x16,%eax
80107e20:	2d 00 10 00 00       	sub    $0x1000,%eax
80107e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e28:	eb 4a                	jmp    80107e74 <deallocuvm+0xac>
80107e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e2d:	8b 00                	mov    (%eax),%eax
80107e2f:	83 e0 01             	and    $0x1,%eax
80107e32:	85 c0                	test   %eax,%eax
80107e34:	74 3e                	je     80107e74 <deallocuvm+0xac>
80107e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e39:	8b 00                	mov    (%eax),%eax
80107e3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e47:	75 0c                	jne    80107e55 <deallocuvm+0x8d>
80107e49:	c7 04 24 99 88 10 80 	movl   $0x80108899,(%esp)
80107e50:	e8 ff 86 ff ff       	call   80100554 <panic>
80107e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e58:	05 00 00 00 80       	add    $0x80000000,%eax
80107e5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e63:	89 04 24             	mov    %eax,(%esp)
80107e66:	e8 fa ac ff ff       	call   80102b65 <kfree>
80107e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107e74:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e81:	0f 82 6c ff ff ff    	jb     80107df3 <deallocuvm+0x2b>
80107e87:	8b 45 10             	mov    0x10(%ebp),%eax
80107e8a:	c9                   	leave  
80107e8b:	c3                   	ret    

80107e8c <freevm>:
80107e8c:	55                   	push   %ebp
80107e8d:	89 e5                	mov    %esp,%ebp
80107e8f:	83 ec 28             	sub    $0x28,%esp
80107e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e96:	75 0c                	jne    80107ea4 <freevm+0x18>
80107e98:	c7 04 24 9f 88 10 80 	movl   $0x8010889f,(%esp)
80107e9f:	e8 b0 86 ff ff       	call   80100554 <panic>
80107ea4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107eab:	00 
80107eac:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107eb3:	80 
80107eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb7:	89 04 24             	mov    %eax,(%esp)
80107eba:	e8 09 ff ff ff       	call   80107dc8 <deallocuvm>
80107ebf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ec6:	eb 44                	jmp    80107f0c <freevm+0x80>
80107ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed5:	01 d0                	add    %edx,%eax
80107ed7:	8b 00                	mov    (%eax),%eax
80107ed9:	83 e0 01             	and    $0x1,%eax
80107edc:	85 c0                	test   %eax,%eax
80107ede:	74 29                	je     80107f09 <freevm+0x7d>
80107ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107eea:	8b 45 08             	mov    0x8(%ebp),%eax
80107eed:	01 d0                	add    %edx,%eax
80107eef:	8b 00                	mov    (%eax),%eax
80107ef1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ef6:	05 00 00 00 80       	add    $0x80000000,%eax
80107efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f01:	89 04 24             	mov    %eax,(%esp)
80107f04:	e8 5c ac ff ff       	call   80102b65 <kfree>
80107f09:	ff 45 f4             	incl   -0xc(%ebp)
80107f0c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107f13:	76 b3                	jbe    80107ec8 <freevm+0x3c>
80107f15:	8b 45 08             	mov    0x8(%ebp),%eax
80107f18:	89 04 24             	mov    %eax,(%esp)
80107f1b:	e8 45 ac ff ff       	call   80102b65 <kfree>
80107f20:	c9                   	leave  
80107f21:	c3                   	ret    

80107f22 <clearpteu>:
80107f22:	55                   	push   %ebp
80107f23:	89 e5                	mov    %esp,%ebp
80107f25:	83 ec 28             	sub    $0x28,%esp
80107f28:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f2f:	00 
80107f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f37:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3a:	89 04 24             	mov    %eax,(%esp)
80107f3d:	e8 72 f8 ff ff       	call   801077b4 <walkpgdir>
80107f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f49:	75 0c                	jne    80107f57 <clearpteu+0x35>
80107f4b:	c7 04 24 b0 88 10 80 	movl   $0x801088b0,(%esp)
80107f52:	e8 fd 85 ff ff       	call   80100554 <panic>
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	8b 00                	mov    (%eax),%eax
80107f5c:	83 e0 fb             	and    $0xfffffffb,%eax
80107f5f:	89 c2                	mov    %eax,%edx
80107f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f64:	89 10                	mov    %edx,(%eax)
80107f66:	c9                   	leave  
80107f67:	c3                   	ret    

80107f68 <copyuvm>:
80107f68:	55                   	push   %ebp
80107f69:	89 e5                	mov    %esp,%ebp
80107f6b:	83 ec 48             	sub    $0x48,%esp
80107f6e:	e8 73 f9 ff ff       	call   801078e6 <setupkvm>
80107f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f7a:	75 0a                	jne    80107f86 <copyuvm+0x1e>
80107f7c:	b8 00 00 00 00       	mov    $0x0,%eax
80107f81:	e9 f8 00 00 00       	jmp    8010807e <copyuvm+0x116>
80107f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f8d:	e9 cb 00 00 00       	jmp    8010805d <copyuvm+0xf5>
80107f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f9c:	00 
80107f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa4:	89 04 24             	mov    %eax,(%esp)
80107fa7:	e8 08 f8 ff ff       	call   801077b4 <walkpgdir>
80107fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107faf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107fb3:	75 0c                	jne    80107fc1 <copyuvm+0x59>
80107fb5:	c7 04 24 ba 88 10 80 	movl   $0x801088ba,(%esp)
80107fbc:	e8 93 85 ff ff       	call   80100554 <panic>
80107fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc4:	8b 00                	mov    (%eax),%eax
80107fc6:	83 e0 01             	and    $0x1,%eax
80107fc9:	85 c0                	test   %eax,%eax
80107fcb:	75 0c                	jne    80107fd9 <copyuvm+0x71>
80107fcd:	c7 04 24 d4 88 10 80 	movl   $0x801088d4,(%esp)
80107fd4:	e8 7b 85 ff ff       	call   80100554 <panic>
80107fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fdc:	8b 00                	mov    (%eax),%eax
80107fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fe3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fe9:	8b 00                	mov    (%eax),%eax
80107feb:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ff3:	e8 03 ac ff ff       	call   80102bfb <kalloc>
80107ff8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ffb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107fff:	75 02                	jne    80108003 <copyuvm+0x9b>
80108001:	eb 6b                	jmp    8010806e <copyuvm+0x106>
80108003:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108006:	05 00 00 00 80       	add    $0x80000000,%eax
8010800b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108012:	00 
80108013:	89 44 24 04          	mov    %eax,0x4(%esp)
80108017:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010801a:	89 04 24             	mov    %eax,(%esp)
8010801d:	e8 d5 d0 ff ff       	call   801050f7 <memmove>
80108022:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108025:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108028:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010802e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108031:	89 54 24 10          	mov    %edx,0x10(%esp)
80108035:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108039:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108040:	00 
80108041:	89 44 24 04          	mov    %eax,0x4(%esp)
80108045:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108048:	89 04 24             	mov    %eax,(%esp)
8010804b:	e8 00 f8 ff ff       	call   80107850 <mappages>
80108050:	85 c0                	test   %eax,%eax
80108052:	79 02                	jns    80108056 <copyuvm+0xee>
80108054:	eb 18                	jmp    8010806e <copyuvm+0x106>
80108056:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010805d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108060:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108063:	0f 82 29 ff ff ff    	jb     80107f92 <copyuvm+0x2a>
80108069:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010806c:	eb 10                	jmp    8010807e <copyuvm+0x116>
8010806e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108071:	89 04 24             	mov    %eax,(%esp)
80108074:	e8 13 fe ff ff       	call   80107e8c <freevm>
80108079:	b8 00 00 00 00       	mov    $0x0,%eax
8010807e:	c9                   	leave  
8010807f:	c3                   	ret    

80108080 <uva2ka>:
80108080:	55                   	push   %ebp
80108081:	89 e5                	mov    %esp,%ebp
80108083:	83 ec 28             	sub    $0x28,%esp
80108086:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010808d:	00 
8010808e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108091:	89 44 24 04          	mov    %eax,0x4(%esp)
80108095:	8b 45 08             	mov    0x8(%ebp),%eax
80108098:	89 04 24             	mov    %eax,(%esp)
8010809b:	e8 14 f7 ff ff       	call   801077b4 <walkpgdir>
801080a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a6:	8b 00                	mov    (%eax),%eax
801080a8:	83 e0 01             	and    $0x1,%eax
801080ab:	85 c0                	test   %eax,%eax
801080ad:	75 07                	jne    801080b6 <uva2ka+0x36>
801080af:	b8 00 00 00 00       	mov    $0x0,%eax
801080b4:	eb 22                	jmp    801080d8 <uva2ka+0x58>
801080b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b9:	8b 00                	mov    (%eax),%eax
801080bb:	83 e0 04             	and    $0x4,%eax
801080be:	85 c0                	test   %eax,%eax
801080c0:	75 07                	jne    801080c9 <uva2ka+0x49>
801080c2:	b8 00 00 00 00       	mov    $0x0,%eax
801080c7:	eb 0f                	jmp    801080d8 <uva2ka+0x58>
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	8b 00                	mov    (%eax),%eax
801080ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d3:	05 00 00 00 80       	add    $0x80000000,%eax
801080d8:	c9                   	leave  
801080d9:	c3                   	ret    

801080da <copyout>:
801080da:	55                   	push   %ebp
801080db:	89 e5                	mov    %esp,%ebp
801080dd:	83 ec 28             	sub    $0x28,%esp
801080e0:	8b 45 10             	mov    0x10(%ebp),%eax
801080e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080e6:	e9 87 00 00 00       	jmp    80108172 <copyout+0x98>
801080eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801080fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108100:	89 04 24             	mov    %eax,(%esp)
80108103:	e8 78 ff ff ff       	call   80108080 <uva2ka>
80108108:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010810b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010810f:	75 07                	jne    80108118 <copyout+0x3e>
80108111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108116:	eb 69                	jmp    80108181 <copyout+0xa7>
80108118:	8b 45 0c             	mov    0xc(%ebp),%eax
8010811b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010811e:	29 c2                	sub    %eax,%edx
80108120:	89 d0                	mov    %edx,%eax
80108122:	05 00 10 00 00       	add    $0x1000,%eax
80108127:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010812a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010812d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108130:	76 06                	jbe    80108138 <copyout+0x5e>
80108132:	8b 45 14             	mov    0x14(%ebp),%eax
80108135:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108138:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010813b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010813e:	29 c2                	sub    %eax,%edx
80108140:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108143:	01 c2                	add    %eax,%edx
80108145:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108148:	89 44 24 08          	mov    %eax,0x8(%esp)
8010814c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108153:	89 14 24             	mov    %edx,(%esp)
80108156:	e8 9c cf ff ff       	call   801050f7 <memmove>
8010815b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815e:	29 45 14             	sub    %eax,0x14(%ebp)
80108161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108164:	01 45 f4             	add    %eax,-0xc(%ebp)
80108167:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010816a:	05 00 10 00 00       	add    $0x1000,%eax
8010816f:	89 45 0c             	mov    %eax,0xc(%ebp)
80108172:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108176:	0f 85 6f ff ff ff    	jne    801080eb <copyout+0x11>
8010817c:	b8 00 00 00 00       	mov    $0x0,%eax
80108181:	c9                   	leave  
80108182:	c3                   	ret    
