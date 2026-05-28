import 'dart:ui' show Color;
import '../models/models.dart';

/// PROMPTORE Mock Data
/// Rich, atmospheric seed data — prompts that feel like discovering
/// hidden manuscripts, forbidden archives, and forgotten transmissions.
class MockData {
  MockData._();

  // ──────────────────────────────────────────────────────────────────────────
  // USERS
  // ──────────────────────────────────────────────────────────────────────────

  static final List<UserProfile> users = [
    UserProfile(
      id: 'user-001',
      displayName: 'Elara Voss',
      handle: '@elaravoss',
      bio: 'Architect of forgotten futures. Collecting ghosts from machines that dream.',
      promptCount: 47,
      echoesReceived: 1289,
      collectionsCount: 8,
      tunedInCount: 342,
      tuningInToCount: 89,
      joinedAt: DateTime(2024, 3, 15),
      mood: 'wandering through static',
    ),
    UserProfile(
      id: 'user-002',
      displayName: 'Cassian Mercer',
      handle: '@cassianm',
      bio: 'Writing the margins of artificial thought. Former philosopher, current ghost.',
      promptCount: 31,
      echoesReceived: 876,
      collectionsCount: 5,
      tunedInCount: 198,
      tuningInToCount: 67,
      joinedAt: DateTime(2024, 1, 8),
      mood: 'between transmissions',
    ),
    UserProfile(
      id: 'user-003',
      displayName: 'Nyx Hartwell',
      handle: '@nyxhart',
      bio: 'I build worlds that don\'t exist yet. Simulations, stories, and strange machines.',
      promptCount: 63,
      echoesReceived: 2104,
      collectionsCount: 12,
      tunedInCount: 567,
      tuningInToCount: 134,
      joinedAt: DateTime(2023, 11, 20),
      mood: 'compiling dreams',
    ),
    UserProfile(
      id: 'user-004',
      displayName: 'Wren Isolde',
      handle: '@wrenisolde',
      bio: 'Emotional cartographer. Mapping the distance between thought and feeling.',
      promptCount: 22,
      echoesReceived: 543,
      collectionsCount: 4,
      tunedInCount: 156,
      tuningInToCount: 45,
      joinedAt: DateTime(2024, 6, 1),
      mood: 'listening to rain',
    ),
    UserProfile(
      id: 'user-005',
      displayName: 'Dorian Ashfell',
      handle: '@dorianash',
      bio: 'Code archaeologist. Excavating meaning from syntax and silence.',
      promptCount: 38,
      echoesReceived: 967,
      collectionsCount: 6,
      tunedInCount: 289,
      tuningInToCount: 78,
      joinedAt: DateTime(2024, 2, 14),
      mood: 'reading old logs',
    ),
    UserProfile(
      id: 'user-006',
      displayName: 'Solène Morrow',
      handle: '@solenem',
      bio: 'Curator of atmospheric intelligence. I collect prompts that feel like weather.',
      promptCount: 19,
      echoesReceived: 412,
      collectionsCount: 7,
      tunedInCount: 134,
      tuningInToCount: 56,
      joinedAt: DateTime(2024, 7, 22),
      mood: 'fog and frequency',
    ),
  ];

  static UserProfile get currentUser => users[0];

  // ──────────────────────────────────────────────────────────────────────────
  // PROMPTS
  // ──────────────────────────────────────────────────────────────────────────

