# Workflows & Procedures

## Consolidation Checklist
Before consolidating, ask:
1. What was the ESSENCE of this session? (1-2 sentences)
2. Any LESSONS LEARNED worth preserving?
3. What's ACTIVE vs COMPLETED?
4. What can be ARCHIVED externally?
5. What are my NEXT 3-5 actions?

## YouTube Upload Workflow (Reference)
1. YouTube Studio → Create → Upload
2. Ctrl+L in file dialog for path
3. Triple-click for title selection
4. Press Escape after hashtags
5. Scroll DOWN for Audience settings
6. Click "Public" radio button

## FFmpeg Quick Reference
```bash
# Cross-fade transitions
ffmpeg -y -i in1.mp4 -i in2.mp4 -filter_complex \
  "[0:v][1:v]xfade=transition=fade:duration=0.5:offset=SECONDS[v]" \
  -map "[v]" output.mp4

# Audio normalization (-16dB LUFS)
ffmpeg -y -i input.mp4 \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy output.mp4
```
