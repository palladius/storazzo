# Product Guidelines

## Prose Style
- **Friendly & Informal:** The CLI should communicate in an approachable manner, utilizing emoji (e.g., 💽, ☁️, 🤐) and a conversational tone.
- **Clarity over Brevity:** While informal, instructions and outputs must remain crystal clear, avoiding ambiguity in technical operations.

## Branding & Tone
- **Professional Utility:** Despite the friendly prose, the underlying tool must feel clean, robust, and highly functional. It is a reliable partner for managing critical data.
- **Trustworthy:** Every interaction should reinforce the user's confidence in the tool's ability to safely handle their files.

## UX & Interaction Principles
- **Progress-Oriented:** For long-running operations like MD5 hashing or cloud synchronization, the tool MUST provide real-time feedback via progress bars and percentage indicators. No operation should ever "hang" in silence.
- **Safety First:** Mandatory confirmation dialogues are required before performing any large-scale cloud uploads, deletions, or actions that significantly alter the local catalog.
- **User-Centric Errors:** Error messages should not just report failures but suggest potential solutions or next steps in a helpful, friendly way.