#tag WindowBegin Window Window1   BackColor       =   16777215   Backdrop        =   ""   CloseButton     =   False   Composite       =   False   Frame           =   3   FullScreen      =   False   HasBackColor    =   False   Height          =   1.32e+2   ImplicitInstance=   True   LiveResize      =   True   MacProcID       =   0   MaxHeight       =   32000   MaximizeButton  =   True   MaxWidth        =   32000   MenuBar         =   1105278886   MenuBarVisible  =   True   MinHeight       =   64   MinimizeButton  =   True   MinWidth        =   64   Placement       =   0   Resizeable      =   False   Title           =   "MAL Scrobbling"   Visible         =   True   Width           =   1.35e+2   Begin BevelButton Settings      AcceptFocus     =   False      AutoDeactivate  =   True      BackColor       =   0      Bevel           =   0      Bold            =   False      ButtonType      =   0      Caption         =   "Setup Scrobbling"      CaptionAlign    =   3      CaptionDelta    =   0      CaptionPlacement=   1      Enabled         =   True      HasBackColor    =   False      HasMenu         =   0      Height          =   30      HelpTag         =   ""      Icon            =   ""      IconAlign       =   0      IconDX          =   0      IconDY          =   0      Index           =   -2147483648      InitialParent   =   ""      Italic          =   False      Left            =   0      LockBottom      =   ""      LockedInPosition=   False      LockLeft        =   ""      LockRight       =   ""      LockTop         =   ""      MenuValue       =   0      Scope           =   0      TabIndex        =   0      TabPanelIndex   =   0      TabStop         =   True      TextColor       =   0      TextFont        =   "System"      TextSize        =   ""      TextUnit        =   0      Top             =   0      Underline       =   False      Value           =   False      Visible         =   True      Width           =   135   End   Begin BevelButton Scrobble      AcceptFocus     =   False      AutoDeactivate  =   True      BackColor       =   0      Bevel           =   0      Bold            =   False      ButtonType      =   0      Caption         =   "Start Scrobbling"      CaptionAlign    =   3      CaptionDelta    =   0      CaptionPlacement=   1      Enabled         =   True      HasBackColor    =   False      HasMenu         =   0      Height          =   30      HelpTag         =   ""      Icon            =   ""      IconAlign       =   0      IconDX          =   0      IconDY          =   0      Index           =   -2147483648      InitialParent   =   ""      Italic          =   False      Left            =   0      LockBottom      =   ""      LockedInPosition=   False      LockLeft        =   ""      LockRight       =   ""      LockTop         =   ""      MenuValue       =   0      Scope           =   0      TabIndex        =   1      TabPanelIndex   =   0      TabStop         =   True      TextColor       =   0      TextFont        =   "System"      TextSize        =   ""      TextUnit        =   0      Top             =   33      Underline       =   False      Value           =   False      Visible         =   True      Width           =   135   End   Begin Timer Timer1      Height          =   32      Index           =   -2147483648      Left            =   178      LockedInPosition=   False      Mode            =   0      Period          =   600000      Scope           =   0      TabPanelIndex   =   0      Top             =   9      Width           =   32   End   Begin TextArea TextArea1      AcceptTabs      =   ""      Alignment       =   0      AutoDeactivate  =   True      BackColor       =   16777215      Bold            =   ""      Border          =   False      DataField       =   ""      DataSource      =   ""      Enabled         =   True      Format          =   ""      Height          =   68      HelpTag         =   ""      HideSelection   =   True      Index           =   -2147483648      InitialParent   =   ""      Italic          =   ""      Left            =   0      LimitText       =   0      LockBottom      =   ""      LockedInPosition=   False      LockLeft        =   ""      LockRight       =   ""      LockTop         =   ""      Mask            =   ""      Multiline       =   True      ReadOnly        =   True      Scope           =   0      ScrollbarHorizontal=   ""      ScrollbarVertical=   True      Styled          =   True      TabIndex        =   2      TabPanelIndex   =   0      TabStop         =   True      Text            =   ""      TextColor       =   0      TextFont        =   "System"      TextSize        =   0      TextUnit        =   0      Top             =   64      Underline       =   ""      UseFocusRing    =   False      Visible         =   True      Width           =   135   EndEnd#tag EndWindow#tag WindowCode	#tag Event		Sub Open()		  checkcred		End Sub	#tag EndEvent	#tag Method, Flags = &h0		Sub checkcred()		  If Prefs.stringpassword = "" then		    scrobble.enabled = false		  else		    scrobble.enabled = true		  end if		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Sub createscript()		  try		    dim b as textoutputStream		    dim f as FolderItem		    Dim s as string		    f = app.executableFile.parent.parent.child("Resources").child("malupdater").child("MALUpdate-" + stringusername + ".rb")		    b = f.createtextfile		    s = scriptheader + chr(13) + "USERNAME      = '" + stringusername + "'" + chr(13) + "PASSWORD      = '"+ decodebase64(stringpassword) + "'" + chr(13) + chr(13) + scriptfooter		    b.write replacelineendings(s,EndOfLine.Unix)		    b.close		    f.permissions = &o755		    timer1.Mode = Timer.ModeSingle		    Scrobble.caption = "Stop Scrobbling"		    Scrobblingmode = true		    textarea1.text = "Scrobbling have been started" + endofline + textarea1.text		  catch		    app.errboxshow("An error occured when the script is generated.", "MALUpdater folder is missing, please reinstall the program and try again.")		    timer1.mode = timer.modeoff		    scrobble.caption = "Start Scrobbling"		    scrobblingmode = false		    textarea1.text = "Couldn't start scrobbling" + endofline + textarea1.text		  end try		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Sub deletescript()		  try		    dim f as folderitem		    f = app.executableFile.parent.parent.child("Resources").child("malupdater").child("MALUpdate-" + stringusername + ".rb")		    f.Delete		    timer1.Mode = Timer.ModeOff		    scrobble.caption = "Start Scrobbling"		    Scrobblingmode = false		  catch		    timer1.Mode = Timer.ModeOff		    scrobble.caption = "Start Scrobbling"		    Scrobblingmode = false		  end try		  textarea1.text = "Scrobbling have been stopped" + endofline + textarea1.text		End Sub	#tag EndMethod	#tag Property, Flags = &h0		scrobblingmode As boolean = false	#tag EndProperty	#tag Constant, Name = scriptfooter, Type = String, Dynamic = False, Default = \"\rBASE_DIR \x3D File.expand_path(File.dirname(__FILE__)) + \"/\"\rrequire BASE_DIR + \'lib/updater\'\r%w{ open-uri net/http rexml/document }.each do |r|\r  require r\rend\r\rMAL::Updater.new(USERNAME\x2C PASSWORD).update()", Scope = Public	#tag EndConstant	#tag Constant, Name = scriptheader, Type = String, Dynamic = False, Default = \"#!/usr/bin/ruby\r\r# Script generated by MAL Updater OS X GUI\r# Licensed under GPL\r# Frontend by Chikorita157 (2009) and orginally written by TakakoShimizu\r\rLANG \x3D \'en-US\'\rDEBUG_OUTPUT  \x3D true", Scope = Public	#tag EndConstant#tag EndWindowCode#tag Events Settings	#tag Event		Sub Action()		  Window2.show		End Sub	#tag EndEvent#tag EndEvents#tag Events Scrobble	#tag Event		Sub Action()		  If  scrobblingmode = false then		    createscript		  elseif Scrobblingmode = true then		    deletescript		  end if		End Sub	#tag EndEvent#tag EndEvents#tag Events Timer1	#tag Event		Sub Action()		  //Execute Command		  dim sh as shell		  sh = new shell		  Dim f as folderitem		  f = app.executableFile.parent.parent.child("Resources").child("malupdater").child("MALUpdate-" + stringusername + ".rb")		  sh.Execute f.shellpath		  textarea1.text = sh.Result + endofline + "----" + endofline + textarea1.text		End Sub	#tag EndEvent#tag EndEvents