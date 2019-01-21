<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xhtml="http://www.w3.org/1999/xhtml">

	<xsl:template match="/data/languages/*">
		<xsl:variable name="lang" select="name()"/>
		<xsl:variable name="path">/<xsl:if test="not(@default)"><xsl:value-of select="nativeName"/></xsl:if></xsl:variable>

		<!-- Accordion -->
		<xsl:result-document href="public{$path}/accordion.html" method="html">
			<html lang="{$lang}">
				<head>
					<meta charset="utf-8"/>
					<title><xsl:value-of select="/data/texts/title/*[name()=$lang]"/></title>
					<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css"/>
					<link rel="stylesheet" href="style.css"/>
					<script
						src="https://code.jquery.com/jquery-3.1.1.min.js"
						integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
						crossorigin="anonymous"></script>
					<script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.js"></script>
				</head>
				<body>
					<h1><xsl:value-of select="/data/texts/title/*[name()=$lang]"/></h1>
					<div class="ui styled accordion">
						<!-- Categories -->
						<xsl:for-each select="/data/categories/*">
							<header>
								<h2><xsl:value-of select="name/*[name()=$lang]"/></h2>
								<span><xsl:value-of select="description/*[name()=$lang]"/></span>
							</header>
							<!-- Types -->
							<xsl:for-each select="types/*">
								<xsl:variable name="typeId" select="name()"/>
								<xsl:for-each select="/data/types/*[name()=$typeId]">
									<xsl:variable name="typeName" select="name/*[name()=$lang]"/>
									<xsl:variable name="escapedTypeName" select="fn:encode-for-uri($typeName)"/>
									<div id="{$escapedTypeName}" class="title">
										<a href="#{$escapedTypeName}">
											<i class="dropdown icon"></i>
											<xsl:value-of select="$typeName"/>
										</a>
									</div>
									<div class="content">
										<div class="styled accordion">
											<xsl:variable name="groupBy" select="groupBy"/>
											<xsl:choose>
												<xsl:when test="$groupBy">
													<!-- Groups -->
													<xsl:for-each select="/data/*[name()=$groupBy]/*">
														<h4><xsl:value-of select="name/*[name()=$lang]"/></h4>
														<!-- Contents -->
														<xsl:for-each select="items/*">
															<xsl:variable name="itemId" select="name()"/>
															<xsl:apply-templates select="/data/*[name()=$typeId]/*[name()=$itemId]">
																<xsl:with-param name="lang" select="$lang"/>
																<xsl:with-param name="escapedTypeName" select="$escapedTypeName"/>
															</xsl:apply-templates>
														</xsl:for-each>
														<div class="ui fitted divider"></div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<!-- Contents -->
													<xsl:for-each select="/data/*[name()=$typeId]">
														<xsl:apply-templates select=".">
															<xsl:with-param name="lang" select="$lang"/>
															<xsl:with-param name="escapedTypeName" select="$escapedTypeName"/>
														</xsl:apply-templates>
													</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</div>
								</xsl:for-each>
							</xsl:for-each>
							<div class="ui fitted divider"></div>
						</xsl:for-each>
					</div>
					<script language="javascript">
						$(document).ready(function() {
							$('.ui.accordion').accordion({ collapsible: false });

							function activateAccordions(hash) {
								if (hash.length) {
									var separator = '/';
									var segments = hash.substring(1).split(separator);
									for (var i = 0; i &lt; segments.length; i++) {
										var path = segments.slice(0, i + 1);
										activateAccordion(path.join(separator));
									}
								}
							}

							function activateAccordion(path) {
								var element = document.getElementById(path);
								var accordion = $(element);
								if (element &amp;&amp; !element.classList.contains("active")) {
									accordion.click();
								}
							}

							activateAccordions(location.hash);

							function locationHashChanged() {
								activateAccordions(location.hash);
							}

							window.onhashchange = locationHashChanged;
						});
				 	</script>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<!-- Compositions -->
	<xsl:template match="/data/compositions/*">
		<xsl:param name="lang"/>
		<xsl:param name="escapedTypeName"/>
		<xsl:variable name="id" select="concat('content-', name())"/>
		<xsl:variable name="name" select="name/*[name()=$lang]"/>
		<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
		<xsl:variable name="qualifiedName" select="concat($escapedTypeName, concat('/', $escapedName))"/>
		<div id="{$qualifiedName}" class="title">
			<xsl:attribute name="onclick">
				$('iframe.<xsl:value-of select="$id"/>').each(function() {
					if (!$(this).attr('src')) {
						$(this).attr('src', $(this).attr('data-src'));
					}
				});
			</xsl:attribute>
			<a href="#{$qualifiedName}">
				<i class="dropdown icon"></i>
				<xsl:value-of select="$name"/>
			</a>
		</div>
		<div class="content">
			<div>
				<a href="https://drive.google.com/uc?export=download&amp;id={drive}"><xsl:value-of select="/data/texts/download/*[name()=$lang]"/></a>
			</div>
			<div>
				<xsl:variable name="width"><xsl:choose><xsl:when test="landscape">59.4</xsl:when><xsl:otherwise>29.7</xsl:otherwise></xsl:choose></xsl:variable>
				<iframe class="{$id}" style="border: 0; width: {$width}em; height: 42em" data-src="https://drive.google.com/file/d/{drive}/preview"></iframe>
			</div>
			<xsl:if test="video-performance">
				<div><iframe class="{$id}" width="560" height="315" data-src="https://www.youtube.com/embed/{video-performance}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"></iframe></div>
			</xsl:if>
			<xsl:if test="audio-performance">
				<div><iframe class="{$id}" style="border: 0; width: 100%; height: 120px;" data-src="{audio-performance}" seamless="seamless"></iframe></div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Poems -->
	<xsl:template match="/data/poems/*">
		<xsl:param name="lang"/>
		<xsl:param name="escapedTypeName"/>
		<xsl:variable name="id" select="concat('content-', name())"/>
		<xsl:variable name="name" select="name/*[name()=$lang]"/>
		<xsl:variable name="escapedName" select="fn:encode-for-uri($name)"/>
		<xsl:variable name="qualifiedName" select="concat($escapedTypeName, concat('/', $escapedName))"/>
		<div id="{$qualifiedName}" class="title">
			<a href="#{$qualifiedName}">
				<i class="dropdown icon"></i>
				<xsl:value-of select="$name"/>
			</a>
		</div>
		<div class="content">
			<div class="poem">
				<xsl:copy-of select="xhtml:text/*[name()=$lang]"/>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
