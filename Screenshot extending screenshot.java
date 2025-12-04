
package runner;

import java.net.MalformedURLException;
import java.net.URL;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.events.EventFiringDecorator;
import org.openqa.selenium.support.events.WebDriverListener;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import org.testng.annotations.AfterMethod;
import utils.EventHandler;
import utils.Screenshot;

public class TestRunner {
    public static WebDriver driver;
    public static Screenshot screenshot;

    @BeforeMethod
    public void openBrowser() throws MalformedURLException {
        ChromeOptions options = new ChromeOptions();
        driver = new RemoteWebDriver(new URL("http://localhost:4444/"), options);
       
        WebDriverListener listener = new EventHandler();
        driver = new EventFiringDecorator<>(listener).decorate(driver);
        driver.manage().window().maximize();
        driver.get("https://demo.broadleafcommerce.org/");
    }

    @Test
    public void screenshot()
    {
        try {
            driver.findElement(By.xpath("//input[@type='search']")).sendKeys("shirt");
            driver.findElement(By.xpath("(//a[@href='/hot-sauces'])[2]")).click();
            screenshot.getScreenShot(driver, "screenshot");

        } catch (Exception e) {
            // TODO: handle exception
            e.getMessage();
        }
    }

    @AfterMethod
    public void closeBrowser() {
        if (driver != null) {
            driver.quit();
        }
    }
}
