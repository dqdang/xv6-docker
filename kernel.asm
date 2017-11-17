
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
8010002d:	b8 ba 3b 10 80       	mov    $0x80103bba,%eax
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
8010003a:	c7 44 24 04 98 85 10 	movl   $0x80108598,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100049:	e8 70 51 00 00       	call   801051be <initlock>

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
80100087:	c7 44 24 04 9f 85 10 	movl   $0x8010859f,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 e9 4f 00 00       	call   80105080 <initsleeplock>
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
801000c9:	e8 11 51 00 00       	call   801051df <acquire>

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
80100104:	e8 40 51 00 00       	call   80105249 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 a3 4f 00 00       	call   801050ba <acquiresleep>
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
8010017d:	e8 c7 50 00 00       	call   80105249 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 2a 4f 00 00       	call   801050ba <acquiresleep>
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
801001a7:	c7 04 24 a6 85 10 80 	movl   $0x801085a6,(%esp)
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
801001e2:	e8 0a 2b 00 00       	call   80102cf1 <iderw>
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
801001fb:	e8 57 4f 00 00       	call   80105157 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 b7 85 10 80 	movl   $0x801085b7,(%esp)
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
80100225:	e8 c7 2a 00 00       	call   80102cf1 <iderw>
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
8010023b:	e8 17 4f 00 00       	call   80105157 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 be 85 10 80 	movl   $0x801085be,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 b7 4e 00 00       	call   80105115 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100265:	e8 75 4f 00 00       	call   801051df <acquire>
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
801002d1:	e8 73 4f 00 00       	call   80105249 <release>
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
801003dc:	e8 fe 4d 00 00       	call   801051df <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 c5 85 10 80 	movl   $0x801085c5,(%esp)
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
801004cf:	c7 45 ec ce 85 10 80 	movl   $0x801085ce,-0x14(%ebp)
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
8010054d:	e8 f7 4c 00 00       	call   80105249 <release>
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
80100569:	e8 1f 2e 00 00       	call   8010338d <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 d5 85 10 80 	movl   $0x801085d5,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 e9 85 10 80 	movl   $0x801085e9,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 ef 4c 00 00       	call   80105296 <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 eb 85 10 80 	movl   $0x801085eb,(%esp)
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
80100695:	c7 04 24 ef 85 10 80 	movl   $0x801085ef,(%esp)
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
801006c9:	e8 3d 4e 00 00       	call   8010550b <memmove>
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
801006f8:	e8 45 4d 00 00       	call   80105442 <memset>
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
8010078e:	e8 85 65 00 00       	call   80106d18 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 79 65 00 00       	call   80106d18 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 6d 65 00 00       	call   80106d18 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 60 65 00 00       	call   80106d18 <uartputc>
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
801007c8:	56                   	push   %esi
801007c9:	53                   	push   %ebx
801007ca:	83 ec 20             	sub    $0x20,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
801007cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801007d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&cons.lock);
801007db:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801007e2:	e8 f8 49 00 00       	call   801051df <acquire>
  while((c = getc()) >= 0){
801007e7:	e9 c3 04 00 00       	jmp    80100caf <consoleintr+0x4ea>
    switch(c){
801007ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801007ef:	83 f8 14             	cmp    $0x14,%eax
801007f2:	74 3b                	je     8010082f <consoleintr+0x6a>
801007f4:	83 f8 14             	cmp    $0x14,%eax
801007f7:	7f 13                	jg     8010080c <consoleintr+0x47>
801007f9:	83 f8 08             	cmp    $0x8,%eax
801007fc:	0f 84 47 02 00 00    	je     80100a49 <consoleintr+0x284>
80100802:	83 f8 10             	cmp    $0x10,%eax
80100805:	74 1c                	je     80100823 <consoleintr+0x5e>
80100807:	e9 e2 02 00 00       	jmp    80100aee <consoleintr+0x329>
8010080c:	83 f8 15             	cmp    $0x15,%eax
8010080f:	0f 84 8b 01 00 00    	je     801009a0 <consoleintr+0x1db>
80100815:	83 f8 7f             	cmp    $0x7f,%eax
80100818:	0f 84 2b 02 00 00    	je     80100a49 <consoleintr+0x284>
8010081e:	e9 cb 02 00 00       	jmp    80100aee <consoleintr+0x329>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100823:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010082a:	e9 80 04 00 00       	jmp    80100caf <consoleintr+0x4ea>
    case C('T'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      if (active == 1){
8010082f:	a1 00 90 10 80       	mov    0x80109000,%eax
80100834:	83 f8 01             	cmp    $0x1,%eax
80100837:	75 0c                	jne    80100845 <consoleintr+0x80>
        active = 2;
80100839:	c7 05 00 90 10 80 02 	movl   $0x2,0x80109000
80100840:	00 00 00 
      }else{
        active = 1;
      }
      while(inputs[active-1].e != inputs[active-1].w &&
80100843:	eb 5b                	jmp    801008a0 <consoleintr+0xdb>
    case C('T'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      if (active == 1){
        active = 2;
      }else{
        active = 1;
80100845:	c7 05 00 90 10 80 01 	movl   $0x1,0x80109000
8010084c:	00 00 00 
      }
      while(inputs[active-1].e != inputs[active-1].w &&
8010084f:	eb 4f                	jmp    801008a0 <consoleintr+0xdb>
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
        inputs[active-1].e--;
80100851:	a1 00 90 10 80       	mov    0x80109000,%eax
80100856:	8d 50 ff             	lea    -0x1(%eax),%edx
80100859:	89 d0                	mov    %edx,%eax
8010085b:	c1 e0 02             	shl    $0x2,%eax
8010085e:	01 d0                	add    %edx,%eax
80100860:	c1 e0 02             	shl    $0x2,%eax
80100863:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010086a:	29 c1                	sub    %eax,%ecx
8010086c:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100872:	8b 40 08             	mov    0x8(%eax),%eax
80100875:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100878:	89 d0                	mov    %edx,%eax
8010087a:	c1 e0 02             	shl    $0x2,%eax
8010087d:	01 d0                	add    %edx,%eax
8010087f:	c1 e0 02             	shl    $0x2,%eax
80100882:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100889:	29 c2                	sub    %eax,%edx
8010088b:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100891:	89 48 08             	mov    %ecx,0x8(%eax)
        consputc(BACKSPACE);
80100894:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010089b:	e8 c8 fe ff ff       	call   80100768 <consputc>
      if (active == 1){
        active = 2;
      }else{
        active = 1;
      }
      while(inputs[active-1].e != inputs[active-1].w &&
801008a0:	a1 00 90 10 80       	mov    0x80109000,%eax
801008a5:	8d 50 ff             	lea    -0x1(%eax),%edx
801008a8:	89 d0                	mov    %edx,%eax
801008aa:	c1 e0 02             	shl    $0x2,%eax
801008ad:	01 d0                	add    %edx,%eax
801008af:	c1 e0 02             	shl    $0x2,%eax
801008b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008b9:	29 c2                	sub    %eax,%edx
801008bb:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
801008c1:	8b 48 08             	mov    0x8(%eax),%ecx
801008c4:	a1 00 90 10 80       	mov    0x80109000,%eax
801008c9:	8d 50 ff             	lea    -0x1(%eax),%edx
801008cc:	89 d0                	mov    %edx,%eax
801008ce:	c1 e0 02             	shl    $0x2,%eax
801008d1:	01 d0                	add    %edx,%eax
801008d3:	c1 e0 02             	shl    $0x2,%eax
801008d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008dd:	29 c2                	sub    %eax,%edx
801008df:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
801008e5:	8b 40 04             	mov    0x4(%eax),%eax
801008e8:	39 c1                	cmp    %eax,%ecx
801008ea:	74 57                	je     80100943 <consoleintr+0x17e>
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
801008ec:	a1 00 90 10 80       	mov    0x80109000,%eax
801008f1:	8d 48 ff             	lea    -0x1(%eax),%ecx
801008f4:	a1 00 90 10 80       	mov    0x80109000,%eax
801008f9:	8d 50 ff             	lea    -0x1(%eax),%edx
801008fc:	89 d0                	mov    %edx,%eax
801008fe:	c1 e0 02             	shl    $0x2,%eax
80100901:	01 d0                	add    %edx,%eax
80100903:	c1 e0 02             	shl    $0x2,%eax
80100906:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010090d:	29 c2                	sub    %eax,%edx
8010090f:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100915:	8b 40 08             	mov    0x8(%eax),%eax
80100918:	48                   	dec    %eax
80100919:	83 e0 7f             	and    $0x7f,%eax
8010091c:	89 c3                	mov    %eax,%ebx
8010091e:	89 c8                	mov    %ecx,%eax
80100920:	c1 e0 02             	shl    $0x2,%eax
80100923:	01 c8                	add    %ecx,%eax
80100925:	c1 e0 02             	shl    $0x2,%eax
80100928:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010092f:	29 c2                	sub    %eax,%edx
80100931:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80100934:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100939:	8a 00                	mov    (%eax),%al
      if (active == 1){
        active = 2;
      }else{
        active = 1;
      }
      while(inputs[active-1].e != inputs[active-1].w &&
8010093b:	3c 0a                	cmp    $0xa,%al
8010093d:	0f 85 0e ff ff ff    	jne    80100851 <consoleintr+0x8c>
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
        inputs[active-1].e--;
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
80100943:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
8010094a:	e9 60 03 00 00       	jmp    80100caf <consoleintr+0x4ea>
    case C('U'):  // Kill line.
      while(inputs[active-1].e != inputs[active-1].w &&
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
        inputs[active-1].e--;
8010094f:	a1 00 90 10 80       	mov    0x80109000,%eax
80100954:	8d 50 ff             	lea    -0x1(%eax),%edx
80100957:	89 d0                	mov    %edx,%eax
80100959:	c1 e0 02             	shl    $0x2,%eax
8010095c:	01 d0                	add    %edx,%eax
8010095e:	c1 e0 02             	shl    $0x2,%eax
80100961:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80100968:	29 c1                	sub    %eax,%ecx
8010096a:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100970:	8b 40 08             	mov    0x8(%eax),%eax
80100973:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100976:	89 d0                	mov    %edx,%eax
80100978:	c1 e0 02             	shl    $0x2,%eax
8010097b:	01 d0                	add    %edx,%eax
8010097d:	c1 e0 02             	shl    $0x2,%eax
80100980:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100987:	29 c2                	sub    %eax,%edx
80100989:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
8010098f:	89 48 08             	mov    %ecx,0x8(%eax)
        consputc(BACKSPACE);
80100992:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100999:	e8 ca fd ff ff       	call   80100768 <consputc>
8010099e:	eb 01                	jmp    801009a1 <consoleintr+0x1dc>
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(inputs[active-1].e != inputs[active-1].w &&
801009a0:	90                   	nop
801009a1:	a1 00 90 10 80       	mov    0x80109000,%eax
801009a6:	8d 50 ff             	lea    -0x1(%eax),%edx
801009a9:	89 d0                	mov    %edx,%eax
801009ab:	c1 e0 02             	shl    $0x2,%eax
801009ae:	01 d0                	add    %edx,%eax
801009b0:	c1 e0 02             	shl    $0x2,%eax
801009b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801009ba:	29 c2                	sub    %eax,%edx
801009bc:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
801009c2:	8b 48 08             	mov    0x8(%eax),%ecx
801009c5:	a1 00 90 10 80       	mov    0x80109000,%eax
801009ca:	8d 50 ff             	lea    -0x1(%eax),%edx
801009cd:	89 d0                	mov    %edx,%eax
801009cf:	c1 e0 02             	shl    $0x2,%eax
801009d2:	01 d0                	add    %edx,%eax
801009d4:	c1 e0 02             	shl    $0x2,%eax
801009d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801009de:	29 c2                	sub    %eax,%edx
801009e0:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
801009e6:	8b 40 04             	mov    0x4(%eax),%eax
801009e9:	39 c1                	cmp    %eax,%ecx
801009eb:	74 57                	je     80100a44 <consoleintr+0x27f>
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
801009ed:	a1 00 90 10 80       	mov    0x80109000,%eax
801009f2:	8d 48 ff             	lea    -0x1(%eax),%ecx
801009f5:	a1 00 90 10 80       	mov    0x80109000,%eax
801009fa:	8d 50 ff             	lea    -0x1(%eax),%edx
801009fd:	89 d0                	mov    %edx,%eax
801009ff:	c1 e0 02             	shl    $0x2,%eax
80100a02:	01 d0                	add    %edx,%eax
80100a04:	c1 e0 02             	shl    $0x2,%eax
80100a07:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100a0e:	29 c2                	sub    %eax,%edx
80100a10:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100a16:	8b 40 08             	mov    0x8(%eax),%eax
80100a19:	48                   	dec    %eax
80100a1a:	83 e0 7f             	and    $0x7f,%eax
80100a1d:	89 c3                	mov    %eax,%ebx
80100a1f:	89 c8                	mov    %ecx,%eax
80100a21:	c1 e0 02             	shl    $0x2,%eax
80100a24:	01 c8                	add    %ecx,%eax
80100a26:	c1 e0 02             	shl    $0x2,%eax
80100a29:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100a30:	29 c2                	sub    %eax,%edx
80100a32:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80100a35:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100a3a:	8a 00                	mov    (%eax),%al
        consputc(BACKSPACE);
      }
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(inputs[active-1].e != inputs[active-1].w &&
80100a3c:	3c 0a                	cmp    $0xa,%al
80100a3e:	0f 85 0b ff ff ff    	jne    8010094f <consoleintr+0x18a>
            inputs[active-1].buf[(inputs[active-1].e-1) % INPUT_BUF] != '\n'){
        inputs[active-1].e--;
        consputc(BACKSPACE);
      }
      break;
80100a44:	e9 66 02 00 00       	jmp    80100caf <consoleintr+0x4ea>
    case C('H'): case '\x7f':  // Backspace
      if(inputs[active-1].e != inputs[active-1].w){
80100a49:	a1 00 90 10 80       	mov    0x80109000,%eax
80100a4e:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a51:	89 d0                	mov    %edx,%eax
80100a53:	c1 e0 02             	shl    $0x2,%eax
80100a56:	01 d0                	add    %edx,%eax
80100a58:	c1 e0 02             	shl    $0x2,%eax
80100a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100a62:	29 c2                	sub    %eax,%edx
80100a64:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100a6a:	8b 48 08             	mov    0x8(%eax),%ecx
80100a6d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100a72:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a75:	89 d0                	mov    %edx,%eax
80100a77:	c1 e0 02             	shl    $0x2,%eax
80100a7a:	01 d0                	add    %edx,%eax
80100a7c:	c1 e0 02             	shl    $0x2,%eax
80100a7f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100a86:	29 c2                	sub    %eax,%edx
80100a88:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100a8e:	8b 40 04             	mov    0x4(%eax),%eax
80100a91:	39 c1                	cmp    %eax,%ecx
80100a93:	74 54                	je     80100ae9 <consoleintr+0x324>
        inputs[active-1].e--;
80100a95:	a1 00 90 10 80       	mov    0x80109000,%eax
80100a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a9d:	89 d0                	mov    %edx,%eax
80100a9f:	c1 e0 02             	shl    $0x2,%eax
80100aa2:	01 d0                	add    %edx,%eax
80100aa4:	c1 e0 02             	shl    $0x2,%eax
80100aa7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80100aae:	29 c1                	sub    %eax,%ecx
80100ab0:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100ab6:	8b 40 08             	mov    0x8(%eax),%eax
80100ab9:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100abc:	89 d0                	mov    %edx,%eax
80100abe:	c1 e0 02             	shl    $0x2,%eax
80100ac1:	01 d0                	add    %edx,%eax
80100ac3:	c1 e0 02             	shl    $0x2,%eax
80100ac6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100acd:	29 c2                	sub    %eax,%edx
80100acf:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100ad5:	89 48 08             	mov    %ecx,0x8(%eax)
        consputc(BACKSPACE);
80100ad8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100adf:	e8 84 fc ff ff       	call   80100768 <consputc>
      }
      break;
80100ae4:	e9 c6 01 00 00       	jmp    80100caf <consoleintr+0x4ea>
80100ae9:	e9 c1 01 00 00       	jmp    80100caf <consoleintr+0x4ea>
    default:
      if(c != 0 && inputs[active-1].e-inputs[active-1].r < INPUT_BUF){
80100aee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100af2:	0f 84 b6 01 00 00    	je     80100cae <consoleintr+0x4e9>
80100af8:	a1 00 90 10 80       	mov    0x80109000,%eax
80100afd:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b00:	89 d0                	mov    %edx,%eax
80100b02:	c1 e0 02             	shl    $0x2,%eax
80100b05:	01 d0                	add    %edx,%eax
80100b07:	c1 e0 02             	shl    $0x2,%eax
80100b0a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100b11:	29 c2                	sub    %eax,%edx
80100b13:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100b19:	8b 48 08             	mov    0x8(%eax),%ecx
80100b1c:	a1 00 90 10 80       	mov    0x80109000,%eax
80100b21:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b24:	89 d0                	mov    %edx,%eax
80100b26:	c1 e0 02             	shl    $0x2,%eax
80100b29:	01 d0                	add    %edx,%eax
80100b2b:	c1 e0 02             	shl    $0x2,%eax
80100b2e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100b35:	29 c2                	sub    %eax,%edx
80100b37:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100b3d:	8b 00                	mov    (%eax),%eax
80100b3f:	29 c1                	sub    %eax,%ecx
80100b41:	89 c8                	mov    %ecx,%eax
80100b43:	83 f8 7f             	cmp    $0x7f,%eax
80100b46:	0f 87 62 01 00 00    	ja     80100cae <consoleintr+0x4e9>
        c = (c == '\r') ? '\n' : c;
80100b4c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80100b50:	74 05                	je     80100b57 <consoleintr+0x392>
80100b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b55:	eb 05                	jmp    80100b5c <consoleintr+0x397>
80100b57:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        inputs[active-1].buf[inputs[active-1].e++ % INPUT_BUF] = c;
80100b5f:	a1 00 90 10 80       	mov    0x80109000,%eax
80100b64:	8d 70 ff             	lea    -0x1(%eax),%esi
80100b67:	a1 00 90 10 80       	mov    0x80109000,%eax
80100b6c:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b6f:	89 d0                	mov    %edx,%eax
80100b71:	c1 e0 02             	shl    $0x2,%eax
80100b74:	01 d0                	add    %edx,%eax
80100b76:	c1 e0 02             	shl    $0x2,%eax
80100b79:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80100b80:	29 c1                	sub    %eax,%ecx
80100b82:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100b88:	8b 48 08             	mov    0x8(%eax),%ecx
80100b8b:	8d 59 01             	lea    0x1(%ecx),%ebx
80100b8e:	89 d0                	mov    %edx,%eax
80100b90:	c1 e0 02             	shl    $0x2,%eax
80100b93:	01 d0                	add    %edx,%eax
80100b95:	c1 e0 02             	shl    $0x2,%eax
80100b98:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100b9f:	29 c2                	sub    %eax,%edx
80100ba1:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100ba7:	89 58 08             	mov    %ebx,0x8(%eax)
80100baa:	89 cb                	mov    %ecx,%ebx
80100bac:	83 e3 7f             	and    $0x7f,%ebx
80100baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100bb2:	88 c1                	mov    %al,%cl
80100bb4:	89 f0                	mov    %esi,%eax
80100bb6:	c1 e0 02             	shl    $0x2,%eax
80100bb9:	01 f0                	add    %esi,%eax
80100bbb:	c1 e0 02             	shl    $0x2,%eax
80100bbe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100bc5:	29 c2                	sub    %eax,%edx
80100bc7:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80100bca:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100bcf:	88 08                	mov    %cl,(%eax)
        consputc(c);
80100bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100bd4:	89 04 24             	mov    %eax,(%esp)
80100bd7:	e8 8c fb ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || inputs[active-1].e == inputs[active-1].r+INPUT_BUF){
80100bdc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100be0:	74 54                	je     80100c36 <consoleintr+0x471>
80100be2:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100be6:	74 4e                	je     80100c36 <consoleintr+0x471>
80100be8:	a1 00 90 10 80       	mov    0x80109000,%eax
80100bed:	8d 50 ff             	lea    -0x1(%eax),%edx
80100bf0:	89 d0                	mov    %edx,%eax
80100bf2:	c1 e0 02             	shl    $0x2,%eax
80100bf5:	01 d0                	add    %edx,%eax
80100bf7:	c1 e0 02             	shl    $0x2,%eax
80100bfa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100c01:	29 c2                	sub    %eax,%edx
80100c03:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100c09:	8b 48 08             	mov    0x8(%eax),%ecx
80100c0c:	a1 00 90 10 80       	mov    0x80109000,%eax
80100c11:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c14:	89 d0                	mov    %edx,%eax
80100c16:	c1 e0 02             	shl    $0x2,%eax
80100c19:	01 d0                	add    %edx,%eax
80100c1b:	c1 e0 02             	shl    $0x2,%eax
80100c1e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100c25:	29 c2                	sub    %eax,%edx
80100c27:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100c2d:	8b 00                	mov    (%eax),%eax
80100c2f:	83 e8 80             	sub    $0xffffff80,%eax
80100c32:	39 c1                	cmp    %eax,%ecx
80100c34:	75 78                	jne    80100cae <consoleintr+0x4e9>
          inputs[active-1].w = inputs[active-1].e;
80100c36:	a1 00 90 10 80       	mov    0x80109000,%eax
80100c3b:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100c3e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100c43:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c46:	89 d0                	mov    %edx,%eax
80100c48:	c1 e0 02             	shl    $0x2,%eax
80100c4b:	01 d0                	add    %edx,%eax
80100c4d:	c1 e0 02             	shl    $0x2,%eax
80100c50:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100c57:	29 c2                	sub    %eax,%edx
80100c59:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100c5f:	8b 48 08             	mov    0x8(%eax),%ecx
80100c62:	89 d8                	mov    %ebx,%eax
80100c64:	c1 e0 02             	shl    $0x2,%eax
80100c67:	01 d8                	add    %ebx,%eax
80100c69:	c1 e0 02             	shl    $0x2,%eax
80100c6c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100c73:	29 c2                	sub    %eax,%edx
80100c75:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100c7b:	89 48 04             	mov    %ecx,0x4(%eax)
          wakeup(&inputs[active-1].r);
80100c7e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100c83:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c86:	89 d0                	mov    %edx,%eax
80100c88:	c1 e0 02             	shl    $0x2,%eax
80100c8b:	01 d0                	add    %edx,%eax
80100c8d:	c1 e0 02             	shl    $0x2,%eax
80100c90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100c97:	29 c2                	sub    %eax,%edx
80100c99:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80100c9f:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100ca4:	89 04 24             	mov    %eax,(%esp)
80100ca7:	e8 38 42 00 00       	call   80104ee4 <wakeup>
        }
      }
      break;
80100cac:	eb 00                	jmp    80100cae <consoleintr+0x4e9>
80100cae:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100caf:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb2:	ff d0                	call   *%eax
80100cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100cb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100cbb:	0f 89 2b fb ff ff    	jns    801007ec <consoleintr+0x27>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100cc1:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100cc8:	e8 7c 45 00 00       	call   80105249 <release>
  if(doprocdump){
80100ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100cd1:	74 05                	je     80100cd8 <consoleintr+0x513>
    procdump();  // now call procdump() wo. cons.lock held
80100cd3:	e8 af 42 00 00       	call   80104f87 <procdump>
  }
  if(doconsoleswitch){
80100cd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100cdc:	74 15                	je     80100cf3 <consoleintr+0x52e>
    cprintf("\nActive console now: %d\n", active);
80100cde:	a1 00 90 10 80       	mov    0x80109000,%eax
80100ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce7:	c7 04 24 02 86 10 80 	movl   $0x80108602,(%esp)
80100cee:	e8 ce f6 ff ff       	call   801003c1 <cprintf>
  }
}
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	5b                   	pop    %ebx
80100cf7:	5e                   	pop    %esi
80100cf8:	5d                   	pop    %ebp
80100cf9:	c3                   	ret    

80100cfa <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100cfa:	55                   	push   %ebp
80100cfb:	89 e5                	mov    %esp,%ebp
80100cfd:	56                   	push   %esi
80100cfe:	53                   	push   %ebx
80100cff:	83 ec 20             	sub    $0x20,%esp
  uint target;
  int c;

  iunlock(ip);
80100d02:	8b 45 08             	mov    0x8(%ebp),%eax
80100d05:	89 04 24             	mov    %eax,(%esp)
80100d08:	e8 db 11 00 00       	call   80101ee8 <iunlock>
  target = n;
80100d0d:	8b 45 10             	mov    0x10(%ebp),%eax
80100d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100d13:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100d1a:	e8 c0 44 00 00       	call   801051df <acquire>
  while(n > 0){
80100d1f:	e9 a5 01 00 00       	jmp    80100ec9 <consoleread+0x1cf>
    while(inputs[active-1].r == inputs[active-1].w || active != ip->minor){
80100d24:	eb 63                	jmp    80100d89 <consoleread+0x8f>
      if(myproc()->killed){
80100d26:	e8 a4 38 00 00       	call   801045cf <myproc>
80100d2b:	8b 40 24             	mov    0x24(%eax),%eax
80100d2e:	85 c0                	test   %eax,%eax
80100d30:	74 21                	je     80100d53 <consoleread+0x59>
        release(&cons.lock);
80100d32:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100d39:	e8 0b 45 00 00       	call   80105249 <release>
        ilock(ip);
80100d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80100d41:	89 04 24             	mov    %eax,(%esp)
80100d44:	e8 95 10 00 00       	call   80101dde <ilock>
        return -1;
80100d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d4e:	e9 a1 01 00 00       	jmp    80100ef4 <consoleread+0x1fa>
      }
      sleep(&inputs[active-1].r, &cons.lock);
80100d53:	a1 00 90 10 80       	mov    0x80109000,%eax
80100d58:	8d 50 ff             	lea    -0x1(%eax),%edx
80100d5b:	89 d0                	mov    %edx,%eax
80100d5d:	c1 e0 02             	shl    $0x2,%eax
80100d60:	01 d0                	add    %edx,%eax
80100d62:	c1 e0 02             	shl    $0x2,%eax
80100d65:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100d6c:	29 c2                	sub    %eax,%edx
80100d6e:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80100d74:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100d79:	c7 44 24 04 a0 b5 10 	movl   $0x8010b5a0,0x4(%esp)
80100d80:	80 
80100d81:	89 04 24             	mov    %eax,(%esp)
80100d84:	e8 87 40 00 00       	call   80104e10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(inputs[active-1].r == inputs[active-1].w || active != ip->minor){
80100d89:	a1 00 90 10 80       	mov    0x80109000,%eax
80100d8e:	8d 50 ff             	lea    -0x1(%eax),%edx
80100d91:	89 d0                	mov    %edx,%eax
80100d93:	c1 e0 02             	shl    $0x2,%eax
80100d96:	01 d0                	add    %edx,%eax
80100d98:	c1 e0 02             	shl    $0x2,%eax
80100d9b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100da2:	29 c2                	sub    %eax,%edx
80100da4:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100daa:	8b 08                	mov    (%eax),%ecx
80100dac:	a1 00 90 10 80       	mov    0x80109000,%eax
80100db1:	8d 50 ff             	lea    -0x1(%eax),%edx
80100db4:	89 d0                	mov    %edx,%eax
80100db6:	c1 e0 02             	shl    $0x2,%eax
80100db9:	01 d0                	add    %edx,%eax
80100dbb:	c1 e0 02             	shl    $0x2,%eax
80100dbe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100dc5:	29 c2                	sub    %eax,%edx
80100dc7:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100dcd:	8b 40 04             	mov    0x4(%eax),%eax
80100dd0:	39 c1                	cmp    %eax,%ecx
80100dd2:	0f 84 4e ff ff ff    	je     80100d26 <consoleread+0x2c>
80100dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ddb:	8b 40 54             	mov    0x54(%eax),%eax
80100dde:	0f bf d0             	movswl %ax,%edx
80100de1:	a1 00 90 10 80       	mov    0x80109000,%eax
80100de6:	39 c2                	cmp    %eax,%edx
80100de8:	0f 85 38 ff ff ff    	jne    80100d26 <consoleread+0x2c>
        ilock(ip);
        return -1;
      }
      sleep(&inputs[active-1].r, &cons.lock);
    }
    c = inputs[active-1].buf[inputs[active-1].r++ % INPUT_BUF];
80100dee:	a1 00 90 10 80       	mov    0x80109000,%eax
80100df3:	8d 70 ff             	lea    -0x1(%eax),%esi
80100df6:	a1 00 90 10 80       	mov    0x80109000,%eax
80100dfb:	8d 50 ff             	lea    -0x1(%eax),%edx
80100dfe:	89 d0                	mov    %edx,%eax
80100e00:	c1 e0 02             	shl    $0x2,%eax
80100e03:	01 d0                	add    %edx,%eax
80100e05:	c1 e0 02             	shl    $0x2,%eax
80100e08:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80100e0f:	29 c1                	sub    %eax,%ecx
80100e11:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100e17:	8b 08                	mov    (%eax),%ecx
80100e19:	8d 59 01             	lea    0x1(%ecx),%ebx
80100e1c:	89 d0                	mov    %edx,%eax
80100e1e:	c1 e0 02             	shl    $0x2,%eax
80100e21:	01 d0                	add    %edx,%eax
80100e23:	c1 e0 02             	shl    $0x2,%eax
80100e26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100e2d:	29 c2                	sub    %eax,%edx
80100e2f:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100e35:	89 18                	mov    %ebx,(%eax)
80100e37:	83 e1 7f             	and    $0x7f,%ecx
80100e3a:	89 f0                	mov    %esi,%eax
80100e3c:	c1 e0 02             	shl    $0x2,%eax
80100e3f:	01 f0                	add    %esi,%eax
80100e41:	c1 e0 02             	shl    $0x2,%eax
80100e44:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100e4b:	29 c2                	sub    %eax,%edx
80100e4d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
80100e50:	05 a0 0f 11 80       	add    $0x80110fa0,%eax
80100e55:	8a 00                	mov    (%eax),%al
80100e57:	0f be c0             	movsbl %al,%eax
80100e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100e5d:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100e61:	75 4d                	jne    80100eb0 <consoleread+0x1b6>
      if(n < target){
80100e63:	8b 45 10             	mov    0x10(%ebp),%eax
80100e66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100e69:	73 43                	jae    80100eae <consoleread+0x1b4>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        inputs[active-1].r--;
80100e6b:	a1 00 90 10 80       	mov    0x80109000,%eax
80100e70:	8d 50 ff             	lea    -0x1(%eax),%edx
80100e73:	89 d0                	mov    %edx,%eax
80100e75:	c1 e0 02             	shl    $0x2,%eax
80100e78:	01 d0                	add    %edx,%eax
80100e7a:	c1 e0 02             	shl    $0x2,%eax
80100e7d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80100e84:	29 c1                	sub    %eax,%ecx
80100e86:	8d 81 20 10 11 80    	lea    -0x7feeefe0(%ecx),%eax
80100e8c:	8b 00                	mov    (%eax),%eax
80100e8e:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100e91:	89 d0                	mov    %edx,%eax
80100e93:	c1 e0 02             	shl    $0x2,%eax
80100e96:	01 d0                	add    %edx,%eax
80100e98:	c1 e0 02             	shl    $0x2,%eax
80100e9b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100ea2:	29 c2                	sub    %eax,%edx
80100ea4:	8d 82 20 10 11 80    	lea    -0x7feeefe0(%edx),%eax
80100eaa:	89 08                	mov    %ecx,(%eax)
      }
      break;
80100eac:	eb 25                	jmp    80100ed3 <consoleread+0x1d9>
80100eae:	eb 23                	jmp    80100ed3 <consoleread+0x1d9>
    }
    *dst++ = c;
80100eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb3:	8d 50 01             	lea    0x1(%eax),%edx
80100eb6:	89 55 0c             	mov    %edx,0xc(%ebp)
80100eb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100ebc:	88 10                	mov    %dl,(%eax)
    --n;
80100ebe:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100ec1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ec5:	75 02                	jne    80100ec9 <consoleread+0x1cf>
      break;
80100ec7:	eb 0a                	jmp    80100ed3 <consoleread+0x1d9>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ecd:	0f 8f 51 fe ff ff    	jg     80100d24 <consoleread+0x2a>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100ed3:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100eda:	e8 6a 43 00 00       	call   80105249 <release>
  ilock(ip);
80100edf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 f4 0e 00 00       	call   80101dde <ilock>

  return target - n;
80100eea:	8b 45 10             	mov    0x10(%ebp),%eax
80100eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ef0:	29 c2                	sub    %eax,%edx
80100ef2:	89 d0                	mov    %edx,%eax
}
80100ef4:	83 c4 20             	add    $0x20,%esp
80100ef7:	5b                   	pop    %ebx
80100ef8:	5e                   	pop    %esi
80100ef9:	5d                   	pop    %ebp
80100efa:	c3                   	ret    

80100efb <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100efb:	55                   	push   %ebp
80100efc:	89 e5                	mov    %esp,%ebp
80100efe:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor){
80100f01:	8b 45 08             	mov    0x8(%ebp),%eax
80100f04:	8b 40 54             	mov    0x54(%eax),%eax
80100f07:	0f bf d0             	movswl %ax,%edx
80100f0a:	a1 00 90 10 80       	mov    0x80109000,%eax
80100f0f:	39 c2                	cmp    %eax,%edx
80100f11:	75 5a                	jne    80100f6d <consolewrite+0x72>
    iunlock(ip);
80100f13:	8b 45 08             	mov    0x8(%ebp),%eax
80100f16:	89 04 24             	mov    %eax,(%esp)
80100f19:	e8 ca 0f 00 00       	call   80101ee8 <iunlock>
    acquire(&cons.lock);
80100f1e:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100f25:	e8 b5 42 00 00       	call   801051df <acquire>
    for(i = 0; i < n; i++)
80100f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100f31:	eb 1b                	jmp    80100f4e <consolewrite+0x53>
      consputc(buf[i] & 0xff);
80100f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100f36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f39:	01 d0                	add    %edx,%eax
80100f3b:	8a 00                	mov    (%eax),%al
80100f3d:	0f be c0             	movsbl %al,%eax
80100f40:	0f b6 c0             	movzbl %al,%eax
80100f43:	89 04 24             	mov    %eax,(%esp)
80100f46:	e8 1d f8 ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100f4b:	ff 45 f4             	incl   -0xc(%ebp)
80100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f51:	3b 45 10             	cmp    0x10(%ebp),%eax
80100f54:	7c dd                	jl     80100f33 <consolewrite+0x38>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100f56:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100f5d:	e8 e7 42 00 00       	call   80105249 <release>
    ilock(ip);
80100f62:	8b 45 08             	mov    0x8(%ebp),%eax
80100f65:	89 04 24             	mov    %eax,(%esp)
80100f68:	e8 71 0e 00 00       	call   80101dde <ilock>
  }
  return n;
80100f6d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100f70:	c9                   	leave  
80100f71:	c3                   	ret    

80100f72 <consoleinit>:

void
consoleinit(void)
{
80100f72:	55                   	push   %ebp
80100f73:	89 e5                	mov    %esp,%ebp
80100f75:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100f78:	c7 44 24 04 1b 86 10 	movl   $0x8010861b,0x4(%esp)
80100f7f:	80 
80100f80:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100f87:	e8 32 42 00 00       	call   801051be <initlock>

  devsw[CONSOLE].write = consolewrite;
80100f8c:	c7 05 8c 1b 11 80 fb 	movl   $0x80100efb,0x80111b8c
80100f93:	0e 10 80 
  devsw[CONSOLE].read = consoleread;
80100f96:	c7 05 88 1b 11 80 fa 	movl   $0x80100cfa,0x80111b88
80100f9d:	0c 10 80 
  cons.locking = 1;
80100fa0:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100fa7:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100faa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100fb1:	00 
80100fb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100fb9:	e8 e5 1e 00 00       	call   80102ea3 <ioapicenable>
}
80100fbe:	c9                   	leave  
80100fbf:	c3                   	ret    

80100fc0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100fc9:	e8 01 36 00 00       	call   801045cf <myproc>
80100fce:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100fd1:	e8 01 29 00 00       	call   801038d7 <begin_op>

  if((ip = namei(path)) == 0){
80100fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd9:	89 04 24             	mov    %eax,(%esp)
80100fdc:	e8 22 19 00 00       	call   80102903 <namei>
80100fe1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100fe4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fe8:	75 1b                	jne    80101005 <exec+0x45>
    end_op();
80100fea:	e8 6a 29 00 00       	call   80103959 <end_op>
    cprintf("exec: fail\n");
80100fef:	c7 04 24 23 86 10 80 	movl   $0x80108623,(%esp)
80100ff6:	e8 c6 f3 ff ff       	call   801003c1 <cprintf>
    return -1;
80100ffb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101000:	e9 f6 03 00 00       	jmp    801013fb <exec+0x43b>
  }
  ilock(ip);
80101005:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101008:	89 04 24             	mov    %eax,(%esp)
8010100b:	e8 ce 0d 00 00       	call   80101dde <ilock>
  pgdir = 0;
80101010:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101017:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
8010101e:	00 
8010101f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101026:	00 
80101027:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
8010102d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101031:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101034:	89 04 24             	mov    %eax,(%esp)
80101037:	e8 39 12 00 00       	call   80102275 <readi>
8010103c:	83 f8 34             	cmp    $0x34,%eax
8010103f:	74 05                	je     80101046 <exec+0x86>
    goto bad;
80101041:	e9 89 03 00 00       	jmp    801013cf <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80101046:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
8010104c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80101051:	74 05                	je     80101058 <exec+0x98>
    goto bad;
80101053:	e9 77 03 00 00       	jmp    801013cf <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80101058:	e8 9d 6c 00 00       	call   80107cfa <setupkvm>
8010105d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101060:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101064:	75 05                	jne    8010106b <exec+0xab>
    goto bad;
80101066:	e9 64 03 00 00       	jmp    801013cf <exec+0x40f>

  // Load program into memory.
  sz = 0;
8010106b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101072:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101079:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
8010107f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101082:	e9 fb 00 00 00       	jmp    80101182 <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101087:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010108a:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80101091:	00 
80101092:	89 44 24 08          	mov    %eax,0x8(%esp)
80101096:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
8010109c:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010a3:	89 04 24             	mov    %eax,(%esp)
801010a6:	e8 ca 11 00 00       	call   80102275 <readi>
801010ab:	83 f8 20             	cmp    $0x20,%eax
801010ae:	74 05                	je     801010b5 <exec+0xf5>
      goto bad;
801010b0:	e9 1a 03 00 00       	jmp    801013cf <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
801010b5:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
801010bb:	83 f8 01             	cmp    $0x1,%eax
801010be:	74 05                	je     801010c5 <exec+0x105>
      continue;
801010c0:	e9 b1 00 00 00       	jmp    80101176 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
801010c5:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
801010cb:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
801010d1:	39 c2                	cmp    %eax,%edx
801010d3:	73 05                	jae    801010da <exec+0x11a>
      goto bad;
801010d5:	e9 f5 02 00 00       	jmp    801013cf <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801010da:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
801010e0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
801010e6:	01 c2                	add    %eax,%edx
801010e8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010ee:	39 c2                	cmp    %eax,%edx
801010f0:	73 05                	jae    801010f7 <exec+0x137>
      goto bad;
801010f2:	e9 d8 02 00 00       	jmp    801013cf <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801010f7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
801010fd:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80101103:	01 d0                	add    %edx,%eax
80101105:	89 44 24 08          	mov    %eax,0x8(%esp)
80101109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010110c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101110:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101113:	89 04 24             	mov    %eax,(%esp)
80101116:	e8 ab 6f 00 00       	call   801080c6 <allocuvm>
8010111b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010111e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101122:	75 05                	jne    80101129 <exec+0x169>
      goto bad;
80101124:	e9 a6 02 00 00       	jmp    801013cf <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80101129:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
8010112f:	25 ff 0f 00 00       	and    $0xfff,%eax
80101134:	85 c0                	test   %eax,%eax
80101136:	74 05                	je     8010113d <exec+0x17d>
      goto bad;
80101138:	e9 92 02 00 00       	jmp    801013cf <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010113d:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80101143:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80101149:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
8010114f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80101153:	89 54 24 0c          	mov    %edx,0xc(%esp)
80101157:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010115a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101162:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101165:	89 04 24             	mov    %eax,(%esp)
80101168:	e8 76 6e 00 00       	call   80107fe3 <loaduvm>
8010116d:	85 c0                	test   %eax,%eax
8010116f:	79 05                	jns    80101176 <exec+0x1b6>
      goto bad;
80101171:	e9 59 02 00 00       	jmp    801013cf <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101176:	ff 45 ec             	incl   -0x14(%ebp)
80101179:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010117c:	83 c0 20             	add    $0x20,%eax
8010117f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101182:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80101188:	0f b7 c0             	movzwl %ax,%eax
8010118b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010118e:	0f 8f f3 fe ff ff    	jg     80101087 <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80101194:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101197:	89 04 24             	mov    %eax,(%esp)
8010119a:	e8 3e 0e 00 00       	call   80101fdd <iunlockput>
  end_op();
8010119f:	e8 b5 27 00 00       	call   80103959 <end_op>
  ip = 0;
801011a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
801011ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011ae:	05 ff 0f 00 00       	add    $0xfff,%eax
801011b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801011b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011be:	05 00 20 00 00       	add    $0x2000,%eax
801011c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801011c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801011ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011d1:	89 04 24             	mov    %eax,(%esp)
801011d4:	e8 ed 6e 00 00       	call   801080c6 <allocuvm>
801011d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801011e0:	75 05                	jne    801011e7 <exec+0x227>
    goto bad;
801011e2:	e9 e8 01 00 00       	jmp    801013cf <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011ea:	2d 00 20 00 00       	sub    $0x2000,%eax
801011ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801011f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011f6:	89 04 24             	mov    %eax,(%esp)
801011f9:	e8 38 71 00 00       	call   80108336 <clearpteu>
  sp = sz;
801011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101201:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101204:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010120b:	e9 95 00 00 00       	jmp    801012a5 <exec+0x2e5>
    if(argc >= MAXARG)
80101210:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80101214:	76 05                	jbe    8010121b <exec+0x25b>
      goto bad;
80101216:	e9 b4 01 00 00       	jmp    801013cf <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010121b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010121e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101225:	8b 45 0c             	mov    0xc(%ebp),%eax
80101228:	01 d0                	add    %edx,%eax
8010122a:	8b 00                	mov    (%eax),%eax
8010122c:	89 04 24             	mov    %eax,(%esp)
8010122f:	e8 61 44 00 00       	call   80105695 <strlen>
80101234:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101237:	29 c2                	sub    %eax,%edx
80101239:	89 d0                	mov    %edx,%eax
8010123b:	48                   	dec    %eax
8010123c:	83 e0 fc             	and    $0xfffffffc,%eax
8010123f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010124c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010124f:	01 d0                	add    %edx,%eax
80101251:	8b 00                	mov    (%eax),%eax
80101253:	89 04 24             	mov    %eax,(%esp)
80101256:	e8 3a 44 00 00       	call   80105695 <strlen>
8010125b:	40                   	inc    %eax
8010125c:	89 c2                	mov    %eax,%edx
8010125e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101261:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80101268:	8b 45 0c             	mov    0xc(%ebp),%eax
8010126b:	01 c8                	add    %ecx,%eax
8010126d:	8b 00                	mov    (%eax),%eax
8010126f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80101273:	89 44 24 08          	mov    %eax,0x8(%esp)
80101277:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010127a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010127e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101281:	89 04 24             	mov    %eax,(%esp)
80101284:	e8 65 72 00 00       	call   801084ee <copyout>
80101289:	85 c0                	test   %eax,%eax
8010128b:	79 05                	jns    80101292 <exec+0x2d2>
      goto bad;
8010128d:	e9 3d 01 00 00       	jmp    801013cf <exec+0x40f>
    ustack[3+argc] = sp;
80101292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101295:	8d 50 03             	lea    0x3(%eax),%edx
80101298:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010129b:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
801012a2:	ff 45 e4             	incl   -0x1c(%ebp)
801012a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801012af:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b2:	01 d0                	add    %edx,%eax
801012b4:	8b 00                	mov    (%eax),%eax
801012b6:	85 c0                	test   %eax,%eax
801012b8:	0f 85 52 ff ff ff    	jne    80101210 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
801012be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012c1:	83 c0 03             	add    $0x3,%eax
801012c4:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
801012cb:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
801012cf:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
801012d6:	ff ff ff 
  ustack[1] = argc;
801012d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012dc:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012e5:	40                   	inc    %eax
801012e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801012ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f0:	29 d0                	sub    %edx,%eax
801012f2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
801012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012fb:	83 c0 04             	add    $0x4,%eax
801012fe:	c1 e0 02             	shl    $0x2,%eax
80101301:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101307:	83 c0 04             	add    $0x4,%eax
8010130a:	c1 e0 02             	shl    $0x2,%eax
8010130d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101311:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80101317:	89 44 24 08          	mov    %eax,0x8(%esp)
8010131b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010131e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101322:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101325:	89 04 24             	mov    %eax,(%esp)
80101328:	e8 c1 71 00 00       	call   801084ee <copyout>
8010132d:	85 c0                	test   %eax,%eax
8010132f:	79 05                	jns    80101336 <exec+0x376>
    goto bad;
80101331:	e9 99 00 00 00       	jmp    801013cf <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101336:	8b 45 08             	mov    0x8(%ebp),%eax
80101339:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101342:	eb 13                	jmp    80101357 <exec+0x397>
    if(*s == '/')
80101344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101347:	8a 00                	mov    (%eax),%al
80101349:	3c 2f                	cmp    $0x2f,%al
8010134b:	75 07                	jne    80101354 <exec+0x394>
      last = s+1;
8010134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101350:	40                   	inc    %eax
80101351:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101354:	ff 45 f4             	incl   -0xc(%ebp)
80101357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135a:	8a 00                	mov    (%eax),%al
8010135c:	84 c0                	test   %al,%al
8010135e:	75 e4                	jne    80101344 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101360:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101363:	8d 50 6c             	lea    0x6c(%eax),%edx
80101366:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010136d:	00 
8010136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101371:	89 44 24 04          	mov    %eax,0x4(%esp)
80101375:	89 14 24             	mov    %edx,(%esp)
80101378:	e8 d1 42 00 00       	call   8010564e <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
8010137d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101380:	8b 40 04             	mov    0x4(%eax),%eax
80101383:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80101386:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101389:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010138c:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
8010138f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101392:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101395:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80101397:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010139a:	8b 40 18             	mov    0x18(%eax),%eax
8010139d:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
801013a3:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801013a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801013a9:	8b 40 18             	mov    0x18(%eax),%eax
801013ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
801013af:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
801013b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
801013b5:	89 04 24             	mov    %eax,(%esp)
801013b8:	e8 17 6a 00 00       	call   80107dd4 <switchuvm>
  freevm(oldpgdir);
801013bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801013c0:	89 04 24             	mov    %eax,(%esp)
801013c3:	e8 d8 6e 00 00       	call   801082a0 <freevm>
  return 0;
801013c8:	b8 00 00 00 00       	mov    $0x0,%eax
801013cd:	eb 2c                	jmp    801013fb <exec+0x43b>

 bad:
  if(pgdir)
801013cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801013d3:	74 0b                	je     801013e0 <exec+0x420>
    freevm(pgdir);
801013d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801013d8:	89 04 24             	mov    %eax,(%esp)
801013db:	e8 c0 6e 00 00       	call   801082a0 <freevm>
  if(ip){
801013e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801013e4:	74 10                	je     801013f6 <exec+0x436>
    iunlockput(ip);
801013e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013e9:	89 04 24             	mov    %eax,(%esp)
801013ec:	e8 ec 0b 00 00       	call   80101fdd <iunlockput>
    end_op();
801013f1:	e8 63 25 00 00       	call   80103959 <end_op>
  }
  return -1;
801013f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013fb:	c9                   	leave  
801013fc:	c3                   	ret    
801013fd:	00 00                	add    %al,(%eax)
	...

80101400 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101406:	c7 44 24 04 2f 86 10 	movl   $0x8010862f,0x4(%esp)
8010140d:	80 
8010140e:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101415:	e8 a4 3d 00 00       	call   801051be <initlock>
}
8010141a:	c9                   	leave  
8010141b:	c3                   	ret    

8010141c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010141c:	55                   	push   %ebp
8010141d:	89 e5                	mov    %esp,%ebp
8010141f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101422:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101429:	e8 b1 3d 00 00       	call   801051df <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010142e:	c7 45 f4 14 12 11 80 	movl   $0x80111214,-0xc(%ebp)
80101435:	eb 29                	jmp    80101460 <filealloc+0x44>
    if(f->ref == 0){
80101437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010143a:	8b 40 04             	mov    0x4(%eax),%eax
8010143d:	85 c0                	test   %eax,%eax
8010143f:	75 1b                	jne    8010145c <filealloc+0x40>
      f->ref = 1;
80101441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101444:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010144b:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101452:	e8 f2 3d 00 00       	call   80105249 <release>
      return f;
80101457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010145a:	eb 1e                	jmp    8010147a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010145c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101460:	81 7d f4 74 1b 11 80 	cmpl   $0x80111b74,-0xc(%ebp)
80101467:	72 ce                	jb     80101437 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101469:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101470:	e8 d4 3d 00 00       	call   80105249 <release>
  return 0;
80101475:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010147a:	c9                   	leave  
8010147b:	c3                   	ret    

8010147c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010147c:	55                   	push   %ebp
8010147d:	89 e5                	mov    %esp,%ebp
8010147f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80101482:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101489:	e8 51 3d 00 00       	call   801051df <acquire>
  if(f->ref < 1)
8010148e:	8b 45 08             	mov    0x8(%ebp),%eax
80101491:	8b 40 04             	mov    0x4(%eax),%eax
80101494:	85 c0                	test   %eax,%eax
80101496:	7f 0c                	jg     801014a4 <filedup+0x28>
    panic("filedup");
80101498:	c7 04 24 36 86 10 80 	movl   $0x80108636,(%esp)
8010149f:	e8 b0 f0 ff ff       	call   80100554 <panic>
  f->ref++;
801014a4:	8b 45 08             	mov    0x8(%ebp),%eax
801014a7:	8b 40 04             	mov    0x4(%eax),%eax
801014aa:	8d 50 01             	lea    0x1(%eax),%edx
801014ad:	8b 45 08             	mov    0x8(%ebp),%eax
801014b0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801014b3:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
801014ba:	e8 8a 3d 00 00       	call   80105249 <release>
  return f;
801014bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801014c2:	c9                   	leave  
801014c3:	c3                   	ret    

801014c4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	57                   	push   %edi
801014c8:	56                   	push   %esi
801014c9:	53                   	push   %ebx
801014ca:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
801014cd:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
801014d4:	e8 06 3d 00 00       	call   801051df <acquire>
  if(f->ref < 1)
801014d9:	8b 45 08             	mov    0x8(%ebp),%eax
801014dc:	8b 40 04             	mov    0x4(%eax),%eax
801014df:	85 c0                	test   %eax,%eax
801014e1:	7f 0c                	jg     801014ef <fileclose+0x2b>
    panic("fileclose");
801014e3:	c7 04 24 3e 86 10 80 	movl   $0x8010863e,(%esp)
801014ea:	e8 65 f0 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
801014ef:	8b 45 08             	mov    0x8(%ebp),%eax
801014f2:	8b 40 04             	mov    0x4(%eax),%eax
801014f5:	8d 50 ff             	lea    -0x1(%eax),%edx
801014f8:	8b 45 08             	mov    0x8(%ebp),%eax
801014fb:	89 50 04             	mov    %edx,0x4(%eax)
801014fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101501:	8b 40 04             	mov    0x4(%eax),%eax
80101504:	85 c0                	test   %eax,%eax
80101506:	7e 0e                	jle    80101516 <fileclose+0x52>
    release(&ftable.lock);
80101508:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
8010150f:	e8 35 3d 00 00       	call   80105249 <release>
80101514:	eb 70                	jmp    80101586 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101516:	8b 45 08             	mov    0x8(%ebp),%eax
80101519:	8d 55 d0             	lea    -0x30(%ebp),%edx
8010151c:	89 c3                	mov    %eax,%ebx
8010151e:	b8 06 00 00 00       	mov    $0x6,%eax
80101523:	89 d7                	mov    %edx,%edi
80101525:	89 de                	mov    %ebx,%esi
80101527:	89 c1                	mov    %eax,%ecx
80101529:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010152b:	8b 45 08             	mov    0x8(%ebp),%eax
8010152e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101535:	8b 45 08             	mov    0x8(%ebp),%eax
80101538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010153e:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80101545:	e8 ff 3c 00 00       	call   80105249 <release>

  if(ff.type == FD_PIPE)
8010154a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010154d:	83 f8 01             	cmp    $0x1,%eax
80101550:	75 17                	jne    80101569 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
80101552:	8a 45 d9             	mov    -0x27(%ebp),%al
80101555:	0f be d0             	movsbl %al,%edx
80101558:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010155b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010155f:	89 04 24             	mov    %eax,(%esp)
80101562:	e8 00 2d 00 00       	call   80104267 <pipeclose>
80101567:	eb 1d                	jmp    80101586 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101569:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010156c:	83 f8 02             	cmp    $0x2,%eax
8010156f:	75 15                	jne    80101586 <fileclose+0xc2>
    begin_op();
80101571:	e8 61 23 00 00       	call   801038d7 <begin_op>
    iput(ff.ip);
80101576:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101579:	89 04 24             	mov    %eax,(%esp)
8010157c:	e8 ab 09 00 00       	call   80101f2c <iput>
    end_op();
80101581:	e8 d3 23 00 00       	call   80103959 <end_op>
  }
}
80101586:	83 c4 3c             	add    $0x3c,%esp
80101589:	5b                   	pop    %ebx
8010158a:	5e                   	pop    %esi
8010158b:	5f                   	pop    %edi
8010158c:	5d                   	pop    %ebp
8010158d:	c3                   	ret    

8010158e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010158e:	55                   	push   %ebp
8010158f:	89 e5                	mov    %esp,%ebp
80101591:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101594:	8b 45 08             	mov    0x8(%ebp),%eax
80101597:	8b 00                	mov    (%eax),%eax
80101599:	83 f8 02             	cmp    $0x2,%eax
8010159c:	75 38                	jne    801015d6 <filestat+0x48>
    ilock(f->ip);
8010159e:	8b 45 08             	mov    0x8(%ebp),%eax
801015a1:	8b 40 10             	mov    0x10(%eax),%eax
801015a4:	89 04 24             	mov    %eax,(%esp)
801015a7:	e8 32 08 00 00       	call   80101dde <ilock>
    stati(f->ip, st);
801015ac:	8b 45 08             	mov    0x8(%ebp),%eax
801015af:	8b 40 10             	mov    0x10(%eax),%eax
801015b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801015b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801015b9:	89 04 24             	mov    %eax,(%esp)
801015bc:	e8 70 0c 00 00       	call   80102231 <stati>
    iunlock(f->ip);
801015c1:	8b 45 08             	mov    0x8(%ebp),%eax
801015c4:	8b 40 10             	mov    0x10(%eax),%eax
801015c7:	89 04 24             	mov    %eax,(%esp)
801015ca:	e8 19 09 00 00       	call   80101ee8 <iunlock>
    return 0;
801015cf:	b8 00 00 00 00       	mov    $0x0,%eax
801015d4:	eb 05                	jmp    801015db <filestat+0x4d>
  }
  return -1;
801015d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801015db:	c9                   	leave  
801015dc:	c3                   	ret    

801015dd <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801015dd:	55                   	push   %ebp
801015de:	89 e5                	mov    %esp,%ebp
801015e0:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801015e3:	8b 45 08             	mov    0x8(%ebp),%eax
801015e6:	8a 40 08             	mov    0x8(%eax),%al
801015e9:	84 c0                	test   %al,%al
801015eb:	75 0a                	jne    801015f7 <fileread+0x1a>
    return -1;
801015ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015f2:	e9 9f 00 00 00       	jmp    80101696 <fileread+0xb9>
  if(f->type == FD_PIPE)
801015f7:	8b 45 08             	mov    0x8(%ebp),%eax
801015fa:	8b 00                	mov    (%eax),%eax
801015fc:	83 f8 01             	cmp    $0x1,%eax
801015ff:	75 1e                	jne    8010161f <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101601:	8b 45 08             	mov    0x8(%ebp),%eax
80101604:	8b 40 0c             	mov    0xc(%eax),%eax
80101607:	8b 55 10             	mov    0x10(%ebp),%edx
8010160a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010160e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101611:	89 54 24 04          	mov    %edx,0x4(%esp)
80101615:	89 04 24             	mov    %eax,(%esp)
80101618:	e8 c8 2d 00 00       	call   801043e5 <piperead>
8010161d:	eb 77                	jmp    80101696 <fileread+0xb9>
  if(f->type == FD_INODE){
8010161f:	8b 45 08             	mov    0x8(%ebp),%eax
80101622:	8b 00                	mov    (%eax),%eax
80101624:	83 f8 02             	cmp    $0x2,%eax
80101627:	75 61                	jne    8010168a <fileread+0xad>
    ilock(f->ip);
80101629:	8b 45 08             	mov    0x8(%ebp),%eax
8010162c:	8b 40 10             	mov    0x10(%eax),%eax
8010162f:	89 04 24             	mov    %eax,(%esp)
80101632:	e8 a7 07 00 00       	call   80101dde <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101637:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010163a:	8b 45 08             	mov    0x8(%ebp),%eax
8010163d:	8b 50 14             	mov    0x14(%eax),%edx
80101640:	8b 45 08             	mov    0x8(%ebp),%eax
80101643:	8b 40 10             	mov    0x10(%eax),%eax
80101646:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010164a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010164e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101651:	89 54 24 04          	mov    %edx,0x4(%esp)
80101655:	89 04 24             	mov    %eax,(%esp)
80101658:	e8 18 0c 00 00       	call   80102275 <readi>
8010165d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101664:	7e 11                	jle    80101677 <fileread+0x9a>
      f->off += r;
80101666:	8b 45 08             	mov    0x8(%ebp),%eax
80101669:	8b 50 14             	mov    0x14(%eax),%edx
8010166c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010166f:	01 c2                	add    %eax,%edx
80101671:	8b 45 08             	mov    0x8(%ebp),%eax
80101674:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101677:	8b 45 08             	mov    0x8(%ebp),%eax
8010167a:	8b 40 10             	mov    0x10(%eax),%eax
8010167d:	89 04 24             	mov    %eax,(%esp)
80101680:	e8 63 08 00 00       	call   80101ee8 <iunlock>
    return r;
80101685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101688:	eb 0c                	jmp    80101696 <fileread+0xb9>
  }
  panic("fileread");
8010168a:	c7 04 24 48 86 10 80 	movl   $0x80108648,(%esp)
80101691:	e8 be ee ff ff       	call   80100554 <panic>
}
80101696:	c9                   	leave  
80101697:	c3                   	ret    

80101698 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101698:	55                   	push   %ebp
80101699:	89 e5                	mov    %esp,%ebp
8010169b:	53                   	push   %ebx
8010169c:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
8010169f:	8b 45 08             	mov    0x8(%ebp),%eax
801016a2:	8a 40 09             	mov    0x9(%eax),%al
801016a5:	84 c0                	test   %al,%al
801016a7:	75 0a                	jne    801016b3 <filewrite+0x1b>
    return -1;
801016a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801016ae:	e9 20 01 00 00       	jmp    801017d3 <filewrite+0x13b>
  if(f->type == FD_PIPE)
801016b3:	8b 45 08             	mov    0x8(%ebp),%eax
801016b6:	8b 00                	mov    (%eax),%eax
801016b8:	83 f8 01             	cmp    $0x1,%eax
801016bb:	75 21                	jne    801016de <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801016bd:	8b 45 08             	mov    0x8(%ebp),%eax
801016c0:	8b 40 0c             	mov    0xc(%eax),%eax
801016c3:	8b 55 10             	mov    0x10(%ebp),%edx
801016c6:	89 54 24 08          	mov    %edx,0x8(%esp)
801016ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801016cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 20 2c 00 00       	call   801042f9 <pipewrite>
801016d9:	e9 f5 00 00 00       	jmp    801017d3 <filewrite+0x13b>
  if(f->type == FD_INODE){
801016de:	8b 45 08             	mov    0x8(%ebp),%eax
801016e1:	8b 00                	mov    (%eax),%eax
801016e3:	83 f8 02             	cmp    $0x2,%eax
801016e6:	0f 85 db 00 00 00    	jne    801017c7 <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801016ec:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801016f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801016fa:	e9 a8 00 00 00       	jmp    801017a7 <filewrite+0x10f>
      int n1 = n - i;
801016ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101702:	8b 55 10             	mov    0x10(%ebp),%edx
80101705:	29 c2                	sub    %eax,%edx
80101707:	89 d0                	mov    %edx,%eax
80101709:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101712:	7e 06                	jle    8010171a <filewrite+0x82>
        n1 = max;
80101714:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101717:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010171a:	e8 b8 21 00 00       	call   801038d7 <begin_op>
      ilock(f->ip);
8010171f:	8b 45 08             	mov    0x8(%ebp),%eax
80101722:	8b 40 10             	mov    0x10(%eax),%eax
80101725:	89 04 24             	mov    %eax,(%esp)
80101728:	e8 b1 06 00 00       	call   80101dde <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010172d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101730:	8b 45 08             	mov    0x8(%ebp),%eax
80101733:	8b 50 14             	mov    0x14(%eax),%edx
80101736:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101739:	8b 45 0c             	mov    0xc(%ebp),%eax
8010173c:	01 c3                	add    %eax,%ebx
8010173e:	8b 45 08             	mov    0x8(%ebp),%eax
80101741:	8b 40 10             	mov    0x10(%eax),%eax
80101744:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101748:	89 54 24 08          	mov    %edx,0x8(%esp)
8010174c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101750:	89 04 24             	mov    %eax,(%esp)
80101753:	e8 81 0c 00 00       	call   801023d9 <writei>
80101758:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010175b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010175f:	7e 11                	jle    80101772 <filewrite+0xda>
        f->off += r;
80101761:	8b 45 08             	mov    0x8(%ebp),%eax
80101764:	8b 50 14             	mov    0x14(%eax),%edx
80101767:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010176a:	01 c2                	add    %eax,%edx
8010176c:	8b 45 08             	mov    0x8(%ebp),%eax
8010176f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101772:	8b 45 08             	mov    0x8(%ebp),%eax
80101775:	8b 40 10             	mov    0x10(%eax),%eax
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 68 07 00 00       	call   80101ee8 <iunlock>
      end_op();
80101780:	e8 d4 21 00 00       	call   80103959 <end_op>

      if(r < 0)
80101785:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101789:	79 02                	jns    8010178d <filewrite+0xf5>
        break;
8010178b:	eb 26                	jmp    801017b3 <filewrite+0x11b>
      if(r != n1)
8010178d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101790:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101793:	74 0c                	je     801017a1 <filewrite+0x109>
        panic("short filewrite");
80101795:	c7 04 24 51 86 10 80 	movl   $0x80108651,(%esp)
8010179c:	e8 b3 ed ff ff       	call   80100554 <panic>
      i += r;
801017a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801017a4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801017ad:	0f 8c 4c ff ff ff    	jl     801016ff <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801017b9:	75 05                	jne    801017c0 <filewrite+0x128>
801017bb:	8b 45 10             	mov    0x10(%ebp),%eax
801017be:	eb 05                	jmp    801017c5 <filewrite+0x12d>
801017c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017c5:	eb 0c                	jmp    801017d3 <filewrite+0x13b>
  }
  panic("filewrite");
801017c7:	c7 04 24 61 86 10 80 	movl   $0x80108661,(%esp)
801017ce:	e8 81 ed ff ff       	call   80100554 <panic>
}
801017d3:	83 c4 24             	add    $0x24,%esp
801017d6:	5b                   	pop    %ebx
801017d7:	5d                   	pop    %ebp
801017d8:	c3                   	ret    
801017d9:	00 00                	add    %al,(%eax)
	...

801017dc <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801017dc:	55                   	push   %ebp
801017dd:	89 e5                	mov    %esp,%ebp
801017df:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801017e2:	8b 45 08             	mov    0x8(%ebp),%eax
801017e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801017ec:	00 
801017ed:	89 04 24             	mov    %eax,(%esp)
801017f0:	e8 c0 e9 ff ff       	call   801001b5 <bread>
801017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fb:	83 c0 5c             	add    $0x5c,%eax
801017fe:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101805:	00 
80101806:	89 44 24 04          	mov    %eax,0x4(%esp)
8010180a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010180d:	89 04 24             	mov    %eax,(%esp)
80101810:	e8 f6 3c 00 00       	call   8010550b <memmove>
  brelse(bp);
80101815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101818:	89 04 24             	mov    %eax,(%esp)
8010181b:	e8 0c ea ff ff       	call   8010022c <brelse>
}
80101820:	c9                   	leave  
80101821:	c3                   	ret    

80101822 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101822:	55                   	push   %ebp
80101823:	89 e5                	mov    %esp,%ebp
80101825:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101828:	8b 55 0c             	mov    0xc(%ebp),%edx
8010182b:	8b 45 08             	mov    0x8(%ebp),%eax
8010182e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101832:	89 04 24             	mov    %eax,(%esp)
80101835:	e8 7b e9 ff ff       	call   801001b5 <bread>
8010183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101840:	83 c0 5c             	add    $0x5c,%eax
80101843:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010184a:	00 
8010184b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101852:	00 
80101853:	89 04 24             	mov    %eax,(%esp)
80101856:	e8 e7 3b 00 00       	call   80105442 <memset>
  log_write(bp);
8010185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185e:	89 04 24             	mov    %eax,(%esp)
80101861:	e8 75 22 00 00       	call   80103adb <log_write>
  brelse(bp);
80101866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101869:	89 04 24             	mov    %eax,(%esp)
8010186c:	e8 bb e9 ff ff       	call   8010022c <brelse>
}
80101871:	c9                   	leave  
80101872:	c3                   	ret    

80101873 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101873:	55                   	push   %ebp
80101874:	89 e5                	mov    %esp,%ebp
80101876:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101887:	e9 03 01 00 00       	jmp    8010198f <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	85 c0                	test   %eax,%eax
80101891:	79 05                	jns    80101898 <balloc+0x25>
80101893:	05 ff 0f 00 00       	add    $0xfff,%eax
80101898:	c1 f8 0c             	sar    $0xc,%eax
8010189b:	89 c2                	mov    %eax,%edx
8010189d:	a1 f8 1b 11 80       	mov    0x80111bf8,%eax
801018a2:	01 d0                	add    %edx,%eax
801018a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	89 04 24             	mov    %eax,(%esp)
801018ae:	e8 02 e9 ff ff       	call   801001b5 <bread>
801018b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801018b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801018bd:	e9 9b 00 00 00       	jmp    8010195d <balloc+0xea>
      m = 1 << (bi % 8);
801018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c5:	25 07 00 00 80       	and    $0x80000007,%eax
801018ca:	85 c0                	test   %eax,%eax
801018cc:	79 05                	jns    801018d3 <balloc+0x60>
801018ce:	48                   	dec    %eax
801018cf:	83 c8 f8             	or     $0xfffffff8,%eax
801018d2:	40                   	inc    %eax
801018d3:	ba 01 00 00 00       	mov    $0x1,%edx
801018d8:	88 c1                	mov    %al,%cl
801018da:	d3 e2                	shl    %cl,%edx
801018dc:	89 d0                	mov    %edx,%eax
801018de:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e4:	85 c0                	test   %eax,%eax
801018e6:	79 03                	jns    801018eb <balloc+0x78>
801018e8:	83 c0 07             	add    $0x7,%eax
801018eb:	c1 f8 03             	sar    $0x3,%eax
801018ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
801018f1:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
801018f5:	0f b6 c0             	movzbl %al,%eax
801018f8:	23 45 e8             	and    -0x18(%ebp),%eax
801018fb:	85 c0                	test   %eax,%eax
801018fd:	75 5b                	jne    8010195a <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
801018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	79 03                	jns    80101909 <balloc+0x96>
80101906:	83 c0 07             	add    $0x7,%eax
80101909:	c1 f8 03             	sar    $0x3,%eax
8010190c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010190f:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101913:	88 d1                	mov    %dl,%cl
80101915:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101918:	09 ca                	or     %ecx,%edx
8010191a:	88 d1                	mov    %dl,%cl
8010191c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010191f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101923:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101926:	89 04 24             	mov    %eax,(%esp)
80101929:	e8 ad 21 00 00       	call   80103adb <log_write>
        brelse(bp);
8010192e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101931:	89 04 24             	mov    %eax,(%esp)
80101934:	e8 f3 e8 ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010193f:	01 c2                	add    %eax,%edx
80101941:	8b 45 08             	mov    0x8(%ebp),%eax
80101944:	89 54 24 04          	mov    %edx,0x4(%esp)
80101948:	89 04 24             	mov    %eax,(%esp)
8010194b:	e8 d2 fe ff ff       	call   80101822 <bzero>
        return b + bi;
80101950:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101953:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101956:	01 d0                	add    %edx,%eax
80101958:	eb 51                	jmp    801019ab <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010195a:	ff 45 f0             	incl   -0x10(%ebp)
8010195d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101964:	7f 17                	jg     8010197d <balloc+0x10a>
80101966:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101969:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010196c:	01 d0                	add    %edx,%eax
8010196e:	89 c2                	mov    %eax,%edx
80101970:	a1 e0 1b 11 80       	mov    0x80111be0,%eax
80101975:	39 c2                	cmp    %eax,%edx
80101977:	0f 82 45 ff ff ff    	jb     801018c2 <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101980:	89 04 24             	mov    %eax,(%esp)
80101983:	e8 a4 e8 ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101988:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010198f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101992:	a1 e0 1b 11 80       	mov    0x80111be0,%eax
80101997:	39 c2                	cmp    %eax,%edx
80101999:	0f 82 ed fe ff ff    	jb     8010188c <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010199f:	c7 04 24 6c 86 10 80 	movl   $0x8010866c,(%esp)
801019a6:	e8 a9 eb ff ff       	call   80100554 <panic>
}
801019ab:	c9                   	leave  
801019ac:	c3                   	ret    

801019ad <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801019ad:	55                   	push   %ebp
801019ae:	89 e5                	mov    %esp,%ebp
801019b0:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801019b3:	c7 44 24 04 e0 1b 11 	movl   $0x80111be0,0x4(%esp)
801019ba:	80 
801019bb:	8b 45 08             	mov    0x8(%ebp),%eax
801019be:	89 04 24             	mov    %eax,(%esp)
801019c1:	e8 16 fe ff ff       	call   801017dc <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801019c9:	c1 e8 0c             	shr    $0xc,%eax
801019cc:	89 c2                	mov    %eax,%edx
801019ce:	a1 f8 1b 11 80       	mov    0x80111bf8,%eax
801019d3:	01 c2                	add    %eax,%edx
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801019dc:	89 04 24             	mov    %eax,(%esp)
801019df:	e8 d1 e7 ff ff       	call   801001b5 <bread>
801019e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801019e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801019ea:	25 ff 0f 00 00       	and    $0xfff,%eax
801019ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f5:	25 07 00 00 80       	and    $0x80000007,%eax
801019fa:	85 c0                	test   %eax,%eax
801019fc:	79 05                	jns    80101a03 <bfree+0x56>
801019fe:	48                   	dec    %eax
801019ff:	83 c8 f8             	or     $0xfffffff8,%eax
80101a02:	40                   	inc    %eax
80101a03:	ba 01 00 00 00       	mov    $0x1,%edx
80101a08:	88 c1                	mov    %al,%cl
80101a0a:	d3 e2                	shl    %cl,%edx
80101a0c:	89 d0                	mov    %edx,%eax
80101a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a14:	85 c0                	test   %eax,%eax
80101a16:	79 03                	jns    80101a1b <bfree+0x6e>
80101a18:	83 c0 07             	add    $0x7,%eax
80101a1b:	c1 f8 03             	sar    $0x3,%eax
80101a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101a21:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101a25:	0f b6 c0             	movzbl %al,%eax
80101a28:	23 45 ec             	and    -0x14(%ebp),%eax
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	75 0c                	jne    80101a3b <bfree+0x8e>
    panic("freeing free block");
80101a2f:	c7 04 24 82 86 10 80 	movl   $0x80108682,(%esp)
80101a36:	e8 19 eb ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
80101a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a3e:	85 c0                	test   %eax,%eax
80101a40:	79 03                	jns    80101a45 <bfree+0x98>
80101a42:	83 c0 07             	add    $0x7,%eax
80101a45:	c1 f8 03             	sar    $0x3,%eax
80101a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101a4b:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101a4f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101a52:	f7 d1                	not    %ecx
80101a54:	21 ca                	and    %ecx,%edx
80101a56:	88 d1                	mov    %dl,%cl
80101a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101a5b:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a62:	89 04 24             	mov    %eax,(%esp)
80101a65:	e8 71 20 00 00       	call   80103adb <log_write>
  brelse(bp);
80101a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6d:	89 04 24             	mov    %eax,(%esp)
80101a70:	e8 b7 e7 ff ff       	call   8010022c <brelse>
}
80101a75:	c9                   	leave  
80101a76:	c3                   	ret    

80101a77 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101a77:	55                   	push   %ebp
80101a78:	89 e5                	mov    %esp,%ebp
80101a7a:	57                   	push   %edi
80101a7b:	56                   	push   %esi
80101a7c:	53                   	push   %ebx
80101a7d:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
80101a80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101a87:	c7 44 24 04 95 86 10 	movl   $0x80108695,0x4(%esp)
80101a8e:	80 
80101a8f:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101a96:	e8 23 37 00 00       	call   801051be <initlock>
  for(i = 0; i < NINODE; i++) {
80101a9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa2:	eb 2b                	jmp    80101acf <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
80101aa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101aa7:	89 d0                	mov    %edx,%eax
80101aa9:	c1 e0 03             	shl    $0x3,%eax
80101aac:	01 d0                	add    %edx,%eax
80101aae:	c1 e0 04             	shl    $0x4,%eax
80101ab1:	83 c0 30             	add    $0x30,%eax
80101ab4:	05 00 1c 11 80       	add    $0x80111c00,%eax
80101ab9:	83 c0 10             	add    $0x10,%eax
80101abc:	c7 44 24 04 9c 86 10 	movl   $0x8010869c,0x4(%esp)
80101ac3:	80 
80101ac4:	89 04 24             	mov    %eax,(%esp)
80101ac7:	e8 b4 35 00 00       	call   80105080 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101acc:	ff 45 e4             	incl   -0x1c(%ebp)
80101acf:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101ad3:	7e cf                	jle    80101aa4 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101ad5:	c7 44 24 04 e0 1b 11 	movl   $0x80111be0,0x4(%esp)
80101adc:	80 
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	89 04 24             	mov    %eax,(%esp)
80101ae3:	e8 f4 fc ff ff       	call   801017dc <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ae8:	a1 f8 1b 11 80       	mov    0x80111bf8,%eax
80101aed:	8b 3d f4 1b 11 80    	mov    0x80111bf4,%edi
80101af3:	8b 35 f0 1b 11 80    	mov    0x80111bf0,%esi
80101af9:	8b 1d ec 1b 11 80    	mov    0x80111bec,%ebx
80101aff:	8b 0d e8 1b 11 80    	mov    0x80111be8,%ecx
80101b05:	8b 15 e4 1b 11 80    	mov    0x80111be4,%edx
80101b0b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101b0e:	8b 15 e0 1b 11 80    	mov    0x80111be0,%edx
80101b14:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101b18:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101b1c:	89 74 24 14          	mov    %esi,0x14(%esp)
80101b20:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101b24:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101b2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101b2f:	89 d0                	mov    %edx,%eax
80101b31:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b35:	c7 04 24 a4 86 10 80 	movl   $0x801086a4,(%esp)
80101b3c:	e8 80 e8 ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101b41:	83 c4 4c             	add    $0x4c,%esp
80101b44:	5b                   	pop    %ebx
80101b45:	5e                   	pop    %esi
80101b46:	5f                   	pop    %edi
80101b47:	5d                   	pop    %ebp
80101b48:	c3                   	ret    

80101b49 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101b49:	55                   	push   %ebp
80101b4a:	89 e5                	mov    %esp,%ebp
80101b4c:	83 ec 28             	sub    $0x28,%esp
80101b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b52:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101b56:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101b5d:	e9 9b 00 00 00       	jmp    80101bfd <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
80101b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b65:	c1 e8 03             	shr    $0x3,%eax
80101b68:	89 c2                	mov    %eax,%edx
80101b6a:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80101b6f:	01 d0                	add    %edx,%eax
80101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	89 04 24             	mov    %eax,(%esp)
80101b7b:	e8 35 e6 ff ff       	call   801001b5 <bread>
80101b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b86:	8d 50 5c             	lea    0x5c(%eax),%edx
80101b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b8c:	83 e0 07             	and    $0x7,%eax
80101b8f:	c1 e0 06             	shl    $0x6,%eax
80101b92:	01 d0                	add    %edx,%eax
80101b94:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b9a:	8b 00                	mov    (%eax),%eax
80101b9c:	66 85 c0             	test   %ax,%ax
80101b9f:	75 4e                	jne    80101bef <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
80101ba1:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101ba8:	00 
80101ba9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101bb0:	00 
80101bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bb4:	89 04 24             	mov    %eax,(%esp)
80101bb7:	e8 86 38 00 00       	call   80105442 <memset>
      dip->type = type;
80101bbc:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc2:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 0b 1f 00 00       	call   80103adb <log_write>
      brelse(bp);
80101bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd3:	89 04 24             	mov    %eax,(%esp)
80101bd6:	e8 51 e6 ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bde:	89 44 24 04          	mov    %eax,0x4(%esp)
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	89 04 24             	mov    %eax,(%esp)
80101be8:	e8 ea 00 00 00       	call   80101cd7 <iget>
80101bed:	eb 2a                	jmp    80101c19 <ialloc+0xd0>
    }
    brelse(bp);
80101bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf2:	89 04 24             	mov    %eax,(%esp)
80101bf5:	e8 32 e6 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101bfa:	ff 45 f4             	incl   -0xc(%ebp)
80101bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c00:	a1 e8 1b 11 80       	mov    0x80111be8,%eax
80101c05:	39 c2                	cmp    %eax,%edx
80101c07:	0f 82 55 ff ff ff    	jb     80101b62 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101c0d:	c7 04 24 f7 86 10 80 	movl   $0x801086f7,(%esp)
80101c14:	e8 3b e9 ff ff       	call   80100554 <panic>
}
80101c19:	c9                   	leave  
80101c1a:	c3                   	ret    

80101c1b <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101c1b:	55                   	push   %ebp
80101c1c:	89 e5                	mov    %esp,%ebp
80101c1e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 40 04             	mov    0x4(%eax),%eax
80101c27:	c1 e8 03             	shr    $0x3,%eax
80101c2a:	89 c2                	mov    %eax,%edx
80101c2c:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80101c31:	01 c2                	add    %eax,%edx
80101c33:	8b 45 08             	mov    0x8(%ebp),%eax
80101c36:	8b 00                	mov    (%eax),%eax
80101c38:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c3c:	89 04 24             	mov    %eax,(%esp)
80101c3f:	e8 71 e5 ff ff       	call   801001b5 <bread>
80101c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c4a:	8d 50 5c             	lea    0x5c(%eax),%edx
80101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c50:	8b 40 04             	mov    0x4(%eax),%eax
80101c53:	83 e0 07             	and    $0x7,%eax
80101c56:	c1 e0 06             	shl    $0x6,%eax
80101c59:	01 d0                	add    %edx,%eax
80101c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c61:	8b 40 50             	mov    0x50(%eax),%eax
80101c64:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c67:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	66 8b 40 52          	mov    0x52(%eax),%ax
80101c71:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c74:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101c78:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7b:	8b 40 54             	mov    0x54(%eax),%eax
80101c7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c81:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	66 8b 40 56          	mov    0x56(%eax),%ax
80101c8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c8f:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 50 58             	mov    0x58(%eax),%edx
80101c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c9c:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca2:	8d 50 5c             	lea    0x5c(%eax),%edx
80101ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca8:	83 c0 0c             	add    $0xc,%eax
80101cab:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101cb2:	00 
80101cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb7:	89 04 24             	mov    %eax,(%esp)
80101cba:	e8 4c 38 00 00       	call   8010550b <memmove>
  log_write(bp);
80101cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc2:	89 04 24             	mov    %eax,(%esp)
80101cc5:	e8 11 1e 00 00       	call   80103adb <log_write>
  brelse(bp);
80101cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ccd:	89 04 24             	mov    %eax,(%esp)
80101cd0:	e8 57 e5 ff ff       	call   8010022c <brelse>
}
80101cd5:	c9                   	leave  
80101cd6:	c3                   	ret    

80101cd7 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101cd7:	55                   	push   %ebp
80101cd8:	89 e5                	mov    %esp,%ebp
80101cda:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101cdd:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101ce4:	e8 f6 34 00 00       	call   801051df <acquire>

  // Is the inode already cached?
  empty = 0;
80101ce9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cf0:	c7 45 f4 34 1c 11 80 	movl   $0x80111c34,-0xc(%ebp)
80101cf7:	eb 5c                	jmp    80101d55 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cfc:	8b 40 08             	mov    0x8(%eax),%eax
80101cff:	85 c0                	test   %eax,%eax
80101d01:	7e 35                	jle    80101d38 <iget+0x61>
80101d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d06:	8b 00                	mov    (%eax),%eax
80101d08:	3b 45 08             	cmp    0x8(%ebp),%eax
80101d0b:	75 2b                	jne    80101d38 <iget+0x61>
80101d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d10:	8b 40 04             	mov    0x4(%eax),%eax
80101d13:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101d16:	75 20                	jne    80101d38 <iget+0x61>
      ip->ref++;
80101d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d1b:	8b 40 08             	mov    0x8(%eax),%eax
80101d1e:	8d 50 01             	lea    0x1(%eax),%edx
80101d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d24:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101d27:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101d2e:	e8 16 35 00 00       	call   80105249 <release>
      return ip;
80101d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d36:	eb 72                	jmp    80101daa <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101d38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101d3c:	75 10                	jne    80101d4e <iget+0x77>
80101d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d41:	8b 40 08             	mov    0x8(%eax),%eax
80101d44:	85 c0                	test   %eax,%eax
80101d46:	75 06                	jne    80101d4e <iget+0x77>
      empty = ip;
80101d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101d4e:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101d55:	81 7d f4 54 38 11 80 	cmpl   $0x80113854,-0xc(%ebp)
80101d5c:	72 9b                	jb     80101cf9 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101d62:	75 0c                	jne    80101d70 <iget+0x99>
    panic("iget: no inodes");
80101d64:	c7 04 24 09 87 10 80 	movl   $0x80108709,(%esp)
80101d6b:	e8 e4 e7 ff ff       	call   80100554 <panic>

  ip = empty;
80101d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d79:	8b 55 08             	mov    0x8(%ebp),%edx
80101d7c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d81:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d84:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d8a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d94:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101d9b:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101da2:	e8 a2 34 00 00       	call   80105249 <release>

  return ip;
80101da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101daa:	c9                   	leave  
80101dab:	c3                   	ret    

80101dac <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101dac:	55                   	push   %ebp
80101dad:	89 e5                	mov    %esp,%ebp
80101daf:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101db2:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101db9:	e8 21 34 00 00       	call   801051df <acquire>
  ip->ref++;
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 40 08             	mov    0x8(%eax),%eax
80101dc4:	8d 50 01             	lea    0x1(%eax),%edx
80101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dca:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101dcd:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101dd4:	e8 70 34 00 00       	call   80105249 <release>
  return ip;
80101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ddc:	c9                   	leave  
80101ddd:	c3                   	ret    

80101dde <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101dde:	55                   	push   %ebp
80101ddf:	89 e5                	mov    %esp,%ebp
80101de1:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101de4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101de8:	74 0a                	je     80101df4 <ilock+0x16>
80101dea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ded:	8b 40 08             	mov    0x8(%eax),%eax
80101df0:	85 c0                	test   %eax,%eax
80101df2:	7f 0c                	jg     80101e00 <ilock+0x22>
    panic("ilock");
80101df4:	c7 04 24 19 87 10 80 	movl   $0x80108719,(%esp)
80101dfb:	e8 54 e7 ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
80101e00:	8b 45 08             	mov    0x8(%ebp),%eax
80101e03:	83 c0 0c             	add    $0xc,%eax
80101e06:	89 04 24             	mov    %eax,(%esp)
80101e09:	e8 ac 32 00 00       	call   801050ba <acquiresleep>

  if(ip->valid == 0){
80101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e11:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e14:	85 c0                	test   %eax,%eax
80101e16:	0f 85 ca 00 00 00    	jne    80101ee6 <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1f:	8b 40 04             	mov    0x4(%eax),%eax
80101e22:	c1 e8 03             	shr    $0x3,%eax
80101e25:	89 c2                	mov    %eax,%edx
80101e27:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80101e2c:	01 c2                	add    %eax,%edx
80101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e31:	8b 00                	mov    (%eax),%eax
80101e33:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e37:	89 04 24             	mov    %eax,(%esp)
80101e3a:	e8 76 e3 ff ff       	call   801001b5 <bread>
80101e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e45:	8d 50 5c             	lea    0x5c(%eax),%edx
80101e48:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4b:	8b 40 04             	mov    0x4(%eax),%eax
80101e4e:	83 e0 07             	and    $0x7,%eax
80101e51:	c1 e0 06             	shl    $0x6,%eax
80101e54:	01 d0                	add    %edx,%eax
80101e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e5c:	8b 00                	mov    (%eax),%eax
80101e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e61:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e68:	66 8b 40 02          	mov    0x2(%eax),%ax
80101e6c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e6f:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e76:	8b 40 04             	mov    0x4(%eax),%eax
80101e79:	8b 55 08             	mov    0x8(%ebp),%edx
80101e7c:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e83:	66 8b 40 06          	mov    0x6(%eax),%ax
80101e87:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8a:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e91:	8b 50 08             	mov    0x8(%eax),%edx
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e9d:	8d 50 0c             	lea    0xc(%eax),%edx
80101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea3:	83 c0 5c             	add    $0x5c,%eax
80101ea6:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101ead:	00 
80101eae:	89 54 24 04          	mov    %edx,0x4(%esp)
80101eb2:	89 04 24             	mov    %eax,(%esp)
80101eb5:	e8 51 36 00 00       	call   8010550b <memmove>
    brelse(bp);
80101eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ebd:	89 04 24             	mov    %eax,(%esp)
80101ec0:	e8 67 e3 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	8b 40 50             	mov    0x50(%eax),%eax
80101ed5:	66 85 c0             	test   %ax,%ax
80101ed8:	75 0c                	jne    80101ee6 <ilock+0x108>
      panic("ilock: no type");
80101eda:	c7 04 24 1f 87 10 80 	movl   $0x8010871f,(%esp)
80101ee1:	e8 6e e6 ff ff       	call   80100554 <panic>
  }
}
80101ee6:	c9                   	leave  
80101ee7:	c3                   	ret    

80101ee8 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ee8:	55                   	push   %ebp
80101ee9:	89 e5                	mov    %esp,%ebp
80101eeb:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101eee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ef2:	74 1c                	je     80101f10 <iunlock+0x28>
80101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef7:	83 c0 0c             	add    $0xc,%eax
80101efa:	89 04 24             	mov    %eax,(%esp)
80101efd:	e8 55 32 00 00       	call   80105157 <holdingsleep>
80101f02:	85 c0                	test   %eax,%eax
80101f04:	74 0a                	je     80101f10 <iunlock+0x28>
80101f06:	8b 45 08             	mov    0x8(%ebp),%eax
80101f09:	8b 40 08             	mov    0x8(%eax),%eax
80101f0c:	85 c0                	test   %eax,%eax
80101f0e:	7f 0c                	jg     80101f1c <iunlock+0x34>
    panic("iunlock");
80101f10:	c7 04 24 2e 87 10 80 	movl   $0x8010872e,(%esp)
80101f17:	e8 38 e6 ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	83 c0 0c             	add    $0xc,%eax
80101f22:	89 04 24             	mov    %eax,(%esp)
80101f25:	e8 eb 31 00 00       	call   80105115 <releasesleep>
}
80101f2a:	c9                   	leave  
80101f2b:	c3                   	ret    

80101f2c <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101f2c:	55                   	push   %ebp
80101f2d:	89 e5                	mov    %esp,%ebp
80101f2f:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	83 c0 0c             	add    $0xc,%eax
80101f38:	89 04 24             	mov    %eax,(%esp)
80101f3b:	e8 7a 31 00 00       	call   801050ba <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f46:	85 c0                	test   %eax,%eax
80101f48:	74 5c                	je     80101fa6 <iput+0x7a>
80101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4d:	66 8b 40 56          	mov    0x56(%eax),%ax
80101f51:	66 85 c0             	test   %ax,%ax
80101f54:	75 50                	jne    80101fa6 <iput+0x7a>
    acquire(&icache.lock);
80101f56:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101f5d:	e8 7d 32 00 00       	call   801051df <acquire>
    int r = ip->ref;
80101f62:	8b 45 08             	mov    0x8(%ebp),%eax
80101f65:	8b 40 08             	mov    0x8(%eax),%eax
80101f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101f6b:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101f72:	e8 d2 32 00 00       	call   80105249 <release>
    if(r == 1){
80101f77:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101f7b:	75 29                	jne    80101fa6 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f80:	89 04 24             	mov    %eax,(%esp)
80101f83:	e8 86 01 00 00       	call   8010210e <itrunc>
      ip->type = 0;
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101f91:	8b 45 08             	mov    0x8(%ebp),%eax
80101f94:	89 04 24             	mov    %eax,(%esp)
80101f97:	e8 7f fc ff ff       	call   80101c1b <iupdate>
      ip->valid = 0;
80101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9f:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa9:	83 c0 0c             	add    $0xc,%eax
80101fac:	89 04 24             	mov    %eax,(%esp)
80101faf:	e8 61 31 00 00       	call   80105115 <releasesleep>

  acquire(&icache.lock);
80101fb4:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101fbb:	e8 1f 32 00 00       	call   801051df <acquire>
  ip->ref--;
80101fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc3:	8b 40 08             	mov    0x8(%eax),%eax
80101fc6:	8d 50 ff             	lea    -0x1(%eax),%edx
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101fcf:	c7 04 24 00 1c 11 80 	movl   $0x80111c00,(%esp)
80101fd6:	e8 6e 32 00 00       	call   80105249 <release>
}
80101fdb:	c9                   	leave  
80101fdc:	c3                   	ret    

80101fdd <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101fdd:	55                   	push   %ebp
80101fde:	89 e5                	mov    %esp,%ebp
80101fe0:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe6:	89 04 24             	mov    %eax,(%esp)
80101fe9:	e8 fa fe ff ff       	call   80101ee8 <iunlock>
  iput(ip);
80101fee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff1:	89 04 24             	mov    %eax,(%esp)
80101ff4:	e8 33 ff ff ff       	call   80101f2c <iput>
}
80101ff9:	c9                   	leave  
80101ffa:	c3                   	ret    

80101ffb <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ffb:	55                   	push   %ebp
80101ffc:	89 e5                	mov    %esp,%ebp
80101ffe:	53                   	push   %ebx
80101fff:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80102002:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80102006:	77 3e                	ja     80102046 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80102008:	8b 45 08             	mov    0x8(%ebp),%eax
8010200b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010200e:	83 c2 14             	add    $0x14,%edx
80102011:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80102015:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010201c:	75 20                	jne    8010203e <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010201e:	8b 45 08             	mov    0x8(%ebp),%eax
80102021:	8b 00                	mov    (%eax),%eax
80102023:	89 04 24             	mov    %eax,(%esp)
80102026:	e8 48 f8 ff ff       	call   80101873 <balloc>
8010202b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010202e:	8b 45 08             	mov    0x8(%ebp),%eax
80102031:	8b 55 0c             	mov    0xc(%ebp),%edx
80102034:	8d 4a 14             	lea    0x14(%edx),%ecx
80102037:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010203a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
8010203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102041:	e9 c2 00 00 00       	jmp    80102108 <bmap+0x10d>
  }
  bn -= NDIRECT;
80102046:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
8010204a:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
8010204e:	0f 87 a8 00 00 00    	ja     801020fc <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102064:	75 1c                	jne    80102082 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102066:	8b 45 08             	mov    0x8(%ebp),%eax
80102069:	8b 00                	mov    (%eax),%eax
8010206b:	89 04 24             	mov    %eax,(%esp)
8010206e:	e8 00 f8 ff ff       	call   80101873 <balloc>
80102073:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102076:	8b 45 08             	mov    0x8(%ebp),%eax
80102079:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010207c:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80102082:	8b 45 08             	mov    0x8(%ebp),%eax
80102085:	8b 00                	mov    (%eax),%eax
80102087:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010208a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010208e:	89 04 24             	mov    %eax,(%esp)
80102091:	e8 1f e1 ff ff       	call   801001b5 <bread>
80102096:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80102099:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010209c:	83 c0 5c             	add    $0x5c,%eax
8010209f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
801020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801020ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020af:	01 d0                	add    %edx,%eax
801020b1:	8b 00                	mov    (%eax),%eax
801020b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801020b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801020ba:	75 30                	jne    801020ec <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
801020bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801020bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	8b 00                	mov    (%eax),%eax
801020d1:	89 04 24             	mov    %eax,(%esp)
801020d4:	e8 9a f7 ff ff       	call   80101873 <balloc>
801020d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020df:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
801020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020e4:	89 04 24             	mov    %eax,(%esp)
801020e7:	e8 ef 19 00 00       	call   80103adb <log_write>
    }
    brelse(bp);
801020ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020ef:	89 04 24             	mov    %eax,(%esp)
801020f2:	e8 35 e1 ff ff       	call   8010022c <brelse>
    return addr;
801020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020fa:	eb 0c                	jmp    80102108 <bmap+0x10d>
  }

  panic("bmap: out of range");
801020fc:	c7 04 24 36 87 10 80 	movl   $0x80108736,(%esp)
80102103:	e8 4c e4 ff ff       	call   80100554 <panic>
}
80102108:	83 c4 24             	add    $0x24,%esp
8010210b:	5b                   	pop    %ebx
8010210c:	5d                   	pop    %ebp
8010210d:	c3                   	ret    

8010210e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
8010210e:	55                   	push   %ebp
8010210f:	89 e5                	mov    %esp,%ebp
80102111:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102114:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010211b:	eb 43                	jmp    80102160 <itrunc+0x52>
    if(ip->addrs[i]){
8010211d:	8b 45 08             	mov    0x8(%ebp),%eax
80102120:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102123:	83 c2 14             	add    $0x14,%edx
80102126:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010212a:	85 c0                	test   %eax,%eax
8010212c:	74 2f                	je     8010215d <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
8010212e:	8b 45 08             	mov    0x8(%ebp),%eax
80102131:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102134:	83 c2 14             	add    $0x14,%edx
80102137:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
8010213e:	8b 00                	mov    (%eax),%eax
80102140:	89 54 24 04          	mov    %edx,0x4(%esp)
80102144:	89 04 24             	mov    %eax,(%esp)
80102147:	e8 61 f8 ff ff       	call   801019ad <bfree>
      ip->addrs[i] = 0;
8010214c:	8b 45 08             	mov    0x8(%ebp),%eax
8010214f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102152:	83 c2 14             	add    $0x14,%edx
80102155:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
8010215c:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010215d:	ff 45 f4             	incl   -0xc(%ebp)
80102160:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80102164:	7e b7                	jle    8010211d <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80102166:	8b 45 08             	mov    0x8(%ebp),%eax
80102169:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010216f:	85 c0                	test   %eax,%eax
80102171:	0f 84 a3 00 00 00    	je     8010221a <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102177:	8b 45 08             	mov    0x8(%ebp),%eax
8010217a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80102180:	8b 45 08             	mov    0x8(%ebp),%eax
80102183:	8b 00                	mov    (%eax),%eax
80102185:	89 54 24 04          	mov    %edx,0x4(%esp)
80102189:	89 04 24             	mov    %eax,(%esp)
8010218c:	e8 24 e0 ff ff       	call   801001b5 <bread>
80102191:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80102194:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102197:	83 c0 5c             	add    $0x5c,%eax
8010219a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010219d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801021a4:	eb 3a                	jmp    801021e0 <itrunc+0xd2>
      if(a[j])
801021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801021b3:	01 d0                	add    %edx,%eax
801021b5:	8b 00                	mov    (%eax),%eax
801021b7:	85 c0                	test   %eax,%eax
801021b9:	74 22                	je     801021dd <itrunc+0xcf>
        bfree(ip->dev, a[j]);
801021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801021c8:	01 d0                	add    %edx,%eax
801021ca:	8b 10                	mov    (%eax),%edx
801021cc:	8b 45 08             	mov    0x8(%ebp),%eax
801021cf:	8b 00                	mov    (%eax),%eax
801021d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801021d5:	89 04 24             	mov    %eax,(%esp)
801021d8:	e8 d0 f7 ff ff       	call   801019ad <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801021dd:	ff 45 f0             	incl   -0x10(%ebp)
801021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021e3:	83 f8 7f             	cmp    $0x7f,%eax
801021e6:	76 be                	jbe    801021a6 <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
801021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021eb:	89 04 24             	mov    %eax,(%esp)
801021ee:	e8 39 e0 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801021f3:	8b 45 08             	mov    0x8(%ebp),%eax
801021f6:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801021fc:	8b 45 08             	mov    0x8(%ebp),%eax
801021ff:	8b 00                	mov    (%eax),%eax
80102201:	89 54 24 04          	mov    %edx,0x4(%esp)
80102205:	89 04 24             	mov    %eax,(%esp)
80102208:	e8 a0 f7 ff ff       	call   801019ad <bfree>
    ip->addrs[NDIRECT] = 0;
8010220d:	8b 45 08             	mov    0x8(%ebp),%eax
80102210:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80102217:	00 00 00 
  }

  ip->size = 0;
8010221a:	8b 45 08             	mov    0x8(%ebp),%eax
8010221d:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80102224:	8b 45 08             	mov    0x8(%ebp),%eax
80102227:	89 04 24             	mov    %eax,(%esp)
8010222a:	e8 ec f9 ff ff       	call   80101c1b <iupdate>
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    

80102231 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102231:	55                   	push   %ebp
80102232:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102234:	8b 45 08             	mov    0x8(%ebp),%eax
80102237:	8b 00                	mov    (%eax),%eax
80102239:	89 c2                	mov    %eax,%edx
8010223b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010223e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102241:	8b 45 08             	mov    0x8(%ebp),%eax
80102244:	8b 50 04             	mov    0x4(%eax),%edx
80102247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010224a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010224d:	8b 45 08             	mov    0x8(%ebp),%eax
80102250:	8b 40 50             	mov    0x50(%eax),%eax
80102253:	8b 55 0c             	mov    0xc(%ebp),%edx
80102256:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80102259:	8b 45 08             	mov    0x8(%ebp),%eax
8010225c:	66 8b 40 56          	mov    0x56(%eax),%ax
80102260:	8b 55 0c             	mov    0xc(%ebp),%edx
80102263:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80102267:	8b 45 08             	mov    0x8(%ebp),%eax
8010226a:	8b 50 58             	mov    0x58(%eax),%edx
8010226d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102270:	89 50 10             	mov    %edx,0x10(%eax)
}
80102273:	5d                   	pop    %ebp
80102274:	c3                   	ret    

80102275 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102275:	55                   	push   %ebp
80102276:	89 e5                	mov    %esp,%ebp
80102278:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010227b:	8b 45 08             	mov    0x8(%ebp),%eax
8010227e:	8b 40 50             	mov    0x50(%eax),%eax
80102281:	66 83 f8 03          	cmp    $0x3,%ax
80102285:	75 60                	jne    801022e7 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102287:	8b 45 08             	mov    0x8(%ebp),%eax
8010228a:	66 8b 40 52          	mov    0x52(%eax),%ax
8010228e:	66 85 c0             	test   %ax,%ax
80102291:	78 20                	js     801022b3 <readi+0x3e>
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
80102296:	66 8b 40 52          	mov    0x52(%eax),%ax
8010229a:	66 83 f8 09          	cmp    $0x9,%ax
8010229e:	7f 13                	jg     801022b3 <readi+0x3e>
801022a0:	8b 45 08             	mov    0x8(%ebp),%eax
801022a3:	66 8b 40 52          	mov    0x52(%eax),%ax
801022a7:	98                   	cwtl   
801022a8:	8b 04 c5 80 1b 11 80 	mov    -0x7feee480(,%eax,8),%eax
801022af:	85 c0                	test   %eax,%eax
801022b1:	75 0a                	jne    801022bd <readi+0x48>
      return -1;
801022b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b8:	e9 1a 01 00 00       	jmp    801023d7 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
801022bd:	8b 45 08             	mov    0x8(%ebp),%eax
801022c0:	66 8b 40 52          	mov    0x52(%eax),%ax
801022c4:	98                   	cwtl   
801022c5:	8b 04 c5 80 1b 11 80 	mov    -0x7feee480(,%eax,8),%eax
801022cc:	8b 55 14             	mov    0x14(%ebp),%edx
801022cf:	89 54 24 08          	mov    %edx,0x8(%esp)
801022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801022d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801022da:	8b 55 08             	mov    0x8(%ebp),%edx
801022dd:	89 14 24             	mov    %edx,(%esp)
801022e0:	ff d0                	call   *%eax
801022e2:	e9 f0 00 00 00       	jmp    801023d7 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
801022e7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	3b 45 10             	cmp    0x10(%ebp),%eax
801022f0:	72 0d                	jb     801022ff <readi+0x8a>
801022f2:	8b 45 14             	mov    0x14(%ebp),%eax
801022f5:	8b 55 10             	mov    0x10(%ebp),%edx
801022f8:	01 d0                	add    %edx,%eax
801022fa:	3b 45 10             	cmp    0x10(%ebp),%eax
801022fd:	73 0a                	jae    80102309 <readi+0x94>
    return -1;
801022ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102304:	e9 ce 00 00 00       	jmp    801023d7 <readi+0x162>
  if(off + n > ip->size)
80102309:	8b 45 14             	mov    0x14(%ebp),%eax
8010230c:	8b 55 10             	mov    0x10(%ebp),%edx
8010230f:	01 c2                	add    %eax,%edx
80102311:	8b 45 08             	mov    0x8(%ebp),%eax
80102314:	8b 40 58             	mov    0x58(%eax),%eax
80102317:	39 c2                	cmp    %eax,%edx
80102319:	76 0c                	jbe    80102327 <readi+0xb2>
    n = ip->size - off;
8010231b:	8b 45 08             	mov    0x8(%ebp),%eax
8010231e:	8b 40 58             	mov    0x58(%eax),%eax
80102321:	2b 45 10             	sub    0x10(%ebp),%eax
80102324:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010232e:	e9 95 00 00 00       	jmp    801023c8 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102333:	8b 45 10             	mov    0x10(%ebp),%eax
80102336:	c1 e8 09             	shr    $0x9,%eax
80102339:	89 44 24 04          	mov    %eax,0x4(%esp)
8010233d:	8b 45 08             	mov    0x8(%ebp),%eax
80102340:	89 04 24             	mov    %eax,(%esp)
80102343:	e8 b3 fc ff ff       	call   80101ffb <bmap>
80102348:	8b 55 08             	mov    0x8(%ebp),%edx
8010234b:	8b 12                	mov    (%edx),%edx
8010234d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102351:	89 14 24             	mov    %edx,(%esp)
80102354:	e8 5c de ff ff       	call   801001b5 <bread>
80102359:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010235c:	8b 45 10             	mov    0x10(%ebp),%eax
8010235f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102364:	89 c2                	mov    %eax,%edx
80102366:	b8 00 02 00 00       	mov    $0x200,%eax
8010236b:	29 d0                	sub    %edx,%eax
8010236d:	89 c1                	mov    %eax,%ecx
8010236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102372:	8b 55 14             	mov    0x14(%ebp),%edx
80102375:	29 c2                	sub    %eax,%edx
80102377:	89 c8                	mov    %ecx,%eax
80102379:	39 d0                	cmp    %edx,%eax
8010237b:	76 02                	jbe    8010237f <readi+0x10a>
8010237d:	89 d0                	mov    %edx,%eax
8010237f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102382:	8b 45 10             	mov    0x10(%ebp),%eax
80102385:	25 ff 01 00 00       	and    $0x1ff,%eax
8010238a:	8d 50 50             	lea    0x50(%eax),%edx
8010238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102390:	01 d0                	add    %edx,%eax
80102392:	8d 50 0c             	lea    0xc(%eax),%edx
80102395:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102398:	89 44 24 08          	mov    %eax,0x8(%esp)
8010239c:	89 54 24 04          	mov    %edx,0x4(%esp)
801023a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801023a3:	89 04 24             	mov    %eax,(%esp)
801023a6:	e8 60 31 00 00       	call   8010550b <memmove>
    brelse(bp);
801023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ae:	89 04 24             	mov    %eax,(%esp)
801023b1:	e8 76 de ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023b9:	01 45 f4             	add    %eax,-0xc(%ebp)
801023bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023bf:	01 45 10             	add    %eax,0x10(%ebp)
801023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023c5:	01 45 0c             	add    %eax,0xc(%ebp)
801023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cb:	3b 45 14             	cmp    0x14(%ebp),%eax
801023ce:	0f 82 5f ff ff ff    	jb     80102333 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801023d4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801023d7:	c9                   	leave  
801023d8:	c3                   	ret    

801023d9 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801023d9:	55                   	push   %ebp
801023da:	89 e5                	mov    %esp,%ebp
801023dc:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023df:	8b 45 08             	mov    0x8(%ebp),%eax
801023e2:	8b 40 50             	mov    0x50(%eax),%eax
801023e5:	66 83 f8 03          	cmp    $0x3,%ax
801023e9:	75 60                	jne    8010244b <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801023eb:	8b 45 08             	mov    0x8(%ebp),%eax
801023ee:	66 8b 40 52          	mov    0x52(%eax),%ax
801023f2:	66 85 c0             	test   %ax,%ax
801023f5:	78 20                	js     80102417 <writei+0x3e>
801023f7:	8b 45 08             	mov    0x8(%ebp),%eax
801023fa:	66 8b 40 52          	mov    0x52(%eax),%ax
801023fe:	66 83 f8 09          	cmp    $0x9,%ax
80102402:	7f 13                	jg     80102417 <writei+0x3e>
80102404:	8b 45 08             	mov    0x8(%ebp),%eax
80102407:	66 8b 40 52          	mov    0x52(%eax),%ax
8010240b:	98                   	cwtl   
8010240c:	8b 04 c5 84 1b 11 80 	mov    -0x7feee47c(,%eax,8),%eax
80102413:	85 c0                	test   %eax,%eax
80102415:	75 0a                	jne    80102421 <writei+0x48>
      return -1;
80102417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010241c:	e9 45 01 00 00       	jmp    80102566 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	66 8b 40 52          	mov    0x52(%eax),%ax
80102428:	98                   	cwtl   
80102429:	8b 04 c5 84 1b 11 80 	mov    -0x7feee47c(,%eax,8),%eax
80102430:	8b 55 14             	mov    0x14(%ebp),%edx
80102433:	89 54 24 08          	mov    %edx,0x8(%esp)
80102437:	8b 55 0c             	mov    0xc(%ebp),%edx
8010243a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010243e:	8b 55 08             	mov    0x8(%ebp),%edx
80102441:	89 14 24             	mov    %edx,(%esp)
80102444:	ff d0                	call   *%eax
80102446:	e9 1b 01 00 00       	jmp    80102566 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
8010244b:	8b 45 08             	mov    0x8(%ebp),%eax
8010244e:	8b 40 58             	mov    0x58(%eax),%eax
80102451:	3b 45 10             	cmp    0x10(%ebp),%eax
80102454:	72 0d                	jb     80102463 <writei+0x8a>
80102456:	8b 45 14             	mov    0x14(%ebp),%eax
80102459:	8b 55 10             	mov    0x10(%ebp),%edx
8010245c:	01 d0                	add    %edx,%eax
8010245e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102461:	73 0a                	jae    8010246d <writei+0x94>
    return -1;
80102463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102468:	e9 f9 00 00 00       	jmp    80102566 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
8010246d:	8b 45 14             	mov    0x14(%ebp),%eax
80102470:	8b 55 10             	mov    0x10(%ebp),%edx
80102473:	01 d0                	add    %edx,%eax
80102475:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010247a:	76 0a                	jbe    80102486 <writei+0xad>
    return -1;
8010247c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102481:	e9 e0 00 00 00       	jmp    80102566 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102486:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010248d:	e9 a0 00 00 00       	jmp    80102532 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102492:	8b 45 10             	mov    0x10(%ebp),%eax
80102495:	c1 e8 09             	shr    $0x9,%eax
80102498:	89 44 24 04          	mov    %eax,0x4(%esp)
8010249c:	8b 45 08             	mov    0x8(%ebp),%eax
8010249f:	89 04 24             	mov    %eax,(%esp)
801024a2:	e8 54 fb ff ff       	call   80101ffb <bmap>
801024a7:	8b 55 08             	mov    0x8(%ebp),%edx
801024aa:	8b 12                	mov    (%edx),%edx
801024ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801024b0:	89 14 24             	mov    %edx,(%esp)
801024b3:	e8 fd dc ff ff       	call   801001b5 <bread>
801024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801024bb:	8b 45 10             	mov    0x10(%ebp),%eax
801024be:	25 ff 01 00 00       	and    $0x1ff,%eax
801024c3:	89 c2                	mov    %eax,%edx
801024c5:	b8 00 02 00 00       	mov    $0x200,%eax
801024ca:	29 d0                	sub    %edx,%eax
801024cc:	89 c1                	mov    %eax,%ecx
801024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024d1:	8b 55 14             	mov    0x14(%ebp),%edx
801024d4:	29 c2                	sub    %eax,%edx
801024d6:	89 c8                	mov    %ecx,%eax
801024d8:	39 d0                	cmp    %edx,%eax
801024da:	76 02                	jbe    801024de <writei+0x105>
801024dc:	89 d0                	mov    %edx,%eax
801024de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801024e1:	8b 45 10             	mov    0x10(%ebp),%eax
801024e4:	25 ff 01 00 00       	and    $0x1ff,%eax
801024e9:	8d 50 50             	lea    0x50(%eax),%edx
801024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024ef:	01 d0                	add    %edx,%eax
801024f1:	8d 50 0c             	lea    0xc(%eax),%edx
801024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801024fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801024fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102502:	89 14 24             	mov    %edx,(%esp)
80102505:	e8 01 30 00 00       	call   8010550b <memmove>
    log_write(bp);
8010250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250d:	89 04 24             	mov    %eax,(%esp)
80102510:	e8 c6 15 00 00       	call   80103adb <log_write>
    brelse(bp);
80102515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102518:	89 04 24             	mov    %eax,(%esp)
8010251b:	e8 0c dd ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102520:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102523:	01 45 f4             	add    %eax,-0xc(%ebp)
80102526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102529:	01 45 10             	add    %eax,0x10(%ebp)
8010252c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010252f:	01 45 0c             	add    %eax,0xc(%ebp)
80102532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102535:	3b 45 14             	cmp    0x14(%ebp),%eax
80102538:	0f 82 54 ff ff ff    	jb     80102492 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010253e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102542:	74 1f                	je     80102563 <writei+0x18a>
80102544:	8b 45 08             	mov    0x8(%ebp),%eax
80102547:	8b 40 58             	mov    0x58(%eax),%eax
8010254a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010254d:	73 14                	jae    80102563 <writei+0x18a>
    ip->size = off;
8010254f:	8b 45 08             	mov    0x8(%ebp),%eax
80102552:	8b 55 10             	mov    0x10(%ebp),%edx
80102555:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102558:	8b 45 08             	mov    0x8(%ebp),%eax
8010255b:	89 04 24             	mov    %eax,(%esp)
8010255e:	e8 b8 f6 ff ff       	call   80101c1b <iupdate>
  }
  return n;
80102563:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102566:	c9                   	leave  
80102567:	c3                   	ret    

80102568 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102568:	55                   	push   %ebp
80102569:	89 e5                	mov    %esp,%ebp
8010256b:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010256e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102575:	00 
80102576:	8b 45 0c             	mov    0xc(%ebp),%eax
80102579:	89 44 24 04          	mov    %eax,0x4(%esp)
8010257d:	8b 45 08             	mov    0x8(%ebp),%eax
80102580:	89 04 24             	mov    %eax,(%esp)
80102583:	e8 22 30 00 00       	call   801055aa <strncmp>
}
80102588:	c9                   	leave  
80102589:	c3                   	ret    

8010258a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010258a:	55                   	push   %ebp
8010258b:	89 e5                	mov    %esp,%ebp
8010258d:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102590:	8b 45 08             	mov    0x8(%ebp),%eax
80102593:	8b 40 50             	mov    0x50(%eax),%eax
80102596:	66 83 f8 01          	cmp    $0x1,%ax
8010259a:	74 0c                	je     801025a8 <dirlookup+0x1e>
    panic("dirlookup not DIR");
8010259c:	c7 04 24 49 87 10 80 	movl   $0x80108749,(%esp)
801025a3:	e8 ac df ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801025a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025af:	e9 86 00 00 00       	jmp    8010263a <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801025bb:	00 
801025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801025c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801025ca:	8b 45 08             	mov    0x8(%ebp),%eax
801025cd:	89 04 24             	mov    %eax,(%esp)
801025d0:	e8 a0 fc ff ff       	call   80102275 <readi>
801025d5:	83 f8 10             	cmp    $0x10,%eax
801025d8:	74 0c                	je     801025e6 <dirlookup+0x5c>
      panic("dirlookup read");
801025da:	c7 04 24 5b 87 10 80 	movl   $0x8010875b,(%esp)
801025e1:	e8 6e df ff ff       	call   80100554 <panic>
    if(de.inum == 0)
801025e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025e9:	66 85 c0             	test   %ax,%ax
801025ec:	75 02                	jne    801025f0 <dirlookup+0x66>
      continue;
801025ee:	eb 46                	jmp    80102636 <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
801025f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025f3:	83 c0 02             	add    $0x2,%eax
801025f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801025fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801025fd:	89 04 24             	mov    %eax,(%esp)
80102600:	e8 63 ff ff ff       	call   80102568 <namecmp>
80102605:	85 c0                	test   %eax,%eax
80102607:	75 2d                	jne    80102636 <dirlookup+0xac>
      // entry matches path element
      if(poff)
80102609:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010260d:	74 08                	je     80102617 <dirlookup+0x8d>
        *poff = off;
8010260f:	8b 45 10             	mov    0x10(%ebp),%eax
80102612:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102615:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102617:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010261a:	0f b7 c0             	movzwl %ax,%eax
8010261d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102620:	8b 45 08             	mov    0x8(%ebp),%eax
80102623:	8b 00                	mov    (%eax),%eax
80102625:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102628:	89 54 24 04          	mov    %edx,0x4(%esp)
8010262c:	89 04 24             	mov    %eax,(%esp)
8010262f:	e8 a3 f6 ff ff       	call   80101cd7 <iget>
80102634:	eb 18                	jmp    8010264e <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102636:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
8010263d:	8b 40 58             	mov    0x58(%eax),%eax
80102640:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102643:	0f 87 6b ff ff ff    	ja     801025b4 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102649:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010264e:	c9                   	leave  
8010264f:	c3                   	ret    

80102650 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102656:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010265d:	00 
8010265e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102661:	89 44 24 04          	mov    %eax,0x4(%esp)
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
80102668:	89 04 24             	mov    %eax,(%esp)
8010266b:	e8 1a ff ff ff       	call   8010258a <dirlookup>
80102670:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102673:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102677:	74 15                	je     8010268e <dirlink+0x3e>
    iput(ip);
80102679:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010267c:	89 04 24             	mov    %eax,(%esp)
8010267f:	e8 a8 f8 ff ff       	call   80101f2c <iput>
    return -1;
80102684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102689:	e9 b6 00 00 00       	jmp    80102744 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010268e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102695:	eb 45                	jmp    801026dc <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010269a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801026a1:	00 
801026a2:	89 44 24 08          	mov    %eax,0x8(%esp)
801026a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ad:	8b 45 08             	mov    0x8(%ebp),%eax
801026b0:	89 04 24             	mov    %eax,(%esp)
801026b3:	e8 bd fb ff ff       	call   80102275 <readi>
801026b8:	83 f8 10             	cmp    $0x10,%eax
801026bb:	74 0c                	je     801026c9 <dirlink+0x79>
      panic("dirlink read");
801026bd:	c7 04 24 6a 87 10 80 	movl   $0x8010876a,(%esp)
801026c4:	e8 8b de ff ff       	call   80100554 <panic>
    if(de.inum == 0)
801026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026cc:	66 85 c0             	test   %ax,%ax
801026cf:	75 02                	jne    801026d3 <dirlink+0x83>
      break;
801026d1:	eb 16                	jmp    801026e9 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d6:	83 c0 10             	add    $0x10,%eax
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801026df:	8b 45 08             	mov    0x8(%ebp),%eax
801026e2:	8b 40 58             	mov    0x58(%eax),%eax
801026e5:	39 c2                	cmp    %eax,%edx
801026e7:	72 ae                	jb     80102697 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801026e9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801026f0:	00 
801026f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801026f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801026fb:	83 c0 02             	add    $0x2,%eax
801026fe:	89 04 24             	mov    %eax,(%esp)
80102701:	e8 f2 2e 00 00       	call   801055f8 <strncpy>
  de.inum = inum;
80102706:	8b 45 10             	mov    0x10(%ebp),%eax
80102709:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102710:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102717:	00 
80102718:	89 44 24 08          	mov    %eax,0x8(%esp)
8010271c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010271f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102723:	8b 45 08             	mov    0x8(%ebp),%eax
80102726:	89 04 24             	mov    %eax,(%esp)
80102729:	e8 ab fc ff ff       	call   801023d9 <writei>
8010272e:	83 f8 10             	cmp    $0x10,%eax
80102731:	74 0c                	je     8010273f <dirlink+0xef>
    panic("dirlink");
80102733:	c7 04 24 77 87 10 80 	movl   $0x80108777,(%esp)
8010273a:	e8 15 de ff ff       	call   80100554 <panic>

  return 0;
8010273f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102744:	c9                   	leave  
80102745:	c3                   	ret    

80102746 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102746:	55                   	push   %ebp
80102747:	89 e5                	mov    %esp,%ebp
80102749:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010274c:	eb 03                	jmp    80102751 <skipelem+0xb>
    path++;
8010274e:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102751:	8b 45 08             	mov    0x8(%ebp),%eax
80102754:	8a 00                	mov    (%eax),%al
80102756:	3c 2f                	cmp    $0x2f,%al
80102758:	74 f4                	je     8010274e <skipelem+0x8>
    path++;
  if(*path == 0)
8010275a:	8b 45 08             	mov    0x8(%ebp),%eax
8010275d:	8a 00                	mov    (%eax),%al
8010275f:	84 c0                	test   %al,%al
80102761:	75 0a                	jne    8010276d <skipelem+0x27>
    return 0;
80102763:	b8 00 00 00 00       	mov    $0x0,%eax
80102768:	e9 81 00 00 00       	jmp    801027ee <skipelem+0xa8>
  s = path;
8010276d:	8b 45 08             	mov    0x8(%ebp),%eax
80102770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102773:	eb 03                	jmp    80102778 <skipelem+0x32>
    path++;
80102775:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102778:	8b 45 08             	mov    0x8(%ebp),%eax
8010277b:	8a 00                	mov    (%eax),%al
8010277d:	3c 2f                	cmp    $0x2f,%al
8010277f:	74 09                	je     8010278a <skipelem+0x44>
80102781:	8b 45 08             	mov    0x8(%ebp),%eax
80102784:	8a 00                	mov    (%eax),%al
80102786:	84 c0                	test   %al,%al
80102788:	75 eb                	jne    80102775 <skipelem+0x2f>
    path++;
  len = path - s;
8010278a:	8b 55 08             	mov    0x8(%ebp),%edx
8010278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102790:	29 c2                	sub    %eax,%edx
80102792:	89 d0                	mov    %edx,%eax
80102794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102797:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010279b:	7e 1c                	jle    801027b9 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
8010279d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801027a4:	00 
801027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801027ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801027af:	89 04 24             	mov    %eax,(%esp)
801027b2:	e8 54 2d 00 00       	call   8010550b <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801027b7:	eb 29                	jmp    801027e2 <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801027ca:	89 04 24             	mov    %eax,(%esp)
801027cd:	e8 39 2d 00 00       	call   8010550b <memmove>
    name[len] = 0;
801027d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801027d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801027d8:	01 d0                	add    %edx,%eax
801027da:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801027dd:	eb 03                	jmp    801027e2 <skipelem+0x9c>
    path++;
801027df:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	8a 00                	mov    (%eax),%al
801027e7:	3c 2f                	cmp    $0x2f,%al
801027e9:	74 f4                	je     801027df <skipelem+0x99>
    path++;
  return path;
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801027ee:	c9                   	leave  
801027ef:	c3                   	ret    

801027f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801027f6:	8b 45 08             	mov    0x8(%ebp),%eax
801027f9:	8a 00                	mov    (%eax),%al
801027fb:	3c 2f                	cmp    $0x2f,%al
801027fd:	75 1c                	jne    8010281b <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801027ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102806:	00 
80102807:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010280e:	e8 c4 f4 ff ff       	call   80101cd7 <iget>
80102813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102816:	e9 ac 00 00 00       	jmp    801028c7 <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010281b:	e8 af 1d 00 00       	call   801045cf <myproc>
80102820:	8b 40 68             	mov    0x68(%eax),%eax
80102823:	89 04 24             	mov    %eax,(%esp)
80102826:	e8 81 f5 ff ff       	call   80101dac <idup>
8010282b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010282e:	e9 94 00 00 00       	jmp    801028c7 <namex+0xd7>
    ilock(ip);
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	89 04 24             	mov    %eax,(%esp)
80102839:	e8 a0 f5 ff ff       	call   80101dde <ilock>
    if(ip->type != T_DIR){
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	8b 40 50             	mov    0x50(%eax),%eax
80102844:	66 83 f8 01          	cmp    $0x1,%ax
80102848:	74 15                	je     8010285f <namex+0x6f>
      iunlockput(ip);
8010284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284d:	89 04 24             	mov    %eax,(%esp)
80102850:	e8 88 f7 ff ff       	call   80101fdd <iunlockput>
      return 0;
80102855:	b8 00 00 00 00       	mov    $0x0,%eax
8010285a:	e9 a2 00 00 00       	jmp    80102901 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
8010285f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102863:	74 1c                	je     80102881 <namex+0x91>
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
80102868:	8a 00                	mov    (%eax),%al
8010286a:	84 c0                	test   %al,%al
8010286c:	75 13                	jne    80102881 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
8010286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102871:	89 04 24             	mov    %eax,(%esp)
80102874:	e8 6f f6 ff ff       	call   80101ee8 <iunlock>
      return ip;
80102879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287c:	e9 80 00 00 00       	jmp    80102901 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102888:	00 
80102889:	8b 45 10             	mov    0x10(%ebp),%eax
8010288c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102893:	89 04 24             	mov    %eax,(%esp)
80102896:	e8 ef fc ff ff       	call   8010258a <dirlookup>
8010289b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010289e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801028a2:	75 12                	jne    801028b6 <namex+0xc6>
      iunlockput(ip);
801028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a7:	89 04 24             	mov    %eax,(%esp)
801028aa:	e8 2e f7 ff ff       	call   80101fdd <iunlockput>
      return 0;
801028af:	b8 00 00 00 00       	mov    $0x0,%eax
801028b4:	eb 4b                	jmp    80102901 <namex+0x111>
    }
    iunlockput(ip);
801028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b9:	89 04 24             	mov    %eax,(%esp)
801028bc:	e8 1c f7 ff ff       	call   80101fdd <iunlockput>
    ip = next;
801028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801028c7:	8b 45 10             	mov    0x10(%ebp),%eax
801028ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801028ce:	8b 45 08             	mov    0x8(%ebp),%eax
801028d1:	89 04 24             	mov    %eax,(%esp)
801028d4:	e8 6d fe ff ff       	call   80102746 <skipelem>
801028d9:	89 45 08             	mov    %eax,0x8(%ebp)
801028dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028e0:	0f 85 4d ff ff ff    	jne    80102833 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801028e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801028ea:	74 12                	je     801028fe <namex+0x10e>
    iput(ip);
801028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ef:	89 04 24             	mov    %eax,(%esp)
801028f2:	e8 35 f6 ff ff       	call   80101f2c <iput>
    return 0;
801028f7:	b8 00 00 00 00       	mov    $0x0,%eax
801028fc:	eb 03                	jmp    80102901 <namex+0x111>
  }
  return ip;
801028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102901:	c9                   	leave  
80102902:	c3                   	ret    

80102903 <namei>:

struct inode*
namei(char *path)
{
80102903:	55                   	push   %ebp
80102904:	89 e5                	mov    %esp,%ebp
80102906:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102909:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010290c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102910:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102917:	00 
80102918:	8b 45 08             	mov    0x8(%ebp),%eax
8010291b:	89 04 24             	mov    %eax,(%esp)
8010291e:	e8 cd fe ff ff       	call   801027f0 <namex>
}
80102923:	c9                   	leave  
80102924:	c3                   	ret    

80102925 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102925:	55                   	push   %ebp
80102926:	89 e5                	mov    %esp,%ebp
80102928:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010292b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010292e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102932:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102939:	00 
8010293a:	8b 45 08             	mov    0x8(%ebp),%eax
8010293d:	89 04 24             	mov    %eax,(%esp)
80102940:	e8 ab fe ff ff       	call   801027f0 <namex>
}
80102945:	c9                   	leave  
80102946:	c3                   	ret    
	...

80102948 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102948:	55                   	push   %ebp
80102949:	89 e5                	mov    %esp,%ebp
8010294b:	83 ec 14             	sub    $0x14,%esp
8010294e:	8b 45 08             	mov    0x8(%ebp),%eax
80102951:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102958:	89 c2                	mov    %eax,%edx
8010295a:	ec                   	in     (%dx),%al
8010295b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010295e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102961:	c9                   	leave  
80102962:	c3                   	ret    

80102963 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102963:	55                   	push   %ebp
80102964:	89 e5                	mov    %esp,%ebp
80102966:	57                   	push   %edi
80102967:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102968:	8b 55 08             	mov    0x8(%ebp),%edx
8010296b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010296e:	8b 45 10             	mov    0x10(%ebp),%eax
80102971:	89 cb                	mov    %ecx,%ebx
80102973:	89 df                	mov    %ebx,%edi
80102975:	89 c1                	mov    %eax,%ecx
80102977:	fc                   	cld    
80102978:	f3 6d                	rep insl (%dx),%es:(%edi)
8010297a:	89 c8                	mov    %ecx,%eax
8010297c:	89 fb                	mov    %edi,%ebx
8010297e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102981:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102984:	5b                   	pop    %ebx
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    

80102988 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102988:	55                   	push   %ebp
80102989:	89 e5                	mov    %esp,%ebp
8010298b:	83 ec 08             	sub    $0x8,%esp
8010298e:	8b 45 08             	mov    0x8(%ebp),%eax
80102991:	8b 55 0c             	mov    0xc(%ebp),%edx
80102994:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102998:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010299b:	8a 45 f8             	mov    -0x8(%ebp),%al
8010299e:	8b 55 fc             	mov    -0x4(%ebp),%edx
801029a1:	ee                   	out    %al,(%dx)
}
801029a2:	c9                   	leave  
801029a3:	c3                   	ret    

801029a4 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801029a4:	55                   	push   %ebp
801029a5:	89 e5                	mov    %esp,%ebp
801029a7:	56                   	push   %esi
801029a8:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801029a9:	8b 55 08             	mov    0x8(%ebp),%edx
801029ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029af:	8b 45 10             	mov    0x10(%ebp),%eax
801029b2:	89 cb                	mov    %ecx,%ebx
801029b4:	89 de                	mov    %ebx,%esi
801029b6:	89 c1                	mov    %eax,%ecx
801029b8:	fc                   	cld    
801029b9:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801029bb:	89 c8                	mov    %ecx,%eax
801029bd:	89 f3                	mov    %esi,%ebx
801029bf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801029c2:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801029c5:	5b                   	pop    %ebx
801029c6:	5e                   	pop    %esi
801029c7:	5d                   	pop    %ebp
801029c8:	c3                   	ret    

801029c9 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801029c9:	55                   	push   %ebp
801029ca:	89 e5                	mov    %esp,%ebp
801029cc:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801029cf:	90                   	nop
801029d0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801029d7:	e8 6c ff ff ff       	call   80102948 <inb>
801029dc:	0f b6 c0             	movzbl %al,%eax
801029df:	89 45 fc             	mov    %eax,-0x4(%ebp)
801029e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801029e5:	25 c0 00 00 00       	and    $0xc0,%eax
801029ea:	83 f8 40             	cmp    $0x40,%eax
801029ed:	75 e1                	jne    801029d0 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801029ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801029f3:	74 11                	je     80102a06 <idewait+0x3d>
801029f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801029f8:	83 e0 21             	and    $0x21,%eax
801029fb:	85 c0                	test   %eax,%eax
801029fd:	74 07                	je     80102a06 <idewait+0x3d>
    return -1;
801029ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a04:	eb 05                	jmp    80102a0b <idewait+0x42>
  return 0;
80102a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102a0b:	c9                   	leave  
80102a0c:	c3                   	ret    

80102a0d <ideinit>:

void
ideinit(void)
{
80102a0d:	55                   	push   %ebp
80102a0e:	89 e5                	mov    %esp,%ebp
80102a10:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102a13:	c7 44 24 04 7f 87 10 	movl   $0x8010877f,0x4(%esp)
80102a1a:	80 
80102a1b:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102a22:	e8 97 27 00 00       	call   801051be <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102a27:	a1 20 3f 11 80       	mov    0x80113f20,%eax
80102a2c:	48                   	dec    %eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102a38:	e8 66 04 00 00       	call   80102ea3 <ioapicenable>
  idewait(0);
80102a3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a44:	e8 80 ff ff ff       	call   801029c9 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102a49:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102a50:	00 
80102a51:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102a58:	e8 2b ff ff ff       	call   80102988 <outb>
  for(i=0; i<1000; i++){
80102a5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a64:	eb 1f                	jmp    80102a85 <ideinit+0x78>
    if(inb(0x1f7) != 0){
80102a66:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102a6d:	e8 d6 fe ff ff       	call   80102948 <inb>
80102a72:	84 c0                	test   %al,%al
80102a74:	74 0c                	je     80102a82 <ideinit+0x75>
      havedisk1 = 1;
80102a76:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
80102a7d:	00 00 00 
      break;
80102a80:	eb 0c                	jmp    80102a8e <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102a82:	ff 45 f4             	incl   -0xc(%ebp)
80102a85:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102a8c:	7e d8                	jle    80102a66 <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102a8e:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102a95:	00 
80102a96:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102a9d:	e8 e6 fe ff ff       	call   80102988 <outb>
}
80102aa2:	c9                   	leave  
80102aa3:	c3                   	ret    

80102aa4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102aa4:	55                   	push   %ebp
80102aa5:	89 e5                	mov    %esp,%ebp
80102aa7:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102aae:	75 0c                	jne    80102abc <idestart+0x18>
    panic("idestart");
80102ab0:	c7 04 24 83 87 10 80 	movl   $0x80108783,(%esp)
80102ab7:	e8 98 da ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
80102abc:	8b 45 08             	mov    0x8(%ebp),%eax
80102abf:	8b 40 08             	mov    0x8(%eax),%eax
80102ac2:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102ac7:	76 0c                	jbe    80102ad5 <idestart+0x31>
    panic("incorrect blockno");
80102ac9:	c7 04 24 8c 87 10 80 	movl   $0x8010878c,(%esp)
80102ad0:	e8 7f da ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102ad5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102adc:	8b 45 08             	mov    0x8(%ebp),%eax
80102adf:	8b 50 08             	mov    0x8(%eax),%edx
80102ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae5:	0f af c2             	imul   %edx,%eax
80102ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102aeb:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102aef:	75 07                	jne    80102af8 <idestart+0x54>
80102af1:	b8 20 00 00 00       	mov    $0x20,%eax
80102af6:	eb 05                	jmp    80102afd <idestart+0x59>
80102af8:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102b00:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102b04:	75 07                	jne    80102b0d <idestart+0x69>
80102b06:	b8 30 00 00 00       	mov    $0x30,%eax
80102b0b:	eb 05                	jmp    80102b12 <idestart+0x6e>
80102b0d:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102b12:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102b15:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102b19:	7e 0c                	jle    80102b27 <idestart+0x83>
80102b1b:	c7 04 24 83 87 10 80 	movl   $0x80108783,(%esp)
80102b22:	e8 2d da ff ff       	call   80100554 <panic>

  idewait(0);
80102b27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102b2e:	e8 96 fe ff ff       	call   801029c9 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102b33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102b3a:	00 
80102b3b:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102b42:	e8 41 fe ff ff       	call   80102988 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
80102b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4a:	0f b6 c0             	movzbl %al,%eax
80102b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b51:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102b58:	e8 2b fe ff ff       	call   80102988 <outb>
  outb(0x1f3, sector & 0xff);
80102b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b60:	0f b6 c0             	movzbl %al,%eax
80102b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b67:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102b6e:	e8 15 fe ff ff       	call   80102988 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
80102b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b76:	c1 f8 08             	sar    $0x8,%eax
80102b79:	0f b6 c0             	movzbl %al,%eax
80102b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b80:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102b87:	e8 fc fd ff ff       	call   80102988 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b8f:	c1 f8 10             	sar    $0x10,%eax
80102b92:	0f b6 c0             	movzbl %al,%eax
80102b95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b99:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102ba0:	e8 e3 fd ff ff       	call   80102988 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba8:	8b 40 04             	mov    0x4(%eax),%eax
80102bab:	83 e0 01             	and    $0x1,%eax
80102bae:	c1 e0 04             	shl    $0x4,%eax
80102bb1:	88 c2                	mov    %al,%dl
80102bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102bb6:	c1 f8 18             	sar    $0x18,%eax
80102bb9:	83 e0 0f             	and    $0xf,%eax
80102bbc:	09 d0                	or     %edx,%eax
80102bbe:	83 c8 e0             	or     $0xffffffe0,%eax
80102bc1:	0f b6 c0             	movzbl %al,%eax
80102bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bc8:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102bcf:	e8 b4 fd ff ff       	call   80102988 <outb>
  if(b->flags & B_DIRTY){
80102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd7:	8b 00                	mov    (%eax),%eax
80102bd9:	83 e0 04             	and    $0x4,%eax
80102bdc:	85 c0                	test   %eax,%eax
80102bde:	74 36                	je     80102c16 <idestart+0x172>
    outb(0x1f7, write_cmd);
80102be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102be3:	0f b6 c0             	movzbl %al,%eax
80102be6:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bea:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102bf1:	e8 92 fd ff ff       	call   80102988 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf9:	83 c0 5c             	add    $0x5c,%eax
80102bfc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102c03:	00 
80102c04:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c08:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102c0f:	e8 90 fd ff ff       	call   801029a4 <outsl>
80102c14:	eb 16                	jmp    80102c2c <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102c19:	0f b6 c0             	movzbl %al,%eax
80102c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c20:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102c27:	e8 5c fd ff ff       	call   80102988 <outb>
  }
}
80102c2c:	c9                   	leave  
80102c2d:	c3                   	ret    

80102c2e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102c34:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102c3b:	e8 9f 25 00 00       	call   801051df <acquire>

  if((b = idequeue) == 0){
80102c40:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c4c:	75 11                	jne    80102c5f <ideintr+0x31>
    release(&idelock);
80102c4e:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102c55:	e8 ef 25 00 00       	call   80105249 <release>
    return;
80102c5a:	e9 90 00 00 00       	jmp    80102cef <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c62:	8b 40 58             	mov    0x58(%eax),%eax
80102c65:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	8b 00                	mov    (%eax),%eax
80102c6f:	83 e0 04             	and    $0x4,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	75 2e                	jne    80102ca4 <ideintr+0x76>
80102c76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102c7d:	e8 47 fd ff ff       	call   801029c9 <idewait>
80102c82:	85 c0                	test   %eax,%eax
80102c84:	78 1e                	js     80102ca4 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c89:	83 c0 5c             	add    $0x5c,%eax
80102c8c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102c93:	00 
80102c94:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c98:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102c9f:	e8 bf fc ff ff       	call   80102963 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca7:	8b 00                	mov    (%eax),%eax
80102ca9:	83 c8 02             	or     $0x2,%eax
80102cac:	89 c2                	mov    %eax,%edx
80102cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb1:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb6:	8b 00                	mov    (%eax),%eax
80102cb8:	83 e0 fb             	and    $0xfffffffb,%eax
80102cbb:	89 c2                	mov    %eax,%edx
80102cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc0:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc5:	89 04 24             	mov    %eax,(%esp)
80102cc8:	e8 17 22 00 00       	call   80104ee4 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ccd:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	74 0d                	je     80102ce3 <ideintr+0xb5>
    idestart(idequeue);
80102cd6:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102cdb:	89 04 24             	mov    %eax,(%esp)
80102cde:	e8 c1 fd ff ff       	call   80102aa4 <idestart>

  release(&idelock);
80102ce3:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102cea:	e8 5a 25 00 00       	call   80105249 <release>
}
80102cef:	c9                   	leave  
80102cf0:	c3                   	ret    

80102cf1 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102cf1:	55                   	push   %ebp
80102cf2:	89 e5                	mov    %esp,%ebp
80102cf4:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80102cfa:	83 c0 0c             	add    $0xc,%eax
80102cfd:	89 04 24             	mov    %eax,(%esp)
80102d00:	e8 52 24 00 00       	call   80105157 <holdingsleep>
80102d05:	85 c0                	test   %eax,%eax
80102d07:	75 0c                	jne    80102d15 <iderw+0x24>
    panic("iderw: buf not locked");
80102d09:	c7 04 24 9e 87 10 80 	movl   $0x8010879e,(%esp)
80102d10:	e8 3f d8 ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102d15:	8b 45 08             	mov    0x8(%ebp),%eax
80102d18:	8b 00                	mov    (%eax),%eax
80102d1a:	83 e0 06             	and    $0x6,%eax
80102d1d:	83 f8 02             	cmp    $0x2,%eax
80102d20:	75 0c                	jne    80102d2e <iderw+0x3d>
    panic("iderw: nothing to do");
80102d22:	c7 04 24 b4 87 10 80 	movl   $0x801087b4,(%esp)
80102d29:	e8 26 d8 ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
80102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d31:	8b 40 04             	mov    0x4(%eax),%eax
80102d34:	85 c0                	test   %eax,%eax
80102d36:	74 15                	je     80102d4d <iderw+0x5c>
80102d38:	a1 18 b6 10 80       	mov    0x8010b618,%eax
80102d3d:	85 c0                	test   %eax,%eax
80102d3f:	75 0c                	jne    80102d4d <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102d41:	c7 04 24 c9 87 10 80 	movl   $0x801087c9,(%esp)
80102d48:	e8 07 d8 ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102d4d:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102d54:	e8 86 24 00 00       	call   801051df <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102d59:	8b 45 08             	mov    0x8(%ebp),%eax
80102d5c:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d63:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
80102d6a:	eb 0b                	jmp    80102d77 <iderw+0x86>
80102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6f:	8b 00                	mov    (%eax),%eax
80102d71:	83 c0 58             	add    $0x58,%eax
80102d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d7a:	8b 00                	mov    (%eax),%eax
80102d7c:	85 c0                	test   %eax,%eax
80102d7e:	75 ec                	jne    80102d6c <iderw+0x7b>
    ;
  *pp = b;
80102d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d83:	8b 55 08             	mov    0x8(%ebp),%edx
80102d86:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102d88:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102d8d:	3b 45 08             	cmp    0x8(%ebp),%eax
80102d90:	75 0d                	jne    80102d9f <iderw+0xae>
    idestart(b);
80102d92:	8b 45 08             	mov    0x8(%ebp),%eax
80102d95:	89 04 24             	mov    %eax,(%esp)
80102d98:	e8 07 fd ff ff       	call   80102aa4 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d9d:	eb 15                	jmp    80102db4 <iderw+0xc3>
80102d9f:	eb 13                	jmp    80102db4 <iderw+0xc3>
    sleep(b, &idelock);
80102da1:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80102da8:	80 
80102da9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dac:	89 04 24             	mov    %eax,(%esp)
80102daf:	e8 5c 20 00 00       	call   80104e10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102db4:	8b 45 08             	mov    0x8(%ebp),%eax
80102db7:	8b 00                	mov    (%eax),%eax
80102db9:	83 e0 06             	and    $0x6,%eax
80102dbc:	83 f8 02             	cmp    $0x2,%eax
80102dbf:	75 e0                	jne    80102da1 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102dc1:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102dc8:	e8 7c 24 00 00       	call   80105249 <release>
}
80102dcd:	c9                   	leave  
80102dce:	c3                   	ret    
	...

80102dd0 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102dd3:	a1 54 38 11 80       	mov    0x80113854,%eax
80102dd8:	8b 55 08             	mov    0x8(%ebp),%edx
80102ddb:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102ddd:	a1 54 38 11 80       	mov    0x80113854,%eax
80102de2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102de5:	5d                   	pop    %ebp
80102de6:	c3                   	ret    

80102de7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102de7:	55                   	push   %ebp
80102de8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102dea:	a1 54 38 11 80       	mov    0x80113854,%eax
80102def:	8b 55 08             	mov    0x8(%ebp),%edx
80102df2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102df4:	a1 54 38 11 80       	mov    0x80113854,%eax
80102df9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102dfc:	89 50 10             	mov    %edx,0x10(%eax)
}
80102dff:	5d                   	pop    %ebp
80102e00:	c3                   	ret    

80102e01 <ioapicinit>:

void
ioapicinit(void)
{
80102e01:	55                   	push   %ebp
80102e02:	89 e5                	mov    %esp,%ebp
80102e04:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102e07:	c7 05 54 38 11 80 00 	movl   $0xfec00000,0x80113854
80102e0e:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102e11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102e18:	e8 b3 ff ff ff       	call   80102dd0 <ioapicread>
80102e1d:	c1 e8 10             	shr    $0x10,%eax
80102e20:	25 ff 00 00 00       	and    $0xff,%eax
80102e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102e2f:	e8 9c ff ff ff       	call   80102dd0 <ioapicread>
80102e34:	c1 e8 18             	shr    $0x18,%eax
80102e37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102e3a:	a0 80 39 11 80       	mov    0x80113980,%al
80102e3f:	0f b6 c0             	movzbl %al,%eax
80102e42:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102e45:	74 0c                	je     80102e53 <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102e47:	c7 04 24 e8 87 10 80 	movl   $0x801087e8,(%esp)
80102e4e:	e8 6e d5 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e5a:	eb 3d                	jmp    80102e99 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e5f:	83 c0 20             	add    $0x20,%eax
80102e62:	0d 00 00 01 00       	or     $0x10000,%eax
80102e67:	89 c2                	mov    %eax,%edx
80102e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e6c:	83 c0 08             	add    $0x8,%eax
80102e6f:	01 c0                	add    %eax,%eax
80102e71:	89 54 24 04          	mov    %edx,0x4(%esp)
80102e75:	89 04 24             	mov    %eax,(%esp)
80102e78:	e8 6a ff ff ff       	call   80102de7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e80:	83 c0 08             	add    $0x8,%eax
80102e83:	01 c0                	add    %eax,%eax
80102e85:	40                   	inc    %eax
80102e86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e8d:	00 
80102e8e:	89 04 24             	mov    %eax,(%esp)
80102e91:	e8 51 ff ff ff       	call   80102de7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e96:	ff 45 f4             	incl   -0xc(%ebp)
80102e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e9f:	7e bb                	jle    80102e5c <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ea1:	c9                   	leave  
80102ea2:	c3                   	ret    

80102ea3 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ea3:	55                   	push   %ebp
80102ea4:	89 e5                	mov    %esp,%ebp
80102ea6:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80102eac:	83 c0 20             	add    $0x20,%eax
80102eaf:	89 c2                	mov    %eax,%edx
80102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80102eb4:	83 c0 08             	add    $0x8,%eax
80102eb7:	01 c0                	add    %eax,%eax
80102eb9:	89 54 24 04          	mov    %edx,0x4(%esp)
80102ebd:	89 04 24             	mov    %eax,(%esp)
80102ec0:	e8 22 ff ff ff       	call   80102de7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ec8:	c1 e0 18             	shl    $0x18,%eax
80102ecb:	8b 55 08             	mov    0x8(%ebp),%edx
80102ece:	83 c2 08             	add    $0x8,%edx
80102ed1:	01 d2                	add    %edx,%edx
80102ed3:	42                   	inc    %edx
80102ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ed8:	89 14 24             	mov    %edx,(%esp)
80102edb:	e8 07 ff ff ff       	call   80102de7 <ioapicwrite>
}
80102ee0:	c9                   	leave  
80102ee1:	c3                   	ret    
	...

80102ee4 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ee4:	55                   	push   %ebp
80102ee5:	89 e5                	mov    %esp,%ebp
80102ee7:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102eea:	c7 44 24 04 1a 88 10 	movl   $0x8010881a,0x4(%esp)
80102ef1:	80 
80102ef2:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80102ef9:	e8 c0 22 00 00       	call   801051be <initlock>
  kmem.use_lock = 0;
80102efe:	c7 05 94 38 11 80 00 	movl   $0x0,0x80113894
80102f05:	00 00 00 
  freerange(vstart, vend);
80102f08:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f12:	89 04 24             	mov    %eax,(%esp)
80102f15:	e8 26 00 00 00       	call   80102f40 <freerange>
}
80102f1a:	c9                   	leave  
80102f1b:	c3                   	ret    

80102f1c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102f1c:	55                   	push   %ebp
80102f1d:	89 e5                	mov    %esp,%ebp
80102f1f:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102f22:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f29:	8b 45 08             	mov    0x8(%ebp),%eax
80102f2c:	89 04 24             	mov    %eax,(%esp)
80102f2f:	e8 0c 00 00 00       	call   80102f40 <freerange>
  kmem.use_lock = 1;
80102f34:	c7 05 94 38 11 80 01 	movl   $0x1,0x80113894
80102f3b:	00 00 00 
}
80102f3e:	c9                   	leave  
80102f3f:	c3                   	ret    

80102f40 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102f46:	8b 45 08             	mov    0x8(%ebp),%eax
80102f49:	05 ff 0f 00 00       	add    $0xfff,%eax
80102f4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f56:	eb 12                	jmp    80102f6a <freerange+0x2a>
    kfree(p);
80102f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f5b:	89 04 24             	mov    %eax,(%esp)
80102f5e:	e8 16 00 00 00       	call   80102f79 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f63:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f6d:	05 00 10 00 00       	add    $0x1000,%eax
80102f72:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102f75:	76 e1                	jbe    80102f58 <freerange+0x18>
    kfree(p);
}
80102f77:	c9                   	leave  
80102f78:	c3                   	ret    

80102f79 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f79:	55                   	push   %ebp
80102f7a:	89 e5                	mov    %esp,%ebp
80102f7c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f82:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f87:	85 c0                	test   %eax,%eax
80102f89:	75 18                	jne    80102fa3 <kfree+0x2a>
80102f8b:	81 7d 08 c8 66 11 80 	cmpl   $0x801166c8,0x8(%ebp)
80102f92:	72 0f                	jb     80102fa3 <kfree+0x2a>
80102f94:	8b 45 08             	mov    0x8(%ebp),%eax
80102f97:	05 00 00 00 80       	add    $0x80000000,%eax
80102f9c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102fa1:	76 0c                	jbe    80102faf <kfree+0x36>
    panic("kfree");
80102fa3:	c7 04 24 1f 88 10 80 	movl   $0x8010881f,(%esp)
80102faa:	e8 a5 d5 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102faf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102fb6:	00 
80102fb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102fbe:	00 
80102fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80102fc2:	89 04 24             	mov    %eax,(%esp)
80102fc5:	e8 78 24 00 00       	call   80105442 <memset>

  if(kmem.use_lock)
80102fca:	a1 94 38 11 80       	mov    0x80113894,%eax
80102fcf:	85 c0                	test   %eax,%eax
80102fd1:	74 0c                	je     80102fdf <kfree+0x66>
    acquire(&kmem.lock);
80102fd3:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80102fda:	e8 00 22 00 00       	call   801051df <acquire>
  r = (struct run*)v;
80102fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80102fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102fe5:	8b 15 98 38 11 80    	mov    0x80113898,%edx
80102feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fee:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ff3:	a3 98 38 11 80       	mov    %eax,0x80113898
  if(kmem.use_lock)
80102ff8:	a1 94 38 11 80       	mov    0x80113894,%eax
80102ffd:	85 c0                	test   %eax,%eax
80102fff:	74 0c                	je     8010300d <kfree+0x94>
    release(&kmem.lock);
80103001:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103008:	e8 3c 22 00 00       	call   80105249 <release>
}
8010300d:	c9                   	leave  
8010300e:	c3                   	ret    

8010300f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010300f:	55                   	push   %ebp
80103010:	89 e5                	mov    %esp,%ebp
80103012:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80103015:	a1 94 38 11 80       	mov    0x80113894,%eax
8010301a:	85 c0                	test   %eax,%eax
8010301c:	74 0c                	je     8010302a <kalloc+0x1b>
    acquire(&kmem.lock);
8010301e:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103025:	e8 b5 21 00 00       	call   801051df <acquire>
  r = kmem.freelist;
8010302a:	a1 98 38 11 80       	mov    0x80113898,%eax
8010302f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80103032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103036:	74 0a                	je     80103042 <kalloc+0x33>
    kmem.freelist = r->next;
80103038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303b:	8b 00                	mov    (%eax),%eax
8010303d:	a3 98 38 11 80       	mov    %eax,0x80113898
  if(kmem.use_lock)
80103042:	a1 94 38 11 80       	mov    0x80113894,%eax
80103047:	85 c0                	test   %eax,%eax
80103049:	74 0c                	je     80103057 <kalloc+0x48>
    release(&kmem.lock);
8010304b:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103052:	e8 f2 21 00 00       	call   80105249 <release>
  return (char*)r;
80103057:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010305a:	c9                   	leave  
8010305b:	c3                   	ret    

8010305c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010305c:	55                   	push   %ebp
8010305d:	89 e5                	mov    %esp,%ebp
8010305f:	83 ec 14             	sub    $0x14,%esp
80103062:	8b 45 08             	mov    0x8(%ebp),%eax
80103065:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103069:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010306c:	89 c2                	mov    %eax,%edx
8010306e:	ec                   	in     (%dx),%al
8010306f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103072:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103075:	c9                   	leave  
80103076:	c3                   	ret    

80103077 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103077:	55                   	push   %ebp
80103078:	89 e5                	mov    %esp,%ebp
8010307a:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
8010307d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103084:	e8 d3 ff ff ff       	call   8010305c <inb>
80103089:	0f b6 c0             	movzbl %al,%eax
8010308c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
8010308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103092:	83 e0 01             	and    $0x1,%eax
80103095:	85 c0                	test   %eax,%eax
80103097:	75 0a                	jne    801030a3 <kbdgetc+0x2c>
    return -1;
80103099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010309e:	e9 21 01 00 00       	jmp    801031c4 <kbdgetc+0x14d>
  data = inb(KBDATAP);
801030a3:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
801030aa:	e8 ad ff ff ff       	call   8010305c <inb>
801030af:	0f b6 c0             	movzbl %al,%eax
801030b2:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
801030b5:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
801030bc:	75 17                	jne    801030d5 <kbdgetc+0x5e>
    shift |= E0ESC;
801030be:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
801030c3:	83 c8 40             	or     $0x40,%eax
801030c6:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
801030cb:	b8 00 00 00 00       	mov    $0x0,%eax
801030d0:	e9 ef 00 00 00       	jmp    801031c4 <kbdgetc+0x14d>
  } else if(data & 0x80){
801030d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030d8:	25 80 00 00 00       	and    $0x80,%eax
801030dd:	85 c0                	test   %eax,%eax
801030df:	74 44                	je     80103125 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801030e1:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
801030e6:	83 e0 40             	and    $0x40,%eax
801030e9:	85 c0                	test   %eax,%eax
801030eb:	75 08                	jne    801030f5 <kbdgetc+0x7e>
801030ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030f0:	83 e0 7f             	and    $0x7f,%eax
801030f3:	eb 03                	jmp    801030f8 <kbdgetc+0x81>
801030f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
801030fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030fe:	05 20 90 10 80       	add    $0x80109020,%eax
80103103:	8a 00                	mov    (%eax),%al
80103105:	83 c8 40             	or     $0x40,%eax
80103108:	0f b6 c0             	movzbl %al,%eax
8010310b:	f7 d0                	not    %eax
8010310d:	89 c2                	mov    %eax,%edx
8010310f:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80103114:	21 d0                	and    %edx,%eax
80103116:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
8010311b:	b8 00 00 00 00       	mov    $0x0,%eax
80103120:	e9 9f 00 00 00       	jmp    801031c4 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80103125:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
8010312a:	83 e0 40             	and    $0x40,%eax
8010312d:	85 c0                	test   %eax,%eax
8010312f:	74 14                	je     80103145 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103131:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80103138:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
8010313d:	83 e0 bf             	and    $0xffffffbf,%eax
80103140:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80103145:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103148:	05 20 90 10 80       	add    $0x80109020,%eax
8010314d:	8a 00                	mov    (%eax),%al
8010314f:	0f b6 d0             	movzbl %al,%edx
80103152:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80103157:	09 d0                	or     %edx,%eax
80103159:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
8010315e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103161:	05 20 91 10 80       	add    $0x80109120,%eax
80103166:	8a 00                	mov    (%eax),%al
80103168:	0f b6 d0             	movzbl %al,%edx
8010316b:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80103170:	31 d0                	xor    %edx,%eax
80103172:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80103177:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
8010317c:	83 e0 03             	and    $0x3,%eax
8010317f:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80103186:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103189:	01 d0                	add    %edx,%eax
8010318b:	8a 00                	mov    (%eax),%al
8010318d:	0f b6 c0             	movzbl %al,%eax
80103190:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80103193:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80103198:	83 e0 08             	and    $0x8,%eax
8010319b:	85 c0                	test   %eax,%eax
8010319d:	74 22                	je     801031c1 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010319f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801031a3:	76 0c                	jbe    801031b1 <kbdgetc+0x13a>
801031a5:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801031a9:	77 06                	ja     801031b1 <kbdgetc+0x13a>
      c += 'A' - 'a';
801031ab:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
801031af:	eb 10                	jmp    801031c1 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
801031b1:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801031b5:	76 0a                	jbe    801031c1 <kbdgetc+0x14a>
801031b7:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801031bb:	77 04                	ja     801031c1 <kbdgetc+0x14a>
      c += 'a' - 'A';
801031bd:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
801031c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801031c4:	c9                   	leave  
801031c5:	c3                   	ret    

801031c6 <kbdintr>:

void
kbdintr(void)
{
801031c6:	55                   	push   %ebp
801031c7:	89 e5                	mov    %esp,%ebp
801031c9:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801031cc:	c7 04 24 77 30 10 80 	movl   $0x80103077,(%esp)
801031d3:	e8 ed d5 ff ff       	call   801007c5 <consoleintr>
}
801031d8:	c9                   	leave  
801031d9:	c3                   	ret    
	...

801031dc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801031dc:	55                   	push   %ebp
801031dd:	89 e5                	mov    %esp,%ebp
801031df:	83 ec 14             	sub    $0x14,%esp
801031e2:	8b 45 08             	mov    0x8(%ebp),%eax
801031e5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	ec                   	in     (%dx),%al
801031ef:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801031f2:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801031f5:	c9                   	leave  
801031f6:	c3                   	ret    

801031f7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801031f7:	55                   	push   %ebp
801031f8:	89 e5                	mov    %esp,%ebp
801031fa:	83 ec 08             	sub    $0x8,%esp
801031fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103200:	8b 55 0c             	mov    0xc(%ebp),%edx
80103203:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103207:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010320a:	8a 45 f8             	mov    -0x8(%ebp),%al
8010320d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103210:	ee                   	out    %al,(%dx)
}
80103211:	c9                   	leave  
80103212:	c3                   	ret    

80103213 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103213:	55                   	push   %ebp
80103214:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103216:	a1 9c 38 11 80       	mov    0x8011389c,%eax
8010321b:	8b 55 08             	mov    0x8(%ebp),%edx
8010321e:	c1 e2 02             	shl    $0x2,%edx
80103221:	01 c2                	add    %eax,%edx
80103223:	8b 45 0c             	mov    0xc(%ebp),%eax
80103226:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80103228:	a1 9c 38 11 80       	mov    0x8011389c,%eax
8010322d:	83 c0 20             	add    $0x20,%eax
80103230:	8b 00                	mov    (%eax),%eax
}
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    

80103234 <lapicinit>:

void
lapicinit(void)
{
80103234:	55                   	push   %ebp
80103235:	89 e5                	mov    %esp,%ebp
80103237:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
8010323a:	a1 9c 38 11 80       	mov    0x8011389c,%eax
8010323f:	85 c0                	test   %eax,%eax
80103241:	75 05                	jne    80103248 <lapicinit+0x14>
    return;
80103243:	e9 43 01 00 00       	jmp    8010338b <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103248:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
8010324f:	00 
80103250:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80103257:	e8 b7 ff ff ff       	call   80103213 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010325c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80103263:	00 
80103264:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
8010326b:	e8 a3 ff ff ff       	call   80103213 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103270:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80103277:	00 
80103278:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010327f:	e8 8f ff ff ff       	call   80103213 <lapicw>
  lapicw(TICR, 10000000);
80103284:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
8010328b:	00 
8010328c:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80103293:	e8 7b ff ff ff       	call   80103213 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103298:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010329f:	00 
801032a0:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
801032a7:	e8 67 ff ff ff       	call   80103213 <lapicw>
  lapicw(LINT1, MASKED);
801032ac:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801032b3:	00 
801032b4:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
801032bb:	e8 53 ff ff ff       	call   80103213 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801032c0:	a1 9c 38 11 80       	mov    0x8011389c,%eax
801032c5:	83 c0 30             	add    $0x30,%eax
801032c8:	8b 00                	mov    (%eax),%eax
801032ca:	c1 e8 10             	shr    $0x10,%eax
801032cd:	0f b6 c0             	movzbl %al,%eax
801032d0:	83 f8 03             	cmp    $0x3,%eax
801032d3:	76 14                	jbe    801032e9 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
801032d5:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801032dc:	00 
801032dd:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
801032e4:	e8 2a ff ff ff       	call   80103213 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801032e9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
801032f0:	00 
801032f1:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
801032f8:	e8 16 ff ff ff       	call   80103213 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801032fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103304:	00 
80103305:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010330c:	e8 02 ff ff ff       	call   80103213 <lapicw>
  lapicw(ESR, 0);
80103311:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103318:	00 
80103319:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103320:	e8 ee fe ff ff       	call   80103213 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103325:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010332c:	00 
8010332d:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103334:	e8 da fe ff ff       	call   80103213 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103339:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103340:	00 
80103341:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103348:	e8 c6 fe ff ff       	call   80103213 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010334d:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103354:	00 
80103355:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010335c:	e8 b2 fe ff ff       	call   80103213 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80103361:	90                   	nop
80103362:	a1 9c 38 11 80       	mov    0x8011389c,%eax
80103367:	05 00 03 00 00       	add    $0x300,%eax
8010336c:	8b 00                	mov    (%eax),%eax
8010336e:	25 00 10 00 00       	and    $0x1000,%eax
80103373:	85 c0                	test   %eax,%eax
80103375:	75 eb                	jne    80103362 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103377:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010337e:	00 
8010337f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103386:	e8 88 fe ff ff       	call   80103213 <lapicw>
}
8010338b:	c9                   	leave  
8010338c:	c3                   	ret    

8010338d <lapicid>:

int
lapicid(void)
{
8010338d:	55                   	push   %ebp
8010338e:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103390:	a1 9c 38 11 80       	mov    0x8011389c,%eax
80103395:	85 c0                	test   %eax,%eax
80103397:	75 07                	jne    801033a0 <lapicid+0x13>
    return 0;
80103399:	b8 00 00 00 00       	mov    $0x0,%eax
8010339e:	eb 0d                	jmp    801033ad <lapicid+0x20>
  return lapic[ID] >> 24;
801033a0:	a1 9c 38 11 80       	mov    0x8011389c,%eax
801033a5:	83 c0 20             	add    $0x20,%eax
801033a8:	8b 00                	mov    (%eax),%eax
801033aa:	c1 e8 18             	shr    $0x18,%eax
}
801033ad:	5d                   	pop    %ebp
801033ae:	c3                   	ret    

801033af <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801033af:	55                   	push   %ebp
801033b0:	89 e5                	mov    %esp,%ebp
801033b2:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
801033b5:	a1 9c 38 11 80       	mov    0x8011389c,%eax
801033ba:	85 c0                	test   %eax,%eax
801033bc:	74 14                	je     801033d2 <lapiceoi+0x23>
    lapicw(EOI, 0);
801033be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801033c5:	00 
801033c6:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
801033cd:	e8 41 fe ff ff       	call   80103213 <lapicw>
}
801033d2:	c9                   	leave  
801033d3:	c3                   	ret    

801033d4 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
}
801033d7:	5d                   	pop    %ebp
801033d8:	c3                   	ret    

801033d9 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801033d9:	55                   	push   %ebp
801033da:	89 e5                	mov    %esp,%ebp
801033dc:	83 ec 1c             	sub    $0x1c,%esp
801033df:	8b 45 08             	mov    0x8(%ebp),%eax
801033e2:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801033e5:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801033ec:	00 
801033ed:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801033f4:	e8 fe fd ff ff       	call   801031f7 <outb>
  outb(CMOS_PORT+1, 0x0A);
801033f9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103400:	00 
80103401:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103408:	e8 ea fd ff ff       	call   801031f7 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010340d:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103414:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103417:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010341c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010341f:	8d 50 02             	lea    0x2(%eax),%edx
80103422:	8b 45 0c             	mov    0xc(%ebp),%eax
80103425:	c1 e8 04             	shr    $0x4,%eax
80103428:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010342b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010342f:	c1 e0 18             	shl    $0x18,%eax
80103432:	89 44 24 04          	mov    %eax,0x4(%esp)
80103436:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010343d:	e8 d1 fd ff ff       	call   80103213 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103442:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103449:	00 
8010344a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103451:	e8 bd fd ff ff       	call   80103213 <lapicw>
  microdelay(200);
80103456:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010345d:	e8 72 ff ff ff       	call   801033d4 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103462:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103469:	00 
8010346a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103471:	e8 9d fd ff ff       	call   80103213 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103476:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010347d:	e8 52 ff ff ff       	call   801033d4 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103482:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103489:	eb 3f                	jmp    801034ca <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
8010348b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010348f:	c1 e0 18             	shl    $0x18,%eax
80103492:	89 44 24 04          	mov    %eax,0x4(%esp)
80103496:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010349d:	e8 71 fd ff ff       	call   80103213 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801034a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801034a5:	c1 e8 0c             	shr    $0xc,%eax
801034a8:	80 cc 06             	or     $0x6,%ah
801034ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801034af:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801034b6:	e8 58 fd ff ff       	call   80103213 <lapicw>
    microdelay(200);
801034bb:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801034c2:	e8 0d ff ff ff       	call   801033d4 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801034c7:	ff 45 fc             	incl   -0x4(%ebp)
801034ca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801034ce:	7e bb                	jle    8010348b <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801034d0:	c9                   	leave  
801034d1:	c3                   	ret    

801034d2 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801034d2:	55                   	push   %ebp
801034d3:	89 e5                	mov    %esp,%ebp
801034d5:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801034d8:	8b 45 08             	mov    0x8(%ebp),%eax
801034db:	0f b6 c0             	movzbl %al,%eax
801034de:	89 44 24 04          	mov    %eax,0x4(%esp)
801034e2:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801034e9:	e8 09 fd ff ff       	call   801031f7 <outb>
  microdelay(200);
801034ee:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801034f5:	e8 da fe ff ff       	call   801033d4 <microdelay>

  return inb(CMOS_RETURN);
801034fa:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103501:	e8 d6 fc ff ff       	call   801031dc <inb>
80103506:	0f b6 c0             	movzbl %al,%eax
}
80103509:	c9                   	leave  
8010350a:	c3                   	ret    

8010350b <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010350b:	55                   	push   %ebp
8010350c:	89 e5                	mov    %esp,%ebp
8010350e:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103518:	e8 b5 ff ff ff       	call   801034d2 <cmos_read>
8010351d:	8b 55 08             	mov    0x8(%ebp),%edx
80103520:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103522:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103529:	e8 a4 ff ff ff       	call   801034d2 <cmos_read>
8010352e:	8b 55 08             	mov    0x8(%ebp),%edx
80103531:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103534:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010353b:	e8 92 ff ff ff       	call   801034d2 <cmos_read>
80103540:	8b 55 08             	mov    0x8(%ebp),%edx
80103543:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103546:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
8010354d:	e8 80 ff ff ff       	call   801034d2 <cmos_read>
80103552:	8b 55 08             	mov    0x8(%ebp),%edx
80103555:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103558:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010355f:	e8 6e ff ff ff       	call   801034d2 <cmos_read>
80103564:	8b 55 08             	mov    0x8(%ebp),%edx
80103567:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010356a:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103571:	e8 5c ff ff ff       	call   801034d2 <cmos_read>
80103576:	8b 55 08             	mov    0x8(%ebp),%edx
80103579:	89 42 14             	mov    %eax,0x14(%edx)
}
8010357c:	c9                   	leave  
8010357d:	c3                   	ret    

8010357e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010357e:	55                   	push   %ebp
8010357f:	89 e5                	mov    %esp,%ebp
80103581:	57                   	push   %edi
80103582:	56                   	push   %esi
80103583:	53                   	push   %ebx
80103584:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103587:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010358e:	e8 3f ff ff ff       	call   801034d2 <cmos_read>
80103593:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103599:	83 e0 04             	and    $0x4,%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	0f 94 c0             	sete   %al
801035a1:	0f b6 c0             	movzbl %al,%eax
801035a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801035a7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801035aa:	89 04 24             	mov    %eax,(%esp)
801035ad:	e8 59 ff ff ff       	call   8010350b <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801035b2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801035b9:	e8 14 ff ff ff       	call   801034d2 <cmos_read>
801035be:	25 80 00 00 00       	and    $0x80,%eax
801035c3:	85 c0                	test   %eax,%eax
801035c5:	74 02                	je     801035c9 <cmostime+0x4b>
        continue;
801035c7:	eb 36                	jmp    801035ff <cmostime+0x81>
    fill_rtcdate(&t2);
801035c9:	8d 45 b0             	lea    -0x50(%ebp),%eax
801035cc:	89 04 24             	mov    %eax,(%esp)
801035cf:	e8 37 ff ff ff       	call   8010350b <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801035d4:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801035db:	00 
801035dc:	8d 45 b0             	lea    -0x50(%ebp),%eax
801035df:	89 44 24 04          	mov    %eax,0x4(%esp)
801035e3:	8d 45 c8             	lea    -0x38(%ebp),%eax
801035e6:	89 04 24             	mov    %eax,(%esp)
801035e9:	e8 cb 1e 00 00       	call   801054b9 <memcmp>
801035ee:	85 c0                	test   %eax,%eax
801035f0:	75 0d                	jne    801035ff <cmostime+0x81>
      break;
801035f2:	90                   	nop
  }

  // convert
  if(bcd) {
801035f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801035f7:	0f 84 ac 00 00 00    	je     801036a9 <cmostime+0x12b>
801035fd:	eb 02                	jmp    80103601 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801035ff:	eb a6                	jmp    801035a7 <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103601:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103604:	c1 e8 04             	shr    $0x4,%eax
80103607:	89 c2                	mov    %eax,%edx
80103609:	89 d0                	mov    %edx,%eax
8010360b:	c1 e0 02             	shl    $0x2,%eax
8010360e:	01 d0                	add    %edx,%eax
80103610:	01 c0                	add    %eax,%eax
80103612:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103615:	83 e2 0f             	and    $0xf,%edx
80103618:	01 d0                	add    %edx,%eax
8010361a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
8010361d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103620:	c1 e8 04             	shr    $0x4,%eax
80103623:	89 c2                	mov    %eax,%edx
80103625:	89 d0                	mov    %edx,%eax
80103627:	c1 e0 02             	shl    $0x2,%eax
8010362a:	01 d0                	add    %edx,%eax
8010362c:	01 c0                	add    %eax,%eax
8010362e:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103631:	83 e2 0f             	and    $0xf,%edx
80103634:	01 d0                	add    %edx,%eax
80103636:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103639:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010363c:	c1 e8 04             	shr    $0x4,%eax
8010363f:	89 c2                	mov    %eax,%edx
80103641:	89 d0                	mov    %edx,%eax
80103643:	c1 e0 02             	shl    $0x2,%eax
80103646:	01 d0                	add    %edx,%eax
80103648:	01 c0                	add    %eax,%eax
8010364a:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010364d:	83 e2 0f             	and    $0xf,%edx
80103650:	01 d0                	add    %edx,%eax
80103652:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103658:	c1 e8 04             	shr    $0x4,%eax
8010365b:	89 c2                	mov    %eax,%edx
8010365d:	89 d0                	mov    %edx,%eax
8010365f:	c1 e0 02             	shl    $0x2,%eax
80103662:	01 d0                	add    %edx,%eax
80103664:	01 c0                	add    %eax,%eax
80103666:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103669:	83 e2 0f             	and    $0xf,%edx
8010366c:	01 d0                	add    %edx,%eax
8010366e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103671:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103674:	c1 e8 04             	shr    $0x4,%eax
80103677:	89 c2                	mov    %eax,%edx
80103679:	89 d0                	mov    %edx,%eax
8010367b:	c1 e0 02             	shl    $0x2,%eax
8010367e:	01 d0                	add    %edx,%eax
80103680:	01 c0                	add    %eax,%eax
80103682:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103685:	83 e2 0f             	and    $0xf,%edx
80103688:	01 d0                	add    %edx,%eax
8010368a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
8010368d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103690:	c1 e8 04             	shr    $0x4,%eax
80103693:	89 c2                	mov    %eax,%edx
80103695:	89 d0                	mov    %edx,%eax
80103697:	c1 e0 02             	shl    $0x2,%eax
8010369a:	01 d0                	add    %edx,%eax
8010369c:	01 c0                	add    %eax,%eax
8010369e:	8b 55 dc             	mov    -0x24(%ebp),%edx
801036a1:	83 e2 0f             	and    $0xf,%edx
801036a4:	01 d0                	add    %edx,%eax
801036a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
801036a9:	8b 45 08             	mov    0x8(%ebp),%eax
801036ac:	89 c2                	mov    %eax,%edx
801036ae:	8d 5d c8             	lea    -0x38(%ebp),%ebx
801036b1:	b8 06 00 00 00       	mov    $0x6,%eax
801036b6:	89 d7                	mov    %edx,%edi
801036b8:	89 de                	mov    %ebx,%esi
801036ba:	89 c1                	mov    %eax,%ecx
801036bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801036be:	8b 45 08             	mov    0x8(%ebp),%eax
801036c1:	8b 40 14             	mov    0x14(%eax),%eax
801036c4:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801036ca:	8b 45 08             	mov    0x8(%ebp),%eax
801036cd:	89 50 14             	mov    %edx,0x14(%eax)
}
801036d0:	83 c4 5c             	add    $0x5c,%esp
801036d3:	5b                   	pop    %ebx
801036d4:	5e                   	pop    %esi
801036d5:	5f                   	pop    %edi
801036d6:	5d                   	pop    %ebp
801036d7:	c3                   	ret    

801036d8 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801036d8:	55                   	push   %ebp
801036d9:	89 e5                	mov    %esp,%ebp
801036db:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801036de:	c7 44 24 04 25 88 10 	movl   $0x80108825,0x4(%esp)
801036e5:	80 
801036e6:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801036ed:	e8 cc 1a 00 00       	call   801051be <initlock>
  readsb(dev, &sb);
801036f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801036f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801036f9:	8b 45 08             	mov    0x8(%ebp),%eax
801036fc:	89 04 24             	mov    %eax,(%esp)
801036ff:	e8 d8 e0 ff ff       	call   801017dc <readsb>
  log.start = sb.logstart;
80103704:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103707:	a3 d4 38 11 80       	mov    %eax,0x801138d4
  log.size = sb.nlog;
8010370c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010370f:	a3 d8 38 11 80       	mov    %eax,0x801138d8
  log.dev = dev;
80103714:	8b 45 08             	mov    0x8(%ebp),%eax
80103717:	a3 e4 38 11 80       	mov    %eax,0x801138e4
  recover_from_log();
8010371c:	e8 95 01 00 00       	call   801038b6 <recover_from_log>
}
80103721:	c9                   	leave  
80103722:	c3                   	ret    

80103723 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103723:	55                   	push   %ebp
80103724:	89 e5                	mov    %esp,%ebp
80103726:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103730:	e9 89 00 00 00       	jmp    801037be <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103735:	8b 15 d4 38 11 80    	mov    0x801138d4,%edx
8010373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373e:	01 d0                	add    %edx,%eax
80103740:	40                   	inc    %eax
80103741:	89 c2                	mov    %eax,%edx
80103743:	a1 e4 38 11 80       	mov    0x801138e4,%eax
80103748:	89 54 24 04          	mov    %edx,0x4(%esp)
8010374c:	89 04 24             	mov    %eax,(%esp)
8010374f:	e8 61 ca ff ff       	call   801001b5 <bread>
80103754:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375a:	83 c0 10             	add    $0x10,%eax
8010375d:	8b 04 85 ac 38 11 80 	mov    -0x7feec754(,%eax,4),%eax
80103764:	89 c2                	mov    %eax,%edx
80103766:	a1 e4 38 11 80       	mov    0x801138e4,%eax
8010376b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010376f:	89 04 24             	mov    %eax,(%esp)
80103772:	e8 3e ca ff ff       	call   801001b5 <bread>
80103777:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010377d:	8d 50 5c             	lea    0x5c(%eax),%edx
80103780:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103783:	83 c0 5c             	add    $0x5c,%eax
80103786:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010378d:	00 
8010378e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103792:	89 04 24             	mov    %eax,(%esp)
80103795:	e8 71 1d 00 00       	call   8010550b <memmove>
    bwrite(dbuf);  // write dst to disk
8010379a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010379d:	89 04 24             	mov    %eax,(%esp)
801037a0:	e8 47 ca ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801037a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a8:	89 04 24             	mov    %eax,(%esp)
801037ab:	e8 7c ca ff ff       	call   8010022c <brelse>
    brelse(dbuf);
801037b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	e8 71 ca ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037bb:	ff 45 f4             	incl   -0xc(%ebp)
801037be:	a1 e8 38 11 80       	mov    0x801138e8,%eax
801037c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037c6:	0f 8f 69 ff ff ff    	jg     80103735 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801037cc:	c9                   	leave  
801037cd:	c3                   	ret    

801037ce <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801037ce:	55                   	push   %ebp
801037cf:	89 e5                	mov    %esp,%ebp
801037d1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801037d4:	a1 d4 38 11 80       	mov    0x801138d4,%eax
801037d9:	89 c2                	mov    %eax,%edx
801037db:	a1 e4 38 11 80       	mov    0x801138e4,%eax
801037e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801037e4:	89 04 24             	mov    %eax,(%esp)
801037e7:	e8 c9 c9 ff ff       	call   801001b5 <bread>
801037ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801037ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f2:	83 c0 5c             	add    $0x5c,%eax
801037f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801037f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037fb:	8b 00                	mov    (%eax),%eax
801037fd:	a3 e8 38 11 80       	mov    %eax,0x801138e8
  for (i = 0; i < log.lh.n; i++) {
80103802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103809:	eb 1a                	jmp    80103825 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
8010380b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010380e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103811:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103815:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103818:	83 c2 10             	add    $0x10,%edx
8010381b:	89 04 95 ac 38 11 80 	mov    %eax,-0x7feec754(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103822:	ff 45 f4             	incl   -0xc(%ebp)
80103825:	a1 e8 38 11 80       	mov    0x801138e8,%eax
8010382a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010382d:	7f dc                	jg     8010380b <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103832:	89 04 24             	mov    %eax,(%esp)
80103835:	e8 f2 c9 ff ff       	call   8010022c <brelse>
}
8010383a:	c9                   	leave  
8010383b:	c3                   	ret    

8010383c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010383c:	55                   	push   %ebp
8010383d:	89 e5                	mov    %esp,%ebp
8010383f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103842:	a1 d4 38 11 80       	mov    0x801138d4,%eax
80103847:	89 c2                	mov    %eax,%edx
80103849:	a1 e4 38 11 80       	mov    0x801138e4,%eax
8010384e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103852:	89 04 24             	mov    %eax,(%esp)
80103855:	e8 5b c9 ff ff       	call   801001b5 <bread>
8010385a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010385d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103860:	83 c0 5c             	add    $0x5c,%eax
80103863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103866:	8b 15 e8 38 11 80    	mov    0x801138e8,%edx
8010386c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010386f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103878:	eb 1a                	jmp    80103894 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
8010387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387d:	83 c0 10             	add    $0x10,%eax
80103880:	8b 0c 85 ac 38 11 80 	mov    -0x7feec754(,%eax,4),%ecx
80103887:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010388a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010388d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103891:	ff 45 f4             	incl   -0xc(%ebp)
80103894:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103899:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010389c:	7f dc                	jg     8010387a <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010389e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a1:	89 04 24             	mov    %eax,(%esp)
801038a4:	e8 43 c9 ff ff       	call   801001ec <bwrite>
  brelse(buf);
801038a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ac:	89 04 24             	mov    %eax,(%esp)
801038af:	e8 78 c9 ff ff       	call   8010022c <brelse>
}
801038b4:	c9                   	leave  
801038b5:	c3                   	ret    

801038b6 <recover_from_log>:

static void
recover_from_log(void)
{
801038b6:	55                   	push   %ebp
801038b7:	89 e5                	mov    %esp,%ebp
801038b9:	83 ec 08             	sub    $0x8,%esp
  read_head();
801038bc:	e8 0d ff ff ff       	call   801037ce <read_head>
  install_trans(); // if committed, copy from log to disk
801038c1:	e8 5d fe ff ff       	call   80103723 <install_trans>
  log.lh.n = 0;
801038c6:	c7 05 e8 38 11 80 00 	movl   $0x0,0x801138e8
801038cd:	00 00 00 
  write_head(); // clear the log
801038d0:	e8 67 ff ff ff       	call   8010383c <write_head>
}
801038d5:	c9                   	leave  
801038d6:	c3                   	ret    

801038d7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801038d7:	55                   	push   %ebp
801038d8:	89 e5                	mov    %esp,%ebp
801038da:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801038dd:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801038e4:	e8 f6 18 00 00       	call   801051df <acquire>
  while(1){
    if(log.committing){
801038e9:	a1 e0 38 11 80       	mov    0x801138e0,%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	74 16                	je     80103908 <begin_op+0x31>
      sleep(&log, &log.lock);
801038f2:	c7 44 24 04 a0 38 11 	movl   $0x801138a0,0x4(%esp)
801038f9:	80 
801038fa:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103901:	e8 0a 15 00 00       	call   80104e10 <sleep>
80103906:	eb 4d                	jmp    80103955 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103908:	8b 15 e8 38 11 80    	mov    0x801138e8,%edx
8010390e:	a1 dc 38 11 80       	mov    0x801138dc,%eax
80103913:	8d 48 01             	lea    0x1(%eax),%ecx
80103916:	89 c8                	mov    %ecx,%eax
80103918:	c1 e0 02             	shl    $0x2,%eax
8010391b:	01 c8                	add    %ecx,%eax
8010391d:	01 c0                	add    %eax,%eax
8010391f:	01 d0                	add    %edx,%eax
80103921:	83 f8 1e             	cmp    $0x1e,%eax
80103924:	7e 16                	jle    8010393c <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103926:	c7 44 24 04 a0 38 11 	movl   $0x801138a0,0x4(%esp)
8010392d:	80 
8010392e:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103935:	e8 d6 14 00 00       	call   80104e10 <sleep>
8010393a:	eb 19                	jmp    80103955 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
8010393c:	a1 dc 38 11 80       	mov    0x801138dc,%eax
80103941:	40                   	inc    %eax
80103942:	a3 dc 38 11 80       	mov    %eax,0x801138dc
      release(&log.lock);
80103947:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010394e:	e8 f6 18 00 00       	call   80105249 <release>
      break;
80103953:	eb 02                	jmp    80103957 <begin_op+0x80>
    }
  }
80103955:	eb 92                	jmp    801038e9 <begin_op+0x12>
}
80103957:	c9                   	leave  
80103958:	c3                   	ret    

80103959 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103959:	55                   	push   %ebp
8010395a:	89 e5                	mov    %esp,%ebp
8010395c:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010395f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103966:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010396d:	e8 6d 18 00 00       	call   801051df <acquire>
  log.outstanding -= 1;
80103972:	a1 dc 38 11 80       	mov    0x801138dc,%eax
80103977:	48                   	dec    %eax
80103978:	a3 dc 38 11 80       	mov    %eax,0x801138dc
  if(log.committing)
8010397d:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80103982:	85 c0                	test   %eax,%eax
80103984:	74 0c                	je     80103992 <end_op+0x39>
    panic("log.committing");
80103986:	c7 04 24 29 88 10 80 	movl   $0x80108829,(%esp)
8010398d:	e8 c2 cb ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
80103992:	a1 dc 38 11 80       	mov    0x801138dc,%eax
80103997:	85 c0                	test   %eax,%eax
80103999:	75 13                	jne    801039ae <end_op+0x55>
    do_commit = 1;
8010399b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801039a2:	c7 05 e0 38 11 80 01 	movl   $0x1,0x801138e0
801039a9:	00 00 00 
801039ac:	eb 0c                	jmp    801039ba <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801039ae:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801039b5:	e8 2a 15 00 00       	call   80104ee4 <wakeup>
  }
  release(&log.lock);
801039ba:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801039c1:	e8 83 18 00 00       	call   80105249 <release>

  if(do_commit){
801039c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801039ca:	74 33                	je     801039ff <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801039cc:	e8 db 00 00 00       	call   80103aac <commit>
    acquire(&log.lock);
801039d1:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801039d8:	e8 02 18 00 00       	call   801051df <acquire>
    log.committing = 0;
801039dd:	c7 05 e0 38 11 80 00 	movl   $0x0,0x801138e0
801039e4:	00 00 00 
    wakeup(&log);
801039e7:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801039ee:	e8 f1 14 00 00       	call   80104ee4 <wakeup>
    release(&log.lock);
801039f3:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801039fa:	e8 4a 18 00 00       	call   80105249 <release>
  }
}
801039ff:	c9                   	leave  
80103a00:	c3                   	ret    

80103a01 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103a01:	55                   	push   %ebp
80103a02:	89 e5                	mov    %esp,%ebp
80103a04:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a0e:	e9 89 00 00 00       	jmp    80103a9c <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103a13:	8b 15 d4 38 11 80    	mov    0x801138d4,%edx
80103a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1c:	01 d0                	add    %edx,%eax
80103a1e:	40                   	inc    %eax
80103a1f:	89 c2                	mov    %eax,%edx
80103a21:	a1 e4 38 11 80       	mov    0x801138e4,%eax
80103a26:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a2a:	89 04 24             	mov    %eax,(%esp)
80103a2d:	e8 83 c7 ff ff       	call   801001b5 <bread>
80103a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a38:	83 c0 10             	add    $0x10,%eax
80103a3b:	8b 04 85 ac 38 11 80 	mov    -0x7feec754(,%eax,4),%eax
80103a42:	89 c2                	mov    %eax,%edx
80103a44:	a1 e4 38 11 80       	mov    0x801138e4,%eax
80103a49:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a4d:	89 04 24             	mov    %eax,(%esp)
80103a50:	e8 60 c7 ff ff       	call   801001b5 <bread>
80103a55:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a5b:	8d 50 5c             	lea    0x5c(%eax),%edx
80103a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a61:	83 c0 5c             	add    $0x5c,%eax
80103a64:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103a6b:	00 
80103a6c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a70:	89 04 24             	mov    %eax,(%esp)
80103a73:	e8 93 1a 00 00       	call   8010550b <memmove>
    bwrite(to);  // write the log
80103a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a7b:	89 04 24             	mov    %eax,(%esp)
80103a7e:	e8 69 c7 ff ff       	call   801001ec <bwrite>
    brelse(from);
80103a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a86:	89 04 24             	mov    %eax,(%esp)
80103a89:	e8 9e c7 ff ff       	call   8010022c <brelse>
    brelse(to);
80103a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a91:	89 04 24             	mov    %eax,(%esp)
80103a94:	e8 93 c7 ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a99:	ff 45 f4             	incl   -0xc(%ebp)
80103a9c:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103aa1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103aa4:	0f 8f 69 ff ff ff    	jg     80103a13 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103aaa:	c9                   	leave  
80103aab:	c3                   	ret    

80103aac <commit>:

static void
commit()
{
80103aac:	55                   	push   %ebp
80103aad:	89 e5                	mov    %esp,%ebp
80103aaf:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103ab2:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	7e 1e                	jle    80103ad9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103abb:	e8 41 ff ff ff       	call   80103a01 <write_log>
    write_head();    // Write header to disk -- the real commit
80103ac0:	e8 77 fd ff ff       	call   8010383c <write_head>
    install_trans(); // Now install writes to home locations
80103ac5:	e8 59 fc ff ff       	call   80103723 <install_trans>
    log.lh.n = 0;
80103aca:	c7 05 e8 38 11 80 00 	movl   $0x0,0x801138e8
80103ad1:	00 00 00 
    write_head();    // Erase the transaction from the log
80103ad4:	e8 63 fd ff ff       	call   8010383c <write_head>
  }
}
80103ad9:	c9                   	leave  
80103ada:	c3                   	ret    

80103adb <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103adb:	55                   	push   %ebp
80103adc:	89 e5                	mov    %esp,%ebp
80103ade:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103ae1:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103ae6:	83 f8 1d             	cmp    $0x1d,%eax
80103ae9:	7f 10                	jg     80103afb <log_write+0x20>
80103aeb:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103af0:	8b 15 d8 38 11 80    	mov    0x801138d8,%edx
80103af6:	4a                   	dec    %edx
80103af7:	39 d0                	cmp    %edx,%eax
80103af9:	7c 0c                	jl     80103b07 <log_write+0x2c>
    panic("too big a transaction");
80103afb:	c7 04 24 38 88 10 80 	movl   $0x80108838,(%esp)
80103b02:	e8 4d ca ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
80103b07:	a1 dc 38 11 80       	mov    0x801138dc,%eax
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	7f 0c                	jg     80103b1c <log_write+0x41>
    panic("log_write outside of trans");
80103b10:	c7 04 24 4e 88 10 80 	movl   $0x8010884e,(%esp)
80103b17:	e8 38 ca ff ff       	call   80100554 <panic>

  acquire(&log.lock);
80103b1c:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103b23:	e8 b7 16 00 00       	call   801051df <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b2f:	eb 1e                	jmp    80103b4f <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b34:	83 c0 10             	add    $0x10,%eax
80103b37:	8b 04 85 ac 38 11 80 	mov    -0x7feec754(,%eax,4),%eax
80103b3e:	89 c2                	mov    %eax,%edx
80103b40:	8b 45 08             	mov    0x8(%ebp),%eax
80103b43:	8b 40 08             	mov    0x8(%eax),%eax
80103b46:	39 c2                	cmp    %eax,%edx
80103b48:	75 02                	jne    80103b4c <log_write+0x71>
      break;
80103b4a:	eb 0d                	jmp    80103b59 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b4c:	ff 45 f4             	incl   -0xc(%ebp)
80103b4f:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103b54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b57:	7f d8                	jg     80103b31 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103b59:	8b 45 08             	mov    0x8(%ebp),%eax
80103b5c:	8b 40 08             	mov    0x8(%eax),%eax
80103b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b62:	83 c2 10             	add    $0x10,%edx
80103b65:	89 04 95 ac 38 11 80 	mov    %eax,-0x7feec754(,%edx,4)
  if (i == log.lh.n)
80103b6c:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103b71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b74:	75 0b                	jne    80103b81 <log_write+0xa6>
    log.lh.n++;
80103b76:	a1 e8 38 11 80       	mov    0x801138e8,%eax
80103b7b:	40                   	inc    %eax
80103b7c:	a3 e8 38 11 80       	mov    %eax,0x801138e8
  b->flags |= B_DIRTY; // prevent eviction
80103b81:	8b 45 08             	mov    0x8(%ebp),%eax
80103b84:	8b 00                	mov    (%eax),%eax
80103b86:	83 c8 04             	or     $0x4,%eax
80103b89:	89 c2                	mov    %eax,%edx
80103b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b8e:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b90:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103b97:	e8 ad 16 00 00       	call   80105249 <release>
}
80103b9c:	c9                   	leave  
80103b9d:	c3                   	ret    
	...

80103ba0 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103ba6:	8b 55 08             	mov    0x8(%ebp),%edx
80103ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103baf:	f0 87 02             	lock xchg %eax,(%edx)
80103bb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103bb8:	c9                   	leave  
80103bb9:	c3                   	ret    

80103bba <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103bba:	55                   	push   %ebp
80103bbb:	89 e5                	mov    %esp,%ebp
80103bbd:	83 e4 f0             	and    $0xfffffff0,%esp
80103bc0:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103bc3:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103bca:	80 
80103bcb:	c7 04 24 c8 66 11 80 	movl   $0x801166c8,(%esp)
80103bd2:	e8 0d f3 ff ff       	call   80102ee4 <kinit1>
  kvmalloc();      // kernel page table
80103bd7:	e8 c7 41 00 00       	call   80107da3 <kvmalloc>
  mpinit();        // detect other processors
80103bdc:	e8 c4 03 00 00       	call   80103fa5 <mpinit>
  lapicinit();     // interrupt controller
80103be1:	e8 4e f6 ff ff       	call   80103234 <lapicinit>
  seginit();       // segment descriptors
80103be6:	e8 a0 3c 00 00       	call   8010788b <seginit>
  picinit();       // disable pic
80103beb:	e8 04 05 00 00       	call   801040f4 <picinit>
  ioapicinit();    // another interrupt controller
80103bf0:	e8 0c f2 ff ff       	call   80102e01 <ioapicinit>
  consoleinit();   // console hardware
80103bf5:	e8 78 d3 ff ff       	call   80100f72 <consoleinit>
  uartinit();      // serial port
80103bfa:	e8 18 30 00 00       	call   80106c17 <uartinit>
  pinit();         // process table
80103bff:	e8 e6 08 00 00       	call   801044ea <pinit>
  tvinit();        // trap vectors
80103c04:	e8 f7 2b 00 00       	call   80106800 <tvinit>
  binit();         // buffer cache
80103c09:	e8 26 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c0e:	e8 ed d7 ff ff       	call   80101400 <fileinit>
  ideinit();       // disk 
80103c13:	e8 f5 ed ff ff       	call   80102a0d <ideinit>
  startothers();   // start other processors
80103c18:	e8 83 00 00 00       	call   80103ca0 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c1d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103c24:	8e 
80103c25:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103c2c:	e8 eb f2 ff ff       	call   80102f1c <kinit2>
  userinit();      // first user process
80103c31:	e8 c1 0a 00 00       	call   801046f7 <userinit>
  mpmain();        // finish this processor's setup
80103c36:	e8 1a 00 00 00       	call   80103c55 <mpmain>

80103c3b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c3b:	55                   	push   %ebp
80103c3c:	89 e5                	mov    %esp,%ebp
80103c3e:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103c41:	e8 74 41 00 00       	call   80107dba <switchkvm>
  seginit();
80103c46:	e8 40 3c 00 00       	call   8010788b <seginit>
  lapicinit();
80103c4b:	e8 e4 f5 ff ff       	call   80103234 <lapicinit>
  mpmain();
80103c50:	e8 00 00 00 00       	call   80103c55 <mpmain>

80103c55 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c55:	55                   	push   %ebp
80103c56:	89 e5                	mov    %esp,%ebp
80103c58:	53                   	push   %ebx
80103c59:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103c5c:	e8 a5 08 00 00       	call   80104506 <cpuid>
80103c61:	89 c3                	mov    %eax,%ebx
80103c63:	e8 9e 08 00 00       	call   80104506 <cpuid>
80103c68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c70:	c7 04 24 69 88 10 80 	movl   $0x80108869,(%esp)
80103c77:	e8 45 c7 ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
80103c7c:	e8 dc 2c 00 00       	call   8010695d <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103c81:	e8 c5 08 00 00       	call   8010454b <mycpu>
80103c86:	05 a0 00 00 00       	add    $0xa0,%eax
80103c8b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103c92:	00 
80103c93:	89 04 24             	mov    %eax,(%esp)
80103c96:	e8 05 ff ff ff       	call   80103ba0 <xchg>
  scheduler();     // start running processes
80103c9b:	e8 a6 0f 00 00       	call   80104c46 <scheduler>

80103ca0 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103ca6:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103cad:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
80103cb6:	c7 44 24 04 ec b4 10 	movl   $0x8010b4ec,0x4(%esp)
80103cbd:	80 
80103cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc1:	89 04 24             	mov    %eax,(%esp)
80103cc4:	e8 42 18 00 00       	call   8010550b <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103cc9:	c7 45 f4 a0 39 11 80 	movl   $0x801139a0,-0xc(%ebp)
80103cd0:	eb 75                	jmp    80103d47 <startothers+0xa7>
    if(c == mycpu())  // We've started already.
80103cd2:	e8 74 08 00 00       	call   8010454b <mycpu>
80103cd7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103cda:	75 02                	jne    80103cde <startothers+0x3e>
      continue;
80103cdc:	eb 62                	jmp    80103d40 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103cde:	e8 2c f3 ff ff       	call   8010300f <kalloc>
80103ce3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce9:	83 e8 04             	sub    $0x4,%eax
80103cec:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103cef:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103cf5:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfa:	83 e8 08             	sub    $0x8,%eax
80103cfd:	c7 00 3b 3c 10 80    	movl   $0x80103c3b,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d06:	8d 50 f4             	lea    -0xc(%eax),%edx
80103d09:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80103d0e:	05 00 00 00 80       	add    $0x80000000,%eax
80103d13:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d18:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d21:	8a 00                	mov    (%eax),%al
80103d23:	0f b6 c0             	movzbl %al,%eax
80103d26:	89 54 24 04          	mov    %edx,0x4(%esp)
80103d2a:	89 04 24             	mov    %eax,(%esp)
80103d2d:	e8 a7 f6 ff ff       	call   801033d9 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d32:	90                   	nop
80103d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d36:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103d3c:	85 c0                	test   %eax,%eax
80103d3e:	74 f3                	je     80103d33 <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d40:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103d47:	a1 20 3f 11 80       	mov    0x80113f20,%eax
80103d4c:	89 c2                	mov    %eax,%edx
80103d4e:	89 d0                	mov    %edx,%eax
80103d50:	c1 e0 02             	shl    $0x2,%eax
80103d53:	01 d0                	add    %edx,%eax
80103d55:	01 c0                	add    %eax,%eax
80103d57:	01 d0                	add    %edx,%eax
80103d59:	c1 e0 04             	shl    $0x4,%eax
80103d5c:	05 a0 39 11 80       	add    $0x801139a0,%eax
80103d61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d64:	0f 87 68 ff ff ff    	ja     80103cd2 <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103d6a:	c9                   	leave  
80103d6b:	c3                   	ret    

80103d6c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103d6c:	55                   	push   %ebp
80103d6d:	89 e5                	mov    %esp,%ebp
80103d6f:	83 ec 14             	sub    $0x14,%esp
80103d72:	8b 45 08             	mov    0x8(%ebp),%eax
80103d75:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d7c:	89 c2                	mov    %eax,%edx
80103d7e:	ec                   	in     (%dx),%al
80103d7f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103d82:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103d85:	c9                   	leave  
80103d86:	c3                   	ret    

80103d87 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d87:	55                   	push   %ebp
80103d88:	89 e5                	mov    %esp,%ebp
80103d8a:	83 ec 08             	sub    $0x8,%esp
80103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d90:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d93:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d97:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d9a:	8a 45 f8             	mov    -0x8(%ebp),%al
80103d9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103da0:	ee                   	out    %al,(%dx)
}
80103da1:	c9                   	leave  
80103da2:	c3                   	ret    

80103da3 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103da3:	55                   	push   %ebp
80103da4:	89 e5                	mov    %esp,%ebp
80103da6:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103da9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103db0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103db7:	eb 13                	jmp    80103dcc <sum+0x29>
    sum += addr[i];
80103db9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbf:	01 d0                	add    %edx,%eax
80103dc1:	8a 00                	mov    (%eax),%al
80103dc3:	0f b6 c0             	movzbl %al,%eax
80103dc6:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103dc9:	ff 45 fc             	incl   -0x4(%ebp)
80103dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103dcf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103dd2:	7c e5                	jl     80103db9 <sum+0x16>
    sum += addr[i];
  return sum;
80103dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103dd7:	c9                   	leave  
80103dd8:	c3                   	ret    

80103dd9 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103dd9:	55                   	push   %ebp
80103dda:	89 e5                	mov    %esp,%ebp
80103ddc:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80103de2:	05 00 00 00 80       	add    $0x80000000,%eax
80103de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103dea:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df0:	01 d0                	add    %edx,%eax
80103df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dfb:	eb 3f                	jmp    80103e3c <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103dfd:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103e04:	00 
80103e05:	c7 44 24 04 80 88 10 	movl   $0x80108880,0x4(%esp)
80103e0c:	80 
80103e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e10:	89 04 24             	mov    %eax,(%esp)
80103e13:	e8 a1 16 00 00       	call   801054b9 <memcmp>
80103e18:	85 c0                	test   %eax,%eax
80103e1a:	75 1c                	jne    80103e38 <mpsearch1+0x5f>
80103e1c:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103e23:	00 
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	89 04 24             	mov    %eax,(%esp)
80103e2a:	e8 74 ff ff ff       	call   80103da3 <sum>
80103e2f:	84 c0                	test   %al,%al
80103e31:	75 05                	jne    80103e38 <mpsearch1+0x5f>
      return (struct mp*)p;
80103e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e36:	eb 11                	jmp    80103e49 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103e38:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e42:	72 b9                	jb     80103dfd <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e49:	c9                   	leave  
80103e4a:	c3                   	ret    

80103e4b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103e4b:	55                   	push   %ebp
80103e4c:	89 e5                	mov    %esp,%ebp
80103e4e:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103e51:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5b:	83 c0 0f             	add    $0xf,%eax
80103e5e:	8a 00                	mov    (%eax),%al
80103e60:	0f b6 c0             	movzbl %al,%eax
80103e63:	c1 e0 08             	shl    $0x8,%eax
80103e66:	89 c2                	mov    %eax,%edx
80103e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e6b:	83 c0 0e             	add    $0xe,%eax
80103e6e:	8a 00                	mov    (%eax),%al
80103e70:	0f b6 c0             	movzbl %al,%eax
80103e73:	09 d0                	or     %edx,%eax
80103e75:	c1 e0 04             	shl    $0x4,%eax
80103e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e7f:	74 21                	je     80103ea2 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103e81:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103e88:	00 
80103e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e8c:	89 04 24             	mov    %eax,(%esp)
80103e8f:	e8 45 ff ff ff       	call   80103dd9 <mpsearch1>
80103e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e9b:	74 4e                	je     80103eeb <mpsearch+0xa0>
      return mp;
80103e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ea0:	eb 5d                	jmp    80103eff <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea5:	83 c0 14             	add    $0x14,%eax
80103ea8:	8a 00                	mov    (%eax),%al
80103eaa:	0f b6 c0             	movzbl %al,%eax
80103ead:	c1 e0 08             	shl    $0x8,%eax
80103eb0:	89 c2                	mov    %eax,%edx
80103eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb5:	83 c0 13             	add    $0x13,%eax
80103eb8:	8a 00                	mov    (%eax),%al
80103eba:	0f b6 c0             	movzbl %al,%eax
80103ebd:	09 d0                	or     %edx,%eax
80103ebf:	c1 e0 0a             	shl    $0xa,%eax
80103ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ec8:	2d 00 04 00 00       	sub    $0x400,%eax
80103ecd:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ed4:	00 
80103ed5:	89 04 24             	mov    %eax,(%esp)
80103ed8:	e8 fc fe ff ff       	call   80103dd9 <mpsearch1>
80103edd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ee0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ee4:	74 05                	je     80103eeb <mpsearch+0xa0>
      return mp;
80103ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ee9:	eb 14                	jmp    80103eff <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103eeb:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ef2:	00 
80103ef3:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103efa:	e8 da fe ff ff       	call   80103dd9 <mpsearch1>
}
80103eff:	c9                   	leave  
80103f00:	c3                   	ret    

80103f01 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f01:	55                   	push   %ebp
80103f02:	89 e5                	mov    %esp,%ebp
80103f04:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f07:	e8 3f ff ff ff       	call   80103e4b <mpsearch>
80103f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f13:	74 0a                	je     80103f1f <mpconfig+0x1e>
80103f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f18:	8b 40 04             	mov    0x4(%eax),%eax
80103f1b:	85 c0                	test   %eax,%eax
80103f1d:	75 07                	jne    80103f26 <mpconfig+0x25>
    return 0;
80103f1f:	b8 00 00 00 00       	mov    $0x0,%eax
80103f24:	eb 7d                	jmp    80103fa3 <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f29:	8b 40 04             	mov    0x4(%eax),%eax
80103f2c:	05 00 00 00 80       	add    $0x80000000,%eax
80103f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103f34:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103f3b:	00 
80103f3c:	c7 44 24 04 85 88 10 	movl   $0x80108885,0x4(%esp)
80103f43:	80 
80103f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f47:	89 04 24             	mov    %eax,(%esp)
80103f4a:	e8 6a 15 00 00       	call   801054b9 <memcmp>
80103f4f:	85 c0                	test   %eax,%eax
80103f51:	74 07                	je     80103f5a <mpconfig+0x59>
    return 0;
80103f53:	b8 00 00 00 00       	mov    $0x0,%eax
80103f58:	eb 49                	jmp    80103fa3 <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f5d:	8a 40 06             	mov    0x6(%eax),%al
80103f60:	3c 01                	cmp    $0x1,%al
80103f62:	74 11                	je     80103f75 <mpconfig+0x74>
80103f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f67:	8a 40 06             	mov    0x6(%eax),%al
80103f6a:	3c 04                	cmp    $0x4,%al
80103f6c:	74 07                	je     80103f75 <mpconfig+0x74>
    return 0;
80103f6e:	b8 00 00 00 00       	mov    $0x0,%eax
80103f73:	eb 2e                	jmp    80103fa3 <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f78:	8b 40 04             	mov    0x4(%eax),%eax
80103f7b:	0f b7 c0             	movzwl %ax,%eax
80103f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f85:	89 04 24             	mov    %eax,(%esp)
80103f88:	e8 16 fe ff ff       	call   80103da3 <sum>
80103f8d:	84 c0                	test   %al,%al
80103f8f:	74 07                	je     80103f98 <mpconfig+0x97>
    return 0;
80103f91:	b8 00 00 00 00       	mov    $0x0,%eax
80103f96:	eb 0b                	jmp    80103fa3 <mpconfig+0xa2>
  *pmp = mp;
80103f98:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f9e:	89 10                	mov    %edx,(%eax)
  return conf;
80103fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103fa3:	c9                   	leave  
80103fa4:	c3                   	ret    

80103fa5 <mpinit>:

void
mpinit(void)
{
80103fa5:	55                   	push   %ebp
80103fa6:	89 e5                	mov    %esp,%ebp
80103fa8:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103fab:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103fae:	89 04 24             	mov    %eax,(%esp)
80103fb1:	e8 4b ff ff ff       	call   80103f01 <mpconfig>
80103fb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103fbd:	75 0c                	jne    80103fcb <mpinit+0x26>
    panic("Expect to run on an SMP");
80103fbf:	c7 04 24 8a 88 10 80 	movl   $0x8010888a,(%esp)
80103fc6:	e8 89 c5 ff ff       	call   80100554 <panic>
  ismp = 1;
80103fcb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fd5:	8b 40 24             	mov    0x24(%eax),%eax
80103fd8:	a3 9c 38 11 80       	mov    %eax,0x8011389c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fe0:	83 c0 2c             	add    $0x2c,%eax
80103fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fe9:	8b 40 04             	mov    0x4(%eax),%eax
80103fec:	0f b7 d0             	movzwl %ax,%edx
80103fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ff2:	01 d0                	add    %edx,%eax
80103ff4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ff7:	eb 7d                	jmp    80104076 <mpinit+0xd1>
    switch(*p){
80103ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffc:	8a 00                	mov    (%eax),%al
80103ffe:	0f b6 c0             	movzbl %al,%eax
80104001:	83 f8 04             	cmp    $0x4,%eax
80104004:	77 68                	ja     8010406e <mpinit+0xc9>
80104006:	8b 04 85 c4 88 10 80 	mov    -0x7fef773c(,%eax,4),%eax
8010400d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
8010400f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80104015:	a1 20 3f 11 80       	mov    0x80113f20,%eax
8010401a:	83 f8 07             	cmp    $0x7,%eax
8010401d:	7f 2c                	jg     8010404b <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010401f:	8b 15 20 3f 11 80    	mov    0x80113f20,%edx
80104025:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104028:	8a 48 01             	mov    0x1(%eax),%cl
8010402b:	89 d0                	mov    %edx,%eax
8010402d:	c1 e0 02             	shl    $0x2,%eax
80104030:	01 d0                	add    %edx,%eax
80104032:	01 c0                	add    %eax,%eax
80104034:	01 d0                	add    %edx,%eax
80104036:	c1 e0 04             	shl    $0x4,%eax
80104039:	05 a0 39 11 80       	add    $0x801139a0,%eax
8010403e:	88 08                	mov    %cl,(%eax)
        ncpu++;
80104040:	a1 20 3f 11 80       	mov    0x80113f20,%eax
80104045:	40                   	inc    %eax
80104046:	a3 20 3f 11 80       	mov    %eax,0x80113f20
      }
      p += sizeof(struct mpproc);
8010404b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010404f:	eb 25                	jmp    80104076 <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80104051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104054:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80104057:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010405a:	8a 40 01             	mov    0x1(%eax),%al
8010405d:	a2 80 39 11 80       	mov    %al,0x80113980
      p += sizeof(struct mpioapic);
80104062:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104066:	eb 0e                	jmp    80104076 <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104068:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010406c:	eb 08                	jmp    80104076 <mpinit+0xd1>
    default:
      ismp = 0;
8010406e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80104075:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104079:	3b 45 e8             	cmp    -0x18(%ebp),%eax
8010407c:	0f 82 77 ff ff ff    	jb     80103ff9 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104082:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104086:	75 0c                	jne    80104094 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80104088:	c7 04 24 a4 88 10 80 	movl   $0x801088a4,(%esp)
8010408f:	e8 c0 c4 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80104094:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104097:	8a 40 0c             	mov    0xc(%eax),%al
8010409a:	84 c0                	test   %al,%al
8010409c:	74 36                	je     801040d4 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010409e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801040a5:	00 
801040a6:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801040ad:	e8 d5 fc ff ff       	call   80103d87 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801040b2:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801040b9:	e8 ae fc ff ff       	call   80103d6c <inb>
801040be:	83 c8 01             	or     $0x1,%eax
801040c1:	0f b6 c0             	movzbl %al,%eax
801040c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801040c8:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801040cf:	e8 b3 fc ff ff       	call   80103d87 <outb>
  }
}
801040d4:	c9                   	leave  
801040d5:	c3                   	ret    
	...

801040d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801040d8:	55                   	push   %ebp
801040d9:	89 e5                	mov    %esp,%ebp
801040db:	83 ec 08             	sub    $0x8,%esp
801040de:	8b 45 08             	mov    0x8(%ebp),%eax
801040e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801040e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801040e8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801040eb:	8a 45 f8             	mov    -0x8(%ebp),%al
801040ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801040f1:	ee                   	out    %al,(%dx)
}
801040f2:	c9                   	leave  
801040f3:	c3                   	ret    

801040f4 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801040fa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104101:	00 
80104102:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104109:	e8 ca ff ff ff       	call   801040d8 <outb>
  outb(IO_PIC2+1, 0xFF);
8010410e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104115:	00 
80104116:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010411d:	e8 b6 ff ff ff       	call   801040d8 <outb>
}
80104122:	c9                   	leave  
80104123:	c3                   	ret    

80104124 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
8010412a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104131:	8b 45 0c             	mov    0xc(%ebp),%eax
80104134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010413a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413d:	8b 10                	mov    (%eax),%edx
8010413f:	8b 45 08             	mov    0x8(%ebp),%eax
80104142:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104144:	e8 d3 d2 ff ff       	call   8010141c <filealloc>
80104149:	8b 55 08             	mov    0x8(%ebp),%edx
8010414c:	89 02                	mov    %eax,(%edx)
8010414e:	8b 45 08             	mov    0x8(%ebp),%eax
80104151:	8b 00                	mov    (%eax),%eax
80104153:	85 c0                	test   %eax,%eax
80104155:	0f 84 c8 00 00 00    	je     80104223 <pipealloc+0xff>
8010415b:	e8 bc d2 ff ff       	call   8010141c <filealloc>
80104160:	8b 55 0c             	mov    0xc(%ebp),%edx
80104163:	89 02                	mov    %eax,(%edx)
80104165:	8b 45 0c             	mov    0xc(%ebp),%eax
80104168:	8b 00                	mov    (%eax),%eax
8010416a:	85 c0                	test   %eax,%eax
8010416c:	0f 84 b1 00 00 00    	je     80104223 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104172:	e8 98 ee ff ff       	call   8010300f <kalloc>
80104177:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010417a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010417e:	75 05                	jne    80104185 <pipealloc+0x61>
    goto bad;
80104180:	e9 9e 00 00 00       	jmp    80104223 <pipealloc+0xff>
  p->readopen = 1;
80104185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104188:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010418f:	00 00 00 
  p->writeopen = 1;
80104192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104195:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010419c:	00 00 00 
  p->nwrite = 0;
8010419f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a2:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801041a9:	00 00 00 
  p->nread = 0;
801041ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041af:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801041b6:	00 00 00 
  initlock(&p->lock, "pipe");
801041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bc:	c7 44 24 04 d8 88 10 	movl   $0x801088d8,0x4(%esp)
801041c3:	80 
801041c4:	89 04 24             	mov    %eax,(%esp)
801041c7:	e8 f2 0f 00 00       	call   801051be <initlock>
  (*f0)->type = FD_PIPE;
801041cc:	8b 45 08             	mov    0x8(%ebp),%eax
801041cf:	8b 00                	mov    (%eax),%eax
801041d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041d7:	8b 45 08             	mov    0x8(%ebp),%eax
801041da:	8b 00                	mov    (%eax),%eax
801041dc:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041e0:	8b 45 08             	mov    0x8(%ebp),%eax
801041e3:	8b 00                	mov    (%eax),%eax
801041e5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041e9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ec:	8b 00                	mov    (%eax),%eax
801041ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041f1:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801041f7:	8b 00                	mov    (%eax),%eax
801041f9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104202:	8b 00                	mov    (%eax),%eax
80104204:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420b:	8b 00                	mov    (%eax),%eax
8010420d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	8b 00                	mov    (%eax),%eax
80104216:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104219:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010421c:	b8 00 00 00 00       	mov    $0x0,%eax
80104221:	eb 42                	jmp    80104265 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104227:	74 0b                	je     80104234 <pipealloc+0x110>
    kfree((char*)p);
80104229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422c:	89 04 24             	mov    %eax,(%esp)
8010422f:	e8 45 ed ff ff       	call   80102f79 <kfree>
  if(*f0)
80104234:	8b 45 08             	mov    0x8(%ebp),%eax
80104237:	8b 00                	mov    (%eax),%eax
80104239:	85 c0                	test   %eax,%eax
8010423b:	74 0d                	je     8010424a <pipealloc+0x126>
    fileclose(*f0);
8010423d:	8b 45 08             	mov    0x8(%ebp),%eax
80104240:	8b 00                	mov    (%eax),%eax
80104242:	89 04 24             	mov    %eax,(%esp)
80104245:	e8 7a d2 ff ff       	call   801014c4 <fileclose>
  if(*f1)
8010424a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424d:	8b 00                	mov    (%eax),%eax
8010424f:	85 c0                	test   %eax,%eax
80104251:	74 0d                	je     80104260 <pipealloc+0x13c>
    fileclose(*f1);
80104253:	8b 45 0c             	mov    0xc(%ebp),%eax
80104256:	8b 00                	mov    (%eax),%eax
80104258:	89 04 24             	mov    %eax,(%esp)
8010425b:	e8 64 d2 ff ff       	call   801014c4 <fileclose>
  return -1;
80104260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104265:	c9                   	leave  
80104266:	c3                   	ret    

80104267 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104267:	55                   	push   %ebp
80104268:	89 e5                	mov    %esp,%ebp
8010426a:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010426d:	8b 45 08             	mov    0x8(%ebp),%eax
80104270:	89 04 24             	mov    %eax,(%esp)
80104273:	e8 67 0f 00 00       	call   801051df <acquire>
  if(writable){
80104278:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010427c:	74 1f                	je     8010429d <pipeclose+0x36>
    p->writeopen = 0;
8010427e:	8b 45 08             	mov    0x8(%ebp),%eax
80104281:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104288:	00 00 00 
    wakeup(&p->nread);
8010428b:	8b 45 08             	mov    0x8(%ebp),%eax
8010428e:	05 34 02 00 00       	add    $0x234,%eax
80104293:	89 04 24             	mov    %eax,(%esp)
80104296:	e8 49 0c 00 00       	call   80104ee4 <wakeup>
8010429b:	eb 1d                	jmp    801042ba <pipeclose+0x53>
  } else {
    p->readopen = 0;
8010429d:	8b 45 08             	mov    0x8(%ebp),%eax
801042a0:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801042a7:	00 00 00 
    wakeup(&p->nwrite);
801042aa:	8b 45 08             	mov    0x8(%ebp),%eax
801042ad:	05 38 02 00 00       	add    $0x238,%eax
801042b2:	89 04 24             	mov    %eax,(%esp)
801042b5:	e8 2a 0c 00 00       	call   80104ee4 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801042ba:	8b 45 08             	mov    0x8(%ebp),%eax
801042bd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042c3:	85 c0                	test   %eax,%eax
801042c5:	75 25                	jne    801042ec <pipeclose+0x85>
801042c7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ca:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042d0:	85 c0                	test   %eax,%eax
801042d2:	75 18                	jne    801042ec <pipeclose+0x85>
    release(&p->lock);
801042d4:	8b 45 08             	mov    0x8(%ebp),%eax
801042d7:	89 04 24             	mov    %eax,(%esp)
801042da:	e8 6a 0f 00 00       	call   80105249 <release>
    kfree((char*)p);
801042df:	8b 45 08             	mov    0x8(%ebp),%eax
801042e2:	89 04 24             	mov    %eax,(%esp)
801042e5:	e8 8f ec ff ff       	call   80102f79 <kfree>
801042ea:	eb 0b                	jmp    801042f7 <pipeclose+0x90>
  } else
    release(&p->lock);
801042ec:	8b 45 08             	mov    0x8(%ebp),%eax
801042ef:	89 04 24             	mov    %eax,(%esp)
801042f2:	e8 52 0f 00 00       	call   80105249 <release>
}
801042f7:	c9                   	leave  
801042f8:	c3                   	ret    

801042f9 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801042f9:	55                   	push   %ebp
801042fa:	89 e5                	mov    %esp,%ebp
801042fc:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
801042ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104302:	89 04 24             	mov    %eax,(%esp)
80104305:	e8 d5 0e 00 00       	call   801051df <acquire>
  for(i = 0; i < n; i++){
8010430a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104311:	e9 a3 00 00 00       	jmp    801043b9 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104316:	eb 56                	jmp    8010436e <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80104318:	8b 45 08             	mov    0x8(%ebp),%eax
8010431b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104321:	85 c0                	test   %eax,%eax
80104323:	74 0c                	je     80104331 <pipewrite+0x38>
80104325:	e8 a5 02 00 00       	call   801045cf <myproc>
8010432a:	8b 40 24             	mov    0x24(%eax),%eax
8010432d:	85 c0                	test   %eax,%eax
8010432f:	74 15                	je     80104346 <pipewrite+0x4d>
        release(&p->lock);
80104331:	8b 45 08             	mov    0x8(%ebp),%eax
80104334:	89 04 24             	mov    %eax,(%esp)
80104337:	e8 0d 0f 00 00       	call   80105249 <release>
        return -1;
8010433c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104341:	e9 9d 00 00 00       	jmp    801043e3 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80104346:	8b 45 08             	mov    0x8(%ebp),%eax
80104349:	05 34 02 00 00       	add    $0x234,%eax
8010434e:	89 04 24             	mov    %eax,(%esp)
80104351:	e8 8e 0b 00 00       	call   80104ee4 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
80104359:	8b 55 08             	mov    0x8(%ebp),%edx
8010435c:	81 c2 38 02 00 00    	add    $0x238,%edx
80104362:	89 44 24 04          	mov    %eax,0x4(%esp)
80104366:	89 14 24             	mov    %edx,(%esp)
80104369:	e8 a2 0a 00 00       	call   80104e10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010436e:	8b 45 08             	mov    0x8(%ebp),%eax
80104371:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104377:	8b 45 08             	mov    0x8(%ebp),%eax
8010437a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104380:	05 00 02 00 00       	add    $0x200,%eax
80104385:	39 c2                	cmp    %eax,%edx
80104387:	74 8f                	je     80104318 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104389:	8b 45 08             	mov    0x8(%ebp),%eax
8010438c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104392:	8d 48 01             	lea    0x1(%eax),%ecx
80104395:	8b 55 08             	mov    0x8(%ebp),%edx
80104398:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010439e:	25 ff 01 00 00       	and    $0x1ff,%eax
801043a3:	89 c1                	mov    %eax,%ecx
801043a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ab:	01 d0                	add    %edx,%eax
801043ad:	8a 10                	mov    (%eax),%dl
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043b6:	ff 45 f4             	incl   -0xc(%ebp)
801043b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bc:	3b 45 10             	cmp    0x10(%ebp),%eax
801043bf:	0f 8c 51 ff ff ff    	jl     80104316 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	05 34 02 00 00       	add    $0x234,%eax
801043cd:	89 04 24             	mov    %eax,(%esp)
801043d0:	e8 0f 0b 00 00       	call   80104ee4 <wakeup>
  release(&p->lock);
801043d5:	8b 45 08             	mov    0x8(%ebp),%eax
801043d8:	89 04 24             	mov    %eax,(%esp)
801043db:	e8 69 0e 00 00       	call   80105249 <release>
  return n;
801043e0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043e3:	c9                   	leave  
801043e4:	c3                   	ret    

801043e5 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043e5:	55                   	push   %ebp
801043e6:	89 e5                	mov    %esp,%ebp
801043e8:	53                   	push   %ebx
801043e9:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801043ec:	8b 45 08             	mov    0x8(%ebp),%eax
801043ef:	89 04 24             	mov    %eax,(%esp)
801043f2:	e8 e8 0d 00 00       	call   801051df <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043f7:	eb 39                	jmp    80104432 <piperead+0x4d>
    if(myproc()->killed){
801043f9:	e8 d1 01 00 00       	call   801045cf <myproc>
801043fe:	8b 40 24             	mov    0x24(%eax),%eax
80104401:	85 c0                	test   %eax,%eax
80104403:	74 15                	je     8010441a <piperead+0x35>
      release(&p->lock);
80104405:	8b 45 08             	mov    0x8(%ebp),%eax
80104408:	89 04 24             	mov    %eax,(%esp)
8010440b:	e8 39 0e 00 00       	call   80105249 <release>
      return -1;
80104410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104415:	e9 b3 00 00 00       	jmp    801044cd <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010441a:	8b 45 08             	mov    0x8(%ebp),%eax
8010441d:	8b 55 08             	mov    0x8(%ebp),%edx
80104420:	81 c2 34 02 00 00    	add    $0x234,%edx
80104426:	89 44 24 04          	mov    %eax,0x4(%esp)
8010442a:	89 14 24             	mov    %edx,(%esp)
8010442d:	e8 de 09 00 00       	call   80104e10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104432:	8b 45 08             	mov    0x8(%ebp),%eax
80104435:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010443b:	8b 45 08             	mov    0x8(%ebp),%eax
8010443e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104444:	39 c2                	cmp    %eax,%edx
80104446:	75 0d                	jne    80104455 <piperead+0x70>
80104448:	8b 45 08             	mov    0x8(%ebp),%eax
8010444b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104451:	85 c0                	test   %eax,%eax
80104453:	75 a4                	jne    801043f9 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010445c:	eb 49                	jmp    801044a7 <piperead+0xc2>
    if(p->nread == p->nwrite)
8010445e:	8b 45 08             	mov    0x8(%ebp),%eax
80104461:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104467:	8b 45 08             	mov    0x8(%ebp),%eax
8010446a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104470:	39 c2                	cmp    %eax,%edx
80104472:	75 02                	jne    80104476 <piperead+0x91>
      break;
80104474:	eb 39                	jmp    801044af <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104476:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010447c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010447f:	8b 45 08             	mov    0x8(%ebp),%eax
80104482:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104488:	8d 48 01             	lea    0x1(%eax),%ecx
8010448b:	8b 55 08             	mov    0x8(%ebp),%edx
8010448e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104494:	25 ff 01 00 00       	and    $0x1ff,%eax
80104499:	89 c2                	mov    %eax,%edx
8010449b:	8b 45 08             	mov    0x8(%ebp),%eax
8010449e:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
801044a2:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044a4:	ff 45 f4             	incl   -0xc(%ebp)
801044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801044ad:	7c af                	jl     8010445e <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044af:	8b 45 08             	mov    0x8(%ebp),%eax
801044b2:	05 38 02 00 00       	add    $0x238,%eax
801044b7:	89 04 24             	mov    %eax,(%esp)
801044ba:	e8 25 0a 00 00       	call   80104ee4 <wakeup>
  release(&p->lock);
801044bf:	8b 45 08             	mov    0x8(%ebp),%eax
801044c2:	89 04 24             	mov    %eax,(%esp)
801044c5:	e8 7f 0d 00 00       	call   80105249 <release>
  return i;
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044cd:	83 c4 24             	add    $0x24,%esp
801044d0:	5b                   	pop    %ebx
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
	...

801044d4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044da:	9c                   	pushf  
801044db:	58                   	pop    %eax
801044dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044e2:	c9                   	leave  
801044e3:	c3                   	ret    

801044e4 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044e7:	fb                   	sti    
}
801044e8:	5d                   	pop    %ebp
801044e9:	c3                   	ret    

801044ea <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801044ea:	55                   	push   %ebp
801044eb:	89 e5                	mov    %esp,%ebp
801044ed:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801044f0:	c7 44 24 04 e0 88 10 	movl   $0x801088e0,0x4(%esp)
801044f7:	80 
801044f8:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
801044ff:	e8 ba 0c 00 00       	call   801051be <initlock>
}
80104504:	c9                   	leave  
80104505:	c3                   	ret    

80104506 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104506:	55                   	push   %ebp
80104507:	89 e5                	mov    %esp,%ebp
80104509:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010450c:	e8 3a 00 00 00       	call   8010454b <mycpu>
80104511:	89 c2                	mov    %eax,%edx
80104513:	b8 a0 39 11 80       	mov    $0x801139a0,%eax
80104518:	29 c2                	sub    %eax,%edx
8010451a:	89 d0                	mov    %edx,%eax
8010451c:	c1 f8 04             	sar    $0x4,%eax
8010451f:	89 c1                	mov    %eax,%ecx
80104521:	89 ca                	mov    %ecx,%edx
80104523:	c1 e2 03             	shl    $0x3,%edx
80104526:	01 ca                	add    %ecx,%edx
80104528:	89 d0                	mov    %edx,%eax
8010452a:	c1 e0 05             	shl    $0x5,%eax
8010452d:	29 d0                	sub    %edx,%eax
8010452f:	c1 e0 02             	shl    $0x2,%eax
80104532:	01 c8                	add    %ecx,%eax
80104534:	c1 e0 03             	shl    $0x3,%eax
80104537:	01 c8                	add    %ecx,%eax
80104539:	89 c2                	mov    %eax,%edx
8010453b:	c1 e2 0f             	shl    $0xf,%edx
8010453e:	29 c2                	sub    %eax,%edx
80104540:	c1 e2 02             	shl    $0x2,%edx
80104543:	01 ca                	add    %ecx,%edx
80104545:	89 d0                	mov    %edx,%eax
80104547:	f7 d8                	neg    %eax
}
80104549:	c9                   	leave  
8010454a:	c3                   	ret    

8010454b <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
8010454b:	55                   	push   %ebp
8010454c:	89 e5                	mov    %esp,%ebp
8010454e:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
80104551:	e8 7e ff ff ff       	call   801044d4 <readeflags>
80104556:	25 00 02 00 00       	and    $0x200,%eax
8010455b:	85 c0                	test   %eax,%eax
8010455d:	74 0c                	je     8010456b <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
8010455f:	c7 04 24 e8 88 10 80 	movl   $0x801088e8,(%esp)
80104566:	e8 e9 bf ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
8010456b:	e8 1d ee ff ff       	call   8010338d <lapicid>
80104570:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010457a:	eb 3b                	jmp    801045b7 <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
8010457c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457f:	89 d0                	mov    %edx,%eax
80104581:	c1 e0 02             	shl    $0x2,%eax
80104584:	01 d0                	add    %edx,%eax
80104586:	01 c0                	add    %eax,%eax
80104588:	01 d0                	add    %edx,%eax
8010458a:	c1 e0 04             	shl    $0x4,%eax
8010458d:	05 a0 39 11 80       	add    $0x801139a0,%eax
80104592:	8a 00                	mov    (%eax),%al
80104594:	0f b6 c0             	movzbl %al,%eax
80104597:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010459a:	75 18                	jne    801045b4 <mycpu+0x69>
      return &cpus[i];
8010459c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459f:	89 d0                	mov    %edx,%eax
801045a1:	c1 e0 02             	shl    $0x2,%eax
801045a4:	01 d0                	add    %edx,%eax
801045a6:	01 c0                	add    %eax,%eax
801045a8:	01 d0                	add    %edx,%eax
801045aa:	c1 e0 04             	shl    $0x4,%eax
801045ad:	05 a0 39 11 80       	add    $0x801139a0,%eax
801045b2:	eb 19                	jmp    801045cd <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801045b4:	ff 45 f4             	incl   -0xc(%ebp)
801045b7:	a1 20 3f 11 80       	mov    0x80113f20,%eax
801045bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801045bf:	7c bb                	jl     8010457c <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801045c1:	c7 04 24 0e 89 10 80 	movl   $0x8010890e,(%esp)
801045c8:	e8 87 bf ff ff       	call   80100554 <panic>
}
801045cd:	c9                   	leave  
801045ce:	c3                   	ret    

801045cf <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801045cf:	55                   	push   %ebp
801045d0:	89 e5                	mov    %esp,%ebp
801045d2:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801045d5:	e8 64 0d 00 00       	call   8010533e <pushcli>
  c = mycpu();
801045da:	e8 6c ff ff ff       	call   8010454b <mycpu>
801045df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801045e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801045eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801045ee:	e8 95 0d 00 00       	call   80105388 <popcli>
  return p;
801045f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801045f6:	c9                   	leave  
801045f7:	c3                   	ret    

801045f8 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801045f8:	55                   	push   %ebp
801045f9:	89 e5                	mov    %esp,%ebp
801045fb:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801045fe:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104605:	e8 d5 0b 00 00       	call   801051df <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010460a:	c7 45 f4 74 3f 11 80 	movl   $0x80113f74,-0xc(%ebp)
80104611:	eb 50                	jmp    80104663 <allocproc+0x6b>
    if(p->state == UNUSED)
80104613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104616:	8b 40 0c             	mov    0xc(%eax),%eax
80104619:	85 c0                	test   %eax,%eax
8010461b:	75 42                	jne    8010465f <allocproc+0x67>
      goto found;
8010461d:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010461e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104621:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104628:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010462d:	8d 50 01             	lea    0x1(%eax),%edx
80104630:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
80104636:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104639:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
8010463c:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104643:	e8 01 0c 00 00       	call   80105249 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104648:	e8 c2 e9 ff ff       	call   8010300f <kalloc>
8010464d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104650:	89 42 08             	mov    %eax,0x8(%edx)
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	8b 40 08             	mov    0x8(%eax),%eax
80104659:	85 c0                	test   %eax,%eax
8010465b:	75 33                	jne    80104690 <allocproc+0x98>
8010465d:	eb 20                	jmp    8010467f <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010465f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104663:	81 7d f4 74 5e 11 80 	cmpl   $0x80115e74,-0xc(%ebp)
8010466a:	72 a7                	jb     80104613 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
8010466c:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104673:	e8 d1 0b 00 00       	call   80105249 <release>
  return 0;
80104678:	b8 00 00 00 00       	mov    $0x0,%eax
8010467d:	eb 76                	jmp    801046f5 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104682:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104689:	b8 00 00 00 00       	mov    $0x0,%eax
8010468e:	eb 65                	jmp    801046f5 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
80104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104693:	8b 40 08             	mov    0x8(%eax),%eax
80104696:	05 00 10 00 00       	add    $0x1000,%eax
8010469b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010469e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046a8:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046ab:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801046af:	ba bc 67 10 80       	mov    $0x801067bc,%edx
801046b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046b7:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046b9:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801046bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046c3:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c9:	8b 40 1c             	mov    0x1c(%eax),%eax
801046cc:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801046d3:	00 
801046d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801046db:	00 
801046dc:	89 04 24             	mov    %eax,(%esp)
801046df:	e8 5e 0d 00 00       	call   80105442 <memset>
  p->context->eip = (uint)forkret;
801046e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046ea:	ba d1 4d 10 80       	mov    $0x80104dd1,%edx
801046ef:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801046f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046f5:	c9                   	leave  
801046f6:	c3                   	ret    

801046f7 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801046f7:	55                   	push   %ebp
801046f8:	89 e5                	mov    %esp,%ebp
801046fa:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801046fd:	e8 f6 fe ff ff       	call   801045f8 <allocproc>
80104702:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104708:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
8010470d:	e8 e8 35 00 00       	call   80107cfa <setupkvm>
80104712:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104715:	89 42 04             	mov    %eax,0x4(%edx)
80104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471b:	8b 40 04             	mov    0x4(%eax),%eax
8010471e:	85 c0                	test   %eax,%eax
80104720:	75 0c                	jne    8010472e <userinit+0x37>
    panic("userinit: out of memory?");
80104722:	c7 04 24 1e 89 10 80 	movl   $0x8010891e,(%esp)
80104729:	e8 26 be ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010472e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104736:	8b 40 04             	mov    0x4(%eax),%eax
80104739:	89 54 24 08          	mov    %edx,0x8(%esp)
8010473d:	c7 44 24 04 c0 b4 10 	movl   $0x8010b4c0,0x4(%esp)
80104744:	80 
80104745:	89 04 24             	mov    %eax,(%esp)
80104748:	e8 0e 38 00 00       	call   80107f5b <inituvm>
  p->sz = PGSIZE;
8010474d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104750:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104759:	8b 40 18             	mov    0x18(%eax),%eax
8010475c:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104763:	00 
80104764:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010476b:	00 
8010476c:	89 04 24             	mov    %eax,(%esp)
8010476f:	e8 ce 0c 00 00       	call   80105442 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104777:	8b 40 18             	mov    0x18(%eax),%eax
8010477a:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104783:	8b 40 18             	mov    0x18(%eax),%eax
80104786:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	8b 50 18             	mov    0x18(%eax),%edx
80104792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104795:	8b 40 18             	mov    0x18(%eax),%eax
80104798:	8b 40 2c             	mov    0x2c(%eax),%eax
8010479b:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
8010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a2:	8b 50 18             	mov    0x18(%eax),%edx
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	8b 40 18             	mov    0x18(%eax),%eax
801047ab:	8b 40 2c             	mov    0x2c(%eax),%eax
801047ae:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b5:	8b 40 18             	mov    0x18(%eax),%eax
801047b8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c2:	8b 40 18             	mov    0x18(%eax),%eax
801047c5:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801047cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cf:	8b 40 18             	mov    0x18(%eax),%eax
801047d2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dc:	83 c0 6c             	add    $0x6c,%eax
801047df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801047e6:	00 
801047e7:	c7 44 24 04 37 89 10 	movl   $0x80108937,0x4(%esp)
801047ee:	80 
801047ef:	89 04 24             	mov    %eax,(%esp)
801047f2:	e8 57 0e 00 00       	call   8010564e <safestrcpy>
  p->cwd = namei("/");
801047f7:	c7 04 24 40 89 10 80 	movl   $0x80108940,(%esp)
801047fe:	e8 00 e1 ff ff       	call   80102903 <namei>
80104803:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104806:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104809:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104810:	e8 ca 09 00 00       	call   801051df <acquire>

  p->state = RUNNABLE;
80104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104818:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010481f:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104826:	e8 1e 0a 00 00       	call   80105249 <release>
}
8010482b:	c9                   	leave  
8010482c:	c3                   	ret    

8010482d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010482d:	55                   	push   %ebp
8010482e:	89 e5                	mov    %esp,%ebp
80104830:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
80104833:	e8 97 fd ff ff       	call   801045cf <myproc>
80104838:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
8010483b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010483e:	8b 00                	mov    (%eax),%eax
80104840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104847:	7e 31                	jle    8010487a <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104849:	8b 55 08             	mov    0x8(%ebp),%edx
8010484c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484f:	01 c2                	add    %eax,%edx
80104851:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104854:	8b 40 04             	mov    0x4(%eax),%eax
80104857:	89 54 24 08          	mov    %edx,0x8(%esp)
8010485b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010485e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104862:	89 04 24             	mov    %eax,(%esp)
80104865:	e8 5c 38 00 00       	call   801080c6 <allocuvm>
8010486a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010486d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104871:	75 3e                	jne    801048b1 <growproc+0x84>
      return -1;
80104873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104878:	eb 4f                	jmp    801048c9 <growproc+0x9c>
  } else if(n < 0){
8010487a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010487e:	79 31                	jns    801048b1 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104880:	8b 55 08             	mov    0x8(%ebp),%edx
80104883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104886:	01 c2                	add    %eax,%edx
80104888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010488b:	8b 40 04             	mov    0x4(%eax),%eax
8010488e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104892:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104895:	89 54 24 04          	mov    %edx,0x4(%esp)
80104899:	89 04 24             	mov    %eax,(%esp)
8010489c:	e8 3b 39 00 00       	call   801081dc <deallocuvm>
801048a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048a8:	75 07                	jne    801048b1 <growproc+0x84>
      return -1;
801048aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048af:	eb 18                	jmp    801048c9 <growproc+0x9c>
  }
  curproc->sz = sz;
801048b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048b7:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801048b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048bc:	89 04 24             	mov    %eax,(%esp)
801048bf:	e8 10 35 00 00       	call   80107dd4 <switchuvm>
  return 0;
801048c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048c9:	c9                   	leave  
801048ca:	c3                   	ret    

801048cb <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801048cb:	55                   	push   %ebp
801048cc:	89 e5                	mov    %esp,%ebp
801048ce:	57                   	push   %edi
801048cf:	56                   	push   %esi
801048d0:	53                   	push   %ebx
801048d1:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801048d4:	e8 f6 fc ff ff       	call   801045cf <myproc>
801048d9:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801048dc:	e8 17 fd ff ff       	call   801045f8 <allocproc>
801048e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
801048e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801048e8:	75 0a                	jne    801048f4 <fork+0x29>
    return -1;
801048ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ef:	e9 35 01 00 00       	jmp    80104a29 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801048f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f7:	8b 10                	mov    (%eax),%edx
801048f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fc:	8b 40 04             	mov    0x4(%eax),%eax
801048ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80104903:	89 04 24             	mov    %eax,(%esp)
80104906:	e8 71 3a 00 00       	call   8010837c <copyuvm>
8010490b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010490e:	89 42 04             	mov    %eax,0x4(%edx)
80104911:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104914:	8b 40 04             	mov    0x4(%eax),%eax
80104917:	85 c0                	test   %eax,%eax
80104919:	75 2c                	jne    80104947 <fork+0x7c>
    kfree(np->kstack);
8010491b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010491e:	8b 40 08             	mov    0x8(%eax),%eax
80104921:	89 04 24             	mov    %eax,(%esp)
80104924:	e8 50 e6 ff ff       	call   80102f79 <kfree>
    np->kstack = 0;
80104929:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010492c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104933:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104936:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010493d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104942:	e9 e2 00 00 00       	jmp    80104a29 <fork+0x15e>
  }
  np->sz = curproc->sz;
80104947:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494a:	8b 10                	mov    (%eax),%edx
8010494c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010494f:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104951:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104954:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104957:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
8010495a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010495d:	8b 50 18             	mov    0x18(%eax),%edx
80104960:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104963:	8b 40 18             	mov    0x18(%eax),%eax
80104966:	89 c3                	mov    %eax,%ebx
80104968:	b8 13 00 00 00       	mov    $0x13,%eax
8010496d:	89 d7                	mov    %edx,%edi
8010496f:	89 de                	mov    %ebx,%esi
80104971:	89 c1                	mov    %eax,%ecx
80104973:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104975:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104978:	8b 40 18             	mov    0x18(%eax),%eax
8010497b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104982:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104989:	eb 36                	jmp    801049c1 <fork+0xf6>
    if(curproc->ofile[i])
8010498b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010498e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104991:	83 c2 08             	add    $0x8,%edx
80104994:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104998:	85 c0                	test   %eax,%eax
8010499a:	74 22                	je     801049be <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010499c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049a2:	83 c2 08             	add    $0x8,%edx
801049a5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049a9:	89 04 24             	mov    %eax,(%esp)
801049ac:	e8 cb ca ff ff       	call   8010147c <filedup>
801049b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801049b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801049b7:	83 c1 08             	add    $0x8,%ecx
801049ba:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801049be:	ff 45 e4             	incl   -0x1c(%ebp)
801049c1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801049c5:	7e c4                	jle    8010498b <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801049c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ca:	8b 40 68             	mov    0x68(%eax),%eax
801049cd:	89 04 24             	mov    %eax,(%esp)
801049d0:	e8 d7 d3 ff ff       	call   80101dac <idup>
801049d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801049d8:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049de:	8d 50 6c             	lea    0x6c(%eax),%edx
801049e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801049e4:	83 c0 6c             	add    $0x6c,%eax
801049e7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801049ee:	00 
801049ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801049f3:	89 04 24             	mov    %eax,(%esp)
801049f6:	e8 53 0c 00 00       	call   8010564e <safestrcpy>

  pid = np->pid;
801049fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801049fe:	8b 40 10             	mov    0x10(%eax),%eax
80104a01:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104a04:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104a0b:	e8 cf 07 00 00       	call   801051df <acquire>

  np->state = RUNNABLE;
80104a10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a13:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104a1a:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104a21:	e8 23 08 00 00       	call   80105249 <release>

  return pid;
80104a26:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104a29:	83 c4 2c             	add    $0x2c,%esp
80104a2c:	5b                   	pop    %ebx
80104a2d:	5e                   	pop    %esi
80104a2e:	5f                   	pop    %edi
80104a2f:	5d                   	pop    %ebp
80104a30:	c3                   	ret    

80104a31 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104a31:	55                   	push   %ebp
80104a32:	89 e5                	mov    %esp,%ebp
80104a34:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104a37:	e8 93 fb ff ff       	call   801045cf <myproc>
80104a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104a3f:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104a44:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a47:	75 0c                	jne    80104a55 <exit+0x24>
    panic("init exiting");
80104a49:	c7 04 24 42 89 10 80 	movl   $0x80108942,(%esp)
80104a50:	e8 ff ba ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a5c:	eb 3a                	jmp    80104a98 <exit+0x67>
    if(curproc->ofile[fd]){
80104a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a61:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a64:	83 c2 08             	add    $0x8,%edx
80104a67:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	74 26                	je     80104a95 <exit+0x64>
      fileclose(curproc->ofile[fd]);
80104a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a75:	83 c2 08             	add    $0x8,%edx
80104a78:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a7c:	89 04 24             	mov    %eax,(%esp)
80104a7f:	e8 40 ca ff ff       	call   801014c4 <fileclose>
      curproc->ofile[fd] = 0;
80104a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a87:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a8a:	83 c2 08             	add    $0x8,%edx
80104a8d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a94:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a95:	ff 45 f0             	incl   -0x10(%ebp)
80104a98:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a9c:	7e c0                	jle    80104a5e <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a9e:	e8 34 ee ff ff       	call   801038d7 <begin_op>
  iput(curproc->cwd);
80104aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aa6:	8b 40 68             	mov    0x68(%eax),%eax
80104aa9:	89 04 24             	mov    %eax,(%esp)
80104aac:	e8 7b d4 ff ff       	call   80101f2c <iput>
  end_op();
80104ab1:	e8 a3 ee ff ff       	call   80103959 <end_op>
  curproc->cwd = 0;
80104ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ab9:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ac0:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104ac7:	e8 13 07 00 00       	call   801051df <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104acf:	8b 40 14             	mov    0x14(%eax),%eax
80104ad2:	89 04 24             	mov    %eax,(%esp)
80104ad5:	e8 cc 03 00 00       	call   80104ea6 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ada:	c7 45 f4 74 3f 11 80 	movl   $0x80113f74,-0xc(%ebp)
80104ae1:	eb 33                	jmp    80104b16 <exit+0xe5>
    if(p->parent == curproc){
80104ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae6:	8b 40 14             	mov    0x14(%eax),%eax
80104ae9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104aec:	75 24                	jne    80104b12 <exit+0xe1>
      p->parent = initproc;
80104aee:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afd:	8b 40 0c             	mov    0xc(%eax),%eax
80104b00:	83 f8 05             	cmp    $0x5,%eax
80104b03:	75 0d                	jne    80104b12 <exit+0xe1>
        wakeup1(initproc);
80104b05:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104b0a:	89 04 24             	mov    %eax,(%esp)
80104b0d:	e8 94 03 00 00       	call   80104ea6 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b12:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b16:	81 7d f4 74 5e 11 80 	cmpl   $0x80115e74,-0xc(%ebp)
80104b1d:	72 c4                	jb     80104ae3 <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b22:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b29:	e8 c3 01 00 00       	call   80104cf1 <sched>
  panic("zombie exit");
80104b2e:	c7 04 24 4f 89 10 80 	movl   $0x8010894f,(%esp)
80104b35:	e8 1a ba ff ff       	call   80100554 <panic>

80104b3a <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b3a:	55                   	push   %ebp
80104b3b:	89 e5                	mov    %esp,%ebp
80104b3d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104b40:	e8 8a fa ff ff       	call   801045cf <myproc>
80104b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104b48:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104b4f:	e8 8b 06 00 00       	call   801051df <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104b54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b5b:	c7 45 f4 74 3f 11 80 	movl   $0x80113f74,-0xc(%ebp)
80104b62:	e9 95 00 00 00       	jmp    80104bfc <wait+0xc2>
      if(p->parent != curproc)
80104b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6a:	8b 40 14             	mov    0x14(%eax),%eax
80104b6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104b70:	74 05                	je     80104b77 <wait+0x3d>
        continue;
80104b72:	e9 81 00 00 00       	jmp    80104bf8 <wait+0xbe>
      havekids = 1;
80104b77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b81:	8b 40 0c             	mov    0xc(%eax),%eax
80104b84:	83 f8 05             	cmp    $0x5,%eax
80104b87:	75 6f                	jne    80104bf8 <wait+0xbe>
        // Found one.
        pid = p->pid;
80104b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8c:	8b 40 10             	mov    0x10(%eax),%eax
80104b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b95:	8b 40 08             	mov    0x8(%eax),%eax
80104b98:	89 04 24             	mov    %eax,(%esp)
80104b9b:	e8 d9 e3 ff ff       	call   80102f79 <kfree>
        p->kstack = 0;
80104ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bad:	8b 40 04             	mov    0x4(%eax),%eax
80104bb0:	89 04 24             	mov    %eax,(%esp)
80104bb3:	e8 e8 36 00 00       	call   801082a0 <freevm>
        p->pid = 0;
80104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcf:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd6:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104be7:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104bee:	e8 56 06 00 00       	call   80105249 <release>
        return pid;
80104bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104bf6:	eb 4c                	jmp    80104c44 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf8:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104bfc:	81 7d f4 74 5e 11 80 	cmpl   $0x80115e74,-0xc(%ebp)
80104c03:	0f 82 5e ff ff ff    	jb     80104b67 <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c0d:	74 0a                	je     80104c19 <wait+0xdf>
80104c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c12:	8b 40 24             	mov    0x24(%eax),%eax
80104c15:	85 c0                	test   %eax,%eax
80104c17:	74 13                	je     80104c2c <wait+0xf2>
      release(&ptable.lock);
80104c19:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104c20:	e8 24 06 00 00       	call   80105249 <release>
      return -1;
80104c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c2a:	eb 18                	jmp    80104c44 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c2c:	c7 44 24 04 40 3f 11 	movl   $0x80113f40,0x4(%esp)
80104c33:	80 
80104c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c37:	89 04 24             	mov    %eax,(%esp)
80104c3a:	e8 d1 01 00 00       	call   80104e10 <sleep>
  }
80104c3f:	e9 10 ff ff ff       	jmp    80104b54 <wait+0x1a>
}
80104c44:	c9                   	leave  
80104c45:	c3                   	ret    

80104c46 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c46:	55                   	push   %ebp
80104c47:	89 e5                	mov    %esp,%ebp
80104c49:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104c4c:	e8 fa f8 ff ff       	call   8010454b <mycpu>
80104c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c57:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104c5e:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c61:	e8 7e f8 ff ff       	call   801044e4 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c66:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104c6d:	e8 6d 05 00 00       	call   801051df <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c72:	c7 45 f4 74 3f 11 80 	movl   $0x80113f74,-0xc(%ebp)
80104c79:	eb 5c                	jmp    80104cd7 <scheduler+0x91>
      if(p->state != RUNNABLE)
80104c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c81:	83 f8 03             	cmp    $0x3,%eax
80104c84:	74 02                	je     80104c88 <scheduler+0x42>
        continue;
80104c86:	eb 4b                	jmp    80104cd3 <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c8e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c97:	89 04 24             	mov    %eax,(%esp)
80104c9a:	e8 35 31 00 00       	call   80107dd4 <switchuvm>
      p->state = RUNNING;
80104c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca2:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cac:	8b 40 1c             	mov    0x1c(%eax),%eax
80104caf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cb2:	83 c2 04             	add    $0x4,%edx
80104cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb9:	89 14 24             	mov    %edx,(%esp)
80104cbc:	e8 fb 09 00 00       	call   801056bc <swtch>
      switchkvm();
80104cc1:	e8 f4 30 00 00       	call   80107dba <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc9:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104cd0:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd3:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104cd7:	81 7d f4 74 5e 11 80 	cmpl   $0x80115e74,-0xc(%ebp)
80104cde:	72 9b                	jb     80104c7b <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104ce0:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104ce7:	e8 5d 05 00 00       	call   80105249 <release>

  }
80104cec:	e9 70 ff ff ff       	jmp    80104c61 <scheduler+0x1b>

80104cf1 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104cf1:	55                   	push   %ebp
80104cf2:	89 e5                	mov    %esp,%ebp
80104cf4:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104cf7:	e8 d3 f8 ff ff       	call   801045cf <myproc>
80104cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104cff:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104d06:	e8 02 06 00 00       	call   8010530d <holding>
80104d0b:	85 c0                	test   %eax,%eax
80104d0d:	75 0c                	jne    80104d1b <sched+0x2a>
    panic("sched ptable.lock");
80104d0f:	c7 04 24 5b 89 10 80 	movl   $0x8010895b,(%esp)
80104d16:	e8 39 b8 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
80104d1b:	e8 2b f8 ff ff       	call   8010454b <mycpu>
80104d20:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d26:	83 f8 01             	cmp    $0x1,%eax
80104d29:	74 0c                	je     80104d37 <sched+0x46>
    panic("sched locks");
80104d2b:	c7 04 24 6d 89 10 80 	movl   $0x8010896d,(%esp)
80104d32:	e8 1d b8 ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
80104d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3a:	8b 40 0c             	mov    0xc(%eax),%eax
80104d3d:	83 f8 04             	cmp    $0x4,%eax
80104d40:	75 0c                	jne    80104d4e <sched+0x5d>
    panic("sched running");
80104d42:	c7 04 24 79 89 10 80 	movl   $0x80108979,(%esp)
80104d49:	e8 06 b8 ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
80104d4e:	e8 81 f7 ff ff       	call   801044d4 <readeflags>
80104d53:	25 00 02 00 00       	and    $0x200,%eax
80104d58:	85 c0                	test   %eax,%eax
80104d5a:	74 0c                	je     80104d68 <sched+0x77>
    panic("sched interruptible");
80104d5c:	c7 04 24 87 89 10 80 	movl   $0x80108987,(%esp)
80104d63:	e8 ec b7 ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
80104d68:	e8 de f7 ff ff       	call   8010454b <mycpu>
80104d6d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104d76:	e8 d0 f7 ff ff       	call   8010454b <mycpu>
80104d7b:	8b 40 04             	mov    0x4(%eax),%eax
80104d7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d81:	83 c2 1c             	add    $0x1c,%edx
80104d84:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d88:	89 14 24             	mov    %edx,(%esp)
80104d8b:	e8 2c 09 00 00       	call   801056bc <swtch>
  mycpu()->intena = intena;
80104d90:	e8 b6 f7 ff ff       	call   8010454b <mycpu>
80104d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d98:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104d9e:	c9                   	leave  
80104d9f:	c3                   	ret    

80104da0 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104da6:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104dad:	e8 2d 04 00 00       	call   801051df <acquire>
  myproc()->state = RUNNABLE;
80104db2:	e8 18 f8 ff ff       	call   801045cf <myproc>
80104db7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dbe:	e8 2e ff ff ff       	call   80104cf1 <sched>
  release(&ptable.lock);
80104dc3:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104dca:	e8 7a 04 00 00       	call   80105249 <release>
}
80104dcf:	c9                   	leave  
80104dd0:	c3                   	ret    

80104dd1 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104dd1:	55                   	push   %ebp
80104dd2:	89 e5                	mov    %esp,%ebp
80104dd4:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104dd7:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104dde:	e8 66 04 00 00       	call   80105249 <release>

  if (first) {
80104de3:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104de8:	85 c0                	test   %eax,%eax
80104dea:	74 22                	je     80104e0e <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104dec:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104df3:	00 00 00 
    iinit(ROOTDEV);
80104df6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104dfd:	e8 75 cc ff ff       	call   80101a77 <iinit>
    initlog(ROOTDEV);
80104e02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e09:	e8 ca e8 ff ff       	call   801036d8 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e0e:	c9                   	leave  
80104e0f:	c3                   	ret    

80104e10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104e16:	e8 b4 f7 ff ff       	call   801045cf <myproc>
80104e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e22:	75 0c                	jne    80104e30 <sleep+0x20>
    panic("sleep");
80104e24:	c7 04 24 9b 89 10 80 	movl   $0x8010899b,(%esp)
80104e2b:	e8 24 b7 ff ff       	call   80100554 <panic>

  if(lk == 0)
80104e30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e34:	75 0c                	jne    80104e42 <sleep+0x32>
    panic("sleep without lk");
80104e36:	c7 04 24 a1 89 10 80 	movl   $0x801089a1,(%esp)
80104e3d:	e8 12 b7 ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e42:	81 7d 0c 40 3f 11 80 	cmpl   $0x80113f40,0xc(%ebp)
80104e49:	74 17                	je     80104e62 <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e4b:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104e52:	e8 88 03 00 00       	call   801051df <acquire>
    release(lk);
80104e57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e5a:	89 04 24             	mov    %eax,(%esp)
80104e5d:	e8 e7 03 00 00       	call   80105249 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e65:	8b 55 08             	mov    0x8(%ebp),%edx
80104e68:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104e75:	e8 77 fe ff ff       	call   80104cf1 <sched>

  // Tidy up.
  p->chan = 0;
80104e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e84:	81 7d 0c 40 3f 11 80 	cmpl   $0x80113f40,0xc(%ebp)
80104e8b:	74 17                	je     80104ea4 <sleep+0x94>
    release(&ptable.lock);
80104e8d:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104e94:	e8 b0 03 00 00       	call   80105249 <release>
    acquire(lk);
80104e99:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9c:	89 04 24             	mov    %eax,(%esp)
80104e9f:	e8 3b 03 00 00       	call   801051df <acquire>
  }
}
80104ea4:	c9                   	leave  
80104ea5:	c3                   	ret    

80104ea6 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ea6:	55                   	push   %ebp
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eac:	c7 45 fc 74 3f 11 80 	movl   $0x80113f74,-0x4(%ebp)
80104eb3:	eb 24                	jmp    80104ed9 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eb8:	8b 40 0c             	mov    0xc(%eax),%eax
80104ebb:	83 f8 02             	cmp    $0x2,%eax
80104ebe:	75 15                	jne    80104ed5 <wakeup1+0x2f>
80104ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec3:	8b 40 20             	mov    0x20(%eax),%eax
80104ec6:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ec9:	75 0a                	jne    80104ed5 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ece:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed5:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104ed9:	81 7d fc 74 5e 11 80 	cmpl   $0x80115e74,-0x4(%ebp)
80104ee0:	72 d3                	jb     80104eb5 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104ee2:	c9                   	leave  
80104ee3:	c3                   	ret    

80104ee4 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104eea:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104ef1:	e8 e9 02 00 00       	call   801051df <acquire>
  wakeup1(chan);
80104ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef9:	89 04 24             	mov    %eax,(%esp)
80104efc:	e8 a5 ff ff ff       	call   80104ea6 <wakeup1>
  release(&ptable.lock);
80104f01:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104f08:	e8 3c 03 00 00       	call   80105249 <release>
}
80104f0d:	c9                   	leave  
80104f0e:	c3                   	ret    

80104f0f <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f0f:	55                   	push   %ebp
80104f10:	89 e5                	mov    %esp,%ebp
80104f12:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f15:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104f1c:	e8 be 02 00 00       	call   801051df <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f21:	c7 45 f4 74 3f 11 80 	movl   $0x80113f74,-0xc(%ebp)
80104f28:	eb 41                	jmp    80104f6b <kill+0x5c>
    if(p->pid == pid){
80104f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2d:	8b 40 10             	mov    0x10(%eax),%eax
80104f30:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f33:	75 32                	jne    80104f67 <kill+0x58>
      p->killed = 1;
80104f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f38:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f42:	8b 40 0c             	mov    0xc(%eax),%eax
80104f45:	83 f8 02             	cmp    $0x2,%eax
80104f48:	75 0a                	jne    80104f54 <kill+0x45>
        p->state = RUNNABLE;
80104f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f54:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104f5b:	e8 e9 02 00 00       	call   80105249 <release>
      return 0;
80104f60:	b8 00 00 00 00       	mov    $0x0,%eax
80104f65:	eb 1e                	jmp    80104f85 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f67:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104f6b:	81 7d f4 74 5e 11 80 	cmpl   $0x80115e74,-0xc(%ebp)
80104f72:	72 b6                	jb     80104f2a <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f74:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104f7b:	e8 c9 02 00 00       	call   80105249 <release>
  return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    

80104f87 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f87:	55                   	push   %ebp
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8d:	c7 45 f0 74 3f 11 80 	movl   $0x80113f74,-0x10(%ebp)
80104f94:	e9 d5 00 00 00       	jmp    8010506e <procdump+0xe7>
    if(p->state == UNUSED)
80104f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	75 05                	jne    80104fa8 <procdump+0x21>
      continue;
80104fa3:	e9 c2 00 00 00       	jmp    8010506a <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fab:	8b 40 0c             	mov    0xc(%eax),%eax
80104fae:	83 f8 05             	cmp    $0x5,%eax
80104fb1:	77 23                	ja     80104fd6 <procdump+0x4f>
80104fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb6:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb9:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	74 12                	je     80104fd6 <procdump+0x4f>
      state = states[p->state];
80104fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc7:	8b 40 0c             	mov    0xc(%eax),%eax
80104fca:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104fd4:	eb 07                	jmp    80104fdd <procdump+0x56>
    else
      state = "???";
80104fd6:	c7 45 ec b2 89 10 80 	movl   $0x801089b2,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe0:	8d 50 6c             	lea    0x6c(%eax),%edx
80104fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe6:	8b 40 10             	mov    0x10(%eax),%eax
80104fe9:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104fed:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ff0:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff8:	c7 04 24 b6 89 10 80 	movl   $0x801089b6,(%esp)
80104fff:	e8 bd b3 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80105004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105007:	8b 40 0c             	mov    0xc(%eax),%eax
8010500a:	83 f8 02             	cmp    $0x2,%eax
8010500d:	75 4f                	jne    8010505e <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010500f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105012:	8b 40 1c             	mov    0x1c(%eax),%eax
80105015:	8b 40 0c             	mov    0xc(%eax),%eax
80105018:	83 c0 08             	add    $0x8,%eax
8010501b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010501e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105022:	89 04 24             	mov    %eax,(%esp)
80105025:	e8 6c 02 00 00       	call   80105296 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010502a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105031:	eb 1a                	jmp    8010504d <procdump+0xc6>
        cprintf(" %p", pc[i]);
80105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105036:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010503a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010503e:	c7 04 24 bf 89 10 80 	movl   $0x801089bf,(%esp)
80105045:	e8 77 b3 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010504a:	ff 45 f4             	incl   -0xc(%ebp)
8010504d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105051:	7f 0b                	jg     8010505e <procdump+0xd7>
80105053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105056:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010505a:	85 c0                	test   %eax,%eax
8010505c:	75 d5                	jne    80105033 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010505e:	c7 04 24 c3 89 10 80 	movl   $0x801089c3,(%esp)
80105065:	e8 57 b3 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010506a:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
8010506e:	81 7d f0 74 5e 11 80 	cmpl   $0x80115e74,-0x10(%ebp)
80105075:	0f 82 1e ff ff ff    	jb     80104f99 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010507b:	c9                   	leave  
8010507c:	c3                   	ret    
8010507d:	00 00                	add    %al,(%eax)
	...

80105080 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80105086:	8b 45 08             	mov    0x8(%ebp),%eax
80105089:	83 c0 04             	add    $0x4,%eax
8010508c:	c7 44 24 04 ef 89 10 	movl   $0x801089ef,0x4(%esp)
80105093:	80 
80105094:	89 04 24             	mov    %eax,(%esp)
80105097:	e8 22 01 00 00       	call   801051be <initlock>
  lk->name = name;
8010509c:	8b 45 08             	mov    0x8(%ebp),%eax
8010509f:	8b 55 0c             	mov    0xc(%ebp),%edx
801050a2:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801050a5:	8b 45 08             	mov    0x8(%ebp),%eax
801050a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801050ae:	8b 45 08             	mov    0x8(%ebp),%eax
801050b1:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
801050b8:	c9                   	leave  
801050b9:	c3                   	ret    

801050ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801050ba:	55                   	push   %ebp
801050bb:	89 e5                	mov    %esp,%ebp
801050bd:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
801050c0:	8b 45 08             	mov    0x8(%ebp),%eax
801050c3:	83 c0 04             	add    $0x4,%eax
801050c6:	89 04 24             	mov    %eax,(%esp)
801050c9:	e8 11 01 00 00       	call   801051df <acquire>
  while (lk->locked) {
801050ce:	eb 15                	jmp    801050e5 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
801050d0:	8b 45 08             	mov    0x8(%ebp),%eax
801050d3:	83 c0 04             	add    $0x4,%eax
801050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050da:	8b 45 08             	mov    0x8(%ebp),%eax
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	e8 2b fd ff ff       	call   80104e10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801050e5:	8b 45 08             	mov    0x8(%ebp),%eax
801050e8:	8b 00                	mov    (%eax),%eax
801050ea:	85 c0                	test   %eax,%eax
801050ec:	75 e2                	jne    801050d0 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801050ee:	8b 45 08             	mov    0x8(%ebp),%eax
801050f1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801050f7:	e8 d3 f4 ff ff       	call   801045cf <myproc>
801050fc:	8b 50 10             	mov    0x10(%eax),%edx
801050ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105102:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105105:	8b 45 08             	mov    0x8(%ebp),%eax
80105108:	83 c0 04             	add    $0x4,%eax
8010510b:	89 04 24             	mov    %eax,(%esp)
8010510e:	e8 36 01 00 00       	call   80105249 <release>
}
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
8010511b:	8b 45 08             	mov    0x8(%ebp),%eax
8010511e:	83 c0 04             	add    $0x4,%eax
80105121:	89 04 24             	mov    %eax,(%esp)
80105124:	e8 b6 00 00 00       	call   801051df <acquire>
  lk->locked = 0;
80105129:	8b 45 08             	mov    0x8(%ebp),%eax
8010512c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105132:	8b 45 08             	mov    0x8(%ebp),%eax
80105135:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010513c:	8b 45 08             	mov    0x8(%ebp),%eax
8010513f:	89 04 24             	mov    %eax,(%esp)
80105142:	e8 9d fd ff ff       	call   80104ee4 <wakeup>
  release(&lk->lk);
80105147:	8b 45 08             	mov    0x8(%ebp),%eax
8010514a:	83 c0 04             	add    $0x4,%eax
8010514d:	89 04 24             	mov    %eax,(%esp)
80105150:	e8 f4 00 00 00       	call   80105249 <release>
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    

80105157 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105157:	55                   	push   %ebp
80105158:	89 e5                	mov    %esp,%ebp
8010515a:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
8010515d:	8b 45 08             	mov    0x8(%ebp),%eax
80105160:	83 c0 04             	add    $0x4,%eax
80105163:	89 04 24             	mov    %eax,(%esp)
80105166:	e8 74 00 00 00       	call   801051df <acquire>
  r = lk->locked;
8010516b:	8b 45 08             	mov    0x8(%ebp),%eax
8010516e:	8b 00                	mov    (%eax),%eax
80105170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105173:	8b 45 08             	mov    0x8(%ebp),%eax
80105176:	83 c0 04             	add    $0x4,%eax
80105179:	89 04 24             	mov    %eax,(%esp)
8010517c:	e8 c8 00 00 00       	call   80105249 <release>
  return r;
80105181:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105184:	c9                   	leave  
80105185:	c3                   	ret    
	...

80105188 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105188:	55                   	push   %ebp
80105189:	89 e5                	mov    %esp,%ebp
8010518b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010518e:	9c                   	pushf  
8010518f:	58                   	pop    %eax
80105190:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105193:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105196:	c9                   	leave  
80105197:	c3                   	ret    

80105198 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105198:	55                   	push   %ebp
80105199:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010519b:	fa                   	cli    
}
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    

8010519e <sti>:

static inline void
sti(void)
{
8010519e:	55                   	push   %ebp
8010519f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801051a1:	fb                   	sti    
}
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    

801051a4 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801051aa:	8b 55 08             	mov    0x8(%ebp),%edx
801051ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b3:	f0 87 02             	lock xchg %eax,(%edx)
801051b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801051b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051bc:	c9                   	leave  
801051bd:	c3                   	ret    

801051be <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801051be:	55                   	push   %ebp
801051bf:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801051c1:	8b 45 08             	mov    0x8(%ebp),%eax
801051c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801051c7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801051ca:	8b 45 08             	mov    0x8(%ebp),%eax
801051cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801051d3:	8b 45 08             	mov    0x8(%ebp),%eax
801051d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051dd:	5d                   	pop    %ebp
801051de:	c3                   	ret    

801051df <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801051df:	55                   	push   %ebp
801051e0:	89 e5                	mov    %esp,%ebp
801051e2:	53                   	push   %ebx
801051e3:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051e6:	e8 53 01 00 00       	call   8010533e <pushcli>
  if(holding(lk))
801051eb:	8b 45 08             	mov    0x8(%ebp),%eax
801051ee:	89 04 24             	mov    %eax,(%esp)
801051f1:	e8 17 01 00 00       	call   8010530d <holding>
801051f6:	85 c0                	test   %eax,%eax
801051f8:	74 0c                	je     80105206 <acquire+0x27>
    panic("acquire");
801051fa:	c7 04 24 fa 89 10 80 	movl   $0x801089fa,(%esp)
80105201:	e8 4e b3 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105206:	90                   	nop
80105207:	8b 45 08             	mov    0x8(%ebp),%eax
8010520a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105211:	00 
80105212:	89 04 24             	mov    %eax,(%esp)
80105215:	e8 8a ff ff ff       	call   801051a4 <xchg>
8010521a:	85 c0                	test   %eax,%eax
8010521c:	75 e9                	jne    80105207 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010521e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105223:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105226:	e8 20 f3 ff ff       	call   8010454b <mycpu>
8010522b:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010522e:	8b 45 08             	mov    0x8(%ebp),%eax
80105231:	83 c0 0c             	add    $0xc,%eax
80105234:	89 44 24 04          	mov    %eax,0x4(%esp)
80105238:	8d 45 08             	lea    0x8(%ebp),%eax
8010523b:	89 04 24             	mov    %eax,(%esp)
8010523e:	e8 53 00 00 00       	call   80105296 <getcallerpcs>
}
80105243:	83 c4 14             	add    $0x14,%esp
80105246:	5b                   	pop    %ebx
80105247:	5d                   	pop    %ebp
80105248:	c3                   	ret    

80105249 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105249:	55                   	push   %ebp
8010524a:	89 e5                	mov    %esp,%ebp
8010524c:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010524f:	8b 45 08             	mov    0x8(%ebp),%eax
80105252:	89 04 24             	mov    %eax,(%esp)
80105255:	e8 b3 00 00 00       	call   8010530d <holding>
8010525a:	85 c0                	test   %eax,%eax
8010525c:	75 0c                	jne    8010526a <release+0x21>
    panic("release");
8010525e:	c7 04 24 02 8a 10 80 	movl   $0x80108a02,(%esp)
80105265:	e8 ea b2 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
8010526a:	8b 45 08             	mov    0x8(%ebp),%eax
8010526d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105274:	8b 45 08             	mov    0x8(%ebp),%eax
80105277:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010527e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105283:	8b 45 08             	mov    0x8(%ebp),%eax
80105286:	8b 55 08             	mov    0x8(%ebp),%edx
80105289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010528f:	e8 f4 00 00 00       	call   80105388 <popcli>
}
80105294:	c9                   	leave  
80105295:	c3                   	ret    

80105296 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105296:	55                   	push   %ebp
80105297:	89 e5                	mov    %esp,%ebp
80105299:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010529c:	8b 45 08             	mov    0x8(%ebp),%eax
8010529f:	83 e8 08             	sub    $0x8,%eax
801052a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801052ac:	eb 37                	jmp    801052e5 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801052b2:	74 37                	je     801052eb <getcallerpcs+0x55>
801052b4:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801052bb:	76 2e                	jbe    801052eb <getcallerpcs+0x55>
801052bd:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801052c1:	74 28                	je     801052eb <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d0:	01 c2                	add    %eax,%edx
801052d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d5:	8b 40 04             	mov    0x4(%eax),%eax
801052d8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801052da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052dd:	8b 00                	mov    (%eax),%eax
801052df:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801052e2:	ff 45 f8             	incl   -0x8(%ebp)
801052e5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801052e9:	7e c3                	jle    801052ae <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801052eb:	eb 18                	jmp    80105305 <getcallerpcs+0x6f>
    pcs[i] = 0;
801052ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052fa:	01 d0                	add    %edx,%eax
801052fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105302:	ff 45 f8             	incl   -0x8(%ebp)
80105305:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105309:	7e e2                	jle    801052ed <getcallerpcs+0x57>
    pcs[i] = 0;
}
8010530b:	c9                   	leave  
8010530c:	c3                   	ret    

8010530d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010530d:	55                   	push   %ebp
8010530e:	89 e5                	mov    %esp,%ebp
80105310:	53                   	push   %ebx
80105311:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105314:	8b 45 08             	mov    0x8(%ebp),%eax
80105317:	8b 00                	mov    (%eax),%eax
80105319:	85 c0                	test   %eax,%eax
8010531b:	74 16                	je     80105333 <holding+0x26>
8010531d:	8b 45 08             	mov    0x8(%ebp),%eax
80105320:	8b 58 08             	mov    0x8(%eax),%ebx
80105323:	e8 23 f2 ff ff       	call   8010454b <mycpu>
80105328:	39 c3                	cmp    %eax,%ebx
8010532a:	75 07                	jne    80105333 <holding+0x26>
8010532c:	b8 01 00 00 00       	mov    $0x1,%eax
80105331:	eb 05                	jmp    80105338 <holding+0x2b>
80105333:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105338:	83 c4 04             	add    $0x4,%esp
8010533b:	5b                   	pop    %ebx
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    

8010533e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010533e:	55                   	push   %ebp
8010533f:	89 e5                	mov    %esp,%ebp
80105341:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105344:	e8 3f fe ff ff       	call   80105188 <readeflags>
80105349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
8010534c:	e8 47 fe ff ff       	call   80105198 <cli>
  if(mycpu()->ncli == 0)
80105351:	e8 f5 f1 ff ff       	call   8010454b <mycpu>
80105356:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010535c:	85 c0                	test   %eax,%eax
8010535e:	75 14                	jne    80105374 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80105360:	e8 e6 f1 ff ff       	call   8010454b <mycpu>
80105365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105368:	81 e2 00 02 00 00    	and    $0x200,%edx
8010536e:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105374:	e8 d2 f1 ff ff       	call   8010454b <mycpu>
80105379:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010537f:	42                   	inc    %edx
80105380:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105386:	c9                   	leave  
80105387:	c3                   	ret    

80105388 <popcli>:

void
popcli(void)
{
80105388:	55                   	push   %ebp
80105389:	89 e5                	mov    %esp,%ebp
8010538b:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010538e:	e8 f5 fd ff ff       	call   80105188 <readeflags>
80105393:	25 00 02 00 00       	and    $0x200,%eax
80105398:	85 c0                	test   %eax,%eax
8010539a:	74 0c                	je     801053a8 <popcli+0x20>
    panic("popcli - interruptible");
8010539c:	c7 04 24 0a 8a 10 80 	movl   $0x80108a0a,(%esp)
801053a3:	e8 ac b1 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
801053a8:	e8 9e f1 ff ff       	call   8010454b <mycpu>
801053ad:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053b3:	4a                   	dec    %edx
801053b4:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801053ba:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801053c0:	85 c0                	test   %eax,%eax
801053c2:	79 0c                	jns    801053d0 <popcli+0x48>
    panic("popcli");
801053c4:	c7 04 24 21 8a 10 80 	movl   $0x80108a21,(%esp)
801053cb:	e8 84 b1 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801053d0:	e8 76 f1 ff ff       	call   8010454b <mycpu>
801053d5:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801053db:	85 c0                	test   %eax,%eax
801053dd:	75 14                	jne    801053f3 <popcli+0x6b>
801053df:	e8 67 f1 ff ff       	call   8010454b <mycpu>
801053e4:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801053ea:	85 c0                	test   %eax,%eax
801053ec:	74 05                	je     801053f3 <popcli+0x6b>
    sti();
801053ee:	e8 ab fd ff ff       	call   8010519e <sti>
}
801053f3:	c9                   	leave  
801053f4:	c3                   	ret    
801053f5:	00 00                	add    %al,(%eax)
	...

801053f8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801053f8:	55                   	push   %ebp
801053f9:	89 e5                	mov    %esp,%ebp
801053fb:	57                   	push   %edi
801053fc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801053fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105400:	8b 55 10             	mov    0x10(%ebp),%edx
80105403:	8b 45 0c             	mov    0xc(%ebp),%eax
80105406:	89 cb                	mov    %ecx,%ebx
80105408:	89 df                	mov    %ebx,%edi
8010540a:	89 d1                	mov    %edx,%ecx
8010540c:	fc                   	cld    
8010540d:	f3 aa                	rep stos %al,%es:(%edi)
8010540f:	89 ca                	mov    %ecx,%edx
80105411:	89 fb                	mov    %edi,%ebx
80105413:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105416:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105419:	5b                   	pop    %ebx
8010541a:	5f                   	pop    %edi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    

8010541d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010541d:	55                   	push   %ebp
8010541e:	89 e5                	mov    %esp,%ebp
80105420:	57                   	push   %edi
80105421:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105422:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105425:	8b 55 10             	mov    0x10(%ebp),%edx
80105428:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542b:	89 cb                	mov    %ecx,%ebx
8010542d:	89 df                	mov    %ebx,%edi
8010542f:	89 d1                	mov    %edx,%ecx
80105431:	fc                   	cld    
80105432:	f3 ab                	rep stos %eax,%es:(%edi)
80105434:	89 ca                	mov    %ecx,%edx
80105436:	89 fb                	mov    %edi,%ebx
80105438:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010543b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010543e:	5b                   	pop    %ebx
8010543f:	5f                   	pop    %edi
80105440:	5d                   	pop    %ebp
80105441:	c3                   	ret    

80105442 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105442:	55                   	push   %ebp
80105443:	89 e5                	mov    %esp,%ebp
80105445:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	83 e0 03             	and    $0x3,%eax
8010544e:	85 c0                	test   %eax,%eax
80105450:	75 49                	jne    8010549b <memset+0x59>
80105452:	8b 45 10             	mov    0x10(%ebp),%eax
80105455:	83 e0 03             	and    $0x3,%eax
80105458:	85 c0                	test   %eax,%eax
8010545a:	75 3f                	jne    8010549b <memset+0x59>
    c &= 0xFF;
8010545c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105463:	8b 45 10             	mov    0x10(%ebp),%eax
80105466:	c1 e8 02             	shr    $0x2,%eax
80105469:	89 c2                	mov    %eax,%edx
8010546b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546e:	c1 e0 18             	shl    $0x18,%eax
80105471:	89 c1                	mov    %eax,%ecx
80105473:	8b 45 0c             	mov    0xc(%ebp),%eax
80105476:	c1 e0 10             	shl    $0x10,%eax
80105479:	09 c1                	or     %eax,%ecx
8010547b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547e:	c1 e0 08             	shl    $0x8,%eax
80105481:	09 c8                	or     %ecx,%eax
80105483:	0b 45 0c             	or     0xc(%ebp),%eax
80105486:	89 54 24 08          	mov    %edx,0x8(%esp)
8010548a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010548e:	8b 45 08             	mov    0x8(%ebp),%eax
80105491:	89 04 24             	mov    %eax,(%esp)
80105494:	e8 84 ff ff ff       	call   8010541d <stosl>
80105499:	eb 19                	jmp    801054b4 <memset+0x72>
  } else
    stosb(dst, c, n);
8010549b:	8b 45 10             	mov    0x10(%ebp),%eax
8010549e:	89 44 24 08          	mov    %eax,0x8(%esp)
801054a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a9:	8b 45 08             	mov    0x8(%ebp),%eax
801054ac:	89 04 24             	mov    %eax,(%esp)
801054af:	e8 44 ff ff ff       	call   801053f8 <stosb>
  return dst;
801054b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054b7:	c9                   	leave  
801054b8:	c3                   	ret    

801054b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054b9:	55                   	push   %ebp
801054ba:	89 e5                	mov    %esp,%ebp
801054bc:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801054bf:	8b 45 08             	mov    0x8(%ebp),%eax
801054c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801054c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801054cb:	eb 2a                	jmp    801054f7 <memcmp+0x3e>
    if(*s1 != *s2)
801054cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d0:	8a 10                	mov    (%eax),%dl
801054d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054d5:	8a 00                	mov    (%eax),%al
801054d7:	38 c2                	cmp    %al,%dl
801054d9:	74 16                	je     801054f1 <memcmp+0x38>
      return *s1 - *s2;
801054db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054de:	8a 00                	mov    (%eax),%al
801054e0:	0f b6 d0             	movzbl %al,%edx
801054e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054e6:	8a 00                	mov    (%eax),%al
801054e8:	0f b6 c0             	movzbl %al,%eax
801054eb:	29 c2                	sub    %eax,%edx
801054ed:	89 d0                	mov    %edx,%eax
801054ef:	eb 18                	jmp    80105509 <memcmp+0x50>
    s1++, s2++;
801054f1:	ff 45 fc             	incl   -0x4(%ebp)
801054f4:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801054f7:	8b 45 10             	mov    0x10(%ebp),%eax
801054fa:	8d 50 ff             	lea    -0x1(%eax),%edx
801054fd:	89 55 10             	mov    %edx,0x10(%ebp)
80105500:	85 c0                	test   %eax,%eax
80105502:	75 c9                	jne    801054cd <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105504:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105509:	c9                   	leave  
8010550a:	c3                   	ret    

8010550b <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010550b:	55                   	push   %ebp
8010550c:	89 e5                	mov    %esp,%ebp
8010550e:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105511:	8b 45 0c             	mov    0xc(%ebp),%eax
80105514:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105517:	8b 45 08             	mov    0x8(%ebp),%eax
8010551a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010551d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105520:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105523:	73 3a                	jae    8010555f <memmove+0x54>
80105525:	8b 45 10             	mov    0x10(%ebp),%eax
80105528:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010552b:	01 d0                	add    %edx,%eax
8010552d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105530:	76 2d                	jbe    8010555f <memmove+0x54>
    s += n;
80105532:	8b 45 10             	mov    0x10(%ebp),%eax
80105535:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105538:	8b 45 10             	mov    0x10(%ebp),%eax
8010553b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010553e:	eb 10                	jmp    80105550 <memmove+0x45>
      *--d = *--s;
80105540:	ff 4d f8             	decl   -0x8(%ebp)
80105543:	ff 4d fc             	decl   -0x4(%ebp)
80105546:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105549:	8a 10                	mov    (%eax),%dl
8010554b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010554e:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105550:	8b 45 10             	mov    0x10(%ebp),%eax
80105553:	8d 50 ff             	lea    -0x1(%eax),%edx
80105556:	89 55 10             	mov    %edx,0x10(%ebp)
80105559:	85 c0                	test   %eax,%eax
8010555b:	75 e3                	jne    80105540 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010555d:	eb 25                	jmp    80105584 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010555f:	eb 16                	jmp    80105577 <memmove+0x6c>
      *d++ = *s++;
80105561:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105564:	8d 50 01             	lea    0x1(%eax),%edx
80105567:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010556a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010556d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105570:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105573:	8a 12                	mov    (%edx),%dl
80105575:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105577:	8b 45 10             	mov    0x10(%ebp),%eax
8010557a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010557d:	89 55 10             	mov    %edx,0x10(%ebp)
80105580:	85 c0                	test   %eax,%eax
80105582:	75 dd                	jne    80105561 <memmove+0x56>
      *d++ = *s++;

  return dst;
80105584:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105587:	c9                   	leave  
80105588:	c3                   	ret    

80105589 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105589:	55                   	push   %ebp
8010558a:	89 e5                	mov    %esp,%ebp
8010558c:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010558f:	8b 45 10             	mov    0x10(%ebp),%eax
80105592:	89 44 24 08          	mov    %eax,0x8(%esp)
80105596:	8b 45 0c             	mov    0xc(%ebp),%eax
80105599:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559d:	8b 45 08             	mov    0x8(%ebp),%eax
801055a0:	89 04 24             	mov    %eax,(%esp)
801055a3:	e8 63 ff ff ff       	call   8010550b <memmove>
}
801055a8:	c9                   	leave  
801055a9:	c3                   	ret    

801055aa <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801055aa:	55                   	push   %ebp
801055ab:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801055ad:	eb 09                	jmp    801055b8 <strncmp+0xe>
    n--, p++, q++;
801055af:	ff 4d 10             	decl   0x10(%ebp)
801055b2:	ff 45 08             	incl   0x8(%ebp)
801055b5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801055b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055bc:	74 17                	je     801055d5 <strncmp+0x2b>
801055be:	8b 45 08             	mov    0x8(%ebp),%eax
801055c1:	8a 00                	mov    (%eax),%al
801055c3:	84 c0                	test   %al,%al
801055c5:	74 0e                	je     801055d5 <strncmp+0x2b>
801055c7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ca:	8a 10                	mov    (%eax),%dl
801055cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801055cf:	8a 00                	mov    (%eax),%al
801055d1:	38 c2                	cmp    %al,%dl
801055d3:	74 da                	je     801055af <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801055d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055d9:	75 07                	jne    801055e2 <strncmp+0x38>
    return 0;
801055db:	b8 00 00 00 00       	mov    $0x0,%eax
801055e0:	eb 14                	jmp    801055f6 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
801055e2:	8b 45 08             	mov    0x8(%ebp),%eax
801055e5:	8a 00                	mov    (%eax),%al
801055e7:	0f b6 d0             	movzbl %al,%edx
801055ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ed:	8a 00                	mov    (%eax),%al
801055ef:	0f b6 c0             	movzbl %al,%eax
801055f2:	29 c2                	sub    %eax,%edx
801055f4:	89 d0                	mov    %edx,%eax
}
801055f6:	5d                   	pop    %ebp
801055f7:	c3                   	ret    

801055f8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055f8:	55                   	push   %ebp
801055f9:	89 e5                	mov    %esp,%ebp
801055fb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801055fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105601:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105604:	90                   	nop
80105605:	8b 45 10             	mov    0x10(%ebp),%eax
80105608:	8d 50 ff             	lea    -0x1(%eax),%edx
8010560b:	89 55 10             	mov    %edx,0x10(%ebp)
8010560e:	85 c0                	test   %eax,%eax
80105610:	7e 1c                	jle    8010562e <strncpy+0x36>
80105612:	8b 45 08             	mov    0x8(%ebp),%eax
80105615:	8d 50 01             	lea    0x1(%eax),%edx
80105618:	89 55 08             	mov    %edx,0x8(%ebp)
8010561b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010561e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105621:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105624:	8a 12                	mov    (%edx),%dl
80105626:	88 10                	mov    %dl,(%eax)
80105628:	8a 00                	mov    (%eax),%al
8010562a:	84 c0                	test   %al,%al
8010562c:	75 d7                	jne    80105605 <strncpy+0xd>
    ;
  while(n-- > 0)
8010562e:	eb 0c                	jmp    8010563c <strncpy+0x44>
    *s++ = 0;
80105630:	8b 45 08             	mov    0x8(%ebp),%eax
80105633:	8d 50 01             	lea    0x1(%eax),%edx
80105636:	89 55 08             	mov    %edx,0x8(%ebp)
80105639:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010563c:	8b 45 10             	mov    0x10(%ebp),%eax
8010563f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105642:	89 55 10             	mov    %edx,0x10(%ebp)
80105645:	85 c0                	test   %eax,%eax
80105647:	7f e7                	jg     80105630 <strncpy+0x38>
    *s++ = 0;
  return os;
80105649:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010564c:	c9                   	leave  
8010564d:	c3                   	ret    

8010564e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010564e:	55                   	push   %ebp
8010564f:	89 e5                	mov    %esp,%ebp
80105651:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105654:	8b 45 08             	mov    0x8(%ebp),%eax
80105657:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010565a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010565e:	7f 05                	jg     80105665 <safestrcpy+0x17>
    return os;
80105660:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105663:	eb 2e                	jmp    80105693 <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
80105665:	ff 4d 10             	decl   0x10(%ebp)
80105668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010566c:	7e 1c                	jle    8010568a <safestrcpy+0x3c>
8010566e:	8b 45 08             	mov    0x8(%ebp),%eax
80105671:	8d 50 01             	lea    0x1(%eax),%edx
80105674:	89 55 08             	mov    %edx,0x8(%ebp)
80105677:	8b 55 0c             	mov    0xc(%ebp),%edx
8010567a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010567d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105680:	8a 12                	mov    (%edx),%dl
80105682:	88 10                	mov    %dl,(%eax)
80105684:	8a 00                	mov    (%eax),%al
80105686:	84 c0                	test   %al,%al
80105688:	75 db                	jne    80105665 <safestrcpy+0x17>
    ;
  *s = 0;
8010568a:	8b 45 08             	mov    0x8(%ebp),%eax
8010568d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105690:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105693:	c9                   	leave  
80105694:	c3                   	ret    

80105695 <strlen>:

int
strlen(const char *s)
{
80105695:	55                   	push   %ebp
80105696:	89 e5                	mov    %esp,%ebp
80105698:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010569b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056a2:	eb 03                	jmp    801056a7 <strlen+0x12>
801056a4:	ff 45 fc             	incl   -0x4(%ebp)
801056a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056aa:	8b 45 08             	mov    0x8(%ebp),%eax
801056ad:	01 d0                	add    %edx,%eax
801056af:	8a 00                	mov    (%eax),%al
801056b1:	84 c0                	test   %al,%al
801056b3:	75 ef                	jne    801056a4 <strlen+0xf>
    ;
  return n;
801056b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
	...

801056bc <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801056bc:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801056c0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801056c4:	55                   	push   %ebp
  pushl %ebx
801056c5:	53                   	push   %ebx
  pushl %esi
801056c6:	56                   	push   %esi
  pushl %edi
801056c7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801056c8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801056ca:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801056cc:	5f                   	pop    %edi
  popl %esi
801056cd:	5e                   	pop    %esi
  popl %ebx
801056ce:	5b                   	pop    %ebx
  popl %ebp
801056cf:	5d                   	pop    %ebp
  ret
801056d0:	c3                   	ret    
801056d1:	00 00                	add    %al,(%eax)
	...

801056d4 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801056da:	e8 f0 ee ff ff       	call   801045cf <myproc>
801056df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e5:	8b 00                	mov    (%eax),%eax
801056e7:	3b 45 08             	cmp    0x8(%ebp),%eax
801056ea:	76 0f                	jbe    801056fb <fetchint+0x27>
801056ec:	8b 45 08             	mov    0x8(%ebp),%eax
801056ef:	8d 50 04             	lea    0x4(%eax),%edx
801056f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f5:	8b 00                	mov    (%eax),%eax
801056f7:	39 c2                	cmp    %eax,%edx
801056f9:	76 07                	jbe    80105702 <fetchint+0x2e>
    return -1;
801056fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105700:	eb 0f                	jmp    80105711 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105702:	8b 45 08             	mov    0x8(%ebp),%eax
80105705:	8b 10                	mov    (%eax),%edx
80105707:	8b 45 0c             	mov    0xc(%ebp),%eax
8010570a:	89 10                	mov    %edx,(%eax)
  return 0;
8010570c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105711:	c9                   	leave  
80105712:	c3                   	ret    

80105713 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105713:	55                   	push   %ebp
80105714:	89 e5                	mov    %esp,%ebp
80105716:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105719:	e8 b1 ee ff ff       	call   801045cf <myproc>
8010571e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105721:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105724:	8b 00                	mov    (%eax),%eax
80105726:	3b 45 08             	cmp    0x8(%ebp),%eax
80105729:	77 07                	ja     80105732 <fetchstr+0x1f>
    return -1;
8010572b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105730:	eb 41                	jmp    80105773 <fetchstr+0x60>
  *pp = (char*)addr;
80105732:	8b 55 08             	mov    0x8(%ebp),%edx
80105735:	8b 45 0c             	mov    0xc(%ebp),%eax
80105738:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
8010573a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573d:	8b 00                	mov    (%eax),%eax
8010573f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105742:	8b 45 0c             	mov    0xc(%ebp),%eax
80105745:	8b 00                	mov    (%eax),%eax
80105747:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010574a:	eb 1a                	jmp    80105766 <fetchstr+0x53>
    if(*s == 0)
8010574c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574f:	8a 00                	mov    (%eax),%al
80105751:	84 c0                	test   %al,%al
80105753:	75 0e                	jne    80105763 <fetchstr+0x50>
      return s - *pp;
80105755:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105758:	8b 45 0c             	mov    0xc(%ebp),%eax
8010575b:	8b 00                	mov    (%eax),%eax
8010575d:	29 c2                	sub    %eax,%edx
8010575f:	89 d0                	mov    %edx,%eax
80105761:	eb 10                	jmp    80105773 <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105763:	ff 45 f4             	incl   -0xc(%ebp)
80105766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105769:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010576c:	72 de                	jb     8010574c <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
8010576e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105773:	c9                   	leave  
80105774:	c3                   	ret    

80105775 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105775:	55                   	push   %ebp
80105776:	89 e5                	mov    %esp,%ebp
80105778:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010577b:	e8 4f ee ff ff       	call   801045cf <myproc>
80105780:	8b 40 18             	mov    0x18(%eax),%eax
80105783:	8b 50 44             	mov    0x44(%eax),%edx
80105786:	8b 45 08             	mov    0x8(%ebp),%eax
80105789:	c1 e0 02             	shl    $0x2,%eax
8010578c:	01 d0                	add    %edx,%eax
8010578e:	8d 50 04             	lea    0x4(%eax),%edx
80105791:	8b 45 0c             	mov    0xc(%ebp),%eax
80105794:	89 44 24 04          	mov    %eax,0x4(%esp)
80105798:	89 14 24             	mov    %edx,(%esp)
8010579b:	e8 34 ff ff ff       	call   801056d4 <fetchint>
}
801057a0:	c9                   	leave  
801057a1:	c3                   	ret    

801057a2 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801057a2:	55                   	push   %ebp
801057a3:	89 e5                	mov    %esp,%ebp
801057a5:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
801057a8:	e8 22 ee ff ff       	call   801045cf <myproc>
801057ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801057b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b7:	8b 45 08             	mov    0x8(%ebp),%eax
801057ba:	89 04 24             	mov    %eax,(%esp)
801057bd:	e8 b3 ff ff ff       	call   80105775 <argint>
801057c2:	85 c0                	test   %eax,%eax
801057c4:	79 07                	jns    801057cd <argptr+0x2b>
    return -1;
801057c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057cb:	eb 3d                	jmp    8010580a <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801057cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057d1:	78 21                	js     801057f4 <argptr+0x52>
801057d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d6:	89 c2                	mov    %eax,%edx
801057d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057db:	8b 00                	mov    (%eax),%eax
801057dd:	39 c2                	cmp    %eax,%edx
801057df:	73 13                	jae    801057f4 <argptr+0x52>
801057e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e4:	89 c2                	mov    %eax,%edx
801057e6:	8b 45 10             	mov    0x10(%ebp),%eax
801057e9:	01 c2                	add    %eax,%edx
801057eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ee:	8b 00                	mov    (%eax),%eax
801057f0:	39 c2                	cmp    %eax,%edx
801057f2:	76 07                	jbe    801057fb <argptr+0x59>
    return -1;
801057f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f9:	eb 0f                	jmp    8010580a <argptr+0x68>
  *pp = (char*)i;
801057fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057fe:	89 c2                	mov    %eax,%edx
80105800:	8b 45 0c             	mov    0xc(%ebp),%eax
80105803:	89 10                	mov    %edx,(%eax)
  return 0;
80105805:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    

8010580c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010580c:	55                   	push   %ebp
8010580d:	89 e5                	mov    %esp,%ebp
8010580f:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105812:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105815:	89 44 24 04          	mov    %eax,0x4(%esp)
80105819:	8b 45 08             	mov    0x8(%ebp),%eax
8010581c:	89 04 24             	mov    %eax,(%esp)
8010581f:	e8 51 ff ff ff       	call   80105775 <argint>
80105824:	85 c0                	test   %eax,%eax
80105826:	79 07                	jns    8010582f <argstr+0x23>
    return -1;
80105828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582d:	eb 12                	jmp    80105841 <argstr+0x35>
  return fetchstr(addr, pp);
8010582f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105832:	8b 55 0c             	mov    0xc(%ebp),%edx
80105835:	89 54 24 04          	mov    %edx,0x4(%esp)
80105839:	89 04 24             	mov    %eax,(%esp)
8010583c:	e8 d2 fe ff ff       	call   80105713 <fetchstr>
}
80105841:	c9                   	leave  
80105842:	c3                   	ret    

80105843 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105843:	55                   	push   %ebp
80105844:	89 e5                	mov    %esp,%ebp
80105846:	53                   	push   %ebx
80105847:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
8010584a:	e8 80 ed ff ff       	call   801045cf <myproc>
8010584f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105855:	8b 40 18             	mov    0x18(%eax),%eax
80105858:	8b 40 1c             	mov    0x1c(%eax),%eax
8010585b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010585e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105862:	7e 2d                	jle    80105891 <syscall+0x4e>
80105864:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105867:	83 f8 15             	cmp    $0x15,%eax
8010586a:	77 25                	ja     80105891 <syscall+0x4e>
8010586c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010586f:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105876:	85 c0                	test   %eax,%eax
80105878:	74 17                	je     80105891 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
8010587a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010587d:	8b 58 18             	mov    0x18(%eax),%ebx
80105880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105883:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
8010588a:	ff d0                	call   *%eax
8010588c:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010588f:	eb 34                	jmp    801058c5 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105894:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589a:	8b 40 10             	mov    0x10(%eax),%eax
8010589d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801058a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ac:	c7 04 24 28 8a 10 80 	movl   $0x80108a28,(%esp)
801058b3:	e8 09 ab ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801058b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058bb:	8b 40 18             	mov    0x18(%eax),%eax
801058be:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801058c5:	83 c4 24             	add    $0x24,%esp
801058c8:	5b                   	pop    %ebx
801058c9:	5d                   	pop    %ebp
801058ca:	c3                   	ret    
	...

801058cc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801058cc:	55                   	push   %ebp
801058cd:	89 e5                	mov    %esp,%ebp
801058cf:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801058d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d9:	8b 45 08             	mov    0x8(%ebp),%eax
801058dc:	89 04 24             	mov    %eax,(%esp)
801058df:	e8 91 fe ff ff       	call   80105775 <argint>
801058e4:	85 c0                	test   %eax,%eax
801058e6:	79 07                	jns    801058ef <argfd+0x23>
    return -1;
801058e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ed:	eb 4f                	jmp    8010593e <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f2:	85 c0                	test   %eax,%eax
801058f4:	78 20                	js     80105916 <argfd+0x4a>
801058f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f9:	83 f8 0f             	cmp    $0xf,%eax
801058fc:	7f 18                	jg     80105916 <argfd+0x4a>
801058fe:	e8 cc ec ff ff       	call   801045cf <myproc>
80105903:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105906:	83 c2 08             	add    $0x8,%edx
80105909:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010590d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105914:	75 07                	jne    8010591d <argfd+0x51>
    return -1;
80105916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591b:	eb 21                	jmp    8010593e <argfd+0x72>
  if(pfd)
8010591d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105921:	74 08                	je     8010592b <argfd+0x5f>
    *pfd = fd;
80105923:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105926:	8b 45 0c             	mov    0xc(%ebp),%eax
80105929:	89 10                	mov    %edx,(%eax)
  if(pf)
8010592b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010592f:	74 08                	je     80105939 <argfd+0x6d>
    *pf = f;
80105931:	8b 45 10             	mov    0x10(%ebp),%eax
80105934:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105937:	89 10                	mov    %edx,(%eax)
  return 0;
80105939:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    

80105940 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105946:	e8 84 ec ff ff       	call   801045cf <myproc>
8010594b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010594e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105955:	eb 29                	jmp    80105980 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
80105957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010595d:	83 c2 08             	add    $0x8,%edx
80105960:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105964:	85 c0                	test   %eax,%eax
80105966:	75 15                	jne    8010597d <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105968:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010596b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010596e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105971:	8b 55 08             	mov    0x8(%ebp),%edx
80105974:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597b:	eb 0e                	jmp    8010598b <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
8010597d:	ff 45 f4             	incl   -0xc(%ebp)
80105980:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105984:	7e d1                	jle    80105957 <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105986:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598b:	c9                   	leave  
8010598c:	c3                   	ret    

8010598d <sys_dup>:

int
sys_dup(void)
{
8010598d:	55                   	push   %ebp
8010598e:	89 e5                	mov    %esp,%ebp
80105990:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105993:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105996:	89 44 24 08          	mov    %eax,0x8(%esp)
8010599a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059a1:	00 
801059a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059a9:	e8 1e ff ff ff       	call   801058cc <argfd>
801059ae:	85 c0                	test   %eax,%eax
801059b0:	79 07                	jns    801059b9 <sys_dup+0x2c>
    return -1;
801059b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b7:	eb 29                	jmp    801059e2 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801059b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059bc:	89 04 24             	mov    %eax,(%esp)
801059bf:	e8 7c ff ff ff       	call   80105940 <fdalloc>
801059c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059cb:	79 07                	jns    801059d4 <sys_dup+0x47>
    return -1;
801059cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d2:	eb 0e                	jmp    801059e2 <sys_dup+0x55>
  filedup(f);
801059d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d7:	89 04 24             	mov    %eax,(%esp)
801059da:	e8 9d ba ff ff       	call   8010147c <filedup>
  return fd;
801059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801059e2:	c9                   	leave  
801059e3:	c3                   	ret    

801059e4 <sys_read>:

int
sys_read(void)
{
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801059f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059f8:	00 
801059f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a00:	e8 c7 fe ff ff       	call   801058cc <argfd>
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 35                	js     80105a3e <sys_read+0x5a>
80105a09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a10:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105a17:	e8 59 fd ff ff       	call   80105775 <argint>
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	78 1e                	js     80105a3e <sys_read+0x5a>
80105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a23:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a27:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a35:	e8 68 fd ff ff       	call   801057a2 <argptr>
80105a3a:	85 c0                	test   %eax,%eax
80105a3c:	79 07                	jns    80105a45 <sys_read+0x61>
    return -1;
80105a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a43:	eb 19                	jmp    80105a5e <sys_read+0x7a>
  return fileread(f, p, n);
80105a45:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a48:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a52:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a56:	89 04 24             	mov    %eax,(%esp)
80105a59:	e8 7f bb ff ff       	call   801015dd <fileread>
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_write>:

int
sys_write(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a69:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a74:	00 
80105a75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a7c:	e8 4b fe ff ff       	call   801058cc <argfd>
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 35                	js     80105aba <sys_write+0x5a>
80105a85:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a88:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a8c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105a93:	e8 dd fc ff ff       	call   80105775 <argint>
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	78 1e                	js     80105aba <sys_write+0x5a>
80105a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aa3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ab1:	e8 ec fc ff ff       	call   801057a2 <argptr>
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	79 07                	jns    80105ac1 <sys_write+0x61>
    return -1;
80105aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abf:	eb 19                	jmp    80105ada <sys_write+0x7a>
  return filewrite(f, p, n);
80105ac1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ac4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105ace:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ad2:	89 04 24             	mov    %eax,(%esp)
80105ad5:	e8 be bb ff ff       	call   80101698 <filewrite>
}
80105ada:	c9                   	leave  
80105adb:	c3                   	ret    

80105adc <sys_close>:

int
sys_close(void)
{
80105adc:	55                   	push   %ebp
80105add:	89 e5                	mov    %esp,%ebp
80105adf:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105ae2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80105af0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105af7:	e8 d0 fd ff ff       	call   801058cc <argfd>
80105afc:	85 c0                	test   %eax,%eax
80105afe:	79 07                	jns    80105b07 <sys_close+0x2b>
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b05:	eb 23                	jmp    80105b2a <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
80105b07:	e8 c3 ea ff ff       	call   801045cf <myproc>
80105b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b0f:	83 c2 08             	add    $0x8,%edx
80105b12:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b19:	00 
  fileclose(f);
80105b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1d:	89 04 24             	mov    %eax,(%esp)
80105b20:	e8 9f b9 ff ff       	call   801014c4 <fileclose>
  return 0;
80105b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b2a:	c9                   	leave  
80105b2b:	c3                   	ret    

80105b2c <sys_fstat>:

int
sys_fstat(void)
{
80105b2c:	55                   	push   %ebp
80105b2d:	89 e5                	mov    %esp,%ebp
80105b2f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b35:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b39:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b40:	00 
80105b41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b48:	e8 7f fd ff ff       	call   801058cc <argfd>
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	78 1f                	js     80105b70 <sys_fstat+0x44>
80105b51:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105b58:	00 
80105b59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b67:	e8 36 fc ff ff       	call   801057a2 <argptr>
80105b6c:	85 c0                	test   %eax,%eax
80105b6e:	79 07                	jns    80105b77 <sys_fstat+0x4b>
    return -1;
80105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b75:	eb 12                	jmp    80105b89 <sys_fstat+0x5d>
  return filestat(f, st);
80105b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b81:	89 04 24             	mov    %eax,(%esp)
80105b84:	e8 05 ba ff ff       	call   8010158e <filestat>
}
80105b89:	c9                   	leave  
80105b8a:	c3                   	ret    

80105b8b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b8b:	55                   	push   %ebp
80105b8c:	89 e5                	mov    %esp,%ebp
80105b8e:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b91:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b94:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b9f:	e8 68 fc ff ff       	call   8010580c <argstr>
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 17                	js     80105bbf <sys_link+0x34>
80105ba8:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105bab:	89 44 24 04          	mov    %eax,0x4(%esp)
80105baf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bb6:	e8 51 fc ff ff       	call   8010580c <argstr>
80105bbb:	85 c0                	test   %eax,%eax
80105bbd:	79 0a                	jns    80105bc9 <sys_link+0x3e>
    return -1;
80105bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc4:	e9 3d 01 00 00       	jmp    80105d06 <sys_link+0x17b>

  begin_op();
80105bc9:	e8 09 dd ff ff       	call   801038d7 <begin_op>
  if((ip = namei(old)) == 0){
80105bce:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105bd1:	89 04 24             	mov    %eax,(%esp)
80105bd4:	e8 2a cd ff ff       	call   80102903 <namei>
80105bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105be0:	75 0f                	jne    80105bf1 <sys_link+0x66>
    end_op();
80105be2:	e8 72 dd ff ff       	call   80103959 <end_op>
    return -1;
80105be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bec:	e9 15 01 00 00       	jmp    80105d06 <sys_link+0x17b>
  }

  ilock(ip);
80105bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf4:	89 04 24             	mov    %eax,(%esp)
80105bf7:	e8 e2 c1 ff ff       	call   80101dde <ilock>
  if(ip->type == T_DIR){
80105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bff:	8b 40 50             	mov    0x50(%eax),%eax
80105c02:	66 83 f8 01          	cmp    $0x1,%ax
80105c06:	75 1a                	jne    80105c22 <sys_link+0x97>
    iunlockput(ip);
80105c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c0b:	89 04 24             	mov    %eax,(%esp)
80105c0e:	e8 ca c3 ff ff       	call   80101fdd <iunlockput>
    end_op();
80105c13:	e8 41 dd ff ff       	call   80103959 <end_op>
    return -1;
80105c18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1d:	e9 e4 00 00 00       	jmp    80105d06 <sys_link+0x17b>
  }

  ip->nlink++;
80105c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c25:	66 8b 40 56          	mov    0x56(%eax),%ax
80105c29:	40                   	inc    %eax
80105c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2d:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c34:	89 04 24             	mov    %eax,(%esp)
80105c37:	e8 df bf ff ff       	call   80101c1b <iupdate>
  iunlock(ip);
80105c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3f:	89 04 24             	mov    %eax,(%esp)
80105c42:	e8 a1 c2 ff ff       	call   80101ee8 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105c47:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c4a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105c4d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c51:	89 04 24             	mov    %eax,(%esp)
80105c54:	e8 cc cc ff ff       	call   80102925 <nameiparent>
80105c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c60:	75 02                	jne    80105c64 <sys_link+0xd9>
    goto bad;
80105c62:	eb 68                	jmp    80105ccc <sys_link+0x141>
  ilock(dp);
80105c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c67:	89 04 24             	mov    %eax,(%esp)
80105c6a:	e8 6f c1 ff ff       	call   80101dde <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c72:	8b 10                	mov    (%eax),%edx
80105c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c77:	8b 00                	mov    (%eax),%eax
80105c79:	39 c2                	cmp    %eax,%edx
80105c7b:	75 20                	jne    80105c9d <sys_link+0x112>
80105c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c80:	8b 40 04             	mov    0x4(%eax),%eax
80105c83:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c87:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c91:	89 04 24             	mov    %eax,(%esp)
80105c94:	e8 b7 c9 ff ff       	call   80102650 <dirlink>
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	79 0d                	jns    80105caa <sys_link+0x11f>
    iunlockput(dp);
80105c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 35 c3 ff ff       	call   80101fdd <iunlockput>
    goto bad;
80105ca8:	eb 22                	jmp    80105ccc <sys_link+0x141>
  }
  iunlockput(dp);
80105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cad:	89 04 24             	mov    %eax,(%esp)
80105cb0:	e8 28 c3 ff ff       	call   80101fdd <iunlockput>
  iput(ip);
80105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb8:	89 04 24             	mov    %eax,(%esp)
80105cbb:	e8 6c c2 ff ff       	call   80101f2c <iput>

  end_op();
80105cc0:	e8 94 dc ff ff       	call   80103959 <end_op>

  return 0;
80105cc5:	b8 00 00 00 00       	mov    $0x0,%eax
80105cca:	eb 3a                	jmp    80105d06 <sys_link+0x17b>

bad:
  ilock(ip);
80105ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccf:	89 04 24             	mov    %eax,(%esp)
80105cd2:	e8 07 c1 ff ff       	call   80101dde <ilock>
  ip->nlink--;
80105cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cda:	66 8b 40 56          	mov    0x56(%eax),%ax
80105cde:	48                   	dec    %eax
80105cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ce2:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce9:	89 04 24             	mov    %eax,(%esp)
80105cec:	e8 2a bf ff ff       	call   80101c1b <iupdate>
  iunlockput(ip);
80105cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf4:	89 04 24             	mov    %eax,(%esp)
80105cf7:	e8 e1 c2 ff ff       	call   80101fdd <iunlockput>
  end_op();
80105cfc:	e8 58 dc ff ff       	call   80103959 <end_op>
  return -1;
80105d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d06:	c9                   	leave  
80105d07:	c3                   	ret    

80105d08 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105d08:	55                   	push   %ebp
80105d09:	89 e5                	mov    %esp,%ebp
80105d0b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d0e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105d15:	eb 4a                	jmp    80105d61 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105d21:	00 
80105d22:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d29:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80105d30:	89 04 24             	mov    %eax,(%esp)
80105d33:	e8 3d c5 ff ff       	call   80102275 <readi>
80105d38:	83 f8 10             	cmp    $0x10,%eax
80105d3b:	74 0c                	je     80105d49 <isdirempty+0x41>
      panic("isdirempty: readi");
80105d3d:	c7 04 24 44 8a 10 80 	movl   $0x80108a44,(%esp)
80105d44:	e8 0b a8 ff ff       	call   80100554 <panic>
    if(de.inum != 0)
80105d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d4c:	66 85 c0             	test   %ax,%ax
80105d4f:	74 07                	je     80105d58 <isdirempty+0x50>
      return 0;
80105d51:	b8 00 00 00 00       	mov    $0x0,%eax
80105d56:	eb 1b                	jmp    80105d73 <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5b:	83 c0 10             	add    $0x10,%eax
80105d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d64:	8b 45 08             	mov    0x8(%ebp),%eax
80105d67:	8b 40 58             	mov    0x58(%eax),%eax
80105d6a:	39 c2                	cmp    %eax,%edx
80105d6c:	72 a9                	jb     80105d17 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105d6e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d7b:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d89:	e8 7e fa ff ff       	call   8010580c <argstr>
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	79 0a                	jns    80105d9c <sys_unlink+0x27>
    return -1;
80105d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d97:	e9 a9 01 00 00       	jmp    80105f45 <sys_unlink+0x1d0>

  begin_op();
80105d9c:	e8 36 db ff ff       	call   801038d7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105da4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105da7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105dab:	89 04 24             	mov    %eax,(%esp)
80105dae:	e8 72 cb ff ff       	call   80102925 <nameiparent>
80105db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dba:	75 0f                	jne    80105dcb <sys_unlink+0x56>
    end_op();
80105dbc:	e8 98 db ff ff       	call   80103959 <end_op>
    return -1;
80105dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc6:	e9 7a 01 00 00       	jmp    80105f45 <sys_unlink+0x1d0>
  }

  ilock(dp);
80105dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dce:	89 04 24             	mov    %eax,(%esp)
80105dd1:	e8 08 c0 ff ff       	call   80101dde <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105dd6:	c7 44 24 04 56 8a 10 	movl   $0x80108a56,0x4(%esp)
80105ddd:	80 
80105dde:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105de1:	89 04 24             	mov    %eax,(%esp)
80105de4:	e8 7f c7 ff ff       	call   80102568 <namecmp>
80105de9:	85 c0                	test   %eax,%eax
80105deb:	0f 84 3f 01 00 00    	je     80105f30 <sys_unlink+0x1bb>
80105df1:	c7 44 24 04 58 8a 10 	movl   $0x80108a58,0x4(%esp)
80105df8:	80 
80105df9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105dfc:	89 04 24             	mov    %eax,(%esp)
80105dff:	e8 64 c7 ff ff       	call   80102568 <namecmp>
80105e04:	85 c0                	test   %eax,%eax
80105e06:	0f 84 24 01 00 00    	je     80105f30 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105e0c:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105e0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e13:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1d:	89 04 24             	mov    %eax,(%esp)
80105e20:	e8 65 c7 ff ff       	call   8010258a <dirlookup>
80105e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e2c:	75 05                	jne    80105e33 <sys_unlink+0xbe>
    goto bad;
80105e2e:	e9 fd 00 00 00       	jmp    80105f30 <sys_unlink+0x1bb>
  ilock(ip);
80105e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e36:	89 04 24             	mov    %eax,(%esp)
80105e39:	e8 a0 bf ff ff       	call   80101dde <ilock>

  if(ip->nlink < 1)
80105e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e41:	66 8b 40 56          	mov    0x56(%eax),%ax
80105e45:	66 85 c0             	test   %ax,%ax
80105e48:	7f 0c                	jg     80105e56 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105e4a:	c7 04 24 5b 8a 10 80 	movl   $0x80108a5b,(%esp)
80105e51:	e8 fe a6 ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e59:	8b 40 50             	mov    0x50(%eax),%eax
80105e5c:	66 83 f8 01          	cmp    $0x1,%ax
80105e60:	75 1f                	jne    80105e81 <sys_unlink+0x10c>
80105e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e65:	89 04 24             	mov    %eax,(%esp)
80105e68:	e8 9b fe ff ff       	call   80105d08 <isdirempty>
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	75 10                	jne    80105e81 <sys_unlink+0x10c>
    iunlockput(ip);
80105e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e74:	89 04 24             	mov    %eax,(%esp)
80105e77:	e8 61 c1 ff ff       	call   80101fdd <iunlockput>
    goto bad;
80105e7c:	e9 af 00 00 00       	jmp    80105f30 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105e81:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105e88:	00 
80105e89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e90:	00 
80105e91:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e94:	89 04 24             	mov    %eax,(%esp)
80105e97:	e8 a6 f5 ff ff       	call   80105442 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105e9f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ea6:	00 
80105ea7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eab:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105eae:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb5:	89 04 24             	mov    %eax,(%esp)
80105eb8:	e8 1c c5 ff ff       	call   801023d9 <writei>
80105ebd:	83 f8 10             	cmp    $0x10,%eax
80105ec0:	74 0c                	je     80105ece <sys_unlink+0x159>
    panic("unlink: writei");
80105ec2:	c7 04 24 6d 8a 10 80 	movl   $0x80108a6d,(%esp)
80105ec9:	e8 86 a6 ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed1:	8b 40 50             	mov    0x50(%eax),%eax
80105ed4:	66 83 f8 01          	cmp    $0x1,%ax
80105ed8:	75 1a                	jne    80105ef4 <sys_unlink+0x17f>
    dp->nlink--;
80105eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edd:	66 8b 40 56          	mov    0x56(%eax),%ax
80105ee1:	48                   	dec    %eax
80105ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ee5:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eec:	89 04 24             	mov    %eax,(%esp)
80105eef:	e8 27 bd ff ff       	call   80101c1b <iupdate>
  }
  iunlockput(dp);
80105ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef7:	89 04 24             	mov    %eax,(%esp)
80105efa:	e8 de c0 ff ff       	call   80101fdd <iunlockput>

  ip->nlink--;
80105eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f02:	66 8b 40 56          	mov    0x56(%eax),%ax
80105f06:	48                   	dec    %eax
80105f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f0a:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f11:	89 04 24             	mov    %eax,(%esp)
80105f14:	e8 02 bd ff ff       	call   80101c1b <iupdate>
  iunlockput(ip);
80105f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1c:	89 04 24             	mov    %eax,(%esp)
80105f1f:	e8 b9 c0 ff ff       	call   80101fdd <iunlockput>

  end_op();
80105f24:	e8 30 da ff ff       	call   80103959 <end_op>

  return 0;
80105f29:	b8 00 00 00 00       	mov    $0x0,%eax
80105f2e:	eb 15                	jmp    80105f45 <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f33:	89 04 24             	mov    %eax,(%esp)
80105f36:	e8 a2 c0 ff ff       	call   80101fdd <iunlockput>
  end_op();
80105f3b:	e8 19 da ff ff       	call   80103959 <end_op>
  return -1;
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    

80105f47 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105f47:	55                   	push   %ebp
80105f48:	89 e5                	mov    %esp,%ebp
80105f4a:	83 ec 48             	sub    $0x48,%esp
80105f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105f50:	8b 55 10             	mov    0x10(%ebp),%edx
80105f53:	8b 45 14             	mov    0x14(%ebp),%eax
80105f56:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105f5a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105f5e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f62:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f69:	8b 45 08             	mov    0x8(%ebp),%eax
80105f6c:	89 04 24             	mov    %eax,(%esp)
80105f6f:	e8 b1 c9 ff ff       	call   80102925 <nameiparent>
80105f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f7b:	75 0a                	jne    80105f87 <create+0x40>
    return 0;
80105f7d:	b8 00 00 00 00       	mov    $0x0,%eax
80105f82:	e9 79 01 00 00       	jmp    80106100 <create+0x1b9>
  ilock(dp);
80105f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8a:	89 04 24             	mov    %eax,(%esp)
80105f8d:	e8 4c be ff ff       	call   80101dde <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f95:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f99:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa3:	89 04 24             	mov    %eax,(%esp)
80105fa6:	e8 df c5 ff ff       	call   8010258a <dirlookup>
80105fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fb2:	74 46                	je     80105ffa <create+0xb3>
    iunlockput(dp);
80105fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb7:	89 04 24             	mov    %eax,(%esp)
80105fba:	e8 1e c0 ff ff       	call   80101fdd <iunlockput>
    ilock(ip);
80105fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc2:	89 04 24             	mov    %eax,(%esp)
80105fc5:	e8 14 be ff ff       	call   80101dde <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105fca:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105fcf:	75 14                	jne    80105fe5 <create+0x9e>
80105fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd4:	8b 40 50             	mov    0x50(%eax),%eax
80105fd7:	66 83 f8 02          	cmp    $0x2,%ax
80105fdb:	75 08                	jne    80105fe5 <create+0x9e>
      return ip;
80105fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe0:	e9 1b 01 00 00       	jmp    80106100 <create+0x1b9>
    iunlockput(ip);
80105fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe8:	89 04 24             	mov    %eax,(%esp)
80105feb:	e8 ed bf ff ff       	call   80101fdd <iunlockput>
    return 0;
80105ff0:	b8 00 00 00 00       	mov    $0x0,%eax
80105ff5:	e9 06 01 00 00       	jmp    80106100 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ffa:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106001:	8b 00                	mov    (%eax),%eax
80106003:	89 54 24 04          	mov    %edx,0x4(%esp)
80106007:	89 04 24             	mov    %eax,(%esp)
8010600a:	e8 3a bb ff ff       	call   80101b49 <ialloc>
8010600f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106016:	75 0c                	jne    80106024 <create+0xdd>
    panic("create: ialloc");
80106018:	c7 04 24 7c 8a 10 80 	movl   $0x80108a7c,(%esp)
8010601f:	e8 30 a5 ff ff       	call   80100554 <panic>

  ilock(ip);
80106024:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106027:	89 04 24             	mov    %eax,(%esp)
8010602a:	e8 af bd ff ff       	call   80101dde <ilock>
  ip->major = major;
8010602f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106032:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106035:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80106039:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010603c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010603f:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106046:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604f:	89 04 24             	mov    %eax,(%esp)
80106052:	e8 c4 bb ff ff       	call   80101c1b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106057:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010605c:	75 68                	jne    801060c6 <create+0x17f>
    dp->nlink++;  // for ".."
8010605e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106061:	66 8b 40 56          	mov    0x56(%eax),%ax
80106065:	40                   	inc    %eax
80106066:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106069:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
8010606d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106070:	89 04 24             	mov    %eax,(%esp)
80106073:	e8 a3 bb ff ff       	call   80101c1b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607b:	8b 40 04             	mov    0x4(%eax),%eax
8010607e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106082:	c7 44 24 04 56 8a 10 	movl   $0x80108a56,0x4(%esp)
80106089:	80 
8010608a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608d:	89 04 24             	mov    %eax,(%esp)
80106090:	e8 bb c5 ff ff       	call   80102650 <dirlink>
80106095:	85 c0                	test   %eax,%eax
80106097:	78 21                	js     801060ba <create+0x173>
80106099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609c:	8b 40 04             	mov    0x4(%eax),%eax
8010609f:	89 44 24 08          	mov    %eax,0x8(%esp)
801060a3:	c7 44 24 04 58 8a 10 	movl   $0x80108a58,0x4(%esp)
801060aa:	80 
801060ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ae:	89 04 24             	mov    %eax,(%esp)
801060b1:	e8 9a c5 ff ff       	call   80102650 <dirlink>
801060b6:	85 c0                	test   %eax,%eax
801060b8:	79 0c                	jns    801060c6 <create+0x17f>
      panic("create dots");
801060ba:	c7 04 24 8b 8a 10 80 	movl   $0x80108a8b,(%esp)
801060c1:	e8 8e a4 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801060c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c9:	8b 40 04             	mov    0x4(%eax),%eax
801060cc:	89 44 24 08          	mov    %eax,0x8(%esp)
801060d0:	8d 45 de             	lea    -0x22(%ebp),%eax
801060d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060da:	89 04 24             	mov    %eax,(%esp)
801060dd:	e8 6e c5 ff ff       	call   80102650 <dirlink>
801060e2:	85 c0                	test   %eax,%eax
801060e4:	79 0c                	jns    801060f2 <create+0x1ab>
    panic("create: dirlink");
801060e6:	c7 04 24 97 8a 10 80 	movl   $0x80108a97,(%esp)
801060ed:	e8 62 a4 ff ff       	call   80100554 <panic>

  iunlockput(dp);
801060f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f5:	89 04 24             	mov    %eax,(%esp)
801060f8:	e8 e0 be ff ff       	call   80101fdd <iunlockput>

  return ip;
801060fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106100:	c9                   	leave  
80106101:	c3                   	ret    

80106102 <sys_open>:

int
sys_open(void)
{
80106102:	55                   	push   %ebp
80106103:	89 e5                	mov    %esp,%ebp
80106105:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106108:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010610b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010610f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106116:	e8 f1 f6 ff ff       	call   8010580c <argstr>
8010611b:	85 c0                	test   %eax,%eax
8010611d:	78 17                	js     80106136 <sys_open+0x34>
8010611f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106122:	89 44 24 04          	mov    %eax,0x4(%esp)
80106126:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010612d:	e8 43 f6 ff ff       	call   80105775 <argint>
80106132:	85 c0                	test   %eax,%eax
80106134:	79 0a                	jns    80106140 <sys_open+0x3e>
    return -1;
80106136:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010613b:	e9 5b 01 00 00       	jmp    8010629b <sys_open+0x199>

  begin_op();
80106140:	e8 92 d7 ff ff       	call   801038d7 <begin_op>

  if(omode & O_CREATE){
80106145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106148:	25 00 02 00 00       	and    $0x200,%eax
8010614d:	85 c0                	test   %eax,%eax
8010614f:	74 3b                	je     8010618c <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106151:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106154:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010615b:	00 
8010615c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106163:	00 
80106164:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010616b:	00 
8010616c:	89 04 24             	mov    %eax,(%esp)
8010616f:	e8 d3 fd ff ff       	call   80105f47 <create>
80106174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010617b:	75 6a                	jne    801061e7 <sys_open+0xe5>
      end_op();
8010617d:	e8 d7 d7 ff ff       	call   80103959 <end_op>
      return -1;
80106182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106187:	e9 0f 01 00 00       	jmp    8010629b <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
8010618c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010618f:	89 04 24             	mov    %eax,(%esp)
80106192:	e8 6c c7 ff ff       	call   80102903 <namei>
80106197:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010619a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010619e:	75 0f                	jne    801061af <sys_open+0xad>
      end_op();
801061a0:	e8 b4 d7 ff ff       	call   80103959 <end_op>
      return -1;
801061a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061aa:	e9 ec 00 00 00       	jmp    8010629b <sys_open+0x199>
    }
    ilock(ip);
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	89 04 24             	mov    %eax,(%esp)
801061b5:	e8 24 bc ff ff       	call   80101dde <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801061ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061bd:	8b 40 50             	mov    0x50(%eax),%eax
801061c0:	66 83 f8 01          	cmp    $0x1,%ax
801061c4:	75 21                	jne    801061e7 <sys_open+0xe5>
801061c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061c9:	85 c0                	test   %eax,%eax
801061cb:	74 1a                	je     801061e7 <sys_open+0xe5>
      iunlockput(ip);
801061cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d0:	89 04 24             	mov    %eax,(%esp)
801061d3:	e8 05 be ff ff       	call   80101fdd <iunlockput>
      end_op();
801061d8:	e8 7c d7 ff ff       	call   80103959 <end_op>
      return -1;
801061dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e2:	e9 b4 00 00 00       	jmp    8010629b <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801061e7:	e8 30 b2 ff ff       	call   8010141c <filealloc>
801061ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061f3:	74 14                	je     80106209 <sys_open+0x107>
801061f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f8:	89 04 24             	mov    %eax,(%esp)
801061fb:	e8 40 f7 ff ff       	call   80105940 <fdalloc>
80106200:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106203:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106207:	79 28                	jns    80106231 <sys_open+0x12f>
    if(f)
80106209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010620d:	74 0b                	je     8010621a <sys_open+0x118>
      fileclose(f);
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	89 04 24             	mov    %eax,(%esp)
80106215:	e8 aa b2 ff ff       	call   801014c4 <fileclose>
    iunlockput(ip);
8010621a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621d:	89 04 24             	mov    %eax,(%esp)
80106220:	e8 b8 bd ff ff       	call   80101fdd <iunlockput>
    end_op();
80106225:	e8 2f d7 ff ff       	call   80103959 <end_op>
    return -1;
8010622a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622f:	eb 6a                	jmp    8010629b <sys_open+0x199>
  }
  iunlock(ip);
80106231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106234:	89 04 24             	mov    %eax,(%esp)
80106237:	e8 ac bc ff ff       	call   80101ee8 <iunlock>
  end_op();
8010623c:	e8 18 d7 ff ff       	call   80103959 <end_op>

  f->type = FD_INODE;
80106241:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106244:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106250:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106253:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106256:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010625d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106260:	83 e0 01             	and    $0x1,%eax
80106263:	85 c0                	test   %eax,%eax
80106265:	0f 94 c0             	sete   %al
80106268:	88 c2                	mov    %al,%dl
8010626a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106273:	83 e0 01             	and    $0x1,%eax
80106276:	85 c0                	test   %eax,%eax
80106278:	75 0a                	jne    80106284 <sys_open+0x182>
8010627a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010627d:	83 e0 02             	and    $0x2,%eax
80106280:	85 c0                	test   %eax,%eax
80106282:	74 07                	je     8010628b <sys_open+0x189>
80106284:	b8 01 00 00 00       	mov    $0x1,%eax
80106289:	eb 05                	jmp    80106290 <sys_open+0x18e>
8010628b:	b8 00 00 00 00       	mov    $0x0,%eax
80106290:	88 c2                	mov    %al,%dl
80106292:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106295:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106298:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010629b:	c9                   	leave  
8010629c:	c3                   	ret    

8010629d <sys_mkdir>:

int
sys_mkdir(void)
{
8010629d:	55                   	push   %ebp
8010629e:	89 e5                	mov    %esp,%ebp
801062a0:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801062a3:	e8 2f d6 ff ff       	call   801038d7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801062a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801062af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062b6:	e8 51 f5 ff ff       	call   8010580c <argstr>
801062bb:	85 c0                	test   %eax,%eax
801062bd:	78 2c                	js     801062eb <sys_mkdir+0x4e>
801062bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801062c9:	00 
801062ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801062d1:	00 
801062d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801062d9:	00 
801062da:	89 04 24             	mov    %eax,(%esp)
801062dd:	e8 65 fc ff ff       	call   80105f47 <create>
801062e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062e9:	75 0c                	jne    801062f7 <sys_mkdir+0x5a>
    end_op();
801062eb:	e8 69 d6 ff ff       	call   80103959 <end_op>
    return -1;
801062f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f5:	eb 15                	jmp    8010630c <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801062f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062fa:	89 04 24             	mov    %eax,(%esp)
801062fd:	e8 db bc ff ff       	call   80101fdd <iunlockput>
  end_op();
80106302:	e8 52 d6 ff ff       	call   80103959 <end_op>
  return 0;
80106307:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010630c:	c9                   	leave  
8010630d:	c3                   	ret    

8010630e <sys_mknod>:

int
sys_mknod(void)
{
8010630e:	55                   	push   %ebp
8010630f:	89 e5                	mov    %esp,%ebp
80106311:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106314:	e8 be d5 ff ff       	call   801038d7 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106319:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010631c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106327:	e8 e0 f4 ff ff       	call   8010580c <argstr>
8010632c:	85 c0                	test   %eax,%eax
8010632e:	78 5e                	js     8010638e <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106330:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106333:	89 44 24 04          	mov    %eax,0x4(%esp)
80106337:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010633e:	e8 32 f4 ff ff       	call   80105775 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80106343:	85 c0                	test   %eax,%eax
80106345:	78 47                	js     8010638e <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106347:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010634a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010634e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106355:	e8 1b f4 ff ff       	call   80105775 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010635a:	85 c0                	test   %eax,%eax
8010635c:	78 30                	js     8010638e <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010635e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106361:	0f bf c8             	movswl %ax,%ecx
80106364:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106367:	0f bf d0             	movswl %ax,%edx
8010636a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010636d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106371:	89 54 24 08          	mov    %edx,0x8(%esp)
80106375:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010637c:	00 
8010637d:	89 04 24             	mov    %eax,(%esp)
80106380:	e8 c2 fb ff ff       	call   80105f47 <create>
80106385:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010638c:	75 0c                	jne    8010639a <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010638e:	e8 c6 d5 ff ff       	call   80103959 <end_op>
    return -1;
80106393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106398:	eb 15                	jmp    801063af <sys_mknod+0xa1>
  }
  iunlockput(ip);
8010639a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639d:	89 04 24             	mov    %eax,(%esp)
801063a0:	e8 38 bc ff ff       	call   80101fdd <iunlockput>
  end_op();
801063a5:	e8 af d5 ff ff       	call   80103959 <end_op>
  return 0;
801063aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063af:	c9                   	leave  
801063b0:	c3                   	ret    

801063b1 <sys_chdir>:

int
sys_chdir(void)
{
801063b1:	55                   	push   %ebp
801063b2:	89 e5                	mov    %esp,%ebp
801063b4:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801063b7:	e8 13 e2 ff ff       	call   801045cf <myproc>
801063bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801063bf:	e8 13 d5 ff ff       	call   801038d7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801063c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801063cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063d2:	e8 35 f4 ff ff       	call   8010580c <argstr>
801063d7:	85 c0                	test   %eax,%eax
801063d9:	78 14                	js     801063ef <sys_chdir+0x3e>
801063db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063de:	89 04 24             	mov    %eax,(%esp)
801063e1:	e8 1d c5 ff ff       	call   80102903 <namei>
801063e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063ed:	75 0c                	jne    801063fb <sys_chdir+0x4a>
    end_op();
801063ef:	e8 65 d5 ff ff       	call   80103959 <end_op>
    return -1;
801063f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f9:	eb 5a                	jmp    80106455 <sys_chdir+0xa4>
  }
  ilock(ip);
801063fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fe:	89 04 24             	mov    %eax,(%esp)
80106401:	e8 d8 b9 ff ff       	call   80101dde <ilock>
  if(ip->type != T_DIR){
80106406:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106409:	8b 40 50             	mov    0x50(%eax),%eax
8010640c:	66 83 f8 01          	cmp    $0x1,%ax
80106410:	74 17                	je     80106429 <sys_chdir+0x78>
    iunlockput(ip);
80106412:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106415:	89 04 24             	mov    %eax,(%esp)
80106418:	e8 c0 bb ff ff       	call   80101fdd <iunlockput>
    end_op();
8010641d:	e8 37 d5 ff ff       	call   80103959 <end_op>
    return -1;
80106422:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106427:	eb 2c                	jmp    80106455 <sys_chdir+0xa4>
  }
  iunlock(ip);
80106429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642c:	89 04 24             	mov    %eax,(%esp)
8010642f:	e8 b4 ba ff ff       	call   80101ee8 <iunlock>
  iput(curproc->cwd);
80106434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106437:	8b 40 68             	mov    0x68(%eax),%eax
8010643a:	89 04 24             	mov    %eax,(%esp)
8010643d:	e8 ea ba ff ff       	call   80101f2c <iput>
  end_op();
80106442:	e8 12 d5 ff ff       	call   80103959 <end_op>
  curproc->cwd = ip;
80106447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010644d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106450:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106455:	c9                   	leave  
80106456:	c3                   	ret    

80106457 <sys_exec>:

int
sys_exec(void)
{
80106457:	55                   	push   %ebp
80106458:	89 e5                	mov    %esp,%ebp
8010645a:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106463:	89 44 24 04          	mov    %eax,0x4(%esp)
80106467:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010646e:	e8 99 f3 ff ff       	call   8010580c <argstr>
80106473:	85 c0                	test   %eax,%eax
80106475:	78 1a                	js     80106491 <sys_exec+0x3a>
80106477:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010647d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106488:	e8 e8 f2 ff ff       	call   80105775 <argint>
8010648d:	85 c0                	test   %eax,%eax
8010648f:	79 0a                	jns    8010649b <sys_exec+0x44>
    return -1;
80106491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106496:	e9 c7 00 00 00       	jmp    80106562 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
8010649b:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801064a2:	00 
801064a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801064aa:	00 
801064ab:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064b1:	89 04 24             	mov    %eax,(%esp)
801064b4:	e8 89 ef ff ff       	call   80105442 <memset>
  for(i=0;; i++){
801064b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801064c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c3:	83 f8 1f             	cmp    $0x1f,%eax
801064c6:	76 0a                	jbe    801064d2 <sys_exec+0x7b>
      return -1;
801064c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cd:	e9 90 00 00 00       	jmp    80106562 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801064d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d5:	c1 e0 02             	shl    $0x2,%eax
801064d8:	89 c2                	mov    %eax,%edx
801064da:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801064e0:	01 c2                	add    %eax,%edx
801064e2:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801064e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ec:	89 14 24             	mov    %edx,(%esp)
801064ef:	e8 e0 f1 ff ff       	call   801056d4 <fetchint>
801064f4:	85 c0                	test   %eax,%eax
801064f6:	79 07                	jns    801064ff <sys_exec+0xa8>
      return -1;
801064f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fd:	eb 63                	jmp    80106562 <sys_exec+0x10b>
    if(uarg == 0){
801064ff:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106505:	85 c0                	test   %eax,%eax
80106507:	75 26                	jne    8010652f <sys_exec+0xd8>
      argv[i] = 0;
80106509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650c:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106513:	00 00 00 00 
      break;
80106517:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010651b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106521:	89 54 24 04          	mov    %edx,0x4(%esp)
80106525:	89 04 24             	mov    %eax,(%esp)
80106528:	e8 93 aa ff ff       	call   80100fc0 <exec>
8010652d:	eb 33                	jmp    80106562 <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010652f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106535:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106538:	c1 e2 02             	shl    $0x2,%edx
8010653b:	01 c2                	add    %eax,%edx
8010653d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106543:	89 54 24 04          	mov    %edx,0x4(%esp)
80106547:	89 04 24             	mov    %eax,(%esp)
8010654a:	e8 c4 f1 ff ff       	call   80105713 <fetchstr>
8010654f:	85 c0                	test   %eax,%eax
80106551:	79 07                	jns    8010655a <sys_exec+0x103>
      return -1;
80106553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106558:	eb 08                	jmp    80106562 <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010655a:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010655d:	e9 5e ff ff ff       	jmp    801064c0 <sys_exec+0x69>
  return exec(path, argv);
}
80106562:	c9                   	leave  
80106563:	c3                   	ret    

80106564 <sys_pipe>:

int
sys_pipe(void)
{
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010656a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106571:	00 
80106572:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106575:	89 44 24 04          	mov    %eax,0x4(%esp)
80106579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106580:	e8 1d f2 ff ff       	call   801057a2 <argptr>
80106585:	85 c0                	test   %eax,%eax
80106587:	79 0a                	jns    80106593 <sys_pipe+0x2f>
    return -1;
80106589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658e:	e9 9a 00 00 00       	jmp    8010662d <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
80106593:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106596:	89 44 24 04          	mov    %eax,0x4(%esp)
8010659a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010659d:	89 04 24             	mov    %eax,(%esp)
801065a0:	e8 7f db ff ff       	call   80104124 <pipealloc>
801065a5:	85 c0                	test   %eax,%eax
801065a7:	79 07                	jns    801065b0 <sys_pipe+0x4c>
    return -1;
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ae:	eb 7d                	jmp    8010662d <sys_pipe+0xc9>
  fd0 = -1;
801065b0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801065b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065ba:	89 04 24             	mov    %eax,(%esp)
801065bd:	e8 7e f3 ff ff       	call   80105940 <fdalloc>
801065c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065c9:	78 14                	js     801065df <sys_pipe+0x7b>
801065cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ce:	89 04 24             	mov    %eax,(%esp)
801065d1:	e8 6a f3 ff ff       	call   80105940 <fdalloc>
801065d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065dd:	79 36                	jns    80106615 <sys_pipe+0xb1>
    if(fd0 >= 0)
801065df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065e3:	78 13                	js     801065f8 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801065e5:	e8 e5 df ff ff       	call   801045cf <myproc>
801065ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065ed:	83 c2 08             	add    $0x8,%edx
801065f0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801065f7:	00 
    fileclose(rf);
801065f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065fb:	89 04 24             	mov    %eax,(%esp)
801065fe:	e8 c1 ae ff ff       	call   801014c4 <fileclose>
    fileclose(wf);
80106603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106606:	89 04 24             	mov    %eax,(%esp)
80106609:	e8 b6 ae ff ff       	call   801014c4 <fileclose>
    return -1;
8010660e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106613:	eb 18                	jmp    8010662d <sys_pipe+0xc9>
  }
  fd[0] = fd0;
80106615:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106618:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010661b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010661d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106620:	8d 50 04             	lea    0x4(%eax),%edx
80106623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106626:	89 02                	mov    %eax,(%edx)
  return 0;
80106628:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010662d:	c9                   	leave  
8010662e:	c3                   	ret    
	...

80106630 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106636:	e8 90 e2 ff ff       	call   801048cb <fork>
}
8010663b:	c9                   	leave  
8010663c:	c3                   	ret    

8010663d <sys_exit>:

int
sys_exit(void)
{
8010663d:	55                   	push   %ebp
8010663e:	89 e5                	mov    %esp,%ebp
80106640:	83 ec 08             	sub    $0x8,%esp
  exit();
80106643:	e8 e9 e3 ff ff       	call   80104a31 <exit>
  return 0;  // not reached
80106648:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010664d:	c9                   	leave  
8010664e:	c3                   	ret    

8010664f <sys_wait>:

int
sys_wait(void)
{
8010664f:	55                   	push   %ebp
80106650:	89 e5                	mov    %esp,%ebp
80106652:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106655:	e8 e0 e4 ff ff       	call   80104b3a <wait>
}
8010665a:	c9                   	leave  
8010665b:	c3                   	ret    

8010665c <sys_kill>:

int
sys_kill(void)
{
8010665c:	55                   	push   %ebp
8010665d:	89 e5                	mov    %esp,%ebp
8010665f:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106662:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106665:	89 44 24 04          	mov    %eax,0x4(%esp)
80106669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106670:	e8 00 f1 ff ff       	call   80105775 <argint>
80106675:	85 c0                	test   %eax,%eax
80106677:	79 07                	jns    80106680 <sys_kill+0x24>
    return -1;
80106679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667e:	eb 0b                	jmp    8010668b <sys_kill+0x2f>
  return kill(pid);
80106680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106683:	89 04 24             	mov    %eax,(%esp)
80106686:	e8 84 e8 ff ff       	call   80104f0f <kill>
}
8010668b:	c9                   	leave  
8010668c:	c3                   	ret    

8010668d <sys_getpid>:

int
sys_getpid(void)
{
8010668d:	55                   	push   %ebp
8010668e:	89 e5                	mov    %esp,%ebp
80106690:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106693:	e8 37 df ff ff       	call   801045cf <myproc>
80106698:	8b 40 10             	mov    0x10(%eax),%eax
}
8010669b:	c9                   	leave  
8010669c:	c3                   	ret    

8010669d <sys_sbrk>:

int
sys_sbrk(void)
{
8010669d:	55                   	push   %ebp
8010669e:	89 e5                	mov    %esp,%ebp
801066a0:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801066aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066b1:	e8 bf f0 ff ff       	call   80105775 <argint>
801066b6:	85 c0                	test   %eax,%eax
801066b8:	79 07                	jns    801066c1 <sys_sbrk+0x24>
    return -1;
801066ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066bf:	eb 23                	jmp    801066e4 <sys_sbrk+0x47>
  addr = myproc()->sz;
801066c1:	e8 09 df ff ff       	call   801045cf <myproc>
801066c6:	8b 00                	mov    (%eax),%eax
801066c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801066cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ce:	89 04 24             	mov    %eax,(%esp)
801066d1:	e8 57 e1 ff ff       	call   8010482d <growproc>
801066d6:	85 c0                	test   %eax,%eax
801066d8:	79 07                	jns    801066e1 <sys_sbrk+0x44>
    return -1;
801066da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066df:	eb 03                	jmp    801066e4 <sys_sbrk+0x47>
  return addr;
801066e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066e4:	c9                   	leave  
801066e5:	c3                   	ret    

801066e6 <sys_sleep>:

int
sys_sleep(void)
{
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
801066e9:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801066f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066fa:	e8 76 f0 ff ff       	call   80105775 <argint>
801066ff:	85 c0                	test   %eax,%eax
80106701:	79 07                	jns    8010670a <sys_sleep+0x24>
    return -1;
80106703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106708:	eb 6b                	jmp    80106775 <sys_sleep+0x8f>
  acquire(&tickslock);
8010670a:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106711:	e8 c9 ea ff ff       	call   801051df <acquire>
  ticks0 = ticks;
80106716:	a1 c0 66 11 80       	mov    0x801166c0,%eax
8010671b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010671e:	eb 33                	jmp    80106753 <sys_sleep+0x6d>
    if(myproc()->killed){
80106720:	e8 aa de ff ff       	call   801045cf <myproc>
80106725:	8b 40 24             	mov    0x24(%eax),%eax
80106728:	85 c0                	test   %eax,%eax
8010672a:	74 13                	je     8010673f <sys_sleep+0x59>
      release(&tickslock);
8010672c:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106733:	e8 11 eb ff ff       	call   80105249 <release>
      return -1;
80106738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673d:	eb 36                	jmp    80106775 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
8010673f:	c7 44 24 04 80 5e 11 	movl   $0x80115e80,0x4(%esp)
80106746:	80 
80106747:	c7 04 24 c0 66 11 80 	movl   $0x801166c0,(%esp)
8010674e:	e8 bd e6 ff ff       	call   80104e10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106753:	a1 c0 66 11 80       	mov    0x801166c0,%eax
80106758:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010675b:	89 c2                	mov    %eax,%edx
8010675d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106760:	39 c2                	cmp    %eax,%edx
80106762:	72 bc                	jb     80106720 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106764:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
8010676b:	e8 d9 ea ff ff       	call   80105249 <release>
  return 0;
80106770:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106775:	c9                   	leave  
80106776:	c3                   	ret    

80106777 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106777:	55                   	push   %ebp
80106778:	89 e5                	mov    %esp,%ebp
8010677a:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
8010677d:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106784:	e8 56 ea ff ff       	call   801051df <acquire>
  xticks = ticks;
80106789:	a1 c0 66 11 80       	mov    0x801166c0,%eax
8010678e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106791:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106798:	e8 ac ea ff ff       	call   80105249 <release>
  return xticks;
8010679d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067a0:	c9                   	leave  
801067a1:	c3                   	ret    
	...

801067a4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067a4:	1e                   	push   %ds
  pushl %es
801067a5:	06                   	push   %es
  pushl %fs
801067a6:	0f a0                	push   %fs
  pushl %gs
801067a8:	0f a8                	push   %gs
  pushal
801067aa:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067ab:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067af:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067b1:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067b3:	54                   	push   %esp
  call trap
801067b4:	e8 c0 01 00 00       	call   80106979 <trap>
  addl $4, %esp
801067b9:	83 c4 04             	add    $0x4,%esp

801067bc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067bc:	61                   	popa   
  popl %gs
801067bd:	0f a9                	pop    %gs
  popl %fs
801067bf:	0f a1                	pop    %fs
  popl %es
801067c1:	07                   	pop    %es
  popl %ds
801067c2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067c3:	83 c4 08             	add    $0x8,%esp
  iret
801067c6:	cf                   	iret   
	...

801067c8 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801067c8:	55                   	push   %ebp
801067c9:	89 e5                	mov    %esp,%ebp
801067cb:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801067ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d1:	48                   	dec    %eax
801067d2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801067d6:	8b 45 08             	mov    0x8(%ebp),%eax
801067d9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067dd:	8b 45 08             	mov    0x8(%ebp),%eax
801067e0:	c1 e8 10             	shr    $0x10,%eax
801067e3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801067e7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801067ea:	0f 01 18             	lidtl  (%eax)
}
801067ed:	c9                   	leave  
801067ee:	c3                   	ret    

801067ef <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801067ef:	55                   	push   %ebp
801067f0:	89 e5                	mov    %esp,%ebp
801067f2:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801067f5:	0f 20 d0             	mov    %cr2,%eax
801067f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801067fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067fe:	c9                   	leave  
801067ff:	c3                   	ret    

80106800 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010680d:	e9 b8 00 00 00       	jmp    801068ca <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106815:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
8010681c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010681f:	66 89 04 d5 c0 5e 11 	mov    %ax,-0x7feea140(,%edx,8)
80106826:	80 
80106827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010682a:	66 c7 04 c5 c2 5e 11 	movw   $0x8,-0x7feea13e(,%eax,8)
80106831:	80 08 00 
80106834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106837:	8a 14 c5 c4 5e 11 80 	mov    -0x7feea13c(,%eax,8),%dl
8010683e:	83 e2 e0             	and    $0xffffffe0,%edx
80106841:	88 14 c5 c4 5e 11 80 	mov    %dl,-0x7feea13c(,%eax,8)
80106848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684b:	8a 14 c5 c4 5e 11 80 	mov    -0x7feea13c(,%eax,8),%dl
80106852:	83 e2 1f             	and    $0x1f,%edx
80106855:	88 14 c5 c4 5e 11 80 	mov    %dl,-0x7feea13c(,%eax,8)
8010685c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010685f:	8a 14 c5 c5 5e 11 80 	mov    -0x7feea13b(,%eax,8),%dl
80106866:	83 e2 f0             	and    $0xfffffff0,%edx
80106869:	83 ca 0e             	or     $0xe,%edx
8010686c:	88 14 c5 c5 5e 11 80 	mov    %dl,-0x7feea13b(,%eax,8)
80106873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106876:	8a 14 c5 c5 5e 11 80 	mov    -0x7feea13b(,%eax,8),%dl
8010687d:	83 e2 ef             	and    $0xffffffef,%edx
80106880:	88 14 c5 c5 5e 11 80 	mov    %dl,-0x7feea13b(,%eax,8)
80106887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010688a:	8a 14 c5 c5 5e 11 80 	mov    -0x7feea13b(,%eax,8),%dl
80106891:	83 e2 9f             	and    $0xffffff9f,%edx
80106894:	88 14 c5 c5 5e 11 80 	mov    %dl,-0x7feea13b(,%eax,8)
8010689b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689e:	8a 14 c5 c5 5e 11 80 	mov    -0x7feea13b(,%eax,8),%dl
801068a5:	83 ca 80             	or     $0xffffff80,%edx
801068a8:	88 14 c5 c5 5e 11 80 	mov    %dl,-0x7feea13b(,%eax,8)
801068af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b2:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
801068b9:	c1 e8 10             	shr    $0x10,%eax
801068bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068bf:	66 89 04 d5 c6 5e 11 	mov    %ax,-0x7feea13a(,%edx,8)
801068c6:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801068c7:	ff 45 f4             	incl   -0xc(%ebp)
801068ca:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801068d1:	0f 8e 3b ff ff ff    	jle    80106812 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801068d7:	a1 78 b1 10 80       	mov    0x8010b178,%eax
801068dc:	66 a3 c0 60 11 80    	mov    %ax,0x801160c0
801068e2:	66 c7 05 c2 60 11 80 	movw   $0x8,0x801160c2
801068e9:	08 00 
801068eb:	a0 c4 60 11 80       	mov    0x801160c4,%al
801068f0:	83 e0 e0             	and    $0xffffffe0,%eax
801068f3:	a2 c4 60 11 80       	mov    %al,0x801160c4
801068f8:	a0 c4 60 11 80       	mov    0x801160c4,%al
801068fd:	83 e0 1f             	and    $0x1f,%eax
80106900:	a2 c4 60 11 80       	mov    %al,0x801160c4
80106905:	a0 c5 60 11 80       	mov    0x801160c5,%al
8010690a:	83 c8 0f             	or     $0xf,%eax
8010690d:	a2 c5 60 11 80       	mov    %al,0x801160c5
80106912:	a0 c5 60 11 80       	mov    0x801160c5,%al
80106917:	83 e0 ef             	and    $0xffffffef,%eax
8010691a:	a2 c5 60 11 80       	mov    %al,0x801160c5
8010691f:	a0 c5 60 11 80       	mov    0x801160c5,%al
80106924:	83 c8 60             	or     $0x60,%eax
80106927:	a2 c5 60 11 80       	mov    %al,0x801160c5
8010692c:	a0 c5 60 11 80       	mov    0x801160c5,%al
80106931:	83 c8 80             	or     $0xffffff80,%eax
80106934:	a2 c5 60 11 80       	mov    %al,0x801160c5
80106939:	a1 78 b1 10 80       	mov    0x8010b178,%eax
8010693e:	c1 e8 10             	shr    $0x10,%eax
80106941:	66 a3 c6 60 11 80    	mov    %ax,0x801160c6

  initlock(&tickslock, "time");
80106947:	c7 44 24 04 a8 8a 10 	movl   $0x80108aa8,0x4(%esp)
8010694e:	80 
8010694f:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106956:	e8 63 e8 ff ff       	call   801051be <initlock>
}
8010695b:	c9                   	leave  
8010695c:	c3                   	ret    

8010695d <idtinit>:

void
idtinit(void)
{
8010695d:	55                   	push   %ebp
8010695e:	89 e5                	mov    %esp,%ebp
80106960:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106963:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010696a:	00 
8010696b:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80106972:	e8 51 fe ff ff       	call   801067c8 <lidt>
}
80106977:	c9                   	leave  
80106978:	c3                   	ret    

80106979 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106979:	55                   	push   %ebp
8010697a:	89 e5                	mov    %esp,%ebp
8010697c:	57                   	push   %edi
8010697d:	56                   	push   %esi
8010697e:	53                   	push   %ebx
8010697f:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106982:	8b 45 08             	mov    0x8(%ebp),%eax
80106985:	8b 40 30             	mov    0x30(%eax),%eax
80106988:	83 f8 40             	cmp    $0x40,%eax
8010698b:	75 3c                	jne    801069c9 <trap+0x50>
    if(myproc()->killed)
8010698d:	e8 3d dc ff ff       	call   801045cf <myproc>
80106992:	8b 40 24             	mov    0x24(%eax),%eax
80106995:	85 c0                	test   %eax,%eax
80106997:	74 05                	je     8010699e <trap+0x25>
      exit();
80106999:	e8 93 e0 ff ff       	call   80104a31 <exit>
    myproc()->tf = tf;
8010699e:	e8 2c dc ff ff       	call   801045cf <myproc>
801069a3:	8b 55 08             	mov    0x8(%ebp),%edx
801069a6:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801069a9:	e8 95 ee ff ff       	call   80105843 <syscall>
    if(myproc()->killed)
801069ae:	e8 1c dc ff ff       	call   801045cf <myproc>
801069b3:	8b 40 24             	mov    0x24(%eax),%eax
801069b6:	85 c0                	test   %eax,%eax
801069b8:	74 0a                	je     801069c4 <trap+0x4b>
      exit();
801069ba:	e8 72 e0 ff ff       	call   80104a31 <exit>
    return;
801069bf:	e9 13 02 00 00       	jmp    80106bd7 <trap+0x25e>
801069c4:	e9 0e 02 00 00       	jmp    80106bd7 <trap+0x25e>
  }

  switch(tf->trapno){
801069c9:	8b 45 08             	mov    0x8(%ebp),%eax
801069cc:	8b 40 30             	mov    0x30(%eax),%eax
801069cf:	83 e8 20             	sub    $0x20,%eax
801069d2:	83 f8 1f             	cmp    $0x1f,%eax
801069d5:	0f 87 ae 00 00 00    	ja     80106a89 <trap+0x110>
801069db:	8b 04 85 50 8b 10 80 	mov    -0x7fef74b0(,%eax,4),%eax
801069e2:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801069e4:	e8 1d db ff ff       	call   80104506 <cpuid>
801069e9:	85 c0                	test   %eax,%eax
801069eb:	75 2f                	jne    80106a1c <trap+0xa3>
      acquire(&tickslock);
801069ed:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
801069f4:	e8 e6 e7 ff ff       	call   801051df <acquire>
      ticks++;
801069f9:	a1 c0 66 11 80       	mov    0x801166c0,%eax
801069fe:	40                   	inc    %eax
801069ff:	a3 c0 66 11 80       	mov    %eax,0x801166c0
      wakeup(&ticks);
80106a04:	c7 04 24 c0 66 11 80 	movl   $0x801166c0,(%esp)
80106a0b:	e8 d4 e4 ff ff       	call   80104ee4 <wakeup>
      release(&tickslock);
80106a10:	c7 04 24 80 5e 11 80 	movl   $0x80115e80,(%esp)
80106a17:	e8 2d e8 ff ff       	call   80105249 <release>
    }
    lapiceoi();
80106a1c:	e8 8e c9 ff ff       	call   801033af <lapiceoi>
    break;
80106a21:	e9 35 01 00 00       	jmp    80106b5b <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a26:	e8 03 c2 ff ff       	call   80102c2e <ideintr>
    lapiceoi();
80106a2b:	e8 7f c9 ff ff       	call   801033af <lapiceoi>
    break;
80106a30:	e9 26 01 00 00       	jmp    80106b5b <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106a35:	e8 8c c7 ff ff       	call   801031c6 <kbdintr>
    lapiceoi();
80106a3a:	e8 70 c9 ff ff       	call   801033af <lapiceoi>
    break;
80106a3f:	e9 17 01 00 00       	jmp    80106b5b <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106a44:	e8 70 03 00 00       	call   80106db9 <uartintr>
    lapiceoi();
80106a49:	e8 61 c9 ff ff       	call   801033af <lapiceoi>
    break;
80106a4e:	e9 08 01 00 00       	jmp    80106b5b <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a53:	8b 45 08             	mov    0x8(%ebp),%eax
80106a56:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106a59:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5c:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a5f:	0f b7 d8             	movzwl %ax,%ebx
80106a62:	e8 9f da ff ff       	call   80104506 <cpuid>
80106a67:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106a6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a73:	c7 04 24 b0 8a 10 80 	movl   $0x80108ab0,(%esp)
80106a7a:	e8 42 99 ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106a7f:	e8 2b c9 ff ff       	call   801033af <lapiceoi>
    break;
80106a84:	e9 d2 00 00 00       	jmp    80106b5b <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106a89:	e8 41 db ff ff       	call   801045cf <myproc>
80106a8e:	85 c0                	test   %eax,%eax
80106a90:	74 10                	je     80106aa2 <trap+0x129>
80106a92:	8b 45 08             	mov    0x8(%ebp),%eax
80106a95:	8b 40 3c             	mov    0x3c(%eax),%eax
80106a98:	0f b7 c0             	movzwl %ax,%eax
80106a9b:	83 e0 03             	and    $0x3,%eax
80106a9e:	85 c0                	test   %eax,%eax
80106aa0:	75 40                	jne    80106ae2 <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aa2:	e8 48 fd ff ff       	call   801067ef <rcr2>
80106aa7:	89 c3                	mov    %eax,%ebx
80106aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80106aac:	8b 70 38             	mov    0x38(%eax),%esi
80106aaf:	e8 52 da ff ff       	call   80104506 <cpuid>
80106ab4:	8b 55 08             	mov    0x8(%ebp),%edx
80106ab7:	8b 52 30             	mov    0x30(%edx),%edx
80106aba:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106abe:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106ac2:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ac6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aca:	c7 04 24 d4 8a 10 80 	movl   $0x80108ad4,(%esp)
80106ad1:	e8 eb 98 ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106ad6:	c7 04 24 06 8b 10 80 	movl   $0x80108b06,(%esp)
80106add:	e8 72 9a ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ae2:	e8 08 fd ff ff       	call   801067ef <rcr2>
80106ae7:	89 c6                	mov    %eax,%esi
80106ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80106aec:	8b 40 38             	mov    0x38(%eax),%eax
80106aef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106af2:	e8 0f da ff ff       	call   80104506 <cpuid>
80106af7:	89 c3                	mov    %eax,%ebx
80106af9:	8b 45 08             	mov    0x8(%ebp),%eax
80106afc:	8b 78 34             	mov    0x34(%eax),%edi
80106aff:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106b02:	8b 45 08             	mov    0x8(%ebp),%eax
80106b05:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106b08:	e8 c2 da ff ff       	call   801045cf <myproc>
80106b0d:	8d 50 6c             	lea    0x6c(%eax),%edx
80106b10:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106b13:	e8 b7 da ff ff       	call   801045cf <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b18:	8b 40 10             	mov    0x10(%eax),%eax
80106b1b:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106b1f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b22:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106b26:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106b2a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b2d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80106b31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106b35:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b38:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b40:	c7 04 24 0c 8b 10 80 	movl   $0x80108b0c,(%esp)
80106b47:	e8 75 98 ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106b4c:	e8 7e da ff ff       	call   801045cf <myproc>
80106b51:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106b58:	eb 01                	jmp    80106b5b <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106b5a:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b5b:	e8 6f da ff ff       	call   801045cf <myproc>
80106b60:	85 c0                	test   %eax,%eax
80106b62:	74 22                	je     80106b86 <trap+0x20d>
80106b64:	e8 66 da ff ff       	call   801045cf <myproc>
80106b69:	8b 40 24             	mov    0x24(%eax),%eax
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	74 16                	je     80106b86 <trap+0x20d>
80106b70:	8b 45 08             	mov    0x8(%ebp),%eax
80106b73:	8b 40 3c             	mov    0x3c(%eax),%eax
80106b76:	0f b7 c0             	movzwl %ax,%eax
80106b79:	83 e0 03             	and    $0x3,%eax
80106b7c:	83 f8 03             	cmp    $0x3,%eax
80106b7f:	75 05                	jne    80106b86 <trap+0x20d>
    exit();
80106b81:	e8 ab de ff ff       	call   80104a31 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106b86:	e8 44 da ff ff       	call   801045cf <myproc>
80106b8b:	85 c0                	test   %eax,%eax
80106b8d:	74 1d                	je     80106bac <trap+0x233>
80106b8f:	e8 3b da ff ff       	call   801045cf <myproc>
80106b94:	8b 40 0c             	mov    0xc(%eax),%eax
80106b97:	83 f8 04             	cmp    $0x4,%eax
80106b9a:	75 10                	jne    80106bac <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9f:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ba2:	83 f8 20             	cmp    $0x20,%eax
80106ba5:	75 05                	jne    80106bac <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80106ba7:	e8 f4 e1 ff ff       	call   80104da0 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bac:	e8 1e da ff ff       	call   801045cf <myproc>
80106bb1:	85 c0                	test   %eax,%eax
80106bb3:	74 22                	je     80106bd7 <trap+0x25e>
80106bb5:	e8 15 da ff ff       	call   801045cf <myproc>
80106bba:	8b 40 24             	mov    0x24(%eax),%eax
80106bbd:	85 c0                	test   %eax,%eax
80106bbf:	74 16                	je     80106bd7 <trap+0x25e>
80106bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc4:	8b 40 3c             	mov    0x3c(%eax),%eax
80106bc7:	0f b7 c0             	movzwl %ax,%eax
80106bca:	83 e0 03             	and    $0x3,%eax
80106bcd:	83 f8 03             	cmp    $0x3,%eax
80106bd0:	75 05                	jne    80106bd7 <trap+0x25e>
    exit();
80106bd2:	e8 5a de ff ff       	call   80104a31 <exit>
}
80106bd7:	83 c4 3c             	add    $0x3c,%esp
80106bda:	5b                   	pop    %ebx
80106bdb:	5e                   	pop    %esi
80106bdc:	5f                   	pop    %edi
80106bdd:	5d                   	pop    %ebp
80106bde:	c3                   	ret    
	...

80106be0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	83 ec 14             	sub    $0x14,%esp
80106be6:	8b 45 08             	mov    0x8(%ebp),%eax
80106be9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bf0:	89 c2                	mov    %eax,%edx
80106bf2:	ec                   	in     (%dx),%al
80106bf3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106bf6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80106bf9:	c9                   	leave  
80106bfa:	c3                   	ret    

80106bfb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106bfb:	55                   	push   %ebp
80106bfc:	89 e5                	mov    %esp,%ebp
80106bfe:	83 ec 08             	sub    $0x8,%esp
80106c01:	8b 45 08             	mov    0x8(%ebp),%eax
80106c04:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c07:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106c0b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c0e:	8a 45 f8             	mov    -0x8(%ebp),%al
80106c11:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c14:	ee                   	out    %al,(%dx)
}
80106c15:	c9                   	leave  
80106c16:	c3                   	ret    

80106c17 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c17:	55                   	push   %ebp
80106c18:	89 e5                	mov    %esp,%ebp
80106c1a:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106c1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c24:	00 
80106c25:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106c2c:	e8 ca ff ff ff       	call   80106bfb <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106c31:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106c38:	00 
80106c39:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106c40:	e8 b6 ff ff ff       	call   80106bfb <outb>
  outb(COM1+0, 115200/9600);
80106c45:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106c4c:	00 
80106c4d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c54:	e8 a2 ff ff ff       	call   80106bfb <outb>
  outb(COM1+1, 0);
80106c59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c60:	00 
80106c61:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106c68:	e8 8e ff ff ff       	call   80106bfb <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106c6d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106c74:	00 
80106c75:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106c7c:	e8 7a ff ff ff       	call   80106bfb <outb>
  outb(COM1+4, 0);
80106c81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c88:	00 
80106c89:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106c90:	e8 66 ff ff ff       	call   80106bfb <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106c95:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106c9c:	00 
80106c9d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106ca4:	e8 52 ff ff ff       	call   80106bfb <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106ca9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cb0:	e8 2b ff ff ff       	call   80106be0 <inb>
80106cb5:	3c ff                	cmp    $0xff,%al
80106cb7:	75 02                	jne    80106cbb <uartinit+0xa4>
    return;
80106cb9:	eb 5b                	jmp    80106d16 <uartinit+0xff>
  uart = 1;
80106cbb:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
80106cc2:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106cc5:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ccc:	e8 0f ff ff ff       	call   80106be0 <inb>
  inb(COM1+0);
80106cd1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cd8:	e8 03 ff ff ff       	call   80106be0 <inb>
  ioapicenable(IRQ_COM1, 0);
80106cdd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ce4:	00 
80106ce5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106cec:	e8 b2 c1 ff ff       	call   80102ea3 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106cf1:	c7 45 f4 d0 8b 10 80 	movl   $0x80108bd0,-0xc(%ebp)
80106cf8:	eb 13                	jmp    80106d0d <uartinit+0xf6>
    uartputc(*p);
80106cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfd:	8a 00                	mov    (%eax),%al
80106cff:	0f be c0             	movsbl %al,%eax
80106d02:	89 04 24             	mov    %eax,(%esp)
80106d05:	e8 0e 00 00 00       	call   80106d18 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d0a:	ff 45 f4             	incl   -0xc(%ebp)
80106d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d10:	8a 00                	mov    (%eax),%al
80106d12:	84 c0                	test   %al,%al
80106d14:	75 e4                	jne    80106cfa <uartinit+0xe3>
    uartputc(*p);
}
80106d16:	c9                   	leave  
80106d17:	c3                   	ret    

80106d18 <uartputc>:

void
uartputc(int c)
{
80106d18:	55                   	push   %ebp
80106d19:	89 e5                	mov    %esp,%ebp
80106d1b:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106d1e:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106d23:	85 c0                	test   %eax,%eax
80106d25:	75 02                	jne    80106d29 <uartputc+0x11>
    return;
80106d27:	eb 4a                	jmp    80106d73 <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d30:	eb 0f                	jmp    80106d41 <uartputc+0x29>
    microdelay(10);
80106d32:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106d39:	e8 96 c6 ff ff       	call   801033d4 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d3e:	ff 45 f4             	incl   -0xc(%ebp)
80106d41:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106d45:	7f 16                	jg     80106d5d <uartputc+0x45>
80106d47:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106d4e:	e8 8d fe ff ff       	call   80106be0 <inb>
80106d53:	0f b6 c0             	movzbl %al,%eax
80106d56:	83 e0 20             	and    $0x20,%eax
80106d59:	85 c0                	test   %eax,%eax
80106d5b:	74 d5                	je     80106d32 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d60:	0f b6 c0             	movzbl %al,%eax
80106d63:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d67:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106d6e:	e8 88 fe ff ff       	call   80106bfb <outb>
}
80106d73:	c9                   	leave  
80106d74:	c3                   	ret    

80106d75 <uartgetc>:

static int
uartgetc(void)
{
80106d75:	55                   	push   %ebp
80106d76:	89 e5                	mov    %esp,%ebp
80106d78:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106d7b:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106d80:	85 c0                	test   %eax,%eax
80106d82:	75 07                	jne    80106d8b <uartgetc+0x16>
    return -1;
80106d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d89:	eb 2c                	jmp    80106db7 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106d8b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106d92:	e8 49 fe ff ff       	call   80106be0 <inb>
80106d97:	0f b6 c0             	movzbl %al,%eax
80106d9a:	83 e0 01             	and    $0x1,%eax
80106d9d:	85 c0                	test   %eax,%eax
80106d9f:	75 07                	jne    80106da8 <uartgetc+0x33>
    return -1;
80106da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106da6:	eb 0f                	jmp    80106db7 <uartgetc+0x42>
  return inb(COM1+0);
80106da8:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106daf:	e8 2c fe ff ff       	call   80106be0 <inb>
80106db4:	0f b6 c0             	movzbl %al,%eax
}
80106db7:	c9                   	leave  
80106db8:	c3                   	ret    

80106db9 <uartintr>:

void
uartintr(void)
{
80106db9:	55                   	push   %ebp
80106dba:	89 e5                	mov    %esp,%ebp
80106dbc:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106dbf:	c7 04 24 75 6d 10 80 	movl   $0x80106d75,(%esp)
80106dc6:	e8 fa 99 ff ff       	call   801007c5 <consoleintr>
}
80106dcb:	c9                   	leave  
80106dcc:	c3                   	ret    
80106dcd:	00 00                	add    %al,(%eax)
	...

80106dd0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $0
80106dd2:	6a 00                	push   $0x0
  jmp alltraps
80106dd4:	e9 cb f9 ff ff       	jmp    801067a4 <alltraps>

80106dd9 <vector1>:
.globl vector1
vector1:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $1
80106ddb:	6a 01                	push   $0x1
  jmp alltraps
80106ddd:	e9 c2 f9 ff ff       	jmp    801067a4 <alltraps>

80106de2 <vector2>:
.globl vector2
vector2:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $2
80106de4:	6a 02                	push   $0x2
  jmp alltraps
80106de6:	e9 b9 f9 ff ff       	jmp    801067a4 <alltraps>

80106deb <vector3>:
.globl vector3
vector3:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $3
80106ded:	6a 03                	push   $0x3
  jmp alltraps
80106def:	e9 b0 f9 ff ff       	jmp    801067a4 <alltraps>

80106df4 <vector4>:
.globl vector4
vector4:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $4
80106df6:	6a 04                	push   $0x4
  jmp alltraps
80106df8:	e9 a7 f9 ff ff       	jmp    801067a4 <alltraps>

80106dfd <vector5>:
.globl vector5
vector5:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $5
80106dff:	6a 05                	push   $0x5
  jmp alltraps
80106e01:	e9 9e f9 ff ff       	jmp    801067a4 <alltraps>

80106e06 <vector6>:
.globl vector6
vector6:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $6
80106e08:	6a 06                	push   $0x6
  jmp alltraps
80106e0a:	e9 95 f9 ff ff       	jmp    801067a4 <alltraps>

80106e0f <vector7>:
.globl vector7
vector7:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $7
80106e11:	6a 07                	push   $0x7
  jmp alltraps
80106e13:	e9 8c f9 ff ff       	jmp    801067a4 <alltraps>

80106e18 <vector8>:
.globl vector8
vector8:
  pushl $8
80106e18:	6a 08                	push   $0x8
  jmp alltraps
80106e1a:	e9 85 f9 ff ff       	jmp    801067a4 <alltraps>

80106e1f <vector9>:
.globl vector9
vector9:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $9
80106e21:	6a 09                	push   $0x9
  jmp alltraps
80106e23:	e9 7c f9 ff ff       	jmp    801067a4 <alltraps>

80106e28 <vector10>:
.globl vector10
vector10:
  pushl $10
80106e28:	6a 0a                	push   $0xa
  jmp alltraps
80106e2a:	e9 75 f9 ff ff       	jmp    801067a4 <alltraps>

80106e2f <vector11>:
.globl vector11
vector11:
  pushl $11
80106e2f:	6a 0b                	push   $0xb
  jmp alltraps
80106e31:	e9 6e f9 ff ff       	jmp    801067a4 <alltraps>

80106e36 <vector12>:
.globl vector12
vector12:
  pushl $12
80106e36:	6a 0c                	push   $0xc
  jmp alltraps
80106e38:	e9 67 f9 ff ff       	jmp    801067a4 <alltraps>

80106e3d <vector13>:
.globl vector13
vector13:
  pushl $13
80106e3d:	6a 0d                	push   $0xd
  jmp alltraps
80106e3f:	e9 60 f9 ff ff       	jmp    801067a4 <alltraps>

80106e44 <vector14>:
.globl vector14
vector14:
  pushl $14
80106e44:	6a 0e                	push   $0xe
  jmp alltraps
80106e46:	e9 59 f9 ff ff       	jmp    801067a4 <alltraps>

80106e4b <vector15>:
.globl vector15
vector15:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $15
80106e4d:	6a 0f                	push   $0xf
  jmp alltraps
80106e4f:	e9 50 f9 ff ff       	jmp    801067a4 <alltraps>

80106e54 <vector16>:
.globl vector16
vector16:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $16
80106e56:	6a 10                	push   $0x10
  jmp alltraps
80106e58:	e9 47 f9 ff ff       	jmp    801067a4 <alltraps>

80106e5d <vector17>:
.globl vector17
vector17:
  pushl $17
80106e5d:	6a 11                	push   $0x11
  jmp alltraps
80106e5f:	e9 40 f9 ff ff       	jmp    801067a4 <alltraps>

80106e64 <vector18>:
.globl vector18
vector18:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $18
80106e66:	6a 12                	push   $0x12
  jmp alltraps
80106e68:	e9 37 f9 ff ff       	jmp    801067a4 <alltraps>

80106e6d <vector19>:
.globl vector19
vector19:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $19
80106e6f:	6a 13                	push   $0x13
  jmp alltraps
80106e71:	e9 2e f9 ff ff       	jmp    801067a4 <alltraps>

80106e76 <vector20>:
.globl vector20
vector20:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $20
80106e78:	6a 14                	push   $0x14
  jmp alltraps
80106e7a:	e9 25 f9 ff ff       	jmp    801067a4 <alltraps>

80106e7f <vector21>:
.globl vector21
vector21:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $21
80106e81:	6a 15                	push   $0x15
  jmp alltraps
80106e83:	e9 1c f9 ff ff       	jmp    801067a4 <alltraps>

80106e88 <vector22>:
.globl vector22
vector22:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $22
80106e8a:	6a 16                	push   $0x16
  jmp alltraps
80106e8c:	e9 13 f9 ff ff       	jmp    801067a4 <alltraps>

80106e91 <vector23>:
.globl vector23
vector23:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $23
80106e93:	6a 17                	push   $0x17
  jmp alltraps
80106e95:	e9 0a f9 ff ff       	jmp    801067a4 <alltraps>

80106e9a <vector24>:
.globl vector24
vector24:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $24
80106e9c:	6a 18                	push   $0x18
  jmp alltraps
80106e9e:	e9 01 f9 ff ff       	jmp    801067a4 <alltraps>

80106ea3 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $25
80106ea5:	6a 19                	push   $0x19
  jmp alltraps
80106ea7:	e9 f8 f8 ff ff       	jmp    801067a4 <alltraps>

80106eac <vector26>:
.globl vector26
vector26:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $26
80106eae:	6a 1a                	push   $0x1a
  jmp alltraps
80106eb0:	e9 ef f8 ff ff       	jmp    801067a4 <alltraps>

80106eb5 <vector27>:
.globl vector27
vector27:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $27
80106eb7:	6a 1b                	push   $0x1b
  jmp alltraps
80106eb9:	e9 e6 f8 ff ff       	jmp    801067a4 <alltraps>

80106ebe <vector28>:
.globl vector28
vector28:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $28
80106ec0:	6a 1c                	push   $0x1c
  jmp alltraps
80106ec2:	e9 dd f8 ff ff       	jmp    801067a4 <alltraps>

80106ec7 <vector29>:
.globl vector29
vector29:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $29
80106ec9:	6a 1d                	push   $0x1d
  jmp alltraps
80106ecb:	e9 d4 f8 ff ff       	jmp    801067a4 <alltraps>

80106ed0 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $30
80106ed2:	6a 1e                	push   $0x1e
  jmp alltraps
80106ed4:	e9 cb f8 ff ff       	jmp    801067a4 <alltraps>

80106ed9 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $31
80106edb:	6a 1f                	push   $0x1f
  jmp alltraps
80106edd:	e9 c2 f8 ff ff       	jmp    801067a4 <alltraps>

80106ee2 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $32
80106ee4:	6a 20                	push   $0x20
  jmp alltraps
80106ee6:	e9 b9 f8 ff ff       	jmp    801067a4 <alltraps>

80106eeb <vector33>:
.globl vector33
vector33:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $33
80106eed:	6a 21                	push   $0x21
  jmp alltraps
80106eef:	e9 b0 f8 ff ff       	jmp    801067a4 <alltraps>

80106ef4 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $34
80106ef6:	6a 22                	push   $0x22
  jmp alltraps
80106ef8:	e9 a7 f8 ff ff       	jmp    801067a4 <alltraps>

80106efd <vector35>:
.globl vector35
vector35:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $35
80106eff:	6a 23                	push   $0x23
  jmp alltraps
80106f01:	e9 9e f8 ff ff       	jmp    801067a4 <alltraps>

80106f06 <vector36>:
.globl vector36
vector36:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $36
80106f08:	6a 24                	push   $0x24
  jmp alltraps
80106f0a:	e9 95 f8 ff ff       	jmp    801067a4 <alltraps>

80106f0f <vector37>:
.globl vector37
vector37:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $37
80106f11:	6a 25                	push   $0x25
  jmp alltraps
80106f13:	e9 8c f8 ff ff       	jmp    801067a4 <alltraps>

80106f18 <vector38>:
.globl vector38
vector38:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $38
80106f1a:	6a 26                	push   $0x26
  jmp alltraps
80106f1c:	e9 83 f8 ff ff       	jmp    801067a4 <alltraps>

80106f21 <vector39>:
.globl vector39
vector39:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $39
80106f23:	6a 27                	push   $0x27
  jmp alltraps
80106f25:	e9 7a f8 ff ff       	jmp    801067a4 <alltraps>

80106f2a <vector40>:
.globl vector40
vector40:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $40
80106f2c:	6a 28                	push   $0x28
  jmp alltraps
80106f2e:	e9 71 f8 ff ff       	jmp    801067a4 <alltraps>

80106f33 <vector41>:
.globl vector41
vector41:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $41
80106f35:	6a 29                	push   $0x29
  jmp alltraps
80106f37:	e9 68 f8 ff ff       	jmp    801067a4 <alltraps>

80106f3c <vector42>:
.globl vector42
vector42:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $42
80106f3e:	6a 2a                	push   $0x2a
  jmp alltraps
80106f40:	e9 5f f8 ff ff       	jmp    801067a4 <alltraps>

80106f45 <vector43>:
.globl vector43
vector43:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $43
80106f47:	6a 2b                	push   $0x2b
  jmp alltraps
80106f49:	e9 56 f8 ff ff       	jmp    801067a4 <alltraps>

80106f4e <vector44>:
.globl vector44
vector44:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $44
80106f50:	6a 2c                	push   $0x2c
  jmp alltraps
80106f52:	e9 4d f8 ff ff       	jmp    801067a4 <alltraps>

80106f57 <vector45>:
.globl vector45
vector45:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $45
80106f59:	6a 2d                	push   $0x2d
  jmp alltraps
80106f5b:	e9 44 f8 ff ff       	jmp    801067a4 <alltraps>

80106f60 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $46
80106f62:	6a 2e                	push   $0x2e
  jmp alltraps
80106f64:	e9 3b f8 ff ff       	jmp    801067a4 <alltraps>

80106f69 <vector47>:
.globl vector47
vector47:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $47
80106f6b:	6a 2f                	push   $0x2f
  jmp alltraps
80106f6d:	e9 32 f8 ff ff       	jmp    801067a4 <alltraps>

80106f72 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $48
80106f74:	6a 30                	push   $0x30
  jmp alltraps
80106f76:	e9 29 f8 ff ff       	jmp    801067a4 <alltraps>

80106f7b <vector49>:
.globl vector49
vector49:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $49
80106f7d:	6a 31                	push   $0x31
  jmp alltraps
80106f7f:	e9 20 f8 ff ff       	jmp    801067a4 <alltraps>

80106f84 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $50
80106f86:	6a 32                	push   $0x32
  jmp alltraps
80106f88:	e9 17 f8 ff ff       	jmp    801067a4 <alltraps>

80106f8d <vector51>:
.globl vector51
vector51:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $51
80106f8f:	6a 33                	push   $0x33
  jmp alltraps
80106f91:	e9 0e f8 ff ff       	jmp    801067a4 <alltraps>

80106f96 <vector52>:
.globl vector52
vector52:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $52
80106f98:	6a 34                	push   $0x34
  jmp alltraps
80106f9a:	e9 05 f8 ff ff       	jmp    801067a4 <alltraps>

80106f9f <vector53>:
.globl vector53
vector53:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $53
80106fa1:	6a 35                	push   $0x35
  jmp alltraps
80106fa3:	e9 fc f7 ff ff       	jmp    801067a4 <alltraps>

80106fa8 <vector54>:
.globl vector54
vector54:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $54
80106faa:	6a 36                	push   $0x36
  jmp alltraps
80106fac:	e9 f3 f7 ff ff       	jmp    801067a4 <alltraps>

80106fb1 <vector55>:
.globl vector55
vector55:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $55
80106fb3:	6a 37                	push   $0x37
  jmp alltraps
80106fb5:	e9 ea f7 ff ff       	jmp    801067a4 <alltraps>

80106fba <vector56>:
.globl vector56
vector56:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $56
80106fbc:	6a 38                	push   $0x38
  jmp alltraps
80106fbe:	e9 e1 f7 ff ff       	jmp    801067a4 <alltraps>

80106fc3 <vector57>:
.globl vector57
vector57:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $57
80106fc5:	6a 39                	push   $0x39
  jmp alltraps
80106fc7:	e9 d8 f7 ff ff       	jmp    801067a4 <alltraps>

80106fcc <vector58>:
.globl vector58
vector58:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $58
80106fce:	6a 3a                	push   $0x3a
  jmp alltraps
80106fd0:	e9 cf f7 ff ff       	jmp    801067a4 <alltraps>

80106fd5 <vector59>:
.globl vector59
vector59:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $59
80106fd7:	6a 3b                	push   $0x3b
  jmp alltraps
80106fd9:	e9 c6 f7 ff ff       	jmp    801067a4 <alltraps>

80106fde <vector60>:
.globl vector60
vector60:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $60
80106fe0:	6a 3c                	push   $0x3c
  jmp alltraps
80106fe2:	e9 bd f7 ff ff       	jmp    801067a4 <alltraps>

80106fe7 <vector61>:
.globl vector61
vector61:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $61
80106fe9:	6a 3d                	push   $0x3d
  jmp alltraps
80106feb:	e9 b4 f7 ff ff       	jmp    801067a4 <alltraps>

80106ff0 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $62
80106ff2:	6a 3e                	push   $0x3e
  jmp alltraps
80106ff4:	e9 ab f7 ff ff       	jmp    801067a4 <alltraps>

80106ff9 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $63
80106ffb:	6a 3f                	push   $0x3f
  jmp alltraps
80106ffd:	e9 a2 f7 ff ff       	jmp    801067a4 <alltraps>

80107002 <vector64>:
.globl vector64
vector64:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $64
80107004:	6a 40                	push   $0x40
  jmp alltraps
80107006:	e9 99 f7 ff ff       	jmp    801067a4 <alltraps>

8010700b <vector65>:
.globl vector65
vector65:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $65
8010700d:	6a 41                	push   $0x41
  jmp alltraps
8010700f:	e9 90 f7 ff ff       	jmp    801067a4 <alltraps>

80107014 <vector66>:
.globl vector66
vector66:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $66
80107016:	6a 42                	push   $0x42
  jmp alltraps
80107018:	e9 87 f7 ff ff       	jmp    801067a4 <alltraps>

8010701d <vector67>:
.globl vector67
vector67:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $67
8010701f:	6a 43                	push   $0x43
  jmp alltraps
80107021:	e9 7e f7 ff ff       	jmp    801067a4 <alltraps>

80107026 <vector68>:
.globl vector68
vector68:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $68
80107028:	6a 44                	push   $0x44
  jmp alltraps
8010702a:	e9 75 f7 ff ff       	jmp    801067a4 <alltraps>

8010702f <vector69>:
.globl vector69
vector69:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $69
80107031:	6a 45                	push   $0x45
  jmp alltraps
80107033:	e9 6c f7 ff ff       	jmp    801067a4 <alltraps>

80107038 <vector70>:
.globl vector70
vector70:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $70
8010703a:	6a 46                	push   $0x46
  jmp alltraps
8010703c:	e9 63 f7 ff ff       	jmp    801067a4 <alltraps>

80107041 <vector71>:
.globl vector71
vector71:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $71
80107043:	6a 47                	push   $0x47
  jmp alltraps
80107045:	e9 5a f7 ff ff       	jmp    801067a4 <alltraps>

8010704a <vector72>:
.globl vector72
vector72:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $72
8010704c:	6a 48                	push   $0x48
  jmp alltraps
8010704e:	e9 51 f7 ff ff       	jmp    801067a4 <alltraps>

80107053 <vector73>:
.globl vector73
vector73:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $73
80107055:	6a 49                	push   $0x49
  jmp alltraps
80107057:	e9 48 f7 ff ff       	jmp    801067a4 <alltraps>

8010705c <vector74>:
.globl vector74
vector74:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $74
8010705e:	6a 4a                	push   $0x4a
  jmp alltraps
80107060:	e9 3f f7 ff ff       	jmp    801067a4 <alltraps>

80107065 <vector75>:
.globl vector75
vector75:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $75
80107067:	6a 4b                	push   $0x4b
  jmp alltraps
80107069:	e9 36 f7 ff ff       	jmp    801067a4 <alltraps>

8010706e <vector76>:
.globl vector76
vector76:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $76
80107070:	6a 4c                	push   $0x4c
  jmp alltraps
80107072:	e9 2d f7 ff ff       	jmp    801067a4 <alltraps>

80107077 <vector77>:
.globl vector77
vector77:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $77
80107079:	6a 4d                	push   $0x4d
  jmp alltraps
8010707b:	e9 24 f7 ff ff       	jmp    801067a4 <alltraps>

80107080 <vector78>:
.globl vector78
vector78:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $78
80107082:	6a 4e                	push   $0x4e
  jmp alltraps
80107084:	e9 1b f7 ff ff       	jmp    801067a4 <alltraps>

80107089 <vector79>:
.globl vector79
vector79:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $79
8010708b:	6a 4f                	push   $0x4f
  jmp alltraps
8010708d:	e9 12 f7 ff ff       	jmp    801067a4 <alltraps>

80107092 <vector80>:
.globl vector80
vector80:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $80
80107094:	6a 50                	push   $0x50
  jmp alltraps
80107096:	e9 09 f7 ff ff       	jmp    801067a4 <alltraps>

8010709b <vector81>:
.globl vector81
vector81:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $81
8010709d:	6a 51                	push   $0x51
  jmp alltraps
8010709f:	e9 00 f7 ff ff       	jmp    801067a4 <alltraps>

801070a4 <vector82>:
.globl vector82
vector82:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $82
801070a6:	6a 52                	push   $0x52
  jmp alltraps
801070a8:	e9 f7 f6 ff ff       	jmp    801067a4 <alltraps>

801070ad <vector83>:
.globl vector83
vector83:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $83
801070af:	6a 53                	push   $0x53
  jmp alltraps
801070b1:	e9 ee f6 ff ff       	jmp    801067a4 <alltraps>

801070b6 <vector84>:
.globl vector84
vector84:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $84
801070b8:	6a 54                	push   $0x54
  jmp alltraps
801070ba:	e9 e5 f6 ff ff       	jmp    801067a4 <alltraps>

801070bf <vector85>:
.globl vector85
vector85:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $85
801070c1:	6a 55                	push   $0x55
  jmp alltraps
801070c3:	e9 dc f6 ff ff       	jmp    801067a4 <alltraps>

801070c8 <vector86>:
.globl vector86
vector86:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $86
801070ca:	6a 56                	push   $0x56
  jmp alltraps
801070cc:	e9 d3 f6 ff ff       	jmp    801067a4 <alltraps>

801070d1 <vector87>:
.globl vector87
vector87:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $87
801070d3:	6a 57                	push   $0x57
  jmp alltraps
801070d5:	e9 ca f6 ff ff       	jmp    801067a4 <alltraps>

801070da <vector88>:
.globl vector88
vector88:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $88
801070dc:	6a 58                	push   $0x58
  jmp alltraps
801070de:	e9 c1 f6 ff ff       	jmp    801067a4 <alltraps>

801070e3 <vector89>:
.globl vector89
vector89:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $89
801070e5:	6a 59                	push   $0x59
  jmp alltraps
801070e7:	e9 b8 f6 ff ff       	jmp    801067a4 <alltraps>

801070ec <vector90>:
.globl vector90
vector90:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $90
801070ee:	6a 5a                	push   $0x5a
  jmp alltraps
801070f0:	e9 af f6 ff ff       	jmp    801067a4 <alltraps>

801070f5 <vector91>:
.globl vector91
vector91:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $91
801070f7:	6a 5b                	push   $0x5b
  jmp alltraps
801070f9:	e9 a6 f6 ff ff       	jmp    801067a4 <alltraps>

801070fe <vector92>:
.globl vector92
vector92:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $92
80107100:	6a 5c                	push   $0x5c
  jmp alltraps
80107102:	e9 9d f6 ff ff       	jmp    801067a4 <alltraps>

80107107 <vector93>:
.globl vector93
vector93:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $93
80107109:	6a 5d                	push   $0x5d
  jmp alltraps
8010710b:	e9 94 f6 ff ff       	jmp    801067a4 <alltraps>

80107110 <vector94>:
.globl vector94
vector94:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $94
80107112:	6a 5e                	push   $0x5e
  jmp alltraps
80107114:	e9 8b f6 ff ff       	jmp    801067a4 <alltraps>

80107119 <vector95>:
.globl vector95
vector95:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $95
8010711b:	6a 5f                	push   $0x5f
  jmp alltraps
8010711d:	e9 82 f6 ff ff       	jmp    801067a4 <alltraps>

80107122 <vector96>:
.globl vector96
vector96:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $96
80107124:	6a 60                	push   $0x60
  jmp alltraps
80107126:	e9 79 f6 ff ff       	jmp    801067a4 <alltraps>

8010712b <vector97>:
.globl vector97
vector97:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $97
8010712d:	6a 61                	push   $0x61
  jmp alltraps
8010712f:	e9 70 f6 ff ff       	jmp    801067a4 <alltraps>

80107134 <vector98>:
.globl vector98
vector98:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $98
80107136:	6a 62                	push   $0x62
  jmp alltraps
80107138:	e9 67 f6 ff ff       	jmp    801067a4 <alltraps>

8010713d <vector99>:
.globl vector99
vector99:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $99
8010713f:	6a 63                	push   $0x63
  jmp alltraps
80107141:	e9 5e f6 ff ff       	jmp    801067a4 <alltraps>

80107146 <vector100>:
.globl vector100
vector100:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $100
80107148:	6a 64                	push   $0x64
  jmp alltraps
8010714a:	e9 55 f6 ff ff       	jmp    801067a4 <alltraps>

8010714f <vector101>:
.globl vector101
vector101:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $101
80107151:	6a 65                	push   $0x65
  jmp alltraps
80107153:	e9 4c f6 ff ff       	jmp    801067a4 <alltraps>

80107158 <vector102>:
.globl vector102
vector102:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $102
8010715a:	6a 66                	push   $0x66
  jmp alltraps
8010715c:	e9 43 f6 ff ff       	jmp    801067a4 <alltraps>

80107161 <vector103>:
.globl vector103
vector103:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $103
80107163:	6a 67                	push   $0x67
  jmp alltraps
80107165:	e9 3a f6 ff ff       	jmp    801067a4 <alltraps>

8010716a <vector104>:
.globl vector104
vector104:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $104
8010716c:	6a 68                	push   $0x68
  jmp alltraps
8010716e:	e9 31 f6 ff ff       	jmp    801067a4 <alltraps>

80107173 <vector105>:
.globl vector105
vector105:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $105
80107175:	6a 69                	push   $0x69
  jmp alltraps
80107177:	e9 28 f6 ff ff       	jmp    801067a4 <alltraps>

8010717c <vector106>:
.globl vector106
vector106:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $106
8010717e:	6a 6a                	push   $0x6a
  jmp alltraps
80107180:	e9 1f f6 ff ff       	jmp    801067a4 <alltraps>

80107185 <vector107>:
.globl vector107
vector107:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $107
80107187:	6a 6b                	push   $0x6b
  jmp alltraps
80107189:	e9 16 f6 ff ff       	jmp    801067a4 <alltraps>

8010718e <vector108>:
.globl vector108
vector108:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $108
80107190:	6a 6c                	push   $0x6c
  jmp alltraps
80107192:	e9 0d f6 ff ff       	jmp    801067a4 <alltraps>

80107197 <vector109>:
.globl vector109
vector109:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $109
80107199:	6a 6d                	push   $0x6d
  jmp alltraps
8010719b:	e9 04 f6 ff ff       	jmp    801067a4 <alltraps>

801071a0 <vector110>:
.globl vector110
vector110:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $110
801071a2:	6a 6e                	push   $0x6e
  jmp alltraps
801071a4:	e9 fb f5 ff ff       	jmp    801067a4 <alltraps>

801071a9 <vector111>:
.globl vector111
vector111:
  pushl $0
801071a9:	6a 00                	push   $0x0
  pushl $111
801071ab:	6a 6f                	push   $0x6f
  jmp alltraps
801071ad:	e9 f2 f5 ff ff       	jmp    801067a4 <alltraps>

801071b2 <vector112>:
.globl vector112
vector112:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $112
801071b4:	6a 70                	push   $0x70
  jmp alltraps
801071b6:	e9 e9 f5 ff ff       	jmp    801067a4 <alltraps>

801071bb <vector113>:
.globl vector113
vector113:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $113
801071bd:	6a 71                	push   $0x71
  jmp alltraps
801071bf:	e9 e0 f5 ff ff       	jmp    801067a4 <alltraps>

801071c4 <vector114>:
.globl vector114
vector114:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $114
801071c6:	6a 72                	push   $0x72
  jmp alltraps
801071c8:	e9 d7 f5 ff ff       	jmp    801067a4 <alltraps>

801071cd <vector115>:
.globl vector115
vector115:
  pushl $0
801071cd:	6a 00                	push   $0x0
  pushl $115
801071cf:	6a 73                	push   $0x73
  jmp alltraps
801071d1:	e9 ce f5 ff ff       	jmp    801067a4 <alltraps>

801071d6 <vector116>:
.globl vector116
vector116:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $116
801071d8:	6a 74                	push   $0x74
  jmp alltraps
801071da:	e9 c5 f5 ff ff       	jmp    801067a4 <alltraps>

801071df <vector117>:
.globl vector117
vector117:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $117
801071e1:	6a 75                	push   $0x75
  jmp alltraps
801071e3:	e9 bc f5 ff ff       	jmp    801067a4 <alltraps>

801071e8 <vector118>:
.globl vector118
vector118:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $118
801071ea:	6a 76                	push   $0x76
  jmp alltraps
801071ec:	e9 b3 f5 ff ff       	jmp    801067a4 <alltraps>

801071f1 <vector119>:
.globl vector119
vector119:
  pushl $0
801071f1:	6a 00                	push   $0x0
  pushl $119
801071f3:	6a 77                	push   $0x77
  jmp alltraps
801071f5:	e9 aa f5 ff ff       	jmp    801067a4 <alltraps>

801071fa <vector120>:
.globl vector120
vector120:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $120
801071fc:	6a 78                	push   $0x78
  jmp alltraps
801071fe:	e9 a1 f5 ff ff       	jmp    801067a4 <alltraps>

80107203 <vector121>:
.globl vector121
vector121:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $121
80107205:	6a 79                	push   $0x79
  jmp alltraps
80107207:	e9 98 f5 ff ff       	jmp    801067a4 <alltraps>

8010720c <vector122>:
.globl vector122
vector122:
  pushl $0
8010720c:	6a 00                	push   $0x0
  pushl $122
8010720e:	6a 7a                	push   $0x7a
  jmp alltraps
80107210:	e9 8f f5 ff ff       	jmp    801067a4 <alltraps>

80107215 <vector123>:
.globl vector123
vector123:
  pushl $0
80107215:	6a 00                	push   $0x0
  pushl $123
80107217:	6a 7b                	push   $0x7b
  jmp alltraps
80107219:	e9 86 f5 ff ff       	jmp    801067a4 <alltraps>

8010721e <vector124>:
.globl vector124
vector124:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $124
80107220:	6a 7c                	push   $0x7c
  jmp alltraps
80107222:	e9 7d f5 ff ff       	jmp    801067a4 <alltraps>

80107227 <vector125>:
.globl vector125
vector125:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $125
80107229:	6a 7d                	push   $0x7d
  jmp alltraps
8010722b:	e9 74 f5 ff ff       	jmp    801067a4 <alltraps>

80107230 <vector126>:
.globl vector126
vector126:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $126
80107232:	6a 7e                	push   $0x7e
  jmp alltraps
80107234:	e9 6b f5 ff ff       	jmp    801067a4 <alltraps>

80107239 <vector127>:
.globl vector127
vector127:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $127
8010723b:	6a 7f                	push   $0x7f
  jmp alltraps
8010723d:	e9 62 f5 ff ff       	jmp    801067a4 <alltraps>

80107242 <vector128>:
.globl vector128
vector128:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $128
80107244:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107249:	e9 56 f5 ff ff       	jmp    801067a4 <alltraps>

8010724e <vector129>:
.globl vector129
vector129:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $129
80107250:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107255:	e9 4a f5 ff ff       	jmp    801067a4 <alltraps>

8010725a <vector130>:
.globl vector130
vector130:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $130
8010725c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107261:	e9 3e f5 ff ff       	jmp    801067a4 <alltraps>

80107266 <vector131>:
.globl vector131
vector131:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $131
80107268:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010726d:	e9 32 f5 ff ff       	jmp    801067a4 <alltraps>

80107272 <vector132>:
.globl vector132
vector132:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $132
80107274:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107279:	e9 26 f5 ff ff       	jmp    801067a4 <alltraps>

8010727e <vector133>:
.globl vector133
vector133:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $133
80107280:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107285:	e9 1a f5 ff ff       	jmp    801067a4 <alltraps>

8010728a <vector134>:
.globl vector134
vector134:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $134
8010728c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107291:	e9 0e f5 ff ff       	jmp    801067a4 <alltraps>

80107296 <vector135>:
.globl vector135
vector135:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $135
80107298:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010729d:	e9 02 f5 ff ff       	jmp    801067a4 <alltraps>

801072a2 <vector136>:
.globl vector136
vector136:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $136
801072a4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072a9:	e9 f6 f4 ff ff       	jmp    801067a4 <alltraps>

801072ae <vector137>:
.globl vector137
vector137:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $137
801072b0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072b5:	e9 ea f4 ff ff       	jmp    801067a4 <alltraps>

801072ba <vector138>:
.globl vector138
vector138:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $138
801072bc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072c1:	e9 de f4 ff ff       	jmp    801067a4 <alltraps>

801072c6 <vector139>:
.globl vector139
vector139:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $139
801072c8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801072cd:	e9 d2 f4 ff ff       	jmp    801067a4 <alltraps>

801072d2 <vector140>:
.globl vector140
vector140:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $140
801072d4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801072d9:	e9 c6 f4 ff ff       	jmp    801067a4 <alltraps>

801072de <vector141>:
.globl vector141
vector141:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $141
801072e0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801072e5:	e9 ba f4 ff ff       	jmp    801067a4 <alltraps>

801072ea <vector142>:
.globl vector142
vector142:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $142
801072ec:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072f1:	e9 ae f4 ff ff       	jmp    801067a4 <alltraps>

801072f6 <vector143>:
.globl vector143
vector143:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $143
801072f8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801072fd:	e9 a2 f4 ff ff       	jmp    801067a4 <alltraps>

80107302 <vector144>:
.globl vector144
vector144:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $144
80107304:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107309:	e9 96 f4 ff ff       	jmp    801067a4 <alltraps>

8010730e <vector145>:
.globl vector145
vector145:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $145
80107310:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107315:	e9 8a f4 ff ff       	jmp    801067a4 <alltraps>

8010731a <vector146>:
.globl vector146
vector146:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $146
8010731c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107321:	e9 7e f4 ff ff       	jmp    801067a4 <alltraps>

80107326 <vector147>:
.globl vector147
vector147:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $147
80107328:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010732d:	e9 72 f4 ff ff       	jmp    801067a4 <alltraps>

80107332 <vector148>:
.globl vector148
vector148:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $148
80107334:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107339:	e9 66 f4 ff ff       	jmp    801067a4 <alltraps>

8010733e <vector149>:
.globl vector149
vector149:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $149
80107340:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107345:	e9 5a f4 ff ff       	jmp    801067a4 <alltraps>

8010734a <vector150>:
.globl vector150
vector150:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $150
8010734c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107351:	e9 4e f4 ff ff       	jmp    801067a4 <alltraps>

80107356 <vector151>:
.globl vector151
vector151:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $151
80107358:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010735d:	e9 42 f4 ff ff       	jmp    801067a4 <alltraps>

80107362 <vector152>:
.globl vector152
vector152:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $152
80107364:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107369:	e9 36 f4 ff ff       	jmp    801067a4 <alltraps>

8010736e <vector153>:
.globl vector153
vector153:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $153
80107370:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107375:	e9 2a f4 ff ff       	jmp    801067a4 <alltraps>

8010737a <vector154>:
.globl vector154
vector154:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $154
8010737c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107381:	e9 1e f4 ff ff       	jmp    801067a4 <alltraps>

80107386 <vector155>:
.globl vector155
vector155:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $155
80107388:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010738d:	e9 12 f4 ff ff       	jmp    801067a4 <alltraps>

80107392 <vector156>:
.globl vector156
vector156:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $156
80107394:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107399:	e9 06 f4 ff ff       	jmp    801067a4 <alltraps>

8010739e <vector157>:
.globl vector157
vector157:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $157
801073a0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073a5:	e9 fa f3 ff ff       	jmp    801067a4 <alltraps>

801073aa <vector158>:
.globl vector158
vector158:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $158
801073ac:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073b1:	e9 ee f3 ff ff       	jmp    801067a4 <alltraps>

801073b6 <vector159>:
.globl vector159
vector159:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $159
801073b8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073bd:	e9 e2 f3 ff ff       	jmp    801067a4 <alltraps>

801073c2 <vector160>:
.globl vector160
vector160:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $160
801073c4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801073c9:	e9 d6 f3 ff ff       	jmp    801067a4 <alltraps>

801073ce <vector161>:
.globl vector161
vector161:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $161
801073d0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801073d5:	e9 ca f3 ff ff       	jmp    801067a4 <alltraps>

801073da <vector162>:
.globl vector162
vector162:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $162
801073dc:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801073e1:	e9 be f3 ff ff       	jmp    801067a4 <alltraps>

801073e6 <vector163>:
.globl vector163
vector163:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $163
801073e8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073ed:	e9 b2 f3 ff ff       	jmp    801067a4 <alltraps>

801073f2 <vector164>:
.globl vector164
vector164:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $164
801073f4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073f9:	e9 a6 f3 ff ff       	jmp    801067a4 <alltraps>

801073fe <vector165>:
.globl vector165
vector165:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $165
80107400:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107405:	e9 9a f3 ff ff       	jmp    801067a4 <alltraps>

8010740a <vector166>:
.globl vector166
vector166:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $166
8010740c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107411:	e9 8e f3 ff ff       	jmp    801067a4 <alltraps>

80107416 <vector167>:
.globl vector167
vector167:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $167
80107418:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010741d:	e9 82 f3 ff ff       	jmp    801067a4 <alltraps>

80107422 <vector168>:
.globl vector168
vector168:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $168
80107424:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107429:	e9 76 f3 ff ff       	jmp    801067a4 <alltraps>

8010742e <vector169>:
.globl vector169
vector169:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $169
80107430:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107435:	e9 6a f3 ff ff       	jmp    801067a4 <alltraps>

8010743a <vector170>:
.globl vector170
vector170:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $170
8010743c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107441:	e9 5e f3 ff ff       	jmp    801067a4 <alltraps>

80107446 <vector171>:
.globl vector171
vector171:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $171
80107448:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010744d:	e9 52 f3 ff ff       	jmp    801067a4 <alltraps>

80107452 <vector172>:
.globl vector172
vector172:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $172
80107454:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107459:	e9 46 f3 ff ff       	jmp    801067a4 <alltraps>

8010745e <vector173>:
.globl vector173
vector173:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $173
80107460:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107465:	e9 3a f3 ff ff       	jmp    801067a4 <alltraps>

8010746a <vector174>:
.globl vector174
vector174:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $174
8010746c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107471:	e9 2e f3 ff ff       	jmp    801067a4 <alltraps>

80107476 <vector175>:
.globl vector175
vector175:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $175
80107478:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010747d:	e9 22 f3 ff ff       	jmp    801067a4 <alltraps>

80107482 <vector176>:
.globl vector176
vector176:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $176
80107484:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107489:	e9 16 f3 ff ff       	jmp    801067a4 <alltraps>

8010748e <vector177>:
.globl vector177
vector177:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $177
80107490:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107495:	e9 0a f3 ff ff       	jmp    801067a4 <alltraps>

8010749a <vector178>:
.globl vector178
vector178:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $178
8010749c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801074a1:	e9 fe f2 ff ff       	jmp    801067a4 <alltraps>

801074a6 <vector179>:
.globl vector179
vector179:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $179
801074a8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074ad:	e9 f2 f2 ff ff       	jmp    801067a4 <alltraps>

801074b2 <vector180>:
.globl vector180
vector180:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $180
801074b4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074b9:	e9 e6 f2 ff ff       	jmp    801067a4 <alltraps>

801074be <vector181>:
.globl vector181
vector181:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $181
801074c0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074c5:	e9 da f2 ff ff       	jmp    801067a4 <alltraps>

801074ca <vector182>:
.globl vector182
vector182:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $182
801074cc:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801074d1:	e9 ce f2 ff ff       	jmp    801067a4 <alltraps>

801074d6 <vector183>:
.globl vector183
vector183:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $183
801074d8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801074dd:	e9 c2 f2 ff ff       	jmp    801067a4 <alltraps>

801074e2 <vector184>:
.globl vector184
vector184:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $184
801074e4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801074e9:	e9 b6 f2 ff ff       	jmp    801067a4 <alltraps>

801074ee <vector185>:
.globl vector185
vector185:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $185
801074f0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074f5:	e9 aa f2 ff ff       	jmp    801067a4 <alltraps>

801074fa <vector186>:
.globl vector186
vector186:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $186
801074fc:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107501:	e9 9e f2 ff ff       	jmp    801067a4 <alltraps>

80107506 <vector187>:
.globl vector187
vector187:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $187
80107508:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010750d:	e9 92 f2 ff ff       	jmp    801067a4 <alltraps>

80107512 <vector188>:
.globl vector188
vector188:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $188
80107514:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107519:	e9 86 f2 ff ff       	jmp    801067a4 <alltraps>

8010751e <vector189>:
.globl vector189
vector189:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $189
80107520:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107525:	e9 7a f2 ff ff       	jmp    801067a4 <alltraps>

8010752a <vector190>:
.globl vector190
vector190:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $190
8010752c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107531:	e9 6e f2 ff ff       	jmp    801067a4 <alltraps>

80107536 <vector191>:
.globl vector191
vector191:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $191
80107538:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010753d:	e9 62 f2 ff ff       	jmp    801067a4 <alltraps>

80107542 <vector192>:
.globl vector192
vector192:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $192
80107544:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107549:	e9 56 f2 ff ff       	jmp    801067a4 <alltraps>

8010754e <vector193>:
.globl vector193
vector193:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $193
80107550:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107555:	e9 4a f2 ff ff       	jmp    801067a4 <alltraps>

8010755a <vector194>:
.globl vector194
vector194:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $194
8010755c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107561:	e9 3e f2 ff ff       	jmp    801067a4 <alltraps>

80107566 <vector195>:
.globl vector195
vector195:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $195
80107568:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010756d:	e9 32 f2 ff ff       	jmp    801067a4 <alltraps>

80107572 <vector196>:
.globl vector196
vector196:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $196
80107574:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107579:	e9 26 f2 ff ff       	jmp    801067a4 <alltraps>

8010757e <vector197>:
.globl vector197
vector197:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $197
80107580:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107585:	e9 1a f2 ff ff       	jmp    801067a4 <alltraps>

8010758a <vector198>:
.globl vector198
vector198:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $198
8010758c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107591:	e9 0e f2 ff ff       	jmp    801067a4 <alltraps>

80107596 <vector199>:
.globl vector199
vector199:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $199
80107598:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010759d:	e9 02 f2 ff ff       	jmp    801067a4 <alltraps>

801075a2 <vector200>:
.globl vector200
vector200:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $200
801075a4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075a9:	e9 f6 f1 ff ff       	jmp    801067a4 <alltraps>

801075ae <vector201>:
.globl vector201
vector201:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $201
801075b0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075b5:	e9 ea f1 ff ff       	jmp    801067a4 <alltraps>

801075ba <vector202>:
.globl vector202
vector202:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $202
801075bc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075c1:	e9 de f1 ff ff       	jmp    801067a4 <alltraps>

801075c6 <vector203>:
.globl vector203
vector203:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $203
801075c8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801075cd:	e9 d2 f1 ff ff       	jmp    801067a4 <alltraps>

801075d2 <vector204>:
.globl vector204
vector204:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $204
801075d4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801075d9:	e9 c6 f1 ff ff       	jmp    801067a4 <alltraps>

801075de <vector205>:
.globl vector205
vector205:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $205
801075e0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801075e5:	e9 ba f1 ff ff       	jmp    801067a4 <alltraps>

801075ea <vector206>:
.globl vector206
vector206:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $206
801075ec:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075f1:	e9 ae f1 ff ff       	jmp    801067a4 <alltraps>

801075f6 <vector207>:
.globl vector207
vector207:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $207
801075f8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801075fd:	e9 a2 f1 ff ff       	jmp    801067a4 <alltraps>

80107602 <vector208>:
.globl vector208
vector208:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $208
80107604:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107609:	e9 96 f1 ff ff       	jmp    801067a4 <alltraps>

8010760e <vector209>:
.globl vector209
vector209:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $209
80107610:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107615:	e9 8a f1 ff ff       	jmp    801067a4 <alltraps>

8010761a <vector210>:
.globl vector210
vector210:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $210
8010761c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107621:	e9 7e f1 ff ff       	jmp    801067a4 <alltraps>

80107626 <vector211>:
.globl vector211
vector211:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $211
80107628:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010762d:	e9 72 f1 ff ff       	jmp    801067a4 <alltraps>

80107632 <vector212>:
.globl vector212
vector212:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $212
80107634:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107639:	e9 66 f1 ff ff       	jmp    801067a4 <alltraps>

8010763e <vector213>:
.globl vector213
vector213:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $213
80107640:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107645:	e9 5a f1 ff ff       	jmp    801067a4 <alltraps>

8010764a <vector214>:
.globl vector214
vector214:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $214
8010764c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107651:	e9 4e f1 ff ff       	jmp    801067a4 <alltraps>

80107656 <vector215>:
.globl vector215
vector215:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $215
80107658:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010765d:	e9 42 f1 ff ff       	jmp    801067a4 <alltraps>

80107662 <vector216>:
.globl vector216
vector216:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $216
80107664:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107669:	e9 36 f1 ff ff       	jmp    801067a4 <alltraps>

8010766e <vector217>:
.globl vector217
vector217:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $217
80107670:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107675:	e9 2a f1 ff ff       	jmp    801067a4 <alltraps>

8010767a <vector218>:
.globl vector218
vector218:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $218
8010767c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107681:	e9 1e f1 ff ff       	jmp    801067a4 <alltraps>

80107686 <vector219>:
.globl vector219
vector219:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $219
80107688:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010768d:	e9 12 f1 ff ff       	jmp    801067a4 <alltraps>

80107692 <vector220>:
.globl vector220
vector220:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $220
80107694:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107699:	e9 06 f1 ff ff       	jmp    801067a4 <alltraps>

8010769e <vector221>:
.globl vector221
vector221:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $221
801076a0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076a5:	e9 fa f0 ff ff       	jmp    801067a4 <alltraps>

801076aa <vector222>:
.globl vector222
vector222:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $222
801076ac:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076b1:	e9 ee f0 ff ff       	jmp    801067a4 <alltraps>

801076b6 <vector223>:
.globl vector223
vector223:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $223
801076b8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076bd:	e9 e2 f0 ff ff       	jmp    801067a4 <alltraps>

801076c2 <vector224>:
.globl vector224
vector224:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $224
801076c4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801076c9:	e9 d6 f0 ff ff       	jmp    801067a4 <alltraps>

801076ce <vector225>:
.globl vector225
vector225:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $225
801076d0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801076d5:	e9 ca f0 ff ff       	jmp    801067a4 <alltraps>

801076da <vector226>:
.globl vector226
vector226:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $226
801076dc:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801076e1:	e9 be f0 ff ff       	jmp    801067a4 <alltraps>

801076e6 <vector227>:
.globl vector227
vector227:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $227
801076e8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076ed:	e9 b2 f0 ff ff       	jmp    801067a4 <alltraps>

801076f2 <vector228>:
.globl vector228
vector228:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $228
801076f4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076f9:	e9 a6 f0 ff ff       	jmp    801067a4 <alltraps>

801076fe <vector229>:
.globl vector229
vector229:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $229
80107700:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107705:	e9 9a f0 ff ff       	jmp    801067a4 <alltraps>

8010770a <vector230>:
.globl vector230
vector230:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $230
8010770c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107711:	e9 8e f0 ff ff       	jmp    801067a4 <alltraps>

80107716 <vector231>:
.globl vector231
vector231:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $231
80107718:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010771d:	e9 82 f0 ff ff       	jmp    801067a4 <alltraps>

80107722 <vector232>:
.globl vector232
vector232:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $232
80107724:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107729:	e9 76 f0 ff ff       	jmp    801067a4 <alltraps>

8010772e <vector233>:
.globl vector233
vector233:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $233
80107730:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107735:	e9 6a f0 ff ff       	jmp    801067a4 <alltraps>

8010773a <vector234>:
.globl vector234
vector234:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $234
8010773c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107741:	e9 5e f0 ff ff       	jmp    801067a4 <alltraps>

80107746 <vector235>:
.globl vector235
vector235:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $235
80107748:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010774d:	e9 52 f0 ff ff       	jmp    801067a4 <alltraps>

80107752 <vector236>:
.globl vector236
vector236:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $236
80107754:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107759:	e9 46 f0 ff ff       	jmp    801067a4 <alltraps>

8010775e <vector237>:
.globl vector237
vector237:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $237
80107760:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107765:	e9 3a f0 ff ff       	jmp    801067a4 <alltraps>

8010776a <vector238>:
.globl vector238
vector238:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $238
8010776c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107771:	e9 2e f0 ff ff       	jmp    801067a4 <alltraps>

80107776 <vector239>:
.globl vector239
vector239:
  pushl $0
80107776:	6a 00                	push   $0x0
  pushl $239
80107778:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010777d:	e9 22 f0 ff ff       	jmp    801067a4 <alltraps>

80107782 <vector240>:
.globl vector240
vector240:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $240
80107784:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107789:	e9 16 f0 ff ff       	jmp    801067a4 <alltraps>

8010778e <vector241>:
.globl vector241
vector241:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $241
80107790:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107795:	e9 0a f0 ff ff       	jmp    801067a4 <alltraps>

8010779a <vector242>:
.globl vector242
vector242:
  pushl $0
8010779a:	6a 00                	push   $0x0
  pushl $242
8010779c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801077a1:	e9 fe ef ff ff       	jmp    801067a4 <alltraps>

801077a6 <vector243>:
.globl vector243
vector243:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $243
801077a8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077ad:	e9 f2 ef ff ff       	jmp    801067a4 <alltraps>

801077b2 <vector244>:
.globl vector244
vector244:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $244
801077b4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077b9:	e9 e6 ef ff ff       	jmp    801067a4 <alltraps>

801077be <vector245>:
.globl vector245
vector245:
  pushl $0
801077be:	6a 00                	push   $0x0
  pushl $245
801077c0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077c5:	e9 da ef ff ff       	jmp    801067a4 <alltraps>

801077ca <vector246>:
.globl vector246
vector246:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $246
801077cc:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801077d1:	e9 ce ef ff ff       	jmp    801067a4 <alltraps>

801077d6 <vector247>:
.globl vector247
vector247:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $247
801077d8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801077dd:	e9 c2 ef ff ff       	jmp    801067a4 <alltraps>

801077e2 <vector248>:
.globl vector248
vector248:
  pushl $0
801077e2:	6a 00                	push   $0x0
  pushl $248
801077e4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801077e9:	e9 b6 ef ff ff       	jmp    801067a4 <alltraps>

801077ee <vector249>:
.globl vector249
vector249:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $249
801077f0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077f5:	e9 aa ef ff ff       	jmp    801067a4 <alltraps>

801077fa <vector250>:
.globl vector250
vector250:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $250
801077fc:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107801:	e9 9e ef ff ff       	jmp    801067a4 <alltraps>

80107806 <vector251>:
.globl vector251
vector251:
  pushl $0
80107806:	6a 00                	push   $0x0
  pushl $251
80107808:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010780d:	e9 92 ef ff ff       	jmp    801067a4 <alltraps>

80107812 <vector252>:
.globl vector252
vector252:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $252
80107814:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107819:	e9 86 ef ff ff       	jmp    801067a4 <alltraps>

8010781e <vector253>:
.globl vector253
vector253:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $253
80107820:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107825:	e9 7a ef ff ff       	jmp    801067a4 <alltraps>

8010782a <vector254>:
.globl vector254
vector254:
  pushl $0
8010782a:	6a 00                	push   $0x0
  pushl $254
8010782c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107831:	e9 6e ef ff ff       	jmp    801067a4 <alltraps>

80107836 <vector255>:
.globl vector255
vector255:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $255
80107838:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010783d:	e9 62 ef ff ff       	jmp    801067a4 <alltraps>
	...

80107844 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010784a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010784d:	48                   	dec    %eax
8010784e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107852:	8b 45 08             	mov    0x8(%ebp),%eax
80107855:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107859:	8b 45 08             	mov    0x8(%ebp),%eax
8010785c:	c1 e8 10             	shr    $0x10,%eax
8010785f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107863:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107866:	0f 01 10             	lgdtl  (%eax)
}
80107869:	c9                   	leave  
8010786a:	c3                   	ret    

8010786b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010786b:	55                   	push   %ebp
8010786c:	89 e5                	mov    %esp,%ebp
8010786e:	83 ec 04             	sub    $0x4,%esp
80107871:	8b 45 08             	mov    0x8(%ebp),%eax
80107874:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107878:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010787b:	0f 00 d8             	ltr    %ax
}
8010787e:	c9                   	leave  
8010787f:	c3                   	ret    

80107880 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107883:	8b 45 08             	mov    0x8(%ebp),%eax
80107886:	0f 22 d8             	mov    %eax,%cr3
}
80107889:	5d                   	pop    %ebp
8010788a:	c3                   	ret    

8010788b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010788b:	55                   	push   %ebp
8010788c:	89 e5                	mov    %esp,%ebp
8010788e:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107891:	e8 70 cc ff ff       	call   80104506 <cpuid>
80107896:	89 c2                	mov    %eax,%edx
80107898:	89 d0                	mov    %edx,%eax
8010789a:	c1 e0 02             	shl    $0x2,%eax
8010789d:	01 d0                	add    %edx,%eax
8010789f:	01 c0                	add    %eax,%eax
801078a1:	01 d0                	add    %edx,%eax
801078a3:	c1 e0 04             	shl    $0x4,%eax
801078a6:	05 a0 39 11 80       	add    $0x801139a0,%eax
801078ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b1:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801078b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ba:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801078c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c3:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ca:	8a 50 7d             	mov    0x7d(%eax),%dl
801078cd:	83 e2 f0             	and    $0xfffffff0,%edx
801078d0:	83 ca 0a             	or     $0xa,%edx
801078d3:	88 50 7d             	mov    %dl,0x7d(%eax)
801078d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d9:	8a 50 7d             	mov    0x7d(%eax),%dl
801078dc:	83 ca 10             	or     $0x10,%edx
801078df:	88 50 7d             	mov    %dl,0x7d(%eax)
801078e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e5:	8a 50 7d             	mov    0x7d(%eax),%dl
801078e8:	83 e2 9f             	and    $0xffffff9f,%edx
801078eb:	88 50 7d             	mov    %dl,0x7d(%eax)
801078ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f1:	8a 50 7d             	mov    0x7d(%eax),%dl
801078f4:	83 ca 80             	or     $0xffffff80,%edx
801078f7:	88 50 7d             	mov    %dl,0x7d(%eax)
801078fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fd:	8a 50 7e             	mov    0x7e(%eax),%dl
80107900:	83 ca 0f             	or     $0xf,%edx
80107903:	88 50 7e             	mov    %dl,0x7e(%eax)
80107906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107909:	8a 50 7e             	mov    0x7e(%eax),%dl
8010790c:	83 e2 ef             	and    $0xffffffef,%edx
8010790f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107915:	8a 50 7e             	mov    0x7e(%eax),%dl
80107918:	83 e2 df             	and    $0xffffffdf,%edx
8010791b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010791e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107921:	8a 50 7e             	mov    0x7e(%eax),%dl
80107924:	83 ca 40             	or     $0x40,%edx
80107927:	88 50 7e             	mov    %dl,0x7e(%eax)
8010792a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107930:	83 ca 80             	or     $0xffffff80,%edx
80107933:	88 50 7e             	mov    %dl,0x7e(%eax)
80107936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107939:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010793d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107940:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107947:	ff ff 
80107949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794c:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107953:	00 00 
80107955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107958:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010795f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107962:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107968:	83 e2 f0             	and    $0xfffffff0,%edx
8010796b:	83 ca 02             	or     $0x2,%edx
8010796e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107977:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010797d:	83 ca 10             	or     $0x10,%edx
80107980:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107989:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010798f:	83 e2 9f             	and    $0xffffff9f,%edx
80107992:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799b:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801079a1:	83 ca 80             	or     $0xffffff80,%edx
801079a4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801079b3:	83 ca 0f             	or     $0xf,%edx
801079b6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bf:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801079c5:	83 e2 ef             	and    $0xffffffef,%edx
801079c8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d1:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801079d7:	83 e2 df             	and    $0xffffffdf,%edx
801079da:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e3:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801079e9:	83 ca 40             	or     $0x40,%edx
801079ec:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f5:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801079fb:	83 ca 80             	or     $0xffffff80,%edx
801079fe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a07:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a11:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107a18:	ff ff 
80107a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1d:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107a24:	00 00 
80107a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a29:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a33:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107a39:	83 e2 f0             	and    $0xfffffff0,%edx
80107a3c:	83 ca 0a             	or     $0xa,%edx
80107a3f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a48:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107a4e:	83 ca 10             	or     $0x10,%edx
80107a51:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5a:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107a60:	83 ca 60             	or     $0x60,%edx
80107a63:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107a72:	83 ca 80             	or     $0xffffff80,%edx
80107a75:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7e:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107a84:	83 ca 0f             	or     $0xf,%edx
80107a87:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a90:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107a96:	83 e2 ef             	and    $0xffffffef,%edx
80107a99:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa2:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107aa8:	83 e2 df             	and    $0xffffffdf,%edx
80107aab:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab4:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107aba:	83 ca 40             	or     $0x40,%edx
80107abd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac6:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107acc:	83 ca 80             	or     $0xffffff80,%edx
80107acf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad8:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107ae9:	ff ff 
80107aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aee:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107af5:	00 00 
80107af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afa:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b04:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107b0a:	83 e2 f0             	and    $0xfffffff0,%edx
80107b0d:	83 ca 02             	or     $0x2,%edx
80107b10:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b19:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107b1f:	83 ca 10             	or     $0x10,%edx
80107b22:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107b31:	83 ca 60             	or     $0x60,%edx
80107b34:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3d:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107b43:	83 ca 80             	or     $0xffffff80,%edx
80107b46:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b55:	83 ca 0f             	or     $0xf,%edx
80107b58:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b61:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b67:	83 e2 ef             	and    $0xffffffef,%edx
80107b6a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b73:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b79:	83 e2 df             	and    $0xffffffdf,%edx
80107b7c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b85:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b8b:	83 ca 40             	or     $0x40,%edx
80107b8e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b97:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b9d:	83 ca 80             	or     $0xffffff80,%edx
80107ba0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba9:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb3:	83 c0 70             	add    $0x70,%eax
80107bb6:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107bbd:	00 
80107bbe:	89 04 24             	mov    %eax,(%esp)
80107bc1:	e8 7e fc ff ff       	call   80107844 <lgdt>
}
80107bc6:	c9                   	leave  
80107bc7:	c3                   	ret    

80107bc8 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107bc8:	55                   	push   %ebp
80107bc9:	89 e5                	mov    %esp,%ebp
80107bcb:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107bce:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd1:	c1 e8 16             	shr    $0x16,%eax
80107bd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bde:	01 d0                	add    %edx,%eax
80107be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be6:	8b 00                	mov    (%eax),%eax
80107be8:	83 e0 01             	and    $0x1,%eax
80107beb:	85 c0                	test   %eax,%eax
80107bed:	74 14                	je     80107c03 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bf2:	8b 00                	mov    (%eax),%eax
80107bf4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bf9:	05 00 00 00 80       	add    $0x80000000,%eax
80107bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c01:	eb 48                	jmp    80107c4b <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c07:	74 0e                	je     80107c17 <walkpgdir+0x4f>
80107c09:	e8 01 b4 ff ff       	call   8010300f <kalloc>
80107c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c15:	75 07                	jne    80107c1e <walkpgdir+0x56>
      return 0;
80107c17:	b8 00 00 00 00       	mov    $0x0,%eax
80107c1c:	eb 44                	jmp    80107c62 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c25:	00 
80107c26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c2d:	00 
80107c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c31:	89 04 24             	mov    %eax,(%esp)
80107c34:	e8 09 d8 ff ff       	call   80105442 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3c:	05 00 00 00 80       	add    $0x80000000,%eax
80107c41:	83 c8 07             	or     $0x7,%eax
80107c44:	89 c2                	mov    %eax,%edx
80107c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c49:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c4e:	c1 e8 0c             	shr    $0xc,%eax
80107c51:	25 ff 03 00 00       	and    $0x3ff,%eax
80107c56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c60:	01 d0                	add    %edx,%eax
}
80107c62:	c9                   	leave  
80107c63:	c3                   	ret    

80107c64 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c64:	55                   	push   %ebp
80107c65:	89 e5                	mov    %esp,%ebp
80107c67:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107c75:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c78:	8b 45 10             	mov    0x10(%ebp),%eax
80107c7b:	01 d0                	add    %edx,%eax
80107c7d:	48                   	dec    %eax
80107c7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c86:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107c8d:	00 
80107c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c91:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c95:	8b 45 08             	mov    0x8(%ebp),%eax
80107c98:	89 04 24             	mov    %eax,(%esp)
80107c9b:	e8 28 ff ff ff       	call   80107bc8 <walkpgdir>
80107ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ca7:	75 07                	jne    80107cb0 <mappages+0x4c>
      return -1;
80107ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cae:	eb 48                	jmp    80107cf8 <mappages+0x94>
    if(*pte & PTE_P)
80107cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cb3:	8b 00                	mov    (%eax),%eax
80107cb5:	83 e0 01             	and    $0x1,%eax
80107cb8:	85 c0                	test   %eax,%eax
80107cba:	74 0c                	je     80107cc8 <mappages+0x64>
      panic("remap");
80107cbc:	c7 04 24 d8 8b 10 80 	movl   $0x80108bd8,(%esp)
80107cc3:	e8 8c 88 ff ff       	call   80100554 <panic>
    *pte = pa | perm | PTE_P;
80107cc8:	8b 45 18             	mov    0x18(%ebp),%eax
80107ccb:	0b 45 14             	or     0x14(%ebp),%eax
80107cce:	83 c8 01             	or     $0x1,%eax
80107cd1:	89 c2                	mov    %eax,%edx
80107cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cd6:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107cde:	75 08                	jne    80107ce8 <mappages+0x84>
      break;
80107ce0:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107ce1:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce6:	eb 10                	jmp    80107cf8 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107ce8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107cef:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107cf6:	eb 8e                	jmp    80107c86 <mappages+0x22>
  return 0;
}
80107cf8:	c9                   	leave  
80107cf9:	c3                   	ret    

80107cfa <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107cfa:	55                   	push   %ebp
80107cfb:	89 e5                	mov    %esp,%ebp
80107cfd:	53                   	push   %ebx
80107cfe:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d01:	e8 09 b3 ff ff       	call   8010300f <kalloc>
80107d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d0d:	75 0a                	jne    80107d19 <setupkvm+0x1f>
    return 0;
80107d0f:	b8 00 00 00 00       	mov    $0x0,%eax
80107d14:	e9 84 00 00 00       	jmp    80107d9d <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107d19:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d20:	00 
80107d21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d28:	00 
80107d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d2c:	89 04 24             	mov    %eax,(%esp)
80107d2f:	e8 0e d7 ff ff       	call   80105442 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d34:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107d3b:	eb 54                	jmp    80107d91 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d40:	8b 48 0c             	mov    0xc(%eax),%ecx
80107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d46:	8b 50 04             	mov    0x4(%eax),%edx
80107d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4c:	8b 58 08             	mov    0x8(%eax),%ebx
80107d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d52:	8b 40 04             	mov    0x4(%eax),%eax
80107d55:	29 c3                	sub    %eax,%ebx
80107d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5a:	8b 00                	mov    (%eax),%eax
80107d5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107d60:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d64:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d68:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d6f:	89 04 24             	mov    %eax,(%esp)
80107d72:	e8 ed fe ff ff       	call   80107c64 <mappages>
80107d77:	85 c0                	test   %eax,%eax
80107d79:	79 12                	jns    80107d8d <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d7e:	89 04 24             	mov    %eax,(%esp)
80107d81:	e8 1a 05 00 00       	call   801082a0 <freevm>
      return 0;
80107d86:	b8 00 00 00 00       	mov    $0x0,%eax
80107d8b:	eb 10                	jmp    80107d9d <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d8d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d91:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107d98:	72 a3                	jb     80107d3d <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
80107d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d9d:	83 c4 34             	add    $0x34,%esp
80107da0:	5b                   	pop    %ebx
80107da1:	5d                   	pop    %ebp
80107da2:	c3                   	ret    

80107da3 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107da3:	55                   	push   %ebp
80107da4:	89 e5                	mov    %esp,%ebp
80107da6:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107da9:	e8 4c ff ff ff       	call   80107cfa <setupkvm>
80107dae:	a3 c4 66 11 80       	mov    %eax,0x801166c4
  switchkvm();
80107db3:	e8 02 00 00 00       	call   80107dba <switchkvm>
}
80107db8:	c9                   	leave  
80107db9:	c3                   	ret    

80107dba <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107dba:	55                   	push   %ebp
80107dbb:	89 e5                	mov    %esp,%ebp
80107dbd:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dc0:	a1 c4 66 11 80       	mov    0x801166c4,%eax
80107dc5:	05 00 00 00 80       	add    $0x80000000,%eax
80107dca:	89 04 24             	mov    %eax,(%esp)
80107dcd:	e8 ae fa ff ff       	call   80107880 <lcr3>
}
80107dd2:	c9                   	leave  
80107dd3:	c3                   	ret    

80107dd4 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107dd4:	55                   	push   %ebp
80107dd5:	89 e5                	mov    %esp,%ebp
80107dd7:	57                   	push   %edi
80107dd8:	56                   	push   %esi
80107dd9:	53                   	push   %ebx
80107dda:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107de1:	75 0c                	jne    80107def <switchuvm+0x1b>
    panic("switchuvm: no process");
80107de3:	c7 04 24 de 8b 10 80 	movl   $0x80108bde,(%esp)
80107dea:	e8 65 87 ff ff       	call   80100554 <panic>
  if(p->kstack == 0)
80107def:	8b 45 08             	mov    0x8(%ebp),%eax
80107df2:	8b 40 08             	mov    0x8(%eax),%eax
80107df5:	85 c0                	test   %eax,%eax
80107df7:	75 0c                	jne    80107e05 <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107df9:	c7 04 24 f4 8b 10 80 	movl   $0x80108bf4,(%esp)
80107e00:	e8 4f 87 ff ff       	call   80100554 <panic>
  if(p->pgdir == 0)
80107e05:	8b 45 08             	mov    0x8(%ebp),%eax
80107e08:	8b 40 04             	mov    0x4(%eax),%eax
80107e0b:	85 c0                	test   %eax,%eax
80107e0d:	75 0c                	jne    80107e1b <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107e0f:	c7 04 24 09 8c 10 80 	movl   $0x80108c09,(%esp)
80107e16:	e8 39 87 ff ff       	call   80100554 <panic>

  pushcli();
80107e1b:	e8 1e d5 ff ff       	call   8010533e <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e20:	e8 26 c7 ff ff       	call   8010454b <mycpu>
80107e25:	89 c3                	mov    %eax,%ebx
80107e27:	e8 1f c7 ff ff       	call   8010454b <mycpu>
80107e2c:	83 c0 08             	add    $0x8,%eax
80107e2f:	89 c6                	mov    %eax,%esi
80107e31:	e8 15 c7 ff ff       	call   8010454b <mycpu>
80107e36:	83 c0 08             	add    $0x8,%eax
80107e39:	c1 e8 10             	shr    $0x10,%eax
80107e3c:	89 c7                	mov    %eax,%edi
80107e3e:	e8 08 c7 ff ff       	call   8010454b <mycpu>
80107e43:	83 c0 08             	add    $0x8,%eax
80107e46:	c1 e8 18             	shr    $0x18,%eax
80107e49:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107e50:	67 00 
80107e52:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107e59:	89 f9                	mov    %edi,%ecx
80107e5b:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107e61:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107e67:	83 e2 f0             	and    $0xfffffff0,%edx
80107e6a:	83 ca 09             	or     $0x9,%edx
80107e6d:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e73:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107e79:	83 ca 10             	or     $0x10,%edx
80107e7c:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e82:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107e88:	83 e2 9f             	and    $0xffffff9f,%edx
80107e8b:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e91:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107e97:	83 ca 80             	or     $0xffffff80,%edx
80107e9a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107ea0:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ea6:	83 e2 f0             	and    $0xfffffff0,%edx
80107ea9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107eaf:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107eb5:	83 e2 ef             	and    $0xffffffef,%edx
80107eb8:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ebe:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ec4:	83 e2 df             	and    $0xffffffdf,%edx
80107ec7:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ecd:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ed3:	83 ca 40             	or     $0x40,%edx
80107ed6:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107edc:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107ee2:	83 e2 7f             	and    $0x7f,%edx
80107ee5:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107eeb:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107ef1:	e8 55 c6 ff ff       	call   8010454b <mycpu>
80107ef6:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107efc:	83 e2 ef             	and    $0xffffffef,%edx
80107eff:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f05:	e8 41 c6 ff ff       	call   8010454b <mycpu>
80107f0a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f10:	e8 36 c6 ff ff       	call   8010454b <mycpu>
80107f15:	8b 55 08             	mov    0x8(%ebp),%edx
80107f18:	8b 52 08             	mov    0x8(%edx),%edx
80107f1b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f21:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f24:	e8 22 c6 ff ff       	call   8010454b <mycpu>
80107f29:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107f2f:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107f36:	e8 30 f9 ff ff       	call   8010786b <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3e:	8b 40 04             	mov    0x4(%eax),%eax
80107f41:	05 00 00 00 80       	add    $0x80000000,%eax
80107f46:	89 04 24             	mov    %eax,(%esp)
80107f49:	e8 32 f9 ff ff       	call   80107880 <lcr3>
  popcli();
80107f4e:	e8 35 d4 ff ff       	call   80105388 <popcli>
}
80107f53:	83 c4 1c             	add    $0x1c,%esp
80107f56:	5b                   	pop    %ebx
80107f57:	5e                   	pop    %esi
80107f58:	5f                   	pop    %edi
80107f59:	5d                   	pop    %ebp
80107f5a:	c3                   	ret    

80107f5b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107f5b:	55                   	push   %ebp
80107f5c:	89 e5                	mov    %esp,%ebp
80107f5e:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107f61:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107f68:	76 0c                	jbe    80107f76 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107f6a:	c7 04 24 1d 8c 10 80 	movl   $0x80108c1d,(%esp)
80107f71:	e8 de 85 ff ff       	call   80100554 <panic>
  mem = kalloc();
80107f76:	e8 94 b0 ff ff       	call   8010300f <kalloc>
80107f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107f7e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f85:	00 
80107f86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f8d:	00 
80107f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f91:	89 04 24             	mov    %eax,(%esp)
80107f94:	e8 a9 d4 ff ff       	call   80105442 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9c:	05 00 00 00 80       	add    $0x80000000,%eax
80107fa1:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107fa8:	00 
80107fa9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107fad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fb4:	00 
80107fb5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fbc:	00 
80107fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc0:	89 04 24             	mov    %eax,(%esp)
80107fc3:	e8 9c fc ff ff       	call   80107c64 <mappages>
  memmove(mem, init, sz);
80107fc8:	8b 45 10             	mov    0x10(%ebp),%eax
80107fcb:	89 44 24 08          	mov    %eax,0x8(%esp)
80107fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd9:	89 04 24             	mov    %eax,(%esp)
80107fdc:	e8 2a d5 ff ff       	call   8010550b <memmove>
}
80107fe1:	c9                   	leave  
80107fe2:	c3                   	ret    

80107fe3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107fe3:	55                   	push   %ebp
80107fe4:	89 e5                	mov    %esp,%ebp
80107fe6:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fec:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ff1:	85 c0                	test   %eax,%eax
80107ff3:	74 0c                	je     80108001 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107ff5:	c7 04 24 38 8c 10 80 	movl   $0x80108c38,(%esp)
80107ffc:	e8 53 85 ff ff       	call   80100554 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108001:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108008:	e9 a6 00 00 00       	jmp    801080b3 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010800d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108010:	8b 55 0c             	mov    0xc(%ebp),%edx
80108013:	01 d0                	add    %edx,%eax
80108015:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010801c:	00 
8010801d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108021:	8b 45 08             	mov    0x8(%ebp),%eax
80108024:	89 04 24             	mov    %eax,(%esp)
80108027:	e8 9c fb ff ff       	call   80107bc8 <walkpgdir>
8010802c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010802f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108033:	75 0c                	jne    80108041 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80108035:	c7 04 24 5b 8c 10 80 	movl   $0x80108c5b,(%esp)
8010803c:	e8 13 85 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80108041:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108044:	8b 00                	mov    (%eax),%eax
80108046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010804b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	8b 55 18             	mov    0x18(%ebp),%edx
80108054:	29 c2                	sub    %eax,%edx
80108056:	89 d0                	mov    %edx,%eax
80108058:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010805d:	77 0f                	ja     8010806e <loaduvm+0x8b>
      n = sz - i;
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	8b 55 18             	mov    0x18(%ebp),%edx
80108065:	29 c2                	sub    %eax,%edx
80108067:	89 d0                	mov    %edx,%eax
80108069:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010806c:	eb 07                	jmp    80108075 <loaduvm+0x92>
    else
      n = PGSIZE;
8010806e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108078:	8b 55 14             	mov    0x14(%ebp),%edx
8010807b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010807e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108081:	05 00 00 00 80       	add    $0x80000000,%eax
80108086:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108089:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010808d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80108091:	89 44 24 04          	mov    %eax,0x4(%esp)
80108095:	8b 45 10             	mov    0x10(%ebp),%eax
80108098:	89 04 24             	mov    %eax,(%esp)
8010809b:	e8 d5 a1 ff ff       	call   80102275 <readi>
801080a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801080a3:	74 07                	je     801080ac <loaduvm+0xc9>
      return -1;
801080a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080aa:	eb 18                	jmp    801080c4 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801080ac:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b6:	3b 45 18             	cmp    0x18(%ebp),%eax
801080b9:	0f 82 4e ff ff ff    	jb     8010800d <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801080bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080c4:	c9                   	leave  
801080c5:	c3                   	ret    

801080c6 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080c6:	55                   	push   %ebp
801080c7:	89 e5                	mov    %esp,%ebp
801080c9:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801080cc:	8b 45 10             	mov    0x10(%ebp),%eax
801080cf:	85 c0                	test   %eax,%eax
801080d1:	79 0a                	jns    801080dd <allocuvm+0x17>
    return 0;
801080d3:	b8 00 00 00 00       	mov    $0x0,%eax
801080d8:	e9 fd 00 00 00       	jmp    801081da <allocuvm+0x114>
  if(newsz < oldsz)
801080dd:	8b 45 10             	mov    0x10(%ebp),%eax
801080e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080e3:	73 08                	jae    801080ed <allocuvm+0x27>
    return oldsz;
801080e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e8:	e9 ed 00 00 00       	jmp    801081da <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
801080ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f0:	05 ff 0f 00 00       	add    $0xfff,%eax
801080f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801080fd:	e9 c9 00 00 00       	jmp    801081cb <allocuvm+0x105>
    mem = kalloc();
80108102:	e8 08 af ff ff       	call   8010300f <kalloc>
80108107:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010810a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010810e:	75 2f                	jne    8010813f <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80108110:	c7 04 24 79 8c 10 80 	movl   $0x80108c79,(%esp)
80108117:	e8 a5 82 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010811c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010811f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108123:	8b 45 10             	mov    0x10(%ebp),%eax
80108126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010812a:	8b 45 08             	mov    0x8(%ebp),%eax
8010812d:	89 04 24             	mov    %eax,(%esp)
80108130:	e8 a7 00 00 00       	call   801081dc <deallocuvm>
      return 0;
80108135:	b8 00 00 00 00       	mov    $0x0,%eax
8010813a:	e9 9b 00 00 00       	jmp    801081da <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
8010813f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108146:	00 
80108147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010814e:	00 
8010814f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108152:	89 04 24             	mov    %eax,(%esp)
80108155:	e8 e8 d2 ff ff       	call   80105442 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010815a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010816d:	00 
8010816e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108172:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108179:	00 
8010817a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010817e:	8b 45 08             	mov    0x8(%ebp),%eax
80108181:	89 04 24             	mov    %eax,(%esp)
80108184:	e8 db fa ff ff       	call   80107c64 <mappages>
80108189:	85 c0                	test   %eax,%eax
8010818b:	79 37                	jns    801081c4 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
8010818d:	c7 04 24 91 8c 10 80 	movl   $0x80108c91,(%esp)
80108194:	e8 28 82 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108199:	8b 45 0c             	mov    0xc(%ebp),%eax
8010819c:	89 44 24 08          	mov    %eax,0x8(%esp)
801081a0:	8b 45 10             	mov    0x10(%ebp),%eax
801081a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801081a7:	8b 45 08             	mov    0x8(%ebp),%eax
801081aa:	89 04 24             	mov    %eax,(%esp)
801081ad:	e8 2a 00 00 00       	call   801081dc <deallocuvm>
      kfree(mem);
801081b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b5:	89 04 24             	mov    %eax,(%esp)
801081b8:	e8 bc ad ff ff       	call   80102f79 <kfree>
      return 0;
801081bd:	b8 00 00 00 00       	mov    $0x0,%eax
801081c2:	eb 16                	jmp    801081da <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801081c4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801081d1:	0f 82 2b ff ff ff    	jb     80108102 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801081d7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081da:	c9                   	leave  
801081db:	c3                   	ret    

801081dc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081dc:	55                   	push   %ebp
801081dd:	89 e5                	mov    %esp,%ebp
801081df:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801081e2:	8b 45 10             	mov    0x10(%ebp),%eax
801081e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081e8:	72 08                	jb     801081f2 <deallocuvm+0x16>
    return oldsz;
801081ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ed:	e9 ac 00 00 00       	jmp    8010829e <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
801081f2:	8b 45 10             	mov    0x10(%ebp),%eax
801081f5:	05 ff 0f 00 00       	add    $0xfff,%eax
801081fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108202:	e9 88 00 00 00       	jmp    8010828f <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108211:	00 
80108212:	89 44 24 04          	mov    %eax,0x4(%esp)
80108216:	8b 45 08             	mov    0x8(%ebp),%eax
80108219:	89 04 24             	mov    %eax,(%esp)
8010821c:	e8 a7 f9 ff ff       	call   80107bc8 <walkpgdir>
80108221:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108228:	75 14                	jne    8010823e <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010822a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822d:	c1 e8 16             	shr    $0x16,%eax
80108230:	40                   	inc    %eax
80108231:	c1 e0 16             	shl    $0x16,%eax
80108234:	2d 00 10 00 00       	sub    $0x1000,%eax
80108239:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010823c:	eb 4a                	jmp    80108288 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
8010823e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108241:	8b 00                	mov    (%eax),%eax
80108243:	83 e0 01             	and    $0x1,%eax
80108246:	85 c0                	test   %eax,%eax
80108248:	74 3e                	je     80108288 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
8010824a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010824d:	8b 00                	mov    (%eax),%eax
8010824f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108254:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825b:	75 0c                	jne    80108269 <deallocuvm+0x8d>
        panic("kfree");
8010825d:	c7 04 24 ad 8c 10 80 	movl   $0x80108cad,(%esp)
80108264:	e8 eb 82 ff ff       	call   80100554 <panic>
      char *v = P2V(pa);
80108269:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010826c:	05 00 00 00 80       	add    $0x80000000,%eax
80108271:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108274:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108277:	89 04 24             	mov    %eax,(%esp)
8010827a:	e8 fa ac ff ff       	call   80102f79 <kfree>
      *pte = 0;
8010827f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108288:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010828f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108292:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108295:	0f 82 6c ff ff ff    	jb     80108207 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010829b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010829e:	c9                   	leave  
8010829f:	c3                   	ret    

801082a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801082a0:	55                   	push   %ebp
801082a1:	89 e5                	mov    %esp,%ebp
801082a3:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801082a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801082aa:	75 0c                	jne    801082b8 <freevm+0x18>
    panic("freevm: no pgdir");
801082ac:	c7 04 24 b3 8c 10 80 	movl   $0x80108cb3,(%esp)
801082b3:	e8 9c 82 ff ff       	call   80100554 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801082b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082bf:	00 
801082c0:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801082c7:	80 
801082c8:	8b 45 08             	mov    0x8(%ebp),%eax
801082cb:	89 04 24             	mov    %eax,(%esp)
801082ce:	e8 09 ff ff ff       	call   801081dc <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801082d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082da:	eb 44                	jmp    80108320 <freevm+0x80>
    if(pgdir[i] & PTE_P){
801082dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082e6:	8b 45 08             	mov    0x8(%ebp),%eax
801082e9:	01 d0                	add    %edx,%eax
801082eb:	8b 00                	mov    (%eax),%eax
801082ed:	83 e0 01             	and    $0x1,%eax
801082f0:	85 c0                	test   %eax,%eax
801082f2:	74 29                	je     8010831d <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801082f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082fe:	8b 45 08             	mov    0x8(%ebp),%eax
80108301:	01 d0                	add    %edx,%eax
80108303:	8b 00                	mov    (%eax),%eax
80108305:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010830a:	05 00 00 00 80       	add    $0x80000000,%eax
8010830f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108315:	89 04 24             	mov    %eax,(%esp)
80108318:	e8 5c ac ff ff       	call   80102f79 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010831d:	ff 45 f4             	incl   -0xc(%ebp)
80108320:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108327:	76 b3                	jbe    801082dc <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108329:	8b 45 08             	mov    0x8(%ebp),%eax
8010832c:	89 04 24             	mov    %eax,(%esp)
8010832f:	e8 45 ac ff ff       	call   80102f79 <kfree>
}
80108334:	c9                   	leave  
80108335:	c3                   	ret    

80108336 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108336:	55                   	push   %ebp
80108337:	89 e5                	mov    %esp,%ebp
80108339:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010833c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108343:	00 
80108344:	8b 45 0c             	mov    0xc(%ebp),%eax
80108347:	89 44 24 04          	mov    %eax,0x4(%esp)
8010834b:	8b 45 08             	mov    0x8(%ebp),%eax
8010834e:	89 04 24             	mov    %eax,(%esp)
80108351:	e8 72 f8 ff ff       	call   80107bc8 <walkpgdir>
80108356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010835d:	75 0c                	jne    8010836b <clearpteu+0x35>
    panic("clearpteu");
8010835f:	c7 04 24 c4 8c 10 80 	movl   $0x80108cc4,(%esp)
80108366:	e8 e9 81 ff ff       	call   80100554 <panic>
  *pte &= ~PTE_U;
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	8b 00                	mov    (%eax),%eax
80108370:	83 e0 fb             	and    $0xfffffffb,%eax
80108373:	89 c2                	mov    %eax,%edx
80108375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108378:	89 10                	mov    %edx,(%eax)
}
8010837a:	c9                   	leave  
8010837b:	c3                   	ret    

8010837c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010837c:	55                   	push   %ebp
8010837d:	89 e5                	mov    %esp,%ebp
8010837f:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108382:	e8 73 f9 ff ff       	call   80107cfa <setupkvm>
80108387:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010838a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010838e:	75 0a                	jne    8010839a <copyuvm+0x1e>
    return 0;
80108390:	b8 00 00 00 00       	mov    $0x0,%eax
80108395:	e9 f8 00 00 00       	jmp    80108492 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
8010839a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083a1:	e9 cb 00 00 00       	jmp    80108471 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801083a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083b0:	00 
801083b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801083b5:	8b 45 08             	mov    0x8(%ebp),%eax
801083b8:	89 04 24             	mov    %eax,(%esp)
801083bb:	e8 08 f8 ff ff       	call   80107bc8 <walkpgdir>
801083c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083c7:	75 0c                	jne    801083d5 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
801083c9:	c7 04 24 ce 8c 10 80 	movl   $0x80108cce,(%esp)
801083d0:	e8 7f 81 ff ff       	call   80100554 <panic>
    if(!(*pte & PTE_P))
801083d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083d8:	8b 00                	mov    (%eax),%eax
801083da:	83 e0 01             	and    $0x1,%eax
801083dd:	85 c0                	test   %eax,%eax
801083df:	75 0c                	jne    801083ed <copyuvm+0x71>
      panic("copyuvm: page not present");
801083e1:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
801083e8:	e8 67 81 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
801083ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083f0:	8b 00                	mov    (%eax),%eax
801083f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801083fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083fd:	8b 00                	mov    (%eax),%eax
801083ff:	25 ff 0f 00 00       	and    $0xfff,%eax
80108404:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108407:	e8 03 ac ff ff       	call   8010300f <kalloc>
8010840c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010840f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108413:	75 02                	jne    80108417 <copyuvm+0x9b>
      goto bad;
80108415:	eb 6b                	jmp    80108482 <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108417:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010841a:	05 00 00 00 80       	add    $0x80000000,%eax
8010841f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108426:	00 
80108427:	89 44 24 04          	mov    %eax,0x4(%esp)
8010842b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010842e:	89 04 24             	mov    %eax,(%esp)
80108431:	e8 d5 d0 ff ff       	call   8010550b <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108439:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010843c:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108445:	89 54 24 10          	mov    %edx,0x10(%esp)
80108449:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010844d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108454:	00 
80108455:	89 44 24 04          	mov    %eax,0x4(%esp)
80108459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010845c:	89 04 24             	mov    %eax,(%esp)
8010845f:	e8 00 f8 ff ff       	call   80107c64 <mappages>
80108464:	85 c0                	test   %eax,%eax
80108466:	79 02                	jns    8010846a <copyuvm+0xee>
      goto bad;
80108468:	eb 18                	jmp    80108482 <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010846a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108474:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108477:	0f 82 29 ff ff ff    	jb     801083a6 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
8010847d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108480:	eb 10                	jmp    80108492 <copyuvm+0x116>

bad:
  freevm(d);
80108482:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108485:	89 04 24             	mov    %eax,(%esp)
80108488:	e8 13 fe ff ff       	call   801082a0 <freevm>
  return 0;
8010848d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108492:	c9                   	leave  
80108493:	c3                   	ret    

80108494 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108494:	55                   	push   %ebp
80108495:	89 e5                	mov    %esp,%ebp
80108497:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010849a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084a1:	00 
801084a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801084a9:	8b 45 08             	mov    0x8(%ebp),%eax
801084ac:	89 04 24             	mov    %eax,(%esp)
801084af:	e8 14 f7 ff ff       	call   80107bc8 <walkpgdir>
801084b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801084b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ba:	8b 00                	mov    (%eax),%eax
801084bc:	83 e0 01             	and    $0x1,%eax
801084bf:	85 c0                	test   %eax,%eax
801084c1:	75 07                	jne    801084ca <uva2ka+0x36>
    return 0;
801084c3:	b8 00 00 00 00       	mov    $0x0,%eax
801084c8:	eb 22                	jmp    801084ec <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801084ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084cd:	8b 00                	mov    (%eax),%eax
801084cf:	83 e0 04             	and    $0x4,%eax
801084d2:	85 c0                	test   %eax,%eax
801084d4:	75 07                	jne    801084dd <uva2ka+0x49>
    return 0;
801084d6:	b8 00 00 00 00       	mov    $0x0,%eax
801084db:	eb 0f                	jmp    801084ec <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
801084dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e0:	8b 00                	mov    (%eax),%eax
801084e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084e7:	05 00 00 00 80       	add    $0x80000000,%eax
}
801084ec:	c9                   	leave  
801084ed:	c3                   	ret    

801084ee <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084ee:	55                   	push   %ebp
801084ef:	89 e5                	mov    %esp,%ebp
801084f1:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801084f4:	8b 45 10             	mov    0x10(%ebp),%eax
801084f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801084fa:	e9 87 00 00 00       	jmp    80108586 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801084ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80108502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108507:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010850a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108511:	8b 45 08             	mov    0x8(%ebp),%eax
80108514:	89 04 24             	mov    %eax,(%esp)
80108517:	e8 78 ff ff ff       	call   80108494 <uva2ka>
8010851c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010851f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108523:	75 07                	jne    8010852c <copyout+0x3e>
      return -1;
80108525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010852a:	eb 69                	jmp    80108595 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010852c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010852f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108532:	29 c2                	sub    %eax,%edx
80108534:	89 d0                	mov    %edx,%eax
80108536:	05 00 10 00 00       	add    $0x1000,%eax
8010853b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010853e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108541:	3b 45 14             	cmp    0x14(%ebp),%eax
80108544:	76 06                	jbe    8010854c <copyout+0x5e>
      n = len;
80108546:	8b 45 14             	mov    0x14(%ebp),%eax
80108549:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010854c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108552:	29 c2                	sub    %eax,%edx
80108554:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108557:	01 c2                	add    %eax,%edx
80108559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010855c:	89 44 24 08          	mov    %eax,0x8(%esp)
80108560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108563:	89 44 24 04          	mov    %eax,0x4(%esp)
80108567:	89 14 24             	mov    %edx,(%esp)
8010856a:	e8 9c cf ff ff       	call   8010550b <memmove>
    len -= n;
8010856f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108572:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108575:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108578:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010857b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010857e:	05 00 10 00 00       	add    $0x1000,%eax
80108583:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108586:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010858a:	0f 85 6f ff ff ff    	jne    801084ff <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108590:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108595:	c9                   	leave  
80108596:	c3                   	ret    
