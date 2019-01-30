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
					<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css"/>
					<link rel="stylesheet" href="style.css"/>
					<link rel="stylesheet" href="mediaqueries.css"/>
					<script
						src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"
						integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
						crossorigin="anonymous"></script>
					<script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.js"></script>
					<script src="https://cdn.jsdelivr.net/npm/vanilla-lazyload@8.17.0/dist/lazyload.min.js"></script>
					<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cinzel"/>
					<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lora"/>
				</head>
				<body>
					<!-- Navbar -->
					<div class="navigation mobile hidden ui left fixed vertical menu">
						<h1 class="header item">
							<a href="#"><xsl:value-of select="/data/texts/title/*[name()=$lang]"/></a>
						</h1>
						<div class="menu">
							<a href="#" class="item">
								<i class="left home icon"/>
								<xsl:value-of select="/data/texts/home/*[name()=$lang]"/>
							</a>
						</div>
						<!-- Categories -->
						<xsl:for-each select="/data/categories/*">
							<div class="item">
								<div class="header" data-tooltip="{description/*[name()=$lang]}" data-variation="small very wide" data-position="right center">
									<xsl:value-of select="name/*[name()=$lang]"/>
								</div>
								<div class="menu">
									<!-- Activities -->
									<xsl:for-each select="activities/*">
										<xsl:variable name="activityId" select="name()"/>
										<xsl:for-each select="/data/activities/*[name()=$activityId]">
											<xsl:variable name="activityName" select="name/*[name()=$lang]"/>
											<xsl:variable name="escapedActivityName" select="fn:encode-for-uri($activityName)"/>
											<a href="#{$escapedActivityName}" class="item" data-tab="{$escapedActivityName}">
												<i class="left {icon} icon"/>
												<xsl:value-of select="$activityName"/>
											</a>
										</xsl:for-each>
									</xsl:for-each>
								</div>
							</div>
						</xsl:for-each>
					</div>
					<!-- Mobile navbar -->
					<div class="mobile-navigation mobile only ui labeled icon upward dropdown button">
						<i class="dropdown icon"/>
						<span class="text"/>
						<div class="menu">
							<a href="#" data-value="#" class="selected item">
								<i class="left home icon"/>
								<xsl:value-of select="/data/texts/home/*[name()=$lang]"/>
							</a>
							<!-- Categories -->
							<xsl:for-each select="/data/categories/*">
								<div class="divider"/>
								<div class="header" data-tooltip="{description/*[name()=$lang]}" data-variation="small very wide" data-position="right center">
									<xsl:value-of select="name/*[name()=$lang]"/>
								</div>
								<!-- Activities -->
								<xsl:for-each select="activities/*">
									<xsl:variable name="activityId" select="name()"/>
									<xsl:for-each select="/data/activities/*[name()=$activityId]">
										<xsl:variable name="activityName" select="name/*[name()=$lang]"/>
										<xsl:variable name="escapedActivityName" select="fn:encode-for-uri($activityName)"/>
										<a href="#{$escapedActivityName}" data-value="#{$escapedActivityName}" class="item">
											<i class="left {icon} icon"/>
											<xsl:value-of select="$activityName"/>
										</a>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:for-each>
						</div>
					</div>
					<!-- Contents -->
					<div class="contents">
						<!-- Home -->
						<div class="ui active tab" data-tab="#">
							<div class="ui centered grid">
								<div class="row">
									<img class="lazy" data-src="portrait.png" style="width: 250px; height: 250px;"/>
								</div>
								<div class="intro row">
									<xsl:value-of select="/data/texts/intro/*[name()=$lang]"/>
								</div>
								<div class="row">
									<h2 class="ui header"><xsl:value-of select="/data/texts/news/*[name()=$lang]"/></h2>
								</div>
								<div class="row">
									<a class="twitter-timeline" data-lang="hu" data-width="92%" href="https://twitter.com/ThsoftHu?ref_src=twsrc%5Etfw" data-chrome="noheader nofooter noborders">Betöltés...</a>
								</div>
							</div>
						</div>
						<!-- Activities -->
						<xsl:for-each select="/data/categories/*/activities/*">
							<xsl:variable name="activityId" select="name()"/>
							<xsl:for-each select="/data/activities/*[name()=$activityId]">
								<xsl:variable name="activityName" select="name/*[name()=$lang]"/>
								<xsl:variable name="escapedActivityName" select="fn:encode-for-uri($activityName)"/>
								<div class="ui tab container" data-tab="{$escapedActivityName}">
									<h2 class="ui center aligned header">
										<xsl:value-of select="$activityName"/>
									</h2>
									<xsl:variable name="groupBy" select="groupBy"/>
									<xsl:choose>
										<xsl:when test="$groupBy"> <!-- Grouped -->
											<!-- Groups -->
											<xsl:for-each select="/data/*[name()=$groupBy]/*">
												<xsl:variable name="groupName" select="name/*[name()=$lang]"/>
												<xsl:variable name="escapedGroupName" select="fn:encode-for-uri($groupName)"/>
												<xsl:variable name="qualifiedGroupName" select="concat($escapedActivityName, concat('/', $escapedGroupName))"/>
												<h3 id="{$qualifiedGroupName}" class="ui center aligned header"><xsl:value-of select="name/*[name()=$lang]"/></h3>
												<!-- Contents -->
												<xsl:for-each select="items/*">
													<xsl:variable name="itemId" select="name()"/>
													<xsl:call-template name="contents">
														<xsl:with-param name="lang" select="$lang"/>
														<xsl:with-param name="escapedActivityName" select="$escapedActivityName"/>
														<xsl:with-param name="contents" select="/data/*[name()=$activityId]/*[name()=$itemId]"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise> <!-- Ungrouped -->
											<xsl:choose>
												<xsl:when test="links"> <!-- Links -->
													<xsl:call-template name="links">
														<xsl:with-param name="lang" select="$lang"/>
														<xsl:with-param name="links" select="/data/*[name()=$activityId]/*"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="content"> <!-- Content -->
													<xsl:copy-of select="/data/*[name()=$activityId]/node()"/>
												</xsl:when>
												<xsl:otherwise> <!-- Contents -->
													<xsl:call-template name="contents">
														<xsl:with-param name="lang" select="$lang"/>
														<xsl:with-param name="escapedActivityName" select="$escapedActivityName"/>
														<xsl:with-param name="contents" select="/data/*[name()=$activityId]/*"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
									<!-- TOC -->
									<xsl:if test="not(links) and not(content)">
										<div class="toc mobile hidden ui vertical menu accordion">
											<xsl:variable name="groupBy" select="groupBy"/>
											<xsl:choose>
												<xsl:when test="$groupBy"> <!-- Grouped -->
													<xsl:for-each select="/data/*[name()=$groupBy]/*">
														<xsl:variable name="groupName" select="name/*[name()=$lang]"/>
														<xsl:variable name="escapedGroupName" select="fn:encode-for-uri($groupName)"/>
														<xsl:variable name="qualifiedGroupName" select="concat($escapedActivityName, concat('/', $escapedGroupName))"/>
														<div class="title">
															<i class="dropdown icon"></i>
															<a href="#{$qualifiedGroupName}"><xsl:value-of select="$groupName"/></a>
														</div>
														<div class="content">
															<div class="menu">
																<xsl:for-each select="items/*">
																	<xsl:variable name="itemId" select="name()"/>
																	<xsl:for-each select="/data/*[name()=$activityId]/*[name()=$itemId]">
																		<xsl:variable name="name" select="name/*[name()=$lang]"/>
																		<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
																		<xsl:variable name="qualifiedName" select="concat($escapedActivityName, concat('/', $escapedName))"/>
																		<a href="#{$qualifiedName}" class="item">
																			<xsl:value-of select="$name"/>
																		</a>
																	</xsl:for-each>
																</xsl:for-each>
															</div>
														</div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise> <!-- Ungrouped -->
													<xsl:for-each select="/data/*[name()=$activityId]/*">
														<xsl:variable name="name" select="name/*[name()=$lang]"/>
														<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
														<xsl:variable name="qualifiedName" select="concat($escapedActivityName, concat('/', $escapedName))"/>
														<a href="#{$qualifiedName}" class="item">
															<xsl:value-of select="$name"/>
														</a>
													</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</xsl:if>
								</div>
							</xsl:for-each>
						</xsl:for-each>
					</div>
					<!-- Script -->
					<script language="javascript">
						$(document).ready(function() {
							// Popups
							$('.header').popup();
							// Lazy loading
							var lazyLoad = new LazyLoad({
								elements_selector: ".lazy",
								load_delay: 300
							});
							// Navigation
							function getActivityName(path) {
								return path.includes('/') ? path.substring(0, path.indexOf('/')) : path;
							}
							function performNavigation(event) {
								$('.menu .item.active').removeClass('active');
								if (!location.hash) {
									// Home
									$.tab('change tab', "#");
									$('a[href="#"]').addClass('active');
									$('.mobile-navigation').dropdown('set selected', "#");
								} else {
									// Activity
									var activityName = getActivityName(location.hash);
									var oldActivityName = event &amp;&amp; event.oldURL &amp;&amp; event.oldURL.includes('#') ? getActivityName(event.oldURL.split('#')[1]) : "";
									if (activityName != oldActivityName) {
										var item = $(document.querySelectorAll('a[href="' + activityName + '"]'));
										item.addClass('active');
										$.tab('change tab', item.data('tab'));
										$('.mobile-navigation').dropdown('set selected', activityName);
										lazyLoad.update();
									}
									// Content
									var position = location.hash.includes('/') ? $(document.getElementById(location.hash.substring(1))).offset().top : 0;
									$('html, body').animate({ scrollTop: position }, 250);
								}
							}
							performNavigation();
							window.onhashchange = performNavigation;
							// Dropdown
							$('.ui.dropdown').dropdown();
							// Modals
							$('.ui.modal').modal();
							// Accordions
							$('.ui.accordion').accordion();
						});
					</script>
					<script async="async" src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<!-- Links -->
	<xsl:template name="links">
		<xsl:param name="lang"/>
		<xsl:param name="links"/>
		<div class="ui stackable two cards">
			<xsl:for-each select="$links">
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
						<div class="ui bottom attached button" onclick="$('#{name()}').modal('show')">
							<i class="help icon"></i>
							<xsl:value-of select="/data/texts/instructions/*[name()=$lang]"/>
						</div>
						<div id="{name()}" class="ui modal">
							<i class="close icon"></i>
							<xsl:copy-of select="instructions/node()"/>
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Contents -->
	<xsl:template name="contents">
		<xsl:param name="lang"/>
		<xsl:param name="escapedActivityName"/>
		<xsl:param name="contents"/>
		<xsl:for-each select="$contents">
			<div class="ui segment">
				<xsl:variable name="name" select="name/*[name()=$lang]"/>
				<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
				<xsl:variable name="qualifiedName" select="concat($escapedActivityName, concat('/', $escapedName))"/>
				<h4 id="{$qualifiedName}" class="ui center aligned header">
					<a href="#{$qualifiedName}">
						<xsl:value-of select="$name"/>
					</a>
				</h4>
				<xsl:apply-templates select=".">
					<xsl:with-param name="lang" select="$lang"/>
				</xsl:apply-templates>
			</div>
		</xsl:for-each>
	</xsl:template>

	<!-- Recordings -->
	<xsl:template match="/data/recordings/*">
		<xsl:param name="lang"/>
		<div class="ui centered grid">
			<xsl:for-each select="youtube/playlist">
				<div class="row"><iframe class="lazy video" data-src="https://www.youtube.com/embed/videoseries?list={text()}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
			</xsl:for-each>
			<xsl:for-each select="bandcamp/album">
				<div class="row"><iframe class="lazy" style="border: 0; width: 100%; height: 315px;" data-src="https://bandcamp.com/EmbeddedPlayer/album={text()}/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=true/artwork=small/transparent=true/" seamless="seamless"></iframe></div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Compositions -->
	<xsl:template match="/data/compositions/*">
		<xsl:param name="lang"/>
		<div class="ui centered grid">
			<div class="row">
				<a class="ui button" href="https://drive.google.com/uc?export=download&amp;id={drive}"><xsl:value-of select="/data/texts/download_score/*[name()=$lang]"/></a>
			</div>
			<div class="row">
				<xsl:variable name="width"><xsl:choose><xsl:when test="landscape">59.4</xsl:when><xsl:otherwise>29.7</xsl:otherwise></xsl:choose></xsl:variable>
				<iframe class="lazy" style="border: 0; width: {$width}em; height: 42em" data-src="https://drive.google.com/file/d/{drive}/preview"></iframe>
			</div>
			<xsl:if test="video-performance">
				<div class="row"><iframe class="lazy video" data-src="https://www.youtube.com/embed/{video-performance}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
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

	<!-- Poems -->
	<xsl:template match="*[@type='poem']">
		<xsl:param name="lang"/>
		<div class="poem">
			<xsl:copy-of select="*[name()='text']/*[name()=$lang]/node()"/>
		</div>
	</xsl:template>

	<!-- Writings -->
	<xsl:template match="*[@type='writing']">
		<xsl:param name="lang"/>
		<div>
			<xsl:copy-of select="*[name()='text']/*[name()=$lang]/node()"/>
		</div>
	</xsl:template>

	<!-- Galleries -->
	<xsl:template match="*[@type='gallery']">
		<iframe class="lazy" data-src="https://drive.google.com/embeddedfolderview?id={drive}#grid" style="width:100%; height:{25 + ceiling(count div 3) * 250}px; border:0;" seamless="seamless"></iframe>
	</xsl:template>

	<!-- YouTube Videos -->
	<xsl:template match="*[@type='youtube']">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy video" data-src="https://www.youtube.com/embed/{id}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe>
			</div>
		</div>
	</xsl:template>

	<!-- Vimeo Videos -->
	<xsl:template match="*[@type='vimeo']">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy video" data-src="https://player.vimeo.com/video/{id}" frameborder="0"></iframe>
			</div>
		</div>
	</xsl:template>

	<!-- Scribd -->
	<xsl:template match="*[@type='scribd']">
		<p style="   margin: 12px auto 6px auto;   font-family: Helvetica,Arial,Sans-serif;   font-style: normal;   font-variant: normal;   font-weight: normal;   font-size: 14px;   line-height: normal;   font-size-adjust: none;   font-stretch: normal;   -x-system-font: none;   display: block;"   ><iframe class="scribd_iframe_embed lazy" title="Gondolatok zeneművek alkotásáról és befogadásáról" data-src="https://www.scribd.com/embeds/{id}/content?start_page=1&amp;view_mode=scroll&amp;show_recommendations=true&amp;access_key={access}" data-auto-height="true" data-aspect-ratio="null" scrolling="no" width="100%" height="600" frameborder="0"></iframe></p>
	</xsl:template>

	<!-- Slideshare -->
	<xsl:template match="*[@type='slideshare']">
		<div class="ui centered grid">
			<div class="row">
				<iframe class="lazy" data-src="http://www.slideshare.net/slideshow/embed_code/key/{id}" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen="allowfullscreen"></iframe>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
