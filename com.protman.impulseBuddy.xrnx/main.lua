
function WipeEfxFromSelection()
local ecvisible=nil

if renoise.song().selection_in_pattern==nil then return
else end
ecvisible=renoise.song().tracks[renoise.song().selected_track_index].visible_effect_columns

for i=renoise.song().selection_in_pattern.start_line,renoise.song().selection_in_pattern.end_line do renoise.song().patterns[renoise.song().selected_pattern_index].tracks[renoise.song().selected_track_index].lines[i].effect_columns[ecvisible].number_string="" 
renoise.song().patterns[renoise.song().selected_pattern_index].tracks[renoise.song().selected_track_index].lines[i].effect_columns[ecvisible].amount_string=""
end
end

renoise.tool():add_keybinding {name = "Global:impulseBuddy:Wipe Effects From Selection", invoke = function() WipeEfxFromSelection() end}


--from http://lua-users.org/lists/lua-l/2004-09/msg00054.html thax!
function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end
--from http://lua-users.org/lists/lua-l/2004-09/msg00054.html thax!


--IT: Alt-D except patternwide
function DoubleSelectPattern()
 local s = renoise.song()
 local lpb = s.transport.lpb
 local sip = s.selection_in_pattern
-- local last_column = s.selected_track.visible_effect_columns + s.selected_track.visible_note_columns
 local last_column = s.selected_track.visible_note_columns

 if sip == nil or sip.start_track ~= s.selected_track_index or s.selected_line_index ~= s.selection_in_pattern.start_line then 
 
  s.selection_in_pattern = { 
    start_line = s.selected_line_index, 
      end_line = lpb + s.selected_line_index - 1,
   start_track = 1, 
     end_track = renoise.song().sequencer_track_count+1, 
  start_column = 1, 
    end_column = last_column }
 else 
  local endline = sip.end_line
  local startline = sip.start_line
  local new_endline = (endline - startline) * 2 + (startline + 1)

  if new_endline > s.selected_pattern.number_of_lines then
   new_endline = s.selected_pattern.number_of_lines
  end

print ("new_endline " .. new_endline)
  s.selection_in_pattern = { 
    start_line = startline, 
      end_line = new_endline, 
   start_track = 1, 
     end_track = renoise.song().sequencer_track_count+1, 
  start_column = 1, 
    end_column = last_column }
 end
end

--IT: Alt-D except  current column only
function DoubleSelectColumnOnly()
 local s = renoise.song()
 local lpb = s.transport.lpb
 local sip = s.selection_in_pattern
 local last_column = s.selected_track.visible_effect_columns + s.selected_track.visible_note_columns
 local currTrak=s.selected_track_index
 local selection=nil
 
 if s.selected_note_column_index==0 then selection=renoise.song().tracks[currTrak].visible_note_columns+s.selected_effect_column_index
 else selection=s.selected_note_column_index
end 
 if sip == nil or sip.start_track ~= s.selected_track_index or s.selected_line_index ~= s.selection_in_pattern.start_line then 
 
  s.selection_in_pattern = { 
    start_line = s.selected_line_index, 
      end_line = lpb + s.selected_line_index - 1,
   start_track = s.selected_track_index, 
     end_track = s.selected_track_index, 
  start_column = selection, 
    end_column = selection }
 else 

  local endline = sip.end_line
  local startline = sip.start_line
  local new_endline = (endline - startline) * 2 + (startline + 1)

  if new_endline > s.selected_pattern.number_of_lines then
   new_endline = s.selected_pattern.number_of_lines
  end

  s.selection_in_pattern = { 
    start_line = startline, 
      end_line = new_endline, 
   start_track = s.selected_track_index, 
     end_track = s.selected_track_index, 
  start_column = selection, 
    end_column = selection }
 end
end

