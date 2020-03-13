<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/item">
	<contentMetadata type="webarchive-seed" >
		<xsl:attribute name="id">  <xsl:value-of select="druid"/>   </xsl:attribute>
		<xsl:for-each select="image">
			<resource type="image" sequence="1">
				<xsl:attribute name="id">  <xsl:value-of select="concat(substring-after(../druid, ':'), '_1')"/>   </xsl:attribute>

				<file preserve="no" publish="yes" shelve="yes"  mimetype="image/jp2"  id="thumbnail.jp2">
					<xsl:attribute name="size">  <xsl:value-of select="size"/>   </xsl:attribute>
					<checksum type="md5"><xsl:value-of select="md5"/></checksum>
      				<checksum type="sha1"><xsl:value-of select="sha1"/></checksum>
			        <imageData>
			        	<xsl:attribute name="width">  <xsl:value-of select="width"/>   </xsl:attribute>
			       		<xsl:attribute name="height">  <xsl:value-of select="height"/>   </xsl:attribute>
			        </imageData>
				</file>
			</resource>
		</xsl:for-each>
	</contentMetadata>
</xsl:template>
</xsl:stylesheet>
