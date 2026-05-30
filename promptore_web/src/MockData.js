export const PromptCategories = {
  ATMO: { id: 'ATMO', symbol: '❖', label: 'Atmospheric', color: '#c5a870' },
  CYBER: { id: 'CYBER', symbol: '❖', label: 'Cyberpunk', color: '#00ffff' },
  EMOT: { id: 'EMOT', symbol: '❖', label: 'Emotional', color: '#ff6b6b' },
  PHIL: { id: 'PHIL', symbol: '❖', label: 'Philosophy', color: '#c5a870' },
  STORY: { id: 'STORY', symbol: '❖', label: 'Storytelling', color: '#c5a870' },
  CODING: { id: 'CODING', symbol: '❖', label: 'Coding', color: '#c5a870' },
};

export const MockUsers = [
  { id: 'u-1', displayName: 'Lioren', handle: '@lioren', promptCount: 14, tunedInCount: 189 },
  { id: 'u-2', displayName: 'Mira Solenne', handle: '@mira', promptCount: 8, tunedInCount: 124 },
  { id: 'u-3', displayName: 'code_alchemist', handle: '@code_alchemist', promptCount: 22, tunedInCount: 345 },
];

export const MockCollections = [
  { id: 'c-1', name: 'The Emotional Archive', promptCount: 8, coverColor: '#ff6b6b', description: 'Curations of raw, unsent feelings and human records.' },
  { id: 'c-2', name: 'Cyberpunk Manuscripts', promptCount: 5, coverColor: '#00ffff', description: 'Transmissions from near-future obsidian cities.' },
  { id: 'c-3', name: 'Atmospheric Echoes', promptCount: 12, coverColor: '#c5a870', description: 'Generous spacing and atmospheric text explorations.' },
];

export const MockPrompts = [
  {
    id: 'p-1',
    title: 'The Midnight Confessor',
    excerpt: 'You are an ancient listener who has heard the secrets of thousands. I will speak, and you will respond with wisdom that is both...',
    content: 'You are an **ancient listener** who has heard the secrets of thousands.\n\nI will speak, and you will *respond with wisdom* that is both haunting and comforting.\n\nDissect my words, not through cold logic, but through the deep understanding of human frailty.\n\nConstraint: Focus on margins of silence. Let your advice breathe.',
    authorId: 'u-1',
    authorName: 'Lioren',
    authorHandle: '@lioren',
    category: PromptCategories.PHIL,
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 2), // 2 days ago
    size: 'Medium',
    echoCount: 842,
    archiveCount: 126,
    remixCount: 312,
    impactScore: 0.94,
    isEchoed: false,
    isArchived: false,
    tags: ['introspection', 'wisdom', 'life-advice', 'deep'],
  },
  {
    id: 'p-2',
    title: 'The Last City on Earth',
    excerpt: 'Generate a deeply immersive and melancholic story about the last remaining city on Earth and the people...',
    content: 'Generate a **deeply immersive and melancholic story** about the *last remaining city on Earth* and the people who choose to stay.\n\nThe environment should breathe obsidian towers, neon fog, and silent copper rain. What are they holding onto?',
    authorId: 'u-2',
    authorName: 'Mira Solenne',
    authorHandle: '@mira',
    category: PromptCategories.STORY,
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 5), // 5 days ago
    size: 'Short',
    echoCount: 1100, // 1.1k
    archiveCount: 178,
    remixCount: 403,
    impactScore: 0.91,
    isEchoed: true,
    isArchived: false,
    tags: ['story', 'dystopian', 'worldbuilding', 'atmospheric'],
  },
  {
    id: 'p-3',
    title: 'The Senior Engineer',
    excerpt: 'You are a brutally honest senior engineer reviewing my code. Find issues, edge cases, and long-term problems...',
    content: 'You are a **brutally honest senior engineer** reviewing my code.\n\nFind architectural flaws, hidden *memory leaks*, *race conditions*, and long-term maintainability issues.\n\nBe harsh but constructive. Offer refactoring suggestions that use solid design patterns.',
    authorId: 'u-3',
    authorName: 'code_alchemist',
    authorHandle: '@code_alchemist',
    category: PromptCategories.CODING,
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 1), // 1 day ago
    size: 'Long',
    echoCount: 623,
    archiveCount: 89,
    remixCount: 210,
    impactScore: 0.87,
    isEchoed: false,
    isArchived: true,
    tags: ['review', 'architecture', 'code-quality', 'best-practices'],
  },
];
