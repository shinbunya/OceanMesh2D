function obj = Calc_f13_Const(obj,attrname,unit,valpernode,value) 
% obj = Calc_f13_Const(obj,attribute,varargin)
% Input a msh class object and get back the specified
% attribute in a f13 structure of the obj
%
%  Inputs:   1) A msh class obj with bathy on it
%            2) The attribute indicator
%               Attributes currently supported:
%              'Cf' ('quadratic_friction_coefficient_at_sea_floor')
%              'Ev' ('average_horizontal_eddy_viscosity_in_sea_water_wrt_depth')
%              'Mn' ('mannings_n_at_sea_floor')
%              'Ss' ('surface_submergence_state')
%              'Re' ('initial_river_elevation')
%              'Ad' ('advection_state')
%              'Sb' ('subgrid_barrier')
%              'Es' ('elemental_slope_limiter')
%
%            3) then either: 
%              'inpoly' followed by...
%            - A cell-arry of polygons in which you would like to alter 
%               the attribute.
%            - A set of attribute values that correspond 1-to-1 with the
%               cell of polygons.
%            - (optional) A set of 0 or 1's that correspond 1-to-1 with the
%               cell of polygons as to whether the in or out polygon is
%               selected
%
%            or 'assign' followed by...
%            - an array of values to assign with length the same as the 
%              number of vertices in the msh obj 
%
%  Outputs: 1) msh class obj with attribute values populating the f13 struct
%
%  Author:      Keith Roberts, WP to make it for general attribute
%  Created:     April 5 2018, July 5 2018, June 6 2019 (cleaning up)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Make into f13 struct
if isempty(obj.f13)
    % Add this as first entry in f13 struct
    obj.f13.AGRID = obj.title;
    obj.f13.NumOfNodes = length(obj.p);
    obj.f13.nAttr = 1;
    NA = 1;
else
    broken = 0;
    for NA = 1:obj.f13.nAttr
        if strcmp(attrname,obj.f13.defval.Atr(NA).AttrName)
            broken = 1;
            % overwrite existing f13
            break
        end
    end
    if ~broken
        % add new attr to list
        obj.f13.nAttr = obj.f13.nAttr + 1;
        NA = obj.f13.nAttr;
    end
end



% Default Values
obj.f13.defval.Atr(NA).AttrName = attrname;
obj.f13.defval.Atr(NA).Unit = unit;
obj.f13.defval.Atr(NA).ValuesPerNode = valpernode ;
obj.f13.defval.Atr(NA).Val = value;

% User Values
obj.f13.userval.Atr(NA).AttrName = attrname ;
obj.f13.userval.Atr(NA).usernumnodes = 0;
obj.f13.userval.Atr(NA).Val = [];

if ~isempty(obj.f15)
    % Change attribute in obj.f15
    found = false;
    for f15attrstruct = obj.f15.AttrName
        f15attrname = f15attrstruct.name;
        disp([f15attrname ',' attrname])
        if(strcmpi(f15attrname,attrname))
            disp([attrname ' already exists in fort.15 struct'])
            found = true;
            break;
        end
    end
    if ~found
        disp(['Adding on ' attrname ' into fort.15 struct'])
        obj.f15.nwp = obj.f15.nwp + 1;
        obj.f15.AttrName(obj.f15.nwp).name = attrname;
    end
end

%EOF
end
