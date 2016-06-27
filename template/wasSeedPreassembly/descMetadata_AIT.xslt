<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs" version="2.0">

    <!--Transforming Archive-It metada to MODS-->
    <!--
        Author: Robert J. Rohrbacher
        Created: 10/15/2014
        Updated: 12/3/2014
        -->

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/item">
 		<xsl:for-each select="source_xml/seed">
 			<mods xmlns:xlink="http://www.w3.org/1999/xlink"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns="http://www.loc.gov/mods/v3"
                    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
                    <typeOfResource>text</typeOfResource>
                    <genre authority="local">archived website</genre>
                    <titleInfo>
                        <title>
                            <xsl:value-of select="metadata/title"/>
                        </title>
                    </titleInfo>
                    <!--Mostly corporate names, but there are personal names as well with no coding in the original metadata to indicate which type a name is-->
                    <xsl:for-each select="metadata/creator">
                        <name type="corporate" usage="primary">
                            <namePart>
                                <xsl:value-of select="."/>
                            </namePart>
                            <role>
                                <roleTerm type="code" authority="marcrelator">cre</roleTerm>
                                <roleTerm type="text" authority="marcrelator"
                                    valueURI="http://id.loc.gov/vocabulary/relators/cre"
                                    >Creator</roleTerm>
                            </role>
                        </name>
                    </xsl:for-each>
                    <!--Mostly corporate names, but there are personal names as well with no coding in the original metadata to indicate which type a name is-->
                    <xsl:for-each select="metadata/contributor">
                        <name type="corporate">
                            <namePart>
                                <xsl:value-of select="."/>
                            </namePart>
                            <role>
                                <roleTerm type="code" authority="marcrelator">ctb</roleTerm>
                                <roleTerm type="text" authority="marcrelator"
                                    valueURI="http://id.loc.gov/vocabulary/relators/ctb"
                                    >Contributor</roleTerm>
                            </role>
                        </name>
                    </xsl:for-each>
                    <name type="corporate">
                        <namePart>
                            <xsl:value-of select="metadata/collector"/>
                        </namePart>
                        <role>
                            <roleTerm type="text" authority="marcrelator"
                                valueURI="http://id.loc.gov/vocabulary/relators/col"
                                >Collector</roleTerm>
                        </role>
                    </name>
                    <note>Archived by <xsl:value-of select="metadata/collector"/>.</note>
                    <note displayLabel="Web archiving service">Archive-It</note>
                    <note type="system details" displayLabel="Original site">
                        <xsl:value-of select="url"/>
                    </note>
                    <xsl:for-each select="metadata/language">
                        <language>
                            <languageTerm authority="iso639-2b" type="code">
                                <xsl:value-of select="."/>
                            </languageTerm>
                        </language>
                    </xsl:for-each>
                    <physicalDescription>
                        <form authority="marcform">electronic</form>
                        <internetMediaType>text/html</internetMediaType>
                        <digitalOrigin>born digital</digitalOrigin>
                    </physicalDescription>
                    <abstract displayLabel="Description">
                        <xsl:value-of select="metadata/description"/>
                    </abstract>
                    <originInfo>
                        <publisher displayLabel="Publisher">
                            <xsl:value-of select="metadata/publisher"/>
                        </publisher>
                    </originInfo>
                    <xsl:for-each select="metadata/subject">
                        <subject>
                            <topic>
                                <xsl:value-of select="."/>
                            </topic>
                        </subject>
                    </xsl:for-each>
                    <location displayLabel="Archived site">
                        <url>https://swap.stanford.edu/*/<xsl:value-of select="url"/></url>
                    </location> 
                    <recordInfo>
                        <languageOfCataloging>
                            <languageTerm authority="iso639-2b" type="code">eng</languageTerm>
                        </languageOfCataloging>
                        <recordContentSource authority="marcorg">CSt</recordContentSource>
                        <recordOrigin>Transformed from record for <xsl:value-of select="url"/> used in the web archiving service Archive-It and which is part of the Fugitive US Agencies collection (record ID <xsl:value-of select="//id"/>).</recordOrigin>
                    </recordInfo>
                </mods>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
