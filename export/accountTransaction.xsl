<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ish="http://www.ish.com.au/schema/2009/onCourseTransform"
                xsi:schemaLocation="http://www.ish.com.au/schema/2009/onCourseTransform http://www.ish.com.au/schema/2009/onCourseTransform.xsd"
                exclude-result-prefixes="xsi ish" version="2.0"
                xpath-default-namespace="http://www.ish.com.au/schema/4/onCourseData">
	<xsl:output method="text" encoding="UTF-8" indent="no" />

	<ish:onCourse>
		<ish:name>CSV</ish:name>
		<ish:entity>AccountTransaction</ish:entity>
		<ish:version>6</ish:version>
		<ish:keyCode>ish.onCourse.accountTransactionCsv</ish:keyCode>
	</ish:onCourse>

	<xsl:param name="delim" select="','" />
	<xsl:param name="quote" select="'&quot;'" />
	<xsl:param name="doublequote" select="'&quot;&quot;'" />
	<xsl:param name="break" select="'&#xA;'" />
	
	<xsl:template match="*">
		<xsl:value-of select="concat($quote, replace(normalize-space(), $quote, $doublequote), $quote)" />
		<xsl:if test="following-sibling::*">
			<xsl:value-of select="$delim" />
		</xsl:if>
	</xsl:template>
	
	<xsl:function name="ish:outputValue">
		<xsl:param name="value" as="xs:string?"/>
		<xsl:value-of select="ish:outputValue($value, false())" />
	</xsl:function>
	
	<xsl:function name="ish:outputValue">
		<xsl:param name="value" as="xs:string?"/>
		<xsl:param name="endOfLine" as="xs:boolean"/>
		<xsl:value-of select="concat($quote, replace(normalize-space($value), $quote, $doublequote), $quote)" />
		<xsl:if test="not($endOfLine)">
			<xsl:value-of select="$delim" />
		</xsl:if>
	</xsl:function>
	
	<xsl:template match="data">
		<xsl:text>Transaction date, Account code, Account description, Account type, Amount, Source, Invoice number, Payment type, Contact name, id</xsl:text>
				<xsl:value-of select="$break" />
		<xsl:apply-templates select="accountTransaction" />
	</xsl:template>
	
	<xsl:template match="accountTransaction">
		<xsl:value-of select="ish:outputValue(format-dateTime(transactionDate, '[D]-[M]-[Y] [H01]:[m01]:[s01]'))"/>
		<xsl:apply-templates select="account"/>
		<xsl:value-of select="ish:outputValue(amount)"/>
		<xsl:value-of select="ish:outputValue(source)"/>
		<xsl:value-of select="ish:outputValue(invoiceNumber)"/>
		<xsl:value-of select="ish:outputValue(paymentType)"/>
		<xsl:value-of select="ish:outputValue(contactName)"/>
		<xsl:value-of select="ish:outputValue(id, true())"/>
		<xsl:if test="following-sibling::*">
			<xsl:value-of select="$break" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="account">
		<xsl:variable name="accountID" select="@id"/>
		<xsl:value-of select="ish:outputValue(/data/account[@id = $accountID]/accountCode)"/>
		<xsl:value-of select="ish:outputValue(/data/account[@id = $accountID]/description)"/>
		<xsl:value-of select="ish:outputValue(/data/account[@id = $accountID]/type)"/>
	</xsl:template>
	
</xsl:stylesheet>