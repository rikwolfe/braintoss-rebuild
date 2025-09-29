# Braintoss 2025 — Functional Design (On-Device, No Backend)

> **Purpose**: Define the complete functional behavior of the Braintoss app redesigned for 2025.  
> **Principles**: One-tap capture, on-device processing, reliability, privacy, simplicity.

---

## 0) Glossary

- **Toss**: A single capture (text, photo, voice and/or PDF) that results in an email.
- **Main Text Screen**: Default screen shown on launch; text-first UI with keyboard open.
- **Preview & Caption**: Screen shown after selecting/taking a photo (or pasting/sharing an image).
- **Share-in**: Using the OS Share Sheet from another app into Braintoss.

---

## 1) Scope & Non-Goals

### 1.1 Scope
- Capture thoughts **fast** as:
  - Text
  - Voice (with audio file + on-device transcription)
  - Photo (with optional caption + on-device OCR/interpretation)
  - PDF attachments (pasted/shared)
- Send results **by email only** (no third-party integrations or server mailbox processing).
- All AI (transcription/OCR/image interpretation/NLU titling/event detection) runs **on-device**.

### 1.2 Non-Goals (MVP)
- No backend server; no cloud sync.
- No integrations (Todoist/Evernote/Dropbox/etc.).
- No special "business card mode" (vCard is opportunistic AI only).
- No non-PDF document types (e.g., DOCX) in MVP.
- No multi-file arbitrary attachments beyond Images & single PDFs per toss (MVP).
- No cross-device history sync.

---

## 2) Core Philosophy

- **Drop it while it's hot**: Capture must be instant; sending is guaranteed without user friction.
- **On-device first**: Privacy and offline robustness.
- **Simplicity**: Familiar patterns (inspired by WhatsApp/iMessage/Photos), minimal options up front.
- **Memory of intent**: Enrich with time, place, transcription/OCR, AI titles, and optional ICS for time-bound intent.

---

## 3) Platforms & Processing

- **iOS** and **Android** supported.
- AI runs fully on-device for:
  - Speech-to-text (voice transcription)
  - Text recognition in images (OCR)
  - Image interpretation (tags/labels → human-friendly description)
  - AI titling (short subject-like title)
  - Event detection (NLU) → optional `.ics`
- **Language strategy**:
  - Voice: Auto-detect if feasible; default to OS language; user override available.
  - OCR: MVP focuses on a robust language (e.g., English) and may tie to the voice setting; expand later.

---

## 4) Information Captured Per Toss

Each toss stores locally (for history/search and email assembly):

- `toss_id` (local unique ID)
- `created_at` (UTC ISO 8601) + `local_time` (formatted `YYYY-MM-DD HH:MM`)
- `text_user` (user-typed note/caption; may be empty)
- `text_ai_transcript` (from voice)
- `text_ai_ocr` (from image OCR)
- `text_ai_image_desc` (short human description / tags)
- `text_ai_title` (short title used for Subject when applicable)
- `attachments`:
  - `audio` (path/filename, mime)
  - `image` (path/filename, mime)
  - `pdf` (path/filename, mime)
  - `ics` (generated; path/filename, mime) — optional
  - `vcf` (generated; path/filename, mime) — optional
- `location`:
  - `coords` (lat, lon, accuracy)
  - `address` (reverse-geocoded if available)
- `destination_email_id` (selected email account)
- `delivery_status` (queued | sending | sent | failed)
- `delivery_attempts` (counter)
- `delivery_last_error` (string/enum)
- `flags`:
  - `ai_complete` (bool)
  - `ai_failed` (bool)
  - `event_detected` (bool)
  - `vcard_detected` (bool)

---

## 5) Main UI

### 5.1 Main Text Screen (launch default)
- **Top bar**:
  - Left: **History** icon
  - Right: **Settings** icon
- **Body**:
  - **Text input** (multi-line, placeholder: "Type your thoughts…")
  - **Attachment strip** (chips/thumbnail row under text):
    - Image thumbnail (if staged)
    - PDF chip (icon + filename)
    - Tap thumbnail/chip → manage/remove before sending
