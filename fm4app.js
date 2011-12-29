
/*
    Radio FM4 App for MeeGo Harmattan, Maemo 5 and Symbian
    Copyright (C) 2011  Thomas Perl <thp.io/about>
    http://thp.io/2011/fm4app/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

var appBg = 'black'
var pageBg = 'black'
var yellow = '#e39b00'
var textFg = '#e4e1e1'
var highFg = '#ffdd00'
var lineFg = '#616263'
var streamUrl = 'http://mp3stream1.apasf.apa.at:8000/'
var trackserviceUrl = 'http://fm4.orf.at/trackservicepopup'

function getTrackservice(callback)
{
    var doc = new XMLHttpRequest();
    var regex = /<td width=300 nowrap><font[^>]*>(.*)<\/td>/mg

    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var html = doc.responseText

            html = html.replace(/(\r\n|\n|\r)/gm, '')
            html = regex(html)[1]

            callback(html)
        }
    };
    doc.open("GET", trackserviceUrl);
    doc.send();
}

