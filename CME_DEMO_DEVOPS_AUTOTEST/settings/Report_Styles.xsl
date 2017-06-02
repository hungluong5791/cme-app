<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body style="font-family:Calibri,sans-serif;">
	<div id="header">TEST SUMMARY</div>
	<br style="line-height: 5px;"/>
	<table border="1" cellpadding="3" style="border-collapse: collapse;table-layout:fixed;min-width: 700px;">
	  <tr bgcolor="#1d88c2" style="color:white;font-weight: bold;">
		<td>Start Time</td>
		<td>End Time</td>
		<td>Duration</td>
		<td># Pass Tests</td>
		<td># Failed Tests</td>
		<td>Total Tests</td>
      </tr>
	  <tr style="text-align: center;">
		<td><xsl:value-of select="TestResult/Summary/StartTime" /></td>
		<td><xsl:value-of select="TestResult/Summary/EndTime" /></td>
		<td><xsl:value-of select="TestResult/Summary/Duration" /></td>
		<td style="color:green;font-weight:bold;"><xsl:value-of select="count(TestResult/TestScenario[@Result = 'Pass'])"/></td>
		<td style="color:red;font-weight:bold;"><xsl:value-of select="count(TestResult/TestScenario[@Result = 'Failed'])"/></td>
		<td style="font-weight:bold;"><xsl:value-of select="count(TestResult/TestScenario)"/></td>
      </tr>
	</table>
	
	<br style="line-height: 5px;"/>
	
	<table border="1" cellpadding="2" style="border-collapse: collapse;table-layout:fixed;min-width: 700px;">
	<tr bgcolor="#1d88c2" style="color:white;">
	  <th style="text-align:center">#</th>
	  <th style="text-align:left">Test Name</th>
	  <th style="text-align:left">Steps</th>
	  <th style="text-align:left">Status</th>
	  <th style="text-align:left">Folder stores files created by Script</th>	  
	</tr>
	<xsl:for-each select="TestResult/TestScenario">
	<tr>
	  <td style="text-align:right"><xsl:value-of select="position()" /></td>
	  <td><a href="#{position()}"><xsl:value-of select="./@Title" /></a></td>
	  <td align="right"><xsl:value-of select="./@NStep" /></td>

	  <xsl:choose>
		<xsl:when test="@Result='Pass'">
	  
	  <td style="color:green;font-weight:bold;">
		<xsl:value-of select="./@Result" />
	  </td>
	  
		</xsl:when>
		<xsl:otherwise>
		
	  <td style="color:red;font-weight:bold;">
		<xsl:value-of select="./@Result" />
	  </td>
		
		</xsl:otherwise>
	  </xsl:choose>
	  
	  <td><a href="{@FolderHyperlink}"><xsl:value-of select="./@FolderData" /></a></td>
	</tr>
	</xsl:for-each>
	</table>
	
	<br />
	
	<div id="header">DETAIL TEST RESULT</div>
	<br style="line-height: 5px;"/>
	
	<table border="1" cellpadding="2" style="border-collapse: collapse;table-layout:fixed;">
	<tr bgcolor="#1d88c2" style="color:white;">
	  <th style="text-align:left"> </th>
	  <th style="text-align:left">Step / Action Name</th>
	  <th style="text-align:left">Status</th>
	  <th style="text-align:left">SnapShot</th>
	  <th style="text-align:left">Error Messages / Comments</th>
	</tr>
	<xsl:for-each select="TestResult/TestScenario">
	<tr bgcolor="#215967" style="color:white;font-weight:bold;">
	  <td colspan="4"><a name="{position()}"></a><xsl:value-of select="./@Title" /></td>
	  <td style="text-align:right;border-left: 1px solid #215967"><a href="#" style="color:white;">^Top^</a></td>
	</tr>
		<xsl:for-each select="Keyword">
		
	<tr style="border:0px;">
	  <td style="width:20px;border:0px;"></td>
	  <td colspan="4" bgcolor="#d8e4bc" style="color:#215967;font-weight:bold;font-size:14px;"><xsl:value-of select="./@Description" /></td>
	</tr>
			<xsl:for-each select="Step">

	<tr>
	  <td style="border-top: 1px solid white;border-bottom: 1px solid white;"></td>
	  <td style="padding-left: 10px;"><xsl:value-of select="./@Description" /></td>

	  <xsl:choose>
		<xsl:when test=".='Pass'">
	  <td style="color:green;"><xsl:value-of select="." /></td>
		</xsl:when>
		<xsl:otherwise>
	  <td style="color:red;"><xsl:value-of select="." /></td>
		</xsl:otherwise>
	  </xsl:choose>

	  <td><a href="{@SnapShotHyperlink}"><xsl:value-of select="./@SnapShotName" /></a></td>

	  <xsl:choose>
		<xsl:when test=".='Pass'">
	  <td style="color:green;"><xsl:value-of select="./@ErrMsg" /></td>
		</xsl:when>
		<xsl:otherwise>
	  <td style="color:red;"><xsl:value-of select="./@ErrMsg" /></td>
		</xsl:otherwise>
	  </xsl:choose>
	  
	</tr>

			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	</table>
  
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
