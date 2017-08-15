<?php

$wgShowExceptionDetails = true;

// Short URL
$wgArticlePath     = "/wiki/$1";
$wgUsePathInfo     = true;

// Disable anonymous edit
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['upload_by_url'] = false;
$wgGroupPermissions['*']['upload'] = false;
$wgGroupPermissions['*']['reupload'] = false;

// Upload
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgFileExtensions = array(
    'png', 'gif', 'jpg', 'jpeg', 'bmp',
    'doc', 'docx', 'xls', 'xlsx', 'mpp', 'pdf', 'ppt', 'pptx', 'txt',
    'odt', 'ods', 'odp', 'odg',
    'zip', 'gz', 'tar', '7z'
);


# -- Extensions START ---------------------------------------------------------
wfLoadExtension( "SyntaxHighlight_GeSHi" );
wfLoadExtension( "ParserFunctions" );
wfLoadExtension( "PageImages" );
wfLoadExtension( "Nuke" );
wfLoadExtension( "Cite" );
wfLoadExtension( "CodeEditor" );
# -- Extensions END -----------------------------------------------------------


# -- WikiEditor START ---------------------------------------------------------
wfLoadExtension( "WikiEditor" );
$wgDefaultUserOptions["usebetatoolbar"] = 1;
$wgDefaultUserOptions["usebetatoolbar-cgd"] = 1;
$wgDefaultUserOptions["wikieditor-preview"] = 1;
$wgDefaultUserOptions["wikieditor-publish"] = 1;
# -- WikiEditor END -----------------------------------------------------------


# -- VisualEditor START -------------------------------------------------------
wfLoadExtension( 'VisualEditor' );

// Enable by default for everybody
$wgDefaultUserOptions['visualeditor-enable'] = 1;

// Optional: Set VisualEditor as the default for anonymous users
// otherwise they will have to switch to VE
$wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

// Don't allow users to disable it
$wgHiddenPrefs[] = 'visualeditor-enable';

// OPTIONAL: Enable VisualEditor's experimental code features
#$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

$wgVisualEditorAvailableNamespaces = [
    NS_MAIN => true,
    NS_USER => true,
    102 => true,
    "_merge_strategy" => "array_plus"
];

$wgVirtualRestConfig['modules']['parsoid'] = array(
	// URL to the Parsoid instance
	// Use port 8142 if you use the Debian package
	'url' => 'http://parsoid:8142',
	// Parsoid "domain", see below (optional)
	'domain' => 'localhost',
);
# -- VisualEditor START -------------------------------------------------------


# -- LDAP START ---------------------------------------------------------------
# ...LDAP config...
# -- LDAP END -----------------------------------------------------------------