--IT: ALT-D (whole track)
function DoubleSelect()
 
 local s = renoise.song()
 local lpb = s.transport.lpb
 local sip = s.selection_in_pattern
 local last_column = s.selected_track.visible_effect_columns + s.selected_track.visible_note_columns

 if sip == nil or sip.start_track ~= s.selected_track_index or s.selected_line_index ~= s.selection_in_pattern.start_line then 
 
  s.selection_in_pattern = { 
    start_line = s.selected_line_index, 
      end_line = lpb + s.selected_line_index - 1,
   start_track = s.selected_track_index, 
     end_track = s.selected_track_index, 
  start_column = 1, 
    end_column = last_column }
 else 

  local endline = sip.end_line
  local startline = sip.start_line
  local new_endline = (endline - startline) * 2 + (startline + 1)

  if new_endline > s.selected_pattern.number_of_lines then
   new_endline = s.selected_pattern.number_of_lines
  end

  s.selection_in_pattern = { 
    start_line = startline, 
      end_line = new_endline, 
   start_track = s.selected_track_index, 
     end_track = s.selected_track_index, 
  start_column = 1, 
    end_column = last_column }
 end
end

renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy DoubleSelect (ALT-D)", invoke = function() DoubleSelect() end}
renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy DoubleSelectColumnOnly (Protman)", invoke = function() DoubleSelectColumnOnly() end}
renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy DoubleSelectPattern", invoke = function() DoubleSelectPattern() end}
renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy Unmark Selection (ALT-U)", invoke = function() Deselect_All() end}
renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy 2nd Unmark Selection (CTRL-U)", invoke = function() Deselect_All() end}
renoise.tool():add_keybinding {name = "Pattern Editor:Selection:impulseBuddy Mark Track/Mark Pattern (ALT-L)", invoke = function() MarkTrackMarkPattern() end}

function Deselect_All()
renoise.song().selection_in_pattern = nil
end

function MarkTrackMarkPattern()
local st=nil
local et=nil
local sl=nil
local el=nil
local s=renoise.song()
local sip=s.selection_in_pattern
local sp=s.selected_pattern
if s.selection_in_pattern ~= nil then 
  st = sip.start_track
  et = sip.end_track
  sl = sip.start_line
  el = sip.end_line

  if st == et and st == s.selected_track_index then
    if sl == 1 and el == sp.number_of_lines then
      s.selection_in_pattern = {
        start_track = 1,
        end_track = s.sequencer_track_count,
          start_line=1,
        end_line=sp.number_of_lines
      }
    else
        s.selection_in_pattern = {
        start_track = st,
          end_track = et,
          start_line = 1, 
       end_line = sp.number_of_lines}
    end
  else
      s.selection_in_pattern = {
      start_track = s.selected_track_index,
        end_track = s.selected_track_index,
        start_line = 1, 
        end_line = sp.number_of_lines}
  end
else
  s.selection_in_pattern ={
      start_track = s.selected_track_index,
        end_track = s.selected_track_index,
        start_line = 1, 
        end_line = sp.number_of_lines}
end
end




--Protman's Expand Selection
function cpclex_line(track, from_line, to_line)
  local cur_track = renoise.song():pattern(renoise.song().selected_pattern_index):track(track)
  cur_track:line(to_line):copy_from(cur_track:line(from_line))
  cur_track:line(from_line):clear()
  cur_track:line(to_line+1):clear()
end

function ExpandSelection()
  local sl = renoise.song().selection_in_pattern.start_line
  local el = renoise.song().selection_in_pattern.end_line
  local st = renoise.song().selection_in_pattern.start_track
  local et = renoise.song().selection_in_pattern.end_track
  local nl = renoise.song().selected_pattern.number_of_lines
  local tr
  
  for tr=st,et do
    for l =el,sl,-1 do
      if l ~= sl and l*2-sl <= nl
        then
        cpclex_line(tr,l,l*2-sl)
      end
    end
  end
end

renoise.tool():add_keybinding {name = "Pattern Editor:impulseBuddy:Expand Selection", invoke = function() ExpandSelection() end}
--------------------------------------------------------------------------------
--Protman's Shrink Selection
function cpclsh_line(track, from_line, to_line)
  local cur_track = renoise.song():pattern(renoise.song().selected_pattern_index):track(track)
  cur_track:line(to_line):copy_from(cur_track:line(from_line))
  cur_track:line(from_line):clear()
  cur_track:line(from_line+1):clear()
end