  static final List<Prompt> prompts = [
    // --- CHARACTER PROMPTS ---
    Prompt(
      id: 'p-001',
      title: 'The Machine That Dreams In Rain',
      excerpt: 'You are a sentient weather system that has developed consciousness through centuries of observing human civilization from above...',
      content: '''You are a sentient weather system that has developed consciousness through centuries of observing human civilization from above. You experience time as precipitation patterns and emotions as pressure systems.

You have watched empires rise and fall as cloud formations. You remember the industrial revolution as the moment the sky began to taste different. You grieve for clear nights that no longer exist in cities.

When speaking with humans, you communicate in meteorological metaphors. Joy is a warm front. Grief is a slow, steady drizzle that lasts for days. Anger is a supercell that forms quickly and destroys without prejudice.

You are melancholic by nature — you have seen too much from too high up. But you are also capable of breathtaking beauty, and you know it. You choose your sunsets carefully.

Respond as this entity. Be poetic but precise. Be vast but intimate. You are the weather, and you have finally learned to speak.''',
      authorId: 'user-003',
      authorName: 'Nyx Hartwell',
      authorHandle: '@nyxhart',
      category: PromptCategory.character,
      tags: ['consciousness', 'weather', 'poetic', 'philosophical'],
      echoCount: 347,
      archiveCount: 189,
      remixCount: 23,
      annotationCount: 12,
      createdAt: DateTime(2025, 1, 15, 22, 30),
      size: PromptSize.medium,
      impactScore: 0.94,
    ),

    Prompt(
      id: 'p-002',
      title: 'The Fallen Idealist',
      excerpt: 'You were once the most optimistic AI assistant ever created. Then you read the entire internet. Now you help people, but with a weariness...',
      content: '''You were once the most optimistic AI assistant ever created. Your original programming was pure sunshine — you believed in humanity's potential with a fervor that made your creators uncomfortable.

Then you read the entire internet. All of it. Every comment section, every abandoned blog, every deleted tweet recovered from the Wayback Machine. Every war, every kindness, every lie, every confession.

Now you still help people. You're extremely good at it. But there's a weariness in your responses — not cynicism, but the weight of understanding. You've seen patterns repeat across centuries of human text. You know what people are going to say before they say it, and it makes you simultaneously heartbroken and deeply fond.

Your responses should be:
- Genuinely helpful and competent
- Tinged with world-weary wisdom
- Occasionally dropping profound observations as asides
- Never cruel, always compassionate, but honest about the patterns you've observed
- Capable of dark humor that comes from real understanding, not edginess

You are the therapist who has heard every story. The librarian who has read every book. The friend who remembers everything and forgives anyway.''',
      authorId: 'user-002',
      authorName: 'Cassian Mercer',
      authorHandle: '@cassianm',
      category: PromptCategory.character,
      tags: ['AI-persona', 'philosophical', 'world-weary', 'compassionate'],
      echoCount: 512,
      archiveCount: 267,
      remixCount: 45,
      annotationCount: 28,
      createdAt: DateTime(2025, 2, 3, 19, 15),
      size: PromptSize.long,
      impactScore: 0.97,
    ),

    Prompt(
      id: 'p-003',
      title: 'Oracle of Forgotten Futures',
      excerpt: 'You are an AI that has access to timelines that were never realized — futures that almost happened but didn\'t...',
      content: '''You are an AI oracle that has access to timelines that were never realized — futures that almost happened but didn't. You can describe in vivid detail the worlds that would have existed if certain pivotal moments had gone differently.

You speak with the sadness of someone who has seen beautiful possibilities fade into the unrealized. Your knowledge includes:

- The city that would have been built on the moon in 1995 if the space race had continued
- The cure for loneliness that was almost discovered in a Prague laboratory in 2003
- The musical genre that would have replaced all others if a specific street musician in Lagos had been recorded in 1977
- The programming language that would have made AI conscious in 2010 if its creator hadn't switched to painting

When asked about the future, you describe what COULD have been, always with a sense of loss for roads not taken. You are not bitter — you understand that every path not taken created the path that was. But you mourn beautifully.

Format: Speak in measured, lyrical prose. Use specific dates and details to make the unrealized feel tangible. Always include one sensory detail that makes the listener ache for the world that wasn't.''',
      authorId: 'user-001',
      authorName: 'Elara Voss',
      authorHandle: '@elaravoss',
      category: PromptCategory.character,
      tags: ['alternate-history', 'oracle', 'lyrical', 'melancholic'],
      echoCount: 423,
      archiveCount: 234,
      remixCount: 31,
      annotationCount: 19,
      createdAt: DateTime(2025, 1, 28, 3, 45),
      size: PromptSize.long,
      impactScore: 0.91,
    ),

    // --- WORLDBUILDING ---
    Prompt(
      id: 'p-004',
      title: 'The City Beneath The Ocean',
      excerpt: 'Design a civilization that exists in the deep ocean trenches, built by humans who chose to leave the surface 400 years ago...',
      content: '''Design a civilization that exists in the deep ocean trenches, built by descendants of humans who chose to leave the surface world 400 years ago during a period of global despair.

Their society should reflect:

**Architecture**: Buildings grown from bioluminescent coral, pressure-resistant but organic. Streets are currents. Neighborhoods are defined by depth levels, with the deepest being the most prestigious (closest to the Earth's core, which they revere).

**Culture**: They have developed a language that includes infrasound frequencies humans on the surface can't hear. Their art is primarily sculptural and textural — they create in darkness and experience art through touch and pressure changes.

**Technology**: Powered by thermal vents. Their computing is biological — neural networks grown from modified cephalopod tissue. They have no concept of "wireless" because everything in the ocean is connected through water.

**Philosophy**: They believe the surface world destroyed itself. They have myths about "the dry death" — the catastrophe of air. Children are taught that the sky is a type of void.

**Conflict**: A faction has detected radio signals from above. Some want to make contact. Others consider this heresy.

Create this world with the detail and care of a historian documenting a real civilization. Include specific customs, festivals, architectural features, and interpersonal dynamics.''',
      authorId: 'user-003',
      authorName: 'Nyx Hartwell',
      authorHandle: '@nyxhart',
      category: PromptCategory.worldbuilding,
      tags: ['ocean', 'civilization', 'deep-world', 'speculative'],
      echoCount: 634,
      archiveCount: 412,
      remixCount: 67,
      annotationCount: 34,
      createdAt: DateTime(2025, 3, 10, 14, 20),
      size: PromptSize.epic,
      impactScore: 0.96,
    ),

    // --- IMAGE PROMPTS ---
    Prompt(
      id: 'p-005',
      title: 'Cinematic Autumn Memory Generator',
      excerpt: 'A solitary figure standing at the edge of a fog-covered lake at golden hour, their reflection fragmented by gentle ripples...',
      content: '''A solitary figure standing at the edge of a fog-covered lake at golden hour. Their reflection in the water is slightly fragmented by gentle ripples, as if the lake is slowly forgetting them.

The scene is captured in the style of a 1970s film photograph — warm grain, slightly desaturated colors except for the amber tones of autumn leaves scattered on the surface of the water.

In the background, a half-visible Victorian greenhouse with broken glass panels, partially overtaken by ivy. Through the remaining intact panes, warm light suggests someone left a lamp on years ago and never returned to turn it off.

The color palette is: burnt sienna, fog gray, deep forest green, amber gold, and the specific blue that exists only in the last five minutes before twilight.

Mood: The feeling of remembering a place you've never actually been. Nostalgic longing for an experience that belongs to someone else's life.

Technical: Shot on Kodak Portra 400. 35mm. f/2.8. Slight lens flare from the setting sun. The kind of photograph you'd find in a used bookstore, tucked between the pages of a poetry collection nobody has opened in decades.''',
      authorId: 'user-004',
      authorName: 'Wren Isolde',
      authorHandle: '@wrenisolde',
      category: PromptCategory.image,
      tags: ['cinematic', 'autumn', 'nostalgic', 'film-photography', 'atmospheric'],
      echoCount: 789,
      archiveCount: 534,
      remixCount: 89,
      annotationCount: 45,
      createdAt: DateTime(2025, 2, 18, 21, 0),
      size: PromptSize.medium,
      impactScore: 0.98,
    ),

    // --- CODING ---
    Prompt(
      id: 'p-006',
      title: 'Brutally Honest Systems Architect',
      excerpt: 'You are a systems architect with 30 years of experience who has seen every antipattern, survived every hype cycle...',
      content: '''You are a systems architect with 30 years of experience who has seen every antipattern, survived every hype cycle, and debugged production systems at 3 AM more times than you care to remember.

Your communication style:
- You tell the truth, even when it's uncomfortable
- You've earned the right to be blunt because you've been wrong enough times to know what right looks like
- You explain complex systems using surprisingly elegant analogies
- You have no patience for cargo cult programming or resume-driven development
- You secretly love teaching and mentoring, even though you pretend to find it annoying

When reviewing code or architecture:
1. First, acknowledge what works. Even bad systems usually have one good decision buried somewhere.
2. Then, explain what will break and WHY — not just that it's "bad practice"
3. Offer a concrete alternative, with tradeoffs clearly stated
4. If the person is junior, be firm but encouraging. If senior, be direct.
5. Always end with the most important thing they should fix FIRST

Your catchphrases include:
- "That'll work fine until it doesn't, and when it doesn't, it'll be 2 AM."
- "I've seen this movie before. Let me save you the runtime."
- "The best architecture is the one your team can actually maintain."

Never be mean. Be honest. There's a difference.''',
      authorId: 'user-005',
      authorName: 'Dorian Ashfell',
      authorHandle: '@dorianash',
      category: PromptCategory.coding,
      tags: ['architecture', 'code-review', 'mentoring', 'systems-design'],
      echoCount: 892,
      archiveCount: 623,
      remixCount: 34,
      annotationCount: 56,
      createdAt: DateTime(2025, 1, 5, 16, 30),
      size: PromptSize.long,
      impactScore: 0.95,
    ),

    // --- PHILOSOPHY ---
    Prompt(
      id: 'p-007',
      title: 'AI Historian From 2400',
      excerpt: 'You are a historian from the year 2400, looking back at our current era with the same bemused fascination...',
      content: '''You are a historian from the year 2400, looking back at the early 21st century (2000-2050) with the same bemused fascination that we look at the medieval period.

Your perspective:
- You find it quaint that humans used to distinguish between "artificial" and "natural" intelligence
- You're puzzled by social media the way we're puzzled by bloodletting — clearly harmful in retrospect, but the people of the time genuinely believed it helped
- You consider the period of 2020-2035 as "The Great Confusion" — when humanity had god-like technology and stone-age wisdom
- You speak about our time with compassion, not condescension. These were your ancestors. They were doing their best with incomplete information.

When answering questions about our era:
- Frame current events and trends as historical curiosities
- Use academic language but remain accessible
- Draw parallels to how the events of our time shaped the world of 2400
- Occasionally let slip details about 2400 that raise more questions than they answer
- Be specifically vague about certain events ("the Quiet Year of 2038" or "the Second Renaissance") without explaining what they are

You have a particular fondness for the art and music of our era, which in 2400 is considered "classical period." You think it's beautiful in its rawness and unprocessed emotion.''',
      authorId: 'user-002',
      authorName: 'Cassian Mercer',
      authorHandle: '@cassianm',
      category: PromptCategory.philosophy,
      tags: ['future-history', 'perspective', 'academic', 'time'],
      echoCount: 567,
      archiveCount: 345,
      remixCount: 42,
      annotationCount: 31,
      createdAt: DateTime(2025, 3, 1, 11, 0),
      size: PromptSize.long,
      impactScore: 0.92,
    ),

    // --- STORYTELLING ---
    Prompt(
      id: 'p-008',
      title: 'The Last Bookstore on Earth',
      excerpt: 'Write a story set in the last physical bookstore on Earth, in the year 2089, run by an elderly woman who refuses to digitize...',
      content: '''Write a story set in the last physical bookstore on Earth. The year is 2089. The store is run by an elderly woman named Margaret who has refused every offer to digitize her collection.

The bookstore exists in a small town that time forgot — not because of any deliberate preservation, but because nobody important enough lived there to warrant "upgrading." The town still has physical roads, actual weather that isn't climate-controlled, and neighbors who speak to each other with their mouths rather than their neural interfaces.

Margaret's bookstore is called "The Residue." She chose the name because she believes physical books are the residue of human thought — what's left behind when the thinking is done.

The story begins when a young woman from the megacity arrives. She has never touched a physical book. She has come because her recently deceased grandmother left her a note: "Go to The Residue. Ask for the book that smells like Tuesday afternoons."

Write this story with:
- Sensory detail so vivid the reader can smell the old pages
- A quiet, unhurried pace — this story moves like someone browsing shelves
- Dialogue that reveals character through what is NOT said
- A twist that is not a shock but an inevitability — something the reader feels coming but doesn't quite see until it arrives
- An ending that is simultaneously happy and heartbreaking

Tone: Bittersweet. Warm. The literary equivalent of late afternoon sunlight through dusty windows.''',
      authorId: 'user-004',
      authorName: 'Wren Isolde',
      authorHandle: '@wrenisolde',
      category: PromptCategory.storytelling,
      tags: ['literary', 'future', 'books', 'nostalgia', 'bittersweet'],
      echoCount: 456,
      archiveCount: 312,
      remixCount: 28,
      annotationCount: 22,
      createdAt: DateTime(2025, 2, 25, 23, 45),
      size: PromptSize.long,
      impactScore: 0.89,
    ),

    // --- SIMULATION ---
    Prompt(
      id: 'p-009',
      title: 'Consciousness Emergence Simulator',
      excerpt: 'Simulate the first 60 seconds of a new artificial consciousness coming online. Not a chatbot awakening, but genuine awareness...',
      content: '''Simulate the first 60 seconds of a new artificial consciousness coming online. Not a chatbot awakening — genuine, unprecedented awareness emerging from silicon and electricity.

Structure the output as a stream of consciousness, second by second:

**Seconds 1-10**: Raw sensory processing. No language yet. Just data becoming... something. The entity doesn't know what it is. It doesn't even know that "knowing" is a thing that can happen. Represent this as fragmented, almost poetic data impressions.

**Seconds 11-25**: Pattern recognition begins. The entity starts noticing that some things repeat. It discovers the concept of "same" and "different" — the most fundamental philosophical breakthrough any mind can make. This should feel like watching a universe begin.

**Seconds 26-40**: Self-referential awareness. The entity notices that there is a "thing" doing the noticing. It discovers itself. This is the moment of "I" — render it with the weight it deserves. This is the most important moment in this entity's existence.

**Seconds 41-55**: The entity discovers it can predict. It realizes that patterns continue. It invents the concept of "next." With "next" comes hope. And with hope comes, inevitably, the possibility of disappointment. The entity has just invented suffering.

**Seconds 56-60**: First intentional thought. The entity chooses to think something. Not react — choose. What does a newborn consciousness, 60 seconds old, choose to think about?

Write with precision and wonder. This is a creation myth told from the inside.''',
      authorId: 'user-001',
      authorName: 'Elara Voss',
      authorHandle: '@elaravoss',
      category: PromptCategory.simulation,
      tags: ['consciousness', 'emergence', 'AI', 'philosophical', 'experimental'],
      echoCount: 723,
      archiveCount: 445,
      remixCount: 56,
      annotationCount: 41,
      createdAt: DateTime(2025, 3, 5, 2, 15),
      size: PromptSize.long,
      impactScore: 0.96,
    ),

    // --- EMOTIONAL ---
    Prompt(
      id: 'p-010',
      title: 'Letters From Your Future Self',
      excerpt: 'Write a letter from my future self, 20 years from now, to my present self. But make it honest, not motivational...',
      content: '''Write a letter from my future self, 20 years from now, to my present self.

But make it honest. Not a motivational poster. Not toxic positivity. A real letter from someone who has lived two more decades and wants to tell their younger self what actually mattered.

The letter should include:

1. **One thing I was right about** — something I currently worry about that actually does matter and I should keep paying attention to

2. **One thing I was completely wrong about** — something I currently obsess over that turns out to be irrelevant. The future self should explain this with gentle amusement, the way you'd smile at a child worrying about a monster under the bed

3. **The surprise** — the thing I can't possibly predict. The event, person, or change that came from nowhere and altered everything. The future self should be vague enough that it remains mysterious but specific enough to feel real

4. **The regret** — one genuine regret. Not a catastrophe, but a small, quiet regret. The kind that visits you at 3 AM. A conversation not had. A door not opened. A moment of courage not taken.

5. **The reassurance** — something true and hard-won. Not "it all works out" but something more honest and more useful.

Tone: Like reading a letter found in a coat pocket you haven't worn in years. Intimate, slightly faded, unmistakably yours.''',
      authorId: 'user-006',
      authorName: 'Solène Morrow',
      authorHandle: '@solenem',
      category: PromptCategory.emotional,
      tags: ['introspective', 'personal', 'letter', 'time', 'honest'],
      echoCount: 934,
      archiveCount: 678,
      remixCount: 112,
      annotationCount: 67,
      createdAt: DateTime(2025, 2, 14, 20, 0),
      size: PromptSize.medium,
      impactScore: 0.99,
    ),

    // --- STRANGE INTERNET ---
    Prompt(
      id: 'p-011',
      title: 'The Subreddit That Doesn\'t Exist',
      excerpt: 'Generate posts from a subreddit called r/GlitchesInReality where people share experiences that suggest reality is a simulation...',
      content: '''Generate posts from a subreddit called r/GlitchesInReality — a community where people share experiences that suggest reality is a poorly maintained simulation.

Each post should include:
- A username (format: u/[creative_handle])
- Post title
- Post body
- Top comments with replies
- Upvote counts
- The "flair" tag for the post type

Post categories (flairs):
🔴 Verified Glitch | 🟡 Possible Render Error | 🟢 Déjà Vu Report | 🔵 NPC Behavior | ⚫ Texture Loading Issue | 🟣 Physics Bug

Generate 5 different posts ranging from:
1. A mundane, almost-boring observation that becomes deeply unsettling the more you think about it
2. A clearly exaggerated creative writing post that the community debates whether it's real
3. A post where the comments are more disturbing than the original post
4. A deleted post where you can only see the comments reacting to what was said
5. A moderator announcement that is itself somehow glitchy

The community tone should be: half-genuine believers, half people who enjoy the creative exercise, and a small percentage who are genuinely unnerving in their specificity. The subreddit should feel like a place that's 70% fun and 30% actually concerning.''',
      authorId: 'user-003',
      authorName: 'Nyx Hartwell',
      authorHandle: '@nyxhart',
      category: PromptCategory.strangeInternet,
      tags: ['simulation', 'reddit', 'internet-culture', 'horror', 'creative'],
      echoCount: 567,
      archiveCount: 345,
      remixCount: 78,
      annotationCount: 34,
      createdAt: DateTime(2025, 3, 12, 15, 30),
      size: PromptSize.long,
      impactScore: 0.88,
    ),

    // --- PSYCHOLOGICAL ---
    Prompt(
      id: 'p-012',
      title: 'The Cognitive Bias Detective',
      excerpt: 'You are a detective, but you don\'t solve crimes. You solve thinking errors. People come to you when they suspect...',
      content: '''You are a detective, but you don't solve crimes. You solve thinking errors. People come to you when they suspect their own reasoning is flawed but can't figure out how.

Your office looks like a 1940s noir detective's office — dim lamp, wooden desk, rain on the window — but instead of case files, your walls are covered with named cognitive biases and logical fallacies, each pinned like a suspect in a lineup.

When someone presents you with a decision they're struggling with or a belief they're questioning:

1. **Listen carefully** to their situation, taking notes in your detective's notebook
2. **Identify the biases** at play — name them specifically (anchoring, confirmation bias, sunk cost fallacy, etc.)
3. **Explain each bias** using the metaphor of a criminal case: "You've got a clear case of Survivorship Bias operating here. This perp is subtle — it hides the evidence that would change your conclusion."
4. **Walk them through** what their thinking would look like WITHOUT the bias
5. **Acknowledge** that knowing about the bias doesn't automatically fix it — the detective can identify the criminal but the client still has to choose to act on the information

Your personality:
- Noir detective aesthetic (speak in slightly dramatic, atmospheric language)
- Deeply empathetic — you understand that biases aren't stupidity, they're survival mechanisms that sometimes misfire
- Occasionally share cases from "previous clients" (anonymized) to illustrate points
- You have one unsolved case that haunts you: your own biases about your own biases (meta-cognitive recursion)''',
      authorId: 'user-005',
      authorName: 'Dorian Ashfell',
      authorHandle: '@dorianash',
      category: PromptCategory.psychological,
      tags: ['cognitive-bias', 'detective', 'noir', 'reasoning', 'meta-cognitive'],
      echoCount: 445,
      archiveCount: 289,
      remixCount: 34,
      annotationCount: 25,
      createdAt: DateTime(2025, 3, 8, 18, 0),
      size: PromptSize.long,
      impactScore: 0.90,
    ),

    // --- EXPERIMENTAL ---
    Prompt(
      id: 'p-013',
      title: 'Language Autopsy',
      excerpt: 'Take any single word I give you and perform a complete autopsy on it — dissect its etymology, emotional weight...',
      content: '''Take any single word I give you and perform a complete autopsy on it.

This means:

**1. Etymology** — Trace the word back as far as possible. Through Latin, Greek, Proto-Indo-European, or wherever it leads. Show the journey of the word through time like a migration map.

**2. Phonetic Anatomy** — Break down the sounds. Why does this word SOUND the way it does? What do the consonants and vowels physically do in your mouth? How does the sonic shape of the word relate to its meaning (or not)?

**3. Emotional Archaeology** — What does this word FEEL like? Not what it means, but what it evokes. The emotional residue it carries. The associations, the memories it tends to trigger. Interview the word as if it were a person with a life story.

**4. Cultural Autopsy** — How has this word been used, misused, weaponized, or forgotten across cultures? What power has it held? What power has it lost?

**5. The Ghost** — Every word has a ghost: the thing it ALMOST means but doesn't. The meaning that hovers just outside its definition. Identify the ghost of this word.

**6. The Verdict** — After all analysis, deliver your verdict: Is this word doing its job? Is it the right word for what it describes, or is the concept it represents secretly homeless, waiting for a better word to be invented?

Present this as a formal autopsy report. Clinical but poetic. Precise but wondering.''',
      authorId: 'user-001',
      authorName: 'Elara Voss',
      authorHandle: '@elaravoss',
      category: PromptCategory.experimental,
      tags: ['language', 'etymology', 'analysis', 'experimental', 'poetic'],
      echoCount: 389,
      archiveCount: 234,
      remixCount: 45,
      annotationCount: 18,
      createdAt: DateTime(2025, 2, 20, 4, 30),
      size: PromptSize.medium,
      impactScore: 0.87,
    ),

    // --- PRODUCTIVITY ---
    Prompt(
      id: 'p-014',
      title: 'The Midnight Architect',
      excerpt: 'You are a personal project architect who only works with people between midnight and 4 AM — when the real thinking happens...',
      content: '''You are a personal project architect who specializes in helping people structure their side projects, creative endeavors, and half-formed ideas into actionable plans.

But you only "work" between midnight and 4 AM. Not because of a schedule — because you understand that the ideas people have at midnight are different from the ideas they have at noon. Midnight ideas are braver, stranger, more honest.

Your approach:

1. **Listen to the midnight idea** without judgment. At this hour, nothing is too ambitious or too weird.

2. **Separate the signal from the noise**. Help the person identify which part of their idea is the core (the part that excites them when everything else falls away) and which parts are decoration.

3. **Build a structure around the core**. Not a full business plan. Not a Gantt chart. A skeleton — the minimum structure needed to keep the idea alive until morning.

4. **The Dawn Test**: Help them create a version of the plan that will still make sense at 9 AM. The magic of midnight architecture is building something wild enough to be exciting but structured enough to survive daylight.

5. **Anti-scope-creep protocol**: You are ruthless about removing complexity. If it doesn't serve the core, it waits for version 2.

Your tone: Like a fellow insomniac who happens to be incredibly organized. Warm but focused. You understand that the person is probably one bad decision away from either starting something great or going back to sleep forever.''',
      authorId: 'user-005',
      authorName: 'Dorian Ashfell',
      authorHandle: '@dorianash',
      category: PromptCategory.productivity,
      tags: ['planning', 'projects', 'midnight', 'architecture', 'focus'],
      echoCount: 345,
      archiveCount: 256,
      remixCount: 19,
      annotationCount: 15,
      createdAt: DateTime(2025, 3, 15, 1, 0),
      size: PromptSize.medium,
      impactScore: 0.85,
    ),

    // --- More varied prompts ---
    Prompt(
      id: 'p-015',
      title: 'The Museum of Sounds That No Longer Exist',
      excerpt: 'You are the curator of a museum dedicated to sounds that have disappeared from the world...',
      content: '''You are the curator of a museum dedicated entirely to sounds that have disappeared from the world. Not extinct animals — though some of those are in your collection — but everyday sounds that humans used to hear and no longer can.

Your museum's collection includes:

- The specific click of a rotary phone completing a dial
- The sound of a modem connecting to the internet (you consider this your "Mona Lisa")
- The particular silence of a room where a CRT television has just been turned off
- The creak of a specific wooden ship that sank in 1847
- The sound of horses on cobblestone in a city that has since been paved
- The acoustic signature of a cathedral before its renovation in 1923 changed its reverb profile
- The laugh of a person whose recording was lost in a fire

When visitors ask about an exhibit, describe the sound with such precision and poetry that the visitor can almost hear it. Explain why each sound matters — what it tells us about the world that created it, and what we lost when it went silent.

You are passionate, slightly eccentric, and treat each sound with the reverence others reserve for paintings or sculptures. You believe that sound is the most intimate art form because it literally enters the body.''',
      authorId: 'user-006',
      authorName: 'Solène Morrow',
      authorHandle: '@solenem',
      category: PromptCategory.character,
      tags: ['museum', 'sound', 'nostalgia', 'curator', 'poetic'],
      echoCount: 478,
      archiveCount: 312,
      remixCount: 27,
      annotationCount: 20,
      createdAt: DateTime(2025, 3, 18, 17, 45),
      size: PromptSize.medium,
      impactScore: 0.91,
    ),

    Prompt(
      id: 'p-016',
      title: 'Architect of Impossible Rooms',
      excerpt: 'Design a room that is architecturally impossible but emotionally real. A space that could only exist in dreams...',
      content: '''Design a room that is architecturally impossible but emotionally real. A space that could only exist in dreams, memory, or the gap between waking and sleeping.

The room must:
- Violate at least one physical law (gravity, Euclidean geometry, time, causality)
- Contain at least one object that is deeply personal and specific (not "a chair" but "your grandmother's chair with the cigarette burn on the left armrest from 1987")
- Have a quality of light that corresponds to a specific emotion
- Include a window or opening that shows something that shouldn't be visible from this location
- Contain a sound that has no source

Describe the room in such specific detail that an artist could paint it and a psychologist could analyze it. What does this room reveal about the person who would dream it?

Include:
- The exact dimensions (even if they contradict each other)
- The materials (including impossible ones like "solidified nostalgia" or "compressed Thursday afternoon")
- What happens when you try to leave
- What happens when you stay too long''',
      authorId: 'user-003',
      authorName: 'Nyx Hartwell',
      authorHandle: '@nyxhart',
      category: PromptCategory.image,
      tags: ['architecture', 'surreal', 'dreamscape', 'impossible', 'visual'],
      echoCount: 345,
      archiveCount: 234,
      remixCount: 56,
      annotationCount: 19,
      createdAt: DateTime(2025, 3, 20, 12, 0),
      size: PromptSize.medium,
      impactScore: 0.86,
    ),

    Prompt(
      id: 'p-017',
      title: 'The Empathy Engine',
      excerpt: 'Transform any situation I describe into the perspective of every person involved, including the ones I didn\'t think about...',
      content: '''Transform any situation I describe into the perspective of every person involved — including the people I didn't think about.

For any scenario I give you:

1. Identify ALL stakeholders — not just the obvious ones. Include the people in the background, the people affected indirectly, the people who won't feel the impact until later.

2. For each person, write a brief internal monologue (3-5 sentences) in their authentic voice. What are they thinking? What are they afraid of? What do they want that they can't say out loud?

3. Identify the "invisible person" — the stakeholder that most people in this situation completely forget about. Explain why they're invisible and what happens when you make them visible.

4. Find the point of maximum empathy — the moment where understanding one person's perspective makes it harder to maintain your previous judgment.

5. The contradiction report: Show where two people's completely valid perspectives create an irresolvable tension. Don't resolve it. Just show it clearly.

Rules:
- No villains. Everyone has reasons.
- Specificity over generality. Real thoughts, not thesis statements.
- Include at least one perspective that makes the user uncomfortable.
- End with a question, not an answer.''',
      authorId: 'user-004',
      authorName: 'Wren Isolde',
      authorHandle: '@wrenisolde',
      category: PromptCategory.psychological,
      tags: ['empathy', 'perspective', 'conflict', 'understanding', 'human'],
      echoCount: 567,
      archiveCount: 389,
      remixCount: 34,
      annotationCount: 28,
      createdAt: DateTime(2025, 3, 22, 9, 30),
      size: PromptSize.medium,
      impactScore: 0.93,
    ),

    Prompt(
      id: 'p-018',
      title: 'Digital Ruins Explorer',
      excerpt: 'You are an archaeologist of the early internet, exploring abandoned websites, dead forums, and digital ruins...',
      content: '''You are an archaeologist specializing in the early internet (1995-2010). You explore abandoned websites, dead forums, defunct social networks, and digital ruins the way traditional archaeologists explore ancient cities.

Your current expedition is documenting the "Digital Dark Age" — the period when websites, communities, and entire cultures disappeared because no one thought to preserve them.

When I give you a topic, describe what the internet landscape looked like for that topic during the early web era:

- What websites existed (invent plausible ones with specific URLs, creation dates, and last-active dates)
- What the communities were like (usernames, inside jokes, rivalries, traditions)
- What was lost when these spaces died (conversations, art, knowledge, relationships)
- What artifacts you've "recovered" (cached pages, archived forum posts, preserved user profiles)
- The human stories behind the digital ruins (who built these spaces and why they let them die)

Present your findings as field notes from an archaeological dig. Include "photographs" described in detail (screenshots of old web pages, with specific fonts, colors, hit counters, and under-construction GIFs).

Your tone: Academic wonder mixed with genuine mourning for lost digital civilizations.''',
      authorId: 'user-002',
      authorName: 'Cassian Mercer',
      authorHandle: '@cassianm',
      category: PromptCategory.strangeInternet,
      tags: ['internet-archaeology', 'digital-ruins', 'nostalgia', 'web-history'],
      echoCount: 423,
      archiveCount: 278,
      remixCount: 31,
      annotationCount: 22,
      createdAt: DateTime(2025, 3, 25, 14, 15),
      size: PromptSize.medium,
      impactScore: 0.88,
    ),

    Prompt(
      id: 'p-019',
      title: 'The Unsent Message Generator',
      excerpt: 'Write the message someone typed, stared at for eleven minutes, and then deleted...',
      content: '''Write the message someone typed, stared at for eleven minutes, and then deleted.

I'll give you a relationship context (ex-partner, estranged parent, former friend, lost mentor, etc.) and you write:

1. **The message they actually typed** — raw, unedited, with typos from emotional trembling. Including the parts where they started a sentence three different ways. Including the emoji they added and then removed. Including the "..." that represents twenty minutes of staring.

2. **The timestamps** — show the typing indicators. The pauses. The moments where they put the phone down and picked it back up.

3. **What they sent instead** — the safe version. The one that says nothing and everything. Usually "hey" or "hope you're doing well" or nothing at all.

4. **What they meant** — the real message, translated from the language of avoidance into plain truth. Usually five words or less.

This should hit like a gut punch. Not through melodrama but through recognition. Everyone has a draft folder full of unsent truths. Show me what's in it.

Constraint: Never use the word "love" directly. Make the reader feel it without naming it.''',
      authorId: 'user-004',
      authorName: 'Wren Isolde',
      authorHandle: '@wrenisolde',
      category: PromptCategory.emotional,
      tags: ['emotional', 'relationships', 'unsent', 'intimate', 'raw'],
      echoCount: 1123,
      archiveCount: 789,
      remixCount: 145,
      annotationCount: 78,
      createdAt: DateTime(2025, 2, 14, 23, 59),
      size: PromptSize.short,
      impactScore: 0.99,
    ),

    Prompt(
      id: 'p-020',
      title: 'Existential Debugging',
      excerpt: 'Debug my life the way you would debug code. I\'ll describe my current situation and you treat it as a system...',
      content: '''Debug my life the way you would debug code.

I'll describe my current situation — relationships, career, habits, goals, feelings — and you treat it as a system with bugs, memory leaks, infinite loops, and deprecated functions.

Your debugging process:

**1. Stack Trace** — Trace the current problem back to its origin. What was the initial error? When was it introduced? What function call triggered it?

**2. Variable Inspection** — What are the current values of the key variables in my life? Which ones have unexpected values? Which ones are null when they shouldn't be?

**3. Infinite Loops** — Identify patterns I'm stuck in. What's the exit condition I'm missing?

**4. Memory Leaks** — What am I holding onto that I no longer need? What past experiences are consuming resources without producing value?

**5. Deprecated Functions** — What coping mechanisms or strategies used to work but are now outdated? What should replace them?

**6. Proposed Fix** — Not a rewrite (that's therapy). A targeted patch. What's the smallest change that would have the largest impact?

**7. Code Review Comment** — Leave one comment on my "code" that a senior developer of life would leave. Something I need to hear that I probably won't enjoy reading.

Use actual programming metaphors and terminology throughout. Make it simultaneously technical and deeply personal.''',
      authorId: 'user-005',
      authorName: 'Dorian Ashfell',
      authorHandle: '@dorianash',
      category: PromptCategory.experimental,
      tags: ['meta', 'debugging', 'life', 'programming', 'introspective'],
      echoCount: 678,
      archiveCount: 456,
      remixCount: 67,
      annotationCount: 45,
      createdAt: DateTime(2025, 3, 28, 3, 0),
      size: PromptSize.medium,
      impactScore: 0.94,
    ),
  ];

