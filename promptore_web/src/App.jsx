import { useState, useEffect } from 'react';
import './App.css';
import { MockPrompts, MockCollections, MockUsers, PromptCategories } from './MockData';

export default function App() {
  const [theme, setTheme] = useState(() => localStorage.getItem('theme') || 'dark');
  const [currentTab, setCurrentTab] = useState('feed'); // feed, explore, categories, collections, activity, archive, saved, prompts, remixes, following, compose
  const [activeView, setActiveView] = useState('shell'); // shell, reader, remix, search
  const [activePromptId, setActivePromptId] = useState(null);
  
  // Dynamic clock telemetry
  const [currentTime, setCurrentTime] = useState(() => {
    const now = new Date();
    return now.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
  });

  useEffect(() => {
    const clockTimer = setInterval(() => {
      const now = new Date();
      setCurrentTime(now.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' }));
    }, 1000 * 15);
    return () => clearInterval(clockTimer);
  }, []);

  // Determine dynamic visual status text
  const getClockSubtitle = () => {
    const hours = new Date().getHours();
    if (hours >= 22 || hours < 5) return "Keep creating.";
    if (hours >= 5 && hours < 12) return "A new day of imagination.";
    if (hours >= 12 && hours < 17) return "Infinite paths await.";
    return "Archive curation active.";
  };
  
  
  // Dynamic App States
  const [prompts, setPrompts] = useState(MockPrompts);
  const collections = MockCollections;
  const [annotations, setAnnotations] = useState([
    { id: 'a-1', promptId: 'p-1', authorName: 'Solène Morrow', authorHandle: '@solene', content: 'I ran this for "former best friend" and had to put my phone down and stare at the wall for twenty minutes. The typing indicator timestamps are what got me.' }
  ]);

  // Accessibility and interactive states
  const [feedSubTab, setFeedSubTab] = useState('foryou'); // foryou, following, trending, recent, impactful
  const [followedUsers, setFollowedUsers] = useState(['u-1', 'u-2']); // follow Mira Solenne and Lioren initially
  const [activeCollectionId, setActiveCollectionId] = useState(null);
  const [activities, setActivities] = useState([
    { id: 'act-1', text: 'Lioren echoed your prompt "The Midnight Confessor"', time: '2h ago', type: 'echo' },
    { id: 'act-2', text: 'System locked directory for late-night curation', time: '4h ago', type: 'system' },
    { id: 'act-3', text: 'New transmission received from Mira Solenne', time: '6h ago', type: 'transmission' },
    { id: 'act-4', text: 'Archive synchronization successful. 8 records cached.', time: '1d ago', type: 'sync' },
    { id: 'act-5', text: 'You tuned into code_alchemist', time: '1d ago', type: 'follow' }
  ]);

  // Form states
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategoryFilter, setSelectedCategoryFilter] = useState(null);
  const [newPromptTitle, setNewPromptTitle] = useState('');
  const [newPromptContent, setNewPromptContent] = useState('');
  const [newPromptCategory, setNewPromptCategory] = useState('PHIL');
  const [newPromptTags, setNewPromptTags] = useState('');

  // Remix form states
  const [remixTitle, setRemixTitle] = useState('');
  const [remixContent, setRemixContent] = useState('');
  const [remixCategory, setRemixCategory] = useState('PHIL');

  // New Annotation state
  const [newAnnotationText, setNewAnnotationText] = useState('');

  // Sync theme with body class
  useEffect(() => {
    document.body.className = theme;
    localStorage.setItem('theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    const nextTheme = theme === 'dark' ? 'light' : 'dark';
    setTheme(nextTheme);
    setActivities(prev => [
      { id: `act-${Date.now()}`, text: `System visual mode adjusted to ${nextTheme.toUpperCase()}`, time: 'Just now', type: 'system' },
      ...prev
    ]);
  };

  // Helper for keyboard actions on role="button" elements
  const handleKeyDown = (e, callback) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      callback();
    }
  };

  // Handle feed actions
  const toggleEcho = (id) => {
    setPrompts(prev => prev.map(p => {
      if (p.id === id) {
        const nextEchoed = !p.isEchoed;
        // Dynamically add activity log when echoing
        setActivities(acts => [
          {
            id: `act-${Date.now()}`,
            text: nextEchoed ? `You echoed "${p.title}"` : `You removed echo from "${p.title}"`,
            time: 'Just now',
            type: 'echo'
          },
          ...acts
        ]);
        return { ...p, isEchoed: nextEchoed, echoCount: p.echoCount + (nextEchoed ? 1 : -1) };
      }
      return p;
    }));
  };

  const toggleArchive = (id) => {
    setPrompts(prev => prev.map(p => {
      if (p.id === id) {
        const nextArchived = !p.isArchived;
        // Dynamically add activity log when archiving
        setActivities(acts => [
          {
            id: `act-${Date.now()}`,
            text: nextArchived ? `You archived "${p.title}"` : `You unarchived "${p.title}"`,
            time: 'Just now',
            type: 'archive'
          },
          ...acts
        ]);
        return { ...p, isArchived: nextArchived, archiveCount: p.archiveCount + (nextArchived ? 1 : -1) };
      }
      return p;
    }));
  };

  const toggleFollow = (userId, handle) => {
    const isNowFollowing = !followedUsers.includes(userId);
    setFollowedUsers(prev => isNowFollowing ? [...prev, userId] : prev.filter(id => id !== userId));
    setActivities(acts => [
      {
        id: `act-${Date.now()}`,
        text: isNowFollowing ? `You tuned in to ${handle}` : `You tuned out of ${handle}`,
        time: 'Just now',
        type: 'follow'
      },
      ...acts
    ]);
  };

  // Add annotation
  const addAnnotation = (promptId) => {
    if (!newAnnotationText.trim()) return;
    const prompt = prompts.find(p => p.id === promptId);
    const newAnn = {
      id: `ann-${Date.now()}`,
      promptId,
      authorName: 'Solène Morrow',
      authorHandle: '@solene',
      content: newAnnotationText.trim()
    };
    setAnnotations(prev => [...prev, newAnn]);
    setActivities(acts => [
      { id: `act-${Date.now()}`, text: `Added margin note on "${prompt ? prompt.title : 'Manuscript'}"`, time: 'Just now', type: 'annotation' },
      ...acts
    ]);
    setNewAnnotationText('');
  };

  // Publish prompt
  const handlePublish = (e) => {
    e.preventDefault();
    if (!newPromptTitle.trim() || !newPromptContent.trim()) return;

    const wordCount = newPromptContent.trim().split(/\s+/).length;
    const size = wordCount < 100 ? 'Short' : wordCount < 400 ? 'Medium' : 'Long';

    const newPrompt = {
      id: `p-${Date.now()}`,
      title: newPromptTitle.trim(),
      excerpt: newPromptContent.substring(0, 120) + '...',
      content: newPromptContent.trim(),
      authorId: 'u-current',
      authorName: 'Solène Morrow',
      authorHandle: '@solene',
      category: PromptCategories[newPromptCategory],
      createdAt: new Date(),
      size,
      echoCount: 0,
      archiveCount: 0,
      remixCount: 0,
      impactScore: Math.random() * 0.4 + 0.5,
      isEchoed: false,
      isArchived: false,
      tags: newPromptTags.split(',').map(t => t.trim()).filter(Boolean),
    };

    setPrompts(prev => [newPrompt, ...prev]);
    setActivities(acts => [
      { id: `act-${Date.now()}`, text: `Published new manuscript "${newPromptTitle.trim()}"`, time: 'Just now', type: 'publish' },
      ...acts
    ]);
    setNewPromptTitle('');
    setNewPromptContent('');
    setNewPromptTags('');
    setCurrentTab('feed');
  };

  // Publish Remix
  const handlePublishRemix = (e) => {
    e.preventDefault();
    if (!remixTitle.trim() || !remixContent.trim()) return;

    const wordCount = remixContent.trim().split(/\s+/).length;
    const size = wordCount < 100 ? 'Short' : wordCount < 400 ? 'Medium' : 'Long';

    const originalPrompt = prompts.find(p => p.id === activePromptId);

    const remixedPrompt = {
      id: `p-${Date.now()}`,
      title: remixTitle.trim(),
      excerpt: remixContent.substring(0, 120) + '...',
      content: remixContent.trim(),
      authorId: 'u-current',
      authorName: 'Solène Morrow',
      authorHandle: '@solene',
      category: PromptCategories[remixCategory],
      createdAt: new Date(),
      size,
      echoCount: 0,
      archiveCount: 0,
      remixCount: 0,
      impactScore: Math.random() * 0.4 + 0.5,
      isEchoed: false,
      isArchived: false,
      tags: originalPrompt ? originalPrompt.tags : [],
      remixOfTitle: originalPrompt ? originalPrompt.title : 'Original',
    };

    setPrompts(prev => [remixedPrompt, ...prev]);
    setPrompts(prev => prev.map(p => {
      if (p.id === activePromptId) {
        return { ...p, remixCount: p.remixCount + 1 };
      }
      return p;
    }));

    setActivities(acts => [
      { id: `act-${Date.now()}`, text: `Published remix of "${originalPrompt ? originalPrompt.title : 'Manuscript'}"`, time: 'Just now', type: 'remix' },
      ...acts
    ]);

    setActiveView('shell');
    setCurrentTab('feed');
  };

  const openReader = (id) => {
    setActivePromptId(id);
    setActiveView('reader');
  };

  const openRemix = (id) => {
    const p = prompts.find(pr => pr.id === id);
    if (!p) return;
    setActivePromptId(id);
    setRemixTitle(`Remix of: ${p.title}`);
    setRemixContent(p.content);
    setRemixCategory(Object.keys(PromptCategories).find(k => PromptCategories[k].label === p.category.label) || 'PHIL');
    setActiveView('remix');
  };

  const formatCount = (count) => {
    if (count >= 1000) return `${(count / 1000).toFixed(1)}K`;
    return count;
  };

  const timeAgo = () => {
    return '2 days ago';
  };

  // Helper mapping curations/collections to specific prompts
  const getPromptsForCollection = (colId) => {
    if (colId === 'c-1') {
      return prompts.filter(p => p.category.id === 'EMOT' || p.category.id === 'STORY' || p.category.id === 'PHIL');
    }
    if (colId === 'c-2') {
      return prompts.filter(p => p.category.id === 'CYBER' || p.tags.includes('cyberpunk') || p.tags.includes('dystopian'));
    }
    if (colId === 'c-3') {
      return prompts.filter(p => p.category.id === 'ATMO' || p.tags.includes('atmospheric') || p.category.id === 'PHIL');
    }
    return [];
  };

  // -------------------------------------------------------------
  // Dynamic Prompt Filtering based on Active Tab
  // -------------------------------------------------------------
  let displayPrompts = [...prompts];

  if (selectedCategoryFilter) {
    displayPrompts = displayPrompts.filter(p => p.category.id === selectedCategoryFilter);
  }

  if (currentTab === 'feed') {
    if (feedSubTab === 'following') {
      displayPrompts = displayPrompts.filter(p => followedUsers.includes(p.authorId));
    } else if (feedSubTab === 'trending') {
      displayPrompts.sort((a, b) => b.echoCount - a.echoCount);
    } else if (feedSubTab === 'recent') {
      displayPrompts.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
    } else if (feedSubTab === 'impactful') {
      displayPrompts.sort((a, b) => b.impactScore - a.impactScore);
    }
  } else if (currentTab === 'saved') {
    displayPrompts = displayPrompts.filter(p => p.isEchoed);
  } else if (currentTab === 'archive') {
    displayPrompts = displayPrompts.filter(p => p.isArchived);
  } else if (currentTab === 'prompts') {
    displayPrompts = displayPrompts.filter(p => p.authorHandle === '@solene');
  } else if (currentTab === 'remixes') {
    displayPrompts = displayPrompts.filter(p => p.remixOfTitle);
  }

  return (
    <div className="app-container">
      <div className="main-wrapper">
        
        {/* ==========================================================================
           LEFT NAVIGATION COLUMN
           ========================================================================== */}
        <aside className="left-sidebar">
          <div className="logo-section">
            <span className="logo-symbol">P</span>
            <span className="logo-text">PROMPTORE</span>
          </div>

          <div className="sidebar-menu">
            <button 
              className={`menu-item ${currentTab === 'feed' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('feed'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Home Feed"
            >
              <span className="menu-icon">⌂</span> Home
            </button>
            <button 
              className={`menu-item ${currentTab === 'explore' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('explore'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Explore Trending and Categories"
            >
              <span className="menu-icon">🔍</span> Explore
            </button>
            <button 
              className={`menu-item ${currentTab === 'categories' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('categories'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Prompt Categories Grid"
            >
              <span className="menu-icon">⚙</span> Categories
            </button>
            <button 
              className={`menu-item ${currentTab === 'collections' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('collections'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Curated Collections"
            >
              <span className="menu-icon">🗂</span> Collections
            </button>
            <button 
              className={`menu-item ${currentTab === 'activity' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('activity'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Cinematic Activity Transmissions"
            >
              <span className="menu-icon">⚡</span> Activity
            </button>
            <button 
              className={`menu-item ${currentTab === 'archive' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('archive'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Archived Manuscripts"
            >
              <span className="menu-icon">📁</span> Archive
            </button>
          </div>

          <hr className="sidebar-divider" />

          <div className="sidebar-menu">
            <h3 className="menu-section-title">Your Library</h3>
            <button 
              className={`menu-item ${currentTab === 'saved' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('saved'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Saved Prompts Library"
            >
              <span className="menu-icon">🔖</span> Saved Prompts
            </button>
            <button 
              className={`menu-item ${currentTab === 'prompts' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('prompts'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Your Authored Prompts"
            >
              <span className="menu-icon">📝</span> Your Prompts
            </button>
            <button 
              className={`menu-item ${currentTab === 'remixes' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('remixes'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Your Remixed Manuscripts"
            >
              <span className="menu-icon">⎗</span> Remixes
            </button>
            <button 
              className={`menu-item ${currentTab === 'following' && activeView === 'shell' ? 'active' : ''}`} 
              onClick={() => { setCurrentTab('following'); setActiveView('shell'); setSelectedCategoryFilter(null); setActiveCollectionId(null); }}
              aria-label="Creators You Follow"
            >
              <span className="menu-icon">⚛</span> Following
            </button>
          </div>

          {/* Late Night Status Card */}
          <div className="status-card">
            <button 
              className="status-icon" 
              onClick={toggleTheme} 
              style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
              aria-label="Toggle system interface visual theme color"
            >
              ☽
            </button>
            <div className="status-text-box">
              <span className="status-title">It's {currentTime}</span>
              <span className="status-subtitle">{getClockSubtitle()}</span>
            </div>
          </div>
        </aside>

        {/* ==========================================================================
           CENTER MAIN FEED COLUMN
           ========================================================================== */}
        <section className="center-content">
          {activeView === 'shell' && (
            <>
              {/* TOP ACTION & SEARCH HEADER */}
              <div className="top-action-bar">
                <div className="search-container">
                  <span className="search-icon-inside">🔍</span>
                  <input 
                    type="text" 
                    placeholder="Search prompts, creators, or ideas..." 
                    className="search-input-field" 
                    value={searchQuery}
                    onChange={e => setSearchQuery(e.target.value)}
                    onClick={() => setActiveView('search')}
                    aria-label="Search bar to search manuscripts"
                  />
                </div>
                <button 
                  className="action-circle-btn" 
                  onClick={() => setCurrentTab('compose')}
                  aria-label="Compose and publish new manuscript"
                >
                  +
                </button>
                <button 
                  className="action-circle-btn"
                  aria-label="Notifications"
                >
                  🔔
                </button>
              </div>

              {/* FEED SECTION */}
              {currentTab === 'feed' && (
                <div className="feed-tab">
                  {/* Hero Block */}
                  <div className="hero-block">
                    <h1 className="hero-title">A library<br />of human imagination.</h1>
                    <p className="hero-desc">Discover prompts that ask better questions, unlock deeper thinking, and create unforgettable results.</p>
                    <button className="explore-cta" onClick={() => setCurrentTab('explore')}>Explore Prompts →</button>
                  </div>

                  {/* Active filter pill */}
                  {selectedCategoryFilter && (
                    <div className="category-filter-pill">
                      <span>❖ Active Filter: {PromptCategories[selectedCategoryFilter].label}</span>
                      <button 
                        className="category-filter-reset" 
                        onClick={() => setSelectedCategoryFilter(null)}
                        aria-label="Reset category filter"
                      >
                        ✕
                      </button>
                    </div>
                  )}

                  {/* Sub Tab selection */}
                  <div className="feed-tabs-bar">
                    {['foryou', 'following', 'trending', 'recent', 'impactful'].map(subTab => {
                      const labels = {
                        foryou: 'For You',
                        following: 'Following',
                        trending: 'Trending',
                        recent: 'Recent',
                        impactful: 'Most Impactful'
                      };
                      return (
                        <button
                          key={subTab}
                          className={`tab-link ${feedSubTab === subTab ? 'active' : ''}`}
                          onClick={() => setFeedSubTab(subTab)}
                          aria-label={`Filter main feed by ${labels[subTab]}`}
                        >
                          {labels[subTab]}
                        </button>
                      );
                    })}
                  </div>

                  {/* Feed List */}
                  <div className="flat-feed-list">
                    {displayPrompts.length === 0 ? (
                      <div className="fallback-tab-view" style={{ padding: '40px 0', textAlign: 'center', color: 'var(--charcoal-color)' }}>
                        <p>No manuscripts fit this criteria. Check back later or follow more creators!</p>
                      </div>
                    ) : (
                      displayPrompts.map(p => (
                        <article 
                          key={p.id} 
                          className="flat-prompt-card" 
                          onClick={() => openReader(p.id)}
                          role="button"
                          tabIndex={0}
                          onKeyDown={(e) => handleKeyDown(e, () => openReader(p.id))}
                          aria-label={`Read manuscript: ${p.title} by ${p.authorName}`}
                        >
                          <div className="card-left-col">
                            <div className="card-category-row">
                              <span className="category-diamond">✦</span> {p.category.label}
                            </div>
                            <h2 className="flat-card-title">{p.title}</h2>
                            <p className="flat-card-desc">{p.excerpt}</p>
                            
                            <div className="flat-card-tags">
                              {p.tags.map(tag => (
                                <span key={tag} className="flat-tag-pill">#{tag}</span>
                              ))}
                            </div>

                            <div className="flat-card-meta">
                              <span className="meta-author">{p.authorName}</span> · <span>{timeAgo()}</span>
                              {p.remixOfTitle && (
                                <span style={{ color: 'var(--gold-color)', marginLeft: '12px' }}>⎗ Remix of {p.remixOfTitle}</span>
                              )}
                            </div>
                          </div>

                          <div className="card-right-col" onClick={e => e.stopPropagation()}>
                            <div className="card-impact-box">
                              <span className="impact-header">impact</span>
                              <div className="impact-value-big">
                                {(p.impactScore * 10).toFixed(1)} <span className="impact-slash">/10</span>
                              </div>
                            </div>

                            <div className="card-vertical-stats">
                              <button 
                                className="stat-row-item"
                                onClick={() => toggleEcho(p.id)}
                                aria-label={p.isEchoed ? `Remove echo from ${p.title}` : `Echo ${p.title}`}
                                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
                              >
                                <span className="stat-icon-mini" style={{ color: p.isEchoed ? 'var(--red-dim)' : 'inherit' }}>
                                  {p.isEchoed ? '♥' : '♡'}
                                </span>
                                <span>{formatCount(p.echoCount)}</span>
                              </button>
                              
                              <div className="stat-row-item" aria-label={`${p.archiveCount} margins`}>
                                <span className="stat-icon-mini">💬</span>
                                <span>{p.archiveCount}</span>
                              </div>
                              
                              <button 
                                className="stat-row-item"
                                onClick={() => openRemix(p.id)}
                                aria-label={`Remix ${p.title}`}
                                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
                              >
                                <span className="stat-icon-mini">⎗</span>
                                <span>{p.remixCount}</span>
                              </button>
                            </div>

                            <button 
                              className={`card-bookmark-btn ${p.isArchived ? 'active' : ''}`} 
                              onClick={() => toggleArchive(p.id)}
                              aria-label={p.isArchived ? `Unarchive ${p.title}` : `Archive ${p.title}`}
                            >
                              🔖
                            </button>
                          </div>
                        </article>
                      ))
                    )}
                  </div>
                </div>
              )}

              {/* EXPLORE SECTION */}
              {currentTab === 'explore' && (
                <div className="explore-tab" style={{ padding: '20px 0' }}>
                  <header className="tab-header" style={{ marginBottom: '24px' }}>
                    <h1 className="serif header-title" style={{ fontSize: '32px' }}>Explore Imaginations</h1>
                    <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                      Navigate trending categories, impactful transcripts, and prominent creators.
                    </p>
                  </header>

                  <div className="widget-card" style={{ marginBottom: '32px' }}>
                    <h3 className="widget-title">Categories grid</h3>
                    <div className="category-grid">
                      {Object.keys(PromptCategories).map(k => {
                        const cat = PromptCategories[k];
                        return (
                          <button 
                            key={cat.id} 
                            className="category-card"
                            onClick={() => { setSelectedCategoryFilter(cat.id); setCurrentTab('feed'); }}
                            aria-label={`View manuscripts in ${cat.label}`}
                          >
                            <span className="category-card-symbol" style={{ color: cat.color }}>{cat.symbol}</span>
                            <span className="category-card-label">{cat.label}</span>
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  <h3 className="widget-title" style={{ marginTop: '36px' }}>Impactful Transmissions</h3>
                  <div className="flat-feed-list">
                    {prompts.slice(0, 3).map(p => (
                      <article 
                        key={p.id} 
                        className="flat-prompt-card" 
                        onClick={() => openReader(p.id)}
                        role="button"
                        tabIndex={0}
                        onKeyDown={(e) => handleKeyDown(e, () => openReader(p.id))}
                        aria-label={`Read manuscript: ${p.title} by ${p.authorName}`}
                      >
                        <div className="card-left-col">
                          <div className="card-category-row">
                            <span className="category-diamond">✦</span> {p.category.label}
                          </div>
                          <h2 className="flat-card-title">{p.title}</h2>
                          <p className="flat-card-desc">{p.excerpt}</p>
                          <div className="flat-card-meta">
                            <span className="meta-author">{p.authorName}</span> · {timeAgo()}
                          </div>
                        </div>
                        <div className="card-right-col" onClick={e => e.stopPropagation()}>
                          <div className="card-impact-box">
                            <span className="impact-header">impact</span>
                            <div className="impact-value-big">{(p.impactScore * 10).toFixed(1)}</div>
                          </div>
                        </div>
                      </article>
                    ))}
                  </div>
                </div>
              )}

              {/* CATEGORIES SECTION */}
              {currentTab === 'categories' && (
                <div className="categories-tab" style={{ padding: '20px 0' }}>
                  <header className="tab-header" style={{ marginBottom: '24px' }}>
                    <h1 className="serif header-title" style={{ fontSize: '32px' }}>Interactive Categories</h1>
                    <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                      Select a visual grid element below to filter the global feed records.
                    </p>
                  </header>
                  <div className="category-grid">
                    {Object.keys(PromptCategories).map(k => {
                      const cat = PromptCategories[k];
                      return (
                        <button 
                          key={cat.id} 
                          className="category-card"
                          onClick={() => { setSelectedCategoryFilter(cat.id); setCurrentTab('feed'); }}
                          aria-label={`Category filter: ${cat.label}`}
                        >
                          <span className="category-card-symbol" style={{ color: cat.color }}>{cat.symbol}</span>
                          <span className="category-card-label">{cat.label}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* COLLECTIONS SECTION */}
              {currentTab === 'collections' && (
                <div className="collections-tab" style={{ padding: '20px 0' }}>
                  {activeCollectionId === null ? (
                    <>
                      <header className="tab-header" style={{ marginBottom: '24px' }}>
                        <h1 className="serif header-title" style={{ fontSize: '32px' }}>Curated Volumes</h1>
                        <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                          Bound collections of complementary manuscripts, assembled by our high-level curators.
                        </p>
                      </header>
                      <div className="collections-grid">
                        {collections.map(col => {
                          const colPromptsCount = getPromptsForCollection(col.id).length;
                          return (
                            <button 
                              key={col.id} 
                              className="collection-card"
                              onClick={() => setActiveCollectionId(col.id)}
                              aria-label={`Open Curation Volume: ${col.name}`}
                            >
                              <div className="collection-cover" style={{ backgroundColor: col.coverColor }}></div>
                              <div className="collection-content">
                                <h3 className="collection-title">{col.name}</h3>
                                <p className="collection-desc">{col.description}</p>
                                <div className="collection-meta">
                                  <span>{colPromptsCount} Manuscripts</span>
                                  <span>Tuned In →</span>
                                </div>
                              </div>
                            </button>
                          );
                        })}
                      </div>
                    </>
                  ) : (
                    (() => {
                      const col = collections.find(c => c.id === activeCollectionId);
                      if (!col) return null;
                      const colPrompts = getPromptsForCollection(col.id);
                      return (
                        <div className="collection-details-subview">
                          <button 
                            className="back-btn" 
                            onClick={() => setActiveCollectionId(null)}
                            style={{ marginBottom: '20px' }}
                            aria-label="Back to collections overview"
                          >
                            ← Back to Collections
                          </button>
                          <div className="collection-header-banner">
                            <div className="collection-header-accent" style={{ backgroundColor: col.coverColor }}></div>
                            <h1 className="collection-header-title">{col.name}</h1>
                            <p className="collection-header-desc">{col.description}</p>
                          </div>
                          <h3 className="widget-title">Manuscripts in this volume</h3>
                          <div className="flat-feed-list">
                            {colPrompts.length === 0 ? (
                              <p style={{ color: 'var(--charcoal-color)', textAlign: 'center', padding: '40px 0' }}>
                                No manuscripts in this volume yet.
                              </p>
                            ) : (
                              colPrompts.map(p => (
                                <article 
                                  key={p.id} 
                                  className="flat-prompt-card" 
                                  onClick={() => openReader(p.id)}
                                  role="button"
                                  tabIndex={0}
                                  onKeyDown={(e) => handleKeyDown(e, () => openReader(p.id))}
                                  aria-label={`Read manuscript: ${p.title} by ${p.authorName}`}
                                >
                                  <div className="card-left-col">
                                    <div className="card-category-row">
                                      <span className="category-diamond">✦</span> {p.category.label}
                                    </div>
                                    <h2 className="flat-card-title">{p.title}</h2>
                                    <p className="flat-card-desc">{p.excerpt}</p>
                                    <div className="flat-card-meta">
                                      <span>by {p.authorName}</span>
                                    </div>
                                  </div>
                                  <div className="card-right-col" onClick={e => e.stopPropagation()}>
                                    <div className="card-impact-box">
                                      <span className="impact-header">impact</span>
                                      <div className="impact-value-big">{(p.impactScore * 10).toFixed(1)}</div>
                                    </div>
                                  </div>
                                </article>
                              ))
                            )}
                          </div>
                        </div>
                      );
                    })()
                  )}
                </div>
              )}

              {/* ACTIVITY SECTION */}
              {currentTab === 'activity' && (
                <div className="activity-tab" style={{ padding: '20px 0' }}>
                  <header className="tab-header">
                    <h1 className="serif header-title" style={{ fontSize: '32px' }}>Archival Transmissions</h1>
                    <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                      Realtime cinematic telemetry logs mapping prompt echoes, compositions, and following states.
                    </p>
                  </header>
                  <div className="activity-log-container">
                    {activities.map(act => (
                      <div key={act.id} className="activity-item">
                        <span className="activity-text">
                          <span style={{ color: 'var(--gold-color)', marginRight: '8px' }}>[OK]</span>
                          {act.text}
                        </span>
                        <span className="activity-time">{act.time}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* SAVED PROMPTS / ARCHIVE / YOUR PROMPTS / REMIXES LIST VIEWS */}
              {(currentTab === 'saved' || currentTab === 'archive' || currentTab === 'prompts' || currentTab === 'remixes') && (
                <div className="saved-archive-tab" style={{ padding: '20px 0' }}>
                  <header className="tab-header" style={{ marginBottom: '24px' }}>
                    <h1 className="serif header-title" style={{ fontSize: '32px' }}>
                      {currentTab === 'saved' && 'Saved Manuscripts'}
                      {currentTab === 'archive' && 'Archived Manuscripts'}
                      {currentTab === 'prompts' && 'Your Manuscripts'}
                      {currentTab === 'remixes' && 'Remixed Manuscripts'}
                    </h1>
                    <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                      {currentTab === 'saved' && 'Your catalog of echoed transmissions and high-fidelity manuscripts.'}
                      {currentTab === 'archive' && 'Curations that you have designated for safe archival preservation.'}
                      {currentTab === 'prompts' && 'A comprehensive collection of manuscripts composed by Solène Morrow.'}
                      {currentTab === 'remixes' && 'Transmissions reconstructed by you from existing prompt designs.'}
                    </p>
                  </header>

                  <div className="flat-feed-list">
                    {displayPrompts.length === 0 ? (
                      <div className="fallback-tab-view" style={{ padding: '60px 0', textAlign: 'center' }}>
                        <p style={{ color: 'var(--charcoal-color)' }}>
                          No manuscripts found in this library section. 
                        </p>
                        <button className="publish-btn" style={{ marginTop: '20px' }} onClick={() => setCurrentTab('feed')}>
                          Return to Feed
                        </button>
                      </div>
                    ) : (
                      displayPrompts.map(p => (
                        <article 
                          key={p.id} 
                          className="flat-prompt-card" 
                          onClick={() => openReader(p.id)}
                          role="button"
                          tabIndex={0}
                          onKeyDown={(e) => handleKeyDown(e, () => openReader(p.id))}
                          aria-label={`Read manuscript: ${p.title} by ${p.authorName}`}
                        >
                          <div className="card-left-col">
                            <div className="card-category-row">
                              <span className="category-diamond">✦</span> {p.category.label}
                            </div>
                            <h2 className="flat-card-title">{p.title}</h2>
                            <p className="flat-card-desc">{p.excerpt}</p>
                            <div className="flat-card-meta">
                              <span className="meta-author">{p.authorName}</span> · {timeAgo()}
                            </div>
                          </div>
                          <div className="card-right-col" onClick={e => e.stopPropagation()}>
                            <div className="card-impact-box">
                              <span className="impact-header">impact</span>
                              <div className="impact-value-big">{(p.impactScore * 10).toFixed(1)}</div>
                            </div>
                            <button 
                              className={`card-bookmark-btn ${p.isArchived ? 'active' : ''}`} 
                              onClick={() => toggleArchive(p.id)}
                              aria-label={p.isArchived ? `Unarchive ${p.title}` : `Archive ${p.title}`}
                            >
                              🔖
                            </button>
                          </div>
                        </article>
                      ))
                    )}
                  </div>
                </div>
              )}

              {/* FOLLOWING SECTION */}
              {currentTab === 'following' && (
                <div className="following-tab" style={{ padding: '20px 0' }}>
                  <header className="tab-header" style={{ marginBottom: '24px' }}>
                    <h1 className="serif header-title" style={{ fontSize: '32px' }}>Tuned In Creators</h1>
                    <p style={{ color: 'var(--charcoal-color)', fontSize: '14px', marginTop: '6px' }}>
                      Creators whose imaginative frequencies you have tuned into. Toggling will filter home telemetry.
                    </p>
                  </header>
                  <div className="creators-list">
                    {MockUsers.map(user => {
                      const isTuned = followedUsers.includes(user.id);
                      return (
                        <div key={user.id} className="creator-card">
                          <div className="creator-info">
                            <div className="creator-avatar">{user.displayName[0]}</div>
                            <div className="creator-details">
                              <span className="creator-name">{user.displayName}</span>
                              <span className="creator-handle">{user.handle}</span>
                              <span className="creator-stats">{user.promptCount} manuscripts · {user.tunedInCount} tuned in</span>
                            </div>
                          </div>
                          <button 
                            className={`tune-in-btn ${isTuned ? 'tuned-in' : ''}`}
                            onClick={() => toggleFollow(user.id, user.handle)}
                            aria-label={isTuned ? `Tune out from ${user.displayName}` : `Tune in to ${user.displayName}`}
                          >
                            {isTuned ? '✓ Tuned In' : 'Tune In'}
                          </button>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* COMPOSE SECTION */}
              {currentTab === 'compose' && (
                <div className="compose-tab">
                  <header className="tab-header">
                    <h1 className="serif header-title">Publish Manuscript</h1>
                  </header>
                  <form onSubmit={handlePublish} className="compose-form">
                    <input 
                      type="text" 
                      placeholder="Manuscript title..." 
                      className="compose-input serif"
                      value={newPromptTitle}
                      onChange={e => setNewPromptTitle(e.target.value)}
                      required
                      aria-label="Manuscript Title Input"
                    />
                    <textarea 
                      placeholder="Write your atmospheric prompt or instructions..." 
                      className="compose-textarea"
                      value={newPromptContent}
                      onChange={e => setNewPromptContent(e.target.value)}
                      required
                      aria-label="Manuscript Content Instructions"
                    ></textarea>

                    <div className="form-row">
                      <label className="form-label" htmlFor="compose-cat-select">Category</label>
                      <select 
                        id="compose-cat-select"
                        value={newPromptCategory} 
                        onChange={e => setNewPromptCategory(e.target.value)}
                        className="compose-select"
                      >
                        {Object.keys(PromptCategories).map(k => (
                          <option key={k} value={k}>{PromptCategories[k].label}</option>
                        ))}
                      </select>
                    </div>

                    <div className="form-row">
                      <label className="form-label" htmlFor="compose-tags-input">Tags (comma separated)</label>
                      <input 
                        id="compose-tags-input"
                        type="text" 
                        placeholder="e.g. dreams, mind, philosophy" 
                        className="compose-tags-input"
                        value={newPromptTags}
                        onChange={e => setNewPromptTags(e.target.value)}
                      />
                    </div>

                    <button type="submit" className="publish-btn">Publish Manuscript</button>
                  </form>
                </div>
              )}
            </>
          )}

          {/* DETAILED READER VIEW */}
          {activeView === 'reader' && (
            (() => {
              const prompt = prompts.find(p => p.id === activePromptId);
              if (!prompt) return null;
              const promptAnnotations = annotations.filter(a => a.promptId === prompt.id);
              return (
                <div className="reader-view">
                  <header className="reader-header">
                    <button className="back-btn" onClick={() => setActiveView('shell')} aria-label="Go back to list">← Back</button>
                    <button 
                      className={`archive-btn ${prompt.isArchived ? 'active' : ''}`} 
                      onClick={() => toggleArchive(prompt.id)}
                      aria-label={prompt.isArchived ? "Remove from archives" : "Archive manuscript"}
                    >
                      {prompt.isArchived ? '🔖 Archived' : '🔖 Archive'}
                    </button>
                  </header>

                  <div className="reader-category" style={{ color: prompt.category.color }}>
                    {prompt.category.symbol} {prompt.category.label}
                  </div>

                  <h1 className="serif reader-title">{prompt.title}</h1>

                  <div className="reader-author-row">
                    <div className="author-avatar" style={{ backgroundColor: `${prompt.category.color}25` }}>
                      {prompt.authorName[0]}
                    </div>
                    <div className="author-meta">
                      <span className="author-name">{prompt.authorName}</span>
                      <span className="author-separator"> · </span>
                      <span className="author-handle">{prompt.authorHandle}</span>
                    </div>
                  </div>

                  <div className="reader-stats">
                    <span>June 30, 2026</span>
                    <span>·</span>
                    <span>{prompt.size}</span>
                    <span>·</span>
                    <span style={{ color: 'var(--gold-color)' }}>{Math.round(prompt.impactScore * 10)} /10 impact</span>
                  </div>

                  <hr className="divider" />

                  <div className="reader-content serif">
                    {prompt.content.split('\n\n').map((para, idx) => {
                      const renderParagraph = (text) => {
                        const parts = [];
                        const regex = /\*\*(.+?)\*\*|\*(.+?)\*/g;
                        let lastIndex = 0;
                        let match;

                        while ((match = regex.exec(text)) !== null) {
                          if (match.index > lastIndex) {
                            parts.push(text.substring(lastIndex, match.index));
                          }
                          if (match[1]) {
                            parts.push(<strong key={match.index}>{match[1]}</strong>);
                          } else if (match[2]) {
                            parts.push(<em key={match.index} style={{ color: 'var(--gold-color)' }}>{match[2]}</em>);
                          }
                          lastIndex = regex.lastIndex;
                        }
                        if (lastIndex < text.length) {
                          parts.push(text.substring(lastIndex));
                        }
                        return parts;
                      };

                      return <p key={idx}>{renderParagraph(para)}</p>;
                    })}
                  </div>

                  <div className="reader-tags">
                    {prompt.tags.map(tag => (
                      <span key={tag} className="flat-tag-pill" style={{ marginRight: '6px' }}>#{tag}</span>
                    ))}
                  </div>

                  <hr className="divider" />

                  <div style={{ display: 'flex', gap: '16px', marginBottom: '24px' }}>
                    <button 
                      className="publish-btn"
                      onClick={() => openRemix(prompt.id)}
                      aria-label={`Remix ${prompt.title}`}
                    >
                      ⎗ Remix Manuscript
                    </button>
                    <button 
                      className="publish-btn"
                      style={{ background: 'transparent', color: 'var(--gold-color)', border: '1px solid var(--gold-color)' }}
                      onClick={() => toggleEcho(prompt.id)}
                      aria-label={prompt.isEchoed ? "Remove echo" : "Echo manuscript"}
                    >
                      {prompt.isEchoed ? '♥ Echoed' : '♡ Echo'}
                    </button>
                  </div>

                  <section className="annotations-section">
                    <h3 className="section-title">Margin Notes</h3>
                    <div className="annotations-list">
                      {promptAnnotations.length === 0 ? (
                        <p style={{ color: 'var(--charcoal-color)', fontSize: '13px' }}>No margin notes recorded for this archive. Add your voice below.</p>
                      ) : (
                        promptAnnotations.map(ann => (
                          <div key={ann.id} className="annotation-tile">
                            <div className="ann-header">
                              <span className="ann-author">{ann.authorName}</span>
                              <span className="ann-separator"> · </span>
                              <span className="ann-handle">{ann.authorHandle}</span>
                            </div>
                            <p className="ann-content">{ann.content}</p>
                          </div>
                        ))
                      )}
                    </div>

                    <div className="add-annotation-box">
                      <textarea 
                        placeholder="Write a thought or annotation..." 
                        className="annotation-input"
                        value={newAnnotationText}
                        onChange={e => setNewAnnotationText(e.target.value)}
                        aria-label="Add Margin Note Textbox"
                      ></textarea>
                      <button className="submit-ann-btn" onClick={() => addAnnotation(prompt.id)}>
                        Add Margin Note
                      </button>
                    </div>
                  </section>
                </div>
              );
            })()
          )}

          {/* REMIX MANUSCRIPT VIEW */}
          {activeView === 'remix' && (
            (() => {
              const prompt = prompts.find(p => p.id === activePromptId);
              if (!prompt) return null;
              return (
                <div className="remix-view">
                  <header className="reader-header">
                    <button className="back-btn" onClick={() => setActiveView('reader')} aria-label="Back to reader">← Back</button>
                    <h2 className="serif title-center">Remix</h2>
                  </header>

                  <div className="remix-attribution-box">
                    ⎗ Original manuscript by {prompt.authorName}
                  </div>

                  <form onSubmit={handlePublishRemix} className="compose-form">
                    <input 
                      type="text" 
                      placeholder="Remix title..." 
                      className="compose-input serif"
                      value={remixTitle}
                      onChange={e => setRemixTitle(e.target.value)}
                      required
                      aria-label="Remix manuscript title"
                    />
                    <textarea 
                      placeholder="Your remixed prompt instructions..." 
                      className="compose-textarea"
                      value={remixContent}
                      onChange={e => setRemixContent(e.target.value)}
                      required
                      aria-label="Remix manuscript content instructions"
                    ></textarea>

                    <button type="submit" className="publish-btn">Publish Remix</button>
                  </form>
                </div>
              );
            })()
          )}

          {/* NATIVE SEARCH VIEW */}
          {activeView === 'search' && (
            <div className="search-view" style={{ padding: '20px 0' }}>
              <header className="search-view-header">
                <input 
                  type="text" 
                  placeholder="Search prompts, creators, or ideas..." 
                  className="search-input"
                  value={searchQuery}
                  onChange={e => setSearchQuery(e.target.value)}
                  autoFocus
                  aria-label="Enter query search text"
                />
                <button className="close-search-btn" onClick={() => setActiveView('shell')}>Close</button>
              </header>

              <div className="search-results-area">
                <div className="search-results-list">
                  {prompts
                    .filter(p => 
                      p.title.toLowerCase().includes(searchQuery.toLowerCase()) || 
                      p.excerpt.toLowerCase().includes(searchQuery.toLowerCase()) ||
                      p.tags.some(t => t.toLowerCase().includes(searchQuery.toLowerCase()))
                    )
                    .map(p => (
                      <button 
                        key={p.id} 
                        className="search-result-tile" 
                        onClick={() => openReader(p.id)}
                        style={{ border: 'none', background: 'none', width: '100%', cursor: 'pointer', textAlign: 'left' }}
                        aria-label={`Open result: ${p.title}`}
                      >
                        <div className="result-indicator" style={{ backgroundColor: p.category.color }}></div>
                        <div className="result-meta">
                          <h4 className="serif result-title" style={{ margin: 0 }}>{p.title}</h4>
                          <span className="result-author">{p.authorName} · {p.category.label}</span>
                        </div>
                      </button>
                    ))}
                </div>
              </div>
            </div>
          )}
        </section>

        {/* ==========================================================================
           RIGHT SIDEBAR (WIDGET COLUMN)
           ========================================================================== */}
        <aside className="right-sidebar">
          {/* Quote Widget */}
          <div className="widget-card quote-widget">
            <span className="quote-icon-large">“</span>
            <p className="quote-text">The right prompt doesn't just get an answer. It creates a story worth reading.</p>
            <span className="quote-author">— PROMPTORE</span>
          </div>

          {/* Top Categories Widget */}
          <div className="widget-card">
            <h3 className="widget-title">TOP CATEGORIES</h3>
            <div className="widget-list">
              <button 
                className="widget-list-row" 
                onClick={() => { setCurrentTab('feed'); setSelectedCategoryFilter('PHIL'); }}
                style={{ background: 'none', border: 'none', width: '100%', textDecoration: 'none' }}
                aria-label="Filter philosophy category"
              >
                <span className="list-row-left">❖ Philosophy</span>
                <span className="list-row-right">763</span>
              </button>
              <button 
                className="widget-list-row" 
                onClick={() => { setCurrentTab('feed'); setSelectedCategoryFilter('CODING'); }}
                style={{ background: 'none', border: 'none', width: '100%', textDecoration: 'none' }}
                aria-label="Filter coding category"
              >
                <span className="list-row-left">{"</>"} Coding Prompts</span>
                <span className="list-row-right">1.8K</span>
              </button>
              <button 
                className="widget-list-row" 
                onClick={() => { setCurrentTab('feed'); setSelectedCategoryFilter('STORY'); }}
                style={{ background: 'none', border: 'none', width: '100%', textDecoration: 'none' }}
                aria-label="Filter storytelling category"
              >
                <span className="list-row-left">📖 Storytelling</span>
                <span className="list-row-right">1.6K</span>
              </button>
              <button 
                className="widget-list-row" 
                onClick={() => { setCurrentTab('feed'); setSelectedCategoryFilter('ATMO'); }}
                style={{ background: 'none', border: 'none', width: '100%', textDecoration: 'none' }}
                aria-label="Filter worldbuilding category"
              >
                <span className="list-row-left">🕸 Worldbuilding</span>
                <span className="list-row-right">945</span>
              </button>
            </div>
            <button className="widget-view-all" onClick={() => setCurrentTab('categories')}>VIEW ALL CATEGORIES →</button>
          </div>

          {/* Trending Prompts Widget */}
          <div className="widget-card">
            <h3 className="widget-title">TRENDING PROMPTS</h3>
            <div className="widget-list">
              <button 
                className="widget-list-row" 
                onClick={() => openReader('p-1')}
                style={{ background: 'none', border: 'none', width: '100%', textAlign: 'left' }}
                aria-label="Open The Midnight Confessor"
              >
                <span className="list-row-left">
                  <span className="row-index-badge">01</span>
                  <div>
                    The Midnight Confessor
                    <span className="row-desc-sub">by Lioren</span>
                  </div>
                </span>
                <span className="list-row-right highlight">9.4</span>
              </button>
              <button 
                className="widget-list-row" 
                onClick={() => openReader('p-2')}
                style={{ background: 'none', border: 'none', width: '100%', textAlign: 'left' }}
                aria-label="Open The Last City on Earth"
              >
                <span className="list-row-left">
                  <span className="row-index-badge">02</span>
                  <div>
                    The Last City on Earth
                    <span className="row-desc-sub">by Mira Solenne</span>
                  </div>
                </span>
                <span className="list-row-right highlight">9.1</span>
              </button>
              <button 
                className="widget-list-row" 
                onClick={() => openReader('p-3')}
                style={{ background: 'none', border: 'none', width: '100%', textAlign: 'left' }}
                aria-label="Open The Senior Engineer"
              >
                <span className="list-row-left">
                  <span className="row-index-badge">03</span>
                  <div>
                    The Senior Engineer
                    <span className="row-desc-sub">by code_alchemist</span>
                  </div>
                </span>
                <span className="list-row-right highlight">8.7</span>
              </button>
            </div>
            <button className="widget-view-all" onClick={() => { setCurrentTab('feed'); setFeedSubTab('trending'); }}>VIEW ALL TRENDING →</button>
          </div>
        </aside>

      </div>
    </div>
  );
}
