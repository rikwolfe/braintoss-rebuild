'use client';

import React, { useState, useRef, useEffect } from 'react';
import { 
  MicrophoneIcon, 
  CameraIcon, 
  PaperAirplaneIcon,
  ClockIcon,
  ArchiveBoxIcon,
  Cog6ToothIcon,
  DocumentIcon,
  XMarkIcon
} from '@heroicons/react/24/outline';

// This will be moved to a proper state management solution later
interface StagedAttachment {
  type: 'image' | 'pdf';
  filename: string;
  preview?: string; // for images
}

export default function MainTextScreen() {
  const [textInput, setTextInput] = useState('');
  const [stagedAttachments, setStagedAttachments] = useState<StagedAttachment[]>([]);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // Auto-focus text area on mount (spec requirement)
  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.focus();
    }
  }, []);

  // Handle send action
  const handleSend = (isLongPress: boolean = false) => {
    // TODO: Implement actual send logic based on spec
    console.log('Sending toss:', { 
      text: textInput, 
      attachments: stagedAttachments,
      isLongPress 
    });
    
    // Clear after sending (spec requirement)
    setTextInput('');
    setStagedAttachments([]);
    
    // Re-focus for next input
    setTimeout(() => {
      if (textareaRef.current) {
        textareaRef.current.focus();
      }
    }, 100);
  };

  // Handle voice recording
  const handleVoiceRecord = () => {
    // TODO: Navigate to Voice Recording Screen
    console.log('Starting voice recording...');
  };

  // Handle photo capture
  const handlePhotoCapture = () => {
    // TODO: Navigate to Camera Screen
    console.log('Opening camera...');
  };

  // Remove staged attachment
  const removeAttachment = (index: number) => {
    setStagedAttachments(prev => prev.filter((_, i) => i !== index));
  };

  return (
    <div className="screen-container">
      {/* Top Bar */}
      <div className="top-bar">
        <button className="btn-icon hover:bg-gray-100">
          <ArchiveBoxIcon className="w-6 h-6 text-gray-700" />
        </button>
        
        <h1 className="text-xl font-semibold text-gray-900">
          Braintoss
        </h1>
        
        <button className="btn-icon hover:bg-gray-100">
          <Cog6ToothIcon className="w-6 h-6 text-gray-700" />
        </button>
      </div>

      {/* Content Area */}
      <div className="content-area">
        {/* Main Text Input */}
        <textarea
          ref={textareaRef}
          value={textInput}
          onChange={(e) => setTextInput(e.target.value)}
          placeholder="Type your thoughts…"
          className="text-input-main"
          rows={6}
        />
        
        {/* Attachment Strip */}
        {stagedAttachments.length > 0 && (
          <div className="mt-4 flex flex-wrap gap-2">
            {stagedAttachments.map((attachment, index) => (
              <div key={index} className="relative">
                {attachment.type === 'image' ? (
                  <div className="relative">
                    <img
                      src={attachment.preview}
                      alt={attachment.filename}
                      className="attachment-thumbnail"
                    />
                    <button
                      onClick={() => removeAttachment(index)}
                      className="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center hover:bg-red-600"
                    >
                      <XMarkIcon className="w-4 h-4" />
                    </button>
                  </div>
                ) : (
                  <div className="attachment-chip">
                    <DocumentIcon className="w-4 h-4 mr-2" />
                    <span className="truncate max-w-32">{attachment.filename}</span>
                    <button
                      onClick={() => removeAttachment(index)}
                      className="ml-2 w-4 h-4 text-gray-500 hover:text-red-500"
                    >
                      <XMarkIcon className="w-4 h-4" />
                    </button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Bottom Action Row */}
      <div className="bottom-actions">
        <div className="action-row">
          {/* Voice Button */}
          <button 
            onClick={handleVoiceRecord}
            className="btn-voice"
            title="Record voice note"
          >
            <MicrophoneIcon className="w-6 h-6" />
          </button>

          {/* Send Button (center, large) */}
          <button 
            onClick={() => handleSend(false)}
            onContextMenu={(e) => {
              e.preventDefault();
              handleSend(true);
            }}
            className="btn-send"
            disabled={!textInput.trim() && stagedAttachments.length === 0}
          >
            <PaperAirplaneIcon className="w-6 h-6 mr-2" />
            Send
          </button>

          {/* Photo Button */}
          <button 
            onClick={handlePhotoCapture}
            className="btn-photo"
            title="Take or choose photo"
          >
            <CameraIcon className="w-6 h-6" />
          </button>
        </div>
        
        {/* Helper text */}
        <p className="text-center text-xs text-gray-500 mt-2">
          Long-press Send to choose destination
        </p>
      </div>
    </div>
  );
}