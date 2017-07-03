<?php

namespace Acquia\govCMSExtension\Context;

use Behat\Mink\Driver\Selenium2Driver;
use Behat\Mink\Element\ElementInterface;
use Behat\Mink\Exception\ExpectationException;
use Drupal\DrupalExtension\Context\DrupalSubContextBase;
use WebDriver\Exception\NoAlertOpenError;

/**
 * A context with miscellaneous helpers.
 */
class UtilityContext extends DrupalSubContextBase {

  /**
   * Asserts that a form field is not present.
   *
   * @param string $field
   *   The field locator.
   *
   * @Then I should not see a :field field
   */
  public function assertFieldNotExists($field) {
    $this->assertSession()->fieldNotExists($field);
  }

  /**
   * Asserts that a certain number of elements match a CSS selector.
   *
   * @param string $selector
   *   The selector.
   * @param int $count
   *   The number of elements expected to match the selector.
   *
   * @throws ExpectationException
   *   If the number of elements that match the selector is not the expected
   *   number.
   *
   * @Then :count element(s) should match :selector
   */
  public function assertSelectorMatch($selector, $count) {
    $session = $this->getSession();

    $result = count($session->getPage()->findAll('css', $selector));

    if ($result != $count) {
      throw new ExpectationException(
        '"' . $selector . '" matched ' . $result . ' element(s), expected ' . $count . '.',
        $session->getDriver()
      );
    }
  }

  /**
   * Asserts that a minimum number of elements match a CSS selector.
   *
   * @param string $selector
   *   The selector.
   * @param int $count
   *   The number of elements expected to match the selector.
   *
   * @throws ExpectationException
   *   If the number of elements that match the selector is less than expected.
   *
   * @Then at least :count element(s) should match :selector
   */
  public function assertSelectorMatchAtLeast($selector, $count) {
    $session = $this->getSession();

    $result = count($session->getPage()->findAll('css', $selector));

    if ($result < $count) {
      throw new ExpectationException(
        '"' . $selector . '" matched ' . $result . ' element(s), expected at least ' . $count . '.',
        $session->getDriver()
      );
    }
  }

  /**
   * Asserts that no elements match a CSS selector.
   *
   * @param string $selector
   *   The selector.
   *
   * @Then no elements should match :selector
   * @Then nothing should match :selector
   */
  public function assertSelectorMatchNothing($selector) {
    $this->assertSelectorMatch($selector, 0);
  }

  /**
   * Asserts than an element is empty.
   *
   * @param string $selector
   *   The element's CSS selector.
   *
   * @throws ExpectationException
   *   If the element has any HTML content.
   *
   * @Then the :selector element(s) should be empty
   */
  public function assertElementIsEmpty($selector) {
    $content = $this->assertSession()->elementExists('css', $selector)->getHtml();

    if (trim($content)) {
      throw new ExpectationException(
        'Expected ' . $selector . ' to be empty but it is not.',
        $this->getSession()->getDriver()
      );
    }
  }

  /**
   * Clears a field.
   *
   * @param string $field
   *   The field to clear.
   * @param ElementInterface $container
   *   (optional) The containing element.
   *
   * @When I clear :field
   */
  public function clearField($field, ElementInterface $container = NULL) {
    $this->assertSession()->fieldExists($field, $container)->setValue(FALSE);
  }

  /**
   * Finds a collapsible details element by its summary text.
   *
   * @param string $summary_text
   *   The summary text.
   *
   * @return \Behat\Mink\Element\NodeElement|null
   *   The details element, or NULL if it was not found.
   */
  public function findCollapsible($summary_text) {
    /** @var \Behat\Mink\Element\NodeElement[] $elements */
    $elements = $this
      ->getSession()
      ->getPage()
      ->findAll('css', 'details > summary');

    foreach ($elements as $element) {
      if ($element->getText() == $summary_text) {
        return $element->getParent();
      }
    }
  }

  /**
   * Accepts any currently open alert box(es), then optionally runs a callback.
   *
   * @param callable $then
   *   (optional) A function to run after accepting the alerts.
   * @param mixed[] $arguments
   *   (optional) Arguments for the callback.
   *
   * @When I accept the alert(s)
   */
  public function acceptAlerts(callable $then = NULL, array $arguments = []) {
    $driver = $this->getSession()->getDriver();

    if ($driver instanceof Selenium2Driver) {
      while (TRUE) {
        try {
          $driver->getWebDriverSession()->accept_alert();
        }
        catch (NoAlertOpenError $e) {
          break;
        }
      }
    }

    if ($then) {
      call_user_func_array($then, $arguments);
    }
  }

}