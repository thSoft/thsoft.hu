<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xhtml="http://www.w3.org/1999/xhtml">

	<xsl:template match="/data/languages/*">
		<xsl:variable name="lang" select="name()"/>
		<xsl:variable name="path">/<xsl:if test="not(defaultLanguage)"><xsl:value-of select="nativeName"/></xsl:if></xsl:variable>
		<xsl:result-document href="www{$path}/index.html" method="html" indent="no">
			<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
			<html lang="{$lang}">
				<head>
					<meta charset="utf-8"/>
					<meta name="viewport" content="width=device-width, initial-scale=1"/>

					<title><xsl:value-of select="/data/texts/title/*[name()=$lang]"/></title>

					<!-- Google Analytics -->
					<script async="async" src="https://www.googletagmanager.com/gtag/js?id=UA-1188284-1"></script>
					<script>
					  window.dataLayer = window.dataLayer || [];
					  function gtag(){dataLayer.push(arguments);}
					  gtag('js', new Date());

					  gtag('config', 'UA-1188284-1', {
							'page_path': location.pathname + location.hash
						});
					</script>

					<!-- Semantic UI -->
					<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css"/>
					<script
						src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"
						integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
						crossorigin="anonymous"></script>
					<script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.js"></script>

					<!-- Lazy loading -->
					<script src="https://cdn.jsdelivr.net/npm/vanilla-lazyload@8.17.0/dist/lazyload.min.js"></script>

					<!-- Stylesheets -->
					<link rel="stylesheet" href="style.css"/>
					<link rel="stylesheet" href="mediaqueries.css"/>
					<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cinzel"/>
					<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lora"/>
				</head>
				<body>
					<xsl:variable name="homeTabId" select="fn:encode-for-uri(/data/contents/*[home]/name/*[name()=$lang])"/>
					<!-- Desktop navbar -->
					<div class="navigation mobile hidden ui left fixed vertical menu">
						<h1 class="header item">
							<a href="#" data-value="{$homeTabId}"><xsl:value-of select="/data/texts/title/*[name()=$lang]"/></a>
						</h1>
						<xsl:for-each select="/data/contents/*">
							<xsl:call-template name="desktopNavbarItem">
								<xsl:with-param name="lang" select="$lang" tunnel="yes"/>
							</xsl:call-template>
						</xsl:for-each>
					</div>

					<!-- Mobile navbar -->
					<div class="mobile-navigation mobile only ui labeled icon dropdown button">
						<i class="dropdown icon"/>
						<span class="text"/>
						<div class="menu">
							<xsl:for-each select="/data/contents/*">
								<xsl:call-template name="mobileNavbarItem">
									<xsl:with-param name="lang" select="$lang" tunnel="yes"/>
								</xsl:call-template>
							</xsl:for-each>
						</div>
					</div>

					<!-- Contents -->
					<div class="contents">
						<xsl:for-each select="/data/contents/*">
							<xsl:call-template name="content">
								<xsl:with-param name="lang" select="$lang" tunnel="yes"/>
							</xsl:call-template>
						</xsl:for-each>
					</div>

					<!-- Script -->
					<script language="javascript">
						$(document).ready(function() {
							// Lazy loading
							var lazyLoad = new LazyLoad({
								elements_selector: ".lazy",
								load_delay: 300
							});
							// Navigation
							function getFragment(url) {
								return url &amp;&amp; url.includes('#') ? url.split('#')[1] : '';
							}
 							function getMainContentName(fragment) {
								if (fragment) {
									return fragment.includes('/') ? fragment.split('/')[0] : fragment;
								} else {
									return '<xsl:value-of select="$homeTabId"/>';
								}
							}
							function performNavigation(event) {
								// Google Analytics
								gtag('event', 'pageview', {
									'page_path': location.pathname + location.search + location.hash
								});
								$('.menu .item.active').removeClass('active');
								var oldFragment = event ? getFragment(event.oldURL) : undefined;
								var newFragment = getFragment(location.hash);
								if (newFragment != oldFragment) {
									var mainContentName = getMainContentName(newFragment);
									// Main content
									var item = $(document.querySelectorAll('a[data-value="' + mainContentName + '"]'));
									if (item.length > 0) {
										item.addClass('active');
										$.tab('change tab', item.data('value'));
										$('.mobile-navigation').dropdown('set selected', mainContentName);
										lazyLoad.update();
										$('.notfound').addClass('hidden');
										// Subcontent
										if (newFragment.includes('/')) {
											var position = $(document.getElementById(newFragment)).offset().top;
											$('html, body').scrollTop(position);
										}
									} else {
										$.tab('change tab', '<xsl:value-of select="$homeTabId"/>');
										$('.notfound').removeClass('hidden');
									}
								}
							}
							performNavigation();
							window.onhashchange = performNavigation;
							// Popups
							$('.header').popup();
							// Dropdowns
							$('.ui.dropdown').dropdown();
							$('.mobile-toc').dropdown({ action: 'hide' });
							$('.mobile-navigation').dropdown({ direction : 'upward', action: 'hide' });
							// Modals
							$('.ui.modal').modal();
							// Accordions
							$('.ui.accordion').accordion();
							// Messages
							$('.message .close').on('click', function() {
								$(this).closest('.message').transition('zoom');
							});
						});
					</script>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="desktopNavbarItem">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="name()='category'">
				<div class="item">
					<xsl:if test="name">
						<div class="header" data-tooltip="{description/*[name()=$lang]}" data-variation="small very wide" data-position="right center">
							<xsl:value-of select="name/*[name()=$lang]"/>
						</div>
					</xsl:if>
					<div class="menu">
						<xsl:for-each select="items/*">
							<xsl:call-template name="desktopNavbarItem"/>
						</xsl:for-each>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="name()=('page', 'collection', 'groupedCollection', 'cardCollection')">
				<xsl:call-template name="atomicNavbarItem"/>
			</xsl:when>
			<xsl:when test="name()='link'">
				<a href="{url}" target="_blank" class="item">
					<i class="left {icon} icon"/>
					<xsl:value-of select="name/*[name()=$lang]"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="atomicNavbarItem">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:variable name="itemName" select="name/*[name()=$lang]"/>
		<xsl:variable name="escapedItemName" select="fn:encode-for-uri($itemName)"/>
		<xsl:variable name="fragment" select="if (exists(home)) then '' else $escapedItemName"/>
		<a href="#{$fragment}" data-value="{$escapedItemName}" class="item">
			<i class="left {icon} icon"/>
			<xsl:value-of select="$itemName"/>
		</a>
	</xsl:template>

	<xsl:template name="mobileNavbarItem">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="name()='category'">
				<div class="divider"/>
				<div class="header" data-tooltip="{description/*[name()=$lang]}" data-variation="small very wide" data-position="right center">
					<xsl:value-of select="name/*[name()=$lang]"/>
				</div>
				<xsl:for-each select="items/*">
					<xsl:call-template name="mobileNavbarItem"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="name()=('page', 'collection', 'groupedCollection', 'cardCollection')">
				<xsl:call-template name="atomicNavbarItem"/>
			</xsl:when>
			<xsl:when test="name()='link'">
				<a href="{url}" target="_blank" class="item">
					<i class="left {icon} icon"/>
					<xsl:value-of select="name/*[name()=$lang]"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="content">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="name()='category'">
				<xsl:for-each select="items/*">
					<xsl:call-template name="content"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="name()='link'"/>
			<xsl:otherwise>
				<xsl:variable name="mainContentName" select="name/*[name()=$lang]"/>
				<xsl:variable name="escapedMainContentName" select="fn:encode-for-uri($mainContentName)"/>
				<div class="ui tab container {if (home) then 'active' else ''}" data-tab="{$escapedMainContentName}">
					<xsl:if test="not(home)">
						<h2 class="ui center aligned header">
							<xsl:value-of select="$mainContentName"/>
						</h2>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="name()='page'">
							<xsl:apply-templates select="contents/node()"/>
						</xsl:when>
						<xsl:when test="name()='groupedCollection'">
							<xsl:for-each select="groups/*">
								<xsl:variable name="groupName" select="name/*[name()=$lang]"/>
								<xsl:variable name="escapedGroupName" select="fn:encode-for-uri($groupName)"/>
								<xsl:variable name="qualifiedGroupName" select="concat($escapedMainContentName, concat('/', $escapedGroupName))"/>
								<h3 id="{$qualifiedGroupName}" class="ui center aligned header"><xsl:value-of select="name/*[name()=$lang]"/></h3>
								<xsl:call-template name="collection">
									<xsl:with-param name="escapedMainContentName" select="$escapedMainContentName"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="name()='collection'">
							<xsl:call-template name="collection">
								<xsl:with-param name="escapedMainContentName" select="$escapedMainContentName"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="name()='cardCollection'">
							<xsl:call-template name="cardCollection"/>
						</xsl:when>
					</xsl:choose>
					<!-- TOC -->
					<xsl:if test="name()=('groupedCollection', 'collection')">
						<div class="toc mobile hidden ui vertical menu accordion">
							<xsl:choose>
								<xsl:when test="name()='groupedCollection'">
									<xsl:for-each select="groups/*">
										<xsl:variable name="groupName" select="name/*[name()=$lang]"/>
										<xsl:variable name="escapedGroupName" select="fn:encode-for-uri($groupName)"/>
										<xsl:variable name="qualifiedGroupName" select="concat($escapedMainContentName, concat('/', $escapedGroupName))"/>
										<div class="title">
											<i class="dropdown icon"></i>
											<a href="#{$qualifiedGroupName}"><xsl:value-of select="$groupName"/></a>
										</div>
										<div class="content">
											<div class="menu">
												<xsl:call-template name="tocItems">
													<xsl:with-param name="escapedMainContentName" select="$escapedMainContentName"/>
												</xsl:call-template>
											</div>
										</div>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="name()='collection'">
									<xsl:call-template name="tocItems">
										<xsl:with-param name="escapedMainContentName" select="$escapedMainContentName"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</div>
					</xsl:if>
					<!-- Mobile TOC -->
					<xsl:if test="name()='groupedCollection'">
						<div class="mobile-toc mobile only ui tiny labeled icon dropdown button">
							<i class="dropdown icon"/>
							<div class="text"><xsl:value-of select="/data/texts/jump/*[name()=$lang]"/></div>
							<div class="menu">
								<xsl:for-each select="groups/*">
									<xsl:variable name="groupName" select="name/*[name()=$lang]"/>
									<xsl:variable name="escapedGroupName" select="fn:encode-for-uri($groupName)"/>
									<xsl:variable name="qualifiedGroupName" select="concat($escapedMainContentName, concat('/', $escapedGroupName))"/>
									<div class="item">
										<a href="#{$qualifiedGroupName}"><xsl:value-of select="$groupName"/></a>
									</div>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tocItems">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:param name="escapedMainContentName"/>
		<xsl:for-each select="items/*">
			<xsl:variable name="name" select="name/*[name()=$lang]"/>
			<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
			<xsl:variable name="qualifiedName" select="concat($escapedMainContentName, concat('/', $escapedName))"/>
			<a href="#{$qualifiedName}" class="item">
				<xsl:value-of select="$name"/>
			</a>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="cardCollection">
		<xsl:param name="lang" tunnel="yes"/>
		<div class="ui stackable two cards">
			<xsl:for-each select="cards/*">
				<xsl:variable name="name" select="name/*[name()=$lang]"/>
				<div class="ui card">
					<xsl:if test="image">
						<a class="image" href="{url}" target="_blank">
							<img class="lazy" data-src="{image}"/>
						</a>
					</xsl:if>
					<div class="content">
						<div class="header">
							<a href="{url}" target="_blank"><xsl:value-of select="$name"/></a>
						</div>
						<div class="description">
							<xsl:copy-of select="description/*[name()=$lang]/node()"/>
						</div>
					</div>
					<xsl:if test="instructions">
						<div class="ui bottom attached button" onclick="$('#{id}').modal('show')">
							<i class="help icon"></i>
							<xsl:value-of select="/data/texts/instructions/*[name()=$lang]"/>
						</div>
						<div id="{id}" class="ui modal">
							<i class="close icon"></i>
							<xsl:copy-of select="instructions/node()"/>
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template name="collection">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:param name="escapedMainContentName"/>
		<xsl:for-each select="items/*">
			<div class="ui segment">
				<xsl:variable name="name" select="name/*[name()=$lang]"/>
				<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
				<xsl:variable name="qualifiedName" select="concat($escapedMainContentName, concat('/', $escapedName))"/>
				<h4 id="{$qualifiedName}" class="ui center aligned header">
					<a href="#{$qualifiedName}">
						<xsl:value-of select="$name"/>
					</a>
				</h4>
				<xsl:apply-templates select="."/>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="string">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:value-of select="*[name()=$lang]/text()"/>
	</xsl:template>

	<xsl:template match="recording">
		<xsl:param name="lang" tunnel="yes"/>
		<div class="ui centered grid">
			<xsl:for-each select="youtube/playlist">
				<div class="row"><iframe class="lazy video" data-src="https://www.youtube.com/embed/videoseries?list={text()}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
			</xsl:for-each>
			<xsl:for-each select="bandcamp/album">
				<div class="row"><iframe class="lazy" style="border: 0; width: 100%; height: 315px;" data-src="https://bandcamp.com/EmbeddedPlayer/album={text()}/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=true/artwork=small/transparent=true/" seamless="seamless"></iframe></div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="composition">
		<xsl:param name="lang" tunnel="yes"/>
		<div class="ui centered grid">
			<xsl:if test="drive">
				<div class="row">
					<a class="ui button" href="https://drive.google.com/uc?export=download&amp;id={drive}"><xsl:value-of select="/data/texts/download_score/*[name()=$lang]"/></a>
				</div>
				<div class="row">
					<xsl:variable name="width"><xsl:choose><xsl:when test="landscape">59.4</xsl:when><xsl:otherwise>29.7</xsl:otherwise></xsl:choose></xsl:variable>
					<iframe class="lazy" style="border: 0; width: {$width}em; height: 42em" data-src="https://drive.google.com/file/d/{drive}/preview"></iframe>
				</div>
			</xsl:if>
			<xsl:if test="video-performance">
				<div class="row"><iframe class="lazy video" data-src="https://www.youtube.com/embed/{video-performance}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
			</xsl:if>
			<xsl:if test="video-performance-playlist">
				<div class="row"><iframe class="lazy video" data-src="https://www.youtube.com/embed/videoseries?list={video-performance-playlist}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
			</xsl:if>
			<xsl:if test="audio-performance">
				<div class="row"><iframe class="lazy" style="border: 0; width: 100%; height: 120px;" data-src="{audio-performance}" seamless="seamless"></iframe></div>
			</xsl:if>
			<xsl:variable name="lyrics" select="lyrics/*[name()=$lang]"/>
			<xsl:if test="$lyrics">
				<div class="row">
					<div class="ui styled accordion">
						<div class="title">
							<i class="dropdown icon"></i>
							<xsl:value-of select="/data/texts/lyrics/*[name()=$lang]"/>
						</div>
						<div class="content poem"><xsl:value-of select="$lyrics"/></div>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="poem">
		<xsl:param name="lang" tunnel="yes"/>
		<div class="poem">
			<xsl:copy-of select="*[name()='text']/*[name()=$lang]/node()"/>
		</div>
	</xsl:template>

	<xsl:template match="writing">
		<xsl:param name="lang" tunnel="yes"/>
		<div>
			<xsl:copy-of select="*[name()='text']/*[name()=$lang]/node()"/>
		</div>
	</xsl:template>

	<xsl:template match="gallery">
		<iframe class="lazy" data-src="https://drive.google.com/embeddedfolderview?id={drive}#grid" style="width:100%; height:{25 + ceiling(count div 3) * 250}px; border:0;" seamless="seamless"></iframe>
	</xsl:template>

	<xsl:template match="youtube">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy video" data-src="https://www.youtube.com/embed/{id}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="vimeo">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy video" data-src="https://player.vimeo.com/video/{id}" frameborder="0"></iframe>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="scribd">
		<p style="margin: 12px auto 6px auto; font-family: Helvetica,Arial,Sans-serif; font-style: normal; font-variant: normal; font-weight: normal; font-size: 14px; line-height: normal; font-size-adjust: none; font-stretch: normal; -x-system-font: none; display: block;"><iframe class="scribd_iframe_embed lazy" title="Gondolatok zeneművek alkotásáról és befogadásáról" data-src="https://www.scribd.com/embeds/{id}/content?start_page=1&amp;view_mode=scroll&amp;show_recommendations=true&amp;access_key={access}" data-auto-height="true" data-aspect-ratio="null" scrolling="no" width="100%" height="600" frameborder="0"></iframe></p>
	</xsl:template>

	<xsl:template match="slideshare">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy" data-src="http://www.slideshare.net/slideshow/embed_code/key/{id}" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen="allowfullscreen"></iframe>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:param name="lang" tunnel="yes"/>
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