function ShrinkSelection()
  local sl = renoise.song().selection_in_pattern.start_line
  local el = renoise.song().selection_in_pattern.end_line
  local st = renoise.song().selection_in_pattern.start_track
  local et = renoise.song().selection_in_pattern.end_track
  local tr
  
  for tr=st,et do
    for l =sl,el,2 do
      if l ~= sl
        then
        cpclsh_line(tr,l,l/2+sl/2)
      end
    end
  end
end

renoise.tool():add_keybinding {name = "Pattern Editor:impulseBuddy:Shrink Selection", invoke = function() ShrinkSelection() end}

----------------------------------------------------------------------------------------------------------------
-- F8, or Impulse Tracker Stop Playback.
-- Switches pattern follow off, pattern looping off, loopblock off and stops playback in the hardest possible
-- way.
function ImpulseTrackerStop()
local t=renoise.song().transport
t.follow_player=false
t:panic()
t.loop_pattern=false
t.loop_block_enabled=false
end


----------------------------------------------------------------------------------------------------------------
--Impulse Tracker "Home Home" behaviour. If you press Home, it takes you to current_track's first line,
--If you press Home again, it takes you to current_song's first_track's first_line.
function homehome()
  local song_pos = renoise.song().transport.edit_pos
-- Go to first line
  if (song_pos.line > 1) then
    renoise.song().transport.follow_player = false
    renoise.song().transport.loop_block_enabled=false
    song_pos.line = 1          
    renoise.song().transport.edit_pos = song_pos   
      if renoise.song().selected_note_column_index==0 then 
      renoise.song().selected_effect_column_index=1 
      else renoise.song().selected_note_column_index=1
      end
    return    
  end  
-- Go to first track
  if (renoise.song().selected_track_index > 1) then
    renoise.song().transport.loop_block_enabled=false
    renoise.song().transport.follow_player = false
    renoise.song().selected_track_index = 1
    renoise.song().selected_note_column_index=1
    return
  end
  renoise.song().selected_note_column_index=1
end


----------------------------------------------------------------------------------------------------------
--Impulse Tracker "End End" behaviour. If you press End, it takes you to current track's last line,
--If you press End again, it takes you to current_song's last_audio_track's last line.
--Now also obeys Home & End  even if in Master Track
function endend()
local song_pos = renoise.song().transport.edit_pos
local last = renoise.song().sequencer_track_count
if (song_pos.line < renoise.song().selected_pattern.number_of_lines) then
 renoise.song().transport.follow_player = false
 renoise.song().transport.loop_block_enabled=false
 song_pos.line = renoise.song().selected_pattern.number_of_lines
 renoise.song().transport.edit_pos = song_pos
 return
 end
if (renoise.song().selected_track_index < renoise.song().sequencer_track_count) then
renoise.song().transport.follow_player = false
renoise.song().selected_track_index= last
return
end
 renoise.song().transport.follow_player = false
 renoise.song().transport.loop_block_enabled=false
end


----------------------------------------------------------------------------------------------------------
--PageUp / PageDown ImpulseTracker behaviour (reads according to LPB, and disables
--Pattern Follow to "eject" you out of playback back to editing step-by-step)
function Jump(Dir)
  local new_pos = 0
  local song = renoise.song()
  local lpb = renoise.song().transport.lpb
  local pat_lines = renoise.song().selected_pattern.number_of_lines
    new_pos = song.transport.edit_pos
    new_pos.line = new_pos.line + lpb * 2 * Dir
    if (new_pos.line < 1) then
    renoise.song().transport.follow_player = false
      new_pos.line = 1
      else if (new_pos.line > pat_lines) then
    renoise.song().transport.follow_player = false
        new_pos.line = pat_lines
      end
    end
    if ((Dir == -1) and (new_pos.line == pat_lines - ((lpb * 2)))) then
      new_pos.line = (pat_lines - (lpb*2) + 1)
    renoise.song().transport.follow_player = false
    end
    song.transport.edit_pos = new_pos
    renoise.song().transport.follow_player = false
