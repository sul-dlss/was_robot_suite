<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/crawlObject">

<contentMetadata type="file" >
     <xsl:attribute name="stacks">
        <xsl:value-of select="concat('/web-archiving-stack/','collectionId')"/>
     </xsl:attribute>
     
    <xsl:for-each select="files/file[type='WARC']">
		<resource type="file" >
			<file dataType="WARC" publish="no" shelve="yes" preserve="yes" >
			     <xsl:attribute name="id">  <xsl:value-of select="name"/>   </xsl:attribute>
			     <xsl:attribute name="size">  <xsl:value-of select="size"/>   </xsl:attribute>
			     <xsl:attribute name="mimetype">  <xsl:value-of select="mimeType"/>   </xsl:attribute>
				 <checksum type="MD5"> <xsl:value-of select="checksumMD5"/> </checksum>
				 <checksum type="SHA1"> <xsl:value-of select="checksumSHA1"/> </checksum>
			</file>
		</resource>
    </xsl:for-each>

    <xsl:for-each select="files/file[type='ARC']">
		<resource type="file" >
			<file dataType="ARC" publish="no" shelve="yes" preserve="yes" >
			     <xsl:attribute name="id">  <xsl:value-of select="name"/>   </xsl:attribute>
			     <xsl:attribute name="size">  <xsl:value-of select="size"/>   </xsl:attribute>
			     <xsl:attribute name="mimetype">  <xsl:value-of select="mimeType"/>   </xsl:attribute>
				 <checksum type="MD5"> <xsl:value-of select="checksumMD5"/> </checksum>
				 <checksum type="SHA1"> <xsl:value-of select="checksumSHA1"/> </checksum>
			</file>
		</resource>
    </xsl:for-each>

	<xsl:for-each select="files/file[type='GENERAL']">
		<resource type="file" >
			<file dataType="general" publish="no" shelve="no" preserve="yes" >
			     <xsl:attribute name="id">  <xsl:value-of select="name"/>   </xsl:attribute>
			     <xsl:attribute name="size">  <xsl:value-of select="size"/>   </xsl:attribute>
			     <xsl:attribute name="mimetype">  <xsl:value-of select="mimeType"/>   </xsl:attribute>
				 <checksum type="MD5"> <xsl:value-of select="checksumMD5"/> </checksum>
				 <checksum type="SHA1"> <xsl:value-of select="checksumSHA1"/> </checksum>
			</file>
		</resource>
    </xsl:for-each>
	

</contentMetadata>

</xsl:template>

</xsl:stylesheet>