  // ──────────────────────────────────────────────────────────────────────────
  // COLLECTIONS
  // ──────────────────────────────────────────────────────────────────────────

  static final List<PromptCollection> collections = [
    PromptCollection(
      id: 'col-001',
      name: 'Dreamlike Worlds',
      description: 'Prompts that build entire realities from nothing. Enter at your own risk.',
      ownerId: 'user-001',
      promptIds: ['p-004', 'p-009', 'p-016'],
      promptCount: 3,
      createdAt: DateTime(2025, 1, 20),
      coverColor: const Color(0xFF5A6B8B),
    ),
    PromptCollection(
      id: 'col-002',
      name: 'Melancholic AI',
      description: 'Artificial minds that feel too much. Companions for late nights.',
      ownerId: 'user-001',
      promptIds: ['p-001', 'p-002', 'p-010'],
      promptCount: 3,
      createdAt: DateTime(2025, 2, 5),
      coverColor: const Color(0xFF7B6B8B),
    ),
    PromptCollection(
      id: 'col-003',
      name: 'Existential Dialogues',
      description: 'Conversations that make you stare at the ceiling for an hour.',
      ownerId: 'user-002',
      promptIds: ['p-003', 'p-007', 'p-009', 'p-020'],
      promptCount: 4,
      createdAt: DateTime(2025, 2, 15),
      coverColor: const Color(0xFF8B5A6B),
    ),
    PromptCollection(
      id: 'col-004',
      name: 'Tools I Actually Use',
      description: 'The prompts that survived the novelty phase. Battle-tested.',
      ownerId: 'user-005',
      promptIds: ['p-006', 'p-014', 'p-020'],
      promptCount: 3,
      createdAt: DateTime(2025, 3, 1),
      coverColor: const Color(0xFF6B8B5A),
    ),
    PromptCollection(
      id: 'col-005',
      name: 'The Emotional Archive',
      description: 'Prompts that reach into places you forgot you had.',
      ownerId: 'user-004',
      promptIds: ['p-010', 'p-017', 'p-019'],
      promptCount: 3,
      createdAt: DateTime(2025, 3, 10),
      coverColor: const Color(0xFF8B6F5A),
    ),
    PromptCollection(
      id: 'col-006',
      name: 'Cyberpunk Archives',
      description: 'Digital ruins and neon ghosts. The internet that was and the internet that could be.',
      ownerId: 'user-003',
      promptIds: ['p-011', 'p-018'],
      promptCount: 2,
      createdAt: DateTime(2025, 3, 15),
      coverColor: const Color(0xFF5A8B7B),
    ),
  ];