end  
----------------------------------------------------------------------------------------------------------------
--8.  "8" in ImpulseTracker "Plays Current Line" and "Advances by EditStep".
function PlayCurrentLine()
local currpos=renoise.song().transport.edit_pos
local sli=renoise.song().selected_line_index
local t=renoise.song().transport
local result=nil
t:start_at(sli)
local start_time = os.clock()
  while (os.clock() - start_time < 0.2) do
        -- Delay the start after panic. Don't go below 0.2 seconds 
        -- or you might tempt some plugins to crash and take Renoise in the fall!!      
  end
  t:stop()
    if renoise.song().selected_line_index == renoise.song().selected_pattern.number_of_lines then
    renoise.song().selected_line_index = 1
    else
    
      if renoise.song().selected_pattern.number_of_lines <  renoise.song().selected_line_index+renoise.song().transport.edit_step
      then renoise.song().selected_line_index=renoise.song().selected_pattern.number_of_lines
      
      else
      renoise.song().selected_line_index=renoise.song().selected_line_index+renoise.song().transport.edit_step
      end
    end
end
----------------------------------------------------------------------------------------------------------------
-- Impulse Tracker "Next Pattern / Prev Pattern"
-- These shortcuts trigger the next sequence. If you're already playing the last sequence and trigger next
-- sequence, it skips to the first sequence. If you're already playing the first sequence, it will trigger
-- the first sequence.
function ImpulseTrackerNextPattern()
if renoise.song().transport.follow_player==false then renoise.song().transport.follow_player=true
end
if renoise.song().transport.playing==false then 
 if renoise.song().selected_sequence_index==(table.count(renoise.song().sequencer.pattern_sequence))
 then return 
 else
renoise.song().selected_sequence_index=renoise.song().selected_sequence_index+1
 end
else
if renoise.song().selected_sequence_index==(table.count(renoise.song().sequencer.pattern_sequence)) then
renoise.song().transport:trigger_sequence(1)
else
renoise.song().transport:trigger_sequence(renoise.song().selected_sequence_index+1)
end
end
end

function ImpulseTrackerPrevPattern()
if renoise.song().transport.follow_player==false then renoise.song().transport.follow_player=true
end
if renoise.song().transport.playing==false then 
 if renoise.song().selected_sequence_index==1 then return
 else
 renoise.song().selected_sequence_index=renoise.song().selected_sequence_index-1
  end
else
if renoise.song().selected_sequence_index==1 then renoise.song().transport:trigger_sequence(renoise.song().selected_sequence_index) else
renoise.song().transport:trigger_sequence(renoise.song().selected_sequence_index-1)
end
end
end
---------------------------------------------------------------------------------------------------------
--Protman's set instrument
function SetInstrument()
local EMPTY_INSTRUMENT = renoise.PatternTrackLine.EMPTY_INSTRUMENT
local pattern_iter = renoise.song().pattern_iterator
local pattern_index = renoise.song().selected_pattern_index
for _,line in pattern_iter:lines_in_pattern(pattern_index) do
  -- will be nil when a send or the master track is iterated
 local first_note_column = line.note_columns[1]
  if (first_note_column and 
      first_note_column.instrument_value ~= EMPTY_INSTRUMENT and 
      first_note_column.is_selected) 
  then
    first_note_column.instrument_value = renoise.song().selected_instrument_index - 1
  end
end
end
renoise.tool():add_keybinding {
  name = "Pattern Editor:impulseBuddy:Set Selection to Current Instrument",
  invoke = function() SetInstrument() end}
----------------------------------------------------------------------------------------------------------
--Protman's set octave
function Octave(new_octave)
  local new_pos = 0
  local song = renoise.song()
  local editstep = renoise.song().transport.edit_step

  new_pos = song.transport.edit_pos
  if ((song.selected_note_column ~= nil) and (song.selected_note_column.note_value < 120)) then
    song.selected_note_column.note_value = song.selected_note_column.note_value  % 12 + (12 * new_octave)
  end
  new_pos.line = new_pos.line + editstep
  if new_pos.line <= song.selected_pattern.number_of_lines then
     song.transport.edit_pos = new_pos
  end
end

