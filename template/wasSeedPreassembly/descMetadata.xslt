<?xml version="1.0" encoding="UTF-8"?>
<!--Transforming Generic output of Seed Registration to MODS for descMetadata -->
<!-- Author: Naomi Dushay -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/item">
      <xsl:for-each select=".">
         <mods xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns="http://www.loc.gov/mods/v3"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
             <typeOfResource>text</typeOfResource>
             <genre authority="local">archived website</genre>
             <titleInfo>
                 <title>Web Archive Seed for <xsl:value-of select="uri"/></title>
             </titleInfo>
             <note displayLabel="Original site"><xsl:value-of select="uri"/></note>
             <physicalDescription>
                 <form authority="marcform">electronic</form>
                 <internetMediaType>text/html</internetMediaType>
                 <digitalOrigin>born digital</digitalOrigin>
             </physicalDescription>
             <location>
                 <url displayLabel="Archived website">https://swap.stanford.edu/*/<xsl:value-of select="uri"/></url>
             </location>
             <recordInfo>
                 <languageOfCataloging>
                     <languageTerm type="code" authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" valueURI="http://id.loc.gov/vocabulary/iso639-2/eng">eng</languageTerm>
                 </languageOfCataloging>
                 <recordContentSource authority="marcorg">CSt</recordContentSource>
                 <recordOrigin>Transformed from record for <xsl:value-of select="uri"/> used in the web archiving service and which is part of the collection (record ID <xsl:value-of select="collection_id"/>).</recordOrigin>
             </recordInfo>
        </mods>
      </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
