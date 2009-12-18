	#tag Class	Class CFNumber	Inherits CFType	Implements CFPropertyList		#tag Event			Function ClassID() As CFTypeID			  return me.ClassID			End Function		#tag EndEvent		#tag Method, Flags = &h0			 Shared Function ClassID() As CFTypeID			  #if targetMacOS			    declare function TypeID lib CarbonLib alias "CFNumberGetTypeID" () as UInt32			    static id as CFTypeID = CFTypeID(TypeID)			    return id			  #endif			End Function		#tag EndMethod		#tag Method, Flags = &h0			Sub Constructor(value as Variant)			  #if targetMacOS			    soft declare function CFNumberCreate lib CarbonLib (allocator as Ptr, theType as Integer, valuePtr as Ptr) as Ptr			    			    dim mb as new MemoryBlock(8)			    dim numType as Integer			    select case value.Type			    case value.TypeDouble			      numType = kCFNumberFloat64Type			      mb.DoubleValue(0) = value			    case value.TypeSingle			      numType = kCFNumberFloat32Type			      mb.SingleValue(0) = value			    case value.TypeInteger			      numType = kCFNumberSInt32Type			      mb.Int32Value(0) = value			    case value.TypeLong			      numType = kCFNumberSInt64Type			      mb.Int64Value(0) = value			    else			      raise new TypeMismatchException			    end select			    			    super.Constructor CFNumberCreate(nil, numType, mb), true			  #endif			End Sub		#tag EndMethod		#tag Method, Flags = &h0			 Shared Function NaN() As CFNumber			  const kCFNumberNaN = "kCFNumberNaN"			  static v as CFNumber = SpecialValue(kCFNumberNaN)			  return v			End Function		#tag EndMethod		#tag Method, Flags = &h0			 Shared Function NegativeInfinity() As CFNumber			  const kCFNumberNegativeInfinity = "kCFNumberNegativeInfinity"			  static v as CFNumber = SpecialValue(kCFNumberNegativeInfinity)			  return v			End Function		#tag EndMethod		#tag Method, Flags = &h0			 Shared Function PositiveInfinity() As CFNumber			  const kCFNumberPositiveInfinity = "kCFNumberPositiveInfinity"			  static v as CFNumber = SpecialValue(kCFNumberPositiveInfinity)			  return v			End Function		#tag EndMethod		#tag Method, Flags = &h21			Private Shared Function SpecialValue(symbolName as String) As CFNumber			  // Note: I (TT) have changed the behavior in case the symbolName can't be found:			  // Instead of returning a number (0), it returns nil so that the failure can be detected.			  			  dim p as Ptr = CFBundle.CarbonFramework.DataPointerNotRetained(symbolName)			  if p = nil then			    return nil			  end if			  			  dim value as new CFNumber(p.Ptr(0), false)			  return value			End Function		#tag EndMethod		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  #if TargetMacOS				    soft declare function CFNumberGetValue lib CarbonLib (number as Ptr, theType as Integer, ByRef valuePtr as Double) as Boolean				    				    if not me.IsNULL then				      dim theValue as Double				      if CFNumberGetValue(me.Reference, kCFNumberDoubleType, theValue) then				        return theValue				      else				        return theValue //but it's an approximate value				      end if				    end if				  #endif				End Get			#tag EndGetter			DoubleValue As Double		#tag EndComputedProperty		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  #if TargetMacOS				    soft declare function CFNumberGetValue lib CarbonLib (number as Ptr, theType as Integer, ByRef valuePtr as Int64) as Boolean				    				    if not me.IsNULL then				      dim theValue as Int64				      if CFNumberGetValue(me.Reference, kCFNumberSInt64Type, theValue) then				        return theValue				      else				        return theValue //but it's an approximate value				      end if				    end if				  #endif				End Get			#tag EndGetter			Int64Value As Int64		#tag EndComputedProperty		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  #if TargetMacOS				    soft declare function CFNumberGetValue lib CarbonLib (number as Ptr, theType as Integer, ByRef valuePtr as Integer) as Boolean				    				    if not me.IsNULL then				      dim theValue as Integer				      if CFNumberGetValue(me.Reference, kCFNumberSInt32Type, theValue) then				        return theValue				      else				        return theValue //but it's an approximate value				      end if				    end if				  #endif				End Get			#tag EndGetter			IntegerValue As Integer		#tag EndComputedProperty		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  #if TargetMacOS				    soft declare function CFNumberIsFloatType lib CarbonLib (number as Ptr) as Boolean				    				    if not me.IsNULL then				      return CFNumberIsFloatType(me.Reference)				    end if				  #endif				End Get			#tag EndGetter			IsFloat As Boolean		#tag EndComputedProperty		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  #if TargetMacOS				    soft declare function CFNumberGetType lib CarbonLib (number as Ptr) as Integer				    				    if not me.IsNULL then				      return CFNumberGetType(me.Reference)				    end if				  #endif				End Get			#tag EndGetter			Type As Integer		#tag EndComputedProperty		#tag ComputedProperty, Flags = &h0			#tag Getter				Get				  // returns a Variant containing either of these types: Single, Double, Integer, Int64				  				  #if targetMacOS				    soft declare function CFNumberGetValue lib CarbonLib (number as Ptr, theType as Integer, valuePtr as Ptr) as Boolean				    soft declare function CFNumberGetType lib CarbonLib (number as Ptr) as Integer				    				    if not me.IsNULL then				      dim numType as Integer = CFNumberGetType(me.Reference)				      				      // adjust the type we want				      select case numType				      case 6, 13, 16				        numType = kCFNumberFloat64Type				      case 5, 12				        numType = kCFNumberFloat32Type				      case 1, 2, 3, 7, 8, 9, 10, 14, 15				        numType = kCFNumberSInt32Type				      case 4, 11				        numType = kCFNumberSInt64Type				      else				        numType = kCFNumberFloat64Type				      end select				      				      dim mb as new MemoryBlock(8)				      if CFNumberGetValue(me.Reference, numType, mb) then				        select case numType				        case kCFNumberFloat64Type				          return mb.DoubleValue(0)				        case kCFNumberFloat32Type				          return mb.SingleValue(0)				        case kCFNumberSInt32Type				          return mb.Int32Value(0)				        case kCFNumberSInt64Type				          return mb.Int64Value(0)				        end select				      end if				      				    end if				  #endif				End Get			#tag EndGetter			Value As Variant		#tag EndComputedProperty		#tag Constant, Name = kCFNumberDoubleType, Type = Double, Dynamic = False, Default = \"13", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberFloat32Type, Type = Double, Dynamic = False, Default = \"5", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberFloat64Type, Type = Double, Dynamic = False, Default = \"6", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberFloatType, Type = Double, Dynamic = False, Default = \"12", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberSInt16Type, Type = Double, Dynamic = False, Default = \"2", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberSInt32Type, Type = Double, Dynamic = False, Default = \"3", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberSInt64Type, Type = Double, Dynamic = False, Default = \"4", Scope = Public		#tag EndConstant		#tag Constant, Name = kCFNumberSInt8Type, Type = Double, Dynamic = False, Default = \"1", Scope = Public		#tag EndConstant		#tag ViewBehavior			#tag ViewProperty				Name="Description"				Group="Behavior"				Type="String"				EditorType="MultiLineEditor"				InheritedFrom="CFType"			#tag EndViewProperty			#tag ViewProperty				Name="DoubleValue"				Group="Behavior"				InitialValue="0"				Type="Double"			#tag EndViewProperty			#tag ViewProperty				Name="Index"				Visible=true				Group="ID"				InitialValue="-2147483648"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="IntegerValue"				Group="Behavior"				InitialValue="0"				Type="Integer"			#tag EndViewProperty			#tag ViewProperty				Name="IsFloat"				Group="Behavior"				InitialValue="0"				Type="Boolean"			#tag EndViewProperty			#tag ViewProperty				Name="Left"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Name"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Super"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Top"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Type"				Group="Behavior"				InitialValue="0"				Type="Integer"			#tag EndViewProperty		#tag EndViewBehavior	End Class	#tag EndClass