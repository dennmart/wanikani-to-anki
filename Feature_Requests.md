Features
========
(Complete as of https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/6#post164115)

Include WaniKani audio sample links
-----------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125587

(DONE) Include level number for each item
----------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126087
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/3#post126343

(DONE) Export burned items only
-----------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126192
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126235
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/3#post126684
"Caveat: Please know that this might not work reliably, especially to those higher level folk who have been here since the beginning and have thousands of burned items. Since there's no API call to fetch items of a certain SRS level (burned, guru, etc. - I really hope this is added to v1.3...), I had to get a little hacky with this. I basically have to fetch all radicals, kanji and vocabulary for the user up to their current level, and then iterate through each item to discard those not matching the specified SRS level. So this most likely has to iterate through thousands of items, and will probably time out if there's too much for my tiny VPS server to handle. I currently don't have support for getting burned items by level so no one will be able to make smaller requests. I'll be working on adding support for that when I get some spare time."
Note: https://www.wanikani.com/api has srs-distribution so you can see totals for each SRS step, but not which levels contain those items.

(DONE) Download recent unlocks
-----------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126235
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post126819

Documentation: How to create reverse decks (i.e. English -> Japanese)
---------------------------------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125587
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125617
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/3#post126685
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post127239
"end up with a few duplicate English readings." (which is ok this is always going to happen)

Choose fields to export
-----------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post127284
"I've been thinking about ways to let people define what fields they want, so when I get some spare time I'll probably start incorporating some changes to let people choose what they want."
(Releated to Documentation: How to create reverse decks (i.e. English -> Japanese))

(DONE) Documentation: How to import the deck into Anki
-----------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126000
"When I import these into anki, they all end up in the same deck. And that causes the some things to get replaced by one another"

Documentation: How to upload to ankiweb.net
-------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post127833

Documentation: Export On and Kun readings for Kanjis?
-----------------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post129432
"I would like to export in Anki both On and Kun readings for the kanjis. Is there a way to do it in this exporter?"
-> The API has onyomi and kunyomi in the json so this is possible


Just use hiragana and english in generated cards?
-------------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125600
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125617
" I'm not sure if I'll do that for the site. The focus of WaniKani is learning kanji, so I don't feel like having options to remove kanji parts is useful to most people. The downloaded files are plain text, however. You can open them in any text editor you have on your computer and edit them, so that's an option for you there."
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/3#post126686
"Anyway to make it so the English meaning can be separated from the hiragana reading, like in it's own field?"
Separating the output into multiple fields may help with his request.

Responses:
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/4#post126687
"currently no way to separate hiragana from the english meaning at the moment. I'll add it to my list of things to do at a later point in time. In the meantime you can probably open the file in a text editor and find and replace / remove all hiragana from the generated deck, but it might be a little tedious to do manually."

Bugs
====

Selecting Text Box doesnt leave cursor in text box
----------------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125597
Steps to reproduce (Firefox):
1. Click Additional Options
2. Click in the text box for "Specific Levels"
3. Note that the text box does not have the editable cursor
4. Attempting to type does nothing to text box
5. If you click and hold the mouse buttons down in the text box you can edit the text box.
6. If you tab/shift+tab cursor focus can be placed on the text box allowing you to type
Reason:
Clicking in the text box enables the radio button "Specific Levels"
https://bugzilla.mozilla.org/show_bug.cgi?id=213519 "Bug 213519 - Unable to focus INPUT element inside a LABEL element" says that its against the W3C spec to have multiple elements in a label element. However other browsers support this fine, its just Firefox with issues.
http://stackoverflow.com/questions/15253646/text-input-inside-radio-button-group-loses-focus-in-firefox-when-clicked says to pull out the input text from the label and then use javascript to select the radio button.
e.g.
$('#behalfid').click(function(){
    $('#optionsRadios2').trigger('click');
});

Download all my vocab it gives me a timeout error (503 service unavailable)
---------------------------------------------------------------------------
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125597
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/1#post125617
* https://www.wanikani.com/chat/api-and-third-party-apps/5154/page/2#post126158
"The issue is not because the WaniKani API is timing out - It's timing out on my end when generating the data for the download, since it's a sizeable amount of data. I checked just now and there are 4541 vocabulary items from level 1 to 45, so it takes a long time to process all that data. I'm sure I can optimize this process since I wasn't thinking about that use case."


