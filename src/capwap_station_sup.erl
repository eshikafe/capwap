%% Copyright (C) 2013-2017, Travelping GmbH <info@travelping.com>

%% This program is free software: you can redistribute it and/or modify
%% it under the terms of the GNU Affero General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.

%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU Affero General Public License for more details.

%% You should have received a copy of the GNU Affero General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

-module(capwap_station_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, new_station/10]).

%% Supervisor callbstationks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

new_station(AC, DataPath, WTPDataChannelAddress, WtpId, SessionId,
	    RadioMAC, ClientMAC, WLAN, MacMode, TunnelMode) ->
    lager:debug("Starting new station: ~p",
		[{AC, DataPath, WTPDataChannelAddress, WtpId, SessionId,
		  RadioMAC, ClientMAC, WLAN, MacMode, TunnelMode}]),
    R = supervisor:start_child(?SERVER, [AC, DataPath, WTPDataChannelAddress, WtpId, SessionId,
					 RadioMAC, ClientMAC, WLAN, MacMode, TunnelMode]),
    lager:debug("Starting new station result: ~p", [R]),
    R.

%%%===================================================================
%%% Supervisor callbstationks
%%%===================================================================

init([]) ->
    {ok, {{simple_one_for_one, 1000, 1000}, 
          [{ieee80211_station, {ieee80211_station, start_link, []}, 
            temporary, 1000, worker, [ieee80211_station]}]}}.