- **Bottom action row**:
  - **Voice** button (left)
  - **Send** button (center; large)
  - **Photo** button (right)
- **Keyboard**:
  - Opens automatically on launch and when returning to Main Text Screen

### 5.2 Long-press on Send (universal rule)
- If only **one** destination is configured: long-press behaves like tap (send).
- If **multiple** destinations: show chooser sheet to pick destination; choice applies to this toss only.

---

## 6) Capture Workflows

### 6.1 Text-only
1) Launch → Main Text Screen (keyboard focused)  
2) Type note  
3) Tap **Send** (or long-press → choose destination)  
4) System:
   - Queue toss `text_user` + context
   - Capture location
   - Background AI (titling, NLU/ICS)
   - Return to **cleared** Main Text Screen

### 6.2 Text + Voice
1) Main Text Screen: type (optional)  
2) Tap **Voice** → **Voice Recording Screen**:
   - Recording auto-starts
   - UI: waveform/timer, **Stop/Send** (primary), **Cancel** (secondary)
3) Speak
4) **Stop/Send** (tap) or long-press (destination)
   - System queues toss with audio + existing text
   - Location captured; background AI transcription & titling; email assembly
   - Return to cleared Main Text Screen
5) **Cancel** (if tapped during recording)
   - Confirm dialog: "Discard this voice recording?"
   - **Discard** → back to Main Text Screen (text preserved)
   - **Keep** → stay recording

**Voice-only variant**: Same as above but without initial text. Transcription becomes body; AI title becomes subject.

### 6.3 Text + Photo
1) Main Text Screen: type (optional)  
2) Tap **Photo** → **Camera Screen**
   - Live view; shutter; flip; flash; photo library; **Back**
3) Take photo or choose from library
4) **Photo Preview & Caption Screen**
   - Large preview
   - Caption text field:
     - Pre-filled with text from Main Text Screen (if any)
     - Keyboard active
   - Actions:
     - **Send** (primary; long-press for destination)
     - **Back / Change Photo** (returns to camera/library; caption preserved)
     - **Discard Photo** (returns to Main Text Screen; caption moved into text field)
     - **Cancel All** (confirm dialog; discards everything → cleared Main)
5) **Send** → queue toss (image + caption), capture location, background AI (OCR/description/titling/ICS), return to cleared Main

**Photo-only variant**: Same as above with empty caption by default. If user leaves it blank, AI image interpretation + OCR provide body/title.

### 6.4 Pasteboard (from clipboard)
- **Paste text** into text area → stays on Main Text Screen
- **Paste image** into text area → open **Photo Preview & Caption** with pasted image; caption pre-filled with current text if any
- **Paste PDF** into text area → stay on Main; stage PDF (chip), allow edit text, then send

### 6.5 Share-in (OS Share Sheet)
- **Text only** → open Main Text Screen with text pre-filled
- **Image (with/without text)** → open **Photo Preview & Caption**; caption pre-filled with shared text if present
- **PDF (with/without text)** → open Main Text Screen; stage PDF chip; pre-fill text if present

---

## 7) Email Composition

