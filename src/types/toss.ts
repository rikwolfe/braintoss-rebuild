/**
 * Braintoss Core Data Types
 * Based on Functional Specification Section 4
 */

export type TossId = string;
export type DeliveryStatus = 'queued' | 'sending' | 'sent' | 'failed';

export interface Location {
  coords: {
    lat: number;
    lon: number;
    accuracy?: number;
  };
  address?: string; // reverse-geocoded if available
}

export interface Attachment {
  path: string;
  filename: string;
  mime: string;
}

export interface Attachments {
  audio?: Attachment;
  image?: Attachment;
  pdf?: Attachment;
  ics?: Attachment; // generated, optional
  vcf?: Attachment; // generated, optional
}

export interface TossFlags {
  ai_complete: boolean;
  ai_failed: boolean;
  event_detected: boolean;
  vcard_detected: boolean;
}

/**
 * Core Toss entity - represents a single capture that results in an email
 */
export interface Toss {
  // Core identification
  toss_id: TossId;
  created_at: string; // UTC ISO 8601
  local_time: string; // formatted YYYY-MM-DD HH:MM
  
  // Text content (user and AI-generated)
  text_user?: string; // user-typed note/caption; may be empty
  text_ai_transcript?: string; // from voice transcription
  text_ai_ocr?: string; // from image OCR
  text_ai_image_desc?: string; // short human description/tags
  text_ai_title?: string; // short title used for Subject
  
  // Media attachments
  attachments: Attachments;
  
  // Context
  location?: Location;
  
  // Email delivery
  destination_email_id: string; // selected email account
  delivery_status: DeliveryStatus;
  delivery_attempts: number;
  delivery_last_error?: string;
  
  // AI processing flags
  flags: TossFlags;
}

/**
 * Email destination configuration
 */
export interface EmailDestination {
  id: string;
  email: string;
  name?: string;
  is_default: boolean;
}

/**
 * App settings based on Functional Specification Section 10
 */
export interface AppSettings {
  // Account / Destination
  default_email_id?: string;
  email_destinations: EmailDestination[];
  subject_prefix: string; // default "[Braintoss]"
  
  // Capture & Processing  
  voice_language: 'auto' | string; // 'auto' or specific language code
  calendar_events_enabled: boolean; // ICS generation
  ocr_enabled: boolean;
  
  // App Behavior & Appearance
  theme: 'system' | 'light' | 'dark';
  sounds_enabled: boolean;
  haptics_enabled: boolean;
  
  // Data Management
  history_retention: '1month' | '1year' | 'indefinite';
}

/**
 * Email composition data for sending
 */
export interface EmailData {
  to: string;
  subject: string;
  html_body: string;
  text_body: string;
  attachments: Attachment[];
}

/**
 * AI Processing results
 */
export interface AIProcessingResult {
  transcript?: string;
  ocr_text?: string;
  image_description?: string;
  title?: string;
  event_detected?: boolean;
  vcard_detected?: boolean;
  ics_file?: Attachment;
  vcf_file?: Attachment;
}

/**
 * Capture input types for different workflows
 */
export type CaptureType = 'text' | 'voice' | 'photo' | 'pdf';

export interface CaptureInput {
  type: CaptureType;
  text?: string;
  audio_path?: string;
  image_path?: string;
  pdf_path?: string;
}

/**
 * Search parameters for history
 */
export interface SearchParams {
  query?: string;
  from_date?: Date;
  to_date?: Date;
  types?: CaptureType[];
}

/**
 * UI state types
 */
export type Screen = 'main' | 'voice_recording' | 'camera' | 'photo_preview' | 'history' | 'settings';

export interface UIState {
  current_screen: Screen;
  text_input: string;
  staged_attachments: Partial<Attachments>;
  is_recording: boolean;
  recording_duration?: number;
}