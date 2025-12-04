package runner;

import java.io.IOException;
import java.net.MalformedURLException;

import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import pages.Testcase1;
import utils.Base;

public class TestSample extends Base{
    Testcase1 testcase1;
    WebDriver driver;
    @BeforeMethod
    public void open() throws Exception
    {
        driver=openBrowser();
        testcase1=new Testcase1(driver);

    }
    @Test
    public void display() throws IOException
    {
        testcase1.display();
    }
    @AfterMethod
    public void close()
    {
        if(driver!=null)
        {
            driver.quit();
        }
    }
}



package pages;

import java.io.IOException;

import org.openqa.selenium.WebDriver;

import uistore.locator;
import utils.Screenshot;
import utils.WebDriverHelper;

public class Testcase1 {
    WebDriverHelper webDriverHelper;
    WebDriver driver;
    public Testcase1(WebDriver driver)
    {
        this.driver=driver;
        webDriverHelper=new WebDriverHelper(driver);
    }
    public void display() throws IOException
    {
        webDriverHelper.clickOnElement(locator.blog);
        webDriverHelper.javascriptScroll(locator.roadmap);
        webDriverHelper.clickOnElement(locator.roadmap);
        Screenshot.getScreenShot(driver, "/screenshots");
    }
}



package uistore;

import org.openqa.selenium.By;

public class locator {
    public static final By blog=By.linkText("Blog");
    public static final By roadmap=By.linkText("Roadmap");
}