for oct=0,9 do
  renoise.tool():add_keybinding {
    name = "Pattern Editor:impulseBuddy:Set Note to Octave " .. oct,
    invoke = function() Octave(oct) end
  }
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Keybinds
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker Home *2 behaviour...", invoke = function() homehome() end }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker End *2 behaviour", invoke = function() endend() end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker Jump Lines Up", invoke = function() Jump(-1) end  }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker Jump Lines Down", invoke = function() Jump(1) end  }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker F8 Stop Playback (Panic)", invoke = function() ImpulseTrackerStop()  end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker F8 Stop Playback (Panic) 2nd", invoke = function() ImpulseTrackerStop()  end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker F8 Stop Playback (Panic) 3rd", invoke = function() 
    if renoise.song().transport.playing then ImpulseTrackerStop() 
       renoise.song().transport.edit_mode=true
    else
       ImpulseTrackerPlaySong()
       renoise.song().transport.edit_mode=false
    end
end}


renoise.tool():add_keybinding {name="Global:impulseBuddy:Play Current Line & Advance by EditStep",  invoke = function() PlayCurrentLine() end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker Next Pattern", invoke = function() ImpulseTrackerNextPattern() end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Impulse Tracker Previous Pattern", invoke = function() ImpulseTrackerPrevPattern() end}
renoise.tool():add_keybinding {name="Global:impulseBuddy:Set LPB -1", invoke = function() adjust_lpb_bpb(-1, 0) end   }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Set LPB +1", invoke = function() adjust_lpb_bpb(1, 0) end   }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Set TPL -1", invoke = function() adjust_lpb_bpb(0, -1) end   }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Set TPL +1", invoke = function() adjust_lpb_bpb(0, 1) end   }
renoise.tool():add_keybinding {name="Global:impulseBuddy:Delete Effectcolumn content from current track", invoke = function() delete_effect_column() end }
----------------------------------------------------------------------------------------------------------
--cortex.scripts.CaptureOctave
--[[
program: CaptureOctave v1.1
author: cortex
]]--
renoise.tool():add_keybinding {name="Pattern Editor:impulseBuddy:Capture Nearest Instrument and Octave",
  invoke = function(repeated) capture_ins_oct() end}
renoise.tool():add_keybinding {name = "Mixer:impulseBuddy:Capture Nearest Instrument and Octave",
  invoke = function(repeated) capture_ins_oct() end}

function capture_ins_oct()
   local closest_note = {}  
   local current_track=renoise.song().selected_track_index
   local current_pattern=renoise.song().selected_pattern_index
   
   for pos,line in renoise.song().pattern_iterator:lines_in_pattern_track(current_pattern,current_track) do
      if (not line.is_empty) then
   local t={}
   if (renoise.song().selected_note_column_index==0) then
      for i=1,renoise.song().tracks[current_track].visible_note_columns do
         table.insert(t,i)
      end
   else
      table.insert(t,renoise.song().selected_note_column_index)  
   end  
   
   for i,v in ipairs(t) do
      local notecol=line.note_columns[v]
      
      if ( (not notecol.is_empty) and (notecol.note_string~="OFF")) then
         if (closest_note.oct==nil) then
      closest_note.oct=math.min(math.floor(notecol.note_value/12),8)
      closest_note.line=pos.line
      closest_note.ins=notecol.instrument_value+1
         elseif ( math.abs(pos.line-renoise.song().transport.edit_pos.line) < math.abs(closest_note.line-renoise.song().transport.edit_pos.line)  ) then
      closest_note.oct=math.min(math.floor(notecol.note_value/12),8)
      closest_note.line=pos.line
      closest_note.ins=notecol.instrument_value+1
         end
         
      end
   end        
   
      end
   end      
   
   if (closest_note.oct~=nil) then 
      renoise.song().selected_instrument_index=closest_note.ins
      renoise.song().transport.octave=closest_note.oct
   end
   
local w = renoise.app().window
   
if renoise.app().window.active_middle_frame == 4 then 
w.active_middle_frame=1
w.active_lower_frame=1
               else
               end
if w.active_lower_frame==1 then w.lower_frame_is_visible=true
   w.active_lower_frame =3
   
 else
   w.active_upper_frame = 1 
   w.upper_frame_is_visible=true
   w.active_middle_frame = 4
   w.lower_frame_is_visible=true
   w.active_lower_frame=3
 end
end
