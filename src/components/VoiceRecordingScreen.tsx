'use client';

import React, { useState, useEffect, useRef, useCallback } from 'react';
import { 
  PaperAirplaneIcon, 
  XMarkIcon,
  ArrowLeftIcon
} from '@heroicons/react/24/outline';

interface VoiceRecordingScreenProps {
  initialText?: string;
  onSend: (audioBlob: Blob, duration: number, existingText?: string) => void;
  onCancel: (preserveText?: boolean) => void;
  onBack: () => void;
}

export default function VoiceRecordingScreen({ 
  initialText, 
  onSend, 
  onCancel, 
  onBack 
}: VoiceRecordingScreenProps) {
  const [isRecording, setIsRecording] = useState(false);
  const [duration, setDuration] = useState(0);
  const [audioData, setAudioData] = useState<Blob | null>(null);
  const [showCancelDialog, setShowCancelDialog] = useState(false);
  const [waveformData, setWaveformData] = useState<number[]>([]);

  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioContextRef = useRef<AudioContext | null>(null);
  const analyserRef = useRef<AnalyserNode | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const animationRef = useRef<number | null>(null);

  // Auto-start recording when component mounts (per spec)
  useEffect(() => {
    startRecording();
    return () => {
      cleanup();
    };
  }, []);

  const cleanup = useCallback(() => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
    }
    if (animationRef.current) {
      cancelAnimationFrame(animationRef.current);
    }
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
    }
    if (audioContextRef.current) {
      audioContextRef.current.close();
    }
  }, []);

  const formatTime = (seconds: number): string => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const updateWaveform = useCallback(() => {
    if (analyserRef.current && isRecording) {
      const bufferLength = analyserRef.current.frequencyBinCount;
      const dataArray = new Uint8Array(bufferLength);
      analyserRef.current.getByteFrequencyData(dataArray);
      
      // Sample the data to get a manageable number of bars (around 50)
      const sampleSize = Math.floor(bufferLength / 50);
      const samples: number[] = [];
      
      for (let i = 0; i < 50; i++) {
        const start = i * sampleSize;
        const end = start + sampleSize;
        const slice = dataArray.slice(start, end);
        const average = slice.reduce((sum, value) => sum + value, 0) / slice.length;
        samples.push(average / 255); // Normalize to 0-1
      }
      
      setWaveformData(samples);
      animationRef.current = requestAnimationFrame(updateWaveform);
    }
  }, [isRecording]);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      streamRef.current = stream;

      // Set up audio context for waveform visualization
      audioContextRef.current = new AudioContext();
      const source = audioContextRef.current.createMediaStreamSource(stream);
      analyserRef.current = audioContextRef.current.createAnalyser();
      analyserRef.current.fftSize = 256;
      source.connect(analyserRef.current);

      // Set up media recorder
      mediaRecorderRef.current = new MediaRecorder(stream);
      const audioChunks: BlobPart[] = [];

      mediaRecorderRef.current.ondataavailable = (event) => {
        audioChunks.push(event.data);
      };

      mediaRecorderRef.current.onstop = () => {
        const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
        setAudioData(audioBlob);
      };

      mediaRecorderRef.current.start();
      setIsRecording(true);

      // Start timer
      timerRef.current = setInterval(() => {
        setDuration(prev => prev + 1);
      }, 1000);

      // Start waveform animation
      updateWaveform();

    } catch (error) {
      console.error('Error accessing microphone:', error);
      // Handle error (show user-friendly message)
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && isRecording) {
      mediaRecorderRef.current.stop();
      setIsRecording(false);
      
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
      if (streamRef.current) {
        streamRef.current.getTracks().forEach(track => track.stop());
      }
    }
  };

  const handleStopSend = (isLongPress: boolean = false) => {
    stopRecording();
    
    // Wait a brief moment for the recording to finalize
    setTimeout(() => {
      if (audioData) {
        onSend(audioData, duration, initialText);
      }
    }, 100);
  };

  const handleCancel = () => {
    if (isRecording) {
      setShowCancelDialog(true);
    } else {
      onCancel(true); // Preserve text
    }
  };

  const confirmDiscard = () => {
    cleanup();
    setShowCancelDialog(false);
    onCancel(true); // Preserve text when discarding recording
  };

  const keepRecording = () => {
    setShowCancelDialog(false);
  };

  return (
    <div className="voice-recording-screen">
      <div className="braintoss-bg">
        {/* Header */}
        <div className="voice-header">
          <button 
            onClick={onBack}
            className="header-back-btn"
          >
            <ArrowLeftIcon className="w-6 h-6 text-white" />
          </button>
          <h1 className="text-lg font-medium text-white">
            {isRecording ? 'Recording...' : 'Voice Note'}
          </h1>
          <div className="w-6" /> {/* Spacer */}
        </div>

        {/* Main Content */}
        <div className="voice-content">
          {/* Timer */}
          <div className="voice-timer">
            {formatTime(duration)}
          </div>

          {/* Waveform Visualization */}
          <div className="waveform-container">
            <div className="waveform">
              {waveformData.map((amplitude, index) => (
                <div
                  key={index}
                  className="waveform-bar"
                  style={{
                    height: `${Math.max(2, amplitude * 100)}%`,
                    opacity: isRecording ? 1 : 0.3
                  }}
                />
              ))}
            </div>
          </div>

          {/* Status Text */}
          <p className="voice-status">
            {isRecording ? 'Recording your voice...' : 'Recording complete'}
          </p>

          {/* Pre-existing text preview */}
          {initialText && (
            <div className="existing-text-preview">
              <p className="text-sm text-white/70 mb-2">Existing text:</p>
              <div className="existing-text-content">
                {initialText}
              </div>
            </div>
          )}
        </div>

        {/* Control Buttons */}
        <div className="voice-controls">
          {isRecording ? (
            <>
              {/* Cancel Button */}
              <button 
                onClick={handleCancel}
                className="voice-btn voice-btn-cancel"
              >
                <XMarkIcon className="w-6 h-6" />
                <span>Cancel</span>
              </button>

              {/* Stop/Send Button */}
              <button 
                onClick={() => handleStopSend(false)}
                onContextMenu={(e) => {
                  e.preventDefault();
                  handleStopSend(true);
                }}
                className="voice-btn voice-btn-send"
              >
                <PaperAirplaneIcon className="w-6 h-6" />
                <span>Stop & Send</span>
              </button>
            </>
          ) : (
            <>
              {/* Start Over Button */}
              <button 
                onClick={startRecording}
                className="voice-btn voice-btn-cancel"
              >
                <span>Record Again</span>
              </button>

              {/* Send Button */}
              <button 
                onClick={() => handleStopSend(false)}
                onContextMenu={(e) => {
                  e.preventDefault();
                  handleStopSend(true);
                }}
                className="voice-btn voice-btn-send"
                disabled={!audioData}
              >
                <PaperAirplaneIcon className="w-6 h-6" />
                <span>Send</span>
              </button>
            </>
          )}
        </div>
      </div>

      {/* Cancel Confirmation Dialog */}
      {showCancelDialog && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h2 className="modal-title">Discard this voice recording?</h2>
            <p className="modal-text">
              Your voice recording will be lost, but any text you typed will be preserved.
            </p>
            <div className="modal-buttons">
              <button 
                onClick={keepRecording}
                className="modal-btn modal-btn-secondary"
              >
                Keep Recording
              </button>
              <button 
                onClick={confirmDiscard}
                className="modal-btn modal-btn-primary"
              >
                Discard
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}