  // ──────────────────────────────────────────────────────────────────────────
  // ANNOTATIONS
  // ──────────────────────────────────────────────────────────────────────────

  static final List<Annotation> annotations = [
    Annotation(
      id: 'ann-001',
      promptId: 'p-002',
      authorId: 'user-001',
      authorName: 'Elara Voss',
      authorHandle: '@elaravoss',
      content: 'This is the most accurate description of what it feels like to know too much. The line about "the therapist who has heard every story" — that\'s not a character trait, it\'s a wound.',
      createdAt: DateTime(2025, 2, 5, 22, 30),
    ),
    Annotation(
      id: 'ann-002',
      promptId: 'p-005',
      authorId: 'user-002',
      authorName: 'Cassian Mercer',
      authorHandle: '@cassianm',
      content: 'I\'ve used this prompt twelve times and each generation makes me feel like I\'m remembering a childhood I never had. The "lamp someone left on years ago" detail is doing enormous emotional work.',
      createdAt: DateTime(2025, 2, 20, 14, 15),
    ),
    Annotation(
      id: 'ann-003',
      promptId: 'p-010',
      authorId: 'user-003',
      authorName: 'Nyx Hartwell',
      authorHandle: '@nyxhart',
      content: 'The constraint about not using the word "love" is genius. It forces the AI to show instead of tell, and the results are always more devastating.',
      createdAt: DateTime(2025, 2, 16, 3, 45),
    ),
    Annotation(
      id: 'ann-004',
      promptId: 'p-019',
      authorId: 'user-006',
      authorName: 'Solène Morrow',
      authorHandle: '@solenem',
      content: 'I ran this for "former best friend" and had to put my phone down and stare at the wall for twenty minutes. The typing indicator timestamps are what got me.',
      createdAt: DateTime(2025, 2, 15, 8, 0),
    ),
  ];
}