### 7.1 Sending Mechanism (priority order)
**Plan A (Preferred)**: Silent/Direct on-device send via system-configured account (background-capable).  
**Plan B**: OS handoff to default mail client (compose sheet or silent queue; one extra step may occur depending on OS/app).  
**Plan C**: Commercial mail relay (only if A/B can't guarantee reliability; no content processing on server).

> Functional requirement: **Never hold the email** to wait for AI. Core payload (user text + raw media + timestamp + location) must send immediately. AI enrichments are best-effort pre-send; if not ready, the email still goes.

### 7.2 Subject Line (prefix + content)
- **Prefix**: `[Braintoss]` (configurable in Settings; can be cleared)
- **Content priority**:
  1. If user typed short text suitable as title → use directly
  2. If user typed long text → attempt **AI Title** on device; if not available in time → first N chars of user text (N ~ 60–80)
  3. Voice-only → AI Title from transcription
  4. Image-only → user caption if present; else AI Image Title (from OCR + image interpretation)
  5. Fallback → `** here's your Braintoss **`
- Trim to safe length for common clients; avoid emoji-only subjects.

### 7.3 Body (HTML, clean & indexable)
**Order (when present):**
1. **User Note/Caption** (verbatim)
2. **Transcription** (voice) — labeled
3. **OCR text & Image Description** (image) — labeled
4. **When & Where** section:
   - **Captured**: `YYYY-MM-DD HH:MM` (device local)
   - **Location**:
     - Display: reverse-geocoded address (if available), else lat/long
     - Links (platform-agnostic):
       - **Apple Maps**: `https://maps.apple.com/?ll=LAT,LON&q=Braintoss`
       - **Google Maps**: `https://maps.google.com/?q=LAT,LON`
5. **Tags/Labels** (image interpretation) — compact comma-separated list
6. **Event detected** (if any; brief summary)
7. **Disclaimer**: "Automated on-device transcription/OCR may contain errors."

**Formatting rules**
- Simple CSS-safe HTML; no heavy styling.
- Avoid tracking pixels; no remote images.
- Use semantic headings (small `<strong>` labels) for sections.
- Preserve line breaks in user text.
- Provide plaintext alternative (MIME multipart/alternative).

### 7.4 Attachments
- **Audio**: e.g., `.m4a` (friendly format), filename: `braintoss-YYYYMMDD-HHMMSS.m4a`
- **Image**: e.g., `.jpg` (reasonable compression), filename: `braintoss-YYYYMMDD-HHMMSS.jpg`
- **PDF** (if shared/pasted): original; filename preserved if available, else `braintoss-YYYYMMDD-HHMMSS.pdf`
- **ICS** (if event detected): `event-YYYYMMDD-HHMM.ics`
- **VCF** (if robust business-card detection): `contact-YYYYMMDD-HHMM.vcf`

---

## 8) AI (On-Device) — Behavior & Constraints

### 8.1 Voice Transcription
- Trigger: after queueing (non-blocking).
- Language: auto-detect if available; else OS language; user override.
- Result stored as `text_ai_transcript`; inserted into body; influences AI Title & ICS.

### 8.2 Image OCR & Interpretation
- OCR extracts textual content.
- Image interpretation yields tags and a 1–2 line human-friendly description.
- Result stored as `text_ai_ocr` + `text_ai_image_desc`; used in body & AI Title.

### 8.3 Opportunistic vCard
- If AI confidently recognizes a business card and parses clean contact fields:
  - Attach `.vcf`
  - Add brief line in body: "Contact info attached (vCard)."
- No explicit user mode; do nothing unless high confidence.

### 8.4 AI Titling
- Short, descriptive title derived from user text, transcription, and/or image analysis.
- Must fit common subject-length constraints.
- Conservative with emojis; avoid shouting case; sentence case preferred.

### 8.5 ICS Event Detection (Ambitious, opt-out available)
- Parse user text + transcription + OCR for dates/times/durations/locations.
- If confidently detected:
  - Build `.ics` with `SUMMARY` = AI Title (or first line of user text), `DTSTART` (local → UTC), `DTEND` (default duration if unspecified, e.g., 30 or 60 min), `LOCATION` (if available), `DESCRIPTION` (short reference to toss content).
- **Important**: ICS generation **must not delay** sending. If ICS is ready pre-send, attach; otherwise skip for this email.
- Optional non-blocking banner (setting-controlled): "Event detected — Add to Calendar" deep link (opening OS calendar prefilled). Default **off** (stay interruption-free).

---

## 9) History (On-Device)

> A reliable local ledger of recent tosses with powerful search.

### 9.1 Contents & Retention
- Stores all fields listed in **§4**
- Retention (Settings): **1 Month**, **1 Year**, **Keep Indefinitely**
  - Auto-prune when limit met (respect "Keep Indefinitely")
  - Manual **Clear All…** (confirmation required)

### 9.2 List View
- Sorted newest → oldest
- Each row shows:
  - **Primary line**: User text or AI Title (fallback to type label: "Voice note", "Photo note", "PDF note")
  - **Meta**: date/time (local), destination indicator (optional icon/label), delivery status badge (Sent/Queued/Failed)
  - **Type icons**: text, image, voice, PDF (multiple if multi-part)
  - **Thumb/chip** for image/PDF when space permits

### 9.3 Item Detail
- Opens a read-only view mirroring the email body structure and lists attachments.
- Actions:
  - **Resend** (to default destination)
  - **Long-press Resend** → choose alternate destination
  - **Delete** (single item; confirmation)

### 9.4 Search (Gmail-like, local)
- Free-text searches across:
  - user text, transcription, OCR text, image description/tags, address, and AI title
- Date filters (simple pickers for from/to)
- (Optional) Simple type filters (image / voice / pdf) for MVP if low complexity
- Results update list view; search term highlighting in result rows is optional

---

## 10) Settings

### 10.1 Account / Destination
- **Default Email Address** (required)
- **Manage Alternative Emails** (add/edit/delete up to 4)
- **Subject Prefix** (default `[Braintoss]`, editable/clearable)
- Behavior: If multiple emails exist, long-press Send shows chooser.

### 10.2 Capture & Processing
- **Voice Transcription Language**
  - **Auto-detect** (default where feasible)
  - Or **Choose language** (override OS)
  - Falls back to OS language when unset
- **Calendar Events (.ics)** → toggle (default ON or OFF per product decision)
- **OCR/Image Interpretation** → toggle (default ON)
- (Future) OCR language pack selector (MVP may tie to voice/OS)

### 10.3 App Behavior & Appearance
- **Theme**: System / Light / Dark
- **Sounds**: toggle (e.g., send swoosh)
- **Haptics**: toggle
- **Notifications**: "Manage in OS Settings" deep link (used for failure alerts/badge)

### 10.4 Data Management
- **History Retention**: 1 Month / 1 Year / Keep Indefinitely
- **Manage History**: Clear All… (confirmation)

### 10.5 Help & Info
- **Tutorial** (replay onboarding)
- **Troubleshooting / Not receiving mails?** (FAQ)
- **Share Braintoss** (OS share intent)
- **About** (version, privacy policy, support contact)

---

## 11) Onboarding (First Launch)

**Flow (suggested content, minimal taps):**
1. **Welcome**: What Braintoss does (type / snap / speak → to your inbox). Privacy-first, on-device AI.
2. **Set Destination**: Ask for default email; **Send Test** button (sends hello test).
3. **Permissions** (contextual or batched with rationale):
   - Microphone (when first tapping Voice)
   - Camera/Photos (when first tapping Photo)
   - Location (when sending first toss; explains "adds context to help you remember")
   - Notifications (after first send; explains "only for send failures")
4. **Tip**: Long-press Send to choose alternate destination (if >1).
5. Done → Main Text Screen.

---

## 12) Error Handling & Reliability

### 12.1 Sending
- **Never block send** waiting on AI.
- If **no mail account configured**:
  - Show clear error: "No mail account is set up. Add one in Settings."
  - Toss is still saved to History (status: **Failed**).
- If **network offline**:
  - Queue toss; attempt background send when network returns.
  - If OS background limits prevent sending, attempt on next app foreground.
- **Retries**:
  - Auto retry with backoff on app open or network regain.
- **Notifications / Badges**:
  - **Only on problems**: badge count = unsent/failed count
  - Optional subtle in-app banner in History

### 12.2 AI Failures
- If transcription/OCR/title/ICS fail or time out:
  - Send continues with raw media + user text
  - History flags `ai_failed` (for internal diagnostics or UI hint)
  - No intrusive alerts needed

### 12.3 File Issues
- If image/PDF too large:
  - Offer compression for images (retain readable quality)
  - PDFs: notify user and allow cancel/remove attachment

### 12.4 Delete Confirmations
- **Delete Item**: "Delete this toss?" (Confirm/Cancel)
- **Clear All History**: "[X] items will be permanently deleted." (Confirm/Cancel)

---

## 13) Visual & Content Details

### 13.1 Iconography (minimum set)
- **Text** bubble
- **Microphone**
- **Camera**
- **PDF** file
- **History** (list/archive)
- **Settings** (gear)
- **Send** (paper plane)
- **Status**: Sent (check), Queued (clock), Failed (warning)

### 13.2 Placeholders & Labels
- Main text placeholder: **"Type your thoughts…"**
- Photo caption placeholder: **"Add a caption (optional)"**
- Voice recording: timer + "Recording…"
- History empty state: "No recent tosses yet."

### 13.3 File Naming
- Images: `braintoss-YYYYMMDD-HHMMSS.jpg`
- Audio:  `braintoss-YYYYMMDD-HHMMSS.m4a`
- PDF:    `original-filename.pdf` or `braintoss-YYYYMMDD-HHMMSS.pdf`
- ICS:    `event-YYYYMMDD-HHMM.ics`
- VCF:    `contact-YYYYMMDD-HHMM.vcf`

---

## 14) Security & Privacy (Functional Expectations)

- All AI processing local to device; no content leaves device except via user's email send.
- No analytics that transmit content.
- Location captured for memory aid; user consent via OS; shown/linked in email.
- No tracking pixels or external assets in email.

---

## 15) Constraints & Edge Cases

- **Background sending**: Best effort; if OS limits, send on next open.
- **Watch** (if applicable/platform): Voice capture proxy to phone; follows same rules (MVP optional).
- **Multiple attachments**:
  - Allow **one** image OR **one** PDF OR image+audio (image+voice is allowed via flows).
  - If user tries to add PDF and image together (MVP decision): either allow both, or warn and let user choose one (product call: **MVP = allow one media type + audio**).
- **Share-in with mixed content**:
  - If text+image → goes to Photo Preview & Caption with caption prefilled.
  - If text+pdf → goes to Main with staged PDF and text.
- **Language mismatch**:
  - If auto-detect uncertain → fall back to OS language; user can override in Settings.

---

## 16) Decision Log (Key Commitments)

- **Text-first main UI** with keyboard open on launch.
- **No "+" icons** above Voice/Photo on main screen; media options handled in their flows.
- **Long-press Send** to select destination (active only if >1 email configured).
- **Photo captioning happens on the Preview screen** (keyboard auto-open).
- **Voice cancel shows confirmation**; discard returns to Main with text preserved.
- **Share-in images go to Preview & Caption**; PDFs to Main (staged).
- **Paste image opens Preview & Caption**; paste PDF stages to Main.
- **PDF attachments supported in MVP** (no PDF OCR in MVP).
- **Always attach raw media** by default (audio/image/PDF).
- **Subject prefix** `[Braintoss]` configurable.
- **Subject content** follows defined priority; robust fallbacks.
- **Email body**: clean HTML; includes user text, AI texts (when ready), timestamp, location (address + Apple & Google links), tags, disclaimer.
- **ICS is ambitious but must not block send**; attach only if ready in time.
- **vCard is opportunistic** (only when high-confidence).
- **History**: on-device; powerful local search; retention options (1 Month / 1 Year / Indefinite); long-press history item → resend to another destination.
- **Notifications** used **only on problems** (badges/quiet alerts).
- **Onboarding** includes default email, single test email, and contextual permission requests.

---

## 17) Open Product Knobs (to confirm defaults)

- ICS toggle default: **ON** / OFF
- OCR/Image interpretation default: **ON**
- History retention default: **1 Year**
- Theme default: **System**
- Sounds/Haptics default: **ON**
- Subject prefix default: **`[Braintoss]`**
- Allow image + audio together: **YES** (recommended) / NO
- Max subject length before truncation: **~70 chars** (tune per testing)

---

# End of Document